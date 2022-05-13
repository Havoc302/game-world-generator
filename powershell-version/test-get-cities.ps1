$cities = Get-Content -Path C:\Users\Havoc\Downloads\simplemaps_worldcities_basicv1.7\worldcities.csv

[System.Collections.ArrayList]$city_list = @()

$nonascii = '[^\x20-\x7F]'

foreach ($city in $cities) {
    $c = ($city -split ",")[0]+","
    if ($c -cnotmatch $nonascii) {
        $city_list.Add($c)
        $c
    }
}

$city_list | Out-File C:\Users\Havoc\Documents\Repos\game-world-generator\powershell-version\city_list.txt

$list = Invoke-WebRequest -Uri https://raw.githubusercontent.com/Havoc302/game-world-generator/main/powershell-version/city_list.txt?token=AB5DYIT7PP4L5A5FYP3T6BK7RGWEA

$1 = get-content C:\Users\Havoc\Downloads\cities.csv

$1.count