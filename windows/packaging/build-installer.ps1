# Compila el instalador Windows de ValleySave con la version de pubspec.yaml
# (2026-07-21: antes MyAppVersion se editaba a mano en valleysave.iss, se
# desincronizo de la app real al menos una vez). Requiere que
# flutter build windows --release ya se haya ejecutado.
#
# Uso: powershell -File windows\packaging\build-installer.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$pubspec = Get-Content (Join-Path $root 'pubspec.yaml') -Raw
if ($pubspec -notmatch 'version:\s*(\d+\.\d+\.\d+)') {
    throw "No se pudo leer la version de pubspec.yaml"
}
$version = $Matches[1]
Write-Host "Version detectada en pubspec.yaml: $version"

$iscc = "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $iscc)) {
    throw "No se encuentra ISCC.exe en $iscc"
}

& $iscc "/DMyAppVersion=$version" (Join-Path $PSScriptRoot 'valleysave.iss')
if ($LASTEXITCODE -ne 0) { throw "ISCC.exe fallo (codigo $LASTEXITCODE)" }

$distDir = Join-Path $root 'dist'
$setupExe = Join-Path $distDir "ValleySave-Setup-v$version.exe"
$zipFile  = Join-Path $distDir "ValleySave-v$version-windows.zip"

$shaLines = @()
foreach ($f in @($setupExe, $zipFile)) {
    if (Test-Path $f) {
        $hash = (Get-FileHash -Path $f -Algorithm SHA256).Hash.ToLower()
        $shaLines += "$hash  $(Split-Path -Leaf $f)"
        Write-Host "SHA-256 $(Split-Path -Leaf $f): $hash"
    }
}
if ($shaLines.Count -gt 0) {
    $shaPath = Join-Path $distDir 'SHA256SUMS-windows.txt'
    # Out-File -Encoding utf8 en PowerShell 5.1 escribe BOM, lo que rompe
    # "sha256sum -c" al leer la primera linea. UTF8 sin BOM via .NET directo.
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($shaPath, ($shaLines -join "`n") + "`n", $utf8NoBom)
    Write-Host "Hashes guardados en $shaPath"
}

Write-Host "Listo: $setupExe"
