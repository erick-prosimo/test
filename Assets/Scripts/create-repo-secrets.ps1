$githubSecrets   = gh secret list
$requiredSecrets = @( 
    'ARM_CLIENT_ID',
    'ARM_CLIENT_SECRET',
    'ARM_SUBSCRIPTION_ID',
    'ARM_TENANT_ID',
    'AWS_ACCESS_KEY_ID',
    'AWS_SECRET_ACCESS_KEY',
    'GCP_SA_EMAIL',
    'GCP_SA_KEY',
    'PROSIMO_API_TOKEN',
    'PROSIMO_TEAMNAME',
    'VM_PASSWORD'
    )


:GHS foreach ($requiredSecret in $requiredSecrets) {
    foreach ($githubSecret in $githubSecrets) {
        if ($githubSecret.StartsWith($requiredSecret)) { 
            Write-Host "Found secret: $requiredSecret" 
            continue GHS
        }
    }
    Write-Host "Creating secret: $requiredSecret"
    gh secret set $requiredSecret --body "empty"
}