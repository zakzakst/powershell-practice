param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [string]$OutputDirectory = (Get-Location).Path,

    [string]$DateFormat = "yyyyMMdd"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
    throw "指定されたフォルダが見つかりません: $SourcePath"
}

if (-not (Test-Path -LiteralPath $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$sourceItem = Get-Item -LiteralPath $SourcePath
$date = Get-Date -Format $DateFormat
$backupFolderName = "{0}_{1}" -f $sourceItem.Name, $date
$backupFolderPath = Join-Path -Path $OutputDirectory -ChildPath $backupFolderName
$zipPath = Join-Path -Path $OutputDirectory -ChildPath ("{0}.zip" -f $backupFolderName)

if (Test-Path -LiteralPath $backupFolderPath) {
    Remove-Item -LiteralPath $backupFolderPath -Recurse -Force
}

if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

Copy-Item -Path $sourceItem.FullName -Destination $OutputDirectory -Recurse -Force

$copiedFolderPath = Join-Path -Path $OutputDirectory -ChildPath $sourceItem.Name
if (Test-Path -LiteralPath $copiedFolderPath) {
    Rename-Item -Path $copiedFolderPath -NewName $backupFolderName
}

Compress-Archive -Path $backupFolderPath -DestinationPath $zipPath -Force

Write-Host "コピー元: $($sourceItem.FullName)"
Write-Host "バックアップ先フォルダ: $backupFolderPath"
Write-Host "ZIPファイル: $zipPath"
