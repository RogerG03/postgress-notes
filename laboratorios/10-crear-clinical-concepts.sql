-- Ejecutar en odonto_learning. Solo datos ficticios y catalogo de demostracion.
-- Estado: preparado; pendiente de ejecucion confirmada.
-- No es un catalogo clinico validado ni una migracion de producto.
-- Si hay error: ROLLBACK; y revisar. No borrar tablas para repetir.

BEGIN;

CREATE TABLE public.clinical_concepts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE CHECK (code ~ '[^[:space:]]'),
    label text NOT NULL CHECK (label ~ '[^[:space:]]'),
    category text NOT NULL
        CHECK (category IN ('physical_state', 'finding', 'treatment')),
    is_active boolean NOT NULL DEFAULT true
);

INSERT INTO public.clinical_concepts (code, label, category)
VALUES
    ('physical-present', 'Presente', 'physical_state'),
    ('finding-caries', 'Caries', 'finding'),
    ('treatment-extraction', 'Extracción', 'treatment');

COMMIT;

SELECT code, label, category, is_active
FROM public.clinical_concepts
ORDER BY code;

-- Esperado: tres opciones activas, una por categoria de esta practica.
-- UUID: identidad de fila. code: identificador semantico estable. label: texto visible.
-- Este paso no crea actuaciones ni modifica el estado de ningun paciente.
-- Al crear clinical_entries conservaremos referencia al concepto y etiqueta historica.
-- Los registros generales sin concepto tambien se consideraran en ese bloque.
