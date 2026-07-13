param(
    [string]$SavesDir = "$env:APPDATA\StardewValley\Saves",
    [string]$SaveFolder,
    [string]$TargetPlayer,
    [ValidateSet("KeepExterior","SwapExterior")]
    [string]$Mode,
    [switch]$CleanFootprint,
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Xml.Linq

$ContentFields = @(
    "buildings", "animals", "piecesOfHay", "characters", "objects", "resourceClumps",
    "largeTerrainFeatures", "terrainFeatures", "numberOfSpawnedObjectsOnMap",
    "miniJukeboxCount", "miniJukeboxTrack", "furniture", "Animals", "IsGreenhouse",
    "wallPaper", "appliedWallpaper", "floor", "appliedFloor", "fridge",
    "fridgePosition", "cribStyle"
)

function Read-ChoiceIndex {
    param([string]$Prompt, [int]$Max)
    while ($true) {
        $raw = Read-Host $Prompt
        $idx = 0
        if ([int]::TryParse($raw, [ref]$idx) -and $idx -ge 1 -and $idx -le $Max) { return $idx - 1 }
        Write-Host "Seleccion invalida. Elige 1-$Max." -ForegroundColor Yellow
    }
}

function Get-MainSavePath {
    param([string]$Folder)
    $name = Split-Path $Folder -Leaf
    $exact = Join-Path $Folder $name
    if (Test-Path -LiteralPath $exact) { return $exact }
    $candidate = Get-ChildItem -LiteralPath $Folder -File |
        Where-Object { $_.Name -ne "SaveGameInfo" -and $_.Extension -eq "" } |
        Select-Object -First 1
    if ($null -eq $candidate) { throw "No encuentro archivo principal en $Folder" }
    return $candidate.FullName
}

function Load-XDoc { param([string]$Path) [System.Xml.Linq.XDocument]::Load($Path, [System.Xml.Linq.LoadOptions]::PreserveWhitespace) }

function Save-XDoc {
    param($Doc, [string]$Path)
    $settings = [System.Xml.XmlWriterSettings]::new()
    $settings.Encoding = [Text.UTF8Encoding]::new($false)
    $settings.Indent = $false
    $settings.OmitXmlDeclaration = $false
    $writer = [System.Xml.XmlWriter]::Create($Path, $settings)
    try { $Doc.Save($writer) } finally { $writer.Close() }
}

function Set-ElementValue {
    param($Parent, [string]$Name, [string]$Value)
    $e = $Parent.Element($Name)
    if ($null -eq $e) { $Parent.Add([System.Xml.Linq.XElement]::new($Name, $Value)) } else { $e.Value = $Value }
}

function Set-NetString {
    param($Parent, [string]$Name, [string]$Value)
    $e = $Parent.Element($Name)
    if ($null -eq $e) { $e = [System.Xml.Linq.XElement]::new($Name); $Parent.Add($e) }
    $e.RemoveNodes()
    $e.Add([System.Xml.Linq.XElement]::new("string", $Value))
}

function Set-NetStringNil {
    param($Parent, [string]$Name)
    $e = $Parent.Element($Name)
    if ($null -eq $e) { $e = [System.Xml.Linq.XElement]::new($Name); $Parent.Add($e) }
    $e.RemoveNodes()
    $s = [System.Xml.Linq.XElement]::new("string")
    $xsi = [System.Xml.Linq.XNamespace]"http://www.w3.org/2001/XMLSchema-instance"
    $s.SetAttributeValue($xsi + "nil", "true")
    $e.Add($s)
}

function Copy-InteriorContent {
    param($Source, $Target, [string[]]$Fields)
    foreach ($name in $Fields) {
        $sourceNode = $Source.Element($name)
        $targetNode = $Target.Element($name)
        if ($null -eq $sourceNode -or $null -eq $targetNode) { throw "Falta campo interior '$name'." }
        $targetNode.ReplaceWith([System.Xml.Linq.XElement]::new($sourceNode))
    }
}

function Get-FarmLocation {
    param($Root)
    $farm = $Root.Element("locations").Elements("GameLocation") |
        Where-Object { ($_.Element("name").Value) -eq "Farm" } | Select-Object -First 1
    if ($null -eq $farm) { throw "No encuentro la localizacion Farm." }
    $farm
}

function Get-TopFarmHouse {
    param($Root)
    $house = $Root.Element("locations").Elements("GameLocation") |
        Where-Object { ($_.Element("name").Value) -eq "FarmHouse" } | Select-Object -First 1
    if ($null -eq $house) { throw "No encuentro la localizacion FarmHouse." }
    $house
}

function Get-Buildings { param($Farm) @($Farm.Element("buildings").Elements("Building")) }

function Get-FarmhouseBuilding {
    param($Farm)
    $b = Get-Buildings $Farm | Where-Object { ($_.Element("buildingType").Value) -eq "Farmhouse" } | Select-Object -First 1
    if ($null -eq $b) { throw "No encuentro Building Farmhouse." }
    $b
}

function Get-CabinByUniqueName {
    param($Farm, [string]$UniqueName)
    Get-Buildings $Farm | Where-Object {
        $indoors = $_.Element("indoors")
        ($_.Element("buildingType").Value) -eq "Cabin" -and $null -ne $indoors -and
        $null -ne $indoors.Element("uniqueName") -and ($indoors.Element("uniqueName").Value) -eq $UniqueName
    } | Select-Object -First 1
}

function Get-CabinsWithIndoors {
    param($Farm)
    @(Get-Buildings $Farm | Where-Object {
        $indoors = $_.Element("indoors")
        ($_.Element("buildingType").Value) -eq "Cabin" -and $null -ne $indoors -and $null -ne $indoors.Element("uniqueName")
    })
}

function New-SaveId {
    param([string]$SavesDir, [string]$Prefix)
    do {
        $id = Get-Random -Minimum 100000000 -Maximum 999999999
        $folder = Join-Path $SavesDir ("{0}_{1}" -f $Prefix, $id)
    } while (Test-Path -LiteralPath $folder)
    @{ Id = $id; Folder = $folder; MainName = ("{0}_{1}" -f $Prefix, $id) }
}

function Remove-EmptyFarmhandForHome {
    param($Farmhands, [string]$HomeLocation)
    $empty = $Farmhands.Elements("Farmer") | Where-Object {
        $nameNode = $_.Element("name")
        $homeNode = $_.Element("homeLocation")
        ($null -eq $nameNode -or [string]::IsNullOrWhiteSpace($nameNode.Value)) -and
        $null -ne $homeNode -and $homeNode.Value -eq $HomeLocation
    } | Select-Object -First 1
    if ($null -ne $empty) { $empty.Remove() }
}

function Clean-BuildingFootprint {
    param($Farm, $Building)
    $x0 = [int]$Building.Element("tileX").Value
    $y0 = [int]$Building.Element("tileY").Value
    $w = [int]$Building.Element("tilesWide").Value
    $h = [int]$Building.Element("tilesHigh").Value
    $x1 = $x0 + $w - 1
    $y1 = $y0 + $h - 1
    foreach ($containerName in @("terrainFeatures", "objects")) {
        $container = $Farm.Element($containerName)
        if ($null -eq $container) { continue }
        $toRemove = @()
        foreach ($item in $container.Elements("item")) {
            $vec = $item.Element("key").Element("Vector2")
            if ($null -eq $vec) { continue }
            $tx = [int][double]$vec.Element("X").Value
            $ty = [int][double]$vec.Element("Y").Value
            if ($tx -ge $x0 -and $tx -le $x1 -and $ty -ge $y0 -and $ty -le $y1) { $toRemove += $item }
        }
        foreach ($item in $toRemove) { $item.Remove() }
    }
}

if (!(Test-Path -LiteralPath $SavesDir)) { throw "No existe SavesDir: $SavesDir" }

if ([string]::IsNullOrWhiteSpace($SaveFolder)) {
    if ($NonInteractive) { throw "En modo NonInteractive debes pasar -SaveFolder." }
    $folders = @(Get-ChildItem -LiteralPath $SavesDir -Directory | Sort-Object LastWriteTime -Descending)
    if ($folders.Count -eq 0) { throw "No hay saves en $SavesDir" }
    Write-Host "Partidas encontradas:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $folders.Count; $i++) { Write-Host ("[{0}] {1} ({2})" -f ($i + 1), $folders[$i].Name, $folders[$i].LastWriteTime) }
    $SaveFolder = $folders[(Read-ChoiceIndex "Elige partida" $folders.Count)].FullName
} elseif (!(Test-Path -LiteralPath $SaveFolder)) {
    $candidate = Join-Path $SavesDir $SaveFolder
    if (Test-Path -LiteralPath $candidate) { $SaveFolder = $candidate } else { throw "No existe SaveFolder: $SaveFolder" }
}

$sourceMain = Get-MainSavePath $SaveFolder
$sourceDoc = Load-XDoc $sourceMain
$root = $sourceDoc.Root
$hostNode = $root.Element("player")
$farmhands = $root.Element("farmhands")
if ($null -eq $hostNode -or $null -eq $farmhands) { throw "Save no tiene player/farmhands esperados." }

$players = @()
$players += [pscustomobject]@{ Name=$hostNode.Element("name").Value; Id=$hostNode.Element("UniqueMultiplayerID").Value; Home=$hostNode.Element("homeLocation").Value; IsHost=$true }
foreach ($fh in $farmhands.Elements("Farmer")) {
    $name = $fh.Element("name").Value
    if ([string]::IsNullOrWhiteSpace($name)) { continue }
    $players += [pscustomobject]@{ Name=$name; Id=$fh.Element("UniqueMultiplayerID").Value; Home=$fh.Element("homeLocation").Value; IsHost=$false }
}

if ([string]::IsNullOrWhiteSpace($TargetPlayer)) {
    if ($NonInteractive) { throw "En modo NonInteractive debes pasar -TargetPlayer." }
    Write-Host "Jugadores:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $players.Count; $i++) {
        $tag = if ($players[$i].IsHost) { "actual host" } else { "farmhand" }
        Write-Host ("[{0}] {1} / id={2} / home={3} / {4}" -f ($i + 1), $players[$i].Name, $players[$i].Id, $players[$i].Home, $tag)
    }
    $TargetPlayer = $players[(Read-ChoiceIndex "Elige nuevo host" $players.Count)].Name
}

$targetInfo = $players | Where-Object { $_.Name -eq $TargetPlayer -or $_.Id -eq $TargetPlayer } | Select-Object -First 1
if ($null -eq $targetInfo) { throw "No encuentro jugador '$TargetPlayer'." }
if ($targetInfo.IsHost) { throw "El jugador seleccionado ya es el host." }

if ([string]::IsNullOrWhiteSpace($Mode)) {
    if ($NonInteractive) { throw "En modo NonInteractive debes pasar -Mode." }
    Write-Host "Modos:" -ForegroundColor Cyan
    Write-Host "[1] SwapExterior  - intercambia edificios: la Farmhouse pasa al sitio de la cabaña. Mas estable, cambia estetica."
    Write-Host "KeepExterior queda desactivado: validamos que Stardew no respeta la cabaña visual como FarmHouse logica." -ForegroundColor Yellow
    $Mode = "SwapExterior"
}

if ($Mode -eq "KeepExterior") {
    throw "KeepExterior esta desactivado. La prueba valida mostro que Stardew convierte/ubica la FarmHouse segun su logica interna y no conserva la cabaña visual original. Hay que rediseñar este modo antes de usarlo."
}

$prefix = if ($Mode -eq "KeepExterior") { "StardustCabinFarmhouse" } else { "StardustHostSwap" }
$new = New-SaveId -SavesDir $SavesDir -Prefix $prefix
Copy-Item -LiteralPath $SaveFolder -Destination $new.Folder -Recurse
$oldMainInCopy = Join-Path $new.Folder (Split-Path $sourceMain -Leaf)
$newMain = Join-Path $new.Folder $new.MainName
Rename-Item -LiteralPath $oldMainInCopy -NewName $new.MainName
$infoPath = Join-Path $new.Folder "SaveGameInfo"

$doc = Load-XDoc $newMain
$root = $doc.Root
Set-ElementValue $root "uniqueIDForThisGame" ([string]$new.Id)
$player = $root.Element("player")
$farmhands = $root.Element("farmhands")
$farm = Get-FarmLocation $root
$topFarmHouse = Get-TopFarmHouse $root
$farmhouseBuilding = Get-FarmhouseBuilding $farm

$target = $farmhands.Elements("Farmer") | Where-Object { ($_.Element("name").Value) -eq $targetInfo.Name -or ($_.Element("UniqueMultiplayerID").Value) -eq $targetInfo.Id } | Select-Object -First 1
if ($null -eq $target) { throw "No encuentro el nodo farmhand del nuevo host en la copia." }

$oldHostClone = [System.Xml.Linq.XElement]::new($player)
$newHostClone = [System.Xml.Linq.XElement]::new($target)
$oldHostId = $player.Element("UniqueMultiplayerID").Value
$targetHome = $target.Element("homeLocation").Value
$targetCabinBuilding = Get-CabinByUniqueName $farm $targetHome
if ($null -eq $targetCabinBuilding) { throw "No encuentro la cabaña asociada a $($targetInfo.Name): $targetHome" }
$targetCabinInterior = $targetCabinBuilding.Element("indoors")

$cabins = Get-CabinsWithIndoors $farm
$spareCabinBuilding = $cabins | Where-Object { $_.Element("indoors").Element("uniqueName").Value -ne $targetHome } | Select-Object -First 1
if ($null -eq $spareCabinBuilding) { throw "No hay cabaña alternativa para mover al host anterior. Crea otra cabaña y reintenta." }
$spareHome = $spareCabinBuilding.Element("indoors").Element("uniqueName").Value
$spareInterior = $spareCabinBuilding.Element("indoors")

$player.ReplaceNodes($newHostClone.Nodes())
Set-ElementValue $player "homeLocation" "FarmHouse"
Set-ElementValue $player "slotCanHost" "true"
Set-ElementValue $player "useSeparateWallets" "true"

$target.ReplaceNodes($oldHostClone.Nodes())
Set-ElementValue $target "homeLocation" $spareHome
Set-ElementValue $target "slotCanHost" "false"
Set-ElementValue $target "useSeparateWallets" "true"
Remove-EmptyFarmhandForHome $farmhands $spareHome

Copy-InteriorContent -Source $targetCabinInterior -Target $topFarmHouse -Fields $ContentFields
Set-ElementValue $topFarmHouse "name" "FarmHouse"
Set-ElementValue $topFarmHouse "isStructure" "false"

Copy-InteriorContent -Source (Get-TopFarmHouse (Load-XDoc $sourceMain).Root) -Target $spareInterior -Fields $ContentFields
Set-ElementValue $spareInterior "name" "Cabin"
Set-ElementValue $spareInterior "uniqueName" $spareHome
Set-ElementValue $spareInterior "isStructure" "true"
Set-ElementValue $spareInterior "farmhandReference" $oldHostId

if ($Mode -eq "KeepExterior") {
    $targetCabinBuilding.Element("indoors").Remove()
    Set-NetString $targetCabinBuilding "nonInstancedIndoorsName" "FarmHouse"
} else {
    $oldFarmX = $farmhouseBuilding.Element("tileX").Value
    $oldFarmY = $farmhouseBuilding.Element("tileY").Value
    $oldCabinX = $targetCabinBuilding.Element("tileX").Value
    $oldCabinY = $targetCabinBuilding.Element("tileY").Value
    $farmhouseBuilding.Element("tileX").Value = $oldCabinX
    $farmhouseBuilding.Element("tileY").Value = $oldCabinY
    $targetCabinBuilding.Element("tileX").Value = $oldFarmX
    $targetCabinBuilding.Element("tileY").Value = $oldFarmY
    Copy-InteriorContent -Source (Get-TopFarmHouse (Load-XDoc $sourceMain).Root) -Target $targetCabinBuilding.Element("indoors") -Fields $ContentFields
    Set-ElementValue $targetCabinBuilding.Element("indoors") "uniqueName" $spareHome
    Set-ElementValue $targetCabinBuilding.Element("indoors") "farmhandReference" $oldHostId
    Set-NetStringNil $targetCabinBuilding "nonInstancedIndoorsName"
    if ($CleanFootprint) { Clean-BuildingFootprint -Farm $farm -Building $farmhouseBuilding }
}

Save-XDoc $doc $newMain

$info = Load-XDoc $infoPath
$info.Root.Name = $player.Element("name").Value
$info.Root.ReplaceNodes([System.Xml.Linq.XElement]::new($player).Nodes())
Set-ElementValue $info.Root "homeLocation" "FarmHouse"
Set-ElementValue $info.Root "slotCanHost" "true"
Set-ElementValue $info.Root "useSeparateWallets" "true"
Save-XDoc $info $infoPath

Write-Host "OK: copia creada" -ForegroundColor Green
Write-Host "Carpeta: $($new.Folder)"
Write-Host "Archivo principal: $($new.MainName)"
Write-Host "Nuevo host: $($player.Element('name').Value) / id=$($player.Element('UniqueMultiplayerID').Value)"
Write-Host "Modo: $Mode"
