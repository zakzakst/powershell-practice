$source = "dist"
$backup = "backup-dist"

if (Test-Path $backup) {
  Remove-Item $backup -Recurse
}

Copy-Item $source $backup -Recurse

Write-Host "backup completed!"