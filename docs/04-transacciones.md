# 4. Fallos, transacciones y concurrencia

Una transacción agrupa operaciones que deben confirmarse juntas. `BEGIN` inicia el bloque, `COMMIT` confirma y `ROLLBACK` revierte. Si una sentencia falla, normalmente hay que revertir la transacción antes de seguir; un `SAVEPOINT` permite recuperar una parte concreta.

Ejemplo de necesidad: si una atención requiere guardar tanto su encabezado como su detalle, no queremos confirmar solo uno de ellos. Validar un formulario ayuda, pero la transacción y las restricciones protegen los datos aunque cambie el cliente.

## Observar una reversión

En una sesión exclusiva de práctica, ejecuta paso a paso:

```sql
CREATE TEMP TABLE contador_lab (valor integer NOT NULL);
INSERT INTO contador_lab VALUES (1);
BEGIN;
UPDATE contador_lab SET valor = 2;
SELECT valor FROM contador_lab; -- Esperado dentro de la transacción: 2.
ROLLBACK;
SELECT valor FROM contador_lab; -- Esperado después: 1.
DROP TABLE contador_lab;
```

Registra ambas consultas. Este ejercicio prueba reversión en una sesión; no demuestra todavía concurrencia ni recuperación ante un corte eléctrico.

## Qué cambia con varias sesiones

PostgreSQL usa MVCC, control de concurrencia mediante versiones. Las consultas ven datos según una instantánea y el nivel de aislamiento; eso no elimina todos los bloqueos. Dos escrituras sobre la misma fila pueden esperar entre sí. En el nivel habitual `Read Committed`, una nueva sentencia puede ver cambios confirmados desde la sentencia anterior.

Práctica futura de dos sesiones: crear una tabla permanente en una base desechable, modificar una fila sin confirmar en A y consultar en B. Predecir qué ve B; después probar otra escritura sobre esa fila con un tiempo de espera limitado. Debe prepararse como laboratorio separado: las tablas temporales de este repositorio no se comparten entre sesiones.

## Persistencia y mantenimiento

WAL, registro de escritura anticipada, registra cambios antes de escribir las páginas de datos correspondientes. Es parte de la recuperación del motor, **no un respaldo independiente** frente a perder el disco. Las garantías de durabilidad también dependen de configuración y almacenamiento.

Las versiones de filas dejan trabajo de mantenimiento. Autovacuum automatiza tareas de limpieza y estadísticas; no se debe desactivar por intuición. Antes de optimizar, observa consultas y planes con datos representativos.

Fuentes: [transacciones](https://www.postgresql.org/docs/18/tutorial-transactions.html), [MVCC](https://www.postgresql.org/docs/18/mvcc-intro.html), [aislamiento](https://www.postgresql.org/docs/18/transaction-iso.html), [WAL](https://www.postgresql.org/docs/18/wal-intro.html), [vacuum](https://www.postgresql.org/docs/18/routine-vacuuming.html).
