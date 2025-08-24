# Private\Initialize-SKConfiguration.ps1
function Initialize-SKConfiguration {
    # --- 1. Load Default Settings ---
    $defaultSettingsPath = Join-Path -Path $PSScriptRoot -ChildPath '..\Settings\default.settings.psd1'
    $defaultSettings = @{}
    if (Test-Path -Path $defaultSettingsPath) {
        try {
            $defaultSettings = Import-PowerShellDataFile -Path $defaultSettingsPath
        }
        catch {
            Write-Warning "Could not load default settings from '$defaultSettingsPath'."
        }
    }

    # --- 2. Locate and Load User Settings ---
    $userSettings = $null
    try {
        $profileDir = Split-Path $PROFILE.CurrentUserAllHosts -Parent
        $userSettingsDir = Join-Path -Path $profileDir -ChildPath 'ScriptKitty'
        $userSettingsPath = Join-Path -Path $userSettingsDir -ChildPath 'ScriptKitty.settings.psd1'

        if (Test-Path -Path $userSettingsPath) {
            $userSettings = Import-PowerShellDataFile -Path $userSettingsPath
        }
    }
    catch {
        Write-Warning "Could not load user settings. Error: $($_.Exception.Message)"
    }

    # --- 3. Merge Settings ---
    $mergedSettings = $defaultSettings.Clone()
    if ($null -ne $userSettings) {
        foreach ($key in $userSettings.Keys) {
            $mergedSettings[$key] = $userSettings[$key]
        }
    }

    # --- 4. Return Final Configuration ---
    return $mergedSettings
}