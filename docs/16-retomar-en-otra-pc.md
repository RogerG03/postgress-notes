# Retomar desde otra PC

## Referencia vigente del producto — 7 de noviembre de 2026

El modelo conceptual y lógico de OdontoSoft ya está aprobado (decisión del 4 de noviembre), y Prisma fue elegido con PostgreSQL. Los capítulos de propuesta y laboratorios anteriores conservan su valor didáctico; no son el esquema de producto ni deben reiniciar decisiones aprobadas.

- [Índice de diagramas y enlace permanente de edición](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/README.md).
- [ER v2 editable, siete páginas](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/odonto-soft-modelo-logico-v2-erd.drawio).
- [Diccionario de datos y detalles físicos pendientes](https://github.com/RogerG03/odonto-soft/blob/main/docs/diagrams/modelo-logico-v1.md).
- [Cierre y siguiente bloque de backend](https://github.com/RogerG03/odonto-soft/blob/main/docs/handoff-2026-11-04.md).

La app sigue con mocks, sin migración de producto ni Prisma instalado/conectado. Primero verificar el entorno del equipo destino; la BD de aprendizaje de otra PC no se transfiere con Git. Bloque 12 del laboratorio sigue sin confirmación; no ejecutarlo como migración de producto.

Pausa solicitada el 2 de noviembre de 2026. No continuar implementación ni ejecutar DDL hasta que el usuario retome. Este documento prevalece sobre los estados intermedios.

## Para el agente

1. Clonar o actualizar, sin descartar cambios locales, `RogerG03/code-memory`, `RogerG03/odonto-soft`, `RogerG03/postgress-notes` y, si se trabaja en la plantilla, `RogerG03/abc-next-js`. Leer AGENTS.md de cada checkout, la memoria de cierre y `odonto-soft/docs/handoff.md`. No asumir las rutas de la PC anterior.
2. Aplicar Ponytail y memoria verificable; usar codebase-memory con comprobación de cobertura para exploración estructural y fuentes si falta índice. No instalar skills o dependencias nuevas sin necesidad.
3. La app es frontend con mocks. Ortodoncia, implantes, prótesis, correcciones y Redux por vista están implementados en el prototipo; no existe conexión PostgreSQL, ORM, autenticación ni auditoría persistente. Leer `docs/backend-data-plan.md` antes de diseñar el backend. Permix es un plan posterior al MVP.
4. En la app: usar la versión de pnpm indicada por package.json, `pnpm install --frozen-lockfile`, `pnpm check`, `pnpm dev`. No transferir node_modules. Hay evidencia previa de E2E y build con Webpack; Turbopack presentó un fallo local de PostCSS. No afirmar CI remoto aprobado sin verlo.
5. Antes de SQL, verificar qué servidor y base están conectados y ejecutar únicamente `laboratorios/13-verificar-avance.sql`. No suponer que otra PC tiene los datos. No ejecutar scripts CREATE sobre objetos existentes ni borrarlos para repetir.
6. Si la base conserva los bloques 04–11 y falta el 12, explicar el bloque 12 y dejar que el usuario lo ejecute. Si ya existen `teeth` o `clinical_entry_teeth`, inspeccionar columnas, restricciones y filas antes de decidir: existencia no prueba que el bloque esté completo.
7. Si la base es nueva, seguir la reconstrucción de laboratorio indicada abajo, por bloques. No convertir el laboratorio en esquema final ni introducir datos reales.

## Estado observado y reportado

PostgreSQL 18.6 x64 observado en pgAdmin; puerto de instalación 5432. Base `odonto_learning` creada por el usuario. Bloques 04–11 confirmados por el usuario, con salidas compartidas para paciente y consulta. Bloque 12 entregado, **sin confirmación**.

Paciente ficticio: `823e17ff-c00e-469e-9473-18182cd15969`, `Paciente de prueba A`. Expediente: `EXP-DEMO-001`. Consulta: `Revisión ficticia de demostración`. Usuarios: `Usuario de prueba` y `Profesional de prueba`. El primer intento del bloque 06 falló y se revirtió; luego pasó. No se conoce el error original.

## Reconstruir solamente una base nueva de aprendizaje

Instalar PostgreSQL y pgAdmin si faltan; Stack Builder no es necesario. Mantener la contraseña privada. Verificar servidor con el bloque 02; crear una base vacía con 03 solo si no existe. Conectarse a `odonto_learning` antes de las tablas.

Ejecutar en orden y revisar cada resultado: 04, **04b**, 05, 06, 07, 08, 09, 10, 11. El archivo 04b crea el paciente ficticio con el UUID requerido por 05. No ejecutarlo en la base anterior: ya tiene esa fila. Las nuevas fechas y los otros UUID pueden cambiar. El bloque 12 se retoma después; 13 es diagnóstico, no una migración.

Si falla una transacción, ejecutar `ROLLBACK;`, conservar el mensaje sin secretos y revisar la causa. No usar DROP, truncado o IF NOT EXISTS para ocultar diferencias. No se ha probado esta reconstrucción completa en un servidor desde el agente.

## Trasladar la base existente

Git no contiene la base ni un respaldo. Para conservar exactamente sus datos hace falta un respaldo de PostgreSQL y restaurarlo en un destino nuevo, con herramientas compatibles y comprobación posterior. Acordar esa operación con el usuario antes de realizarla; no sobrescribir otra base. No subir dumps, contraseñas, .env ni datos reales al repositorio. Respaldos automáticos cifrados y Drive siguen pendientes, no están implementados.

## Siguiente conversación

Confirmar si se retoma la misma base o una nueva; verificar el bloque 12; continuar la enseñanza por bloques. Después acordar esquema de producto, restricciones e índices, rol técnico mínimo, migraciones y contratos paginados/proyecciones para frontend. Objetivo: instalación local por clínica, equipos de 4–8 GB, posible acceso futuro por LAN; sin prometer rendimiento sin medirlo. Una identidad de paciente admite varios expedientes en el modelo, con flujo inicial de uno; nombres técnicos en inglés y UUID. Documento/identificación opcional y comparación de duplicados como advertencia, no rechazo ciego. No crear automáticamente un paciente duplicado para un segundo expediente.
