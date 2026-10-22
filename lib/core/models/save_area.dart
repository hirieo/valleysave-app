/// Sección de la pantalla de partidas a la que pertenece una granja (spec 010
/// D1): juego normal o con mods (SMAPI). En Drive cada sección vive en su
/// propia carpeta — `ValleySave/` y `ValleySave/SMAPI/Saves/` — así que una
/// misma granja puede existir en las dos (D3).
enum SaveArea { normal, smapi }
