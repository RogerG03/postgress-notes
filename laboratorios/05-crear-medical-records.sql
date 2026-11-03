-- Ejecutar el bloque completo en odonto_learning, despues de la practica 4.
-- Requiere el paciente ficticio cuyo UUID proporciono el usuario.
-- Estado: preparado; pendiente de ejecucion por el usuario.
-- Es un ejercicio, no una migracion del producto.
-- Si hay un error, ejecutar ROLLBACK; y revisar antes de repetir.

BEGIN;

CREATE TABLE public.medical_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id uuid NOT NULL REFERENCES public.patients(id),
    record_number text NOT NULL UNIQUE
        CHECK (record_number ~ '[^[:space:]]'),
    created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.medical_records (patient_id, record_number)
VALUES (
    '823e17ff-c00e-469e-9473-18182cd15969',
    'EXP-DEMO-001'
);

COMMIT;

SELECT
    p.full_name,
    r.record_number,
    r.id AS medical_record_id
FROM public.medical_records AS r
JOIN public.patients AS p ON p.id = r.patient_id;

-- Esperado: Paciente de prueba A, EXP-DEMO-001 y UUID del expediente.
-- Conservar los objetos para las siguientes practicas; no usar DROP para repetir.
-- UNIQUE compara aqui el texto exacto. Normalizacion, inmutabilidad del codigo,
-- autoria y limite inicial de un expediente se implementaran en el bloque de producto.
-- patient_id no es UNIQUE: la relacion queda preparada para varios expedientes.
