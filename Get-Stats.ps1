param (
  [int]$Day,
  [int]$Part,
  [int]$Year = (Get-Date).Year
)

$YearPath = Join-Path $PSScriptRoot $Year

if (-not (Test-Path $YearPath)) {
  Write-Warning "The directory for $Year ($YearPath) doesn't exist."
  return
}

if (!$PSBoundParameters.ContainsKey('Day')) {
  $null = (Get-ChildItem -Path $YearPath | Select-Object Name | Sort-Object)[-1] -match '\d+'
  $Day = $Matches[0].ToString()
}

$DayPath = Join-Path $YearPath "Day $Day"

if (!$PSBoundParameters.ContainsKey('Part')) {
  $Part = 2
  # Assume P1 exists if P2 doesn't
  if (-not (Test-Path (Join-Path $DayPath "P$Part.ps1"))) { $Part = 1 }
}

$ScriptPath = Join-Path $DayPath "P$Part.ps1"

if (-not (Test-Path $ScriptPath)) {
  Write-Warning "The script at `"$ScriptPath`" doesn't exist."
  return
}

$StatsPath = Join-Path $DayPath ("P" + $Part + "_stats.txt")

Measure-Command -Expression { & $ScriptPath } | Out-String | ForEach-Object { $_.Trim() | Out-File $StatsPath }