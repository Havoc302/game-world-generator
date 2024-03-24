$empireSystemsArray = New-Object System.Collections.Generic.List[psobject]

# Go through every system in the System Array
foreach ($systemObj in $systemsArray) {
    
    if ($doEmpires) {
        # Create a temp array that excludes the current systemObj being checked
        $tempArray = $systemsArray | where {$_ -notmatch $systemObj}
        # If the systemObj being checked has a - in the name, meaning it's a settled and habitable system check start the checks
        if ($systemObj.SystemName -match "-") {
            write-host "System name: $($systemObj.SystemName)"
            # Iterate through each empire and check what systems are in range of each habitable based on their empire power
            foreach ($empire in $empireStats) {
                $inRangeSystems = New-Object System.Collections.Generic.List[psobject]
                $inRangeObj = @()
                $inRange = $null
                $empire[0]
                # Calculate the pixels range of influence each empire has
                $empirePower = [int]$empire[1]*30
                Write-Host "Empire power: $empirePower"
                # Iterate through each system in the temp array and check its distance from each habitable
                foreach ($systemC in $tempArray) {
                    # Boolean if it's in range or not
                    $inRange = Get-WithinRange -x1 $systemObj.XCoord -y1 $systemObj.YCoord -x2 $systemC.XCoord -y2 $systemc.YCoord -distanceThreshold $empirePower
                    # If it's in range add it to the array against this system
                    if ($inRange) {
                        Write-Host "System in range: $($systemC.SystemName)"
                        $inRangeSystems += $systemC.SystemName
                    }
                    $inRangeObj = [PSCustomObject]@{
                        "SourceSystem" = $systemObj.SystemName
                        "InRangeCount" = $inRangeSystems.count
                        "InRangeSystems" = $inRangeSystems
                        "Range" = $empirePower
                    }
                }
                $empireSystemsArray += $inRangeObj
            }
        }
    }
    "#####################################"
}

$empireSystemsArray | sort range