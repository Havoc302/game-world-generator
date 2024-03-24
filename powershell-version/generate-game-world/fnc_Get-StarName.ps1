﻿Function Get-StarName {
    
    if ($($firstNames).Count -ge 1) {
        $systemName = Get-Random -InputObject $firstNames
        $firstNames.Remove($systemName)
    } else {
        $systemName = Get-Random -InputObject $systemNames
        $systemName = $systemName.Trim()
        $systemNames.Remove($systemName)
    }

    return $systemName
}