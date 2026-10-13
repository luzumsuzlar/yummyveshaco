$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$fixtureRoot = Join-Path $projectRoot ('exports/package-resource-fixtures/' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
$textures = @('kitchen-background-v1', 'cupboard-v1', 'yumi-idle-v1', 'yumi-sleep-v2', 'yumi-paw-v1', 'yumi-walk-v1', 'shako-idle-v1', 'yumi-groom-v1', 'shako-reactions-v1')
foreach ($case in @('complete', 'missing-groom', 'missing-shako', 'legacy')) {
    # Synthetic empty ZIP entries only; these files are NOT installable APKs.
    $path = Join-Path $fixtureRoot ($case + '.zip')
    $zip = [IO.Compression.ZipFile]::Open($path, [IO.Compression.ZipArchiveMode]::Create)
    try {
        $null = $zip.CreateEntry('assets/assets/art/marker')
        foreach ($name in @('main', 'game_audio', 'game_progress')) { $null = $zip.CreateEntry("assets/scripts/$name.gdc") }
        foreach ($name in $textures) {
            if (($case -in @('legacy', 'missing-groom') -and $name -eq 'yumi-groom-v1') -or
                ($case -in @('legacy', 'missing-shako') -and $name -eq 'shako-reactions-v1')) { continue }
            $null = $zip.CreateEntry("assets/.godot/imported/$name.png-fixture.ctex")
        }
    } finally { $zip.Dispose() }
    $rejected = $false
    try { & (Join-Path $PSScriptRoot 'audit_apk.ps1') -ApkPath $path }
    catch {
        if ($_.Exception.Message -notlike 'Required game texture missing:*') { throw }
        $rejected = $true
    }
    if ($rejected -ne ($case -ne 'complete')) { throw "Unexpected resource audit result: $case" }
    if ($case -eq 'legacy') {
        & (Join-Path $PSScriptRoot 'audit_apk.ps1') -ApkPath $path -ResourceSet Legacy013
    }
}
$legacyBuildRejected = $false
try { & (Join-Path $PSScriptRoot 'prepare_android.ps1') -Build -ResourceSet Legacy013 }
catch {
    if ($_.Exception.Message -notlike 'New builds must use Current resources*') { throw }
    $legacyBuildRejected = $true
}
if (-not $legacyBuildRejected) { throw 'Legacy resource set was incorrectly accepted for a new build.' }
Write-Host 'Four synthetic resource cases and legacy-build guard passed. No APK built or installed.'
