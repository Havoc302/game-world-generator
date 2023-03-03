# Random event generator

$list = "Chopping board - glass
Cutlery - fork - plain - metal
Cutlery - fork - fancy - silver
Cutlery - spoon - plain - metal
Cutlery - spoon - fancy - silver
Cutlery - knife - plain - metal
Cutlery - knife - fancy - silver
Cutlery - serving implement - plain - metal
Cutlery - serving implement - fancy - silver
Dishes - bowl/plate - plain - ceramic
Dishes - bowl/plate - plain - metal
Dishes - bowl/plate - fancy - ceramic
Dishes - bowl/plate - fancy - metal
Dishes - pitcher - fancy - ceramic
Dishes - pitcher - fancy - glass
Dishes - serving platter - fancy - ceramic
Dishes - serving platter - fancy - metal
Frying pan - metal - small
Frying pan - metal - large
Jug - ceramic - 1 lt
Jug - ceramic - 2 lt
Jug - ceramic - 3 lt
Kettle - metal - 1 lt
Kettle - electric - 1 lt
Mixing bowl - metal - small
Mixing bowl - metal - medium
Mixing bowl - metal - large
Pot - metal - 2 lt
Pot - metal - 3 lt
Pot - metal - 4 lt
Utensils - cake server - metal - plain
Utensils - cake server - silver - fancy
Utensils - meat cleaver
Utensils - kitchen knives - small (paring, peeling, etc.)
Utensils - kitchen knives - medium (chopping, boning, etc.)
Utensils - kitchen knives - large (carving, bread, etc.)
Utensils - ladle - metal - plain
Utensils - ladle - silver - fancy
Utensils - scraper - metal and rubber
Utensils - skewers - metal - pack of 12
Utensils - spatula - metal - plain
Utensils - spoon - metal - plain
Utensils - spoon - silver - plain
Utensils - spoon - silver - fancy
Utensils - tongs - metal - plain
Utensils - wire whisk - looped - metal
Utensils - wire whisk - ball-tipped - metal'
Mug - Ceramic - Plain
Mug - Ceramic - Fancy
Mug - Metal
Small glass
Large glass"

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

$returned = Get-Items -amount 20 | Sort-Object
$returned