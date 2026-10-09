# Generate the opaque app icons and native launch images with Windows drawing APIs.
# Run from the repository root: powershell -File tools/generate-branding.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path $PSScriptRoot -Parent
$canvas = New-Object System.Drawing.Bitmap(1728,1728,[System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.SmoothingMode = 'AntiAlias'
$graphics.ScaleTransform(16,16)
$graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#FFF1BF'))
# Native adaptive icons use the same mark at its safe-zone size.
$graphics.TranslateTransform(-13.5,-13.5)
$graphics.ScaleTransform(1.25,1.25)
function Rounded-Rect([single]$x,[single]$y,[single]$w,[single]$h,[single]$r) {
    $path=New-Object System.Drawing.Drawing2D.GraphicsPath
    $d=2*$r
    $path.AddArc($x,$y,$d,$d,180,90)
    $path.AddArc(($x+$w-$d),$y,$d,$d,270,90)
    $path.AddArc(($x+$w-$d),($y+$h-$d),$d,$d,0,90)
    $path.AddArc($x,($y+$h-$d),$d,$d,90,90)
    $path.CloseFigure()
    return $path
}
$ink=New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#1B2233'))
$paper=New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FFFEF8'))
$yellow=New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FFC93C'))
$outline=Rounded-Rect 32 26 44 56 8
$page=Rounded-Rect 44 30 28 48 5
$spine=Rounded-Rect 37 33 3 42 1.5
$graphics.FillPath($ink,$outline)
$graphics.FillPath($paper,$page)
$graphics.FillPath($yellow,$spine)
$blue=New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#1C3FA0'),2.5)
$blue.StartCap='Round'; $blue.EndCap='Round'
$graphics.DrawLine($blue,50,40,65,40)
$graphics.DrawLine($blue,50,48,61,48)
$graphics.FillEllipse($ink,56,55,24,24)
$graphics.FillEllipse($yellow,58,57,20,20)
$check=New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#1B2233'),3)
$check.StartCap='Round'; $check.EndCap='Round'; $check.LineJoin='Round'
$graphics.DrawLines($check,[System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(63,67), [System.Drawing.PointF]::new(67,71), [System.Drawing.PointF]::new(73,63)))
function Write-BrandImage([string]$relativePath,[int]$pixels) {
    $bitmap=New-Object System.Drawing.Bitmap($pixels,$pixels,[System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $drawing=[System.Drawing.Graphics]::FromImage($bitmap)
    try {
        $drawing.InterpolationMode='HighQualityBicubic'
        $drawing.Clear([System.Drawing.ColorTranslator]::FromHtml('#FFF1BF'))
        $drawing.DrawImage($canvas,0,0,$pixels,$pixels)
        $bitmap.Save((Join-Path $projectRoot $relativePath),[System.Drawing.Imaging.ImageFormat]::Png)
        if ($bitmap.Width -ne $pixels -or [System.Drawing.Image]::IsAlphaPixelFormat($bitmap.PixelFormat)) {
            throw 'Brand image must have the requested size and no alpha channel.'
        }
    } finally { $drawing.Dispose(); $bitmap.Dispose() }
}
try {
    Write-BrandImage 'assets/branding/app_icon.png' 1024
    foreach ($density in @(@('mdpi',48),@('hdpi',72),@('xhdpi',96),@('xxhdpi',144),@('xxxhdpi',192))) {
        Write-BrandImage ('android/app/src/main/res/mipmap-'+$density[0]+'/ic_launcher.png') $density[1]
    }
    $catalog=Get-Content (Join-Path $projectRoot 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json') -Raw | ConvertFrom-Json
    foreach ($icon in $catalog.images) {
        $pixels=[int]([double]($icon.size.Split('x')[0]) * [double]($icon.scale.TrimEnd('x')))
        Write-BrandImage ('ios/Runner/Assets.xcassets/AppIcon.appiconset/'+$icon.filename) $pixels
    }
    foreach ($scale in 1,2,3) {
        $suffix=if ($scale -eq 1) { '' } else { '@'+$scale+'x' }
        Write-BrandImage ('ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage'+$suffix+'.png') (160*$scale)
    }
} finally {
    $graphics.Dispose(); $canvas.Dispose(); $outline.Dispose()
    $ink.Dispose(); $paper.Dispose(); $yellow.Dispose(); $blue.Dispose(); $check.Dispose()
    $page.Dispose(); $spine.Dispose()
}


