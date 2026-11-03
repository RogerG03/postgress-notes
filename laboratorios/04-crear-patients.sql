-- Practica incremental: ejecutar solo en odonto_learning.
-- Tabla de aprendizaje, no esquema final de la aplicacion.
-- Estado: preparado; el usuario ejecutara este CREATE y comprobara el resultado.
-- Primero verificar SELECT current_database(); debe devolver odonto_learning.
-- Si patients ya existe, detenerse y revisar; no borrarla ni repetir con DROP.

CREATE TABLE public.patients (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name text NOT NULL CHECK (full_name ~ '[^[:space:]]'),
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Comprobacion posterior, ejecutar por separado:
-- SELECT * FROM public.patients;
-- Esperado: columnas id, full_name y created_at; cero filas.
-- La tabla queda para la siguiente practica; no requiere borrado.
-- Documento, contacto, actualizacion y autoria se estudiaran al ampliar el modelo.
