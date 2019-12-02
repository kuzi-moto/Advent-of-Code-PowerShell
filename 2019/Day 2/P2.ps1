Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile
$Program = @()
$Noun = $null
$Data.Split(',') | ForEach-Object { $Program += [int]$_ }

$OriginalState = $Program.Clone()

for ($n = 0; $n -lt 100; $n++) {
  for ($v = 0; $v -lt 100; $v++) {
    $Program[1] = $n
    $Program[2] = $v

    for ($i = 0; $i -lt $Program.Count; $i += 4) {
      $Start = $Program[$i]

      if ($Start -eq 99) {
        break
      }
      if ($Start -ne 1 -and $Start -ne 2) {
        break
      }

      $Value1 = $Program[$Program[$i + 1]]
      $Value2 = $Program[$Program[$i + 2]]
      $StoreAt = $Program[$i + 3]

      if ($Start -eq 1) {
        $NewValue = $Value1 + $Value2
      }
      else {
        $NewValue = $Value1 * $Value2
      }

      $Program[$StoreAt] = $NewValue
    }

    if ($Program[0] -eq 19690720) {
      $Noun = $n
      $Verb = $v
      break
    }

    $Program = $OriginalState.Clone()
  }
  if ($Noun) { break }
}

$Ans = (100 * $Noun) + $Verb

Write-Host "Answer: $Ans"