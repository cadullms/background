$RESOURCE_GROUP="cadulltestcontainerapps"
$LOCATION="northeurope"
$CONTAINERAPPS_ENVIRONMENT="cadulltestcontainerapps"
$LOG_ANALYTICS_WORKSPACE="cadulltestcontainerapps"
$STORAGE_ACCOUNT="cadulltestcontainerapps"
$ACR_NAME="cadulltestcontainerapps"

$STORAGE_ACCOUNT_KEY=(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query '[0].value' --out tsv)
$ACR_PASSWORD=(az acr credential show -n $ACR_NAME --query "passwords[0].value" -o tsv)

az deployment group create `
  --resource-group "$RESOURCE_GROUP" `
  --template-file $PSScriptRoot/client-app.json `
  --parameters `
      environment_name="$CONTAINERAPPS_ENVIRONMENT" `
      location="$LOCATION" `
      image_name="$ACR_NAME.azurecr.io/daprtest/client-app" `
      image_tag="latest" `
      acr_name="$ACR_NAME" `
      acr_password="$ACR_PASSWORD" `
      queue_storage_account_name="$STORAGE_ACCOUNT" `
      queue_storage_account_key="$STORAGE_ACCOUNT_KEY" 

az deployment group create `
  --resource-group "$RESOURCE_GROUP" `
  --template-file $PSScriptRoot/queue-processor-app.json `
    --parameters `
        environment_name="$CONTAINERAPPS_ENVIRONMENT" `
        location="$LOCATION" `
        image_name="$ACR_NAME.azurecr.io/daprtest/queue-processor-app" `
        image_tag="latest" `
        acr_name="$ACR_NAME" `
        acr_password="$ACR_PASSWORD" `
        queue_storage_account_name="$STORAGE_ACCOUNT" `
        queue_storage_account_key="$STORAGE_ACCOUNT_KEY" 
    
          