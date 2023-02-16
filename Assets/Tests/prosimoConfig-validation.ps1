#Requires -Version 5

$prosimoConfig      = Get-Content $env:CONFIG_FILE -Raw
$prosimoObject      = $prosimoConfig | ConvertFrom-Json
$edgeRegions        = $prosimoObject.regions
$idpValue           = $prosimoObject.idp.name
$clouds             = @("AWS", "Azure", "GCP")
$edgeCIDR           = @()
$cloudAccounts      = @()
$azureRegionsRaw    = @()
$awsRegionsRaw      = @()
$gcpRegionsRaw      = @()
$azureRegions       = @()
$awsRegions         = @()
$gcpRegions         = @()
$configFields       = ($prosimoObject | Get-Member -MemberType NoteProperty).name
$edgeCloudRegions   = ($edgeRegions  | Get-Member -MemberType NoteProperty).name
$requiredFields     = @("cloudNickname", "edgeCIDR", "idp", "regions", "terraform")
$allowdIdp          = @("azure_ad","google","okta","one_login","pingone","other")
$configuredClouds   = ($prosimoObject.cloudNickname | Get-Member -MemberType NoteProperty).name  
$configuredEdges    = ($prosimoObject.edgeCIDR | Get-Member -MemberType NoteProperty).name     
$cloudRegions       = "https://$env:PROSIMO_TEAMNAME.admin.prosimo.io/api/dashboard/diagnostics/map/cloud"
$headers            = @{                                                        
    "content-type"      = 'application/json'
    "Prosimo-ApiToken"  = $env:PROSIMO_API_TOKEN
}
$proRegions         = Invoke-WebRequest -Uri $cloudRegions -Method Get -Headers $headers
$proRegionsObj      = ($proRegions.Content | ConvertFrom-Json).data


# Build list of configured edge CIDR ranges
foreach ( $cidr in  ($prosimoObject.edgeCIDR | Get-Member -MemberType NoteProperty).Name ) { 
    $edgeCIDR += $prosimoObject.edgeCIDR.$cidr
}

foreach ($cloud in $clouds) {
    foreach ( $cloudAccount in $prosimoObject.cloudNickname.$cloud ) {
        $cloudAccounts += $cloudAccount
    }
}

$awsRegionsRaw     = ($proRegionsObj | Where-Object edgeCloud -eq "AWS").edgeRegion
$azureRegionsRaw   = ($proRegionsObj | Where-Object edgeCloud -eq "AZURE").edgeRegion
$gcpRegionsRaw     = ($proRegionsObj | Where-Object edgeCloud -eq "GCP").edgeRegion

foreach ($region in $awsRegionsRaw) { 
    $awsRegions += $region.Split('.')[1]
}

foreach ($region in $azureRegionsRaw) { 
    $azureRegions += $region.Split('.')[1]
}

foreach ($region in $gcpRegionsRaw) { 
    $gcpRegions += $region.Split('.')[1]
}

function Assert-ValidIp ($cidr) {
    $proposedNetwork = Get-Subnet $cidr
    return ($proposedNetwork.IPAddress.IPAddressToString -eq $proposedNetwork.NetworkAddress.IPAddressToString) 
}