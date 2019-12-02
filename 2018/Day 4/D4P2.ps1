Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile

# Parse the input
# split to Year-Month-Day Hour-Minute | Text

$Parsed = @()
$Data | ForEach-Object {
  $_ -match "\[(?<date>\d{4}-\d{2}-\d{2}\s\d{2}:\d{2})\]\s(?<text>.+)" | Out-Null
  $Date = [datetime]$Matches.date
  if ($Date.Hour -eq 23) {
    $Minute = 0
  }
  else { $Minute = $Date.Minute }
  $Parsed += @{
    date   = $date
    text   = $Matches.text
    minute = $Minute
  }
}
$SleepTime = @{}
# https://stackoverflow.com/questions/20874464/format-table-on-array-of-hash-tables
$Parsed.ForEach( {[PSCustomObject]$_}) | Sort-Object -Property date | ForEach-Object {
  if ($_.text -match 'Guard\s#(?<guard>\d+)\sbegins\sshift') {
    $CurrentGuard = $Matches.guard
  }
  elseif ($_.text -match 'falls\sasleep') {
    $SleepStart = $_.minute
  }
  elseif ($_.text -match 'wakes\sup') {
    $SleepEnd = $_.minute - 1
  }

  if ($SleepEnd) {
    if (!$SleepTime.$CurrentGuard) {
      $SleepTime.$CurrentGuard = @()
    }
    $SleepTime.$CurrentGuard += $SleepStart..$SleepEnd
    $SleepEnd = $null
  }
}

$GuardMinuteTable = @{}

$SleepTime.GetEnumerator() | ForEach-Object {
  $Guard = $_.Name
  foreach ($i in $_.Value) {
    $GuardMinuteTable."$Guard.$i" += 1
  }
}

$GuardMinute = ($GuardMinuteTable.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 1).Name

$GuardMinute -match '(?<guard>\d+).(?<minute>\d+)' | Out-Null
$SleepingGuard = [int]$Matches.guard
$SleepingMinute = [int]$Matches.minute

Write-Host "Guard $SleepingGuard was asleep most during minute $SleepingMinute. Ans: $($SleepingGuard * $SleepingMinute)"