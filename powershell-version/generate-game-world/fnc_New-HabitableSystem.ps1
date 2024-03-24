function New-HabitableSystem {
param($StarMass,$StarName)
Set-Location ($stargenPath | Split-Path)
    $counter = 0
    do {
        Start-Process $stargenPath -ArgumentList "-m$StarMass -M -g -H" -Wait #-NoNewWindow
        Start-Sleep -Seconds 1
        $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
        if ($starFile) {
            $starFileTerresCheck = (Get-Content $starFile -Raw) -match "Terrestrial"
            Write-Host "System $starFileTerresCheck for habitable planets"
        } else {
            $starFileTerresCheck = $false
            Write-Host "System $starFileTerresCheck for habitable planets"
        }
        $counter++
        if ($counter -ge 5) {
            Write-Host $counter
            if ($StarMass -le 1) {
                $StarMass = $starMass + 0.02
            } elseif ($StarMass -ge 1) {
                $StarMass = $starMass - 0.02
            }
            Write-Host $StarMass
        }
        if ($starFileTerresCheck -ne $true) {
            Remove-Item "$htmlFiles\*" -Force
        }
    } until ($null -ne $starFile -and $starFileTerresCheck -eq $true)
    $html = Get-Content $starFile -Raw
    #$htmlWeb = Invoke-WebRequest -Uri $starfile -UseBasicParsing
    $hydrospheres = @(($html -split "`n" | Select-String -Pattern "Hydrosphere") -replace "<TR>","" -replace "<TH>","" -replace "</TR>","" -replace "</TH>","" -replace "<TD>","" -replace "</TD>","" -replace "Hydrosphere percentage","" | where {$_ -notmatch "0.0"}) -split "`n"
    $terresCount = ($html -split "<" | Select-String -Pattern "TerrestrialPlanet.gif" | Group-Object).count
    $asteroidBool = ($html | Select-String -Pattern "Asteroids.gif" -AllMatches).matches.count -ge 1
    $currentSeed = (($html -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
    $currentName = "StarGen.exe $currentSeed-$StarMass"
    $currentTitle = "System $currentSeed - $currentName"
    $currentFileName = "StarGen.exe-$currentSeed-$StarMass.html"
    $html = $html -replace $currentName,$StarName
    $html = $html -replace $currentFileName,$StarName
    $html = $html -replace $currentFileLink,$StarName
    #$htmlObj = New-Object -Com "HTMLFile"
    #$htmlObj.IHTMLDocument2_write($htmlWeb.RawContent)
    Set-Content "$htmlFiles\$StarName.html" $html
    New-Item -Path $systemsPath -ItemType Directory -Name $StarName
    Move-Item -Path "$htmlFiles\$StarName.html" -Destination $systemsPath\$StarName
    if ($uploadToAWS) {
        Write-Host "Writing $systemsPath\$StarName\$StarName.html to S3"
        Write-S3Object -BucketName "$bucketName/$StarName" -Credential $awsCreds -File "$systemsPath\$StarName\$StarName.html" -PublicReadOnly
    }
    Remove-Item $starFile -Force
    return $asteroidBool,$terresCount,$hydrospheres
}