---
description: Limpia contexto temporal. Útil cuando hay info acumulada que confunde.
---

1. Preguntar qué limpiar:
   - `cache` — archivos temporales del proyecto (`.dart_tool/`, `__pycache__/`, `node_modules/.cache/`, etc.)
   - `plans` — planes antiguos en `plan/` ya completados
   - `context` — recordar al usuario que use `/clear` para limpiar contexto del chat
   - `all` — todo lo anterior

2. Mostrar qué se va a borrar
3. Pedir confirmación
4. Ejecutar

NUNCA borrar sin confirmar.
NUNCA tocar archivos del usuario en `.env`, `.git/`, código fuente.
