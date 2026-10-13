-- =============================================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA COMPLETO Y CORREGIDO - MILFSHAKES
-- =============================================================================

-- 1. LIMPIEZA TOTAL (Para que todos los contadores de IDs vuelvan a empezar en 1)
TRUNCATE TABLE 
    lineas_pedido, pedidos, pagos, tickets_soporte, 
    stock_movimientos, variantes, productos, categorias, 
    drops, clientes, direcciones 
RESTART IDENTITY CASCADE;

-- 2. DROPS (Lanzamientos exclusivos)
INSERT INTO drops (nombre, fecha_lanzamiento, estado) VALUES 
('Milfshakes OG Collection', '2026-01-01 10:00:00', 'finalizado'), -- ID 1
('Summer Drop 26', '2026-06-15 20:00:00', 'activo'),             -- ID 2
('Winter Cyber Punk', '2026-11-15 12:00:00', 'proximamente'),      -- ID 3
('Secret Collab Nil & Misho', '2026-03-20 18:00:00', 'finalizado'),-- ID 4
('Milfshakes X Misho Collab', '2026-02-14 18:00:00', 'finalizado'),-- ID 5
('Winter Drop 26', '2026-12-01 00:00:00', 'proximamente');          -- ID 6

-- 3. CATEGORÍAS
INSERT INTO categorias (nombre) VALUES 
('Sudaderas'),  -- ID 1
('Camisetas'),  -- ID 2
('Accesorios'), -- ID 3
('Pantalones'); -- ID 4

-- 4. PRODUCTOS (Creados de forma consecutiva del ID 1 al ID 9)
INSERT INTO productos (id_categoria, id_drop, nombre, descripcion) VALUES 
(1, 1, 'Sudadera Classic Cream', 'La sudadera original de Milfshakes en color crema.'), -- ID 1
(2, 2, 'Camiseta Logo Verano', 'Camiseta ligera de algodón orgánico.'),                 -- ID 2
(3, 1, 'Gorra OG Black', 'Gorra con el logo clásico bordado.'),                        -- ID 3
(2, 2, 'Camiseta Oversize Black', 'Corte ancho premium, 240 GSM.'),                    -- ID 4
(3, 2, 'Calcetines Milfshakes Pack', 'Pack de 3 pares de calcetines altos.'),           -- ID 5
(4, 4, 'Pantalón Cargo Technical', 'Pantalón con bolsillos tácticos.'),                -- ID 6
(4, 2, 'Pantalón Cargo Beige', 'Pantalón cargo de corte recto multibolsillos.'),       -- ID 7
(1, 5, 'Sudadera Boxy Cyber', 'Sudadera de corte boxy con gráficos reflectantes.'),     -- ID 8
(3, 2, 'Llavero Milfshakes OG', 'Llavero de goma con el logo clásico.');               -- ID 9

-- 5. VARIANTES (Ahora que los productos del 1 al 9 existen sí o sí, NO dará error)
INSERT INTO variantes (id_producto, sku, talla, color, precio_actual, stock) VALUES 
(1, 'SUD-CR-M', 'M', 'Crema', 59.99, 50),     -- ID Variante 1
(1, 'SUD-CR-L', 'L', 'Crema', 59.99, 0),      -- ID Variante 2
(2, 'CAM-VG-S', 'S', 'Blanco', 29.99, 100),    -- ID Variante 3
(2, 'CAM-VG-M', 'M', 'Blanco', 29.99, 85),     -- ID Variante 4
(4, 'CAM-OV-BK-M', 'M', 'Negro', 34.99, 40),   -- ID Variante 5
(4, 'CAM-OV-BK-L', 'L', 'Negro', 34.99, 60),   -- ID Variante 6
(5, 'CAL-OG-UNI', 'Única', 'Blanco', 14.99, 200),-- ID Variante 7
(6, 'CAR-BL-M', 'M', 'Negro', 79.99, 30),      -- ID Variante 8
(6, 'CAR-BL-L', 'L', 'Negro', 79.99, 25),      -- ID Variante 9
(7, 'CAR-BE-M', 'M', 'Beige', 64.99, 45),     -- ID Variante 10
(7, 'CAR-BE-L', 'L', 'Beige', 64.99, 50),     -- ID Variante 11
(8, 'SUD-CY-L', 'L', 'Gris', 69.99, 15),      -- ID Variante 12
(8, 'SUD-CY-XL', 'XL', 'Gris', 69.99, 5),     -- ID Variante 13
(9, 'KEY-OG-UNI', 'Única', 'Negro', 9.99, 500),-- ID Variante 14
(2, 'CAM-VG-L', 'L', 'Blanco', 29.99, 40);    -- ID Variante 15

-- 6. CLIENTES (Y sus cuentas para loguearse)
INSERT INTO clientes (nombre, email, password) VALUES 
('Nil Ojeda', 'nil@milfshakes.com', 'hash_admin_secret'), -- ID 1
('Ibai Llanos', 'ibai@falsa.com', 'porcinos_secure_pass'), -- ID 2
('David Cánovas', 'thegrefg@falsa.com', 'grefg_contador_2026'), -- ID 3
('Gerard Piqué', 'gerard@falsa.com', 'kingsleague_boss'),       -- ID 4
('Misho Amoli', 'misho@falsa.com', 'misho_heavy_weights');       -- ID 5

-- 7. DIRECCIONES
INSERT INTO direcciones (id_cliente, calle, ciudad, codigo_postal, es_predeterminada) VALUES 
(1, 'Gran Vía 45, Piso 4', 'Madrid', '28013', true),
(2, 'Avenida Diagonal 99', 'Barcelona', '08001', true),
(3, 'Carrer del Serrat 12', 'Andorra la Vella', 'AD500', true),
(4, 'Avinguda Corts Catalanes 4', 'Barcelona', '08021', true),
(5, 'Paseo de la Castellana 110', 'Madrid', '28046', true);

-- 8. PEDIDOS 
INSERT INTO pedidos (id_cliente, fecha, estado, total, direccion_envio_fijada) VALUES 
(2, '2026-05-10 14:30:00', 'entregado', 89.98, 'Avenida Diagonal 99, Barcelona, CP 08001'), -- ID Pedido 1
(3, CURRENT_TIMESTAMP, 'enviado', 149.97, 'Carrer del Serrat 12, Andorra la Vella'),       -- ID Pedido 2
(5, CURRENT_TIMESTAMP, 'entregado', 69.99, 'Paseo de la Castellana 110, Madrid');          -- ID Pedido 3

-- 9. LÍNEAS DE PEDIDO (Vinculadas a las variantes creadas arriba)
INSERT INTO lineas_pedido (id_pedido, id_variante, cantidad, precio_unitario_venta) VALUES 
(1, 1, 1, 59.99),
(1, 3, 1, 29.99),
(2, 12, 2, 69.99), -- Pedido 2: 2 sudaderas grises L
(2, 14, 1, 9.99),  -- Pedido 2: 1 llavero
(3, 13, 1, 69.99); -- Pedido 3: 1 sudadera cyber XL

-- 10. PAGOS
INSERT INTO pagos (id_pedido, metodo, estado_pago) VALUES 
(1, 'tarjeta', 'completado'),
(2, 'paypal', 'completado'),
(3, 'tarjeta', 'completado');

-- 11. MOVIMIENTOS DE STOCK
INSERT INTO stock_movimientos (id_variante, tipo_movimiento, cantidad, motivo) VALUES 
(1, 'entrada', 100, 'Recepción de stock de fábrica para el lanzamiento OG'),
(14, 'entrada', 500, 'Recepción masiva de llaveros de goma desde proveedor'),
(13, 'ajuste', -1, 'Unidad de exposición en oficina dañada por uso');

-- 12. TICKETS DE SOPORTE
INSERT INTO tickets_soporte (id_cliente, id_pedido, asunto, prioridad, estado) VALUES 
(2, 1, '¿Cuándo llega el repartidor a Barcelona?', 'media', 'abierto'),
(3, 2, 'El paquete está retenido en la aduana de Andorra', 'alta', 'abierto'),
(4, NULL, '¿Vais a reponer las sudaderas Classic en talla L?', 'baja', 'resuelto');