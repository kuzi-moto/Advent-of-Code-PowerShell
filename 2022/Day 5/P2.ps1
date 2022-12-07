Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

function Write-CrateLayout {
  param ($Layout)

  $i = 0
  $Output = @()

  do {
    # Row

    $LineArray = @()

    for ($ii = 0; $ii -lt $Layout.Count; $ii++) {
      # Column

      if ($Layout[$ii][$i]) {
        $LineArray += "[$($Layout[$ii][$i])]"
      }
      else {
        $LineArray += '   '
      }

    }

    $Line = @($LineArray -join ' ')
    $Output = $Line + $Output
    $i++

  } until ($Line -notmatch '\w')

  # Add column numbers at the bottom
  $Output += (1..$Layout.Count | ForEach-Object {
      " $_ "
    }) -join ' '

  $Output | Out-Host
  
}

function Move-Crate {
  param (
    $Layout,
    [int]$Count,
    [int]$Source,
    [int]$Destination
  )

  $Start = $Layout[$Source].Count - $Count
  $End = $Layout[$Source].Count - 1

  # Gets the crate(s) to move
  $Crates = $Layout[$Source][$Start..$End]

  # Remove from source
  $Layout[$Source].RemoveRange($Start, $Count)

  # Add to destination
  $null = $Layout[$Destination].AddRange($Crates)

  $Layout

}

$Data = Get-Content $InputFile

<#
1. Get numbers of stack, and index of the bottom.
2. Work backwards to create the initial configuration.
3. Iterate through the instructions to complete the moves.
#>

# Get the index for the stack numbers.
for ($i = 0; $i -lt $Data.Count; $i++) {
  if ($Data[$i] -match '^\s\d') {
    $StackIndex = $i
    $i = $Data.Count
  }
}

# Determine number of columns and create array
$Columns = ($Data[$StackIndex] -split '   ').Count
$CrateLayout = @($null) * $Columns

# Instantiate a null ArrayList in each column.
# I think there might be a better way to do this.
for ($i = 0; $i -lt $CrateLayout.Count; $i++) {
  $CrateLayout[$i] = [System.Collections.ArrayList]::new()
}

# Build the array
# Work up from the row numbers
for ($i = $StackIndex - 1; $i -ge 0; $i--) {

  # Navigate each column in the row and add to array
  for ($ii = 0; $ii -lt $Columns; $ii++) {
    
    # Grab the crate and add it to its column
    $Crate = $Data[$i].Substring(($ii * 4 + 1), 1)
    if ($Crate -match '\w') { $null = $CrateLayout[$ii].add($Crate) }

  }

}

Write-CrateLayout $CrateLayout

for ($i = $StackIndex + 2; $i -lt $Data.Count; $i++) {
  
  # move 1 from 8 to 4
  $null = $Data[$i] -match '(\d+) from (\d) to (\d)'

  Write-Host
  $Data[$i]
  $CrateLayout = Move-Crate $CrateLayout.Clone() $Matches[1] ($Matches[2] - 1) ($Matches[3] - 1)

  Write-CrateLayout $CrateLayout

}

# Get last crate of each stack
$Answer = ($CrateLayout.GetEnumerator() | ForEach-Object { $_[-1] }) -join ''

Write-Host "Answer: $Answer"
