-- ==========================================
-- SCRIPT DE INSPECCIÓN: MILFSHAKES STORE
-- ==========================================

-- 1. REVISAR EL CATÁLOGO (Lo que Nil Ojeda vende)
SELECT * FROM drops;
SELECT * FROM categorias;
SELECT * FROM productos;
SELECT * FROM variantes;

-- 2. REVISAR CLIENTES Y LOGÍSTICA (A quién enviamos)
SELECT * FROM clientes;
SELECT * FROM direcciones;

-- 3. REVISAR VENTAS (La chicha del negocio)
SELECT * FROM pedidos;
SELECT * FROM lineas_pedido;

-- 4. REVISAR OPERACIONES (Pagos y Stock)
SELECT * FROM pagos;
SELECT * FROM stock_movimientos;
SELECT * FROM tickets_soporte;