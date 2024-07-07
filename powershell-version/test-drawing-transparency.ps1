Add-Type -AssemblyName System.Drawing

# Define the dimensions of the bitmap
$width = 500
$height = 500

# Create a new bitmap
$bitmap = New-Object System.Drawing.Bitmap($width, $height)

# Create a graphics object from the bitmap
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Set the background color to white
$graphics.Clear([System.Drawing.Color]::White)

# Define the circle's center and radius
$centerX = $width / 2
$centerY = $height / 2
$radius = 100

# Create a color with transparency (alpha value)
$alpha = 128 # 0 (completely transparent) to 255 (completely opaque)
$circleColor = [System.Drawing.Color]::FromArgb($alpha, 255, 0, 0) # Red with transparency

# Create a brush with the transparent color
$brush = New-Object System.Drawing.SolidBrush($circleColor)

$pen = New-Object System.Drawing.Pen DarkSlateGray

$graphics.DrawLine($gridPen,0,0,$height,$width)

# Draw the circle
$graphics.FillEllipse($brush, $centerX - $radius, $centerY - $radius, $radius * 2, $radius * 2)

# Save the bitmap to a file
$bitmap.Save("$env:USERPROFILE\desktop\circle_with_transparency.bmp", [System.Drawing.Imaging.ImageFormat]::Bmp)

# Clean up
$graphics.Dispose()
$bitmap.Dispose()
$brush.Dispose()

Start-Process explorer "$env:USERPROFILE\desktop\circle_with_transparency2.bmp"