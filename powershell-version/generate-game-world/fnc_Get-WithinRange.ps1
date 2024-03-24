# Function to check if two points are within a certain distance of each other
function Get-WithinRange {
    param (
        [int]$x1,
        [int]$x2,
        [int]$y1,
        [int]$y2,
        [int]$distanceThreshold
    )
  # Calculate squared distance for better performance
  $squaredDistance = ($x2 - $x1) * ($x2 - $x1) + ($y2 - $y1) * ($y2 - $y1)
  # Use squared distance comparison for accuracy
  return $squaredDistance -le ($distanceThreshold * $distanceThreshold)
}