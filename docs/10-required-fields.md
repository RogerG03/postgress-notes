# 10. Campos obligatorios y soporte de varios expedientes

Decisión del usuario: nombres técnicos en inglés, con `snake_case`; explicación e interfaz pueden seguir en español. El modelo admite varios expedientes para un mismo paciente, mientras el flujo inicial permite crear solo uno. Nombre y código de expediente serán obligatorios. Tras considerar niños sin documento y distintos identificadores, se ajusta la propuesta para permitir documento opcional y comparación orientativa de duplicados. Los identificadores internos serán UUID v4 aleatorios.

## Identificadores internos

Usaremos el tipo nativo `uuid` para las claves internas y sus referencias, con UUID v4 generado por el sistema, sin secuencias numéricas propias. En PostgreSQL se puede generar mediante `gen_random_uuid()`; la clave primaria seguirá impidiendo duplicados. Véase [funciones UUID de PostgreSQL 18](https://www.postgresql.org/docs/18/functions-uuid.html).

Los campos siguen llamándose `id`, `patient_id`, etcétera. UUID es su tipo, no exige renombrarlos a `uid`. El UUID no sustituye el documento del paciente ni el código visible del expediente. Los códigos de catálogo, como una pieza dental, mantienen su significado estable y no se convierten en números aleatorios.

## Relación preparada sin duplicar pacientes

`patients.id → medical_records.patient_id` es uno a muchos. `medical_records.patient_id` es una clave foránea requerida, sin unicidad sobre ese campo. Cada expediente conserva su propio `id` y `record_number` único dentro de la instalación. Las consultas pertenecen a un expediente concreto mediante `consultations.medical_record_id`.

El alta actual creará paciente y expediente juntos. Al abrir un expediente para un paciente existente, el backend debe impedir un segundo expediente, incluidos los archivados. Esa comprobación debe resistir peticiones concurrentes: una transacción y bloqueo de la fila del paciente antes de comprobar e insertar es una opción concreta. Todos los caminos de escritura deben respetarla. No se ha implementado esa política ni un mecanismo de configuración.

Cuando se habiliten múltiples expedientes, habrá que adaptar navegación, selección y reglas de acceso; permitir la relación en BD no hace funcionar automáticamente esas pantallas. No se crea otro paciente ni otra cuenta para el segundo expediente.

## `patients`

| Campo                | ¿Obligatorio?              | Quién lo proporciona y significado                                                                                                                   |
| -------------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                 | Sí                         | Sistema. Identificador interno estable; no es la cédula.                                                                                             |
| `full_name`          | Sí                         | Persona que registra. Nombre completo no vacío ni formado solo por espacios; no es único.                                                            |
| `document_type`      | Opcional                   | Tipo del documento cuando se proporciona: cédula, pasaporte u otro tipo aceptado.                                                                    |
| `document_number`    | Opcional                   | Número del documento cuando esté disponible; se admite alta sin documento, sin inventar un número.                                                   |
| `phone`              | No                         | Contacto, si está disponible; texto, sin exigir unicidad.                                                                                            |
| `date_of_birth`      | Propuesta: no inicialmente | Dato nuevo recomendado para distinguir pacientes y conocer edad. Si se incorpora, usar fecha y no edad guardada; no inventar día o mes desconocidos. |
| `created_at`         | Sí                         | Sistema. Momento de creación del registro.                                                                                                           |
| `updated_at`         | Sí                         | Sistema. Se inicializa al crear y se actualiza al modificar.                                                                                         |
| `created_by_user_id` | Sí para altas nuevas       | Backend, a partir de la cuenta autenticada. No es un selector editable.                                                                              |

La propuesta inicial de documento obligatorio se revisa por los casos planteados por el usuario. Si se informa un documento, registrar tipo y número juntos; en ausencia de documento, ambos quedan sin valor. Las reglas de país emisor, validación y múltiples documentos por persona se definirán si el alcance lo necesita. No se usará la cédula de un familiar como si fuera la del paciente.

## Posibles duplicados, no identificación infalible

Conservar el número original y comparar una representación normalizada según el tipo de documento. Para documentos cuyo formato lo permita, espacios o guiones no deben ocultar coincidencias; no convertir a número, perder ceros o eliminar caracteres significativos indiscriminadamente. Comparar documentos de tipos distintos no demuestra identidad ni diferencia de personas.

Cuando falte el documento o se use otro, comparar nombre y fecha de nacimiento conocida; el teléfono puede aportar contexto, pero puede ser compartido por una familia. No atribuir coincidencia a datos ausentes. Empezar con reglas comprensibles y avisos revisables, sin porcentajes de certeza inventados, fusiones automáticas ni bloqueos basados solo en nombres parecidos. Ofrecer abrir el paciente existente o continuar el alta tras revisar. Buscar también entre archivados.

El nombre no es único y el número de documento no tendrá una restricción global de unicidad sin acordar tipo/emisor y tratamiento de casos legítimos. UUID interno y código de expediente sí mantienen sus respectivas restricciones. El UUID evita colisiones técnicas; no detecta que la misma persona se registró dos veces. Sin más datos identificativos, el sistema solo puede advertir, no asegurar la identidad.

## `medical_records`

| Campo                | ¿Obligatorio?        | Quién lo proporciona y significado                                                                                                                                  |
| -------------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                 | Sí                   | Sistema. Identificador interno del expediente.                                                                                                                      |
| `patient_id`         | Sí                   | Backend. Paciente existente al que pertenece; no es único.                                                                                                          |
| `record_number`      | Sí                   | Persona que registra. Nombre o número visible del expediente, siguiendo la UI actual; único e inmutable después del alta. No tiene que ser exclusivamente numérico. |
| `medical_history`    | No para crear        | Antecedentes clínicos, cuando se recojan. Vacío o desconocido no equivale a «sin antecedentes».                                                                     |
| `general_notes`      | No                   | Comentarios generales del expediente.                                                                                                                               |
| `created_at`         | Sí                   | Sistema. Momento real de creación; no es la fecha de una consulta.                                                                                                  |
| `updated_at`         | Sí                   | Sistema. Momento de la última modificación.                                                                                                                         |
| `created_by_user_id` | Sí para altas nuevas | Backend. Cuenta que creó el expediente; no lo convierte en propiedad de ese usuario.                                                                                |
| `archived_at`        | No                   | Sistema. Sin valor mientras no esté archivado.                                                                                                                      |

Paciente y expediente se guardan atómicamente: si falla uno, no se confirma el otro. Una creación rápida no implica que la información clínica esté completa para atender; las validaciones de atención deben acordarse por separado.

## Fechas y autoría

`created_at` y `updated_at` se generan en el servidor. `updated_at` no es un historial de cambios completo. No añadimos fechas duplicadas con el mismo significado solo por tener más columnas.

En consultas distinguiremos `occurred_at` (fecha y hora de la atención) de `recorded_at` (momento de captura). La primera puede ser de ayer y la segunda de hoy. Los autores no se deducen de un comentario. Los datos antiguos sin autor o fecha conocida requerirán una política de importación; no se rellenan con identidades o fechas ficticias.

## Próximo acuerdo

El mínimo de alta propuesto actualizado es `full_name` y `record_number` escritos por la persona; documento, contacto y fecha de nacimiento cuando estén disponibles; IDs UUID, relaciones, fechas y autor generados o asignados por el backend. Después detallar validación de documentos y campos obligatorios de `consultations` y de los registros clínicos. No se han creado tablas ni cambiado el formulario existente.
