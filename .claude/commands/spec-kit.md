---
description: Invoca spec-kit (instalado globalmente) para generar especificación de feature.
---

Spec-kit está instalado globalmente. Subcomandos principales:
- `spec-kit init` → crear nueva especificación
- `spec-kit build` → convertir spec en plan de tareas
- `spec-kit review` → revisar spec existente

## Workflow recomendado

### Para feature nueva
1. Ejecutar `spec-kit init` en una carpeta `specs/[feature]/`
2. Rellenar el template generado:
   - Problema que resuelve
   - Comportamiento esperado
   - Usuarios afectados
   - Edge cases
   - No-objetivos (qué NO va a hacer)
3. Ejecutar `spec-kit build` → genera plan de tareas
4. Mover plan a `plan/` (compatible con `/dream`)

### Para feature existente
1. `spec-kit review specs/[feature]/spec.md`
2. Aplicar cambios sugeridos

## Reglas
- Toda feature mayor pasa por spec-kit ANTES de código
- Specs van a `specs/` (commiteable al repo)
- Plans van a `plan/` (locales, no se commitean)

Si el usuario no tiene spec-kit instalado:
```bash
npm install -g spec-kit  # o el comando real según docs oficiales
```
