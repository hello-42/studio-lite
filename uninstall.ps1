$reinstallStudio = Read-Host "Would you like to revert changes? (Y/N)"

if ($reinstallStudio -eq "Y") {
    # Attempt to query and remove an actionable RobloxStudioStarted ScheduledTask.
    $robloxStudioStarted = (Get-ScheduledTask | Where-Object { $_.TaskName -eq "RobloxStudioStarted" })
    if ($robloxStudioStarted) {
        Unregister-ScheduledTask -TaskName "RobloxStudioStarted" -Confirm:$FALSE
    }

    # Retrieve logged in User's registry key SID
    $User = New-Object System.Security.Principal.NTAccount($env:UserName)
    $SecurityIdentifier = $User.Translate([System.Security.Principal.SecurityIdentifier]).value

    # Retrieve Roblox Studio's ContentFolder registry key, locating the root of our Studio Version folder.
    $HKU = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    $RobloxStudio = "${HKU}:\$SecurityIdentifier\SOFTWARE\Roblox\RobloxStudio"
    $ContentFolderPath = (Get-ItemProperty -Path $RobloxStudio -Name "ContentFolder").ContentFolder
    $RobloxStudioVersionFolder = (Split-Path $ContentFolderPath -Parent)

    # Attempt to retrieve and start an actionable RobloxStudioLauncherBeta.exe installation process.
    $RobloxStudioLauncherBeta = "$RobloxStudioVersionFolder\RobloxStudioLauncherBeta.exe"
    if (Test-Path $RobloxStudioLauncherBeta) {
        Start-Process $RobloxStudioLauncherBeta
    }
}
