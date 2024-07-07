function New-PlanetaryUninhabitableSystem {
param($StarMass,$StarName)
Set-Location ($stargenPath | Split-Path)
    $counter = 0
    do {
        Start-Process $stargenPath -ArgumentList "-m$StarMass -M -g" -Wait -NoNewWindow
        Start-Sleep -Seconds 1
        $starFile = (Get-ChildItem $htmlFiles -Filter "*.html").FullName | Sort-Object -Property LastWriteTime | Select-Object -Last 1
        $starFileTerresCheck = (Get-Content $starFile -Raw) -match "Terrestrial"
        Write-Host "System $starFileTerresCheck for habitable planets"
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
        if ($starFileTerresCheck -eq $true) {
            Remove-Item "$htmlFiles\*" -Force
        }
    } until ($starFile -ne $null -and $starFileTerresCheck -eq $false)
    $htmlraw = Get-Content $starFile -Raw
    # Replace the HTML title name (the one that appears on the browser tab)
    $currentSeed = (($htmlRaw -split "`n" | Select-String -Pattern "System *") -split ">" -split "-" -split " " -split "<")[3]
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
    return $asteroidBool
}