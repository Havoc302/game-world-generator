Write-Host "Loading function Create-SovereigntyScore" -BackgroundColor Gray -ForegroundColor Black

function Create-SovereigntyScore {
    $societyFiles = Get-ChildItem -Path $societyDataPath -Filter "*.json"
    $societyData = @{}
    Foreach ($file in $societyFiles) {
        $jsonData = Get-Content $file.FullName | Out-String | ConvertFrom-Json
        $faction = @{}
        $faction.Add("Name",$($jsonData.FactionName))
        $faction.Add("SovereigntyScore",$([math]::ROUND(($jsonData.EconomyScore*2) + ($jsonData.MilitaryScore*5) + ($jsonData.EducationScore/2) + ($jsonData.LeadershipScore/2) + ($jsonData.PopulationScore/2) + ($jsonData.TechnologyScore) + ($jsonData.UnityScore/2),0)))
        $societyData.add($faction.Name,$faction.SovereigntyScore)
    }

    $societyData = $societyData.GetEnumerator() | Sort-Object -Property Value -Descending

    return $societyData
}

Write-Host "Function Create-SovereigntyScore loaded." -BackgroundColor Green -ForegroundColor Black