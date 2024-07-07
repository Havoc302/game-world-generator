function Create-Index {
    $index = Get-ChildItem -Path $systemsPath -Include "*.html" -Recurse | where {$_.DirectoryName -notmatch "ref"} | Select-Object -Property FullName,DirectoryName
    $indexHTML = ""
    foreach ($i in $index) {
        $dir = $i.FullName
        $dirName = $($i.DirectoryName -split "\\" | Select -Last 1)
        $indexHTML += "<a href=$dir>$dirName</a>`n"
    }

    $html = @"
    <!DOCTYPE html>
        <html>
        <head>
            <title>Systems Index</title>
            <style>
        </head>
        <body>
            <h1>Systems Index</h1>
        $indexHTML
        </body>
        </html>
"@
    $html | Out-File "$systemsPath\SystemsIndex.html"
    if ($uploadToAWS) {
        Write-Host "Writing $systemsPath\SystemsIndex.html to S3"
        Write-S3Object -BucketName "$bucketName/$systemLabel" -Credential $awsCreds -File "$systemsPath\SystemsIndex.html" -PublicReadOnly
    }
}