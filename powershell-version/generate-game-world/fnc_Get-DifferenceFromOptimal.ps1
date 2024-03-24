function Get-DifferenceFromOptimal {
    param(
        [double] $value
    )

    $optimal = 50
    $difference = [Math]::Abs($value - $optimal)
    return $difference
}