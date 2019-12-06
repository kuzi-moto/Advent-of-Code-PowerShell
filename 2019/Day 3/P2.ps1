Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

Add-Type -AssemblyName System.Drawing


$Data = Get-Content $InputFile
$m = [System.Math]
$Wires = @{ }

# Convert input, so each wire is an array of hastables with a start point, end point,
# and it's orientation.
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
    $length = $m::Abs($x1 - $x2) + $m::Abs($y1 - $y2)
    #$Path.AddLine($x1, $y1, $x2, $y2)
    $Path += @{
      "Start"      = [System.Drawing.Point]::new($x1, $y1)
      "End"        = [System.Drawing.Point]::new($x2, $y2)
      "Horizontal" = $Horizontal
      "Length"     = $length
    }

    $x1 = $x2
    $y1 = $y2
  }
  $Wires."$i" = $Path
  $i++
}

function Get-Intersection {
  param (
    $SegmentOne,
    $SegmentTwo
  )

  if ($SegmentOne.Horizontal -ne $SegmentTwo.Horizontal) {

    $x1 = $SegmentOne.Start.X
    $y1 = $SegmentOne.Start.Y
    $x2 = $SegmentOne.End.X
    $y2 = $SegmentOne.End.Y

    $x3 = $SegmentTwo.Start.X
    $y3 = $SegmentTwo.Start.Y
    $x4 = $SegmentTwo.End.X
    $y4 = $SegmentTwo.End.Y
  }
  else { return $null }

  if ($SegmentOne.Horizontal) {
    # Test if X of line 2 is within X of Line 1
    if ($x3 -lt $m::Min($x1, $x2) -or $x3 -gt $m::Max($x1, $x2)) {
      return $null
    }
    # Test if Y of Line 1 is wihin Y of Line 2
    if ($m::Max($y3, $y4) -lt $y1 -or $m::Min($y3, $y4) -gt $y1) {
      return $null
    }
    if (($x1 -eq 0 -and -$y1 -eq 0) -or ($x3 -eq 0 -and $y3 -eq 0)) {
      return $null
    }
    $x = $x3
    $y = $y1
  }
  else {
    # Test if X of line 2 is within X of Line 1
    if ($x1 -lt $m::Min($x3, $x4) -or $x1 -gt $m::Max($x3, $x4)) {
      return $null
    }
    # Test if Y of Line 1 is wihin Y of Line 2
    if ($m::Max($y1, $y2) -lt $y3 -or $m::Min($y1, $y2) -gt $y3) {
      return $null
    }
    if (($x1 -eq 0 -and -$y1 -eq 0) -or ($x3 -eq 0 -and $y3 -eq 0)) {
      return $null
    }
    $x = $x1
    $y = $y3
  }

  return @{"X" = $x; "Y" = $y }
}

# Calculate all intersections. Only checking where wires orientations are
# opposite.
$Intersections = @()

$Wires.'1' | ForEach-Object {
  $WireOneSegment = $_
  $Wires.'2' | ForEach-Object {
    $Intersection = Get-Intersection -SegmentOne $WireOneSegment -SegmentTwo $_

    if ($Intersection) {
      $Intersections += $Intersection
    }
  }
}

# Calculate the total lengths for both wires
$Wires.Clone().GetEnumerator() | ForEach-Object {
  $Wire = $_.Name
  $PreviousLength = 0
  # Calculate total length for each wire segment
  for ($i = 0; $i -lt $_.Value.Count; $i++) {
    $SegmentLength = $_.Value[$i].Length

    $Wires."$Wire"[$i].TotalLength = $SegmentLength + $PreviousLength
    $PreviousLength = $Wires."$Wire"[$i].TotalLength
  }
}

# Determine total length to all intersections
for ($i = 0; $i -lt $Intersections.Count; $i++) {
  $x = $Intersections[$i].X
  $y = $Intersections[$i].Y
  $CombinedLength = 0

  #
  $Wires.Clone().GetEnumerator() | ForEach-Object {
    # Determine at which segment the intersection occurs
    for ($ii = 0; $ii -lt $_.Value.Count; $ii++) {
      $x1 = $_.Value[$ii].Start.X
      $y1 = $_.Value[$ii].Start.Y
      $x2 = $_.Value[$ii].End.X
      $y2 = $_.Value[$ii].End.Y

      if ($_.Value[$ii].Horizontal) {
        $minx = $m::Min($x1, $x2)
        $maxx = $m::Max($x1, $x2)
        if ($x -gt $minx -and $x -lt $maxx -and $y -eq $y1 ) {
          $CombinedLength += $m::Abs($x1 - $x) + $WireLength
          break
        }
      }
      else {
        $miny = $m::Min($y1, $y2)
        $maxy = $m::Max($y1, $y2)
        if ($y -gt $miny -and $y -lt $maxy -and $x -eq $x1 ) {
          $CombinedLength += $m::Abs($y1 - $y) + $WireLength
          break
        }
      }
      $WireLength = $_.Value[$ii].TotalLength
    }
  }
  $Intersections[$i].Length = $CombinedLength
}

$Ans = $Intersections | ForEach-Object { if ($_.Length -gt 0) { $_.Length } } |
Sort-Object | Select-Object -First 1

Write-Host "Steps to the shortest intersection: $Ans"

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