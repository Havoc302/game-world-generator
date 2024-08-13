Write-Host "Loading function Get-SovereigntyRanges" -BackgroundColor Gray -ForegroundColor Black

# Function to check if two points are within a certain distance of each other
function Get-WithinRange {
    param (
        [int]$x1,
        [int]$y1,
        [int]$x2,
        [int]$y2,
        [int]$distanceThreshold
    )

    # Calculate squared distance for better performance
    $squaredDistance = ($x2 - $x1) * ($x2 - $x1) + ($y2 - $y1) * ($y2 - $y1)
    
    # Use squared distance comparison for accuracy
    return $squaredDistance -le ($distanceThreshold * $distanceThreshold)
}

# Function to find the coordinate with the most other coordinates within range
function Get-SovereigntyRanges {
    param (
        [array]$systems,
        [int]$distanceThreshold
    )

    # Initialize variables to store the best system and its count
    $bestSystem = $null
    $maxPointsWithinRange = 0
    $systemsWithinRange = @()

    # Iterate through each system that has a word in its SystemName
    foreach ($system1 in $systems | Where-Object { $_.SystemName -match '[a-zA-Z]' }) {
        Write-Host "Processing system: $($system1.SystemName)" -ForegroundColor Cyan
        # Count the number of systems within range of $system1
        $currentSystemsWithinRange = @($system1)
        foreach ($system2 in $systems) {
            if ($system1 -ne $system2) {
                if (Get-WithinRange -x1 $system1.XCoord -y1 $system1.YCoord -x2 $system2.XCoord -y2 $system2.YCoord -distanceThreshold $distanceThreshold) {
                    Write-Host "System $($system2.SystemName) is within range of $($system1.SystemName)" -ForegroundColor Yellow
                    $currentSystemsWithinRange += $system2
                }
            }
        }

        # Update best system if this system has more points within range
        if ($currentSystemsWithinRange.Count -gt $maxPointsWithinRange) {
            Write-Host "System $($system1.SystemName) has $($currentSystemsWithinRange.Count) systems within range." -ForegroundColor Green
            $maxPointsWithinRange = $currentSystemsWithinRange.Count
            $bestSystem = $system1
            $systemsWithinRange = $currentSystemsWithinRange
        } else {
            Write-Host "System $($system1.SystemName) has fewer systems within range than the current best." -ForegroundColor Red
        }
    }

    # Return the best system and the systems within its range
    return @{
        BestSystem = $bestSystem
        SystemsWithinRange = $systemsWithinRange
    }
}

Write-Host "Function Get-SovereigntyRanges loaded." -BackgroundColor Green -ForegroundColor Black
