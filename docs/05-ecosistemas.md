# 5. PostgreSQL y otros ecosistemas

El servidor no necesita saber si tu interfaz está hecha en React. Recibe conexiones de clientes que hablan su protocolo; cada lenguaje puede usar un driver. Un ORM es otra capa: ayuda a representar datos y consultas, pero no sustituye comprender SQL, permisos o transacciones.

| Entorno | Cliente habitual y documentación oficial | Qué aprender primero |
| --- | --- | --- |
| JavaScript / TypeScript en Node.js | [node-postgres (`pg`)](https://node-postgres.com/features/queries) | Parámetros, conexiones y pool. |
| Python | [Psycopg](https://www.psycopg.org/psycopg3/docs/basic/usage.html) | Parámetros y contexto de transacción. |
| Java | [pgJDBC](https://jdbc.postgresql.org/documentation/use/) | Conexión JDBC y sentencias preparadas. |

Un **pool** administra conexiones reutilizables. No implica conexiones ilimitadas: varias instancias de la aplicación suman su consumo. Una transacción debe usar la misma conexión durante todas sus sentencias; con `pg`, no se reparten mediante llamadas independientes a `pool.query`.

## Ejemplo mínimo en Node.js

Fragmento explicativo, pendiente de ejecución; requiere un proyecto Node.js con módulos ESM y el paquete `pg`. No instala dependencias en este repositorio. Configura `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` y `PGPASSWORD` por un mecanismo local seguro; no las publiques ni las escribas en el código.

```js
import pg from 'pg';

const pool = new pg.Pool(); // Lee la configuración de conexión del entorno.
try {
  const result = await pool.query('SELECT $1::text AS saludo', ['Hola, PostgreSQL']);
  console.log(result.rows[0].saludo);
} finally {
  await pool.end(); // Este ejemplo es un proceso breve, no un servidor web.
}
```

Resultado esperado: `Hola, PostgreSQL`. `$1` separa el valor del texto SQL y evita concatenarlo como instrucciones. Los parámetros no sustituyen nombres de tablas o columnas; esos identificadores requieren un tratamiento diferente y no deben salir directamente de una entrada del usuario.

En un backend de larga duración se reutiliza el pool y se cierra al terminar el proceso, no después de cada petición. Si la conexión falla, revisa entorno, permisos y disponibilidad; no registres contraseñas para depurar.

## Cómo encaja Next.js

El navegador envía una petición o invoca una acción. El servidor autentica al usuario, autoriza la operación, valida la entrada y usa el driver u ORM para consultar. Después devuelve solo los datos que el usuario puede ver.

Server Components pueden consultar desde el servidor; Server Actions sirven para operaciones invocadas desde la interfaz; Route Handlers permiten exponer endpoints HTTP. No hace falta llamar por HTTP a una ruta propia desde cada Server Component para llegar a la base.

Las credenciales y el acceso SQL pertenecen al código de servidor. No uses `NEXT_PUBLIC_` para secretos ni conectes directamente el navegador a PostgreSQL. Redux o Context pueden gestionar estado de interfaz; no son una base persistente ni un requisito del backend.

## Cambios de estructura

Una **migración** es un cambio versionado del esquema, por ejemplo agregar una columna. Es distinta de un respaldo y de los datos iniciales de demostración. Antes de automatizar actualizaciones, debemos ensayar migraciones y recuperación con una copia desechable; nunca reemplazar la base de una clínica por la de desarrollo.

Fuentes adicionales: [conexión de pg](https://node-postgres.com/features/connecting), [pool](https://node-postgres.com/features/pooling), [transacciones de pg](https://node-postgres.com/features/transactions), [Next.js como backend](https://nextjs.org/docs/app/guides/backend-for-frontend), [Redux con Next.js](https://redux.js.org/usage/nextjs).
