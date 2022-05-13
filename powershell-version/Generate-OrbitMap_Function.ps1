function Generate-OrbitalMap {
    param($Name,$StarColour,$PlanetOrbits,$SaveLoc)
    $scale = 20
    $orbitalMapFile = "$SaveLoc\$Name-orbital_map"
    $orbitalWidthInt = [int]($planetOrbits | Select-Object -Last 1) * $scale
    [int]$orbitalMapWidth = $orbitalWidthInt * 1.1
    $orbitalMap = new-object System.Drawing.Bitmap $orbitalMapWidth,$orbitalMapWidth
    $penOrbits = New-Object System.Drawing.Pen "GhostWhite"
    $penScale = New-Object System.Drawing.Pen "Red"
    $brushBackground = [System.Drawing.Brushes]::Black
    $orbitalGraphics = [System.Drawing.Graphics]::FromImage($orbitalMap)
    $orbitalGraphics.FillRectangle($brushBackground,0,0,$orbitalMapWidth,$orbitalMapWidth)
    $orbitalMap.SetPixel(($orbitalMapWidth/2),($orbitalMapWidth/2),$starColour)
    $planetOrbitsDesc = $planetOrbits | Get-Unique | Sort {[int]$_} -Descending
    foreach ($n in $planetOrbitsDesc) {
        [single]$orbitalWidthInt = [single]$n*[single]$scale
        $orbitalGraphics.DrawEllipse($penOrbits,(($orbitalMapWidth-$orbitalWidthInt)/2),(($orbitalMapWidth-$orbitalWidthInt)/2),$orbitalWidthInt,$orbitalWidthInt)
    }
    [single]$scaleLinePos = 10
    [single]$scaleLine = $orbitalWidthInt / $scale
    $orbitalGraphics.DrawLine($penScale,($scaleLinePos+($orbitalWidthInt/10)),$scaleLinePos,($scaleLine*10),$scaleLinePos)

    $orbitalGraphics.Dispose()

    $orbitalMap.Save("$orbitalMapFile.jpg")
}
