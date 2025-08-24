# ScriptKitty.psm1
# This script module serves as the entry point for the ScriptKitty module.
# Its primary responsibilities are to dynamically load all public and private functions,
# and to initialize the module's configuration settings.

# --- DYNAMIC FUNCTION LOADING ---
# Find and dot-source all.ps1 files from the Public and Private subdirectories.
# This makes all functions available within the module's scope.

# Define paths to the function directories relative to this script's location.
$PublicPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

# Get an array of all.ps1 files in both directories.
# The -ErrorAction SilentlyContinue prevents errors if a directory doesn't exist.
$FunctionFiles = Get-ChildItem -Path $PublicPath, $PrivatePath -Filter '*.ps1' -ErrorAction SilentlyContinue

# Loop through each found file and dot-source it.
foreach ($File in $FunctionFiles) {
    try {
        # The '.' operator (dot-source) runs the script in the current scope.
       . $File.FullName
    }
    catch {
        # If a file fails to load, write a warning to the console for debugging.
        Write-Warning -Message "Failed to load function file: $($File.FullName). Error: $($_.Exception.Message)"
    }
}

# --- CONFIGURATION INITIALIZATION ---
# Initialize the module's configuration settings.
# This calls a private function (Initialize-SKConfiguration) which should be
# defined in a.ps1 file within the 'Private' directory.

# The resulting merged settings are stored in a script-scoped variable.
# The $Script: scope makes the variable available to all functions within this module,
# but not to the user's global session.
$Script:Settings = Initialize-SKConfiguration

# --- EXPORT MODULE MEMBERS ---
# The functions to be exported to the user are controlled by the 'FunctionsToExport'
# key in the ScriptKitty.psd1 manifest file for best practice.
# However, this is where you would explicitly export members if not using a manifest.
# This module also exports the 'Settings' variable for inspection and advanced use.
Export-ModuleMember -Variable 'Settings'