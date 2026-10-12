param(
    [string]$ApkPath = (Join-Path $PSScriptRoot '..\exports\android\yumi-sako-test.apk'),
    [switch]$AuditOnly
)

# Read-only ZIP entry inspection: never extract, install, or alter the APK.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$resolvedApk = (Resolve-Path -LiteralPath $ApkPath).Path
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolvedApk)
try {
    $entries = @($archive.Entries | ForEach-Object { $_.FullName })
    if (@($entries | Where-Object { $_ -match '\.pck$' }).Count -gt 0) {
        throw 'Embedded PCK format cannot be audited by this ZIP-only check; do not infer a clean package.'
    }
    if (-not ($entries -match '^assets/assets/art/') -or
        -not ($entries -match '^assets/scripts/main\.gd(c|\.remap)$')) {
        throw 'Expected Godot Android resource layout not found; package audit is inconclusive.'
    }
    $forbidden = @($entries | Where-Object {
        $_ -match '(^|/)(tests|docs|exports|sources)/' -or
        $_ -match '\.(xls|xlsx|csv|tsv|log)(\.|$)' -or
        $_ -match '(^|/)(sleep\.jpg|Generated Image[^/]*|yumi-sleep-v1\.png)(-|\.|$)'
    })
    Write-Host "APK: $resolvedApk"
    Write-Host "SHA256: $((Get-FileHash -LiteralPath $resolvedApk -Algorithm SHA256).Hash)"
    Write-Host "Inspected $($entries.Count) ZIP entries. Forbidden entries: $($forbidden.Count)."
    foreach ($entry in $forbidden) { Write-Host "NOT FOR DISTRIBUTION: $entry" }
    if ($forbidden.Count -gt 0 -and -not $AuditOnly) {
        throw 'Package contains reference/private/test resources. Build and audit a clean package before sharing.'
    }
    if ($forbidden.Count -eq 0) {
        Write-Host 'No listed forbidden resources found. This is not a full privacy or playability guarantee.'
    }
} finally {
    $archive.Dispose()
}
