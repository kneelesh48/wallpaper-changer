$ShortcutFile="$($home)\Desktop\wallpaper changer.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $(get-command pythonw).Source
$Shortcut.Arguments = ".\main.py"
$Shortcut.WorkingDirectory = $(Get-Location).Path
$Shortcut.IconLocation = "$(Get-Location)\icon.ico"
$Shortcut.Description = "Wallpaper Changer"
$Shortcut.Save()

Write-Output "Finished creating desktop shortcut"
Read-Host "Press Enter to continue"
