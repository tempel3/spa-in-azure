docker build -t spa .
#az acr login --name myregistry

docker login -u "spadeploymentcontainerregistry" --password "$env:spadeploymentcontainerregistryPw" spadeploymentcontainerregistry.azurecr.io

docker tag spa spadeploymentcontainerregistry.azurecr.io/spa
docker push spadeploymentcontainerregistry.azurecr.io/spa

