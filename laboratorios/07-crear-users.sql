-- Ejecutar en odonto_learning. Ejercicio incremental con datos ficticios.
-- Estado: preparado; pendiente de ejecucion por el usuario.
-- Esto registra una identidad de prueba, no instala login ni concede permisos.
-- Si hay error, ejecutar ROLLBACK; y revisar; no borrar tablas para repetir.

BEGIN;

CREATE TABLE public.users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    display_name text NOT NULL CHECK (display_name ~ '[^[:space:]]'),
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.users (display_name)
VALUES ('Usuario de prueba');

COMMIT;

SELECT id, display_name, is_active, created_at
FROM public.users;

-- Esperado: un usuario ficticio con is_active = true.
-- El nombre visible no es un identificador de login ni debe ser UNIQUE.
-- Conservar tabla y fila; despues estudiaremos perfil profesional y referencias.
-- No inventar contrasenas, roles ni autor de registros historicos reales.
