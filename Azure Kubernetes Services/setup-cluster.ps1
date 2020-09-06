Write-Host "Install Azure CLI, kubectl and helm first"

$ClusterName = "deploy-spa-aks"
$ResourceGroup = "deploy-spa-aks"

az group create --name $ResourceGroup --location westeurope
az aks create --resource-group $ResourceGroup --name $ClusterName --node-count 1 --node-vm-size Standard_B2s
az aks update --resource-group $ResourceGroup --name $ClusterName --attach-acr  "/subscriptions/b404fc03-8dcd-4078-949b-497702ba66bc/resourceGroups/deploy-spa/providers/Microsoft.ContainerRegistry/registries/spadeploymentcontainerregistry"

az aks get-credentials --resource-group $ResourceGroup --name $ClusterName

az aks enable-addons --resource-group $ResourceGroup --name $ClusterName --addons http_application_routing