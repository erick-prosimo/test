$cloudBackEnd   = $env:tfbackend
$stateLocation  = $env:tfbackendLocation
$backEnd        = "backend.tf"
$backEndPath    = "../Backend/$cloudBackEnd"
$backendFile    = "../Backend/$cloudBackEnd/$backEnd"
$clouds         = @("AWS", "Azure", "GCP")


if ($cloudBackEnd -eq "AWS") {}
if ($cloudBackEnd -eq "Azure") {

    az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET -t $env:ARM_TENANT_ID 
    az account set --subscription $env:ARM_SUBSCRIPTION_ID
    
    $templateOutput = az deployment sub create --name "tfstate" --location $stateLocation --template-file "$backEndPath/main.bicep"
    $storageName    = ($templateOutput | ConvertFrom-Json).properties.outputs.storageName.value
    $containerName  = ($templateOutput | ConvertFrom-Json).properties.outputs.containerName.value
    $rgName         = ($templateOutput | ConvertFrom-Json).properties.outputs.rgName.value  

    gh secret set BE_STORAGE_NAME   --body $storageName
    gh secret set BE_CONTAINER_NAME --body $containerName
    gh secret set BE_RGNAME         --body $rgName

}
if ($cloudBackEnd -eq "GCP") {}
if ($cloudBackEnd -eq "TFCloud") {}

foreach ($cloud in $clouds) {
    $pocPath = "../../Examples/$cloud/POC"
    if ( (Test-Path -Path "$pocPath/$backEnd") -eq $false ) {
        Copy-Item -Path $pocPath $backendFile -Force
    }
}