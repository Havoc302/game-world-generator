# Civilisation generator






$planetOrbits = @((($html -split "`n" | select-string -Pattern "<TH>Distance from primary star</TH>") -replace "<TR>","" -replace "</TR>","" -replace "<TD>","" -replace "</TD>","" -replace "<TH>","" -replace "</TH>","" -replace "Distance from primary star","" -split "KM") | Select-String -Pattern "AU") -replace "AU","" -replace " ","" | Get-Unique
$hydrospheres = @(($html -split "`n" | Select-String -Pattern "Hydrosphere") -replace "<TR>","" -replace "<TH>","" -replace "</TR>","" -replace "</TH>","" -replace "<TD>","" -replace "</TD>","" -replace "Hydrosphere percentage","" | where {$_ -notmatch "0.0"}) -split "`n"