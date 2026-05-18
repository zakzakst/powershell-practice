$files = @(
  "index.html",
  "style.css",
  "main.js"
)

if (!(Test-Path src)) {
  mkdir src
}

foreach ($file in $files) {
  New-Item "src/$file"
}