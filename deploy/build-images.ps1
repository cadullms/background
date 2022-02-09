$ACR_NAME = "cadulltestcontainerapps"

function BuildAndPush($imageName, $tag, $path) {
    docker image build -t "$($imageName):$tag" $path
    docker image push "$($imageName):$tag"
}

#az acr login --name $ACR_NAME
#BuildAndPush -imageName "$ACR_NAME.azurecr.io/daprtest/client-app" -tag "latest" -path "$PSScriptRoot/../client-app"

az acr build --registry $ACR_NAME --image daprtest/queue-processor-app:latest $PSScriptRoot/../queue-processor-app
az acr build --registry $ACR_NAME --image daprtest/client-app:latest $PSScriptRoot/../client-app
