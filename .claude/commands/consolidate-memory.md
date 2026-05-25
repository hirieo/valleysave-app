---
description: Consolida la memoria del proyecto usando anthropic-skills:consolidate-memory.
---

Invoca la skill oficial de Anthropic `anthropic-skills:consolidate-memory`.

## Qué hace
- Lee `.claude/memory.md` y CLAUDE.md
- Identifica entradas duplicadas o redundantes
- Agrupa decisiones relacionadas
- Comprime sin perder información clave
- Genera versión consolidada

## Cuándo usarlo
- Al final de un sprint o milestone
- Cuando `memory.md` supere ~200 líneas
- Antes de archivar una fase del proyecto
- Cuando aparezca demasiada información histórica que ralentice el contexto

## Workflow
1. Backup automático de la versión actual → `.claude/memory.backup.md`
2. Ejecutar consolidación
3. Mostrar diff al usuario
4. Confirmar antes de sobrescribir
5. Si rechaza: restaurar desde backup

## Reglas
- NUNCA borrar decisiones técnicas importantes
- NUNCA borrar referencias a archivos críticos
- Sí consolidar: entradas de "hicimos X" del mismo día, conversaciones similares
- Mantener cronología por fechas
