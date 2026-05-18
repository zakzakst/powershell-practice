function Create-Backup {
  param(
    $path
  )

  if (Test-Path $path) {
    $date = Get-Date -Format "yyyyMMdd"
    $backupName = "$path-$date"
    Copy-Item $path $backupName -Recurse
  }
  else {
    Write-Error "指定されたパス：$path が存在しません"
  }
}

# Create-Backup "src"
Create-Backup "public"