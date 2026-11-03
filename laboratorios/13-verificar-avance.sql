-- Diagnostico de SOLO LECTURA. No ejecuta ni repara las practicas.
-- Conectarse a odonto_learning; si es otra base, detenerse y cambiar conexion.
SELECT version(), current_database(), current_user;

-- Un objeto presente no demuestra que su estructura o sus datos sean correctos.
SELECT name, to_regclass('public.' || name) IS NOT NULL AS exists_in_public
FROM (VALUES
 ('patients'), ('medical_records'), ('consultations'), ('users'),
 ('practitioner_profiles'), ('clinical_concepts'), ('clinical_entries'),
 ('teeth'), ('clinical_entry_teeth')
) AS expected(name);

SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

SELECT conrelid::regclass AS table_name, conname,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, conname;
