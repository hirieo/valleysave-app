param(
  [Parameter(Mandatory = $true)]
  [string] $GamePath,

  [Parameter(Mandatory = $true)]
  [string] $TbinDirectory,

  [Parameter(Mandatory = $true)]
  [string] $OutputPath
)

$ErrorActionPreference = 'Stop'

Add-Type -Path (Join-Path $GamePath 'MonoGame.Framework.dll')
Add-Type -Path (Join-Path $GamePath 'xTile.dll')

$maps = [ordered]@{
  0 = 'Farm'
  1 = 'Farm_Fishing'
  2 = 'Farm_Foraging'
  3 = 'Farm_Mining'
  4 = 'Farm_Combat'
  5 = 'Farm_FourCorners'
  6 = 'Farm_Island'
  7 = 'Farm_Ranching'
}

function Get-TileProperty {
  param($Tile, [string] $Name)
  if ($null -eq $Tile) { return $null }
  if ($Tile.Properties.ContainsKey($Name)) {
    return "$($Tile.Properties[$Name])"
  }
  $indexProperties = $Tile.TileSheet.TileIndexProperties[$Tile.TileIndex]
  if ($indexProperties.ContainsKey($Name)) {
    return "$($indexProperties[$Name])"
  }
  return $null
}

function Test-TrueProperty {
  param($Tile, [string] $Name)
  $value = Get-TileProperty $Tile $Name
  return $null -ne $value -and $value -match '^(T|True)$'
}

function Test-FalseProperty {
  param($Tile, [string] $Name)
  $value = Get-TileProperty $Tile $Name
  return $null -ne $value -and $value -match '^(F|False)$'
}

function Set-Bit {
  param([byte[]] $Bytes, [int] $Index)
  $byteIndex = [math]::Floor($Index / 8)
  $bitIndex = $Index % 8
  $Bytes[$byteIndex] = $Bytes[$byteIndex] -bor (1 -shl $bitIndex)
}

function Get-WarpAnchors {
  param($Map, [int] $Width, [int] $Height)
  $raw = "$($Map.Properties['Warp'])".Trim()
  if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
  $parts = $raw -split '\s+'
  $anchors = [System.Collections.Generic.HashSet[int]]::new()
  for ($i = 0; $i + 4 -lt $parts.Length; $i += 5) {
    $x = [int]$parts[$i]
    $y = [int]$parts[$i + 1]
    if ($x -eq -1) { $x = 0 }
    if ($x -eq $Width) { $x = $Width - 1 }
    if ($y -eq -1) { $y = 0 }
    if ($y -eq $Height) { $y = $Height - 1 }
    if ($x -ge 0 -and $x -lt $Width -and $y -ge 0 -and $y -lt $Height) {
      [void]$anchors.Add($y * $Width + $x)
    }
  }
  return @($anchors | Sort-Object)
}

$entries = [System.Collections.Generic.List[string]]::new()

foreach ($pair in $maps.GetEnumerator()) {
  $whichFarm = [int]$pair.Key
  $name = [string]$pair.Value
  $path = Join-Path $TbinDirectory "$name.tbin"
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing unpacked map: $path"
  }

  $map = [xTile.Format.FormatManager]::Instance.LoadMap($path)
  $back = $map.GetLayer('Back')
  $buildings = $map.GetLayer('Buildings')
  $buildings2 = $map.GetLayer('Buildings2')
  if ($null -eq $back -or $null -eq $buildings) {
    throw "$name must contain Back and Buildings layers"
  }

  $width = $back.LayerSize.Width
  $height = $back.LayerSize.Height
  $byteCount = [math]::Ceiling(($width * $height) / 8)
  $water = [byte[]]::new($byteCount)
  $passable = [byte[]]::new($byteCount)
  $buildable = [byte[]]::new($byteCount)
  $fishable = [byte[]]::new($byteCount)

  for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
      $index = $y * $width + $x
      $backTile = $back.Tiles[$x, $y]
      $buildingTiles = @($buildings.Tiles[$x, $y])
      if ($null -ne $buildings2) {
        $buildingTiles += $buildings2.Tiles[$x, $y]
      }
      $presentBuildings = @($buildingTiles | Where-Object { $null -ne $_ })
      $isWater = Test-TrueProperty $backTile 'Water'
      $hasBlockingBuilding = $false
      $hasPassableBridge = $false
      $explicitlyNotBuildable = Test-FalseProperty $backTile 'Buildable'
      $noFishing = Test-TrueProperty $backTile 'NoFishing'

      foreach ($tile in $presentBuildings) {
        if (Test-TrueProperty $tile 'Passable') {
          $hasPassableBridge = $true
        } else {
          $hasBlockingBuilding = $true
        }
        if (Test-FalseProperty $tile 'Buildable') {
          $explicitlyNotBuildable = $true
        }
        if (Test-TrueProperty $tile 'NoFishing') {
          $noFishing = $true
        }
      }

      $isPassable = -not $hasBlockingBuilding -and (-not $isWater -or $hasPassableBridge)
      $isBuildable = -not $isWater -and $presentBuildings.Count -eq 0 -and -not $explicitlyNotBuildable
      $isFishable = $isWater -and -not $noFishing

      if ($isWater) { Set-Bit $water $index }
      if ($isPassable) { Set-Bit $passable $index }
      if ($isBuildable) { Set-Bit $buildable $index }
      if ($isFishable) { Set-Bit $fishable $index }
    }
  }

  $anchors = Get-WarpAnchors $map $width $height
  $anchorText = ($anchors -join ', ')
  $entries.Add(@"
  ${whichFarm}: <String, Object>{
    'name': '$name',
    'width': $width,
    'height': $height,
    'water': '$([Convert]::ToBase64String($water))',
    'passable': '$([Convert]::ToBase64String($passable))',
    'buildable': '$([Convert]::ToBase64String($buildable))',
    'fishable': '$([Convert]::ToBase64String($fishable))',
    'anchors': <int>[$anchorText],
  },
"@)
}

$generated = @"
// GENERATED FILE. DO NOT EDIT.
// Source: vanilla Stardew Valley 1.6.15 XNB maps unpacked to TBin.
// Generator: tool/generate_farm_surfaces.ps1

const vanillaFarmSurfaceData = <int, Map<String, Object>>{
$($entries -join '')};
"@

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
[System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($resolvedOutput)) | Out-Null
[System.IO.File]::WriteAllText($resolvedOutput, $generated, [System.Text.UTF8Encoding]::new($false))
Write-Output "Generated $resolvedOutput"
