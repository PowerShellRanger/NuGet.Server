# escape=`
FROM microsoft/windowsservercore:latest

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD buildagentconfig.ps1 buildagentconfig.ps1

RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; `
    Install-Module -Name PackageManagement -RequiredVersion 1.1.7.2 -Force -Verbose

RUN powershell.exe .\buildagentconfig.ps1

ENTRYPOINT ["powershell"]