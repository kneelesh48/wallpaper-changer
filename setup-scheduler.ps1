$taskName = "Wallpaper changer"
$trigger =  New-ScheduledTaskTrigger -Daily -At 9am
$action = New-ScheduledTaskAction -Execute 'C:\ProgramData\Anaconda3\pythonw.exe' -Argument '.\main.py' -WorkingDirectory $(Get-Location)

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
if($taskExists) {
    Write-Output "Task already exists"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Changes wallpaper everyday at a specified time"

Write-Output "Finished adding program to Task Scheduler"
Read-Host "Press Enter to continue"
