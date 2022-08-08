# This generator creates cities and towns on planetary bodies

$count = $args[0]
$scale = $args[1]

Write-Host $args

$homePath = 'G:\Colonial_Alliance_Game'

$Global:cityNameListFile = "$homePath\starmap_creation\Sectors\cityNameList.txt"
$cityNameList = Get-Content $cityNameListFile
$cityNames = ""

$storeTypes = "Small General Store, Icecream Shop, Average Clothing Store, Fancy Clothing Store, Kitchenware Store, Technology Store, HoloProgram Store"

[System.Collections.Hashtable]$cities = @{}

Function Get-CityName {
    $rndSource = Get-Random 0,1,2,3
    if ($rndSource -eq 0) {
        $rndCityid = Get-Random -Minimum 1 -Maximum 23847
        $name = Invoke-RestMethod -uri "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=$rndCityid&hateoasMode=off"
        $name = (Get-Culture).TextInfo.ToTitleCase($name.data.city)
        $cityName = ((Get-Random @("","","","","","","","","","","","","","","Sunny","Eden","Main","Great","New")) + " " + $name).ToString().Trim()
        Write-Host "1 $cityName"
    } elseif ($rndSource -eq 1) {
        do {
            $name1 = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) -split " " | Select-Object -First 1
        } until ($name1 -notmatch "\?" -and $name1.length -ge 3)
        $name2 = Get-Random "Bay","Hill","Landing","Valley","Atoll","Beach","Ridge","Cove","Island","Badlands","Cave","Gorge","River","Lake","Flats","Mount","Mountain","Port","View","Field","Market","Fort","Island","Mound","Inlet","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
        $cityName = "$name1 $name2"
        Write-Host "2 $cityName"
    } elseif ($rndSource -eq 2) {
        do {
            $APIReturn = (Invoke-RestMethod -Uri api.namefake.com/random).Name
            $name = ((& "$homePath\game-world-generator\powershell-version\translate-string.ps1" ((($APIReturn) -split " ")[1]) | Select-Object -First 1).ToString()) -split " " | Select-Object -First 1
        } until ($name -notmatch "\?" -and $name.length -ge 3)
        $cityName = $name
        Write-Host "3 $cityName"
    } elseif ($rndSource -eq 3) {
        do {
            $name1 = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.location.city) -split " " | Select-Object -First 1
        } until ($name1 -notmatch "\?" -and $name1.length -ge 3)
        $name2 = Get-Random "Bay","Hill","Landing","Valley","Atoll","Beach","Ridge","Cove","Island","Badlands","Cave","Gorge","River","Lake","Flats","Mount","Mountain","Port","View","Field","Market","Fort","Island","Mound","Inlet","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
        $cityName = "$name1 $name2"
        Write-Host "4 $cityName"
    }
    return $cityName.Trim()
}

[System.Collections.Hashtable]$cities = @{}
foreach ($n in 1..$count) {
    if ($scale -eq $null) {
        $scale = Get-Random -InputObject "Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Town","Large Town","Large Town","Large Town","Large Town","Large Town","Large Town","Large Town","City","City","City","City","Large City","Large City","Capital"
    }

    do {
        $cityName = Get-CityName
    } until ($cityName -inotin $cityNamesList -and $cityName -inotin $($cities.Keys) -and $cityName -inotin $cityNames)
    $cityNames += "$cityName`n"

    switch ($Scale)
    {
        "Town" {$x = 100,10000}
        "Large Town" {$x= 10001,100000}
        "City" {$x= 100001,1000000}
        "Large City" {$x= 1000001,10000000}
        "Capital" {$x= 10000001,100000000}
    }

    $primaryIndustry = Get-Random "Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Heavy Water","Mining-Platinum","Mining-Plutonium","Mining-Tungsten","Mining-Gold","Mining-Uranium","Mining-Gold","Mining-Uranium","Mining-Gold","Mining-Uranium","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Crops","Agriculture-Livestock","Agriculture-Livestock","Manufacturing","Manufacturing","Manufacturing","Pharmaceuticals","Pharmaceuticals","Military-Marines","Military-Fleet","Pirate","Research","Private Mercenary"

    $population = Get-Random -Minimum $($x[0]) -Maximum $($x[1])
    [System.Collections.Hashtable]$city = @{}
    #$xcoord = Get-Random -Minimum 1 -Maximum 1600
    #$ycoord = Get-Random -Minimum 1 -Maximum 1020
    $city.CityName = $cityName
    $city.Population = $population
    $city.PrimaryIndustry = $primaryIndustry
    #$city.Coordinates = "$xcoord,$ycoord"
    $cities.Add($city.CityName,$city)
    Clear-Variable cityName
}

Add-Content -Path $cityNameListFile -Value $cityNames
$cities