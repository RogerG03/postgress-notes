-- Practica 2: diagnostico de solo lectura. Sin contrasenas ni cambios de datos.
-- Estado: revisado contra documentacion de PostgreSQL 18; no ejecutado aqui.
-- Abrir Query Tool en una conexion local disponible (por ejemplo, postgres).
-- Selecciona y ejecuta cada SELECT por separado para observar su resultado.

SELECT
    current_setting('server_version') AS server_version,
    current_database() AS connected_database,
    current_user AS connected_role,
    current_setting('server_encoding') AS server_encoding,
    current_setting('TimeZone') AS session_timezone;

-- Esta consulta mira exclusivamente los privilegios del rol conectado.
-- Que sea superusuario no significa que la futura app deba usarlo.
SELECT
    rolcreatedb AS can_create_database,
    rolsuper AS is_superuser
FROM pg_catalog.pg_roles
WHERE rolname = current_user;

-- true: la base ya existe; no ejecutes CREATE DATABASE sobre ese nombre.
-- false: no existe una base con ese nombre. No se crea nada con este SELECT.
SELECT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_database
    WHERE datname = 'odonto_learning'
) AS learning_database_exists;
