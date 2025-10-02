# Fix date format in all markdown files
Get-ChildItem -Path "content" -Recurse -Filter "*_index*.md" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newContent = $content -replace 'date\s*:\s*"`r Sys\.Date\(\)`"', 'date : "2023-11-26"'
    Set-Content -Path $_.FullName -Value $newContent -NoNewline
    Write-Host "Fixed: $($_.FullName)"
}