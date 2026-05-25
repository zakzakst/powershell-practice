# =========================================
# フォルダ構成とファイル一覧をCSV出力するスクリプト
# =========================================

param(
  # 調査対象フォルダ
  [string]$TargetPath = ".",

  # 出力CSVファイル名
  [string]$OutputCsv = "folder-structure.csv"
)

# 対象パスを絶対パス化
$resolvedPath = Resolve-Path $TargetPath

Write-Host "調査対象: $resolvedPath"
Write-Host "CSV出力先: $OutputCsv"

# 結果格納用
$result = @()

# フォルダ・ファイル取得
# NOTE: -Include *.ts, *.tsx を利用すれば特定の拡張子のみ出力することも可能
Get-ChildItem -Path $resolvedPath -Recurse | ForEach-Object {

  $item = $_

  # 種別
  $type = if ($item.PSIsContainer) {
    "Directory"
  }
  else {
    "File"
  }

  # 相対パス作成
  $relativePath = $item.FullName.Replace("$resolvedPath\", "")

  # オブジェクト化
  $result += [PSCustomObject]@{
    Type         = $type
    Name         = $item.Name
    RelativePath = $relativePath
    FullPath     = $item.FullName
    Extension    = $item.Extension
    SizeKB       = if ($item.PSIsContainer) {
      ""
    }
    else {
      [math]::Round($item.Length / 1KB, 2)
    }
    UpdatedAt    = $item.LastWriteTime
  }
}

# CSV出力
$result |
Export-Csv `
  -Path $OutputCsv `
  -NoTypeInformation `
  -Encoding UTF8

Write-Host ""
Write-Host "CSV出力完了"