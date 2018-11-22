$nuGetPath = "C:\Chocolatey\bin\nuget.bat"
$msBuildPath = "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"

& $nuGetPath restore .\ThinkFinanceNuGet.Server.sln

& $msBuildPath .\ThinkFinanceNuGet.Server.sln `
    /p:OutputPath=c:\build\out\web\ThinkFinanceNuGet.Server `
    /p:DeployOnBuild=true `
    /p:VSToolsPath='C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v14.0'
