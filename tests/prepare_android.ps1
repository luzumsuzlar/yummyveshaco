param(
    [switch]$Build,
    [string]$ApkPath = '',
    [string]$GodotPath = 'D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64_console.exe',
    [string]$AaptPath = 'C:\Users\Zalman\AppData\Local\Android\Sdk\build-tools\36.0.0\aapt.exe',
    [string]$JavaPath = 'C:\Program Files\Android\Android Studio\jbr\bin\java.exe'
)

# Local preparation only. Never installs, uninstalls, uploads, or changes presets.
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$presetLines = Get-Content -LiteralPath (Join-Path $projectRoot 'export_presets.cfg')
$versionCode = [regex]::Match(($presetLines -join "`n"), '(?m)^version/code=(\d+)\r?$').Groups[1].Value
$versionName = [regex]::Match(($presetLines -join "`n"), '(?m)^version/name="([^"]+)"\r?$').Groups[1].Value
if (-not $versionCode -or -not $versionName) { throw 'Preset version metadata missing.' }
if (-not $ApkPath) { $ApkPath = "exports/android/yumi-sako-$versionName.apk" }
if (-not [IO.Path]::IsPathRooted($ApkPath)) { $ApkPath = Join-Path $projectRoot $ApkPath }
$targetPath = [IO.Path]::GetFullPath($ApkPath)
$androidRoot = [IO.Path]::GetFullPath((Join-Path $projectRoot 'exports\android'))
if (-not $targetPath.StartsWith($androidRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -or
    [IO.Path]::GetExtension($targetPath) -ne '.apk') {
    throw 'Target must be an APK inside this project exports/android directory.'
}
if ($Build -and (Test-Path -LiteralPath $targetPath)) {
    throw 'Refusing to overwrite an existing APK. Choose a new filename or verify without -Build.'
}
if (-not (Test-Path -LiteralPath $AaptPath -PathType Leaf)) { throw 'Existing aapt executable not found; no installation attempted.' }
$signerJar = Join-Path ([IO.Path]::GetDirectoryName($AaptPath)) 'lib\apksigner.jar'
if (-not (Test-Path -LiteralPath $JavaPath -PathType Leaf) -or -not (Test-Path -LiteralPath $signerJar -PathType Leaf)) {
    throw 'Existing Java/apksigner tools missing; specify paths. No environment setting or installation attempted.'
}
if ($Build) {
    if (-not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) { throw 'Existing Godot console executable not found.' }
    & (Join-Path $PSScriptRoot 'run_checks.ps1') -GodotPath $GodotPath
    New-Item -ItemType Directory -Path ([IO.Path]::GetDirectoryName($targetPath)) -Force | Out-Null
    $logRoot = Join-Path $projectRoot 'exports\check-logs'
    $exportArguments = @('--headless', '--path', ('"' + $projectRoot + '"'), '--export-debug', '"Android Test"', ('"' + $targetPath + '"'))
    $exportProcess = Start-Process -FilePath $GodotPath -ArgumentList $exportArguments -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logRoot 'android-export.out.log') -RedirectStandardError (Join-Path $logRoot 'android-export.err.log')
    $exportFinished = $false
    for ($attempt = 0; $attempt -lt 4; $attempt++) {
        if ($exportProcess.WaitForExit(30000)) { $exportFinished = $true; break }
        Write-Host 'Local Android export still running...'
    }
    if (-not $exportFinished) {
        $exportProcess.Kill()
        throw "Android export timed out; partial output is not approved. Logs: $logRoot"
    }
    $exportProcess.WaitForExit()
    if ($exportProcess.ExitCode -ne 0) { throw "Android export failed; output is not approved. Logs: $logRoot" }
}
if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) { throw 'APK missing. Use -Build with a new filename to prepare one.' }
& (Join-Path $PSScriptRoot 'audit_apk.ps1') -ApkPath $targetPath
$badging = @(& $AaptPath dump badging $targetPath 2>&1)
if ($LASTEXITCODE -ne 0) { throw 'Android manifest inspection failed.' }
$packageLine = @($badging | Where-Object { $_ -match '^package:' })
$nativeLine = @($badging | Where-Object { $_ -match '^native-code:' })
if ($packageLine.Count -ne 1 -or
    $packageLine[0] -notmatch "name='com\.yumisako\.prototype'" -or
    $packageLine[0] -notmatch ("versionCode='" + [regex]::Escape($versionCode) + "'") -or
    $packageLine[0] -notmatch ("versionName='" + [regex]::Escape($versionName) + "'") -or
    $nativeLine.Count -ne 1 -or $nativeLine[0] -ne "native-code: 'arm64-v8a'") {
    throw 'APK package/version/architecture does not match the current preset.'
}
Write-Host $packageLine[0]
Write-Host $nativeLine[0]
& $JavaPath -jar $signerJar verify $targetPath
if ($LASTEXITCODE -ne 0) { throw 'APK signature verification failed.' }
Write-Host 'Local resource, manifest, and signature checks passed. Physical Android testing is still required.'
