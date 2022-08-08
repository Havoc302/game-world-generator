$count = 10

$filename = "$home\foo.png" 
$bmp = new-object System.Drawing.Bitmap 250,61 
$font = new-object System.Drawing.Font Consolas,24 
$brushBg = [System.Drawing.Brushes]::Yellow 
$brushFg = [System.Drawing.Brushes]::Black 
$graphics = [System.Drawing.Graphics]::FromImage($bmp) 
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height) 
$x = 1
foreach ($i in 1..$count) {
    $x = $x+20
    $graphics.DrawString($i,$font,$brushFg,$x,10) 
}
$graphics.Dispose() 
$bmp.Save($filename) 

Start-Process C:\Users\Havoc\foo.png