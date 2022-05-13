# Random event generator

[int]$amount = $args

$list = "Cold weather gloves - cloth - waterproof
Cold weather jacket - cloth - waterproof
Cold weather pants - cloth - waterproof
Cold weather boots - cloth - waterproof
Heated cold weather gloves - cloth - waterproof
Heated cold weather jacket - cloth - waterproof
Heated cold weather pants - cloth - waterproof
Heated cold weather boots - cloth - waterproof
Formal business jacket (Grey)
Formal business pants (Grey)
Formal business jacket (Black)
Formal business pants (Black)
Formal business jacket (Brown)
Formal business pants (Brown)
Dress shoes
Dress boots - cloth
Dress boots - artificial leather
Casual pants - cloth - tan
Casual pants - cloth - dark blue
Casual pants - cloth - black
Casual pants - cloth - grey
Casual pants - cloth - green
Casual pants - cloth - camo
Casual jacket - cloth - tan
Casual jacket - cloth - dark blue
Casual jacket - cloth - black
Casual jacket - cloth - grey
Casual jacket - cloth - green
Casual jacket - cloth - camo
Casual jacket - artificial leather - black
Jeans - cloth
T-shirt - short sleeved (White)
T-shirt - short sleeved (Dark Green)
T-shirt - short sleeved (Red)
T-shirt - short sleeved (Orange)
T-shirt - short sleeved (Blue)
T-shirt - short sleeved (Black)
T-shirt - short sleeved (Black with popular band logo)
T-shirt - long sleeved (White)
T-shirt - long sleeved (Dark Green)
T-shirt - long sleeved (Red)
T-shirt - long sleeved (Orange)
T-shirt - long sleeved (Blue)
T-shirt - long sleeved (Black)
T-shirt - long sleeved (Black with popular band logo)
Blouse - short sleeved (White)
Blouse - short sleeved (Dark Green)
Blouse - short sleeved (Red)
Blouse - short sleeved (Orange)
Blouse - short sleeved (Blue)
Blouse - short sleeved (Black)
Blouse - short sleeved (White with Floral Print)
Blouse - long sleeved (White)
Blouse - long sleeved (Dark Green)
Blouse - long sleeved (Red)
Blouse - long sleeved (Orange)
Blouse - long sleeved (Blue)
Blouse - long sleeved (Black)
Blouse - long sleeved (White with Floral Print)
Short skirt (White)
Short skirt (Dark Green)
Short skirt (Red)
Short skirt (Orange)
Short skirt (Blue)
Short skirt (Black)
Short skirt (White with Floral Print)
Long skirt (White)
Long skirt (Dark Green)
Long skirt (Red)
Long skirt (Orange)
Long skirt (Blue)
Long skirt (Black)
Long skirt (White with Floral Print)
Long sleeved shirt
Utility coveralls
Navy officers uniform
Navy non-com uniform
Navy pilot officers uniform
Navy pilot non-com uniform
Navy military police officers uniform
Navy military police non-com uniform
Marine officers uniform
Marine non-com uniform
Marine pilot officers uniform
Marine pilot non-com uniform
Marine military police officers uniform
Marine military police non-com uniform
Civilian spacesuit undergarment
Military powered armour undergarment
Navy field boots
Marine field boots
Federal Police officers uniform
Federal Police non-com uniform
Federal Police investigators uniform
Federal Police day uniform
Navy day shoes
Navy dress shoes
Marine dress shoes
Ballgown - simple
Ballgown - extravagant
Bandanna
Belt - cloth - no buckle
Belt - cloth - with buckle
Belt - artificial leather - no buckle
Belt - artificial leather - with large fancy buckle
Boots - ankle - cloth
Boots - knee - cloth
Boots - ankle - soft artificial leather
Boots - knee - soft artificial leather
Boots - thigh - soft artificial leather
Baseball cap - cloth
Ushanka hat - cloth
Cloak - cloth
Cloak - cloth - hooded
Cloak - wool
Cloak - wool - hooded
Coat - light
Coat - heavy
Coat - down filled - short
Coat - down filled - long
Coat - artificial leather, minimal lining
Coat - artificial leather, padded lining
Coat - fur - plain/common
Coat - fur - fancy
Dress/Gown - plain - cloth
Dress/Gown - plain - wool
Dress/Gown - fancy - silk
Dress/Gown - fancy - silk and embroidered accents
Gloves - plain - cloth
Gloves - plain - wool
Gloves - plain - artificial leather - unlined
Gloves - plain - artificial leather - lined
Gloves - fancy - cloth - hand only
Gloves - fancy - silk - hand only
Gloves - fancy - silk - to mid forearm
Gloves - fancy - silk - to elbow
Gloves - fancy - silk - to mid upper arm
Hat - plain - cloth - protects to 0°C
Hat - plain - wool - protects to -10°C
Hat - plain - short brim outdoor - cloth
Hat - plain - large brim outdoor - cloth
Hat - plain - large brim outdoor - artificial leather
Hat - fancy - bowler style
Hat - fancy - top hat
Hat - fancy - beret
Hat - fancy - women's style
Hat - extravagant - women's style
Lingerie - cloth
Lingerie - cloth and lace
Lingerie - silk and lace
Nightgown - plain - cloth
Nightgown - plain - wool
Nightgown - fancy - silk
Overdress - plain - cloth
Overdress - plain - wool
Overdress - fancy - silk
Overdress - fancy - silk and embroidered accents
Pyjamas - plain - cloth
Pyjamas - plain - wool
Pyjamas - fancy - silk
Robe - light - cloth
Robe - light - cloth
Robe - heavy - wool
Robe - heavy - wool
Sandals - plain
Sandals - fancy
Scarf - wool - 3' long
Scarf - decorative silk - 2' square
Shirt - plain - cloth
Shirt - plain - wool
Shirt - fancy - silk
Shirt - fancy - silk and embroidered accents
Shoes - plain
Shoes - fancy
Shorts/bikini-style bottoms - cloth
Shorts/bikini-style bottoms - artificial leather
Skirt - plain - cloth
Skirt - plain - wool
Skirt - fancy - silk
Skirt - fancy - silk and embroidered accents
Socks - cloth
Socks - wool
Stockings - wool
Stockings - silk
Trousers - plain - cloth
Trousers - plain - wool
Trousers - fancy
Undergarments - cloth
Undergarments - silk
Bed sheet - cloth
Bed sheet - silk
Pillow - small - cloth
Pillow - medium - cloth
Pillow - large - foam
Gas mask
Hazmat suit
Safety harness
Security officer uniform shirt - Black
Security officer uniform pants - Black
Security officer uniform baseball cap - Black
Security officer uniform peak cap - Black
Security officer uniform shirt - Navy Blue
Security officer uniform pants - Navy Blue
Security officer uniform baseball cap - Navy Blue
Security officer uniform peak cap - Navy Blue
Security officer uniform shirt - Charcoal Grey
Security officer uniform pants - Charcoal Grey
Security officer uniform baseball cap - Charcoal Grey
Security officer uniform peak cap - Charcoal Grey
Nurse uniform pants - White
Nurse uniform shirt - White
Nurse uniform pants - Light Blue
Nurse uniform shirt - Light Blue
Doctor uniform pants - White
Doctor uniform shirt - White
Doctor uniform pants - Light Blue
Doctor uniform shirt - Light Blue
Lab coat
Doctor's coat
Medical scrubs
Nurse uniform
Paramedic uniform
Utility boots"

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

Get-Items -amount $amount | Sort-Object