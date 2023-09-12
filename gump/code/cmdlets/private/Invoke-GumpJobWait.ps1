using namespace System.Collections.Generic
using namespace System.Management.Automation.job
using namespace System.Management.Automation
function Invoke-GumpJobWait {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory, 
            ValueFromPipeline,
            ParameterSetName = 'job'
        )]
        [Job]$Job,

        [System.Drawing.KnownColor]$SpinColor = [System.Drawing.KnownColor]::MediumSpringGreen,
        [ValidateSet(
            'Information',
            'progress',
            'Warning',
            'Debug',
            'Verbose',
            'Error',
            'Output',
            "none"
        )]
        [string]$WriteJobInfo = 'Information',
        [switch]$DontClear
    )
    dynamicparam {
        #add dynamic param that has validateset of spinners.json
        $ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
        # $ParamAttrib.Mandatory = $true
        $ParamAttrib.ParameterSetName = '__AllParameterSets'

        $AttribColl = New-Object  System.Collections.ObjectModel.Collection[System.Attribute]
        $AttribColl.Add($ParamAttrib)
        $spinners = get-content "$psscriptroot\spinners.json" -raw | ConvertFrom-Json
        $SpinnerNames = $spinners.psobject.properties.name
        $AttribColl.Add((New-Object  System.Management.Automation.ValidateSetAttribute($SpinnerNames)))
        $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Spinner', [string], $AttribColl)
        $RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Spinner', $RuntimeParam)
        return  $RuntimeParamDic
    }
    
    begin {
        $spinner = $pscmdlet.MyInvocation.BoundParameters['Spinner']
        if(!$spinner){
            $spinner = 'dots'
        }
        $spinners = get-content "$psscriptroot\spinners.json" -raw | ConvertFrom-Json

        #frame handler
        $Frames = $spinners.$spinner.frames
        $Interval = $spinners.$spinner.interval


        $jobs = [List[Job]]::new()
        $verbose = $VerbosePreference -eq 'continue'
    }
    
    process {
        if($PSCmdlet.ParameterSetName -eq 'scriptblock'){
            $Job = Start-Job -ScriptBlock $ScriptBlock 
        }
        $jobs.Add($Job)

        if($Job.ChildJobs){
            $Job.ChildJobs|%{
                $jobs.Add($_)
            }
        }
    }
    
    end {
        $global:jobs = $jobs
        $jobsInfo = @{}
        New-GumpConsoleZone -name 'status' -Height 1 -Init

        #generate zones for each job
        $jobs|%{
            $jobsInfo.($_.id) = @{
                animate = $true
                frames = $Frames
                interval = $Interval
                animationframe = 0
            }
            New-GumpConsoleZone -name $_.Name -Height 1
        }

        #add verbose zone if verbose preference is continue
        if ($verbose) {
            New-GumpConsoleZone -name 'verbose' -Height 1 -StreamType 'verbose'
        }

        #init console
        Initialize-GumpConsoleZones

        $ColorSpin = Get-GumpAnsiSequence -ForegroundColor $SpinColor
        $reset = Get-GumpAnsiSequence
        
        try {
            Set-GumpConsoleModes -Modes DisableCursor
            do {

                #update status zone
                if($jobs.count -gt 1){
                    $Stats = $jobs |Group-Object state|Select-Object count,name
                    $statmsg = ($Stats|%{$_.name + ":" + $_.count}) -join ", "
                    Set-GumpConsoleZone -Name 'status' -content "Running jobs. total:$($jobs.count) -> $statmsg"
                }

                foreach($CurrentJob in $jobs){
                    $thisJobInfo = $jobsInfo[$CurrentJob.id]
                    $msg = ""
                    switch($CurrentJob.State) {
                        'Completed' {
                            $msg = "done"
                            $thisJobInfo.animate = $false
                            break
                        }
                        'Failed' {
                            $msg = "failed"
                            $thisJobInfo.animate = $false
                            break
                        }
                        'Stopped' {
                            $msg = "stopped"
                            break
                        }
                        'Running' {
                            $thisJobInfo.frames = $Frames
                            $thisJobInfo.interval = $Interval
                            $thisJobInfo.animate = $true
                            if($writejobinfo -ne 'none'){
                                $msg = $CurrentJob.$WriteJobInfo|Select-Object -last 1
                            }

                            if (!$msg) {
                                $msg = "working..."
                            }
                            break
                        }
                        'NotStarted' {
                            $msg = "waiting to start.."
                            $thisJobInfo.animate = $false
                            break
                        }
                    }

                    #update spinner
                    if ($thisJobInfo.animationframe -eq $thisJobInfo.frames.count) {
                        $thisJobInfo.animationframe = 0
                    }
                    $Frame = $thisJobInfo.frames[$thisJobInfo.animationframe]
                    $type = $CurrentJob.gettype().name -replace "PSRemoting"
                    Set-GumpConsoleZone -Name $CurrentJob.Name -content ("`t" + $ColorSpin + $Frame + $reset + "`t" + $msg)

                    if($thisJobInfo.animate){
                        $thisJobInfo.animationframe++
                    }
                }


                #update spinner
                # Set-GumpConsoleZone -Name 'spinner' -content ("`t" + $ColorSpin + $Frames[$FrameIndex] + $reset + "`t" + $msg)
                if ($verbose) {
                    Set-GumpConsoleZone -Name 'verbose' -content ("spinner: $spinner, job id: $($RunJob.Id), childjobs id: $($RunJob.ChildJobs.Id -join ",")")
                }
                Update-GumpConsole

                #wait
                #get max interval of jobsinfo
                $Interval = ($jobsInfo.Values|%{$_.interval}) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
                Start-Sleep -Milliseconds $Interval
            }while ($Jobs.count -gt 0 -and $Jobs.State -eq 'Running')
        }
        catch {
            throw $_
        }
        finally {
            #remove spinner
            if (!$DontClear) {
                $jobs|%{
                    Set-GumpConsoleZone -Name $_.name -content ""
                }
            }
            if ($verbose) {
                Set-GumpConsoleZone -Name 'verbose' -content ""
            }
            Update-GumpConsole
            #remove cursor
            Set-GumpConsoleModes -Modes EnableCursor
            #remove job
            if ($RunJob) {
                $RunJob | Remove-Job
            }
        }
    }
}

