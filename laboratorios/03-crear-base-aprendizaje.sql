-- Practica 3: crear una base VACIA de aprendizaje, no la BD de produccion.
-- Estado: propuesto; no ejecutado aqui. Primero completar practica 2.
-- Requiere rol con CREATEDB o superusuario y nombre inexistente.
-- Ejecutar conectado a postgres, con Auto-commit activado en Query Tool.
-- Ejecutar esta unica sentencia, fuera de BEGIN/COMMIT.
-- Si la base ya existe: detenerse. No borrar ni reemplazar esa base.
-- El dueno sera el rol que ejecute CREATE DATABASE (solo para este laboratorio).
-- La futura app usara un rol propio de privilegios limitados, nunca superusuario.

CREATE DATABASE odonto_learning
    WITH TEMPLATE = template0
    ENCODING = 'UTF8';

-- Despues: refrescar Databases en pgAdmin y abrir OTRO Query Tool
-- sobre odonto_learning. Ejecutar alli el diagnostico de la practica 2.
-- Resultado esperado de connected_database: odonto_learning.
-- Este archivo no crea tablas ni usuarios, no cambia permisos o configuracion,
-- no inserta datos y no conecta la aplicacion. La base queda para la practica 4.
