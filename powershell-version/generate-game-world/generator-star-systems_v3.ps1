﻿# Space RP Game World Generator v3
# Starts by generating random systems with stellar map coordinates, if the system is habitable or not, if the system has a habitable planet with cities, a starbase, an asteroid base, or a base on an uninhabitable planet
cls

Add-Type -AssemblyName System.Drawing

# Get the home directory for the script
$homePath = "I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game"

# Set the locations of required software and filepaths for the script to operate
$WorldScriptPath = "$homePath\game-world-generator\powershell-version\generate-game-world" # Where all the scripts are located
$systemsPath = "$homePath\StarmapCreation\StarSystems" # Where the finalised star system files will go on output
$softwarePath = "$homePath\StarmapCreation\Software" # Where all the software that runs the generation is located
$stargenPath = "$SoftwarePath\StarGen" # Root directory of the StarGen application required for all this to work. https://www.gryphel.com/c/sw/astro/stargen/
$stargenExePath = "$stargenPath\StarGen.exe" # StarGen Executable
$htmlFiles = "$stargenPath\html"
$refFilesDir = "$stargenPath\ref"
$planetgenPath = "$SoftwarePath\Planets\planet.exe"
$cityNameslist = "$homePath\game-world-generator\data\city_names_master.txt"

# Reset the world generation. Deletes all systems created
$redoGeneration = $true

# Create an Index file?
$createIndex = $true

# Open all the created Star System files in your default browser at end of generation?
$openSystemsOnEnd = $true

# Define the main starmap properties
$systemCount = 20 # star systems per map (sector) # Standard 5000
$systemCountVariation = 0 # how much to randomly vary the number or and down from system count *** Must be higher than 2 ***
$sectorNumber = "2" # What sector of space is this, purely for labelling the map
$gridDividers = 48 # How many grid lines to have on the map
$gridDividerPixels = 100 # How many pixels between each grid line
$buffer = 5 # Pixel buffer around the edges of the map image to place names

# Generation Customisation
$minimumHabitable = 5 # 0 will allow the generation to run compeletely random, must be equal to or more than the total list of first names
[System.Collections.ArrayList]$firstNames = @() # Define a list of names here that you want to exist as habitable systems, it'll use these first
$firstNamesOrderSequence = $true # Will use names in the order they appear in the list above. Change to $false if you'd like the script to randomly select the name from the list.

# Add Empire territory markers
$doEmpires = $true
$empireStats = @(("The Small Fart Empire","6"),("The Napolean Empire","12"),("The Conquerers","18")) # Defined as "empireName",EmpirePower # string,int

# Kanka details
$uploadToKanka = $false
$kankaCampaignURL = "https://kanka.io/api/1.0/campaigns/111078"
$kankaPANPath = "$homePath\kankaPANKey.txt"

# AWS details
$uploadToAWS = $false
$bucketName = "rpg-objects"
$awsProfileName = "rpg-stuff-profile"

$sleepTime = 3

################ END OF CUSTOMISABLE VARIABLES ################

# Include all the functions
. $WorldScriptPath\fnc_Get-DifferenceFromOptimal.ps1
. $WorldScriptPath\fnc_Get-StarLocation.ps1
. $WorldScriptPath\fnc_Get-StarName.ps1
. $WorldScriptPath\fnc_Get-StarType.ps1
. $WorldScriptPath\fnc_Get-WithinRange.ps1
. $WorldScriptPath\fnc_New-HabitableSystem.ps1
. $WorldScriptPath\fnc_New-NonPlanetarySystem.ps1
. $WorldScriptPath\fnc_New-PlanetaryUninhabitableSystem.ps1

# Names to use when naming star systems which are claimed
[System.Collections.ArrayList]$systemNames = Get-Content $cityNameslist

if ($uploadToAWS) {
    Import-Module AWSPowershell
}

$kankaPANkey = Get-Content $kankaPANPath

if (!(Test-Path $WorldScriptPath)) {Write-Host "generate-game-world folder not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $SoftwarePath)) {Write-Host "Software folder not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $htmlFiles)) {Write-Host "StarGen HTML folder not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $stargenExePath)) {Write-Host "StarGen executable not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $planetgenPath)) {Write-Host "Planet Generator executable not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $systemsPath)) {Write-Host "Location where to output created star systems files not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if (!(Test-Path $refFilesDir)) {Write-Host "reference files StarGen uses in its HTML files not detected or defined correctly" -BackgroundColor Red -ErrorAction Stop}
if ($uploadToKanka -eq $true -and $kankaCampaignURL -eq "") {Write-Host "Kanka campaign URL missing" -BackgroundColor Red -ErrorAction Stop}
if ($uploadToAWS -eq $true -and $bucketName -eq "") {Write-Host "S3 Bucket name missing" -BackgroundColor Red -ErrorAction Stop}

# colour values for the biomes where we can put settlements created on the planet maps generated by planet.exe
$okBiomes = "210210210","250215165","105155120","220195175","225155100","155215170","170195200","185150160","130190025","110160170"# Tundra, Grasslands, Taiga, Desert, Savanna, Temperate Forest, Temperate Rainforest, Xeric Shrubland and Dry Forest, Tropical Dry Forest, Tropical Rainforest

# Gets AWS credentials
$awsCreds = Get-AWSCredential -ProfileName $awsProfileName

# Uploading StarGen reference files to the bucket
if ($uploadToAWS) {
    $refFiles = Get-ChildItem $refFilesDir/*
    $refCheck = ((Get-S3Object -BucketName "$bucketName" -Credential $awsCreds | where {$_.Key -match "ref"}).count) -ge 0
    if (!$refCheck) {
        foreach ($refFile in $refFiles) {
            $refFilePath = Join-Path $refFile.Directory $refFile.Name
            $refFilePath
            Write-S3Object -BucketName "$bucketName/ref" -Credential $awsCreds -PublicReadOnly -File $refFilePath
        }
    }
}

# Sets the map size in pixels
[int]$masterMapSizeX = $gridDividers*$gridDividerPixels+2 # map file pixel width
[int]$masterMapSizeY = $masterMapSizeX # map file pixel height

# Clears all the world data created
if ($redoGeneration) {
    Write-Host "Redoing generation. Clearing previous files."
    $headers = @{
        'Authorization'="Bearer $kankaPANkey"
    }
    # Remove local files
    Write-Host "Removing local files"
    Remove-Item -Path "$systemsPath\*" -Recurse -Force
    Remove-Item -Path "$htmlFiles\*" -Recurse -Force
    # Copy the requires files for the new HTML pages created
    Write-Host "Copying reference files into the Star system destination directory so html pictures work"
    Copy-Item -Path $refFilesDir -Destination $systemsPath -Recurse
    if ($uploadToAWS) {
        # Get the list of files in the S3 bucket which aren't the ref folder and delete them
        Write-Host "Removing S3 files"
        Get-S3Object -BucketName "$bucketName" -Credential $awsCreds | where {$_.Key -notmatch "ref"} | Remove-S3Object -Credential $awsCreds -Force
    }
    if ($uploadToKanka) {
        # Get the ID's of any map sectors added to Kanka
        Write-Host "Removing Kanka files"
        $kankaMapEntityID = ((Invoke-RestMethod -Uri "$kankaCampaignURL/entities" -Method GET -Headers $headers -UseBasicParsing -ContentType "application/json").data  | where {$_.name -match "$sectorName"}).id
        # Delete all the map files attached to those sectors in Kanka
        if ($kankaMapEntityID) {Invoke-RestMethod -Uri "$kankaCampaignURL/entities/$kankaMapEntityID/image" -Method DELETE -Headers $headers -UseBasicParsing -ContentType "application/json"}
        # Get the ID of the map in Kanka
        $kankaMapID = (Invoke-RestMethod -Uri "$kankaCampaignURL/maps" -Method GET -Headers $headers -UseBasicParsing -ContentType "application/json").data.id
        # Delete the map in Kanka
        if ($kankaMapID) {Invoke-RestMethod -Uri "$kankaCampaignURL/maps/$kankaMapID" -Method DELETE -Headers $headers -UseBasicParsing -ContentType "application/json"}
        # Get a list of locations added to Kanka
        $kankaLocationIDs = (Invoke-RestMethod -Uri "$kankaCampaignURL/locations" -Method GET -Headers $headers -UseBasicParsing -ContentType "application/json").data.id
        # Delete all the locations added to Kanka
        foreach ($locationID in $kankaLocationIDs) {
            Invoke-RestMethod -Uri "$kankaCampaignURL/locations/$locationID" -Method DELETE -Headers $headers -UseBasicParsing -ContentType "application/json"
            Start-Sleep -Seconds $sleepTime
        }
    }
}

# Generate star system base values
$systemsCoordArray = @()
$systemsArray = New-Object System.Collections.Generic.List[psobject]

if ($redoGeneration) {
    
    # Make sure the requested systems count actually matches up
    if ($minimumHabitable -lt $firstNames.count) {
        Write-Host "Minimum number of habitable systems requested is lower than the count of habitable planet names." -BackgroundColor Red -ForegroundColor Yellow
        $minHabCheck = Read-Host "Number of Habitable System names is higher than Minimum Habitable system count, do you wish to set Minimum Habitable system count to match count of names? Y/N"
        if ($minHabCheck -match "Y") {
            $minimumHabitable = $firstNames.count
            Write-Host "Generating $minimumHabitable habitable systems"
        }
    }

    if ($systemCount -lt $minimumHabitable) {
        Write-Host "Minimum number of habitable systems is lower than the total System count requested." -BackgroundColor Red -ForegroundColor Yellow
        $minSysCheck = Read-Host "Total number of Systems is lower than the minimum habitable system requested. Do you wish to set total System count to match Minimum Habitable? Y/N"
        if ($minSysCheck -match "Y") {
            $systemCount = $minimumHabitable
        }
    }

    if ($systemCountVariation -ge 2) {
        $systemCountFinal = Get-Random -Minimum ($systemCount-$systemCountVariation) -Maximum ($systemCount+$systemCountVariation)
    } else {
        $systemCountFinal = $systemCount
    }
    Write-Host "Commencing generation for $systemCountFinal systems"
    foreach ($systemCount in 1..$systemCountFinal) {
        Write-Host "Generating system $systemCount"
        $systemCoords = Get-StarLocation -MapSizeX $masterMapSizeX -MapSizeY $masterMapSizeY
        $systemsCoordArray += "$systemCoords"
        [string]$systemNum = $($systemCoords) -replace ","
        $systemDesignation = ($sectorNumber+"_"+('{0:d4}' -f $systemCount))

        # Set if there's going to be planets and if they're habitable.
        if ($minimumHabitable -ge 1) {
            # 100% sets up a system with planets that are habitable. Will keep generating these until mininumHabitables have been reached
            $starType = Get-StarType -habitable $true
            $starMass = [math]::Round($starType[1],5)
            $planetBool = $true
            $habitableBool = $true
        } else {
            # Leaves the chances of a planet to a completely random chance
            $starType = Get-StarType
            $starMass = [math]::Round($starType[1],5)
            $planetBool = ((Get-Random -Minimum 0 -Maximum 100) -in 0..($starType[2]))
            if ($planetBool) {
                # Leaves the chances of a planet to a completely random chance
                $habitableBool = ((Get-Random -Minimum 0 -Maximum 100) -in 0..($starType[3]))
            } else {
                $habitableBool = $false
            }
        }
            
        # If the RNG brings out a system that's got planets does some RNG to see if they're habitable
        
        # Names the system
        if ($habitableBool -eq $True) {
            $systemName = Get-StarName
            $systemLabel = $systemName + "-" + $sectorNumber + "_" + ('{0:d4}' -f $systemCount)
        } else {
            $systemLabel = $sectorNumber + "_" + ('{0:d4}' -f $systemCount)
        }
        # Generating system with no planets
        if (!$planetBool) {
            Write-Host "Generating non-planetary system $systemLabel with stellar mass of $starMass"
            $nonPlanetaryReturn = New-NonPlanetarySystem -systemLabel $systemLabel -systemDesignation $systemDesignation -xcoord (($systemCoords) -split ",")[0] -ycoord (($systemCoords) -split ",")[1] -starType $($starType[0]) -starMass $starMass -planetBool $planetBool -habitableBool $habitableBool -uploadToAWS $uploadToAWS
            $hydrosphere = 0
        }
        # Generate system with planets and a habitable
        if ($planetBool -eq $true -and $habitableBool -eq $true) {
            Write-Host "Generating habitable system $systemLabel with stellar mass of $starMass"
            $habitablePlanetReturn = New-HabitableSystem -StarMass $starMass -StarName $systemLabel
            $hydrosphere = $habitablePlanetReturn[3]
            $asteroidFieldBool = $habitablePlanetReturn[0]
            $minimumHabitable--
        }
        # Generate system with planets but no habitable
        if ($planetBool -eq $true -and $habitableBool -eq $false) {
            Write-Host "Generating planetary uninhabitable system $systemLabel with stellar mass of $starMass"
            $asteroidFieldBool = New-PlanetaryUninhabitableSystem -StarMass $starMass -StarName $systemLabel
            $hydrosphere = 0
        }
        $systemURL = "https://$bucketName.s3.amazonaws.com/$systemLabel/$systemLabel.html"
        
        if ($systemName -match "") {
            $systemName = $systemLabel
        }

        $starSystemObj = [PSCustomObject]@{
            "SystemName" = $systemName
            "SystemDesignation" = $systemDesignation
            "XCoord" = (($systemCoords) -split ",")[0]
            "YCoord" = (($systemCoords) -split ",")[1]
            "StarColour" = $starType[0]
            "StarMass" = $starMass
            "Planets" = $planetBool
            "Habitable" = $habitableBool
            "Hydrospere" = $hydrosphere
            "AsteroidField" = $asteroidFieldBool[1]
            "SystemURL" = $systemUrl
        }
        if ($habitableBool) {
            $starSystemObj | Add-Member -Type NoteProperty -Name HabitableCount -Value $($asteroidFieldBool[2])
            $starSystemObj | Add-Member -Type NoteProperty -Name Hydrosphere -Value $($asteroidFieldBool[3])
        }
        $systemsArray.Add($starSystemObj)
    }
}

### Initialise map creation ###
$masterMapBmp = new-object System.Drawing.Bitmap $masterMapSizeX,$masterMapSizeY
$masterMapBrushBg = [System.Drawing.Brushes]::Black
$fontMapNum = new-object System.Drawing.Font "Lucida Sans",8
$fontStarNum = new-object System.Drawing.Font "Lucida Sans",7
$masterMapGraphics = [System.Drawing.Graphics]::FromImage($masterMapBmp)
$masterMapGraphics.FillRectangle($masterMapBrushBg,0,0,$masterMapBmp.Width,$masterMapBmp.Height)
$masterMapBrushTitle = [System.Drawing.Brushes]::White
$masterMapFileName = "Sector_$sectorNumber`_Starmap.jpg"

# Draw the map gridlines first so they're overwritten easily
$gridPen = New-Object System.Drawing.Pen DarkSlateGray
$masterMapGraphics.DrawLine($gridPen,0,0,0,$masterMapSizeX)
$masterMapGraphics.DrawLine($gridPen,0,0,$masterMapSizeY,0)

foreach ($xGridLine in 2..$gridDividers) {
    if ($xGridLine -eq 2) {
        $linePosIterationX = 1+$gridDividerPixels
        $masterMapGraphics.DrawLine($gridPen,$linePosIterationX,0,$linePosIterationX,$masterMapSizeX)
    }
    $linePosIterationX = $linePosIterationX+$gridDividerPixels
    $masterMapGraphics.DrawLine($gridPen,$linePosIterationX,0,$linePosIterationX,$masterMapSizeX)
}

foreach ($yGridline in 2..$gridDividers) {
    if ($yGridline -eq 2) {
        $linePosIterationY = 1+$gridDividerPixels
        $masterMapGraphics.DrawLine($gridPen,0,$linePosIterationY,$masterMapSizeY,$linePosIterationY)
    }
    $linePosIterationY = $linePosIterationY+$gridDividerPixels
    $masterMapGraphics.DrawLine($gridPen,0,$linePosIterationY,$masterMapSizeY,$linePosIterationY)
}

# Draw the master map label
$sectorName = "Sector: $sectorNumber"
$masterMapGraphics.DrawString($sectorName,$fontMapNum,$masterMapBrushTitle,10,10)
$masterMapGraphics.DrawString("Scale: 1 square = 1 lt-mo",$fontMapNum,$masterMapBrushTitle,10,28)

# Fill the starmap with star system locations and set label locations
foreach ($systemObj in $systemsArray) {
    <#foreach ($empire in $empireStats) {
        $empirePower = [int]$empire[1]*75
        if ($doEmpires) {
            foreach ($systemC in $systemsArray) {
                $inRange = Get-WithinRange -x1 $systemObj.XCoord -y1 $systemObj.YCoord -x2 $systemC.XCoord -y2 $systemc.YCoord -distanceThreshold $empirePower
                if ($inRange) {$systemC.SystemName}
        
            }
        }
    }
    #>
    $brushFg = [System.Drawing.Brushes]::($systemObj.StarColour)
    $starColour = [System.Drawing.Color]::($systemObj.StarColour)
    $labelWidth = $($systemObj.SystemName).length * 5 + 4
    [int]$xPos = $systemObj.XCoord
    [int]$yPos = $systemObj.YCoord
    $masterMapBmp.SetPixel($xPos,$yPos,$starColour)
    if (($xPos+$labelWidth) -ge $masterMapSizeX) {
        $xTextPos = ($xPos-($labelWidth))
        $yTextPos = $yPos
    } else {
        $xTextPos = $xPos
    }
    if (($yTextPos+6) -ge $masterMapSizeY) {
        $yTextPos = ($yPos-$buffer)
    } else {
        $yTextPos = $yPos
    }
    if (($yPos) -le 6) {
        $yTextPos = ($yPos+$buffer)
    } else {
        $yTextPos = $yPos
    }
    [string]$graphicsText = $systemObj.SystemName
    [int]$xTextPos = $xTextPos+1
    [int]$yTextPos = $yTextPos-6
    $masterMapGraphics.DrawString($graphicsText,$fontStarNum,$brushFg,$xTextPos,$yTextPos)
}

$masterMapGraphics.Dispose()
$masterMapBmp.Save("$systemsPath\$masterMapFileName")

$systemsArray | ConvertTo-Json | Out-File -FilePath "$systemsPath\StarSystems.json"

Start-Process "$systemsPath\$masterMapFileName"

# Upload everything to Kanka
if ($uploadToKanka) {

    $headers = @{
        'Authorization'="Bearer $kankaPANkey"
    }

    $mapBody = @{
        'name' = "$sectorName"
        'type'='Starmap'
        'center_x'="$($masterMapSizeX/2)"
        'center_y'="$($masterMapSizeY/2)"
    } | ConvertTo-Json

    $kankaMapEntityID = ((Invoke-RestMethod -Uri "$kankaCampaignURL/entities" -Method GET -Headers $headers -UseBasicParsing -ContentType "application/json").data  | where {$_.name -match "$sectorName"}).id

    $kankaCheckMap = ($kankaMapEntityID -ge 1)

    if (!($kankaCheckMap)) {
        Invoke-RestMethod -Uri "$kankaCampaignURL/maps" -Method POST -Headers $headers -UseBasicParsing -ContentType "application/json" -Body $mapBody
    }
    
    $mapFilePath = "$systemsPath\$masterMapFileName"
    $client = New-Object System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", $kankaPANkey)
    $fileBytes = [System.IO.File]::ReadAllBytes($mapFilePath)

    if ($fileBytes) {
        $stream = New-Object System.IO.MemoryStream
        $stream.Write($fileBytes, 0, $fileBytes.Length)
        $stream.Seek(0, 'Begin')

        $fileContent = New-Object System.Net.Http.StreamContent -ArgumentList $stream
        $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
    
        $formData = New-Object System.Net.Http.MultipartFormDataContent
        $formData.Add($fileContent, "image", (Split-Path $mapFilePath -Leaf))
    
        $response = $client.PostAsync("$kankaCampaignURL/entities/$kankaMapEntityID/image", $formData).Result
    } else {
        Write-Host "Failed to read file: $mapFilePath"
    }
    
    $kankaMapID = ((Invoke-RestMethod -Uri "$kankaCampaignURL/maps" -Method GET -Headers $headers -UseBasicParsing -ContentType "application/json").data  | where {$_.name -match "$sectorName"}).id

    foreach ($system in $systemsArray) {
        $location = @{
                "name" = $($system.SystemName)
                "type"= $($system.SystemURL)
                "is_private" = $false
        } | ConvertTo-Json
        $locationEntityID = (Invoke-RestMethod -Uri "$kankaCampaignURL/locations" -Method POST -Headers $headers -UseBasicParsing -ContentType "application/json" -Body $location).data.id
        $colour = [drawing.color]"$($system.StarColour)"
        $colourARGB = "0x"+"{0:x}" -f $colour.ToArgb()
        $hexColor = '#' + ($colourARGB -band 0xFFFFFF).ToString('X6')
        $marker = @{
                "name" = $($system.SystemName)
                "map_id"= $kankaMapID
                "latitude" = $($system.XCoord)
                "longitude" = $($system.YCoord)
                "shape_id" = 1
                "icon" = 1
                "visibility_id" = 1
                "colour" = $hexColor
                "font_colour" = $hexColor
                "size_id" = 1
                "circle_radius" = 1
                "entity_id" = $locationEntityID
                "entry" = $($system.SystemURL)
        } | ConvertTo-Json
        Invoke-RestMethod -Uri "$kankaCampaignURL/maps/$kankaMapID/map_markers" -Method POST -Headers $headers -UseBasicParsing -ContentType "application/json" -Body $marker
        Start-Sleep -Seconds $sleepTime
        Write-Host "Sleeping to prevent reaching API limits" -BackgroundColor Yellow -ForegroundColor Black
    }
}

if ($createIndex) {
    . $WorldScriptPath\fnc_Create-Index.ps1
    Create-Index
}

if ($openSystemsOnEnd) {
    foreach ($i in $(Get-ChildItem 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\StarmapCreation\StarSystems' -Recurse | where {$_.Extension -match "html" -and $_.Name -notmatch "key"} | Select-Object -ExpandProperty FullName)) {
        Start-Process $i
    }
}