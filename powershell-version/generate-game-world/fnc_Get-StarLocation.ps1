function Get-StarLocation {
    param($MapSizeX,$MapSizeY)
    $labelX = 0..145
    $labelY = 0..55
    do {
        $1 = Get-Random -Minimum 5 -Maximum ($masterMapSizeX-5)
        $2 = Get-Random -Minimum 5 -Maximum ($masterMapSizeY-5)
        $coords = $1,$2
    } until ($systemsCoordArray -notcontains $coords -and ($1 -notin $labelX -or $2 -notin $labelY))
    $systemsCoordArray += $1,$2
    return $coords
}