-- Ejecutar en odonto_learning, despues de la practica 5.
-- Estado: preparado, pendiente de ejecucion por el usuario.
-- Ejercicio incremental con datos ficticios; no esquema de producto.
-- Si hay un error, ejecutar ROLLBACK; y revisar antes de repetir.

BEGIN;

CREATE TABLE public.consultations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    medical_record_id uuid NOT NULL REFERENCES public.medical_records(id),
    reason text NOT NULL CHECK (reason ~ '[^[:space:]]'),
    occurred_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.consultations (medical_record_id, reason, occurred_at)
VALUES (
    (SELECT id FROM public.medical_records WHERE record_number = 'EXP-DEMO-001'),
    'Revisión ficticia de demostración',
    now()
);

COMMIT;

SELECT
    p.full_name,
    r.record_number,
    c.reason,
    c.occurred_at,
    c.recorded_at
FROM public.consultations AS c
JOIN public.medical_records AS r ON r.id = c.medical_record_id
JOIN public.patients AS p ON p.id = r.patient_id;

-- Esperado: paciente, expediente y motivo de la consulta ficticia, con dos tiempos.
-- occurred_at: atencion; recorded_at: captura. Aqui coinciden porque usamos now().
-- Si el expediente no existe, la subconsulta devuelve NULL y NOT NULL impide guardar.
-- Conservar la tabla para la siguiente practica; no DROP ni reejecucion del CREATE.
-- Profesional responsable, autor autenticado, archivo y demas datos se incorporaran
-- al diseno completo; no conectar esta tabla de practica a pacientes reales.
