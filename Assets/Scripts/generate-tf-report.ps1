$tempData           = @()
$terraformPath      = "../../Examples/$env:cloud/POC"
$terraformReport    = Get-Content "$terraformPath/tfreport-$env:cloud"
$resources          = $terraformReport | ConvertFrom-Json
$createTotal        = ($resources.resource_changes.change | Where-Object actions -eq "create").count
$updateTotal        = ($resources.resource_changes.change | Where-Object actions -eq "update").count
$deleteTotal        = ($resources.resource_changes.change | Where-Object actions -eq "delete").count

$tempData += "## Terraform Report  "
$tempData += "---"
$tempData += "  "
$tempData += " Create: $createTotal "
$tempData += " Update: $updateTotal "
$tempData += " Delete: $deleteTotal "
$tempData += "  "
$tempData += "---"
$tempData += "| Resource  | Create | Update | Delete |"
$tempData += "| :---: | :---: | :---: | :---: |" 

for ($i = 0; $i -lt $resources.resource_changes.count; $i ++) {

    $resourceType = $resources.resource_changes[$i].type
    $resourceAction = $resources.resource_changes[$i].change.actions

    if ($resourceAction -eq "create") { $tempData += " | $resourceType | X | | |" }
    if ($resourceAction -eq "update") { $tempData += " | $resourceType | | X | |" }
    if ($resourceAction -eq "delete") { $tempData += " | $resourceType | | | X |" }
}

Write-Output $tempData