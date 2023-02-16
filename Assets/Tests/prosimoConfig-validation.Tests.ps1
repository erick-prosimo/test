#Requires -Version 5

BeforeAll {
    # Download subnet module from PowerShell Gallery
    if (-not (Get-Module Subnet)) { Install-Module -Name Subnet -Force }
    
    # Import data and functions
    . ./Assets/Tests/prosimoConfig-validation.ps1
}

BeforeDiscovery {
    # Import data and functions
    . ./Assets/Tests/prosimoConfig-validation.ps1
} 

Describe 'Prosimo-Config' {
    
    It "should be valid JSON"  {
        (Test-Json -Json $prosimoConfig) | Should -Be $true
    }

    It "should have required fields in config" {
        $requiredFields | Should -BeIn $configFields
    }

    It "should be a valid IDP" {
        $idpValue | Should -BeIn $allowdIdp
    }

    It "should have at least 1 cloud configured" {
        $cloudAccounts | Should -Not -Be $null `
            -Because "No cloud account configured"
    }        

    It "should be a valid CIDR for Edge" -ForEach ($edgeCIDR) {
        Assert-ValidIp -cidr $_ | Should -Be $true `
            -Because "$_ is not a valid IP CIDR"
    }

    It "should be in a valid cloud region" -ForEach ($edgeCloudRegions) {
        $edgeRegions.$_.region | Should -BeIn ( Get-Variable -Name ($_.ToLower() + "Regions") -ValueOnly ) `
            -Because "is not a valid region for cloud $_"
    }

    It "should have an edge CIDR defined for cloud account" {
        $configuredClouds | Should -BeIn $configuredEdges
    }
}