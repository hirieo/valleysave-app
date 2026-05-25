---
description: Propone versión más simple del código actual. Comparar y elegir.
---

Para el archivo/función en `$ARGUMENTS` (o el contexto actual si vacío):

1. Leer código actual
2. Identificar complejidad innecesaria:
   - Funciones que hacen más de una cosa
   - Abstracciones prematuras
   - Lógica anidada que cabe linear
   - Variables intermedias innecesarias
   - Patrones overengineered para el problema real
3. Generar versión simplificada
4. Mostrar diff lado a lado
5. Explicar qué se simplificó y por qué
6. Esperar aprobación
7. Aplicar solo tras "ok"

Principios:
- Menos código siempre que no pierda legibilidad
- Nombres claros > comentarios explicativos
- Una función = una responsabilidad
- Evitar abstracciones que solo se usan una vez

NO simplificar si:
- Rompe tests existentes
- Pierde funcionalidad
- Reduce legibilidad real (no aparente)
