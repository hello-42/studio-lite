$excludedPlugins = [array](
    # "RotateDragger.rbxm",
    # "MoveDragger.rbxm",
    # "ScaleDragger.rbxm",
    # "TransformDragger.rbxm",
    "SelectDragger.rbxm"
)
$removeBuiltInStandalonePlugins = $TRUE
$useCustomRibbon = $FALSE

# Retrieve logged in User's registry key SID
$User = New-Object System.Security.Principal.NTAccount($env:UserName)
$SecurityIdentifier = $User.Translate([System.Security.Principal.SecurityIdentifier]).value

# Retrieve Roblox Studio's ContentFolder registry key, locating the root of our ContentFolder.
$HKU = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$RobloxStudio = "${HKU}:\$SecurityIdentifier\SOFTWARE\Roblox\RobloxStudio"
$ContentFolder = (Get-ItemProperty -Path $RobloxStudio -Name "ContentFolder").ContentFolder

Set-Location (New-Object System.IO.DirectoryInfo $ContentFolder).Parent.FullName

# Attempt to query and remove Optimized_Embedded_Signature plugins.
$OptimizedEmbeddedSignature = "$(Get-Location)\BuiltInPlugins\Optimized_Embedded_Signature"
if (Test-Path $OptimizedEmbeddedSignature) {
    # Delete all plugins whose names are not under $excludedPlugins.
    Get-ChildItem -Path $OptimizedEmbeddedSignature | ForEach-Object {
        if ($_.Name -notin $excludedPlugins) {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
    }
}

# Attempt to query and remove actionable BuiltInStandalonePlugins.
if ($TRUE -eq $removeBuiltInStandalonePlugins) {
    $BuiltInStandalonePlugins = "$(Get-Location)\BuiltInStandalonePlugins"

    if (Test-Path $BuiltInStandalonePlugins) {
        Get-ChildItem -Path $BuiltInStandalonePlugins | ForEach-Object {
            if ($_.Name -notin $excludedPlugins) {
                Remove-Item -Path $_.FullName -Recurse -Force
            }
        }
    }
}

# Attempt to query and remove/replace the RobloxStudioRibbon.xml file.
if ($TRUE -eq $useCustomRibbon) {
    $RobloxStudioRibbon = "$(Get-Location)\RobloxStudioRibbon.xml"

    Copy-Item "$PSScriptRoot\RobloxStudioRibbon.xml" -Destination (Get-Location) -Force
}
