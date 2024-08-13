Write-Host "Loading function New-NonPlanetarySystem" -BackgroundColor Gray -ForegroundColor Black

Function New-NonPlanetarySystem {
param($systemLabel,$systemDesignation,$xcoord,$ycoord,$starType,$starMass,$planetBool,$habitableBool,$uploadToAWS)
    $asteroidFieldBool = (Get-Random -Minimum 0 -Maximum 100) -in 0..12
    $html = @"
    <!DOCTYPE html>
        <html>
        <head>
            <title>System Information - $systemLabel</title>
            <style>
            table {
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid black;
                padding: 8px;
            }
            </style>
        </head>
        <body>
            <h1>System Information - $systemLabel</h1>
            <table>
            <tr>
                <th>System Name</th>
                <th>System Designation</th>
                <th>X Coordinate</th>
                <th>Y Coordinate</th>
                <th>Star Colour</th>
                <th>Star Mass</th>
                <th>Has Planets</th>
                <th>Habitable</th>
                <th>AsteroidField</th>
            </tr>
            <tr>
                <td>$systemLabel</td>
                <td>$systemDesignation</td>
                <td>$((($systemCoords) -split ",")[0])</td>
                <td>$((($systemCoords) -split ",")[1])</td>
                <td>$starType</td>
                <td>$starMass</td>
                <td>$planetBool</td>
                <td>$habitableBool</td>
                <td>$($asteroidFieldBool[0])</td>
            </tr>
            </table>
        </body>
        </html>
"@
    New-Item -ItemType Directory -Path $systemsPath -Name $systemLabel
    $html | Out-File "$systemsPath\$systemLabel\$systemLabel.html"
    if ($uploadToAWS) {
        Write-Host "Writing $systemsPath\$systemLabel\$systemLabel.html to S3"
        Write-S3Object -BucketName "$bucketName/$systemLabel" -Credential $awsCreds -File "$systemsPath\$systemLabel\$systemLabel.html" -PublicReadOnly
    }
    return $asteroidFieldBool
}

Write-Host "Function New-NonPlanetarySystem loaded." -BackgroundColor Green -ForegroundColor Black