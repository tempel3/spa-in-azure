$ClusterName = "deploy-spa-aks"
$ResourceGroup = "deploy-spa-aks"

az aks get-credentials --resource-group $ResourceGroup --name $ClusterName