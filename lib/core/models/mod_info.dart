/// Tipo de mod según su `manifest.json` (research §3, `ModScanner` de SMAPI):
/// `EntryDll` → código C#; `ContentPackFor` → paquete de contenido; ambos o
/// ninguno → inválido (se lista con aviso, nunca se sube).
enum ModKind { csharp, contentPack, invalid }

/// Compatibilidad orientativa de un mod con una plataforma (spec 010 D9).
enum ModCompat { works, mayFail, unsupported }

/// Un mod instalado en la carpeta `Mods` (spec 010).
class ModInfo {
  const ModInfo({
    required this.uniqueId,
    required this.name,
    required this.author,
    required this.version,
    required this.kind,
    required this.folderPath,
    required this.relativePath,
    this.minimumApiVersion,
    this.contentPackFor,
    this.updateKeys = const [],
    this.dependencies = const [],
    this.hasConfig = false,
  });

  /// Identidad del mod; se compara sin distinguir mayúsculas.
  final String uniqueId;
  final String name;
  final String author;
  final String version;
  final ModKind kind;

  /// Carpeta del mod en este equipo.
  final String folderPath;

  /// Ruta dentro de `Mods/` con `/` (se conserva la subestructura del autor).
  final String relativePath;
  final String? minimumApiVersion;
  final String? contentPackFor;
  final List<String> updateKeys;
  final List<String> dependencies;

  /// Tiene `config.json` (ajustes del usuario, D6).
  final bool hasConfig;

  String get key => uniqueId.toLowerCase();

  /// Enlace público del mod a partir de `UpdateKeys` (para compartir solo la
  /// lista, D11). `null` si no hay ninguno conocido.
  String? get pageUrl {
    for (final k in updateKeys) {
      final parts = k.split(':');
      if (parts.length != 2) continue;
      final id = parts[1].split('@').first.trim();
      if (!RegExp(r'^[A-Za-z0-9_.-]{1,64}$').hasMatch(id)) continue;
      switch (parts[0].trim().toLowerCase()) {
        case 'nexus':
          return 'https://www.nexusmods.com/stardewvalley/mods/$id';
        case 'moddrop':
          return 'https://www.moddrop.com/stardew-valley/mods/$id';
        case 'curseforge':
          return 'https://www.curseforge.com/projects/$id';
        case 'github':
          if (id.contains('/')) return 'https://github.com/$id';
      }
    }
    return null;
  }
}
