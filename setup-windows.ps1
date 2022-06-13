# Install required packages
pip install -r requirements.txt

# Create desktop shortcut
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

# Add program to Task Scheduler
$taskName = "Wallpaper changer"
$trigger =  New-ScheduledTaskTrigger -Daily -At 11am
$action = New-ScheduledTaskAction -Execute 'C:\ProgramData\Anaconda3\pythonw.exe' -Argument '.\main.py' -WorkingDirectory $(Get-Location)

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
if($taskExists) {
    Write-Output "Task already exists"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Changes wallpaper everyday at a specified time"

Write-Output "Finished adding program to Task Scheduler"
Read-Host "Press Enter to continue"
