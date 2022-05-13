Add-Type -AssemblyName System.Drawing

$systems = 5000
$filename = "$home\foo.png" 
$x = 5000
$y = 5000
$buffer = 5
$bmp = new-object System.Drawing.Bitmap $x,$y
$font = new-object System.Drawing.Font Consolas,8
$colour = [System.Drawing.Color]::Gray
$brushBg = [System.Drawing.Brushes]::Black
$brushFg = [System.Drawing.Brushes]::White
$pen = [System.Drawing.Pen]::Gray
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height)

foreach ($i in 1..$systems) {
    $x_rnd = Get-Random -Minimum 10 -Maximum ($x-$buffer)
    $y_rnd = Get-Random -Minimum 10 -Maximum ($y-$buffer)
    $bmp.SetPixel($x_rnd,$y_rnd,$colour)
    #$rect = New-Object System.Drawing.Rectangle $x_rnd,$y_rnd, 2, 2
    if (($x_rnd+70) -ge $x) {
        $x_text_pos = ($x_rnd-(50+$buffer)) 
    } else {
        $x_text_pos = $x_rnd
    }
    if (($y_rnd+20) -ge $y) {
        $y_text_pos = ($y_rnd-(20+$buffer))
    } else {
        $y_text_pos = $y_rnd
    }
    if (($y_rnd+20) -le $y) {
        $y_text_pos = ($y_rnd-(20+$buffer))
    } else {
        $y_text_pos = $y_rnd
    }
    $graphics.DrawString("System $i",$font,$brushFg,$x_text_pos+1,$y_text_pos)
}
$graphics.Dispose() 
$bmp.Save($filename) 

Invoke-Item $filename 