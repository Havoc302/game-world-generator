[System.Collections.ArrayList]$firstFemaleNameArray = @{}

[System.Collections.ArrayList]$firstMaleNameArray = @{}

[System.Collections.ArrayList]$lastNameArray = @{}

foreach ($i in 1..100000) {
    $user1 = Invoke-RestMethod -Uri api.namefake.com
    if ($user1.pict -match "female") {
        $firstFemaleNameArray.Add(($user1.Name -split " " -split "-" | Select -First 1))
    } else {
        $firstMaleNameArray.Add(($user1.Name -split " " -split "-" | Select -First 1))
    }
    $lastNameArray.Add(($user1.Maiden_Name -split " " -split "-" | Select -Last 1))

    $user2 = (Invoke-RestMethod -Uri https://randomuser.me/api/).results
    if ($user2.picture -match "men") {
        $firstMaleNameArray.Add(($user2.Name.First -split " " -split "-" | Select -First 1))
    } else {
        $firstFemaleNameArray.Add(($user1.Name -split " " -split "-" | Select -First 1))
    }
    $lastNameArray.Add(($user2.Name.Last -split " " -split "-" | Select -Last 1))
}

foreach ($i in 1..1000) {
    $users3 = Invoke-RestMethod -Uri https://random-data-api.com/api/v2/users?size=100
    foreach ($user in $users3) {
        if ($user.gender -match "Male") {
            
            $firstNameArray.Add(($user.first_name -split " " -split "-" | Select -First 1))
            $lastNameArray.Add(($user.last_name -split " " -split "-" | Select -Last 1))
        }
    }
}

$firstNameArrayFiltered = $firstNameArray | where {$_ -cnotmatch '\P{IsBasicLatin}' -and $_ -notmatch '\.' -and $_.length -ge 3}

$lastNameArrayFiltered = $lastNameArray | where {$_ -cnotmatch '\P{IsBasicLatin}' -and $_ -notmatch '\.' -and $_.length -ge 3}

[System.Collections.ArrayList]$firstNameArrayFiltered2 = @{}

foreach ($firstName in $firstNameArrayFiltered) {
    $firstNameArrayFiltered2.Add((Get-Culture).TextInfo.ToTitleCase($($firstName -split " " -split "-" | Select-Object -First 1)))
}

[System.Collections.ArrayList]$lastNameArrayFiltered2 = @{}

foreach ($lastName in $lastNameArrayFiltered) {
    $lastNameArrayFiltered2.Add((Get-Culture).TextInfo.ToTitleCase($($lastName -split " " -split "-" | Select-Object -Last 1)))
}

$firstNameArrayFiltered3 = $firstNameArrayFiltered2 | Group-Object | sort Count | Select-Object -ExpandProperty Name | Sort

$lastNameArrayFiltered3 = $lastNameArrayFiltered2 | Group-Object | sort Count | Select-Object -ExpandProperty Name | Sort

$firstNameArrayFiltered3.count

$lastNameArrayFiltered3.count

foreach ($n in 1..1000) {
    "$(Get-Random -InputObject $firstNameArrayFiltered3) "+"$(Get-Random -InputObject $lastNameArrayFiltered3)"
}