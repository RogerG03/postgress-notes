# 2. Preparar un entorno local sin mezclar responsabilidades

## Qué programa sirve para qué

| Herramienta | Para qué la usaríamos | ¿Es necesaria? |
| --- | --- | --- |
| PostgreSQL Server | Guardar y consultar información. | Sí para ejecutar estas prácticas. |
| psql | Conectarnos y ejecutar archivos SQL desde terminal. | Para los comandos de este repositorio. |
| pgAdmin | Explorar bases y ejecutar SQL visualmente. | Opcional. |
| Editor de texto | Escribir notas y SQL. | Cualquiera sirve. |
| Node.js, Python o Java | Ejecutar una integración del capítulo 5. | Solo para la integración elegida. |

En Windows, el instalador enlazado por PostgreSQL permite seleccionar servidor, herramientas de línea de comandos y pgAdmin. Stack Builder ofrece complementos y no es un requisito para comenzar. No necesitamos Docker, un ORM ni una cuenta en la nube para aprender SQL.

Descarga desde la [página oficial para Windows](https://www.postgresql.org/download/windows/). El procedimiento exacto depende del instalador y la versión; consulta sus [instrucciones](https://www.enterprisedb.com/docs/supported-open-source/postgresql/installing/windows/). No copies una contraseña de ejemplo a una instalación real.

## Primer objetivo: verificar la conexión

Antes de instalar, acuerda dónde se guardarán los datos y quién conservará la contraseña administrativa. Usa el administrador para preparar el entorno, no como usuario habitual de una aplicación. Mantén inicialmente el servicio accesible solo desde la máquina local.

Tras instalar, verifica las herramientas en PowerShell:

```powershell
psql --version
pg_dump --version
```

Esto identifica los **clientes**, no demuestra que el servidor esté encendido. Si el comando no existe en PATH, busca la carpeta `bin` de tu instalación; no reinstales automáticamente.

Abre una sesión administrativa local; el parámetro `-W` solicita la contraseña sin incluirla en el comando:

```powershell
psql -h localhost -p 5432 -U postgres -d postgres -W
```

Si el usuario o puerto difieren, adapta el comando. Dentro de psql, crea una identidad y una base **solo para aprender**:

```sql
CREATE ROLE aprendiz LOGIN;
\password aprendiz
CREATE DATABASE aprendizaje_pg OWNER aprendiz;
\q
```

`\password` y `\q` son instrucciones de **psql**, no SQL para pgAdmin. El rol será dueño de su base de práctica: no es el diseño de permisos recomendado para una aplicación productiva.

Conecta con ese rol y ejecuta `SELECT current_database(), current_user;`:

```powershell
psql -h localhost -p 5432 -U aprendiz -d aprendizaje_pg -W
```

Esperamos `aprendizaje_pg` y `aprendiz`. No continúes si estás conectado a una base real de pacientes.

## Si falla

| Mensaje o síntoma | Qué revisar primero |
| --- | --- |
| Comando no reconocido | Ruta de las herramientas cliente. |
| Conexión rechazada | Servicio, dirección y puerto. |
| Fallo de autenticación | Rol, contraseña y reglas de acceso; no desactivar autenticación. |
| Base inexistente | Nombre de la base a la que intentas entrar. |

Anota el error sin secretos. Puedes completar esta etapa cuando conectes con el rol de práctica y distingas la versión del cliente de la del servidor.

Fuentes: [psql](https://www.postgresql.org/docs/18/app-psql.html), [roles](https://www.postgresql.org/docs/18/user-manag.html), [CREATE DATABASE](https://www.postgresql.org/docs/18/sql-createdatabase.html).
