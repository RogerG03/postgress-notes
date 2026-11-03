-- Solo odonto_learning. Bloque 11 confirmado por el usuario.
-- Estado: preparado; pendiente de ejecucion confirmada.
-- Catalogo de aprendizaje reducido a dos piezas permanentes.
-- Si hay error: ROLLBACK; y revisar; no borrar tablas ni usar LIMIT 1.

BEGIN;

CREATE TABLE public.teeth (
    fdi smallint PRIMARY KEY,
    label text NOT NULL CHECK (label ~ '[^[:space:]]'),
    CHECK (
        (fdi / 10 BETWEEN 1 AND 4 AND fdi % 10 BETWEEN 1 AND 8)
        OR (fdi / 10 BETWEEN 5 AND 8 AND fdi % 10 BETWEEN 1 AND 5)
    )
);

INSERT INTO public.teeth (fdi, label)
VALUES (16, 'Pieza permanente 16'), (26, 'Pieza permanente 26');

CREATE TABLE public.clinical_entry_teeth (
    clinical_entry_id uuid NOT NULL REFERENCES public.clinical_entries(id),
    tooth_fdi smallint NOT NULL REFERENCES public.teeth(fdi),
    PRIMARY KEY (clinical_entry_id, tooth_fdi)
);

INSERT INTO public.clinical_entry_teeth (clinical_entry_id, tooth_fdi)
VALUES (
    (SELECT e.id
     FROM public.clinical_entries AS e
     JOIN public.clinical_concepts AS cc ON cc.id = e.clinical_concept_id
     JOIN public.consultations AS c ON c.id = e.consultation_id
     JOIN public.medical_records AS r ON r.id = c.medical_record_id
     WHERE r.record_number = 'EXP-DEMO-001'
       AND c.reason = 'Revisión ficticia de demostración'
       AND cc.code = 'finding-caries'),
    16
);

COMMIT;

SELECT r.record_number, e.label_snapshot, t.fdi, t.label
FROM public.clinical_entry_teeth AS target
JOIN public.teeth AS t ON t.fdi = target.tooth_fdi
JOIN public.clinical_entries AS e ON e.id = target.clinical_entry_id
JOIN public.consultations AS c ON c.id = e.consultation_id
JOIN public.medical_records AS r ON r.id = c.medical_record_id;

-- Esperado: EXP-DEMO-001, Caries, 16, Pieza permanente 16.
-- La PK compuesta evita repetir una pieza dentro de la misma actuacion.
-- La tabla teeth es catalogo, no el estado de un diente de un paciente.
-- El catalogo completo, superficies, compatibilidad de objetivos y reglas de
-- implantes/ortodoncia/protesis/correccion siguen pendientes. No es producto listo.
