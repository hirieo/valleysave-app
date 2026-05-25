---
description: Refinamiento iterativo. Genera → critica → mejora. 2-3 iteraciones por defecto.
---

Para la tarea en `$ARGUMENTS`:

## Iteración 1: Generar
- Producir primera versión funcional
- Sin obsesionar con perfección
- Mostrar al usuario

## Iteración 2: Auto-crítica
Pasar mentalmente la primera versión por estos filtros:
- ¿Cumple el objetivo?
- ¿Hay edge cases sin cubrir?
- ¿Es legible para alguien que no participó?
- ¿Hay duplicación o lógica que se puede extraer?
- ¿Sigue las convenciones del proyecto (`.claude/rules/`)?
- ¿Es lo más simple que funciona?

Listar problemas encontrados.

## Iteración 3: Refinar
- Aplicar correcciones a los problemas listados
- Mostrar versión final
- Mostrar qué cambió entre v1 y v3

## Stop conditions
- El usuario dice "ya está"
- Las iteraciones empiezan a deshacer cambios anteriores (señal de overfitting)
- Llevamos 5 iteraciones sin mejora clara

Esperar feedback entre iteraciones si el usuario lo pide.
Por defecto: hacer las 3 iteraciones seguidas y mostrar resultado.
