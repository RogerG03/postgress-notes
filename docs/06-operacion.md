# 6. Cuidar y recuperar la información

Una instalación local también necesita mantenimiento. Distingue tres preguntas: ¿quién puede acceder?, ¿qué pasa si se pierden los archivos?, ¿cómo compruebo que puedo recuperar el servicio?

## Acceso

Usa roles con los permisos necesarios. El usuario de la aplicación no debería ser superusuario; la identidad que aplica migraciones puede necesitar permisos diferentes. Permitir conexiones externas requiere revisar escucha del servidor, autenticación y firewall: no se resuelve exponiendo el puerto sin restricciones.

Para una clínica con acceso por navegador, una opción inicial es mantener PostgreSQL local al backend y publicar únicamente la aplicación en la red permitida. Acceso desde Internet es otra decisión, con su configuración de seguridad.

## Un respaldo que podamos probar

`pg_dump` genera una copia lógica consistente de una base. El formato personalizado permite restaurar con `pg_restore`; **no cifra** el contenido. Roles y otros objetos globales necesitan una estrategia adicional. No copies sin más la carpeta de datos de un servidor encendido.

Práctica propuesta, **solo con `aprendizaje_pg`**. Ejecuta desde una carpeta local privada fuera del repositorio, con herramientas disponibles en PATH. Elige un nombre nuevo para el archivo; no sobrescribas un respaldo anterior.

```powershell
pg_dump -h localhost -p 5432 -U aprendiz -W -d aprendizaje_pg -Fc -f aprendizaje-2026-11-01.dump
```

Comprueba el código de salida antes de continuar (`$LASTEXITCODE` en PowerShell); debe ser 0. Listar el archivo ayuda a comprobar que se puede leer, pero todavía no demuestra que restaure:

```powershell
pg_restore --list aprendizaje-2026-11-01.dump
```

Con una sesión administrativa prepara una base **nueva y vacía** llamada `aprendizaje_restaurada`, propiedad de `aprendiz`. Si ya existe, detente y elige otra: no la borres para seguir el tutorial.

```sql
CREATE DATABASE aprendizaje_restaurada OWNER aprendiz;
```

Restaura únicamente en esa base desechable:

```powershell
pg_restore -h localhost -p 5432 -U aprendiz -W -d aprendizaje_restaurada --no-owner --no-privileges --exit-on-error aprendizaje-2026-11-01.dump
```

Revisa el código de salida y compara objetos, conteos y consultas representativas entre origen y destino. `--no-owner --no-privileges` simplifica este ensayo; no valida la recuperación de dueños y permisos de producción. Las tablas temporales del laboratorio 1 no se respaldan: si esa es tu única práctica, la base estará sin esas tablas. Para ensayar recuperación de datos, primero necesitaremos un laboratorio con objetos permanentes y datos ficticios.

No restaures archivos desconocidos: un respaldo puede contener instrucciones ejecutables. Conserva el archivo de práctica en ubicación privada hasta decidir su limpieza; no lo subas a GitHub.

## Cifrado y automatización: siguiente etapa

Una solución completa debe producir la copia, comprobar éxito, cifrarla con una herramienta apropiada, verificar el descifrado y restaurar una muestra. La clave de recuperación debe conservarse por separado y sobrevivir a la pérdida de la computadora.

Subir una copia ya cifrada a Drive puede ser una etapa adicional, no reemplaza la prueba de restauración ni convierte Drive en almacenamiento activo del motor. Todavía no hay integración ni cifrado implementados aquí.

Antes de programarlo, acuerda cuánto trabajo se puede perder (objetivo de punto de recuperación, RPO), cuánto tiempo puede estar detenida la clínica (objetivo de tiempo de recuperación, RTO), frecuencia, retención, destino y cómo avisar fallos. Una tarea programada de Windows puede ejecutar una herramienta de respaldo aunque no haya una página abierta; depende de que la máquina esté disponible y de sus permisos.

Fuentes: [copias lógicas](https://www.postgresql.org/docs/18/backup-dump.html), [pg_dump](https://www.postgresql.org/docs/18/app-pgdump.html), [pg_restore](https://www.postgresql.org/docs/18/app-pgrestore.html), [autenticación](https://www.postgresql.org/docs/18/client-authentication.html).
