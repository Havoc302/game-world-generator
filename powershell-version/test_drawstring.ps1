$count = 30
$x = 1000
$y = 1000
$buffer = 5
$labelWidth = 25
$bmp = new-object System.Drawing.Bitmap $x,$y
$colour = "Red"
$brushBg = [System.Drawing.Brushes]::Black
$brushFg = [System.Drawing.Brushes]::$colour
$font = new-object System.Drawing.Font Consolas,8
$pen = [System.Drawing.Pen]::Gray
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height)
foreach ($i in 1..$count) {
    $xRnd = Get-Random -Minimum $buffer -Maximum ($x-$buffer)
    $yRnd = Get-Random -Minimum $buffer -Maximum ($y-$buffer)
    $brushFg = [System.Drawing.Brushes]::$colour
    $bmp.SetPixel($xRnd,$yRnd,$colour)
    if (($xRnd+30) -ge $x) {
        $xTextPos = ($xRnd-($labelWidth+$buffer))
        $yTextPos = $yRnd-$buffer
    } else {
        $xTextPos = $xRnd
    }
    if (($yTextPos+10) -ge $y) {
        $yTextPos = ($yRnd-$buffer)
    } else {
        $yTextPos = $yRnd
    }
    if (($yRnd) -le 10) {
        $yTextPos = ($yRnd+$buffer)
    } else {
        $yTextPos = $yRnd
    }
    $graphics.DrawString($i,$font,$brushFg,$xTextPos,$yTextPos) 
}
$graphics.Dispose()
$bmp.Save("C:\temp\testing123.bmp")
Start-Process "C:\temp\testing123.bmp"