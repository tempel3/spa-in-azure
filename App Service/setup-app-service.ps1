Write-Host "Install Azure CLI first"

$Settings = Get-Content -Raw -Path settings.json | ConvertFrom-Json

az group create --name $Settings.ResourceGroupName --location westeurope

az appservice plan create --sku S1 --tags="os=windows project=spa technology=appservice" --name $Settings.AppServicePlanName -g $Settings.ResourceGroupName

az webapp create --name $Settings.AppServiceName -g $Settings.ResourceGroupName  --plan $Settings.AppServicePlanName#  --runtime='"DOTNETCORE|3.1"' # Auf das Escaping der Pipe achten!

az webapp deployment slot create --name $Settings.AppServiceName -g $Settings.ResourceGroupName --slot blue
az webapp deployment slot create --name $Settings.AppServiceName -g $Settings.ResourceGroupName --slot test
az webapp deployment slot create --name $Settings.AppServiceName -g $Settings.ResourceGroupName --slot dev

#az webapp config set -n $Settings.AppServiceName -g $Settings.ResourceGroupName --settings '"runtime=DOTNETCORE|3.1"'
#az webapp config appsettings set -n $Settings.AppServiceName -g $Settings.ResourceGroupName --settings '"runtime=DOTNETCORE|3.1"'

# $FtpAddress = az webapp show -n $Settings.AppServiceName --query "{url: ftpPublishingUrl}" | ConvertFrom-Json
# $FtpCredentials = az webapp deployment list-publishing-credentials -n $Settings.AppServiceName --query '{name:name, publishingUserName:publishingUserName, publishingPassword:publishingPassword}' | ConvertFrom-Json

# $BuildDirectory = "Kaziya.SPA.AppService.Sidecar\bin\Release\netcoreapp3.1\*"
$DistributeableZipPath = "dist/deploy.zip"

dotnet publish .\Kaziya.SPA.AppService.Sidecar\ -o dist\files -c Release --self-contained false
Compress-Archive -Path dist\files\* -DestinationPath $DistributeableZipPath -Force

# Subfolder are ignored on linux !!!!! >:-(
az webapp browse --name $Settings.AppServiceName -g $Settings.ResourceGroupName
az webapp deployment source config-zip --name $Settings.AppServiceName -g $Settings.ResourceGroupName --src $DistributeableZipPath --slot dev

az webapp deployment slot swap  -name $Settings.AppServiceName -g $Settings.ResourceGroupName --slot dev --target-slot production

az webapp browse --name $Settings.AppServiceName -g $Settings.ResourceGroupName
