﻿function Do-MultiRoller {
    param ($Rolls,
           $Dice_Count,
           $Dice_Type,
           $Modifier)

    Foreach ($roll in 1..$rolls) {
        foreach ($dice in 1..$dice_count) {
            $count += Get-Random -Minimum 1 -Maximum $dice_type
        }
        $count + $Modifier
        $count = 0
    }
}
    
Do-MultiRoller -Rolls 100 -Dice_Count 1 -Dice_Type 20 -Modifier 0