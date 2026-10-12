param(
    [string]$GodotPath = 'D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64_console.exe'
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) {
    throw 'Godot console executable not found; specify -GodotPath.'
}
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$logRoot = Join-Path $projectRoot 'exports\check-logs'
New-Item -ItemType Directory -Path $logRoot -Force | Out-Null
$checks = @(
	'hole_drop_smoke',
    'input_lifecycle_smoke', 'audio_state_smoke', 'save_notice_smoke', 'save_recovery_smoke', 'interaction_smoke', 'progress_smoke', 'pause_smoke', 'tutorial_smoke', 'purr_smoke',
    'audio_smoke', 'menu_smoke', 'paw_smoke', 'scatter_smoke',
    'toy_smoke', 'portrait_smoke', 'wall_smoke', 'art_smoke',
    'character_art_smoke', 'walk_smoke'
)
foreach ($check in $checks) {
    $outputPath = Join-Path $logRoot "$check.out.log"
    $errorPath = Join-Path $logRoot "$check.err.log"
    $arguments = @('--headless', '--path', ('"' + $projectRoot + '"'), '--script', "res://tests/$check.gd")
    $checkProcess = Start-Process -FilePath $GodotPath -ArgumentList $arguments -PassThru -WindowStyle Hidden -RedirectStandardOutput $outputPath -RedirectStandardError $errorPath
    if (-not $checkProcess.WaitForExit(45000)) {
        $checkProcess.Kill()
        throw "Check timed out: $check. Logs: $logRoot"
    }
    $checkProcess.WaitForExit()
    Get-Content -LiteralPath $outputPath
    Get-Content -LiteralPath $errorPath
    if ($checkProcess.ExitCode -ne 0) {
        throw "Check failed: $check (exit $($checkProcess.ExitCode))"
    }
}
Write-Host "All $($checks.Count) checks passed. Physical Android testing is still required."
