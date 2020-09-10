../set-my-env-variables.ps1

docker build -t spa .
#az acr login --name myregistry

docker login -u "deployspadockeracr" --password "$env:spadeploymentcontainerregistryPw" deployspadockeracr.azurecr.io

docker tag spa deployspadockeracr.azurecr.io/spa
docker push deployspadockeracr.azurecr.io/spa

