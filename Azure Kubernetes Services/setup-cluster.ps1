Write-Host "Install Azure CLI, kubectl and helm first"

$ClusterName = "deploy-spa-aks"
$ResourceGroup = "deploy-spa-aks"

az group create --name $ResourceGroup --location westeurope
az aks create --resource-group $ResourceGroup --name $ClusterName --node-count 1 --node-vm-size Standard_B2s
az aks update --resource-group $ResourceGroup --name $ClusterName --attach-acr "/subscriptions/188b30ed-e61a-4a66-a82e-797c61c5aaa1/resourceGroups/deploy-spa-docker/providers/Microsoft.ContainerRegistry/registries/deployspadockeracr"
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName

az aks enable-addons --resource-group $ResourceGroup --name $ClusterName --addons http_application_routing

