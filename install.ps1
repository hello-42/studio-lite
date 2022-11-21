# Retrieve logged in User's registry key SID
$User = New-Object System.Security.Principal.NTAccount($env:UserName)
$SecurityIdentifier = $User.Translate([System.Security.Principal.SecurityIdentifier]).value

# Retrieve Roblox Studio's ContentFolder registry key, locating the root of our Studio Version folder.
$HKU = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$RobloxStudio = "${HKU}:\$SecurityIdentifier\SOFTWARE\Roblox\RobloxStudio"
$ContentFolderPath = (Get-ItemProperty -Path $RobloxStudio -Name "ContentFolder").ContentFolder
$RobloxStudioVersionFolder = (Split-Path $ContentFolderPath -Parent)

# Retrieve the registry key we want to monitor for value additions to via RobloxStudioBeta.exe
$OpenStudioProcesses = "$RobloxStudio\OpenStudioProcesses"

# Ensure that the registry key we want to monitor exists and that we have edited it's audit permissions accordingly.
$RegistryKeyAuditRule = New-Object System.Security.AccessControl.RegistryAuditRule("Everyone","QueryValues","none","none","Success")
$RegKey_ACL = Get-Acl $OpenStudioProcesses
$RegKey_ACL.AddAuditRule($RegistryKeyAuditRule)
$RegKey_ACL | Set-Acl $OpenStudioProcesses

# Subscription query template - specific to the registry key and from the proper Roblox Studio version folder.
$subscriptionQuery = @"
<QueryList>
    <Query Id="0" Path="Security">
        <Select Path="Security">
            *[System[Provider[@Name="Microsoft-Windows-Security-Auditing"]]] and
            *[System[(EventID="4663")]] and
            *[EventData[Data[@Name="ObjectName"]='\REGISTRY\User\$SecurityIdentifier\SOFTWARE\Roblox\RobloxStudio\OpenStudioProcesses']] and
            *[EventData[Data[@Name="ProcessName"]='$RobloxStudioVersionFolder\RobloxStudioBeta.exe']]
        </Select>
    </Query>
</QueryList>
"@

# If we aren't currently scheduled, create the scheduled task that handles task automation.
if ($TRUE -ne (Get-ScheduledTask | Where-Object { $_.TaskName -eq "RobloxStudioStarted" })) {
    # Execute .\debloat.ps1 with elevated privileges, attempting to hide the nasty PowerShell shell - fail anyways.
    # Thanks, Windows. If anyone knows how to do this, please let me know or send in a PR!
    $TaskAction = New-ScheduledTaskAction -Argument ".\debloat.ps1 -WorkingDirectory $PSScriptRoot" -Execute "powershell.exe"
    $TaskPrincipal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -Hidden -DontStopIfGoingOnBatteries

    # Create our ScheduledTask's trigger, firing only when a new value is added to the OpenStudioProcesses registry key.
    $TaskTrigger = CimClass MSFT_TaskEventTrigger "root/Microsoft/Windows/TaskScheduler" | New-CimInstance -ClientOnly
    $TaskTrigger.Enabled = $TRUE
    $TaskTrigger.Subscription = $subscriptionQuery

    $RegisterScheduledTaskParameters = @{
        TaskName = "RobloxStudioStarted"
        TaskPath = "\Event Viewer Tasks\"
        Action = $TaskAction
        Principal = $TaskPrincipal
        Settings = $TaskSettings
        Trigger = $TaskTrigger
    }

    # Register our ScheduledTask under the name "RobloxStudioStarted".
    Register-ScheduledTask @RegisterScheduledTaskParameters
}

# Run our debloat tool once to ensure that we install with a clean slate.
Start-Process -FilePath "powershell.exe" -ArgumentList ".\debloat.ps1 -WorkingDirectory $PSScriptRoot" -Verb RunAs
