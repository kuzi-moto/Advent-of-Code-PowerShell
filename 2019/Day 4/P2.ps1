Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

if (($Data -match "(\d{6})-(\d{6})") -eq $false) {
  Write-Host "Error reading input"
  return
}
$Start = $Matches[1]
$End = $Matches[2]

$Start -match '(\d)(\d)(\d)(\d)(\d)(\d)' | Out-Null
$StartArr = [int]$Matches[1], [int]$Matches[2], [int]$Matches[3], [int]$Matches[4], [int]$Matches[5], [int]$Matches[6]

$End -match '(\d)(\d)(\d)(\d)(\d)(\d)' | Out-Null
$EndArr = [int]$Matches[1], [int]$Matches[2], [int]$Matches[3], [int]$Matches[4], [int]$Matches[5], [int]$Matches[6]

$MeetsCriteria = 0
$sample = @()

# 172851
# 012345

$Done = $false
do {
  if ($StartArr[1] -lt $StartArr[0]) {
    $StartArr[1] = $StartArr[0]
    $StartArr[2] = $StartArr[0]
    $StartArr[3] = $StartArr[0]
    $StartArr[4] = $StartArr[0]
    $StartArr[5] = $StartArr[0]
  }
  elseif ($StartArr[2] -lt $StartArr[1]) {
    $StartArr[2] = $StartArr[1]
    $StartArr[3] = $StartArr[1]
    $StartArr[4] = $StartArr[1]
    $StartArr[5] = $StartArr[1]
  }
  elseif ($StartArr[3] -lt $StartArr[2]) {
    $StartArr[3] = $StartArr[2]
    $StartArr[4] = $StartArr[2]
    $StartArr[5] = $StartArr[2]
  }
  elseif ($StartArr[4] -lt $StartArr[3]) {
    $StartArr[4] = $StartArr[3]
    $StartArr[5] = $StartArr[3]
  }
  elseif ($StartArr[5] -lt $StartArr[4]) {
    $StartArr[5] = $StartArr[4]
  }

  if ([int]($StartArr -Join "") -ge [int]($EndArr -Join "")) { $Done = $true; }
  else {
    $Result = Select-String -InputObject ($StartArr -join "") -Pattern '(\d)\1+' -AllMatches

    for ($ii = 0; $ii -lt $Result.Matches.Length; $ii++) {
      if ($Result.Matches[$ii].Length -eq 2) {
        $MeetsCriteria++
        break
      }
    }

  }

  $StartArr[5]++
  for ($ii = 5; $ii -gt 0; $ii--) {
    if ($StartArr[$ii] -gt 9) {
      $StartArr[$ii - 1]++
      $StartArr[$ii] = 0
    }
  }



  #$Done = $true
  # ($StartArr -Join "") -eq ($EndArr -Join "")
} until ($Done)

Write-Host "Valid password count: $MeetsCriteria"
