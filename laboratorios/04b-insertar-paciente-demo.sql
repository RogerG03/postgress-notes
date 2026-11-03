-- Solo para reconstruir una base NUEVA tras el bloque 04.
-- No repetir en la base original: el paciente ya existe.
-- El UUID explicito permite ejecutar el bloque 05 sin cambiar su referencia.
INSERT INTO public.patients (id, full_name)
VALUES ('823e17ff-c00e-469e-9473-18182cd15969', 'Paciente de prueba A');

SELECT id, full_name, created_at
FROM public.patients
WHERE id = '823e17ff-c00e-469e-9473-18182cd15969';
