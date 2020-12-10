Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

class Policy {
  [int]$Pos1
  [int]$Pos2
  [string]$Character
  [string]$Password

  [bool]IsValid() {
    $Index = ($This.Password | Select-String $This.Character -AllMatches).Matches.Index
    $Contains1 = $Index -contains ($This.Pos1 - 1)
    $Contains2 = $Index -contains ($This.Pos2 - 1)
    if ($Contains1 -and $Contains2) { return $false }
    if ($Contains1 -or $Contains2) { return $true }
    else { return $false }
  }
}

$Valid = $Data | ForEach-Object {
  $null = $_ -match '(?<one>\d+)-(?<two>\d+) (?<character>\w): (?<password>\w+)'
  $Policy = [Policy]::new()
  $Policy.Pos1 = $Matches.one
  $Policy.Pos2 = $Matches.two
  $Policy.Character = $Matches.character
  $Policy.Password = $Matches.password

  $Policy.IsValid()
} | Where-Object { $_ -eq $true }

$Ans = $Valid.count

Write-Host "Answer: $Ans"
