#https://www.davepaquette.com/archive/2020/05/10/deploying-a-static-site-to-azure-using-the-az-cli.aspx

$Settings = Get-Content -Raw -Path settings.json | ConvertFrom-Json

az group create --name $Settings.ResourceGroupName --location germanywestcentral
#az configure --defaults group=$Settings.ResourceGroupName location=germanywestcentral

az storage account create --name $Settings.StorageAccountName -g $Settings.ResourceGroupName --sku Standard_LRS --kind StorageV2 --access-tier Hot
az storage blob service-properties update --account-name $Settings.StorageAccountName --static-website --404-document index.html --index-document index.html

az storage blob upload-batch --account-name $Settings.StorageAccountName --source ./spa --destination '$web'

$Url = az storage account show --name $Settings.StorageAccountName --resource-group $Settings.ResourceGroupName --query "primaryEndpoints.web" | ConvertFrom-Json

explorer $Url

#npm i
#ng build --prod



#az group delete --name $Settings.ResourceGroupName -y
