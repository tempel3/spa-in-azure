Write-Host "Install Azure CLI, kubectl and helm first"

$ClusterName = "deploy-spa-aks"
$ResourceGroup = "deploy-spa-aks"

az group create --name $ResourceGroup --location westeurope
az aks create --resource-group $ResourceGroup --name $ClusterName --node-count 1 --node-vm-size Standard_B2s
az aks update --resource-group $ResourceGroup --name $ClusterName --attach-acr  "/subscriptions/b404fc03-8dcd-4078-949b-497702ba66bc/resourceGroups/deploy-spa/providers/Microsoft.ContainerRegistry/registries/spadeploymentcontainerregistry"

az aks get-credentials --resource-group $ResourceGroup --name $ClusterName

az aks enable-addons --resource-group $ResourceGroup --name $ClusterName --addons http_application_routing


# https://docs.microsoft.com/de-de/azure/aks/ingress-basic
# Create a namespace for your ingress resources
#kubectl create namespace ingress-basic

# Add the official stable repository
#helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Use Helm to deploy an NGINX ingress controller
#helm install nginx-ingress stable/nginx-ingress --namespace ingress-basic --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
