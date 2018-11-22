# escape=`
FROM microsoft/aspnet:4.7.2

#ENTRYPOINT ["powershell"]

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD .\docker\web\webserverconfig.ps1 webserverconfig.ps1

RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; `
    Install-Module -Name xWebAdministration -Force -Verbose

RUN powershell.exe .\webserverconfig.ps1

EXPOSE 80

COPY ThinkFinanceNuGet.Server/_PublishedWebsites/ThinkFinanceNuGet.Server /www/sites/nuget/
