-- Active: 1776941730634@@127.0.0.1@5436@course_db
    --- M***SHAKES ---

-- 1.- CATÁLOGO M***SHAKES --

CREATE TABLE drops(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- Identificador único de cada lanzamiento. Se autogenera solo.
    nombre VARCHAR(65) NOT NULL, -- El nombre comercial de la colección (ej. 'Summer Drop 26').
    fecha_lanzamiento TIMESTAMP NOT NULL, -- Fecha y hora exacta en la que los productos se vuelven visibles y se pueden comprar en la web.
    estado VARCHAR(20) DEFAULT 'proximamente' CHECK (estado IN('proximamente', 'activo', 'finalizado')) -- Estado actual del drop. Solo permite tres valores: proximamente: El drop está anunciado pero oculto/no comprable.||activo: El drop está abierto y los usuarios están comprando.||finalizado: Colección sold-out o retirada (ya no se vende).
);

CREATE TABLE categorias(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- Identificador único de la categoría.
    nombre VARCHAR(50) NOT NULL UNIQUE -- Nombre de la categoría (ej. 'Sudaderas', 'Pantalones'). Es único para que no existan duplicados.
);

CREATE TABLE productos(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- Identificador único del producto.
    id_categoria INT NOT NULL, -- Apoya la relación con la tabla categorias. Indica a qué sección pertenece la prenda.
    id_drop INT NOT NULL, -- Apoya la relación con la tabla drops. Indica en qué colección masiva se lanzó este producto.
    nombre VARCHAR(100) NOT NULL, -- Aumentado para nombres largos
    descripcion TEXT, -- Explicación detallada del producto (materiales, tipo de corte, etc.).
    FOREIGN KEY (id_categoria) REFERENCES categorias(id), -- Apunta a 'id'
    FOREIGN KEY (id_drop) REFERENCES drops(id)
);

CREATE TABLE variantes(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- Identificador de la variante física.
    id_producto INT NOT NULL,
    sku VARCHAR(50) NOT NULL, -- Código interno de almacén para identificar rápido la prenda (ej. 'SUD-CR-M' -> Sudadera Crema M).
    talla VARCHAR(10) NOT NULL, -- Talla de la prenda (S, M, L, XL, Única).
    color VARCHAR(30) NOT NULL, -- Color de la variante.
    precio_actual DECIMAL(10,2) NOT NULL CHECK (precio_actual > 0), -- Precio de venta hoy. Tiene que ser mayor que 0.
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0), -- Cantidad de unidades físicas disponibles en el almacén. No puede ser negativo.
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE -- Enlaza la variante con su producto padre. Si se borra el producto, sus variantes se eliminan solas (ON DELETE CASCADE).
);

-- 2.- Clientes y Logística --

CREATE TABLE clientes (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL, -- Nombre completo del usuario.
    email VARCHAR(150) UNIQUE NOT NULL, -- Correo electrónico del usuario (se usa para iniciar sesión, por eso es único).
    password VARCHAR(255) NOT NULL, -- Contraseña encriptada para proteger la cuenta.
    fecha_registro DATE DEFAULT CURRENT_DATE -- Día exacto en el que el usuario creó la cuenta.
);

CREATE TABLE direcciones (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_cliente INT NOT NULL,
    calle VARCHAR(125) NOT NULL,
    ciudad VARCHAR(80) NOT NULL, -- Aumentado
    codigo_postal VARCHAR(10) NOT NULL,
    es_predeterminada BOOLEAN DEFAULT FALSE, -- Indica si es la dirección de envío favorita del cliente para marcarla automáticamente al comprar.
    FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE -- Enlaza la dirección con su dueño. Si el cliente borra su cuenta, sus direcciones se eliminan con él (ON DELETE CASCADE).
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_cliente INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Momento exacto en el que se procesó el carrito.
    estado VARCHAR(30) DEFAULT 'pendiente', -- Estado logístico del pedido (pendiente, en preparacion, enviado, entregado, cancelado).
    total DECIMAL(12,2) NOT NULL DEFAULT 0, -- El importe final que paga el cliente sumando todos sus artículos.
    direccion_envio_fijada TEXT NOT NULL, -- Muy importante. Es una "foto" en texto de la dirección de envío en el momento de la compra. Si el cliente cambia su dirección en el perfil el mes que viene, el histórico de este pedido no se altera.
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE lineas_pedido (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_pedido INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0), -- Cuántas unidades se lleva. Debe ser mínimo 1.
    precio_unitario_venta DECIMAL(10,2) NOT NULL, -- El precio al que se vendió la prenda en ese instante (por si en el futuro el producto sube o baja de precio).
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE, -- A qué compra pertenece esta línea. Si el pedido se elimina, sus líneas también (ON DELETE CASCADE).
    FOREIGN KEY (id_variante) REFERENCES variantes(id) -- Qué producto específico (talla y color) compró.
);

-- 3.- Operaciones y Soporte --

CREATE TABLE pagos (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_pedido INT NOT NULL,
    metodo VARCHAR(50) NOT NULL, -- Pasarela utilizada (tarjeta, paypal, bizum).
    estado_pago VARCHAR(20) DEFAULT 'completado', -- Estado de la transacción (pendiente, completado, fallido).
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Cuándo se cobró el dinero.
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE -- A qué compra corresponde este movimiento de dinero.
);

CREATE TABLE stock_movimientos (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_variante INT NOT NULL,
    tipo_movimiento VARCHAR(20) CHECK (tipo_movimiento IN ('entrada', 'venta', 'devolucion', 'ajuste')), -- Motivo del cambio. Solo permite: entrada: Entra mercancía nueva desde la fábrica.||venta: Salida automática por una compra (ideal para ligarlo al Trigger).||devolucion: Un cliente devuelve la ropa y vuelve a estar disponible.||ajuste: Pérdidas, robos o taras de ropa defectuosa.
    cantidad INT NOT NULL, -- Unidades alteradas (pueden ser negativas si es un ajuste de pérdida).
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Cuándo ocurrió la modificación.
    motivo TEXT, -- Nota aclaratoria (ej. "Prenda rota con costura defectuosa").
    FOREIGN KEY (id_variante) REFERENCES variantes(id) ON DELETE CASCADE -- Qué talla/color se está alterando.
);

CREATE TABLE tickets_soporte (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_cliente INT NOT NULL, 
    id_pedido INT,
    asunto VARCHAR(200) NOT NULL, -- Título de la queja (ej. "Mi paquete no ha llegado").
    prioridad VARCHAR(10) DEFAULT 'media' CHECK (prioridad IN ('baja', 'media', 'alta')), -- Urgencia del caso (baja, media, alta).
    estado VARCHAR(20) DEFAULT 'abierto', -- Estado de la resolución (abierto, en_espera, resuelto).
    FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE, -- Qué usuario ha abierto la queja.
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE SET NULL -- Si la queja es sobre un paquete roto o retrasado, apunta al pedido. Puede ser NULL si es una duda general de la web. Si el pedido se borra, el ticket no se borra, simplemente este campo se pone en blanco (ON DELETE SET NULL).
);