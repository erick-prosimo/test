set -o errexit

# Initialize terraform backend based on configured provider
if [ "$TFBACKEND" = "AWS" ] 
then 
    terraform init -backend-config=bucket="$BE_BUCKET_NAME" -backend-config=key="Prosimo-$CLOUD-POC.tfstate" -backend-config=region="$BE_REGION_NAME"
fi

if [ "$TFBACKEND" = "Azure" ] 
then 
    terraform init -backend-config=storage_account_name="$BE_STORAGE_NAME" -backend-config=container_name="$BE_CONTAINER_NAME" -backend-config=key="Prosimo-$CLOUD-POC.tfstate" -backend-config=resource_group_name="$BE_RGNAME"
fi

if [ "$TFBACKEND" = "GCP" ] 
then 
    terraform init -backend-config="tbd"
fi

if [ "$TFBACKEND" = "TFCloud" ] 
then 
    terraform init -backend-config="tbd"
fi

if [ -z "$TFBACKEND" ] 
then 
    echo "Error no backend configured - Exiting now"
    exit 1
fi