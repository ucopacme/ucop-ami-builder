Write-Host "Running image validation tests."
$VALIDATION = $True
if ( -not (Test-Path C:\temp\domainjoin.exe -PathType Leaf)) {
    Write-Host "File not found"
    $VALIDATION = $False
}

if ( -not $VALIDATION ) {
    Write-Host "Image validation Failed"
    exit 1
}

