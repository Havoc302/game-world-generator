# Space RP Game World Generator v2
# Starts by generating random systems with stellar map coordinates, if the system is habitable or not, if the system has a habitable planet with cities, a starbase, an asteroid base, or a base on an uninhabitable planet

Add-Type -AssemblyName System.Drawing

$getHomePath1 = $psISE.CurrentFile.FullPath -split "\\"
$getHomePath2 = $getHomePath1[0..($getHomePath1.Length -5)]
$homePath = ""
foreach ($t in $getHomePath2) {$homePath += "$t\"}

$ScriptPath = "$homePath\game-world-generator\powershell-version\generate-game-world"
$SoftwarePath = "$homePath\StarmapCreation\Software"
$htmlFiles = "$SoftwarePath\StarGen\html"
$stargenPath = "$SoftwarePath\StarGen\StarGen.exe"
$planetgenPath = "$SoftwarePath\Planets\planet.exe"
$systemsPath = "$homePath\StarmapCreation\StarSystems"
$systems = 5000 # total systems to create
$asteroidFieldChance = 12 # Percentage based

Set-Location $ScriptPath

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
    $asteroidFieldRaw = (& "$ScriptPath\generator-random-asteroids.ps1" "$systemName" "$asteroidCount")
    $asteroidField = $asteroidFieldRaw | ConvertTo-Json
    $asteroidFieldLoc = $(Get-Random $($planetOrbits.Count))
    $asteroidFieldLocText = "Asteroid belt between the orbit of planets $asteroidFieldLoc and $($asteroidFieldLoc+1)`n"
    return $asteroidFieldLocText,$asteroidField
}

########## Start sector map creation ##########

Copy-Item -Path "$SoftwarePath\StarGen\ref" -Destination $systemsPath -Recurse

foreach ($s in 1..$systems) {
        [hashtable]$SystemData = @{}
        $systemNum = '{0:d5}' -f $s
        $newName = "System_$systemNum"
        $SystemData.Add("System",$newName)
        Write-Host "Generating system $newName"
        # Getting star type, colour and name then writing it to the sector map
        $StarType = Get-StarType
        $StarColour = $StarType[0]
        $MapStarColour = [System.Drawing.Color]::$StarColour
        $SystemData.Add("Star Colour",$StarColour)

########## System Creation ##########

        write-Host "Starting Terrestrial system creation" -BackgroundColor Blue
        Set-Location "$SoftwarePath\StarGen"
        do {
            $mass = Get-Random -Minimum $starType[1] -Maximum $starType[2]
            $mass = $mass.ToString()
            Start-Process $stargenPath -ArgumentList "-m$mass -M" -Wait -NoNewWindow
            $starFileText = "$htmlFiles\$newName.txt"
            Start-Process $stargenPath -ArgumentList "-m$mass -M -t > $starFileText" -Wait -NoNewWindow
            Start-Sleep -Milliseconds 500
            $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
        } until ($starFile -ne $null)
        $html = Get-Content $starFile -Raw
        $htmlWeb = Invoke-WebRequest -Uri $starfile # -UseBasicParsing
        $SystemJSON = ConvertTo-Json $htmlWeb
        $currentSeed = (($html -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
        Write-Host "Current seed: $currentSeed"
        $currentName = "System $currentSeed - StarGen.exe $currentSeed-$mass"
        Write-Host "Current name: $currentName"
        Write-Host "New name: $newName"
        $currentFileLink = "StarGen.exe $currentSeed-$mass"
        $currentFileName = "StarGen.exe-$currentSeed-$mass"
        $html = $html -replace $currentName,$newName
        $html = $html -replace $currentFileName,$newName
        $html = $html -replace $currentFileLink,$newName
        $htmlObj = New-Object -Com "HTMLFile"
        $htmlObj.IHTMLDocument2_write($htmlWeb.RawContent)
        [array]$planetList = (($htmlObj.body.outerText) -split "`n" | Select-String -Pattern "Planet Type" -Context 1,0) -replace "Planet Type" -replace "Statistics" -replace ">"
        Set-Content "$htmlFiles\$newName.html" $html
        $metaFile = $newName+"_SystemData.txt"
        $terresCount = ($html -split "<" | Select-String -Pattern "TerrestrialPlanet.gif" | Group-Object).count
        $planetOrbits = @((($html -split "`n" | select-string -Pattern "<TH>Distance from primary star</TH>") -replace "<TR>","" -replace "</TR>","" -replace "<TD>","" -replace "</TD>","" -replace "<TH>","" -replace "</TH>","" -replace "Distance from primary star","" -split "KM") | Select-String -Pattern "AU") -replace "AU","" -replace " ","" | Get-Unique
        New-Item -ItemType Directory -Path $systemsPath -Name $newName
        Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath
        #Copy-Item -Path "$homePath\starmap_creation\Software\StarGen\ref" -Destination $systemPath -Recurse
        Copy-Item -Path "$homePath\starmap_creation\Software\Planets\biome_legend.png" -Destination $systemPath
}
            # Ends solar system creation
            <# Starts naming system
            if ($m -eq 1 -and ($coreWorlds.Count) -ne 0) {
                Write-Host "Creating core world" -BackgroundColor Blue
                $coreWorldCheck = $true
                $systemName = ($coreWorlds[0] -split ",")[0]
                $planetName = ($coreWorlds[0] -split ",")[1]
                $capitalCityName = ($coreWorlds[0] -split ",")[2] + " Landing"
                $SystemData += "System Name: $systemName`n"
                $SystemData += "1st Terrestrial Planet Name: $planetName`n"
                $capitalCity = & "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" "1" "Capital"
                $SystemData += $capitalCity | ConvertTo-Json -Depth 3
                $SystemData += "`n"
                $coreWorlds.Remove($coreWorlds[0])
            } elseif ($m -eq 1 -and ($coreWorlds.Count) -eq 0) {
                $coreWorldCheck = $false
                $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                $SystemData += "System Name: $systemName`n"
                $SystemData += "1st Terrestrial Planet Name: $planetName`n"
            } elseif ($m -in 2..7 -and ($coreWorlds.Count) -eq 0) {
                $coreWorldCheck = $false
                $claimed = (Get-Random -Minimum 1 -Maximum 101) -in 1..25
                if ($claimed -eq $true) {
                    $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $SystemData += "System Name: $systemName`n"
                    $SystemData += "1st Terrestrial Planet Name: $planetName`n"
                } else {
                    $SystemData += "System $newName unclaimed"
                }
            } else {
                $coreWorldCheck = $false
                $claimed = (Get-Random -Minimum 1 -Maximum 101) -in 1..3
                if ($claimed -eq $true) {
                    $systemName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $planetName = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
                    $SystemData += "System Name: $systemName`n"
                    $SystemData += "1st Terrestrial Planet Name: $planetName`n"
                } else {
                    $SystemData += "System $newName unclaimed"
                }
            }
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck`n"
            $SystemData += "Asteroid field in system: $asteroidFieldCheck`n"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $SystemData += $asteroidReturn[0]
                $SystemData += $asteroidReturn[1]
                $SystemData += "`n"
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
                    $SystemData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $SystemData += $cities | ConvertTo-Json -Depth 3
                    $SystemData += "`n"
                    $milBaseCount = Get-Random -Minimum 10 -Maximum 30 #100,300
                    Write-Host "Generating $milBaseCount military bases"
                    $SystemData += "Military Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $SystemData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $SystemData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 3 -Maximum 10) #30,100
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $SystemData += "Criminal Bases:`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $SystemData += "`n"
                        }
                    }
                } elseif ($m -eq 1 -and ((Get-Random -Minimum 1 -Maximum 101) -in 1..66)) {
                    Write-Host "Core world check: $coreWorldCheck"
                    $cityAmount = 10,20#25,200
                    $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                    Write-Host "Generating $cityCount cities"                        
                    $SystemData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $SystemData += $cities | ConvertTo-Json -Depth 3
                    $SystemData += "`n"
                    $milBaseCount = Get-Random -Minimum 20 -Maximum 100
                    Write-Host "Generating $milBaseCount military bases"
                    $SystemData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBaseLoc = Get-Random $locationList
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $SystemData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $SystemData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 12) -1
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $SystemData += "Criminal Bases in $newName`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random -InputObject $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $SystemData += "`n"
                        }
                    }
                } elseif ($m -in 2..6 -and (Get-Random -Minimum 1 -Maximum 100) -in 1..33 -or $claimed -eq $true) {
                    Write-Host "Core world check: $coreWorldCheck"
                    $cityAmount = 5,10#5,50
                    $cityCount = Get-Random -Minimum ($cityAmount[0]) -Maximum ($cityAmount[1])
                    Write-Host "Generating $cityCount cities"                        
                    $SystemData += "Cities found on habitable planet $p in $newName`n"
                    $cities = (& "$homePath\game-world-generator\powershell-version\generator-cities-and-towns.ps1" $cityCount)
                    $locationList += $($cities.Keys)
                    $SystemData += $cities | ConvertTo-Json -Depth 3
                    $SystemData += "`n"
                    $milBaseCount = (Get-Random -Minimum 1 -Maximum 7) -1
                    Write-Host "Generating $milBaseCount military bases"
                    $SystemData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
                    foreach ($mb in 1..$milBaseCount) {
                        $milBaseLoc = Get-Random -InputObject $locationList
                        $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                        $SystemData += $milBases | ConvertTo-Json -Depth 3
                    }
                    $SystemData += "`n"
                    $pirateBaseCount = (Get-Random -Minimum 1 -Maximum 15) -1
                    Write-Host "Generating $pirateBaseCount criminal bases" -BackgroundColor Red
                    if ($pirateBaseCount -ge 1) {
                        $SystemData += "Criminal Bases in $newName`n"
                        foreach ($pb in 1..$pirateBaseCount) {
                            $location = Get-Random -InputObject $locationList
                            $pirBaseLoc = $newName+"-"+$location
                            $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                            $SystemData += "`n"
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
            $metaFile = $newName+"_SystemData.txt"
            New-Item -ItemType Directory -Path "$sectorDir\non-terrestrial" -Name "$newName"
            $systemPath = "$sectorDir\non-terrestrial\$newName"
            $SystemData += "System: $newname`n"
            $SystemData += "Star Type: $colour`n"
            Move-Item -Path "$htmlFiles\$newName.html" -Destination $systemPath
            # Ends solar system creation								 
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $SystemData += $asteroidReturn[0]
                $SystemData += $asteroidReturn[1]
                $SystemData += "`n"
            }
            $milBaseCount = (Get-Random -Minimum 1 -Maximum 5) -1
            Write-Host "Generating $milBaseCount military bases"
            $SystemData += "Miltary Bases on or in Orbit of terrestrial planet $p in $newName`n"
            foreach ($mb in 1..$milBaseCount) {
                $milBaseLoc = Get-Random $locationList
                $milBases = $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" 1 $milBaseLoc)
                $SystemData += $milBases | ConvertTo-Json -Depth 3
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
                    $SystemData += "Criminal Bases:`n"
                    foreach ($pb in 1..$pirateBaseCount) {
                        $location = Get-Random -InputObject $locationList
                        $pirBaseLoc = $newName+"-"+$location
                        $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $pirBaseLoc) | ConvertTo-Json
                        $SystemData += "`n"
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
            $metaFile = $newName+"_SystemData.txt"
            $SystemData += "System: $newname`n"
            $SystemData += "Star Type: $colour`n"
            $asteroidFieldCheck = ((Get-Random -Minimum 1 -Maximum 101) -in ((1..$asteroidFieldChance)+1))
            Write-Host "Asteroid field in system: $asteroidFieldCheck"
            if ($asteroidFieldCheck -eq $true) {
                $asteroidReturn = Get-AsteroidField -SystemName $newName -PlanetOrbits $planetOrbits
                $locationList += $($asteroidFieldRaw.Keys)
                $SystemData += $asteroidReturn[0]
                $SystemData += $asteroidReturn[1]
                $SystemData += "`n"
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
                        $SystemData += "Criminal Bases in orbit of star in $newName`n"
                    
                        $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-criminal-bases-and-outposts.ps1" 1 $baseLoc) | ConvertTo-Json
                        $SystemData += "`n"
                    }
                }
                if ((Get-Random -Minimum 1 -Maximum 100) -in 1..66) {
                    $milBaseCount = (Get-Random -Minimum 1 -Maximum 4) -1
                    if ($milBaseCount -ge 1) {
                        Write-Host "Generating $baseCount military bases"
                        $SystemData += "Miltary Bases in Orbit of star in $newName`n"
                        $SystemData += $(& "$homePath\game-world-generator\powershell-version\generator-bases-and-outposts.ps1" $milBaseCount) | ConvertTo-Json -Depth 3
                        $SystemData += "`n"
                    }
                }
            }
        }
        Add-Content "$systemPath\$metaFile" $SystemData
        Remove-Item -Path "$htmlFiles\*" -Force
        Write-Host "########## $newName SYSTEM GENERATION COMPLETE ##########"
        Clear-Variable terresPlanetChance,nonTerresPlanetChance,locationList
    }
    $graphics.Dispose()
    Write-Host "Saving Sector map $sectorDir"
    $starmapBmp.Save("$sectorDir\$sectorMapFilename")
    }
    #>