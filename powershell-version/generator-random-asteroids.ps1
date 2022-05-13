[string]$system_name = $args[0]

[int]$asteroid_count = $args[1]

$asteroid_type = @("C","S","M") # C = chondrite, S = stony, M = metallic

$asteroid_shape = @("Rectangular Prism", "Cube", "Spherical", "Cone", "Cyclinder","Potato","Banana","Pear", "Ellipsoid")

$mineralList = "Aluminium,Antimony,Arsenic,Bismuth,Cadmium,Chromium,Cobalt,Indium,Iron,Manganese,Molybdenum,Nickel,Rhenium,Selenium,Tantalum,Tellurium,Tin,Titanium,Tungsten,Vanadium,Zinc,Gold,Copper,Lead,Aluminum,Mercury,Silver,Platinum,Iridium,Osmium,Palladium,Rhodium,Ruthenium,Brass,Bronze,Pewter,German Silver,Osmiridium,Electrum,White Gold,Silver-Mercury,Gold-Mercury Amalgam"

$mineralList = $mineralList -split ","

$mineralListCulture = (Get-Culture).TextInfo

$asteroids = @{}

$StopWatch = New-Object System.Diagnostics.Stopwatch
$StopWatch.Start()

Function Get-AsteroidID {
    do {
        $rnd = Get-Random -Minimum 1 -Maximum 9999999999
    } until ($asteroidIDList -notcontains $rnd)
    $rndFull = '{0:d10}' -f $rnd
    return $rndFull
    [System.Collections.ArrayList]$asteroidIDList += $rnd
}

foreach ($i in 1..$asteroid_count) {
    $asteroid_id = Get-AsteroidID
    $asteroid = @{}
    $type = (Get-Random -InputObject $asteroid_type)
    $asteroid.Name = $system_name+'-'+$type+'-'+($asteroid_id)
    $size = "$([math]::ROUND((Get-Random -Minimum 0.5 -Maximum 550),2))"
    $asteroid.Size = $size+[string]"m"
    $volume = "$([math]::ROUND((4/3) * [math]::PI * [math]::Pow(($size/2), 3),2))"
    $asteroid.Volume = "$volume"+"m3"
    [int]$volumeInt = $volume
    $asteroid.Mass = "$([math]::ROUND(2*($volumeInt*1000),2))"+"t"
    $asteroid.Shape = Get-Random -InputObject $asteroid_shape
    $asteroid.Rotation_rate = "$(Get-Random -Minimum 0.01 -Maximum 5)"+"r/s"
    if ($type -match "M") {
        $asteroid.MineralType = $(Get-Random -InputObject $mineralList)
        $asteroid.MineralPercent = "$((Get-Random -Minimum 1 -Maximum 10000) / 100)"+'%'
    }
    $asteroids.Add($asteroid.Name,$asteroid)
}

return $asteroids

$StopWatch.Elapsed.TotalSeconds
$StopWatch.Stop()