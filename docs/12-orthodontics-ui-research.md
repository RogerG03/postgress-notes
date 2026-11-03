# 12. Ortodoncia e iconografía: investigación y propuesta de interfaz

Estado: investigación y diseño propuesto; no se modificó la aplicación. Fecha: 1 de noviembre de 2026. La selección de varias piezas para guardar una actuación está aceptada. El usuario prefiere conservar el odontograma, con marcadores sobre las piezas y un acceso a una sección de ortodoncia; no solicita una nueva simulación frontal con arco.

## Qué aprendimos de las fuentes

La AAPD separa evaluación, objetivos y planificación de las notas de evolución. Su guía de desarrollo de la dentición contempla problemas variados y registros diagnósticos según el caso; no existe un único formulario de «colocar brackets» que describa toda la atención. Fuente: [Management of the Developing Dentition and Occlusion, revisión 2024](https://www.aapd.org/media/Policies_Guidelines/BP_DevelopDentition.pdf).

Su documento de [Recordkeeping](https://www.aapd.org/globalassets/media/policies_guidelines/bp_recordkeeping.pdf) distingue los datos de cada visita y las notas de progreso, incluyendo problemas del aparato y preocupaciones del paciente. La ADA presenta SOAP como una forma posible de organizar anotaciones: [Writing in the Dental Record](https://www.ada.org/resources/practice/practice-management/writing-in-the-dental-record). Estos recursos orientan la organización; no convierten los campos propuestos en exigencias legales locales ni recomendaciones de tratamiento.

La NTS 188 de Perú estandariza gráfico y nomenclatura del odontograma según su [ficha oficial](https://repositorio.minsa.gob.pe/handle/MINSA/81634). Sirve como referencia para investigar un repertorio coherente, no como norma automáticamente aplicable a otra clínica o país. El PDF enlazado respondió 403 durante la consulta: no se revisaron sus láminas ni se validó un símbolo contra ellas. La norma anterior NTS 150 fue derogada por la resolución que aprueba NTS 188; no copiarla como si fuera la vigente.

## Propuesta de entrada y distribución

Modo de uso: Operate. Conservar tipografía, paleta, controles MUI y odontograma actuales. Agregar un botón **Ortodoncia** junto a las acciones del odontograma. Abre una sección dentro del mismo espacio del paciente, sin navegar a otra página ni modificar todavía los dibujos.

En escritorio: odontograma para seleccionar piezas y panel lateral con resumen de selección y formulario. En móvil: selección primero y formulario debajo, con un resumen visible de las piezas seleccionadas. Salir protege cualquier borrador sin guardar.

```text
Odontograma                     [Ortodoncia]

Seleccionar piezas                  Registrar atención
[odontograma actual]                Cita y profesional
                                    Piezas: [13 ×] [14 ×]
                                    Qué se encontró
                                    Qué se realizó
                                    Evolución / incidencias
                                    Indicaciones y siguiente paso
                                    [Guardar actuación]

Resumen del tratamiento             Historial por fecha y cita
```

La selección tendrá texto «Seleccionar piezas», contador, botones para quitar cada pieza y limpiar selección. No cambiar el significado del clic habitual fuera de ese modo. Debe poder usarse con teclado y anunciar la selección sin depender del color.

## Dos niveles de información

### Resumen del tratamiento

Contexto que no debería reescribirse en cada control: motivo o problema descrito por el profesional, valoración, objetivos y descripción libre de aparatología/técnica si corresponde. Admitir tratamiento iniciado en otra clínica. Esta sección es propuesta, no un diagnóstico automatizado ni una lista obligatoria de maloclusiones. Si se edita, conservar evolución y autoría en lugar de alterar silenciosamente la historia.

### Registro de la atención actual

| Campo visible                    | Comportamiento propuesto                                                                                                            |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Cita y profesional               | Tomados de la consulta seleccionada. El autor de captura se registra por separado.                                                  |
| Piezas involucradas              | Selección múltiple explícita. Una nota general puede no tener piezas; no se interpreta como toda la boca.                           |
| Tipo de actuación                | Catálogo pequeño como ayuda, con «Otra actuación» y descripción requerida cuando se use. No forzar todo a colocación/ajuste/retiro. |
| Qué se encontró                  | Texto libre de observaciones/valoración, con ayuda breve.                                                                           |
| Qué se realizó                   | Texto libre requerido para una actuación realizada; sin completar automáticamente procedimientos.                                   |
| Evolución e incidencias          | Texto libre cuando aplique.                                                                                                         |
| Aparatología o detalles técnicos | Opcional, plegado inicialmente; no exigir datos técnicos para todos los casos.                                                      |
| Indicaciones y siguiente paso    | Texto libre opcional. No crea una cita futura automáticamente.                                                                      |

El formulario debe distinguir una valoración, un plan y un procedimiento realizado. No todas las secciones son obligatorias en cada tipo de nota. El mínimo y las etiquetas definitivas requieren revisión con la clínica; los campos no constituyen un expediente ortodóntico completo certificado. Adjuntos e imágenes son un alcance aparte, no una carga de archivos fingida.

El caso personal referido por el usuario ilustra la necesidad de describir intervenciones variadas. No se le asigna un diagnóstico retrospectivo ni se sugiere cómo debía tratarse.

## Qué mostrar sobre las piezas

Un marcador de aparato se superpone sin reemplazar hallazgos o restauraciones. Solo representa datos expresamente registrados: una nota de ajuste general no demuestra qué pieza tiene bracket. Un punto de anclaje u otro dispositivo no se dibuja automáticamente como bracket.

Si confluyen varios datos, usar un marcador principal con indicador de más registros y ofrecer lista con etiquetas al abrir; no apilar símbolos ilegibles ni depender de hover. La leyenda debe explicar nombre, significado y estados. Mantener filtro por fecha e información desconocida explícita. No inferir retirada de aparato porque no haya un registro reciente.

No diseñar todavía arcos, fuerzas o movimientos como si el gráfico fuera una simulación clínica. Los estados planeado, observado, realizado, retirado y corregido deben distinguirse antes de producir un símbolo «actual». La terminación de un procedimiento y la presencia actual de un aparato no son el mismo estado.

## Inventario real y huecos del odontograma actual

Se leyeron completos `src/modules/odontogram/data/dental-catalog.ts` y `src/modules/odontogram/ui/clinical-symbol.tsx` de OdontoSoft. MCP no disponible (`Transport closed`), incluida comprobación de cobertura; conclusiones limitadas a esos archivos y a capturas previas de la interfaz.

El catálogo actual tiene cinco estados físicos, seis hallazgos y cinco tratamientos. Entre los símbolos dedicados hay caries, restauración, fractura, movilidad, ausencia/extracción, erupción, corona y endodoncia. Corona usa una silueta de corona decorativa; los símbolos se eligen comparando etiquetas de texto. No se afirma que ese repertorio esté clínicamente estandarizado.

Propuesta de revisión por familias, validando conceptos y nombres antes del dibujo:

| Familia                        | Candidatos a cubrir                                                                                                               |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| Situación y posición de piezas | Ausencia y extracción diferenciadas en texto; erupción, retención/inclusión y posición anómala cuando se definan.                 |
| Lesiones y restauraciones      | Caries, fractura y restauraciones por superficie, con su condición registrada.                                                    |
| Rehabilitación                 | Corona protésica, incrustación, carilla y puente; distinguir elementos y piezas implicadas.                                       |
| Endodoncia                     | Representación específica, sin prometer datos que no se capturen.                                                                 |
| Implantes y anclaje            | Separar implante protésico, perno intrarradicular y anclaje ortodóntico; «tornillo» no identifica por sí solo el concepto.        |
| Ortodoncia                     | Bracket y otros aparatos según alcance validado; conservar el detalle escrito para intervenciones no representables en una marca. |

No importar una colección de iconos genéricos como sustituto del sistema clínico. Proponer una lámina con símbolo, nombre, localización y significado de estados para revisión por el profesional. El SVG puede vivir en código y referenciarse mediante una clave estable de catálogo; no depender del texto traducido ni aceptar SVG arbitrario enviado por un catálogo remoto. Esta es una decisión de representación propuesta, no una migración ya hecha.

## Orden recomendado

1. Revisar con la clínica la lista y la nomenclatura de símbolos faltantes, usando su hoja de odontograma si existe.
2. Preparar una maqueta del botón/sección de ortodoncia con selección múltiple y formulario flexible, más la lámina de símbolos prioritarios.
3. Confirmar interacción, campos y significado visual antes de implementar UI o ajustar nuevamente el esquema de BD.

Sin cambios clínicos o legales asumidos, sin nuevos paquetes y sin ejecución de pruebas de producto: esta entrega solo investiga y documenta una propuesta.

## Prototipo local de UI, 2 de noviembre de 2026

Implementado en OdontoSoft sobre datos ficticios: activar modo ortodoncia, seleccionar varias piezas en los dibujos del odontograma y Confirmar piezas para abrir el modal. Se preselecciona la cita activa y se permite cambiarla. Campos flexibles: valoración/objetivo, descripción obligatoria, evolución, siguiente paso y aparatología opcional. Cambiar piezas conserva el formulario; cancelar protege el borrador. Una actuación se muestra una vez en el resumen de la cita y queda accesible desde sus piezas.

El contrato de presentación usa `ToothEvent.teeth` y detalles `orthodontics`, no tablas nuevas. Colocación/presencia documentada añade marcador; retiro lo quita por pieza y fecha; un ajuste solo no lo añade. No representa todos los aparatos ni un tratamiento longitudinal, ni demuestra ausencia de aparato cuando no existe registro. Pendiente validación profesional. Esta ampliación de UI no crea BD, migraciones ni persistencia: recargar borra los cambios.

Las superficies habituales varían según pieza y arcada. Otra localización conserva texto libre sin inventar un código anatómico. Referencias: [superficies dentales, Dentalcare](https://www.dentalcare.com/en-us/ce-courses/ce500/surfaces-of-the-teeth) y [áreas de tratamiento, Open Dental](https://www.opendental.com/manual/procedureedit.html).
