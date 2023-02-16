$gitDiff = git diff --name-status HEAD^ HEAD

if ($null -ne $gitDiff) {
    $gitDiff | Write-Host
    $gitDiff | Out-File -FilePath '/tmp/diff.txt'

    $deletedContent = git diff --diff-filter=D HEAD^ HEAD --no-prefix --no-renames
    if($null -ne $deletedContent) {
        $deletedContent = $deletedContent -match '^-' -replace '^([^-+ ]*)[-+ ]', '$1'
        Write-Host '##[group]Deleted files content'
        $deletedContent | Write-Host
        Write-Host '##[endgroup]'
        $deletedContent | Out-File -FilePath '/tmp/diffdeletedfiles.txt'
    }
}
else {
    Write-Host '##[error]The validation pipeline failed because there is currently no change to be processed'
    exit 1
}


$gitDiff = git diff --name-only
$gitdiff | Split-Path
