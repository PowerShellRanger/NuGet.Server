configuration BuildAgentConfig
{    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName PackageManagement -ModuleVersion 1.1.7.2
      
    Node localhost 
    {
        $packageProviders = @(
            @{
                Name           = 'Nuget'                
                SourceLocation = 'https://www.nuget.org/api/v2'
            },
            @{
                Name           = 'Chocolatey'
                SourceLocation = 'http://chocolatey.org/api/v2/'
            }
        )
        
        $packages = @(
            @{
                Name    = 'microsoft-build-tools'
                Version = '14.0.25420.1'                
            },
            @{
                Name    = 'netfx-4.6.1-devpack'
                Version = '4.6.01055.00'
            },
            @{
                Name    = 'webdeploy'
                Version = '3.6.20170627'                
            },
            @{
                Name    = 'nuget.commandline'
                Version = '4.8.1'
            },
            @{
                Name    = 'MSBuild.Microsoft.VisualStudio.Web.targets'
                Version = '14.0.0.3'
            }            
        )

        foreach ($packageProviderName in $packageProviders)
        {
            PackageManagementSource "$($packageProviderName['Name'])_PackageProvider"
            {
                Ensure             = 'Present'
                Name               = $packageProviderName['Name']
                ProviderName       = $packageProviderName['Name']
                SourceLocation     = $packageProviderName['SourceLocation']
                InstallationPolicy = 'Trusted'
            }
        }        

        foreach ($packageName in $packages)
        {
            PackageManagement "$($packageName['Name'])_Package"
            {
                Ensure          = 'Present'
                Name            = $packageName['Name']
                RequiredVersion = $packageName['Version']
            }
        }
                
        File 'MSBuild.Microsoft.VisualStudio.Web.targets_Copy'
        {
            Type            = 'Directory'
            SourcePath      = 'C:\Program Files\PackageManagement\NuGet\Packages\MSBuild.Microsoft.VisualStudio.Web.targets.14.0.0.3\tools\VSToolsPath\'
            DestinationPath = 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v14.0\'
            Ensure          = 'Present'
            Recurse         = $true 
            DependsOn       = "[PackageManagement]MSBuild.Microsoft.VisualStudio.Web.targets_package"
        }

        Environment 'MSBuild_AddToPath'
        {
            Ensure    = 'Present'
            Name      = 'Path'
            Value     = 'C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild.exe'
            Path      = $true
            DependsOn = "[PackageManagement]microsoft-build-tools_package"
        }
    }
}

BuildAgentConfig -OutputPath .\BuildAgentConfig
Start-DscConfiguration -Wait -Verbose -Path .\BuildAgentConfig -Force