configuration WebServerConfig
{      
    Import-DscResource -ModuleName xWebAdministration
      
    Node localhost 
    {
        WindowsFeature 'IIS_Install'
        {
            Ensure = 'Present'
            Name   = 'Web-Server'
        }

        xWebSite 'RemoveDefaultWebSite'
        {
            Name         = 'Default Web Site'
            Ensure       = 'Absent'
            PhysicalPath = 'C:\inetpub\wwwroot'
            DependsOn    = '[WindowsFeature]IIS_Install'
        }
        
        File 'NuGetSite_Directory'
        {
            Type            = 'Directory'
            DestinationPath = 'C:\www\sites\nuget'
            Ensure          = 'Present'
            DependsOn       = '[xWebSite]RemoveDefaultWebsite'
        }

        xWebAppPool 'NuGet_AppPool'
        {
            Name      = 'NuGetAppPool'
            DependsOn = '[File]NuGetSite_Directory'
        }

        xWebSite 'NuGet_Site'
        {
            Name            = 'NuGet'
            Bindinginfo     = @(
                MSFT_xWebBindingInformation
                {
                    Protocol = 'HTTP'
                    Port     = 80
                }
            )
            PhysicalPath    = 'C:\www\sites\nuget'
            ApplicationPool = 'NuGetAppPool'
            DependsOn       = '[xWebAppPool]NuGet_AppPool'
        }

        Registry 'ServerPriorityTimeList'
        {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters'
            ValueName = 'ServerPriorityTimeLimit'
            ValueData = 0
            ValueType = 'Dword'
        }
    }
}

WebServerConfig -OutputPath .\WebServerConfig
Start-DscConfiguration -Wait -Verbose -Path .\WebServerConfig -Force