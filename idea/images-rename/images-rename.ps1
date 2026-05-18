# =========================
# 画像リネームスクリプト
# =========================

# スクリプトが置かれているディレクトリ
$targetDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "対象フォルダ: $targetDir"
Write-Host ""

# プレフィックス入力
$prefix = Read-Host "ファイル名のプレフィックスを入力してください（未入力: image）"

# 未入力なら image
if ([string]::IsNullOrWhiteSpace($prefix)) {
  $prefix = "image"
}

# 対応画像拡張子
$imageExtensions = @(
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.webp",
  "*.gif",
  "*.bmp"
)

# 画像一覧取得
$files = foreach ($ext in $imageExtensions) {
  Get-ChildItem -Path $targetDir -Filter $ext -File
}

# 更新日時順でソート
$sortedFiles = $files | Sort-Object LastWriteTime

# 連番リネーム
$index = 1

foreach ($file in $sortedFiles) {

  # 拡張子
  $extension = $file.Extension

  # 3桁連番
  $number = "{0:D3}" -f $index

  # 新しいファイル名
  $newName = "$prefix-$number$extension"

  # リネーム
  Rename-Item -Path $file.FullName -NewName $newName

  Write-Host "Renamed: $($file.Name) -> $newName"

  $index++
}

Write-Host ""
Write-Host "完了しました"