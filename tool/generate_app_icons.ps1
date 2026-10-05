param(
  [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$source = Join-Path $ProjectRoot 'assets\images\onboarding\logo.png'
$brandBackground = [System.Drawing.Color]::FromArgb(255, 8, 59, 140)

function Export-AppIcon {
  param(
    [Parameter(Mandatory = $true)][string]$Destination,
    [Parameter(Mandatory = $true)][int]$Size
  )

  $sourceImage = [System.Drawing.Image]::FromFile($source)
  try {
    $bitmap = New-Object System.Drawing.Bitmap(
      $Size,
      $Size,
      [System.Drawing.Imaging.PixelFormat]::Format24bppRgb
    )
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.Clear($brandBackground)
        $graphics.CompositingQuality =
          [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.InterpolationMode =
          [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode =
          [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode =
          [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

        $availableSize = $Size * 0.94
        $scale = [Math]::Min(
          $availableSize / $sourceImage.Width,
          $availableSize / $sourceImage.Height
        )
        $width = [int][Math]::Round($sourceImage.Width * $scale)
        $height = [int][Math]::Round($sourceImage.Height * $scale)
        $x = [int][Math]::Round(($Size - $width) / 2)
        $y = [int][Math]::Round(($Size - $height) / 2)
        $graphics.DrawImage(
          $sourceImage,
          [System.Drawing.Rectangle]::new($x, $y, $width, $height)
        )
      }
      finally {
        $graphics.Dispose()
      }

      $bitmap.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
      $bitmap.Dispose()
    }
  }
  finally {
    $sourceImage.Dispose()
  }
}

$androidIcons = @{
  'mipmap-mdpi' = 48
  'mipmap-hdpi' = 72
  'mipmap-xhdpi' = 96
  'mipmap-xxhdpi' = 144
  'mipmap-xxxhdpi' = 192
}

foreach ($entry in $androidIcons.GetEnumerator()) {
  Export-AppIcon `
    -Destination (Join-Path $ProjectRoot "android\app\src\main\res\$($entry.Key)\ic_launcher.png") `
    -Size $entry.Value
}

$iosIconDirectory = Join-Path $ProjectRoot 'ios\Runner\Assets.xcassets\AppIcon.appiconset'
$iosIcons = @{
  'Icon-App-20x20@1x.png' = 20
  'Icon-App-20x20@2x.png' = 40
  'Icon-App-20x20@3x.png' = 60
  'Icon-App-29x29@1x.png' = 29
  'Icon-App-29x29@2x.png' = 58
  'Icon-App-29x29@3x.png' = 87
  'Icon-App-40x40@1x.png' = 40
  'Icon-App-40x40@2x.png' = 80
  'Icon-App-40x40@3x.png' = 120
  'Icon-App-60x60@2x.png' = 120
  'Icon-App-60x60@3x.png' = 180
  'Icon-App-76x76@1x.png' = 76
  'Icon-App-76x76@2x.png' = 152
  'Icon-App-83.5x83.5@2x.png' = 167
  'Icon-App-1024x1024@1x.png' = 1024
}

foreach ($entry in $iosIcons.GetEnumerator()) {
  Export-AppIcon `
    -Destination (Join-Path $iosIconDirectory $entry.Key) `
    -Size $entry.Value
}

Write-Output 'FixGeo launcher icons generated for Android and iOS.'
