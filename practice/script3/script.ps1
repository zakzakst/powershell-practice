if (Test-Path dist.zip) {
  Remove-Item dist.zip
}

Compress-Archive `
  -Path dist `
  -DestinationPath dist.zip