FROM thinkfinancedev.azurecr.io/msbuild:20181019.02

SHELL ["powershell"]

COPY . 'C:\\build\\'
WORKDIR 'C:\\build\\'

RUN powershell.exe .\docker\publish\msbuildproject.ps1

## Usage: build image, then create container and copy out the bin directory.

ENTRYPOINT ["powershell"]