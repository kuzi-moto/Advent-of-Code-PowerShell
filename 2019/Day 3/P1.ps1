Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt"),
  [switch]$Display
)

$Data = Get-Content $InputFile

$Lines = @()

$Data | ForEach-Object {
  $Path = New-Object -TypeName System.Drawing.Drawing2D.GraphicsPath
  $x1 = 0
  $y1 = 0
  $_ -split ',' | ForEach-Object {
    $_ -match '([URDL])(\d+)' | Out-Null
    switch ($Matches[1]) {
      'U' { $x2 = $x1; $y2 = $y1 + $Matches[2]; break }
      'R' { $x2 = $x1 + $Matches[2]; $y2 = $y1; break }
      'D' { $x2 = $x1; $y2 = $y1 - $Matches[2]; break }
      'L' { $x2 = $x1 - $Matches[2]; $y2 = $y1; break }
      Default { }
    }
    $Path.AddLine($x1, $y1, $x2, $y2)
    $x1 = $x2
    $y1 = $y2
  }
  $Lines += $Path
}

if ($Display) {
  Add-Type -AssemblyName System.Drawing
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
  $form.AutoSize = $true
  $form.VerticalScroll.Visible = $true
  $form.HorizontalScroll.Visible = $true

  # Get the form's graphics object
  $formGraphics = $form.createGraphics()

  # Define the paint handler
  $form.add_paint(
    {
      $formGraphics.DrawPath([System.Drawing.Pen]::new([System.Drawing.Color]::Red), $Line1)
      $formGraphics.DrawPath([System.Drawing.Pen]::new([System.Drawing.Color]::Blue), $Line2)
    }
  )

  $form.ShowDialog() | Out-Null   # display the dialog
}


# Write-Host "Answer: "
