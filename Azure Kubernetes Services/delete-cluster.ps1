$ClusterName = "deploy-spa-aks"
$ResourceGroup = "deploy-spa-aks"

az aks delete --name $ClusterName --resource-group $ResourceGroup --yes
az group delete --name $ResourceGroup --yes

kubectl config unset users.$ClusterName
kubectl config unset contexts.$ClusterName
kubectl config unset clusters.$ClusterName