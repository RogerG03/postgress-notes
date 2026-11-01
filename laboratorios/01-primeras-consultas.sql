-- Estado: propuesto; pendiente de ejecución en PostgreSQL 18.
-- Usar una sesión exclusiva de aprendizaje. Todo se revierte al terminar.
BEGIN;
SET LOCAL TIME ZONE 'America/Managua';

CREATE TEMP TABLE pacientes_lab (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    expediente text NOT NULL UNIQUE,
    nombre text NOT NULL CHECK (length(trim(nombre)) > 0)
) ON COMMIT DROP;

CREATE TEMP TABLE citas_lab (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paciente_id bigint NOT NULL REFERENCES pacientes_lab(id),
    atendida_en timestamptz NOT NULL
) ON COMMIT DROP;

INSERT INTO pacientes_lab (expediente, nombre)
VALUES ('DEMO-001', 'Paciente de prueba A'), ('DEMO-002', 'Paciente de prueba B');

INSERT INTO citas_lab (paciente_id, atendida_en)
SELECT id, TIMESTAMPTZ '2026-10-20 09:30:00-06'
FROM pacientes_lab WHERE expediente = 'DEMO-001';

SELECT p.expediente, p.nombre, count(c.id) AS total_citas
FROM pacientes_lab AS p
LEFT JOIN citas_lab AS c ON c.paciente_id = p.id
GROUP BY p.id, p.expediente, p.nombre
ORDER BY p.expediente;

-- Esperado: DEMO-001 tiene 1 cita; DEMO-002 tiene 0.
DO $$
BEGIN
    IF (SELECT count(*) FROM pacientes_lab) <> 2
       OR (SELECT count(*) FROM citas_lab) <> 1 THEN
        RAISE EXCEPTION 'Los conteos no coinciden con el ejercicio';
    END IF;

    BEGIN
        INSERT INTO pacientes_lab (expediente, nombre) VALUES ('DEMO-001', 'Duplicado');
        RAISE EXCEPTION 'Falta la restricción UNIQUE';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Correcto: expediente duplicado rechazado';
    END;

    BEGIN
        INSERT INTO citas_lab (paciente_id, atendida_en) VALUES (-1, now());
        RAISE EXCEPTION 'Falta la clave foránea';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Correcto: paciente inexistente rechazado';
    END;
END;
$$;

ROLLBACK;
