$apiReturn = Invoke-RestMethod -Uri https://countriesnow.space/api/v0.1/countries/population/cities

$names1 = ($apiReturn.Data.City | where {$_.Length -le 18 -and $_ -notmatch "\s\(\S*\)"}).count

$excludeList = "Municipality|District|County|Province|,|Shire|Prefecture|Islands|League|Constituency|\s\(\S*\)|\s\-\s|zone|area|department|/|banner|division|coast|sector"

$namesDB1 = ((Get-Content 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\city_names1.txt') -split "`r`n|`n|`r" |  Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and $_.Length -le 18 -and $_ -notmatch $excludeList}).Trim()

$namesDB2 = ((Get-Content 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\city_names2.txt') -split "`r`n|`n|`r" |  Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and $_.Length -le 18 -and $_ -notmatch $excludeList}).Trim()

$namesDB3 = ((Get-Content 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\city_names3.txt') -split "`r`n|`n|`r" |  Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and $_.Length -le 18 -and $_ -notmatch $excludeList}).Trim()

$systemNames = ($systemNames | Where-Object { -not [string]::IsNullOrWhiteSpace($_)}).Trim()

$namesDB = $namesDB1+$namesDB2+$namesDB3+$systemNames
<#
if ($namesDB.count -lt 1) {

    $namesDB.Add($(Invoke-RestMethod -Uri "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-all-cities-with-a-population-500/records?limit=100" | Select-Object -ExpandProperty Results | Select-Object -ExpandProperty name))

    foreach ($n in 1..99) {
        $n = $n * 100
        $n
        $namesDB.Add($(Invoke-RestMethod -Uri "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-all-cities-with-a-population-500/records?limit=100&offset=$n" | Select-Object -ExpandProperty Results | Select-Object -ExpandProperty name))
    }

    $namesDB2 = $namesDB | Where-Object {$_.length -le 18} | Sort

    foreach ($name in $namesDB2) {
        if ($($name -replace "\([^\)]+\)","").length -le 18) {
            $namesDB2 += $name -split "`n" 
        }
    }

    $namesDB2 += $systemNames

    $namesDB = $namesDB3 -replace "\([^\)]+\)","" | Sort | Group-Object | Select-Object -ExpandProperty Name

    $namesDB.count
}
#>
$namesDB.count

$namesDB = $namesDB | Group-Object | Select-Object -ExpandProperty Name | sort

$namesDB.count

$namesDB | Out-File 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\city_names_master.txt'

Get-Random -Count 20 -InputObject $namesDB