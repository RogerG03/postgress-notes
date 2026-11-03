-- Solo odonto_learning, despues del bloque 8 confirmado por el usuario.
-- Estado: preparado; pendiente de ejecucion confirmada.
-- Asignamos deliberadamente identidades FICTICIAS a la consulta del ejercicio.
-- No usar este backfill para atribuir autoria desconocida de registros reales.
-- Si hay error: ROLLBACK; y revisar. No borrar ni anadir LIMIT 1 para ocultarlo.

BEGIN;

ALTER TABLE public.consultations
    ADD COLUMN responsible_practitioner_id uuid
        REFERENCES public.practitioner_profiles(id),
    ADD COLUMN recorded_by_user_id uuid
        REFERENCES public.users(id);

UPDATE public.consultations
SET responsible_practitioner_id = (
        SELECT p.id
        FROM public.practitioner_profiles AS p
        JOIN public.users AS u ON u.id = p.user_id
        WHERE u.display_name = 'Profesional de prueba'
    ),
    recorded_by_user_id = (
        SELECT id FROM public.users
        WHERE display_name = 'Usuario de prueba'
    )
WHERE medical_record_id = (
    SELECT id FROM public.medical_records
    WHERE record_number = 'EXP-DEMO-001'
)
AND reason = 'Revisión ficticia de demostración';

ALTER TABLE public.consultations
    ALTER COLUMN responsible_practitioner_id SET NOT NULL,
    ALTER COLUMN recorded_by_user_id SET NOT NULL;

COMMIT;

SELECT
    c.reason,
    doctor.display_name AS responsible_practitioner,
    author.display_name AS recorded_by
FROM public.consultations AS c
JOIN public.practitioner_profiles AS p ON p.id = c.responsible_practitioner_id
JOIN public.users AS doctor ON doctor.id = p.user_id
JOIN public.users AS author ON author.id = c.recorded_by_user_id;

-- Esperado: motivo ficticio, Profesional de prueba, Usuario de prueba.
-- Una subconsulta con nombres duplicados falla; no son claves de login.
-- En la app se usaran IDs verificados y autor obtenido de la sesion del servidor.
-- NOT NULL fallara y revertiremos si quedan consultas sin asignacion en este lab.
-- El modelo de importacion real debe conservar desconocidos, no inventarlos.
