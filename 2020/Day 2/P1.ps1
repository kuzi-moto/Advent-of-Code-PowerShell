Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

class Policy {
  [int]$MinReq
  [int]$MaxReq
  [string]$Character
  [string]$Password

  [bool]IsValid(){
    $Count = ($This.Password.GetEnumerator() | Where-Object { $_ -eq $This.Character }).count
    return $Count -ge $This.MinReq -and $Count -le $This.MaxReq
  }
}

$Valid = $Data | ForEach-Object {
  $null = $_ -match '(?<min>\d+)-(?<max>\d+) (?<character>\w): (?<password>\w+)'
  $Policy = [Policy]::new()
  $Policy.MinReq = $Matches.min
  $Policy.MaxReq = $Matches.max
  $Policy.Character = $Matches.character
  $Policy.Password = $Matches.password

  $Policy.IsValid()
} | Where-Object { $_ -eq $true }

$Ans = $Valid.count

Write-Host "Answer: $Ans"
