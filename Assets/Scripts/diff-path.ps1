$diff       = Get-Content '/tmp/diff.txt'
$allPaths   = @{}

$addModifySet = foreach ($change in $diff) {
    $operation, $filename = ($change -split "`t")[0, -1]

    if ($operation -eq 'D') {
        $deleteSet += $filename
        continue
    }

    if ($operation -in 'A', 'M') { 

        $workpath   = $null
        $pathSplit = $filename.split('/')

        for ($i = 0; $i -lt ($pathSplit.count - 1); $i ++) {
            $workPath += $pathSplit[$i] + "/" 
        }

        $allPaths.Add($workPath, $workpath)
    }
}