Add-Type -AssemblyName System.Drawing

$homePath = 'G:\Colonial_Alliance_Game'
#$homePath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$starmapCreation = "$homePath\StarmapCreation"
$htmlFiles = "$starmapCreation\Software\StarGen\html"
$stargenPath = "$starmapCreation\Software\StarGen\StarGen.exe"
$planetgenPath = "$starmapCreation\Software\Planets\planet.exe"
$sectorsSave = "$starmapCreation\Sectors"
$sectorX = 1000
$sectorY = 1000
$buffer = 5
$labelWidth = 20
$systems = 50 # star systems per map # Standard 5000
$maps =  9 # total number of maps to make # Standard 31
$asteroidFieldChance = 12
$okBiomes = "210210210","250215165","105155120","220195175","225155100","155215170","170195200","185150160","130190025","110160170"# Tundra, Grasslands, Taiga, Desert, Savanna, Temperate Forest, Temperate Rainforest, Xeric Shrubland and Dry Forest, Tropical Dry Forest, Tropical Rainforest
[System.Collections.ArrayList]$coreWorlds = "New Eden,Eugene Davis","Ka-May,Asheigh Kelvin","Xin De Shuguang,Xiwang","Nouvelle,Gabriel Bernard,","Gemutlichkeit,Gisela Ziegler","Nihongo,Tanegashima","Britannia,Trafalgar"

Set-Location "$sectorsSave"

Remove-Item -Path "$sectorsSave\*" -Recurse -Force

function Get-StarType {
    $rnd = Get-Random -Minimum 1 -Maximum 1000000
    switch ($rnd) {
        {$_ -ge 1 -and $_ -le 3} {"Blue",16000000,30000000}
        {$_ -ge 4 -and $_ -le 1400} {"LightSkyBlue",2100000,15999999}
        {$_ -ge 1401 -and $_ -le 7700} {"White",1400000,2099999}
        {$_ -ge 7701 -and $_ -le 29000} {"LightYellow",1040000,1399999}
        {$_ -ge 29001 -and $_ -le 106000} {"Yellow",800000,1039999}
        {$_ -ge 106001 -and $_ -le 235500} {"Orange",450000,799999}
        {$_ -ge 235501 -and $_ -le 1000000} {"Red",80000,449999}
    }
}

function Get-AsteroidField {
    param($SystemName,$PlanetOrbits)
    $asteroidCount = Get-Random -Minimum 51 -Maximum 315
    Write-Host "Generating $asteroidCount asteroids" -BackgroundColor Gray
    $asteroidFieldRaw = (& "$homePath\game-world-generator\powershell-version\generator-random-asteroids.ps1" "$systemName" "$asteroidCount")
    $asteroidField = $asteroidFieldRaw | ConvertTo-Json
    $asteroidFieldLoc = $(Get-Random $($planetOrbits.Count))
    $asteroidFieldLocText = "Asteroid belt between the orbit of planets $asteroidFieldLoc and $($asteroidFieldLoc+1)`n"
    return $asteroidFieldLocText,$asteroidField
}

# Start map creation
foreach ($m in 1..$maps) {
    Write-Host "Starting sector $m map creation"
    ########## Start sector map creation ##########
    $sectorNum = '{0:d3}' -f $m
    $starmapBmp = new-object System.Drawing.Bitmap $sectorX,$sectorY
    $brushBg = [System.Drawing.Brushes]::Black
    $fontMapNum = new-object System.Drawing.Font Consolas,12
    $fontStarNum = new-object System.Drawing.Font Consolas,6
    $graphics = [System.Drawing.Graphics]::FromImage($starmapBmp)
    $graphics.FillRectangle($brushBg,0,0,$starmapBmp.Width,$starmapBmp.Height)
    $brushTitle = [System.Drawing.Brushes]::White
    $graphics.DrawString("Sector $sectorNum",$fontMapNum,$brushTitle,10,10)
    # Define sector map file name
    $sectorMapFilename = "Sector_$sectorNum.jpg"

    New-Item -Path $sectorsSave -Name "Sector_$sectorNum" -ItemType Directory

    $sectorDir = "$sectorsSave\Sector_$sectorNum"

    New-Item -Path $sectorDir -Name "Terrestrial" -ItemType Directory
    Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination "$sectorDir\terrestrial" -Recurse
    New-Item -Path $sectorDir -Name "Non-Terrestrial" -ItemType Directory
    Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination "$sectorDir\non-terrestrial" -Recurse
    
    Set-Location "$homePath\starmap_creation\Software\StarGen"

    Write-Host "Starting system creation for Sector $m"

    $systemCount = Get-Random -Minimum $($systems - 2) -Maximum $($systems + 5)

    ########## Star system creation ##########
    foreach ($s in 1..$systems) {
        Write-Host "Generating system $s"
        $locationList = @()
        # Getting star type, colour and name then writing it to the sector map
        $starType = Get-StarType
        $colour = $starType[0]
        $starColour = [System.Drawing.Color]::$colour
        $xRnd = Get-Random -Minimum $buffer -Maximum ($sectorX-$buffer)
        $yRnd = Get-Random -Minimum $buffer -Maximum ($sectorY-$buffer)
        $brushFg = [System.Drawing.Brushes]::$colour
        $starmapBmp.SetPixel($xRnd,$yRnd,$starColour)
        if (($xRnd+30) -ge $sectorX) {
            $xTextPos = ($xRnd-($labelWidth+$buffer))
            $yTextPos = $yRnd-$buffer
        } else {
            $xTextPos = $xRnd
        }
        if (($yTextPos+10) -ge $sectorY) {
            $yTextPos = ($yRnd-$buffer)
        } else {
            $yTextPos = $yRnd
        }
        if (($yRnd) -le 10) {
            $yTextPos = ($yRnd+$buffer)
        } else {
            $yTextPos = $yRnd
        }
        [string]$graphicsText = "$s"
        [int]$xTextPos = $xTextPos+1
        [int]$yTextPos = $yTextPos-6
        $graphics.DrawString($graphicsText,$fontStarNum,$brushFg,$xTextPos,$yTextPos)
        # End sector map creation creation
        # Decide if the system should have planets or not
        if ($s -in 1..7 -and $m -eq 1) {
            $terresPlanetChance = $true
            Write-Host "Terrestrial planet $terresPlanetChance - core system" -BackgroundColor White -ForegroundColor Black
        } else {
            $terresPlanetChance = ((Get-Random -Minimum 1 -Maximum 101) -in (1..75))
            Write-Host "Terrestrial planet $terresPlanetChance - non core system" -BackgroundColor Cyan
        }
        if ($terresPlanetChance -eq $false) {
            $nonTerresPlanetChance = ((Get-Random -Minimum 1 -Maximum 101) -in (1..75))
            Write-Host "Terrestrial planet $nonTerresPlanetChance" -BackgroundColor Magenta
        }
        $metaData = ""
        Write-Host "System has planets: $planetChance"

########## Terrestrial System Creation ##########
        
        if ($terresPlanetChance -eq $true) {
            write-Host "Starting Terrestrial system creation" -BackgroundColor Blue
            Set-Location "$homePath\starmap_creation\Software\StarGen"
            do {
                $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                $mass = $mass.ToString()
                Start-Process $stargenPath -ArgumentList "-m$mass -M" -Wait -NoNewWindow
                Start-Sleep -Seconds 1
                $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
                $starFileTerresCheck = (Get-Content $starFile -Raw) -match "Terrestrial"
                if ($starFileTerresCheck -ne $true) {
                    Remove-Item "$htmlFiles\*" -Force
                }
            } until ($starFile -ne $null -and $starFileTerresCheck -eq $true)
            $html = Get-Content $starFile -Raw
            $htmlWeb = Invoke-WebRequest -Uri $starfile -UseBasicParsing
            $currentSeed = (($html -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
            $planetOrbits = @((($html -split "`n" | select-string -Pattern "<TH>Distance from primary star</TH>") -replace "<TR>","" -replace "</TR>","" -replace "<TD>","" -replace "</TD>","" -replace "<TH>","" -replace "</TH>","" -replace "Distance from primary star","" -split "KM") | Select-String -Pattern "AU") -replace "AU","" -replace " ",""
            $hydrospheres = @(($html -split "`n" | Select-String -Pattern "Hydrosphere") -replace "<TR>","" -replace "<TH>","" -replace "</TR>","" -replace "</TH>","" -replace "<TD>","" -replace "</TD>","" -replace "Hydrosphere percentage","" | where {$_ -notmatch "0.0"}) -split "`n"
            Write-Host "Current seed: $currentSeed"
            $currentName = "System $currentSeed - StarGen.exe $currentSeed-$mass"
            Write-Host "Current name: $currentName"
            $systemNum = '{0:d5}' -f $s
            $newName = "System_$sectorNum-$systemNum"
            Write-Host "New name: $newName"
            $currentFileLink = "StarGen.exe $currentSeed-$mass"
            $currentFileName = "StarGen.exe-$currentSeed-$mass"
            $html = $html -replace $currentName,$newName
            $html = $html -replace $currentFileName,$newName
            $html = $html -replace $currentFileLink,$newName
            $htmlObj = New-Object -Com "HTMLFile"
            $htmlObj.IHTMLDocument2_write($htmlWeb.RawContent)
            [array]$planetList = (($htmlObj.body.outerText) -split "`n" | Select-String -Pattern "Planet Type" -Context 1,0) -replace "Planet Type" -replace "Statistics" -replace ">"
            $basePlanetType = "Rock","Terrestrial","Martian","Ice"
            $basePlanetList = @{}
            foreach ($pl in $planetList) {
                $plObj = ($pl -split "`n").Trim()
                $plObj1 = $plObj[0],$plObj[1]
                if ($basePlanetType -match $plObj[1]) {
                    $basePlanetList.add($plObj1[0],$plObj1)
                }
            }
            $locationList += $($basePlanetList.Keys)
            Set-Content "$htmlFiles\$newName.html" $html
            $metaFile = $newName+"_metaData.txt"
            $terresCount = ($html -split "<" | Select-String -Pattern "TerrestrialPlanet.gif" | Group-Object).count
            New-Item -ItemType Directory -Path "$sectorDir\terrestrial" -Name "$newName"
            $systemPath = "$sectorDir\terrestrial\$newName"
            $metaData += "System: $newname`n"
            $metaData += "Star Type: $colour`n"
            Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath
            #Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination $systemPath -Recurse
            Copy-Item -Path "$homePath\starmap_creation\Software\Planets\biome_legend.png" -Destination $systemPath
            # Ends solar system creation
            # Starts naming system
            if ($m -eq 1 -and ($coreWorlds.Count) -ne 0) {
                Write-Host "Creating core world" -BackgroundColor Blue
                $coreWorldCheck = $true
                $systemName = ($coreWorlds[0] -split ",")[0]
                $planetName = ($coreWorlds[0] -split ",")[1]
                $capitalCityName = ($coreWorlds[0] -split ",")[2] + " Landing"
                $metaData += "System Name: $systemName`n"
                $metaData += "1st Terrestrial Planet Name: $planetName`n"
                $capitalCity = & "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" "1" "Capital"
                $metaData += $capitalCity | ConvertTo-Json -Depth 3
                $metaData += "`n"
                $coreWorlds.Remove($coreWorlds[0])
            } elseif ($m -eq 1 -and ($coreWorlds.Count) -eq 0) {
                $coreWorldCheck = $false
                $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                $metaData += "System Name: $systemName`n"
                $metaData += "1st Terrestrial Planet Name: $planetName`n"
            } elseif ($m -in 2..7 -and ($coreWorlds.Count) -eq 0) {
                $coreWorldCheck = $false
                $claimed = (Get-Random -Minimum 1 -Maximum 101) -in 1..25
                if ($claimed -eq $true) {
                    $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $metaData += "System Name: $systemName`n"
                    $metaData += "1st Terrestrial Planet Name: $planetName`n"
                } else {
                    $metaData += "System $newName unclaimed"
                }
            } else {
                $coreWorldCheck = $false
                $claimed = (Get-Random -Minimum 1 -Maximum 101) -in 1..3
                if ($claimed -eq $true) {
                    $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $metaData += "System Name: $systemName`n"
                    $metaData += "1st Terrestrial Planet Name: $planetName`n"
                } else {
                    $metaData += "System $newName unclaimed"
                }
            }
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck`n"
            $metaData += "Asteroid field in system: $asteroidFieldCheck`n"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $metaData += $asteroidReturn[0]
                $metaData += $asteroidReturn[1]
                $metaData += "`n"
            }
        ########## Planetary object creation ##########
            foreach ($p in 1..$terresCount) {
                Write-Host "Creating objects for planet $p in $newName" -BackgroundColor Green -ForegroundColor Black
                $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                Set-Location "$homePath\starmap_creation\Software\Planets"
                $hydrosphereIndex = $($p-1)
                [int]$hydrosphere = $hydrospheres[$hydrosphereIndex]
                $hydrosphere = $hydrosphere*100
                # Check comments at bottom for how I arrived at these figures
                if ($hydrosphere -in 100..1000) {$waterMod = [math]::Round((Get-Random -Maximum 10.05 -Minimum 10.026),4)}
                elseif ($hydrosphere -in 1001..2000)   {$waterMod = [math]::Round((Get-Random -Maximum 10.025 -Minimum 10.015),4)}
                elseif ($hydrosphere -in 2001..3000)   {$waterMod = [math]::Round((Get-Random -Maximum 10.014 -Minimum 10.005),4)}
                elseif ($hydrosphere -in 3001..4000)   {$waterMod = [math]::Round((Get-Random -Maximum 10.0049 -Minimum 9.9955),4)}
                elseif ($hydrosphere -in 4001..5000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.9954 -Minimum 9.987),4)}
                elseif ($hydrosphere -in 5001..6000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.986 -Minimum 9.978),4)}
                elseif ($hydrosphere -in 6001..7000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.977 -Minimum 9.967),4)}
                elseif ($hydrosphere -in 7001..8000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.966 -Minimum 9.956),4)}
                elseif ($hydrosphere -in 8001..9000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.955 -Minimum 9.943),4)}
                elseif ($hydrosphere -in 9001..10000)   {$waterMod = [math]::Round((Get-Random -Maximum 9.942 -Minimum 9.92),4)}
                $waterModArg = $waterMod-10
                $waterModArg = [math]::Round($waterModArg,4)
                $planetFileLocBio = "$systemPath\$newName-$p-Bio.bmp"
                $planetFileLocH = "$systemPath\$newName-$p-Height.bmp"
                $planetArgsBio = "-s 0.$mass -o ""$planetFileLocBio"" -w 1600 -h 1020 -i ""$waterModArg"" -g 10 -G 10 -E -z -pprojectionM" #
                Start-Process $planetGenPath $planetArgsBio -NoNewWindow -Wait
                $planetArgsH = "-s 0.$mass -o ""$planetFileLocH"" -w 1600 -h 1020 -i ""$waterModArg"" -g 10 -G 10 -E -pprojectionM" #
                Start-Process $planetGenPath $planetArgsH -NoNewWindow -Wait
                if ($coreWorldCheck -eq $true) {
                    Write-Host "Core world check: $coreWorldCheck"
                    $cityAmount = 20,30#150,1000
                    $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                    Write-Host "Generating $cityCount cities"                        
                    $metaData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $metaData += $cities | ConvertTo-Json -Depth 3
                    $metaData += "`n"
                    $milBaseCount = Get-Random -Minimum 10 -Maximum 30 #100,300
                    Write-Host "Generating $milBaseCount military bases"
                    $metaData += "Military Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $metaData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $metaData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 3 -Maximum 10) #30,100
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $metaData += "Criminal Bases:`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $metaData += "`n"
                        }
                    }
                } elseif ($m -eq 1 -and ((Get-Random -Minimum 1 -Maximum 101) -in 1..66)) {
                    Write-Host "Core world check: $coreWorldCheck"
                    $cityAmount = 10,20#25,200
                    $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                    Write-Host "Generating $cityCount cities"                        
                    $metaData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $metaData += $cities | ConvertTo-Json -Depth 3
                    $metaData += "`n"
                    $milBaseCount = Get-Random -Minimum 20 -Maximum 100
                    Write-Host "Generating $milBaseCount military bases"
                    $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBaseLoc = Get-Random $locationList
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $metaData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $metaData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 12) -1
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $metaData += "Criminal Bases in $newName`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random -InputObject $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $metaData += "`n"
                        }
                    }
                } elseif ($m -in 2..6 -and (Get-Random -Minimum 1 -Maximum 100) -in 1..33 -or $claimed -eq $true) {
                    Write-Host "Core world check: $coreWorldCheck"
                    $cityAmount = 5,10#5,50
                    $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                    Write-Host "Generating $cityCount cities"                        
                    $metaData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $metaData += $cities | ConvertTo-Json -Depth 3
                    $metaData += "`n"
                    $milBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                    Write-Host "Generating $milBaseCount military bases"
                    $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBaseLoc = Get-Random -InputObject $locationList
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $metaData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $metaData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 15) -1
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $metaData += "Criminal Bases in $newName`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random -InputObject $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $metaData += "`n"
                        }
                    }
                }
                foreach ($city in $($cities.GetEnumerator())) {
                    Write-Host "Processing $($city.Key)"
                    $bioMapPath = (Get-ChildItem "$systemPath\$newName-$p-Bio.bmp").FullName
                    $heightMapPath = (Get-ChildItem "$systemPath\$newName-$p-Height.bmp").FullName
                    $bioBitmap = [System.Drawing.Bitmap]::FromFile($bioMapPath)
                    $heightBitmap = [System.Drawing.Bitmap]::FromFile($heightMapPath)                    
                    do {
                        $bioXRnd = Get-Random -Minimum 20 -Maximum 1580
                        $bioYRnd = Get-Random -Minimum 20 -Maximum 1000
                        $bioPixelCheck = $bioBitmap.GetPixel($bioXRnd,$bioYRnd)
                        $bioPixelCheck = "$($bioPixelCheck.R)"+"$($bioPixelCheck.G)"+"$($bioPixelCheck.B)"
                    } until ($bioPixelCheck -in $okBiomes)
                    $cities.($city.Key).Coordinates = $bioXRnd,$bioYRnd
                    if ($city.Value.Population -ge 5000) {
                        $bioMapBrush = [System.Drawing.Brushes]::DarkRed
                        $bioMarkerColour = [System.Drawing.Color]::Red
                        $bioMapFont = new-object System.Drawing.Font Consolas,5
                        $bioMapGraphics = [System.Drawing.Graphics]::FromImage($bioBitmap)
                        $HeightMapGraphics = [System.Drawing.Graphics]::FromImage($heightBitmap)
                        $bioMapGraphics.DrawString($bioMapCityName,$bioMapFont,$bioMapBrush,$($bioXRnd+5),$($bioYRnd-8))
                        $HeightMapGraphics.DrawString($bioMapCityName,$bioMapFont,$bioMapBrush,$($bioXRnd+5),$($bioYRnd-8))
                        $bioBitmap.SetPixel($bioXRnd,$bioYRnd,$bioMarkerColour)
                        $heightBitmap.SetPixel($bioXRnd,$bioYRnd,$bioMarkerColour)
                    }
                    $bioMapPathNew = (($bioMapPath -split "\\" | Select-Object -Last 1)+"Old")
                    $heightMapPathNew = (($heightMapPath -split "\\" | Select-Object -Last 1)+"Old")
                    Rename-Item -Path $bioMapPath -NewName $bioMapPathNew
                    Rename-Item -Path $heightMapPath -NewName $heightMapPathNew
                    Remove-Item -Path $bioMapPath -Force
                    Remove-Item -Path $heightMapPath -Force
                    $bioBitmap.Save("$systemPath\$newName-Bio.bmp")
                    $heightBitmap.Save("$systemPath\$newName-Height.bmp")
                    $bioBitmap.Dispose()
                    $heightBitmap.Dispose()
                }
            }
        }

########## Generation of non-terrestrial system with planets ##########
        if ($nonTerresPlanetChance -eq $true) {
            Write-Host "Generating non-terrestrial system with planets" -ForegroundColor Black -BackgroundColor Yellow
            Set-Location "$homePath\starmap_creation\Software\StarGen"
            do {
                $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                $mass = $mass.ToString()
                Start-Process $stargenPath -ArgumentList "-m$mass -M" -Wait -NoNewWindow
                Start-Sleep -Seconds 1
                $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
                $starFileTerresCheck = (Get-Content $starFile -Raw) -match "Terrestrial"
                if ($starFileTerresCheck -eq $true) {
                    Remove-Item $starFile -Force
                }
            } until ($starFile -ne $null -and $starFileTerresCheck -eq $false)
            $html = Get-Content $starFile -Raw
            $htmlWeb = Invoke-WebRequest -Uri $starfile -UseBasicParsing
            $currentSeed = (($html -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
            $planetOrbits = @((($html -split "`n" | select-string -Pattern "<TH>Distance from primary star</TH>") -replace "<TR>","" -replace "</TR>","" -replace "<TD>","" -replace "</TD>","" -replace "<TH>","" -replace "</TH>","" -replace "Distance from primary star","" -split "KM") | Select-String -Pattern "AU") -replace "AU","" -replace " ",""
            Write-Host "Current seed: $currentSeed"
            $currentName = "System $currentSeed - StarGen.exe $currentSeed-$mass"
            Write-Host "Current name: $currentName"
            $systemNum = '{0:d5}' -f $s
            $newName = "System_$sectorNum-$systemNum"
            Write-Host "New name: $newName"
            $currentFileLink = "StarGen.exe $currentSeed-$mass"
            $currentFileName = "StarGen.exe-$currentSeed-$mass"
            $html = $html -replace $currentName,$newName
            $html = $html -replace $currentFileName,$newName
            $html = $html -replace $currentFileLink,$newName
            $htmlObj = New-Object -Com "HTMLFile"
            $htmlObj.IHTMLDocument2_write($htmlWeb.RawContent)
            [array]$planetList = (($htmlObj.body.outerText) -split "`n" | Select-String -Pattern "Planet Type" -Context 1,0) -replace "Planet Type" -replace "Statistics" -replace ">"
            $basePlanetType = "Rock","Terrestrial","Martian","Ice"
            $basePlanetList = @{}
            foreach ($pl in $planetList) {
                $plObj = ($pl -split "`n").Trim()
                $plObj1 = $plObj[0],$plObj[1]
                if ($basePlanetType -match $plObj[1]) {
                    $basePlanetList.add($plObj1[0],$plObj1)
                }
            }
            $locationList += $($basePlanetList.Keys)
            Set-Content "$htmlFiles\$newName.html" $html
            $metaFile = $newName+"_metaData.txt"
            New-Item -ItemType Directory -Path "$sectorDir\non-terrestrial" -Name "$newName"
            $systemPath = "$sectorDir\non-terrestrial\$newName"
            $metaData += "System: $newname`n"
            $metaData += "Star Type: $colour`n"
            Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath
            # Ends solar system creation								 
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $metaData += $asteroidReturn[0]
                $metaData += $asteroidReturn[1]
                $metaData += "`n"
            }
            $milBaseCount = (Get-Random -Minimum 1 -Maximum 5) -1
            Write-Host "Generating $milBaseCount military bases"
            $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
            foreach ($mb in 1..$milBaseCount) {
                $milBaseLoc = Get-Random $locationList
                $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                $metaData += $milBases | ConvertTo-Json -Depth 3
            }
            if ($m -in 1..12) {
                if ($m -eq 1) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                } elseif ($m -eq 2..7)  {
                    $pirateBaseCount = (Get-Random -Minimum 8 -Maximum 30) -1
                } elseif ($m -eq 8..12) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 15) -1
                }
                if ($pirateBaseCount -ge 1) {
                    $metaData += "Criminal Bases:`n"
                    foreach ($pb in 1..$pirateBaseCount) {
                        $location = Get-Random -InputObject $locationList
                        $pirBaseLoc = $newName+"-"+$location
                        $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                        $metaData += "`n"
                    }
                }
            }
        } elseif ($nonTerresPlanetChance -eq $false -and $terresPlanetChance -eq $false) {
    ########## Star only (no planets) system creation ##########
            Write-Host "Generating no planets system" -ForegroundColor Black -BackgroundColor Gray
            $locationList = @()
            $systemNum = '{0:d5}' -f $s
            $newName = "System_$sectorNum-$systemNum"
            $systemPath = "$sectorDir\non-terrestrial\$newName"
            New-Item -Path "$sectorDir\non-terrestrial" -Name $newName -ItemType Directory
            $metaFile = $newName+"_metaData.txt"
            $metaData += "System: $newname`n"
            $metaData += "Star Type: $colour`n"
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $metaData += $asteroidReturn[0]
                $metaData += $asteroidReturn[1]
                $metaData += "`n"
            }
            if ($m -in 1..12) {
                if ($m -eq 1) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 3) -1
                } elseif ($m -eq 2..6)  {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 5) -1
                } elseif ($m -eq 7..12) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                }
                if ($pirateBaseCount -ge 1) {
                    foreach ($baseCount in 1..$pirateBaseCount) {
                        if ($asteroidFieldCheck -eq $true) {
                            $locationList = $($asteroidFieldRaw.Keys)
                            $location = Get-Random -InputObject $locationList
                            $baseLoc = $newName+"-"+$location
                        } else {
                            $baseLoc = $newName
                        }
                        $metaData += "Criminal Bases in orbit of star in $newName`n"
                    
                        $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $baseLoc) | ConvertTo-Json
                        $metaData += "`n"
                    }
                }
                if ((Get-Random -Minimum 1 -Maximum 100) -in 1..66) {
                    $milBaseCount = (Get-Random -Minimum 1 -Maximum 4) -1
                    if ($milBaseCount -ge 1) {
                        Write-Host "Generating $baseCount military bases"
                        $metaData += "Miltary Bases in Orbit of star in $newName`n"
                        $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" $milBaseCount) | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                    }
                }
            }
        }
        Add-Content "$systemPath\$metaFile" $metaData
        Remove-Item -Path "$htmlFiles\*" -Force
        Write-Host "########## $newName SYSTEM GENERATION COMPLETE ##########"
        Clear-Variable terresPlanetChance,nonTerresPlanetChance,locationList
    }
    $graphics.Dispose()
    Write-Host "Saving Sector map $sectorDir"
    $starmapBmp.Save("$sectorDir\$sectorMapFilename")
}

Remove-Item "$htmlFiles\*" -Recurse -Force

<# Planet Generator water percentage plot:

This was fucking annoying to work out.

0.05 = 1%
0.026 = 10%
0.015 = 20%
0.005 = 30%
-0.0045 = 40%
-0.013 = 50%
-0.022 = 60%
-0.033 = 70%
-0.044 = 80%
-0.057 = 90%
-0.08 = 99%

#>




<#
        if ($terresPlanetChance -eq $true) {
            write-Host "Starting Terrestrial system creation" -BackgroundColor Blue
            Set-Location "$homePath\starmap_creation\Software\StarGen"
            if ($s -in 1..7 -and $m -eq 1) {
                Write-Host "Creating core system $((($coreWorlds[0]) -split",")[0])" -BackgroundColor Blue
                do {
                    $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                    $mass = $mass.ToString()
                    Start-Process $stargenPath -ArgumentList "-m$mass -M" -Wait -NoNewWindow
                    Start-Sleep -Seconds 1
                    $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
                    $starFileTerresCheck = (Get-Content $starFile -Raw) -match "Terrestrial"
                    if ($starFileTerresCheck -ne $true) {
                        Remove-Item $starFile -Force
                    }
                } until ($starFile -ne $null -and $starFileTerresCheck -eq $true)
            } else {
                Write-Host "Creating non-core uninhabitable system" -BackgroundColor Red
                do {
                    $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                    $mass = $mass.ToString()
                    Start-Process $stargenPath -ArgumentList "-m$mass -M" -Wait -NoNewWindow
                    Start-Sleep -Seconds 1
                    $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
                } until ($starFile -ne $null)
            }
            $html = Get-Content $starFile -Raw
            $htmlWeb = Invoke-WebRequest -Uri $starfile -UseBasicParsing
            $currentSeed = (($html -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
            $planetOrbits = @((($html -split "`n" | select-string -Pattern "<TH>Distance from primary star</TH>") -replace "<TR>","" -replace "</TR>","" -replace "<TD>","" -replace "</TD>","" -replace "<TH>","" -replace "</TH>","" -replace "Distance from primary star","" -split "KM") | Select-String -Pattern "AU") -replace "AU","" -replace " ",""
            Write-Host "Current seed: $currentSeed"
            $currentName = "System $currentSeed - StarGen.exe $currentSeed-$mass"
            Write-Host "Current name: $currentName"
            $systemNum = '{0:d5}' -f $s
            $newName = "System_$sectorNum-$systemNum"
            Write-Host "New name: $newName"
            $currentFileLink = "StarGen.exe $currentSeed-$mass"
            $currentFileName = "StarGen.exe-$currentSeed-$mass"
            $html = $html -replace $currentName,$newName
            $html = $html -replace $currentFileName,$newName
            $html = $html -replace $currentFileLink,$newName
            $htmlObj = New-Object -Com "HTMLFile"
            $htmlObj.IHTMLDocument2_write($htmlWeb.RawContent)
            [array]$planetList = (($htmlObj.body.outerText) -split "`n" | Select-String -Pattern "Planet Type" -Context 1,0) -replace "Planet Type" -replace "Statistics" -replace ">"
            $basePlanetType = "Rock","Terrestrial","Martian","Ice"
            $basePlanetList = @{}
            foreach ($pl in $planetList) {
                $plObj = ($pl -split "`n").Trim()
                $plObj1 = $plObj[0],$plObj[1]
                if ($basePlanetType -match $plObj[1]) {
                    $basePlanetList.add($plObj1[0],$plObj1)
                }
            }
            $locationList += $($basePlanetList.Keys)
            [boolean]$terresCheck = ($html -match "Terrestrial")
            Write-Host "Terrestrial planet found: $terresCheck"
            Set-Content "$htmlFiles\$newName.html" $html
            $metaFile = $newName+"_metaData.txt"
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in (1..6))
            Write-Host "Asteroid field in system: $asteroidFieldCheck"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidCount = Get-Random -Minimum 100 -Maximum 400
                Write-Host "Generating $asteroidCount asteroids"
                $asteroidFieldRaw = (& "$homePath\game-world-generator\powershell-version\generator-random-asteroids.ps1" "$newName" "$asteroidCount")
                $asteroidField = $asteroidFieldRaw | ConvertTo-Json
                $asteroidFieldLoc = $(Get-Random $($planetOrbits.Count))
                $asteroidFieldLocText = "Asteroid belt between the orbit of planets $asteroidFieldLoc and $($asteroidFieldLoc+1)`n"
                $locationList += $($asteroidFieldRaw.Keys)
            }
            if ($terresCheck -eq $false) {
                Write-Host "Generating non-terrestrial system" -BackgroundColor Red
                New-Item -ItemType Directory -Path "$sectorDir\non-terrestrial" -Name "$newName"
                $systemPath = "$sectorDir\non-terrestrial\$newName"
                $metaData += "System: $newname`n"
                $metaData += "Star Type: $colour`n"
                Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath -Force
                #Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination $systemPath -Recurse
                # Ends solar system creation								 
                if ($asteroidFieldCheck -eq $true) {
                    # Adds the Asteroid Data
                    $metaData += $asteroidFieldLocText
                    $metaData += "$asteroidField`n"
                }
                if ($m -in 1..12) {
                    if ($m -eq 1) {
                        $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                    } elseif ($m -eq 2..6)  {
                        $pirateBaseCount = (Get-Random -Minimum 8 -Maximum 30) -1
                    } elseif ($m -eq 7..12) {
                        $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 15) -1
                    }
                    if ($pirateBaseCount -ge 1) {
                        Write-Host "$pirateBaseCount criminal bases in system"
                        $metaData += "$pirateBaseCount criminal bases in system"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = get-random -InputObject $locationList
                            $baseLoc = $newName+"-"+$location
                            $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $baseLoc) | ConvertTo-Json
                            $metaData += "`n"
                        }
                    }
                }
                # Generates an orbit map
                #Generate-OrbitalMap -Name $newName -StarColour $starColour -PlanetOrbits $planetOrbits -SaveLoc "$htmlFiles\non-terrestrial\$newName"
            } else {

            ########## Terrestrial (with planets) system creation ##########
                Write-Host "Generating terrestrial system" -BackgroundColor Green
                $terresCount = ($html -split "<" | Select-String -Pattern "TerrestrialPlanet.gif" | Group-Object).count
                New-Item -ItemType Directory -Path "$sectorDir\terrestrial" -Name "$newName"
                $systemPath = "$sectorDir\terrestrial\$newName"
                $metaData += "System: $newname`n"
                $metaData += "Star Type: $colour`n"
                Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath
                #Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination $systemPath -Recurse
                Copy-Item -Path "$homePath\starmap_creation\Software\Planets\biome_legend.png" -Destination $systemPath
                # Ends solar system creation
                # Starts naming system
                if ($m -eq 1 -and ($coreWorlds.Count) -ne 0) {
                    $coreWorldCheck = $true
                    $systemName = ($coreWorlds[0] -split ",")[0]
                    $planetName = ($coreWorlds[0] -split ",")[1]
                    $capitalCityName = ($coreWorlds[0] -split ",")[2] + " Landing"
                    $metaData += "System Name: $systemName`n"
                    $metaData += "1st Terrestrial Planet Name: $planetName`n"
                    $capitalCity = & "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" "1"
                    $metaData += $capitalCity | ConvertTo-Json -Depth 3
                    $metaData += "`n"
                    $coreWorlds.Remove($coreWorlds[0])
                } elseif ($m -in 2..12) {
                    $coreWorldCheck = $false
                    $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $metaData += "System Name: $systemName`n"
                    $metaData += "1st Terrestrial Planet Name: $planetName`n"
                } else {
                    $coreWorldCheck = $false
                    $claimed = (Get-Random -Minimum 1 -Maximum 101) -in 1..3
                    if ($claimed -eq $true) {
                        $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                        $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                        $metaData += "System Name: $systemName`n"
                        $metaData += "1st Terrestrial Planet Name: $planetName`n"
                    }
                }
                if ($asteroidFieldCheck -eq $true) {
                    # Adds the Asteroid Data
                    $metaData += $asteroidFieldLocText
                    $metaData += "$asteroidField`n"
                }
                
                # Adds habitable planet and city data
                # Start planet map generation
                foreach ($p in 1..$terresCount) {
                    $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
                    Set-Location "$homePath\starmap_creation\Software\Planets"
                    $planetFileLocBio = "$systemPath\$newName-$p-Bio.bmp"
                    $planetFileLocH = "$systemPath\$newName-$p-Height.bmp"
                    $planetArgsBio = "-s 0.$mass -o ""$planetFileLocBio"" -w 1600 -h 1020 -g 10 -G 10 -E -z -pprojectionM" #
                    Start-Process $planetGenPath $planetArgsBio -NoNewWindow -Wait
                    $planetArgsH = "-s 0.$mass -o ""$planetFileLocH"" -w 1600 -h 1020 -g 10 -G 10 -E -pprojectionM" #
                    Start-Process $planetGenPath $planetArgsH -NoNewWindow -Wait
                    if ($coreWorldCheck -eq $true) {
                        $cityAmount = 1000,4000
                        $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                        Write-Host "Generating $cityCount cities"                        
                        $metaData += "Cities found on habitable planet $p in $newName`n"
                        $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                        $locationList += $($cities.Keys)
                        $metaData += $cities | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                        $milBaseCount = Get-Random -Minimum 100 -Maximum 300
                        Write-Host "Generating $milBaseCount military bases"
                        $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                        foreach ($mb in 1..$milBaseCount) {
                            $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                            $metaData += $milBases | ConvertTo-Json -Depth 3
                        }
                        $metaData += "`n"
                        $pirateBaseCount = (Get-Random -Minimum 30 -Maximum 100) -1
                        if ($pirateBaseCount -ge 1) {
                            $metaData += "Criminal Bases:`n"
                            foreach ($pb in 1..$pirateBaseCount) {
                                if ($asteroidFieldCheck -eq $true) {
                                    $locationList = $($asteroidFieldRaw.Keys)+$($basePlanetList.Keys)
                                    $location = Get-Random -InputObject $locationList
                                } else {
                                    $location = get-random -InputObject $($basePlanetList.Keys)
                                }
                                $pirBaseLoc = $newName+"-"+$location
                                $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            }
                            $metaData += "`n"
                        }
                    } elseif ($m -eq 1 -and (((Get-Random -Minimum 1 -Maximum 101) -in 1..66) -or $cities -match "Military")) {
                        $cityAmount = 50,500
                        $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                        Write-Host "Generating $cityCount cities"                        
                        $metaData += "Cities found on habitable planet $p in $newName`n"
                        $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                        $locationList += $($cities.Keys)
                        $metaData += $cities | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                        $milBaseCount = Get-Random -Minimum 2 -Maximum 10
                        Write-Host "Generating $milBaseCount military bases"
                        $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $metaData += $milBases | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                        $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 5) -1
                        $metaData += "Criminal Bases in $newName`n"
                        if ($pirateBaseCount -ge 1) {
                            $metaData += "Criminal Bases:`n"
                            foreach ($pb in 1..$pirateBaseCount) {
                                if ($asteroidFieldCheck -eq $true) {
                                    $locationList = $($asteroidFieldRaw.Keys)+$($basePlanetList.Keys)
                                    $location = Get-Random -InputObject $locationList
                                } else {
                                    $location = get-random -InputObject $($basePlanetList.Keys)
                                }
                                $pirBaseLoc = $newName+"-"+$location
                                $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                                $metaData += "`n"
                            }
                        }
                    } elseif ($m -in 2..6 -and (Get-Random -Minimum 1 -Maximum 100) -in 1..33 -or $claimed -eq $true) {
                        $cityAmount = 5,100
                        $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                        Write-Host "Generating $cityCount cities"                        
                        $metaData += "Cities found on habitable planet $p in $newName`n"
                        $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                        $locationList += $($cities.Keys)
                        $metaData += $cities | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                        $milBaseCount = Get-Random -Minimum 1 -Maximum 5
                        Write-Host "Generating $milBaseCount military bases"
                        $metaData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $metaData += $milBases | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                        $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 15) -1
                        $metaData += "Criminal Bases in $newName`n"
                        if ($pirateBaseCount -ge 1) {
                            $metaData += "Criminal Bases:`n"
                            foreach ($pb in 1..$pirateBaseCount) {
                                if ($asteroidFieldCheck -eq $true) {
                                    $locationList = $($asteroidFieldRaw.Keys)+$($basePlanetList.Keys)
                                    $location = Get-Random -InputObject $locationList
                                } else {
                                    $location = get-random -InputObject $($basePlanetList.Keys)
                                }
                                $pirBaseLoc = $newName+"-"+$location
                                $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                                $metaData += "`n"
                            }
                        }
                    }
                }
            }
            #Generate-OrbitalMap -Name $newName -StarColour $starColour -PlanetOrbits $planetOrbits -SaveLoc "$htmlFiles\terrestrial\$newName"
            Write-Host "########################################"
            Remove-Item -Path $starFile -Force
            #Clear-Variable html,mass,currentSeed,currentName
        } else {

        ########## Non-Terrestrial (without planets) system creation ##########
            $locationList = @()
            $systemNum = '{0:d5}' -f $s
            $newName = "System_$sectorNum-$systemNum"
            $systemPath = "$sectorDir\non-terrestrial\$newName"
            New-Item -Path "$sectorDir\non-terrestrial" -Name $newName -ItemType Directory
            $metaFile = $newName+"_metaData.txt"
            $metaData += "System: $newname`n"
            $metaData += "Star Type: $colour`n"
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 1000) -in (1..3))
            if ($asteroidFieldCheck -eq $true) {
                $asteroidCount = Get-Random -Minimum 5 -Maximum 40
                Write-Host "Generating $asteroidCount asteroids"
                $asteroidFieldRaw = (& "$homePath\game-world-generator\powershell-version\generator-random-asteroids.ps1" "$newName" "$asteroidCount")
                $asteroidField = $asteroidFieldRaw | ConvertTo-Json
                $asteroidFieldLoc = $(Get-Random $($planetOrbits.Count))
                $asteroidFieldLocText = "Asteroid belt between the orbit of planets $asteroidFieldLoc and $($asteroidFieldLoc+1)`n"
                $metaData += $asteroidFieldLocText
                $metaData += $asteroidField
                $metaData += "`n"
            }
            if ($m -in 1..12) {
                if ($m -eq 1) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 3) -1
                } elseif ($m -eq 2..6)  {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 5) -1
                } elseif ($m -eq 7..12) {
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                }
                if ($pirateBaseCount -ge 1) {
                    foreach ($baseCount in 1..$pirateBaseCount) {
                        if ($asteroidFieldCheck -eq $true) {
                            $locationList = $($asteroidFieldRaw.Keys)
                            $location = Get-Random -InputObject $locationList
                            $baseLoc = $newName+"-"+$location
                        } else {
                            $baseLoc = $newName
                        }
                        $metaData += "Criminal Bases in orbit of star in $newName`n"
                    
                        $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $baseLoc) | ConvertTo-Json
                        $metaData += "`n"
                    }
                }
                if ((Get-Random -Minimum 1 -Maximum 100) -in 1..66) {
                    $milBaseCount = (Get-Random -Minimum 1 -Maximum 3) -1
                    if ($milBaseCount -ge 1) {
                        Write-Host "Generating $baseCount military bases"
                        $metaData += "Miltary Bases in Orbit of star in $newName`n"
                        $metaData += $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" $milBaseCount) | ConvertTo-Json -Depth 3
                        $metaData += "`n"
                    }
                }
            }
        }
        Add-Content "$systemPath\$metaFile" $metaData
    }
    $graphics.Dispose()
    Write-Host "Saving Sector map $sectorDir"
    $starmapBmp.Save("$sectorDir\$sectorMapFilename")
}

Remove-Item "$htmlFiles\*" -Recurse -Force

#>

