# Set variables
$terraformFile      = Get-Content $env:TEST_FILE
$cloud              = $env:CLOUD
$prosimoConfig      = Get-Content $env:CONFIG_FILE | ConvertFrom-Json
$allowedConfig      = @{}
$proposedConfig     = @{}
$azureRegionsRaw    = @()
$awsRegionsRaw      = @()
$gcpRegionsRaw      = @()
$azureRegions       = @()
$awsRegions         = @()
$gcpRegions         = @()
$cloudRegions       = "https://$env:PROSIMO_TEAMNAME.admin.prosimo.io/api/dashboard/diagnostics/map/cloud"
$headers            = @{                                                        
    "content-type"      = 'application/json'
    "Prosimo-ApiToken"  = $env:PROSIMO_API_TOKEN
}
$proRegions         = Invoke-WebRequest -Uri $cloudRegions -Method Get -Headers $headers
$proRegionsObj      = ($proRegions.Content | ConvertFrom-Json).data
$awsRegionsRaw      = ($proRegionsObj | Where-Object edgeCloud -eq "AWS").edgeRegion
$azureRegionsRaw    = ($proRegionsObj | Where-Object edgeCloud -eq "AZURE").edgeRegion
$gcpRegionsRaw      = ($proRegionsObj | Where-Object edgeCloud -eq "GCP").edgeRegion

foreach ($region in $awsRegionsRaw) { 
    $awsRegions += $region.Split('.')[1]
}

foreach ($region in $azureRegionsRaw) { 
    $azureRegions += $region.Split('.')[1]
}

foreach ($region in $gcpRegionsRaw) { 
    $gcpRegions += $region.Split('.')[1]
}

# Convert json config to hash table
foreach ($item in $prosimoConfig.regions.$cloud) {
    $allowedConfig.Add($item.region, $item.allowedCIDR)
}



for ($i = 0; $i -lt $terraformFile.count; $i ++) {
    if ($terraformFile[$i] -match "deployment") { $startRead = $i + 1 }
    if ($terraformFile[$i] -match "]") { $endRead = $i - 1 }
}

# Loop through start and end of deployment block to build proposed config hash table
for ($i = $startRead; $i -le $endRead; $i ++) {
    if ($terraformFile[$i] -match "{") { 
        do {
            if ($terraformFile[$i] -match "region" ) {
                $region = ($terraformFile[$i].Split("=")[1] -replace '"', "").Trim()
            }            
            if ($terraformFile[$i] -match "cidr" ) {
                $cidr = ($terraformFile[$i].Split("=")[1] -replace '"', "").Trim()
            }
            $i ++
        }
        until ( 
            $terraformFile[$i] -match "}" 
        )
        $proposedConfig.Add($region, $cidr)
    }
}

# Set proposed regions and cidrs to be array of strings (return this data to test file)
$proposedRegions    = [string[]]$proposedConfig.Keys
$proposedCidrs      = [string[]]$proposedConfig.Values

function Assert-ValidIp ($cidr) {
    $proposedNetwork = Get-Subnet $cidr
    return ($proposedNetwork.IPAddress.IPAddressToString -eq $proposedNetwork.NetworkAddress.IPAddressToString) 
}

function Assert-EdgeConfigured ($region) {
    return $allowedConfig.ContainsKey($region)
}

function Assert-AllowedCidr ($region) {
    if ( $allowedConfig.$region ) { 
        $proposedCidr   = (Get-Subnet $proposedConfig[$region]).HostAddresses
        $allowedCidr    = (Get-Subnet $allowedConfig[$region]).HostAddresses

        foreach ($ip in $proposedCidr) {
            return ($ip -in $allowedCidr)
        }
    }
}