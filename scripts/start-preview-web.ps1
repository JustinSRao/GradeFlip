param(
    [int]$Port = 4173
)

$projectRoot = Split-Path -Parent $PSScriptRoot
$previewRoot = Join-Path $projectRoot "apps\GradeFlipPreviewWeb"

if (-not (Test-Path $previewRoot)) {
    throw "Preview harness not found at $previewRoot"
}

Write-Host "Starting GradeFlip preview harness on http://127.0.0.1:$Port"
Write-Host "Press Ctrl+C to stop."

python -m http.server $Port --bind 127.0.0.1 --directory $previewRoot
