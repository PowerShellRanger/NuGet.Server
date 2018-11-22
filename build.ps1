
if (Test-Path -Path .\ThinkFinanceNuGet.Server\_PublishedWebsites)
{
    Remove-Item -Path .\ThinkFinanceNuGet.Server\_PublishedWebsites -Recurse
}
#use if building local and want to rebuild msbuild iamge
#docker build --file .\docker\builder\Dockerfile --tag msbuild .\docker\builder

docker build --file .\docker\publish\Dockerfile --tag nugetserver-publish .

docker container create --name nugetserver-publish-1 nugetserver-publish
docker container cp nugetserver-publish-1:C:\\build\\out\\web\\ThinkFinanceNuGet.Server\\_PublishedWebsites .\\ThinkFinanceNuGet.Server\\_PublishedWebsites
docker container rm nugetserver-publish-1

docker image rm nugetserver-publish

docker build --file .\docker\web\Dockerfile --tag travisallen/thinkfinancenuget.server .

#docker container run -it -p 80:80 --name nuget travisallen/thinkfinancenuget.server powershell