# Random event generator

$list = "Backpack - small
Backpack - large
Bottle - steel - 1 lt
Bottle - glass - 1 lt
Box - cardboard - small - 10x10x10 cm
Box - cardboard - medium - 25x25x25 cm
Box - cardboard - large - 50x50x50 cm
Box - steel - small - 10x10x10 cm
Box - steel - medium - 25x25x25 cm
Box - steel - large - 50x50x50 cm
Sealed box - steel - small - 10x10x10 cm
Sealed box - steel - medium - 25x25x25 cm
Sealed box - steel - large - 50x50x50 cm
Sealed secure box - steel - small - 10x10x10 cm - simple (-3) lock
Sealed secure box - steel - medium - 25x25x25 cm - simple (-3) lock
Sealed secure box - steel - large - 50x50x50 cm - simple (-3) lock
Sealed secure box - steel - small - 10x10x10 cm - complex (-6) lock
Sealed secure box - steel - medium - 25x25x25 cm - complex (-6) lock
Sealed secure box - steel - large - 50x50x50 cm - complex (-6) lock
Bucket with handle - metal - 10 lt
Cask - wood - 10 lt
Cask - wood - 20 lt
Cask - wood - 30 lt
Bottle - plain - metal
Bottle - plain - ceramic
Bottle - fancy - metal
Bottle - fancy - ceramic
Flask - small - 250ml - filled
Flask - large - 500ml - filled
Flask - small - 250ml - empty
Flask - large - 500ml - empty
Jar - glass - 500ml
Jar - glass - 1 lt
Jar - glass - 2 lt
Cloth bag - small
Cloth bag - large
Purse - belt - leather - small
Purse - belt - leather - large
Purse - pocket - leather - small
Purse - pocket - leather - medium
Purse - pocket - leather - large
Purse - shoulder - leather - small
Purse - shoulder - leather - medium
Purse - shoulder - leather - large
Messenger bag- cloth - small
Messenger bag- cloth - medium
Messenger bag- cloth - large
Duffel bag- cloth - large
Secure info chip case - metal - small - 5x5x2 cm - simple (-3) lock
Secure info chip case - metal - medium - 10x10x5 cm - simple (-3) lock
Secure info chip case - metal - large - 20x10x10 cm - simple (-3) lock
Secure info chip case - metal - small - 5x5x2 cm - complex (-6) lock
Secure info chip case - metal - medium - 10x10x5 cm - complex (-6) lock
Secure info chip case - metal - large - 20x10x10 cm - complex (-6) lock
Secure medical case - small - 5x5x2 cm - simple (-3) lock
Secure medical case - medium - 10x10x5 cm - simple (-3) lock
Secure medical case - large - 20x10x10 cm - simple (-3) lock
Secure medical case - small - 5x5x2 cm - complex (-6) lock
Secure medical case - medium - 10x10x5 cm - complex (-6) lock
Secure medical case - large - 20x10x10 cm - complex (-6) lock
Trunk - metal - small - 50x50x50 cm
Trunk - metal - medium - 1x1x1 m
Trunk - metal - large - 2x2x2 m
Secure trunk - metal - small - 50x50x50 cm - simple (-3) lock
Secure trunk - metal - medium - 1x1x1 m - simple (-3) lock
Secure trunk - metal - large - 2x2x2 m - simple (-3) lock
Secure trunk - metal - small - 50x50x50 cm - complex (-6) lock
Secure trunk - metal - medium - 1x1x1 m - complex (-6) lock
Secure trunk - metal - large - 2x2x2 m - complex (-6) lock
Trunk - hover addon"

$list = $list -split "`n"

function Get-Items {
    param ($amount)
    
    $states = "brand new,worn,worn,worn,worn,worn,worn,worn,worn,well worn,well worn,well worn,well worn,damaged"

    $states = $states -split ","

    $returnList = @()
    foreach ($numnber in 1..$amount) {
         $item = Get-Random -InputObject $list
         $state = Get-Random -InputObject $states
         $returnList += "$item, $state"
    }
    return $returnList
}

$returned = Get-Items -amount 5 | Sort-Object
$returned