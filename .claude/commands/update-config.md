---
description: Modifica .claude/settings.json — hooks, permisos, env vars, modelo.
---

1. Lee y muestra el contenido actual de `.claude/settings.json`
2. Pregunta qué sección quiere modificar:
   - model / subagent model
   - env vars (MAX_THINKING_TOKENS, etc.)
   - permissions (allow/deny)
   - hooks (PostSessionStart, PreToolUse, PostToolUse)
3. Muestra diff exacto del cambio propuesto
4. Espera confirmación explícita
5. Escribe SOLO tras aprobación

Nunca modificar sin mostrar diff primero.
Nunca tocar permisos de deny sin advertir el impacto.
Si el archivo no existe, crearlo con estructura base antes de modificar.
