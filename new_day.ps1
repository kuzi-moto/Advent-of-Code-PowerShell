param (
  [int]$Year = (Get-Date).year
)

$YearDir = Join-Path $PSScriptRoot $Year

if (-not (Test-Path $Year)) {
  Write-Host "Creating a new directory for year $Year"
  New-Item -ItemType Directory -Path $YearDir | Out-Null
}

$Days = Get-ChildItem $YearDir

if ($Days.count -eq 25) {
    Write-Host "Already have all 25 days"
    return
}
else {
    $Day = ($Days.count +1)
    $DayDir = Join-Path $YearDir "Day $Day"
    Write-Host "Creating a new directory for day $Day"
    New-Item -ItemType Directory -Path $DayDir | Out-Null
}

Get-ChildItem -Path "templates" | Copy-Item -Destination $DayDir
New-Item -Path (Join-Path $DayDir "TestInput.txt") | Out-Null
Write-Host ""
Write-Host "Don't forget to save the input: https://adventofcode.com/$Year/day/$Day/input" -ForegroundColor Yellow
Write-Host "Done!" -ForegroundColor Green