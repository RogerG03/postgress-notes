-- Ejecutar en odonto_learning despues del catalogo confirmado del bloque 10.
-- Estado: preparado; pendiente de ejecucion confirmada.
-- Datos ficticios. Todavia no se asigna esta actuacion a una pieza dental.
-- Si hay error, ejecutar ROLLBACK; y revisar. No borrar tablas para repetir.

BEGIN;

CREATE TABLE public.clinical_entries (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    consultation_id uuid NOT NULL REFERENCES public.consultations(id),
    clinical_concept_id uuid REFERENCES public.clinical_concepts(id),
    label_snapshot text NOT NULL CHECK (label_snapshot ~ '[^[:space:]]'),
    notes text NOT NULL DEFAULT '',
    recorded_by_user_id uuid NOT NULL REFERENCES public.users(id),
    recorded_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.clinical_entries (
    consultation_id, clinical_concept_id, label_snapshot, notes, recorded_by_user_id
)
VALUES (
    (SELECT c.id
     FROM public.consultations AS c
     JOIN public.medical_records AS r ON r.id = c.medical_record_id
     WHERE r.record_number = 'EXP-DEMO-001'
       AND c.reason = 'Revisión ficticia de demostración'),
    (SELECT id FROM public.clinical_concepts WHERE code = 'finding-caries'),
    (SELECT label FROM public.clinical_concepts WHERE code = 'finding-caries'),
    'Registro ficticio para practicar; pieza pendiente del siguiente bloque.',
    (SELECT id FROM public.users WHERE display_name = 'Usuario de prueba')
);

COMMIT;

SELECT
    r.record_number,
    c.reason,
    e.label_snapshot,
    e.notes,
    u.display_name AS recorded_by
FROM public.clinical_entries AS e
JOIN public.consultations AS c ON c.id = e.consultation_id
JOIN public.medical_records AS r ON r.id = c.medical_record_id
JOIN public.users AS u ON u.id = e.recorded_by_user_id;

-- Esperado: EXP-DEMO-001, motivo ficticio, Caries, nota y Usuario de prueba.
-- Los SELECT escalares fallan si hay coincidencias multiples; no usar LIMIT 1.
-- Si falta consulta/autor/concepto de esta practica, sus datos requeridos fallan.
-- clinical_concept_id admite NULL para notas generales sin concepto de catalogo.
-- label_snapshot conserva el texto de la actuacion, distinto de la etiqueta actual.
-- La app futura validara clase, concepto activo, objetivos y autor de sesion.
-- Proyeccion clinica, objetivos, correcciones e inmutabilidad del historial aun pendientes.
