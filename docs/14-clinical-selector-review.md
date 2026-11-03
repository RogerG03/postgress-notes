# 14. Selector clínico compacto y primera revisión de recursos

El usuario pide un desplegable con icono y nombre para evitar llenar el detalle dental de opciones, y comenzar a revisar la investigación del chat paralelo. Se implementa únicamente ese ajuste de interfaz sobre los conceptos existentes de OdontoSoft; no se importan símbolos ni se adopta un motor de terceros.

## Cambio en la aplicación

Se conservan las categorías Estado físico, Hallazgo y Tratamiento. Dentro de cada categoría se usa el Select MUI compartido, con icono y etiqueta tanto en el valor seleccionado como en el menú. El menú tiene altura limitada y desplazamiento; los IDs de catálogo siguen siendo el valor guardado y las etiquetas históricas se conservan.

Un catálogo sin opciones deshabilita el control e informa «Sin opciones disponibles». Se mantiene el menú dentro del diálogo nativo para poder interactuar con él y Escape cierra primero el desplegable. Los otros selectores de la app siguen usando texto si no suministran iconos.

No se agrega búsqueda en esta primera versión acotada. Si se amplía el catálogo considerablemente, revisar búsqueda y agrupación antes de volcar todo el inventario en una lista. Los pictogramas actuales siguen siendo provisionales y no se declaran clínicamente estandarizados.

## Primera revisión de la investigación externa

Se volvió a leer la entrega completa del [chat de iconografía](https://chatgpt.com/c/6ae82405-52ac-83e8-8e55-3247df6d9e09), cuyo título visible ahora es «Investigar iconografía odontográfica». Se verificaron estos puntos en fuentes originales:

| Recurso                                                                                                   | Evidencia leída                                                                                                                                                                                                                                                                                                                                                    | Conclusión para nuestro trabajo                                                                                                                                                       |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Dentrix Ascend](https://hsps.pro/DentrixAscend/Help/Charting_symbols.htm)                                | Su leyenda enumera condiciones y procedimientos, con variantes de coronas, puentes, implantes, postes y restauraciones; distingue estados del procedimiento.                                                                                                                                                                                                       | Útil para revisar familias y evitar confundir piezas, procedimientos y estados. Su convención no se adopta automáticamente ni autoriza copiar gráficos.                               |
| [React Advanced Odontogram](https://github.com/ZoliQua/React-Advanced-Odontogram/blob/main/README.md)     | README, [LICENSE](https://github.com/ZoliQua/React-Advanced-Odontogram/blob/main/LICENSE) y [THIRD-PARTY-NOTICES](https://github.com/ZoliQua/React-Advanced-Odontogram/blob/main/THIRD-PARTY-NOTICES.md). El autor declara originales/MIT sus SVG y documenta avisos de terceros. También declara componente cliente y estado global con una instancia por página. | Candidato para estudiar dibujos y capas. No se instaló, auditó o probó su compatibilidad con la app; integrar el motor requiere revisar aislamiento, estado e historial por paciente. |
| [react-odontogram de biomathcode](https://github.com/biomathcode/react-odontogram/blob/main/package.json) | `package.json` declara MIT y describe un selector dental. Se inspeccionó el listado raíz; la consulta de `LICENSE` en esa ruta respondió 404.                                                                                                                                                                                                                      | Declaración de licencia identificada; aviso completo y procedencia de assets pendientes antes de reutilizarlos. No asumir que no existe licencia en otra ruta.                        |

El resto del inventario, incluidas láminas NTS 188, axiUm, referencias académicas locales y licencias de iconos individuales, sigue pendiente de revisión directa. Las cantidades publicadas por bancos gráficos no equivalen a conceptos clínicos únicos. Las afirmaciones de compatibilidad, anatomía o estándares de un README son declaraciones del proyecto, no validación clínica independiente.

## Qué revisar después

Preparar una matriz por concepto: nombre, ubicación (superficie/pieza/raíz/varias piezas), símbolo candidato, fuente, estado representado y prioridad. Comenzar por conceptos actuales y huecos señalados por el usuario: corona protésica, implante, poste/anclaje y brackets. Separar explícitamente esos conceptos y validarlos con la clínica. Periodontograma y clasificaciones diagnósticas completas conservan su propio alcance.

## Verificación de la interfaz

`pnpm check` aprobado (16 pruebas en 8 archivos) y siete recorridos E2E Chromium aprobados, incluido cambio de opción con ID correcto, catálogo alternativo/vacío, Escape dentro del modal y capturas en 390, 768 y 1440 px. Detector Impeccable sin hallazgos en los dos componentes modificados. No se ejecutó PostgreSQL ni se implementó una nueva biblioteca clínica.
