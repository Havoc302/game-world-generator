# Random organisation generator

$governmentTypeArray = "Government - Democratic Republic
Government - Constituional Republic
Government - Federal Republic
Government - People's Republic
Government - Direct Democracy
Government - Representative Democracy
Government - Constitutional Democracy
Government - Socialist
Government - Plutocracy
Government - Aristocracy
Government - Kraterocracy
Government - Consitutional Monarchy
Government - Absolute Monarchy
Government - Elective Monarchy
Government - Crowned Monarchy
Government - Theocracy
Government - Colonialst
Government - Totalitarian
Government - Stratocracy
Government - Technocracy
Government - Confederacy
Government - Federation
Government - Demarchy
Government - Timocracy
Government - Civilian Dictatorship
Government - Military Dictatorship
Government - Banana Republic
Government - Corporatocracy
Government - Bureacracy"

$governmentTypeArray = $governmentTypeArray -split "`n"

Get-Random -InputObject $governmentTypeArray