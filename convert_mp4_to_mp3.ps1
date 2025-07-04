param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    [string]$OutputPath
)

if (-not $OutputPath) {
    $OutputPath = Join-Path $SourcePath "MP3"
}

if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory | Out-Null
}

$mp4Files = Get-ChildItem -Path $SourcePath -Filter *.mp4

if ($mp4Files.Count -eq 0) {
    Write-Host 'Brak plików MP4 w' $SourcePath -ForegroundColor Yellow
    exit
}

foreach ($file in $mp4Files) {
    $in   = $file.FullName
    $name = [System.IO.Path]::GetFileNameWithoutExtension($in)
    $out  = Join-Path $OutputPath "$name.mp3"

    Write-Host 'Konwertuję' $in '->' $out
    ffmpeg -i $in -vn -codec:a libmp3lame -qscale:a 2 $out

    if ($LASTEXITCODE -eq 0) {
        Write-Host '  OK:' $out -ForegroundColor Green
    }
    else {
        Write-Host '  BŁĄD przy:' $in -ForegroundColor Red
    }
}

Write-Host 'Gotowe!' -ForegroundColor Cyan
