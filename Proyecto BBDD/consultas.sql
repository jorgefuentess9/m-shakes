-- =============================================================================
-- SCRIPT DE CONSULTAS Y DICCIONARIO SQL - MILFSHAKES
-- =============================================================================

-- =============================================================================
-- PARTE 1: OPERATIVA BÁSICA Y REPORTES DIARIOS
-- =============================================================================

-- 1. CATÁLOGO COMPLETO
SELECT p.nombre AS Producto, c.nombre AS Categoria, d.nombre AS Drop 
-- SELECT: Indica qué columnas exactas queremos ver en el resultado final.
-- AS: Renombra temporalmente la columna (Alias) para que se lea mejor en la tabla resultante.
FROM productos p 
-- FROM: Define la tabla principal de donde sacaremos los datos (y le asigna el alias 'p').
JOIN categorias c ON p.id_categoria = c.id 
-- JOIN: Cruza la tabla 'productos' con 'categorias'.
-- ON: Es la condición del cruce. Le dice a PostgreSQL: "Une las filas donde la Clave Foránea (id_categoria) coincida con la Clave Primaria (id) de la otra tabla".
JOIN drops d ON p.id_drop = d.id;
-- Vuelve a usar JOIN para añadir una tercera tabla ('drops') a la ecuación.

-- 2. ALERTA DE STOCK BAJO (CRÍTICO ALMACÉN)
SELECT p.nombre, v.talla, v.stock 
FROM variantes v
JOIN productos p ON v.id_producto = p.id
WHERE v.stock < 5; 
-- WHERE: Filtra las filas ANTES de mostrar nada. Aquí solo deja pasar aquellas donde el valor de la columna 'stock' sea estrictamente menor que 5.

-- 3. RANKING DE VENTAS (MÁS DEMANDADOS)
SELECT p.nombre, SUM(lp.cantidad) AS total_vendido 
-- SUM(): Función de agregación. Suma todos los valores matemáticos de la columna 'cantidad'.
FROM lineas_pedido lp
JOIN variantes v ON lp.id_variante = v.id
JOIN productos p ON v.id_producto = p.id
GROUP BY p.nombre 
-- GROUP BY: Como estamos usando SUM(), necesitamos decirle a SQL cómo agrupar esa suma. Aquí le decimos "suma las cantidades, pero agrupándolas por el nombre del producto".
ORDER BY total_vendido DESC; 
-- ORDER BY: Ordena los resultados finales usando la columna calculada 'total_vendido'.
-- DESC: Orden descendente (de mayor a menor). Si no se pone nada, por defecto es ASC (ascendente).

-- 4. RECAUDACIÓN TOTAL POR DROP
SELECT d.nombre, SUM(lp.cantidad * lp.precio_unitario_venta) AS recaudacion 
-- SUM(a * b): Las funciones de agregación permiten hacer operaciones matemáticas internas. Aquí multiplicamos unidades por precio antes de sumar el total.
FROM drops d
JOIN productos p ON p.id_drop = d.id
JOIN variantes v ON v.id_producto = p.id
JOIN lineas_pedido lp ON lp.id_variante = v.id
GROUP BY d.nombre;

-- 5. TICKET MEDIO DE VENTA
SELECT AVG(total) AS ticket_medio 
-- AVG(): Función de agregación que calcula la media aritmética (Average) de todos los valores numéricos de una columna.
FROM pedidos;

-- 6. HISTORIAL DE PEDIDOS DE UN CLIENTE ESPECÍFICO
SELECT pe.id, pe.fecha, pe.total, pe.estado 
FROM pedidos pe
JOIN clientes cl ON pe.id_cliente = cl.id
WHERE cl.email = 'ibai@falsa.com'; 
-- El WHERE usa el operador '=' para buscar una coincidencia exacta de texto (String). Los textos en SQL siempre van entre comillas simples (' ').

-- 7. PRODUCTOS FUERA DE STOCK COMPLETO
SELECT p.nombre, v.talla, v.color 
FROM variantes v
JOIN productos p ON v.id_producto = p.id
WHERE v.stock = 0;

-- 8. VOLUMEN DE PEDIDOS REGISTRADOS POR DÍA
SELECT DATE(fecha) AS dia, COUNT(*) AS numero_pedidos 
-- DATE(): Función que recorta un TIMESTAMP (fecha y hora) para quedarse solo con la fecha (AAAA-MM-DD).
-- COUNT(*): Función de agregación que cuenta el número total de filas que existen en ese grupo.
FROM pedidos
GROUP BY dia
ORDER BY numero_pedidos DESC;

-- 9. DETALLE TÉCNICO DE UN PEDIDO CONCRETO (#1)
SELECT p.nombre, v.talla, lp.cantidad, lp.precio_unitario_venta
FROM lineas_pedido lp
JOIN variantes v ON lp.id_variante = v.id
JOIN productos p ON v.id_producto = p.id
WHERE lp.id_pedido = 1;

-- 10. CLIENTES VIP CON FILTRO DE GASTOS ACUMULADOS (>50€)
SELECT cl.nombre, SUM(pe.total) AS total_gastado
FROM clientes cl
JOIN pedidos pe ON cl.id = pe.id_cliente
GROUP BY cl.nombre
HAVING SUM(pe.total) > 50; 
-- HAVING: Es como un WHERE, pero se aplica DESPUÉS del GROUP BY. No puedes usar "WHERE SUM(pe.total) > 50" porque el WHERE no entiende de funciones de agregación. Para filtrar sumas, medias o conteos, SIEMPRE se usa HAVING.


-- =============================================================================
-- PARTE 2: RESOLUCIÓN DE CONSULTAS COMPLEJAS Y REQUISITOS DEL NEGOCIO, EJERCICIOS COMPLEMENTARIOS
-- =============================================================================

-- PREGUNTA 1: DIRECCIÓN HISTÓRICA DE ENVÍO INDEPENDIENTE (RGPD / FACTURACIÓN)
SELECT id AS numero_pedido, fecha, direccion_envio_fijada AS direccion_congelada_factura
FROM pedidos
WHERE id = 2;

-- PREGUNTA 2: PEDIDOS ENVIADOS A ESPAÑA FILTRADOS Y AGRUPADOS POR PROVINCIA
SELECT d.ciudad AS provincia, COUNT(p.id) AS total_pedidos
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id
JOIN direcciones d ON c.id = d.id_cliente
WHERE (d.calle LIKE '%España%' OR d.ciudad IN ('Madrid', 'Barcelona')) 
-- LIKE '%texto%': Operador de búsqueda de patrones. Busca la palabra "España" en cualquier parte de la dirección.
-- IN (...): Es un atajo para no escribir "ciudad = 'Madrid' OR ciudad = 'Barcelona'".
  AND p.fecha >= NOW() - INTERVAL '3 months' 
  -- NOW(): Función que devuelve la fecha y hora exacta del sistema en este momento.
  -- INTERVAL 'X': Resta o suma tiempo dinámicamente. Aquí calculamos los últimos 3 meses exactos.
GROUP BY d.ciudad
ORDER BY total_pedidos DESC;

-- PREGUNTA 10: INFORME DE LOGÍSTICA - UNIDADES PERDIDAS POR ROTURA/MERMA
SELECT pr.nombre, SUM(ABS(sm.cantidad)) AS unidades_perdidas 
-- ABS(): Función matemática de "Valor Absoluto". Si en la tabla el ajuste es de -2 unidades perdidas, el ABS(-2) lo convierte en 2 positivo para poder sumarlo en informes.
FROM stock_movimientos sm
JOIN variantes v ON v.id = sm.id_variante
JOIN productos pr ON pr.id = v.id_producto
WHERE sm.tipo_movimiento = 'ajuste' 
GROUP BY pr.nombre;

-- PREGUNTA 16: AUDITORÍA DE PASARELA - TODOS LOS INTENTOS DE PAGO
SELECT pa.metodo, pa.estado_pago, pa.fecha AS hora_intento
FROM pagos pa
WHERE pa.id_pedido = 2
ORDER BY pa.fecha ASC; 
-- ASC: Orden Ascendente (del más antiguo al más nuevo cronológicamente).

-- PREGUNTA 25: RANKING AVANZADO "TOP 10 VENTAS" CON EXCLUSIÓN DE CANCELADOS
SELECT pr.nombre, SUM(lp.cantidad) AS unidades_vendidas,
       RANK() OVER (ORDER BY SUM(lp.cantidad) DESC) AS ranking 
       -- RANK() OVER (...): Es una "Window Function" (Función de ventana). 
       -- En lugar de agrupar, evalúa todas las filas resultantes y les asigna un número de ranking (1, 2, 3...) ordenándolas internamente por la suma de cantidades.
FROM lineas_pedido lp
JOIN pedidos p ON lp.id_pedido = p.id
JOIN variantes v ON lp.id_variante = v.id
JOIN productos pr ON v.id_producto = pr.id
WHERE p.estado != 'cancelado' 
-- != (Distinto de): Excluye cualquier pedido que tenga el estado 'cancelado'.
GROUP BY pr.nombre
ORDER BY unidades_vendidas DESC
LIMIT 10; 
-- LIMIT X: Recorta el resultado final. Aunque haya 50 productos, la consola solo mostrará las 10 primeras filas.

-- PREGUNTA 26: ANÁLISIS FINANCIERO CON TABLAS TEMPORALES
WITH gastos AS ( 
-- WITH: Crea una "CTE" (Common Table Expression). Es como declarar una variable o crear una tabla temporal virtual llamada 'gastos' que solo existe mientras dura esta consulta.
    SELECT p.id_cliente,
           SUM(p.total) AS gasto_total,
           SUM(CASE WHEN p.fecha >= DATE_TRUNC('month', NOW()) THEN p.total ELSE 0 END) AS gasto_este_mes 
           -- CASE WHEN ... THEN ... ELSE ... END: Es un IF-ELSE dentro de SQL. 
           -- DATE_TRUNC('month', NOW()): Recorta la fecha actual al día 1 del mes en curso.
           -- Lógica: Si la fecha del pedido es de este mes, suma el total; si no, suma 0.
    FROM pedidos p
    WHERE p.estado != 'cancelado'
    GROUP BY p.id_cliente
)
SELECT c.nombre, c.email, g.gasto_total, g.gasto_este_mes
FROM gastos g 
-- El FROM ataca directamente a la tabla virtual 'gastos' que hemos creado arriba con el bloque WITH.
JOIN clientes c ON c.id = g.id_cliente
ORDER BY g.gasto_total DESC;

-- PREGUNTA 28: ALGORITMO DE RECOMENDACIÓN WEB (CROSS-SELLING CON SELF-JOIN)
SELECT pr1.nombre AS producto_a, pr2.nombre AS producto_b, COUNT(*) AS veces_juntos
FROM lineas_pedido lp1
JOIN lineas_pedido lp2 ON lp2.id_pedido = lp1.id_pedido AND lp2.id > lp1.id 
-- SELF-JOIN: Cruzar una tabla consigo misma dándole dos alias distintos (lp1 y lp2).
-- lp2.id_pedido = lp1.id_pedido: Busca productos que estén dentro del mismo carrito/pedido.
-- lp2.id > lp1.id: Truco matemático avanzado. Evita que compare el ID 3 consigo mismo (Sudadera con Sudadera) y evita duplicados reflejados (Sudadera+Gorra y Gorra+Sudadera).
JOIN variantes v1 ON lp1.id_variante = v1.id
JOIN variantes v2 ON lp2.id_variante = v2.id
JOIN productos pr1 ON v1.id_producto = pr1.id
JOIN productos pr2 ON v2.id_producto = pr2.id
GROUP BY pr1.nombre, pr2.nombre
ORDER BY veces_juntos DESC
LIMIT 20;