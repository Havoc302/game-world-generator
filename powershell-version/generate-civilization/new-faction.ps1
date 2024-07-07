$factionsDir = 'I:\My Drive\TTRPG\Colonial Alliance RP Game\Colonial_Alliance_Game\StarmapCreation\Factions'

$newFaction = [pscustomobject]@{}

$headerList = "FactionName","SymbolDescription","LeadershipScore","LeadershipDescription","ElectionProcess","EconomyScore","EconomyDescription","MilitaryScore","MilitaryDescription","DiplomaticRelationships","ArchitecturalStyle","PopulationScore","Population","TechnologyScore","TechnologyLevel","Religion","History","Language","Government","ValuesAndEthics","SocialStructure","LegalSystem","EducationScore","EducationDescription","HealthCare","Infrastructure","NotableFigures","PopularSport","FreedomIndex","AIUse","Slavery","Unity","ConflictingInternalFaction","ResourceDependency","FoodDependency","ActiveWars","SpecialPublicHolidays"

foreach ($header in $headerList) {
    
    $value = Read-Host $header

    $newFaction | Add-Member -Name $header -Value $value -MemberType NoteProperty
}

$newFaction | ConvertTo-Json | Out-File "$factionsDir\$($newFaction.FactionName).json"