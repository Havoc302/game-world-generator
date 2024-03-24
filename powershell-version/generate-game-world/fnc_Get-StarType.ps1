# Attempts to represent reasonably accurate real world chances of star type, they're in order of star colour, lower mass range, upper mass range, chance of planets, chance of habitable planets.

function Get-StarType {
param($habitable,$planets)
    if ($habitable -eq $true) {
        $starRandom = Get-Random -Minimum 0.1 -max 0.9
    } elseif ($planets -eq $true) {
        $starRandom = Get-Random -Minimum 7701 -max 1000000
    } else {
        $starRandom = Get-Random -Minimum 1 -Maximum 1000000
    }
    switch ($starRandom) {
        {$_ -ge 0.1 -and $_ -lt 0.5} {"LightYellow",$(Get-Random -Minimum 0.9 -Maximum 1.2),100,100} # F type light yellow star - Forced 100% chance of habitable for minimum habitables count
        {$_ -ge 0.5 -and $_ -le 0.9} {"Yellow",$(Get-Random -Minimum 0.9 -Maximum 1.2),100,100} # G type yellow star - Forced 100% chance of habitable for minimum habitables count
        {$_ -ge 1 -and $_ -le 3} {"Blue",$(Get-Random -Minimum 3 -Maximum 150),0,0} # O Type blue star
        {$_ -ge 4 -and $_ -le 1400} {"LightSkyBlue",$(Get-Random -Minimum 3 -Maximum 70),0,0} # B type light sky blue star
        {$_ -ge 1401 -and $_ -le 7700} {"White",$(Get-Random -Minimum 0.15 -Maximum 1.2),0,0} # A type white star
        {$_ -ge 7701 -and $_ -le 29000} {"LightYellow",$(Get-Random -Minimum 0.9 -Maximum 1.2),80,7} # F type light yellow star
        {$_ -ge 29001 -and $_ -le 106000} {"Yellow",$(Get-Random -Minimum 0.9 -Maximum 1.2),95,50} # G type yellow star
        {$_ -ge 106001 -and $_ -le 235500} {"Orange",$(Get-Random -Minimum 0.5 -Maximum 0.8),80,0} # K type orange star
        {$_ -ge 235501 -and $_ -le 1000000} {"Red",$(Get-Random -Minimum 0.075 -Maximum 0.4),70,0} # M type red star
    }
}