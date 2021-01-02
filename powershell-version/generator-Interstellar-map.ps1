Add-Type -AssemblyName System.Drawing

$filename = "$home\foo1.png" 
$bmp = new-object System.Drawing.Bitmap 5000,5000 
$font = new-object System.Drawing.Font Consolas,8
$brushBg = [System.Drawing.Brushes]::Black
$brushFg = [System.Drawing.Brushes]::White 
$graphics = [System.Drawing.Graphics]::FromImage($bmp) 
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height)  
$graphics.Dispose() 
$bmp.Save($filename) 

Invoke-Item $filename 