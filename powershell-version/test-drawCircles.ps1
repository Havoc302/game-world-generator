Add-Type -AssemblyName System.Drawing

$bitmap1 = new-object System.Drawing.Bitmap 1000,1000

$brush1 = [System.Drawing.Brushes]::Black

$brush2 = [System.Drawing.Brushes]::LightBlue

$graphics1 = [System.Drawing.Graphics]::FromImage($bitmap1)

$graphics1.FillRectangle($brush1,0,0,$bitmap1.Width,$bitmap1.Height)

$pen1 = New-Object System.Drawing.Pen DarkSlateGray

$graphics1.DrawEllipse($pen1, 450, 450, 100, 100)

$graphics1.FillEllipse($brush2, 450, 450, 100, 100)

$graphics1.Dispose()

$bitmap1.Save("C:\temp\test1.bmp")

Start-Process "C:\temp\test1.bmp"