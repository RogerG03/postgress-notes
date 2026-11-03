-- Ejecutar en odonto_learning despues del bloque 7 confirmado por el usuario.
-- Estado: preparado; pendiente de ejecucion confirmada.
-- Perfil profesional no equivale a permiso ni implementa autenticacion.
-- Si hay error, ejecutar ROLLBACK; y revisar antes de repetir.

BEGIN;

CREATE TABLE public.practitioner_profiles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL UNIQUE REFERENCES public.users(id),
    created_at timestamptz NOT NULL DEFAULT now()
);

WITH new_user AS (
    INSERT INTO public.users (display_name)
    VALUES ('Profesional de prueba')
    RETURNING id
)
INSERT INTO public.practitioner_profiles (user_id)
SELECT id FROM new_user;

COMMIT;

SELECT
    p.id AS practitioner_id,
    u.id AS user_id,
    u.display_name,
    u.is_active
FROM public.practitioner_profiles AS p
JOIN public.users AS u ON u.id = p.user_id;

-- Esperado: Profesional de prueba, con un UUID de perfil y otro de usuario.
-- UNIQUE(user_id): una cuenta tiene como maximo un perfil profesional.
-- WITH enlaza inserts por el UUID devuelto, sin buscar por nombre no unico.
-- Especialidades y matricula profesional se definiran al ampliar el producto.
-- Conservar tabla y datos ficticios; no borrar para repetir la practica.
