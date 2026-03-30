param(
    [int]$Port = 4173
)

$projectRoot = Split-Path -Parent $PSScriptRoot
$previewRoot = Join-Path $projectRoot "apps\GradeFlipPreviewWeb"

if (-not (Test-Path $previewRoot)) {
    throw "Preview harness not found at $previewRoot"
}

$process = $null

try {
    $process = Start-Process cmd.exe -ArgumentList "/c", "python -m http.server $Port --bind 127.0.0.1 --directory `"$previewRoot`"" -PassThru -WindowStyle Hidden

    $html = $null
    for ($attempt = 0; $attempt -lt 10; $attempt++) {
        Start-Sleep -Milliseconds 700
        try {
            $html = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/index.html" -UseBasicParsing
            break
        }
        catch {
            if ($process.HasExited) {
                throw "Preview server exited before responding."
            }
        }
    }

    if (-not $html) {
        throw "Preview server did not respond in time."
    }

    $json = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/preview-state.json" -UseBasicParsing

    if ($html.Content -notmatch "GradeFlip Preview Harness") {
        throw "Preview HTML did not contain the expected title."
    }

    if ($html.Content -notmatch "Study" -or $html.Content -notmatch "Decks") {
        throw "Preview HTML did not expose the expected offline tabs."
    }

    $payload = $json.Content | ConvertFrom-Json
    if (-not $payload.decks -or $payload.decks.Count -lt 2) {
        throw "Preview JSON fixture did not expose the expected deck data."
    }

    Write-Host "Preview harness smoke test passed."
}
finally {
    if ($process -and -not $process.HasExited) {
        Stop-Process -Id $process.Id -Force
    }
}
