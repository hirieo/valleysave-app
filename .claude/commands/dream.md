---
description: Genera plan antes de implementar. Auto-invocado en cambios no triviales.
---

1. Crear carpeta `plan/` si no existe
2. Generar archivo `plan/YYYY-MM-DD-nombre-tarea.md` con:
   ```
   # [Tarea]

   ## Objetivo
   Una frase. Qué se quiere conseguir.

   ## Contexto
   Qué hay ahora. Qué falta.

   ## Enfoque
   Pasos numerados. Decisiones técnicas con justificación.

   ## Archivos
   - `ruta/archivo.ext` — qué cambia
   - ...

   ## Riesgos
   Qué puede salir mal. Qué romper.

   ## Validación
   Cómo comprobar que funciona.
   ```
3. Mostrar el plan en el chat
4. Esperar confirmación explícita
5. NO tocar código hasta "ok", "adelante" o equivalente

Si el plan es rechazado: iterar sin escribir nada.
Si la tarea es trivial (typo, rename local): omitir plan, hacer directo.
