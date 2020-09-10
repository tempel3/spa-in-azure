#https://www.davepaquette.com/archive/2020/05/10/deploying-a-static-site-to-azure-using-the-az-cli.aspx

$Settings = Get-Content -Raw -Path cdn-settings.json | ConvertFrom-Json

az group create --name $Settings.ResourceGroupName --location westeurope
#az configure --defaults group=$Settings.ResourceGroupName location=germanywestcentral

az storage account create --name $Settings.StorageAccountName -g $Settings.ResourceGroupName --sku Standard_LRS --kind StorageV2 --access-tier Hot
az storage blob service-properties update --account-name $Settings.StorageAccountName --static-website --404-document index.html --index-document index.html

az storage blob upload-batch --account-name $Settings.StorageAccountName --source ./spa --destination '$web'

$StorageUrl = az storage account show --name $Settings.StorageAccountName --resource-group $Settings.ResourceGroupName --query "primaryEndpoints.web" | ConvertFrom-Json
$StorageDomain = $StorageUrl.TrimStart("https://").TrimEnd("/")



#explorer $Url

az cdn profile create -n $Settings.CdnName -g $Settings.ResourceGroupName --location westeurope --sku Standard_Microsoft

#$CdnUrl = $Settings.StorageAccountName + ".z21.web.core.windows.net"
az cdn endpoint create -n $Settings.CdnEndpoint -g $Settings.ResourceGroupName --location westeurope --profile-name $Settings.CdnName  --origin $StorageDomain --origin-host-header $StorageDomain --enable-compression

az cdn endpoint rule add -n $Settings.CdnEndpoint -g $Settings.ResourceGroupName --profile-name $Settings.CdnName --rule-name enforcehttps --order 1 --action-name "UrlRedirect"  --redirect-type Found --redirect-protocol HTTPS --match-variable RequestScheme --operator Equal --match-value HTTP
az cdn endpoint rule add -n $Settings.CdnEndpoint -g $Settings.ResourceGroupName --profile-name $Settings.CdnName --rule-name sparewrite --order 2 --action-name "UrlRewrite" --source-pattern '/' --destination /index.html --preserve-unmatched-path false --match-variable UrlFileExtension --operator LessThan --match-value 1

az cdn custom-domain create --endpoint-name $Settings.CdnEndpoint --profile-name $Settings.CdnName -g $Settings.ResourceGroupName  -n cdn-domain --hostname cdn.az-kaziya.org
az cdn custom-domain enable-https --endpoint-name $Settings.CdnEndpoint --name cdn-domain --profile-name $Settings.CdnName --resource-group $Settings.ResourceGroupName

#az cdn custom-domain enable-https --endpoint-name davefancyapp123cdnendpoint --profile-name davefancyapp123cdn --name fancyapp-domain

#az storage blob upload-batch --account-name davefancyapp123 -s ./build -d '$web'
#az cdn endpoint purge -n davefancyapp123cdnendpoint --profile-name davefancyapp123cdn --no-wait --content-paths '/' '/index.html'

#npm i
#ng build --prod



#az group delete --name $Settings.ResourceGroupName -y
