---
description: Busca e instala skills del ecosistema Claude Code relevantes al proyecto.
---

1. Lee CLAUDE.md para detectar el stack del proyecto actual
2. Busca skills relevantes en:
   - https://github.com/anthropics/claude-code (directorio oficial)
   - https://github.com/anthropics/claude-code-skills (si existe)
3. Lista las encontradas en formato:
   ```
   [nombre] — descripción breve — relevancia para este proyecto
   ```
4. Pregunta cuáles instalar
5. Para cada skill aprobada:
   - Descarga el SKILL.md
   - Lo coloca en `.claude/skills/[nombre]/SKILL.md`
   - Confirma instalación

No instala nada sin confirmación explícita.
No sobreescribe skills existentes sin avisar y mostrar diff.
