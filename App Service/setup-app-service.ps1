Write-Host "Install Azure CLI first"

$AppServicePlanName = "deploy-spa-app-service-linux"
$AppServiceName = "deploy-spa-app-service-linux"
$ResourceGroup = "deploy-spa-app-service"

az group create --name $ResourceGroup --location germanywestcentral
az configure --defaults group=$ResourceGroup location=germanywestcentral

az appservice plan create --is-linux --sku S1 --tags="os=linux project=spa technology=appservice" --name $AppServicePlanName

# Get Runtimes with:
# az webapp list-runtimes --linux

az webapp create --name $AppServiceName --plan $AppServicePlanName --runtime '"DOTNETCORE|3.1"' # Auf das Escaping der Pipe achten!

az webapp browse --name $AppServiceName

$FtpAddress = az webapp show -n $AppServiceName --query "{url: ftpPublishingUrl}" | ConvertFrom-Json
$FtpCredentials = az webapp deployment list-publishing-credentials -n $AppServiceName --query '{name:name, publishingUserName:publishingUserName, publishingPassword:publishingPassword}' | ConvertFrom-Json

$BuildDirectory = "Kaziya.SPA.AppService.Sidecar\bin\Release\netcoreapp3.1\*"
$DistributeableZipPath = "dist/deploy.zip"

dotnet publish .\Kaziya.SPA.AppService.Sidecar\ -o dist\files -c Release --self-contained false
Compress-Archive -Path dist\files\* -DestinationPath $DistributeableZipPath -Force

# nur ein test, hat bisher nichts gebracht
#az webapp config appsettings set --name $AppServiceName --settings WEBSITE_RUN_FROM_PACKAGE="0"

# Subfolder are ignored!!!!! >:-(
az webapp deployment source config-zip --name $AppServiceName --src $DistributeableZipPath


# TODO upload certificate, example script
#https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-certificate#create-a-free-certificate-preview

#curl -X POST -u <user> --data-binary $DistributeableZipPath https://deploy-spa-app-service-linux.scm.azurewebsites.net/api/zipdeploy
#curl -X POST -u <user> --data-binary $DistributeableZipPath https://deploy-spa-app-service-linux.scm.azurewebsites.net/api/zipdeploy
#Invoke-RestMethod -Uri "https://deploy-spa-app-service-linux.scm.azurewebsites.net/api/zipdeploy" -Method Post -InFile $DistributeableZipPath -UseDefaultCredentials



$username = 'SpaDeploymentUser123'
$password = 'SpaDeploymentUser123!'
#$zipfile = "$home\Desktop\publish.zip"
$apiUrl = "https://deploy-spa-app-service-linux.scm.azurewebsites.net/api/zipdeploy"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$userAgent = "powershell/1.0"


Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -UserAgent $userAgent -Method POST -InFile $DistributeableZipPath -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop

#curl -X POST -u SpaDeploymentUser123:SpaDeploymentUser123! --data-binary deploy.zip https://deploy-spa-app-service-linux.scm.azurewebsites.net/api/zipdeploy

# UploadFolder -url $FtpAddress.url -username "$($FtpCredentials.name)\$($FtpCredentials.publishingUserName)" -password $FtpCredentials.publishingPassword -source $BuildDirectory

#az aks create --resource-group $ResourceGroup --name $ClusterName --node-count 1 --node-vm-size Standard_B2s
#az aks update --resource-group $ResourceGroup --name $ClusterName --attach-acr  "/subscriptions/b404fc03-8dcd-4078-949b-497702ba66bc/resourceGroups/deploy-spa/providers/Microsoft.ContainerRegistry/registries/spadeploymentcontainerregistry"

# az aks get-credentials --resource-group $ResourceGroup --name $ClusterName

# az aks enable-addons --resource-group $ResourceGroup --name $ClusterName --addons http_application_routing


# # https://docs.microsoft.com/de-de/azure/aks/ingress-basic
# # Create a namespace for your ingress resources
# #kubectl create namespace ingress-basic

# # Add the official stable repository
# #helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# # Use Helm to deploy an NGINX ingress controller
# #helm install nginx-ingress stable/nginx-ingress --namespace ingress-basic --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux


# function UploadFolder($url, $username, $password, $source)
# {
#     Write-Host $username $password

#     Set-Location $source
#     $webclient = New-Object -TypeName System.Net.WebClient
#     $webclient.Credentials = New-Object System.Net.NetworkCredential($username, $password)
#     $files = Get-ChildItem -Path "." -Recurse | Where-Object{!($_.PSIsContainer)}
#     foreach ($file in $files)
#     {
#         $relativepath = (Resolve-Path -Path $file.FullName -Relative).Replace(".\", "").Replace('\', '/')
#         $uri = New-Object System.Uri("$url/$relativepath")
#         Write-Host "Uploading to " $uri.AbsoluteUri
#         $webclient.UploadFile($uri, $file.FullName)
#     } 
#     $webclient.Dispose()
# }