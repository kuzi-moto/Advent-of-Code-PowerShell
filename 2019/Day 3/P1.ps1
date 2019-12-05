Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$Wires = @{ }

$i = 1
$Data | ForEach-Object {
  #$Path = New-Object -TypeName System.Drawing.Drawing2D.GraphicsPath
  $Path = @()
  $x1 = 0
  $y1 = 0
  $_ -split ',' | ForEach-Object {
    $_ -match '([URDL])(\d+)' | Out-Null
    switch ($Matches[1]) {
      'U' { $x2 = $x1; $y2 = $y1 + $Matches[2]; $Horizontal = $false; break }
      'R' { $x2 = $x1 + $Matches[2]; $y2 = $y1; $Horizontal = $true; break }
      'D' { $x2 = $x1; $y2 = $y1 - $Matches[2]; $Horizontal = $false; break }
      'L' { $x2 = $x1 - $Matches[2]; $y2 = $y1; $Horizontal = $true; break }
      Default { }
    }
    #$Path.AddLine($x1, $y1, $x2, $y2)
    $Path += @{"Start" = [System.Drawing.Point]::new($x1, $y1); "End" = [System.Drawing.Point]::new($x2, $y2); "Horizontal" = $Horizontal }

    $x1 = $x2
    $y1 = $y2
  }
  $Wires."$i" = $Path
  $i++
}

$Intersections = @()

$m = [System.Math]
$test = 1
$Wires.'1' | ForEach-Object {
  $x1 = $_.Start.X
  $y1 = $_.Start.Y
  $x2 = $_.End.X
  $y2 = $_.End.Y
  $Horizontal = $_.Horizontal
  $Wires.'2' | ForEach-Object {
    $test++
    if ($Horizontal -ne $_.Horizontal) {
      $x3 = $_.Start.X
      $y3 = $_.Start.Y
      $x4 = $_.End.X
      $y4 = $_.End.Y
    }
    else { return }

    if ($Horizontal) {
      # Test if X of line 2 is within X of Line 1
      if ($x3 -lt $m::Min($x1, $x2) -or $x3 -gt $m::Max($x1, $x2)) {
        return
      }
      # Test if Y of Line 1 is wihin Y of Line 2
      if ($m::Max($y3, $y4) -lt $y1 -or $m::Min($y3, $y4) -gt $y1) {
        return
      }
      $Intersections += @{"X" = $x3; "Y" = $y1 }
    }
    else {
      # Test if X of line 2 is within X of Line 1
      if ($x1 -lt $m::Min($x3, $x4) -or $x1 -gt $m::Max($x3, $x4)) {
        return
      }
      # Test if Y of Line 1 is wihin Y of Line 2
      if ($m::Max($y1, $y2) -lt $y3 -or $m::Min($y1, $y2) -gt $y3) {
        return
      }
      $Intersections += @{"X" = $x1; "Y" = $y3 }
    }

  }
}

$Ans = $Intersections | ForEach-Object {
  $Distance = $m::Abs(0-$_.X) + $m::Abs(0-$_.Y)
  if ($Distance -gt 0) {$Distance}
} | Sort-Object | Select-Object -Index 0

Write-Host "Manhattan distance to closest intersection: $Ans"

<# Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$TransformX = [System.Math]::Abs(($Lines.PathPoints.X | Sort-Object | Select-Object -First 1))
$TransformY = [System.Math]::Abs(($Lines.PathPoints.Y | Sort-Object | Select-Object -First 1))

$Matrix = [System.Drawing.Drawing2D.Matrix]::new()
$Matrix.Translate($TransformX, $TransformY)

$Line1 = $Lines[0]
$Line2 = $Lines[1]

$Line1.Transform($Matrix)
$Line2.Transform($Matrix)

# Create a Form
$form = New-Object Windows.Forms.Form
$form.AutoScroll = $true

# Get the form's graphics object
$formGraphics = $form.createGraphics()

# Define the paint handler
$form.add_paint(
  {
    $formGraphics.DrawPath([System.Drawing.Pen]::new([System.Drawing.Color]::Red), $Line1)
    $formGraphics.DrawPath([System.Drawing.Pen]::new([System.Drawing.Color]::Blue), $Line2)
  }
)

$form.ShowDialog() | Out-Null   # display the dialog #>