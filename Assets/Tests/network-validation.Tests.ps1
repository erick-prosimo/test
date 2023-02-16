#Requires -Version 5

BeforeAll {
    # Download subnet module from PowerShell Gallery
    if (-not (Get-Module Subnet)) { Install-Module -Name Subnet -Force }
    
    # Import data and functions
    . ./Assets/Tests/network-validation.ps1
}

BeforeDiscovery {
    # Import data and functions
    . ./Assets/Tests/network-validation.ps1
}    

Describe 'Proposed-Network' {
    
    It "should be a valid CIDR" -ForEach ($proposedCidrs) {
        Assert-ValidIp -cidr $_ | Should -Be $true `
            -Because "$_ is not a valid IP CIDR"
    }

    It "should have a matching region defined in prosimo-config.json" -ForEach ($proposedRegions) {
        $allowedConfig.ContainsKey($_) | Should -Be $true `
            -Because "deployment to region: $_ is missing matching region in prosimo-config.json"
    }

    It "should be in an allowed CIDR range for cloud region" -ForEach ($proposedRegions) {
        Assert-AllowedCidr -region $_ | Should -Be $true `
            -Because "$($proposedConfig[$_]) not valid for cloud $cloud and region $_ | Allowed range is: $($allowedConfig[$_])"
    }

    It "should be a valid cloud region" -ForEach ($proposedRegions) {
        $_ | Should -BeIn ( Get-Variable -Name ($cloud.ToLower() + "Regions") -ValueOnly ) `
            -Because "is not a valid region for cloud $_"
    }    
}