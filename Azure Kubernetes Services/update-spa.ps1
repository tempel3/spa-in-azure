helm upgrade -i spa .\spa-chart\

$POD_NAME = $(kubectl get pods --namespace default -l "app.kubernetes.io/name=spa-chart,app.kubernetes.io/instance=spa" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward "$POD_NAME" 8080:80 