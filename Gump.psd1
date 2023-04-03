@{
    ModuleVersion = '0.0.1'
    RootModule = 'Gump.psm1'
    FunctionsToExport = @("*")
    CmdletsToExport = @("*")
    AliasesToExport = @()
    VariablesToExport = @()
    NestedModules = @()
    RequiredModules = @()
    RequiredAssemblies = @()
    PrivateData = @{
    }
    ScriptsToProcess = @(
        ".\code\helpers\private\gump.class.ps1"
    )

}