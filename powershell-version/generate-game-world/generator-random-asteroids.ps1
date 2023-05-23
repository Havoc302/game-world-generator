Function New-AsteroidID {
    do {
        $rnd = Get-Random -Minimum 1 -Maximum 9999999999
    } until ($asteroidIDList -notcontains $rnd)
    $rndFull = '{0:d10}' -f $rnd
    return $rndFull
    [System.Collections.ArrayList]$asteroidIDList += $rnd
}

Function New-Asteroid {

    param ($systemName,$asteroidId)

    $asteroid = @{}

    $asteroidType = @("C","S","M") # C = chondrite, S = stony, M = metallic

    $asteroidShape = @("Rectangular Prism", "Cube", "Spherical", "Cone", "Cyclinder","Potato","Banana","Pear", "Ellipsoid")

    $mineralList = "Aluminium,Antimony,Arsenic,Bismuth,Cadmium,Chromium,Cobalt,Indium,Iron,Manganese,Molybdenum,Nickel,Rhenium,Selenium,Tantalum,Tellurium,Tin,Titanium,Tungsten,Vanadium,Zinc,Gold,Copper,Lead,Aluminum,Mercury,Silver,Platinum,Iridium,Osmium,Palladium,Rhodium,Ruthenium,Brass,Bronze,Pewter,German Silver,Osmiridium,Electrum,White Gold,Silver-Mercury,Gold-Mercury Amalgam" -split ","

    #$mineralListCulture = (Get-Culture).TextInfo

    $chondriteTypeList = "E3,EH3,EL3,E4,EH4,EL4,E5,EH5,EL5,E6,EH6,EL6,E7,EH7,EL7,H3,H4,H5,H6,H7,L3,L4,L5,L6,L7,LL3,LL4,LL5,LL6,LL7,CI,CM1,CM2,CV2,CV3,CR,CO3,CK,CB,CL,K,R" -split ","

    $type = (Get-Random -InputObject $asteroidType)
    $asteroid.Name = $systemName+'-'+$type+'-'+($asteroidId)
    $scale = Get-Random 0,0,0,0,0,0,0,0,0,0,0,1,1,1,2
    if ($scale -eq 0) {$size = "$([math]::ROUND((Get-Random -Minimum 0.5 -Maximum 550),2))"} elseif ($scale -eq 1) {$size = "$([math]::ROUND((Get-Random -Minimum 551 -Maximum 2000),2))"} elseif ($scale -eq 2) {$size = "$([math]::ROUND((Get-Random -Minimum 2001 -Maximum 20000),2))"}
    $asteroid.Size = $size+[string]" m"
    $volume = "$([math]::ROUND((4/3) * [math]::PI * [math]::Pow(($size/2), 3),0))"
    $asteroid.Volume = "$volume"+" m3"
    [int64]$volumeInt = $volume
    $asteroid.Mass = "$([math]::ROUND(2*($volumeInt),2))"+" t"
    $asteroid.Shape = Get-Random -InputObject $asteroidShape
    $asteroid.Rotation_rate = "$(Get-Random -Minimum 0.01 -Maximum 5)"+" r/m"
    if ($type -match "M") {
        $asteroid.MineralType = $(Get-Random -InputObject $mineralList -Count $(Get-Random -Minimum 1 -Maximum 6))
        $asteroid.MineralPercent = "$((Get-Random -Minimum 200 -Maximum 10000) / 100)"+'%'
    } elseif ($type -match "C") {
        $asteroid.MineralType = $(Get-Random -InputObject $chondriteTypeList)
        $asteroid.MineralPercent = "$((Get-Random -Minimum 20 -Maximum 4000) / 100)"+'%'
    } elseif ($type -match "S") { 
        $asteroid.MineralType = "Silicon","Nickel","Iron"
        $asteroid.MineralPercent = "$((Get-Random -Minimum 200 -Maximum 10000) / 100)"+'%'
    }
    return $asteroid
}

function New-AsteroidsGroup {
    param ($systemName,$asteroidCount)

    $counter = 0

    $asteroidTable = @{}

    do {
        $counter++
        $asteroidID = $(New-AsteroidID)
        $asteroidTable.Add($asteroidID,$(New-Asteroid -systemName $systemName -asteroidId $asteroidID))
    } until ($counter -ge $asteroidCount)
    return $asteroidTable
}