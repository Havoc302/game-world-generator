function New-HabitableSystem {
param($StarName,$StarMass)
Set-Location $stargenPath
    $counter = 0
    do {
        Start-Process $stargenExePath -ArgumentList "-m$StarMass -M -g -H" -Wait #-NoNewWindow
        Start-Sleep -Seconds 1
        $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
        if ($starFile) {
            $htmlRaw = Get-Content $starFile -Raw
            $starFileTerresCheck = $htmlRaw -match "Terrestrial"
            if ($starFileTerresCheck) {
                Write-Host "System $starFileTerresCheck for habitable planets"
            } else {
                $starFileTerresCheck = $false
                Write-Host "System $starFileTerresCheck for habitable planets"
            }
        } else {
            $starFileTerresCheck = $false
            Write-Host "No system HTML file found"
        }
        $counter++
        if ($counter -ge 5) {
            Write-Host $counter
            if ($StarMass -le 1) {
                $StarMass = $starMass + (Get-Random -Minimum 0.0001 -Maximum 0.02)
            } elseif ($StarMass -ge 1) {
                $StarMass = $starMass - (Get-Random -Minimum 0.0001 -Maximum 0.02)
            }
            Write-Host $StarMass
        }
        if ($starFileTerresCheck -ne $true) {
            Remove-Item "$htmlFiles\*" -Force
        }
    } until ($null -ne $starFile -and $starFileTerresCheck -eq $true)
    $hydrospheres = @(($htmlRaw -split "`n" | Select-String -Pattern "Hydrosphere") -replace "<TR>","" -replace "<TH>","" -replace "</TR>","" -replace "</TH>","" -replace "<TD>","" -replace "</TD>","" -replace "Hydrosphere percentage","" | where {$_ -notmatch "0.0"}) -split "`n"
    $terresCount = ($htmlRaw -split "<" | Select-String -Pattern "TerrestrialPlanet.gif" | Group-Object).count
    $asteroidBool = ($htmlRaw | Select-String -Pattern "Asteroids.gif" -AllMatches).matches.count -ge 1
    $currentSeed = (($htmlRaw -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]

    # Replace the HTML title name (the one that appears on the browser tab)
    $currentHTMLTitle = (($htmlRaw -split "`n" | Select-String -Pattern "System $currentSeed - StarGen.exe $currentSeed-[\d-\.]") -replace "<TITLE>","" -replace "</TITLE>","").trim()
    $htmlraw = $htmlRaw -replace $currentHTMLTitle,$systemLabel

    # Replace the name at the top of the page
    $currentPageTitle = ($htmlRaw -split "`n" | Select-String -Pattern 'StarGen\.exe \d+-\d+\.\d+').Matches.Value
    $htmlRaw = $htmlRaw -replace ".html'>$currentPageTitle</A>",".html'>$systemLabel</A>"
    
    # Change the links within the page that point to the file name to be the new one
    $currentFileName = ($htmlRaw -split "`n" | Select-String -Pattern 'StarGen\.exe-\d+-\d+\.\d+\.html').Matches.Value
    $htmlRaw = $htmlRaw -replace $currentFileName,"$systemLabel.html"

    # Set all that information into a new HTML file at the new location with the new name
    Set-Content "$htmlFiles\$systemLabel.html" $htmlRaw
    New-Item -Path $systemsPath -ItemType Directory -Name $systemLabel
    Move-Item -Path "$htmlFiles\$systemLabel.html" -Destination $systemsPath\$systemLabel
    if ($uploadToAWS) {
        Write-Host "Writing $systemsPath\$systemLabel\$systemLabel.html to S3"
        Write-S3Object -BucketName "$bucketName/$systemLabel" -Credential $awsCreds -File "$systemsPath\$systemLabel\$systemLabel.html" -PublicReadOnly
    }
    # Remove the old file
    Remove-Item $starFile -Force
    return $asteroidBool,$terresCount,$hydrospheres
}


$line = "<FONT SIZE='+2' COLOR='#000000'><A HREF='../html/StarGen.exe-18630-1.01921.html'>StarGen.exe 18630-1.01921</A></FONT></TH></TR>"

# Use a regular expression to match the desired part
if ($line -match 'StarGen\.exe \d+-\d+\.\d+') {
    $matchedText = $matches[0]
    Write-Output $matchedText
}