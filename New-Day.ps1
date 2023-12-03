param (
  [int]$Year = (Get-Date).year
)

$root = $PSScriptRoot
$YearDir = Join-Path $root $Year
$TemplatesDir = Join-Path $root "templates"

if (-not (Test-Path $YearDir)) {
  Write-Host "Creating a new directory for year $Year"
  New-Item -ItemType Directory -Path $YearDir | Out-Null
}

$Days = Get-ChildItem $YearDir

if ($Days.count -eq 25) {
    Write-Host "Already have all 25 days for $Year"
    return
}
else {
    $Day = ($Days.count +1)
    $DayDir = Join-Path $YearDir "Day $Day"
    Write-Host "Creating a new directory for day $Day"
    New-Item -ItemType Directory -Path $DayDir | Out-Null
}

Get-ChildItem -Path $TemplatesDir | Copy-Item -Destination $DayDir
$null = New-Item -Path (Join-Path $DayDir "Input.txt")
$null = New-Item -Path (Join-Path $DayDir "TestInput.txt")
Write-Host ""
Write-Host "Don't forget to save the input: https://adventofcode.com/$Year/day/$Day/input" -ForegroundColor Yellow
Write-Host "Done!" -ForegroundColor Green