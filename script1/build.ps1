$date = Get-Date -Format "yyyyMMdd"
$backupName = "backup-$date"

if (Test-Path $backupName) {
  Remove-Item $backupName -Recurse
}

Copy-Item dist $backupName -Recurse