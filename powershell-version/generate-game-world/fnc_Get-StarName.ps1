Write-Host "Loading function Get-StarName" -BackgroundColor Gray -ForegroundColor Black

Function Get-StarName {
    
    if ($firstNames.Count -ge 1) {
        if ($firstNamesOrderSequence -eq $true) {
            $systemName = $firstNames[0]
            $firstNames.Remove($systemName)
        } else {
            $systemName = Get-Random -InputObject $firstNames
            $firstNames.Remove($systemName)
        }
    } else {
        $systemName = Get-Random -InputObject $systemNames
        $systemName = $systemName.Trim()
        $systemNames.Remove($systemName)
    }

    return $systemName
}

Write-Host "Function Get-StarName loaded." -BackgroundColor Green -ForegroundColor Black