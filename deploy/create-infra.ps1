$RESOURCE_GROUP="cadulltestcontainerapps"
$LOCATION="northeurope"
$CONTAINERAPPS_ENVIRONMENT="cadulltestcontainerapps"
$LOG_ANALYTICS_WORKSPACE="cadulltestcontainerapps"
$STORAGE_ACCOUNT="cadulltestcontainerapps"
$ACR_NAME="cadulltestcontainerapps"

az group create --name $RESOURCE_GROUP --location "$LOCATION"

az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE
$LOG_ANALYTICS_WORKSPACE_CLIENT_ID=(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)
$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=(az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

az containerapp env create `
  --name $CONTAINERAPPS_ENVIRONMENT `
  --resource-group $RESOURCE_GROUP `
  --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
  --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET `
  --location "$LOCATION"

az storage account create `
  --name $STORAGE_ACCOUNT `
  --resource-group $RESOURCE_GROUP `
  --location "$LOCATION" `
  --sku Standard_RAGRS `
  --kind StorageV2

$QUEUE_CONNECTION_STRING=(az storage account show-connection-string -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT --query connectionString --out tsv)
az storage queue create `
  --name "processing-queue" `
  --account-name $STORAGE_ACCOUNT `
  --connection-string $QUEUE_CONNECTION_STRING

az acr create `
  --name $ACR_NAME `
  --resource-group $RESOURCE_GROUP `
  --sku Basic `
  --admin-enabled true


