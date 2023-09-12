
# modified from example i wrote for microsoft
# https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/write-progress-across-multiple-threads?view=powershell-7.3

$dataset = @(
    @{
        Id   = 1
        Wait = 3..10 | get-random | Foreach-Object {$_*100}
    }
    @{
        Id   = 2
        Wait = 3..10 | get-random | Foreach-Object {$_*100}
    }
    @{
        Id   = 3
        Wait = 3..10 | get-random | Foreach-Object {$_*100}
    }
    @{
        Id   = 4
        Wait = 3..10 | get-random | Foreach-Object {$_*100}
    }
    @{
        Id   = 5
        Wait = 3..10 | get-random | Foreach-Object {$_*100}
    }
)

$job = $dataset | Foreach-Object -ThrottleLimit 3 -AsJob -Parallel {
    $process = @{}
    $process.Id = $PSItem.Id
    $process.Activity = "Id $($PSItem.Id) starting"
    $process.Status = "Processing"
    $record = [System.Management.Automation.ProgressRecord]::new($process.Id, $process.Activity, $process.Status)
    $record.RecordType = [System.Management.Automation.ProgressRecordType]::Processing
    $PSCmdlet.WriteProgress($record)
    # Write-progress @process
    # Fake workload start up that takes x amount of time to complete
    start-sleep -Milliseconds ($PSItem.wait*5)

    # Process. update activity
    $process.Activity = "Id $($PSItem.id) processing"
    foreach ($percent in 1..100)
    {
        # Update process on status
        $record.Status = "Handling $percent/100"
        Write-host $record.Status
        $record.PercentComplete = (($percent / 100) * 100)
        $PSCmdlet.WriteProgress($record)
        # Write-progress @process
        # Fake workload that takes x amount of time to complete
        Start-Sleep -Milliseconds $PSItem.Wait
    }

    # Mark process as completed
    $record.RecordType  = [System.Management.Automation.ProgressRecordType]::Completed 
    $PSCmdlet.WriteProgress($record)
}

while ($job.State -eq 'Running')
{
    #read childjob progress

    $job.ChildJobs|%{
        # $_.State
        if ($_.Progress)
        {
            Write-host $_.Progress
        }
    }
    # $job | Receive-Job -Wait -AutoRemoveJob
    Start-Sleep -Milliseconds 100
}
# $job|Invoke-GumpSpin -WriteJobInfo Information -Spinner 'dots'