// Prueba de concepto: detector de colisiones de huella para el cambio de anfitrion,
// escrito en Dart con package:xml (la misma dependencia que ya usa SaveService en la
// app real). Objetivo: demostrar que la logica de Test-FootprintCollision.ps1 se puede
// portar a Dart sin sorpresas, antes de construir host_swap_service.dart de verdad.
//
// Solo lectura. No modifica ningun save.
//
// Uso: dart run collision_check.dart <ruta_carpeta_save> <nombreJugadorObjetivo>

import 'dart:io';
import 'package:xml/xml.dart';

const _ignorableTypes = {'Weeds', 'Grass'};

class Collision {
  final String container;
  final int x, y;
  final String type;
  final bool hasCrop;
  final String? treeInfo;
  Collision(this.container, this.x, this.y, this.type, this.hasCrop, this.treeInfo);
}

XmlElement? _firstWhere(Iterable<XmlElement> elements, bool Function(XmlElement) test) {
  for (final e in elements) {
    if (test(e)) return e;
  }
  return null;
}

String? _text(XmlElement parent, String childName) =>
    parent.findElements(childName).firstOrNull?.innerText;

int? _intText(XmlElement parent, String childName) {
  final t = _text(parent, childName);
  if (t == null) return null;
  return double.tryParse(t)?.toInt();
}

void main(List<String> args) {
  final saveFolder = args.isNotEmpty
      ? args[0]
      : r'C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\Stardust_443121237';
  final targetName = args.length > 1 ? args[1] : 'Eltestosteron';

  final folderName = saveFolder.split(Platform.pathSeparator).last;
  final mainFile = File('$saveFolder${Platform.pathSeparator}$folderName');
  if (!mainFile.existsSync()) {
    stderr.writeln('No encuentro el archivo principal: ${mainFile.path}');
    exit(1);
  }

  final doc = XmlDocument.parse(mainFile.readAsStringSync());
  final root = doc.rootElement; // <SaveGame>

  final locations = root.findElements('locations').first;
  final farm = _firstWhere(
    locations.findElements('GameLocation'),
    (loc) => _text(loc, 'name') == 'Farm',
  );
  if (farm == null) {
    stderr.writeln('No encuentro la location Farm.');
    exit(1);
  }

  final buildings = farm.findElements('buildings').first.findElements('Building');

  final farmhouseBuilding = _firstWhere(
    buildings,
    (b) => _text(b, 'buildingType') == 'Farmhouse',
  );
  if (farmhouseBuilding == null) {
    stderr.writeln('No encuentro el building Farmhouse.');
    exit(1);
  }

  final farmhands = root.findElements('farmhands').first.findElements('Farmer');
  final target = _firstWhere(farmhands, (f) => _text(f, 'name') == targetName);
  if (target == null) {
    stderr.writeln("No encuentro el farmhand '$targetName'.");
    exit(1);
  }
  final targetHome = _text(target, 'homeLocation');

  final targetCabin = _firstWhere(buildings, (b) {
    if (_text(b, 'buildingType') != 'Cabin') return false;
    final indoors = b.findElements('indoors').firstOrNull;
    if (indoors == null) return false;
    return _text(indoors, 'uniqueName') == targetHome;
  });
  if (targetCabin == null) {
    stderr.writeln("No encuentro la cabaña de '$targetName' (home=$targetHome).");
    exit(1);
  }

  final fw = _intText(farmhouseBuilding, 'tilesWide')!;
  final fh = _intText(farmhouseBuilding, 'tilesHigh')!;
  final x0 = _intText(targetCabin, 'tileX')!;
  final y0 = _intText(targetCabin, 'tileY')!;
  final x1 = x0 + fw - 1;
  final y1 = y0 + fh - 1;

  print('=== Deteccion de colisiones (Dart, package:xml) ===');
  print('Jugador objetivo: $targetName');
  print('Farmhouse ${fw}x$fh se colocaria en tile $x0,$y0');
  print('Huella: X $x0..$x1  Y $y0..$y1');
  print('');

  List<Collision> scanContainer(String containerName, String label) {
    final results = <Collision>[];
    final container = farm.findElements(containerName).firstOrNull;
    if (container == null) return results;
    for (final item in container.findElements('item')) {
      final key = item.findElements('key').firstOrNull;
      final vec = key?.findElements('Vector2').firstOrNull;
      if (vec == null) continue;
      final tx = _intText(vec, 'X');
      final ty = _intText(vec, 'Y');
      if (tx == null || ty == null) continue;
      if (tx < x0 || tx > x1 || ty < y0 || ty > y1) continue;

      final value = item.findElements('value').firstOrNull;
      final valChild = value?.children.whereType<XmlElement>().firstOrNull;
      if (valChild == null) continue;
      // El tipo real no viene siempre del mismo sitio: terrainFeatures (arboles) usan
      // el atributo xsi:type; los objetos sueltos (maleza, cofres) usan un hijo <name>.
      // Se prueban ambos, con el nombre de la etiqueta como ultimo recurso.
      final xsiType = valChild.attributes
          .where((a) => a.name.qualified == 'xsi:type')
          .firstOrNull
          ?.value;
      final type = xsiType ?? _text(valChild, 'name') ?? valChild.name.local;
      final hasCrop = valChild.findElements('crop').isNotEmpty;
      final treeType = _text(valChild, 'treeType');
      final growthStage = _text(valChild, 'growthStage');
      final treeInfo = treeType != null ? 'treeType=$treeType growthStage=$growthStage' : null;

      results.add(Collision(label, tx, ty, type, hasCrop, treeInfo));
    }
    return results;
  }

  final collisions = <Collision>[
    ...scanContainer('objects', 'objects'),
    ...scanContainer('terrainFeatures', 'terrainFeatures'),
    ...scanContainer('largeTerrainFeatures', 'largeTerrainFeatures'),
  ];

  // resourceClumps: estructura de coleccion distinta (lista directa, no Vector2-keyed dict)
  final resourceClumps = farm.findElements('resourceClumps').firstOrNull;
  if (resourceClumps != null) {
    for (final clump in resourceClumps.children.whereType<XmlElement>()) {
      final tileEl = clump.findElements('tile').firstOrNull;
      int? tx, ty;
      if (tileEl != null) {
        tx = _intText(tileEl, 'X');
        ty = _intText(tileEl, 'Y');
      } else {
        tx = _intText(clump, 'X');
        ty = _intText(clump, 'Y');
      }
      if (tx == null || ty == null) continue;
      if (tx < x0 || tx > x1 || ty < y0 || ty > y1) continue;
      collisions.add(Collision('resourceClumps', tx, ty, clump.name.local, false, null));
    }
  }

  if (collisions.isEmpty) {
    print('SIN COLISIONES: la huella esta libre, el swap no pisa nada.');
    return;
  }

  print('COLISIONES DETECTADAS: ${collisions.length}');
  final blocking = <Collision>[];
  for (final c in collisions) {
    final ignorable = _ignorableTypes.contains(c.type);
    String severity;
    if (ignorable) {
      severity = 'ignorable';
    } else if (c.hasCrop) {
      severity = 'CRITICO (cultivo plantado)';
    } else if (c.type == 'Chest') {
      severity = 'CRITICO (cofre con items)';
    } else if (c.treeInfo != null) {
      severity = 'aviso (arbol)';
    } else {
      severity = 'aviso';
    }
    if (!ignorable) blocking.add(c);
    print('  [${c.container}] ${c.type} en ${c.x},${c.y} ${c.treeInfo ?? ''} -> $severity');
  }

  print('');
  if (blocking.isEmpty) {
    print('VEREDICTO: solo maleza/hierba. Swap seguro sin confirmacion extra.');
  } else {
    print('VEREDICTO: ${blocking.length} elemento(s) bloqueante(s). NO ejecutar el swap.');
    print('El jugador debe despejar la zona antes de reintentar.');
  }
}
