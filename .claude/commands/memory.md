---
description: Gestiona memoria persistente del proyecto. Auto-actualiza al final de sesión.
---

Ubicación: `.claude/memory.md`

## Acciones según input

### Sin argumentos → mostrar memoria actual
Leer y mostrar `.claude/memory.md`.

### `/memory add [texto]` → añadir entrada
Añadir línea con timestamp + texto al final del archivo.

### `/memory clean` → consolidar
Pedir confirmación. Luego invocar `anthropic-skills:consolidate-memory` para
consolidar entradas duplicadas o redundantes.

### `/memory clear` → borrar todo
Pedir confirmación doble. Solo borrar si confirma "sí borra".

## Auto-actualización
Al final de cada sesión (cuando el usuario diga "fin", "hasta mañana", etc):
1. Actualizar sección "Estado" de CLAUDE.md
2. Añadir entrada a memory.md con resumen de lo hecho
3. Listar archivos creados/modificados
4. Listar decisiones tomadas

Formato de entrada en memory.md:
```
## YYYY-MM-DD
- [decisión/hecho/archivo creado]
- [decisión/hecho/archivo creado]
```
