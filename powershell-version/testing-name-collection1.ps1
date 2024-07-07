$files = Get-ChildItem F:\Downloads\names -File

$firstNames = @()

Foreach ($file in $files) {
    $firstNames += Get-Content $file.FullName
}

$maleFirstNames = $firstNames | where {$_ -match ",M,"} | ForEach-Object {$_.Split(",") | Select-Object -First 1} | Group-Object | Select-Object -ExpandProperty Name

$femaleFirstNames = $firstNames | where {$_ -match ",F,"} | ForEach-Object {$_.Split(",") | Select-Object -First 1} | Group-Object | Select-Object -ExpandProperty Name

Clear-Variable firstNames

$maleFirstNames | sort | Out-File 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\game-world-generator\data\maleFirstNames.txt'

$femaleFirstNames | sort | Out-File 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\game-world-generator\data\femaleFirstNames.txt'