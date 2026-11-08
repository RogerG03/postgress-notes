# PostgreSQL: aprender, probar y explicar

Ampliación acordada el 7 de noviembre: tabla `features(code, is_active)` para habilitar funcionalidades por instalación. [Contrato y tabla](https://github.com/RogerG03/odonto-soft/blob/main/docs/installation-features.md). Frontend adaptado con filas mock (ortodoncia false); tabla física y conexión pendientes. No mezclar estas filas con permisos individuales ni borrar historia al desactivar. El ER anterior todavía no incluye esta ampliación.

## Referencia vigente del producto — 7 de noviembre de 2026

El modelo conceptual y lógico de OdontoSoft ya está aprobado (decisión del 4 de noviembre), y Prisma fue elegido con PostgreSQL. Los capítulos de propuesta y laboratorios anteriores conservan su valor didáctico; no son el esquema de producto ni deben reiniciar decisiones aprobadas.

- [Índice de diagramas y enlace permanente de edición](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/README.md).
- [ER v2 editable, siete páginas](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/odonto-soft-modelo-logico-v2-erd.drawio).
- [Diccionario de datos y detalles físicos pendientes](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/modelo-logico-v1.md).
- [Cierre y siguiente bloque de backend](https://github.com/RogerG03/odonto-soft/blob/main/docs/handoff-2026-11-04.md).

La app sigue con mocks, sin migración de producto ni Prisma instalado/conectado. Primero verificar el entorno del equipo destino; la BD de aprendizaje de otra PC no se transfiere con Git. Bloque 12 del laboratorio sigue sin confirmación; no ejecutarlo como migración de producto.

Apuntes en español para entender PostgreSQL desde cero y aprender a conectarlo con una aplicación. El nombre del repositorio conserva `postgress-notes`; el motor se llama **PostgreSQL**.

Partimos de preguntas reales de una aplicación de clínica: dónde se guardan los datos, cómo se relacionan, cómo acceden varias personas y cómo recuperarlos. Los ejemplos son ficticios y no definen el esquema de ninguna aplicación existente.

## Punto de pausa — 2 de noviembre de 2026

[Instructivo para retomar desde otra PC](docs/16-retomar-en-otra-pc.md). Bloques 04–11 confirmados por el usuario en `odonto_learning`; bloque 12 preparado, sin confirmación. PostgreSQL 18.6 observado. La app todavía usa mocks. Git no traslada los datos de PostgreSQL.

## Ruta de aprendizaje

Avanza una etapa a la vez. Puedes leer las primeras dos sin instalar nada.

| Etapa | Pregunta que resolverás                          | Lectura y práctica                                                                                      |
| ----- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| 1     | ¿Qué hace cada programa?                         | [Arquitectura](docs/01-arquitectura.md)                                                                 |
| 2     | ¿Qué necesito y por qué?                         | [Entorno local](docs/02-entorno-local.md)                                                               |
| 3     | ¿Cómo guardo y consulto datos relacionados?      | [SQL y relaciones](docs/03-sql-y-relaciones.md) · [Laboratorio](laboratorios/01-primeras-consultas.sql) |
| 4     | ¿Qué pasa si algo falla o dos personas escriben? | [Transacciones y concurrencia](docs/04-transacciones.md)                                                |
| 5     | ¿Cómo habla una aplicación con PostgreSQL?       | [Ecosistemas y Next.js](docs/05-ecosistemas.md)                                                         |
| 6     | ¿Cómo cuido y recupero la información?           | [Operación y respaldos](docs/06-operacion.md)                                                           |

## Cómo usar estos apuntes

1. Lee la explicación y escribe qué crees que sucederá en el ejercicio.
2. Ejecuta únicamente en una base de aprendizaje, con datos ficticios.
3. Compara el resultado con lo esperado; conserva también los errores útiles.
4. Registra versiones, pasos y evidencia con la [plantilla de experiencia](bitacora/plantilla.md).

**Estado inicial, 1 de noviembre de 2026:** contenido contrastado con documentación oficial de PostgreSQL 18. Los laboratorios están propuestos, **pendientes de ejecución en PostgreSQL**. No hay mediciones ni resultados experimentales que podamos afirmar todavía. Cada experiencia futura debe indicar su entorno y fecha.

## Alcance

Esta primera entrega explica fundamentos y propone prácticas pequeñas. No instala programas, no elige un ORM ni modifica una aplicación clínica. Replicación, alta disponibilidad, afinación avanzada, automatización de respaldos e integraciones completas se incorporarán cuando exista una pregunta y una práctica que las justifiquen.

Para contribuir, consulta [CONTRIBUTING.md](CONTRIBUTING.md). Las fuentes están al final de cada capítulo; no sustituyen las observaciones de tu entorno.

## Caso de estudio en discusión

[Backend y primeros scripts](docs/15-backend-y-primeros-scripts.md): punto de entrada práctico vigente. Primero diagnóstico de solo lectura; después, una BD vacía de aprendizaje. El usuario ejecuta y revisa cada paso antes de diseñar las tablas de producto. Hay progreso de laboratorio confirmado, detallado en el cierre; la app sigue sin conexión.

[Pacientes, expedientes y autores](docs/07-propuesta-clinica.md): propuesta de relaciones para conversar antes de crear tablas. No es un esquema aprobado ni implementado.

[Catálogos y otras especialidades](docs/08-catalogos-y-especialidades.md): ampliación del núcleo clínico y separación de detalles dentales, con fuentes de terminología para investigar.

[Tablas y relaciones por bloques](docs/09-tablas-y-relaciones.md): campos candidatos y recorrido completo. Catálogo pequeño y un médico responsable por consulta.

[Campos obligatorios](docs/10-required-fields.md): nombres técnicos en inglés; relación paciente-expedientes preparada para varios, con flujo inicial limitado a uno; propuesta del mínimo necesario para registrar paciente y expediente.

[Brackets y ortodoncia](docs/11-orthodontics.md): ampliación propuesta para actuaciones sobre varias piezas y diferencia entre historial de actuaciones y seguimiento completo de un aparato.

[Interfaz de ortodoncia e iconografía](docs/12-orthodontics-ui-research.md): investigación en fuentes profesionales, flujo con selección múltiple, campos flexibles e inventario de símbolos por revisar antes de implementar.

[Coordinación con el chat de iconografía](docs/13-iconography-coordination.md): alcance del inventario paralelo y cómo usarlo sin confundir referencias con decisiones ya aprobadas.

[Selector clínico y revisión de recursos](docs/14-clinical-selector-review.md): ajuste de UI realizado y primera verificación de fuentes de la investigación, con límites de integración y licencias pendientes.
