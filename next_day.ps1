param (
  [int]$Year = (Get-Date).year
)

$YearDir = Join-Path $PSScriptRoot $Year

if (-not (Test-Path $Year)) {
  Wite-Host "Creating a new directory for $Year"
  New-Item -ItemType Directory -Path $YearDir | Out-Null
}

$Days = Get-ChildItem $YearDir

if ($Days.count -eq 25) {
    Write-Host "Already have all 25 days"
}
else {
    $DayDir = Join-Path $YearDir ($Days.count +1)
    Write-Host "Creating a new directory for $DayDir"
    New-Item -ItemType Directory -Path $DayDir | Out-Null
}


