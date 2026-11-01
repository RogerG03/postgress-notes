# PostgreSQL: aprender, probar y explicar

Apuntes en español para entender PostgreSQL desde cero y aprender a conectarlo con una aplicación. El nombre del repositorio conserva `postgress-notes`; el motor se llama **PostgreSQL**.

Partimos de preguntas reales de una aplicación de clínica: dónde se guardan los datos, cómo se relacionan, cómo acceden varias personas y cómo recuperarlos. Los ejemplos son ficticios y no definen el esquema de ninguna aplicación existente.

## Ruta de aprendizaje

Avanza una etapa a la vez. Puedes leer las primeras dos sin instalar nada.

| Etapa | Pregunta que resolverás | Lectura y práctica |
| --- | --- | --- |
| 1 | ¿Qué hace cada programa? | [Arquitectura](docs/01-arquitectura.md) |
| 2 | ¿Qué necesito y por qué? | [Entorno local](docs/02-entorno-local.md) |
| 3 | ¿Cómo guardo y consulto datos relacionados? | [SQL y relaciones](docs/03-sql-y-relaciones.md) · [Laboratorio](laboratorios/01-primeras-consultas.sql) |
| 4 | ¿Qué pasa si algo falla o dos personas escriben? | [Transacciones y concurrencia](docs/04-transacciones.md) |
| 5 | ¿Cómo habla una aplicación con PostgreSQL? | [Ecosistemas y Next.js](docs/05-ecosistemas.md) |
| 6 | ¿Cómo cuido y recupero la información? | [Operación y respaldos](docs/06-operacion.md) |

## Cómo usar estos apuntes

1. Lee la explicación y escribe qué crees que sucederá en el ejercicio.
2. Ejecuta únicamente en una base de aprendizaje, con datos ficticios.
3. Compara el resultado con lo esperado; conserva también los errores útiles.
4. Registra versiones, pasos y evidencia con la [plantilla de experiencia](bitacora/plantilla.md).

**Estado inicial, 1 de noviembre de 2026:** contenido contrastado con documentación oficial de PostgreSQL 18. Los laboratorios están propuestos, **pendientes de ejecución en PostgreSQL**. No hay mediciones ni resultados experimentales que podamos afirmar todavía. Cada experiencia futura debe indicar su entorno y fecha.

## Alcance

Esta primera entrega explica fundamentos y propone prácticas pequeñas. No instala programas, no elige un ORM ni modifica una aplicación clínica. Replicación, alta disponibilidad, afinación avanzada, automatización de respaldos e integraciones completas se incorporarán cuando exista una pregunta y una práctica que las justifiquen.

Para contribuir, consulta [CONTRIBUTING.md](CONTRIBUTING.md). Las fuentes están al final de cada capítulo; no sustituyen las observaciones de tu entorno.
