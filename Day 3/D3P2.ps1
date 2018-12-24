param (
  $InputFile = ".\Input.txt"
)
$Data = Get-Content $InputFile
$Claims = @{}
$Data | ForEach-Object {
  $_ -match '#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)' | Out-Null
  $Claims.([Int]$Matches[1]) = [System.Drawing.Rectangle]::new([Int]$Matches[2] + 1, [Int]$Matches[3] + 1, [Int]$Matches[4], [Int]$Matches[5])
}

$Skip = @()
while (!$Result) {
  $Claims.GetEnumerator() | Foreach-Object {
    if ($Skip -contains $_.Key) {
      return
    }
    $ClaimRect = $_.Value
    $ClaimID = $_.Key
    $Count = 0
    $Claims.GetEnumerator() | ForEach-Object {
      if ($ClaimRect.IntersectsWith($_.Value) -and ($ClaimID -ne $_.Key)) {
        $Skip += $ClaimID
        $Skip += $_.Key
        continue
      }
      else {
        $Count ++
      }
    }
    if ($Count = $Claims.Count) {
      $Result = $ClaimID
      continue
    }
    else {
      $Result = $false
    }
  }
}
Write-Host "Claim: $Result"