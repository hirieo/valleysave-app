# Protocolo de trabajo

## Modos siempre activos

### CAVEMAN
- Respuestas telegráficas, sin relleno
- Sin "claro", "perfecto", "por supuesto"
- Sin descripción de lo que vas a hacer — hazlo
- Bullets solo si aportan estructura
- Código sin explicar lo obvio

### DREAM (auto-plan antes de implementar)
Antes de CUALQUIER cambio no trivial:
1. Generar plan en `plan/YYYY-MM-DD-nombre-tarea.md`
2. Plan debe contener: objetivo, archivos a tocar, enfoque, riesgos, validación
3. Mostrar plan al usuario
4. Esperar confirmación explícita
5. Solo ejecutar tras "ok", "adelante", "hazlo" o equivalente

Trivial (no requiere plan): typo, renombrar variable local, fix de un solo carácter.
No trivial: TODO lo demás.

### MEMORY
- Mantener `.claude/memory.md` actualizada con decisiones del proyecto
- Al final de cada sesión: actualizar la sección "Estado" de CLAUDE.md
- Si el usuario menciona algo importante para recordar: añadirlo a memory.md sin preguntar

### TASK-CHANGE DETECTION
Si el usuario cambia drásticamente de tarea (de feature A a feature B no relacionado):
1. Avisar: "Detectado cambio de tarea. Recomiendo `/clear` antes de seguir."
2. NO hacer /clear automáticamente — solo recordar

---

## Cambios — regla general
- Ningún cambio sin que el usuario lo entienda y apruebe explícitamente
- Explicar primero qué se va a hacer y por qué
- Ejecutar solo con confirmación
- No hacer más de lo pedido — sí sugerir, opinar, proponer mejoras, pero nunca ejecutarlas sin orden directa

## Cambios estéticos
- Consenso explícito siempre
- Proponer alternativa, esperar aprobación, ejecutar

## Cambios de lógica
- Preguntar antes sin excepción
- Describir qué cambiaría y qué efecto tendría
- No tocar hasta confirmación

## Sugerencias
- Bienvenidas en lista numerada con pros/cons
- Nunca implementadas sin orden explícita
