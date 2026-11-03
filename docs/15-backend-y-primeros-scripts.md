# 15. Empezar el backend sin correr antes de caminar

El objetivo es aprender construyendo el backend de la clínica por bloques. Primero comprobaremos el entorno y crearemos una base vacía de aprendizaje. Después vendrán las tablas, sus pruebas y la primera conexión desde Next.js. Los scripts los ejecuta quien está aprendiendo; preparar un archivo no significa que ya se haya ejecutado.

La aplicación todavía usa mocks. El plan técnico completo se documenta en `RogerG03/odonto-soft`, `docs/backend-data-plan.md`; no es un esquema de producción aprobado. Incluye pacientes, expedientes, citas, catálogos, actuaciones de varias piezas, ortodoncia, implantes, prótesis y correcciones. Permix queda para después del MVP.

## Qué queremos evitar

El directorio no necesita recibir todas las consultas para averiguar la última. Tampoco necesitamos enviar el historial completo para dibujar cada pieza del odontograma. PostgreSQL buscará, ordenará y paginará; Next validará y devolverá estados/resúmenes; el navegador dibujará y manejará el formulario. Si todo corre en la misma computadora, ese trabajo sigue consumiendo recursos allí: hay que medir y limitar consultas, datos y conexiones.

Empezaremos sin servicios adicionales ni tablas de resumen mantenidas por anticipación. El historial conservará los hechos; si más adelante reconstruir un expediente resulta lento, mediremos una proyección persistida que pueda reconstruirse. No afirmamos mejoras de velocidad sin pruebas.

## Paso actual: instalar si hace falta

Revisión de esta computadora el 2 de noviembre: no se encontraron servicios con nombre habitual de PostgreSQL, entradas de PostgreSQL/pgAdmin en los registros de instalación consultados, herramientas `psql`/`pg_dump` en PATH ni la carpeta habitual de PostgreSQL. Esto no descarta una instalación portátil o no estándar; todavía no hay conexión verificada.

Para este caso usaremos la ruta de prácticas de este capítulo; los comandos del capítulo 2 explican otra base de aprendizaje y no hace falta ejecutar ambas rutas.

1. Descarga el instalador desde [PostgreSQL para Windows](https://www.postgresql.org/download/windows/), que enlaza el instalador de EDB. Usa una versión estable de la rama 18 si seguimos estas referencias; evita versiones RC o de desarrollo.
2. Selecciona servidor, pgAdmin y herramientas de línea de comandos. Stack Builder no es necesario en este paso.
3. Conserva la contraseña administrativa en un lugar privado; no la pegues en el repositorio ni en el chat. Anota el puerto elegido: habitualmente 5432 si está disponible. No habilites acceso remoto durante esta práctica.
4. Al terminar, abre pgAdmin y verifica que conecta al servidor local. La contraseña administrativa puede ser distinta de la contraseña maestra de pgAdmin; no son cuentas de pacientes o doctores.
5. Continúa con el diagnóstico siguiente; la versión que importa se obtiene del servidor conectado.

Objetivo de diseño acordado: equipos de 4–8 GB de RAM, tomando 4 GB como referencia. PgAdmin puede cerrarse al terminar la práctica. No cambiar parámetros de memoria por anticipación ni afirmar que el equipo tendrá rendimiento suficiente sin medirlo.

## Primera práctica: conocer tu conexión

Requisitos: PostgreSQL iniciado, pgAdmin conectado al servidor local y acceso autorizado. Referencia de los scripts: PostgreSQL 18; confirma tu versión antes de continuar. Si aún no está instalado, detente aquí y sigue [entorno local](02-entorno-local.md); no necesitas Docker para esta práctica.

1. En pgAdmin, abre **Query Tool** desde una base disponible, habitualmente `postgres`. No necesitas pegar una contraseña en ningún script.
2. Abre [02-verificar-servidor.sql](../laboratorios/02-verificar-servidor.sql).
3. Ejecuta un `SELECT` a la vez con Ejecutar/F5, seleccionando la sentencia correspondiente. Observa el resultado antes de pasar a la siguiente.

| Resultado                              | Qué significa                                                                               |
| -------------------------------------- | ------------------------------------------------------------------------------------------- |
| `server_version`                       | Versión del servidor real, distinta de la versión de pgAdmin.                               |
| `connected_database`                   | Base donde está abierto ese Query Tool.                                                     |
| `connected_role`                       | Rol técnico de PostgreSQL; no es el perfil médico de la aplicación.                         |
| `server_encoding`                      | Codificación de esa base; para la base de aprendizaje usaremos UTF8.                        |
| `session_timezone`                     | Zona de esta sesión. No implica que debas cambiar toda la configuración del servidor.       |
| `can_create_database` / `is_superuser` | Si este rol puede crear la base. La futura aplicación tendrá otro rol con permisos mínimos. |
| `learning_database_exists`             | Si el nombre de la práctica siguiente ya está ocupado.                                      |

Los valores concretos son **resultados esperados por observar**, no una salida real registrada. Este script no modifica nada y no necesita limpieza. No publiques contraseñas, conexiones ni datos reales en la bitácora.

## Segunda práctica: una base vacía

Hazla después de revisar el diagnóstico. Requiere `can_create_database = true` o `is_superuser = true`, y `learning_database_exists = false`. Si no tienes esos permisos, no intentes alterarlos sin entender qué rol usar.

1. Abre [03-crear-base-aprendizaje.sql](../laboratorios/03-crear-base-aprendizaje.sql) conectado a `postgres`.
2. En Query Tool activa **Auto-commit**. Ejecuta únicamente el `CREATE DATABASE`, fuera de un bloque `BEGIN/COMMIT`. [PostgreSQL no permite crear una BD dentro de una transacción](https://www.postgresql.org/docs/18/sql-createdatabase.html).
3. Refresca **Databases**. Debe aparecer `odonto_learning`.
4. Abre un nuevo Query Tool sobre esa base y repite el diagnóstico. `connected_database` debe ser `odonto_learning`; `server_encoding`, `UTF8`. Ahora `learning_database_exists` será `true`.

El script crea solo esa base vacía; el rol que lo ejecute será su dueño para el laboratorio. No es la configuración de permisos de producción. Si ya existe, no la borres para repetir: detente y revisa. No usamos `DROP`, ni reemplazamos una base anterior. Conserva la base para el siguiente bloque; todavía no habrá tablas clínicas.

Si se produce un error, conserva el mensaje para revisarlo, sin compartir secretos. No continúes pegando más scripts para intentar arreglarlo al azar.

## Tercera práctica: una tabla pequeña

Progreso del 2 de noviembre: se comprobó en pgAdmin una consulta de solo lectura que devolvió PostgreSQL **18.6** y la base administrativa `postgres`. Posteriormente el usuario informó haber creado `odonto_learning`, confirmado su conexión y obtenido un UUID con `gen_random_uuid()`. Son pasos distintos; el CREATE siguiente todavía no tiene ejecución confirmada.

Abre [04-crear-patients.sql](../laboratorios/04-crear-patients.sql) en Query Tool conectado a `odonto_learning`. Comprueba primero `SELECT current_database();` y ejecuta después únicamente el `CREATE TABLE`. Con Auto-commit activado, el resultado esperado en Messages es `CREATE TABLE`.

| Campo        | Significado                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------- |
| `id`         | UUID generado al insertar una fila; clave primaria que identifica al paciente.                              |
| `full_name`  | Nombre requerido, con algún carácter distinto de espacio. No es único: dos pacientes pueden llamarse igual. |
| `created_at` | Instante de creación generado al insertar, no fecha de nacimiento ni fecha de consulta.                     |

`CREATE TABLE` prepara la estructura; todavía no agrega pacientes. Para comprobarla ejecuta por separado `SELECT * FROM public.patients;`: esperamos esas tres columnas y ninguna fila. Si dice que la tabla ya existe, detente y revisa; no la borres para continuar. Conservaremos esta tabla para la siguiente práctica.

Es un ejercicio incremental, no el esquema definitivo de la clínica. Documento, contacto, actualización y autoría se añadirán y probarán al estudiar el siguiente bloque. Aún no usamos datos reales. Referencias: [crear tablas](https://www.postgresql.org/docs/18/sql-createtable.html), [restricciones](https://www.postgresql.org/docs/18/ddl-constraints.html) y [UUID](https://www.postgresql.org/docs/18/functions-uuid.html).

## Estado al pausar: 2 de noviembre de 2026

Prevalece este cierre sobre los pasos históricos anteriores. PostgreSQL 18.6 fue observado en pgAdmin. El usuario creó `odonto_learning` y confirmó las prácticas siguientes; el agente no ejecutó DDL.

| Bloque | Estado                                                                                                            |
| ------ | ----------------------------------------------------------------------------------------------------------------- |
| 02–03  | Diagnóstico parcial observado; creación de la base reportada. No se confirmó ejecutar íntegramente esos archivos. |
| 04     | Paciente ficticio insertado y salida compartida.                                                                  |
| 05–06  | Expediente y consulta confirmados; salida del JOIN compartida.                                                    |
| 07–09  | Usuario, perfil médico y autoría confirmados por el usuario.                                                      |
| 10–11  | Catálogo pequeño y actuación clínica confirmados por el usuario.                                                  |
| 12     | Preparado, **sin ejecución confirmada**.                                                                          |

Siguiente paso al volver: [instructivo para otra PC](16-retomar-en-otra-pc.md) y diagnóstico de solo lectura antes de repetir scripts. La app continúa con mocks; estos ejercicios no son migraciones de producción. Las comprobaciones de restricciones, rendimiento, permisos y recuperación siguen pendientes.
