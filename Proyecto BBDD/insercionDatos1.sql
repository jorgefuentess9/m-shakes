-- 1. DROPS
INSERT INTO drops (nombre, fecha_lanzamiento, estado) VALUES 
('Milfshakes OG', '2026-01-01 10:00:00', 'finalizado'),
('Summer Drop 26', '2026-06-15 20:00:00', 'activo');

-- 2. CATEGORÍAS
INSERT INTO categorias (nombre) VALUES 
('Sudaderas'), ('Camisetas'), ('Accesorios');

-- 3. PRODUCTOS
INSERT INTO productos (id_categoria, id_drop, nombre, descripcion) VALUES 
(1, 1, 'Sudadera Classic Cream', 'La sudadera original de Milfshakes'),
(2, 2, 'Camiseta Logo Verano', 'Camiseta ligera para el calor'),
(3, 1, 'Gorra OG Black', 'Gorra con logo bordado');

-- 4. VARIANTES (Tallas y Stock)
INSERT INTO variantes (id_producto, sku, talla, color, precio_actual, stock) VALUES 
(1, 'SUD-CR-M', 'M', 'Crema', 59.99, 50),
(1, 'SUD-CR-L', 'L', 'Crema', 59.99, 0), -- Agotada para probar consultas
(2, 'CAM-VG-S', 'S', 'Blanco', 29.99, 100),
(2, 'CAM-VG-M', 'M', 'Blanco', 29.99, 85);

-- 5. CLIENTES
INSERT INTO clientes (nombre, email, password) VALUES 
('Nil Ojeda', 'nil@milfshakes.com', 'admin123'),
('User Prueba', 'cliente@gmail.com', 'pass123');

-- 6. PEDIDOS
INSERT INTO pedidos (id_cliente, fecha, estado, total, direccion_envio_fijada) VALUES 
(2, CURRENT_TIMESTAMP, 'entregado', 89.98, 'Calle Falsa 123, Madrid');

-- 7. LÍNEAS DE PEDIDO (El cliente compró una sudadera y una camiseta)
INSERT INTO lineas_pedido (id_pedido, id_variante, cantidad, precio_unitario_venta) VALUES 
(1, 1, 1, 59.99),
(1, 3, 1, 29.99);