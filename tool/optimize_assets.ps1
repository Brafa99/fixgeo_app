param(
  [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$sourceRoot = Join-Path $ProjectRoot 'assets\images'
$outputRoot = Join-Path $ProjectRoot 'assets\optimized'

function Export-OptimizedPng {
  param(
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination,
    [Parameter(Mandatory = $true)][int]$MaxDimension
  )

  $destinationDirectory = Split-Path -Parent $Destination
  New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

  $sourceImage = [System.Drawing.Image]::FromFile($Source)
  try {
    $largestDimension = [Math]::Max($sourceImage.Width, $sourceImage.Height)
    if ($largestDimension -le $MaxDimension) {
      Copy-Item -LiteralPath $Source -Destination $Destination -Force
      return
    }

    $scale = $MaxDimension / $largestDimension
    $width = [Math]::Max(1, [int][Math]::Round($sourceImage.Width * $scale))
    $height = [Math]::Max(1, [int][Math]::Round($sourceImage.Height * $scale))
    $bitmap = New-Object System.Drawing.Bitmap(
      $width,
      $height,
      [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    )
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.CompositingMode =
          [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
        $graphics.CompositingQuality =
          [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.InterpolationMode =
          [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode =
          [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode =
          [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.DrawImage(
          $sourceImage,
          [System.Drawing.Rectangle]::new(0, 0, $width, $height)
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

$onboardingSizes = @{
  'logo.png' = 384
  '1_inicio.png' = 640
  'objetc.png' = 640
  'worer.png' = 640
  'work.png' = 640
  '1.png' = 320
  '2.png' = 320
  '3.png' = 320
  '1_1.png' = 320
  '1_2.png' = 320
}

foreach ($entry in $onboardingSizes.GetEnumerator()) {
  Export-OptimizedPng `
    -Source (Join-Path $sourceRoot "onboarding\$($entry.Key)") `
    -Destination (Join-Path $outputRoot "onboarding\$($entry.Key)") `
    -MaxDimension $entry.Value
}

Get-ChildItem -LiteralPath (Join-Path $sourceRoot 'categorias') -Filter '*.png' |
  ForEach-Object {
    Export-OptimizedPng `
      -Source $_.FullName `
      -Destination (Join-Path $outputRoot "categorias\$($_.Name)") `
      -MaxDimension 320
  }

Get-ChildItem -LiteralPath (Join-Path $sourceRoot 'redes') -Filter '*.png' |
  ForEach-Object {
    Export-OptimizedPng `
      -Source $_.FullName `
      -Destination (Join-Path $outputRoot "redes\$($_.Name)") `
      -MaxDimension 320
  }

Write-Output 'Optimized image assets generated.'
