-- ============================================
--   CREACIÓN DE BASE DE DATOS PIZZERÍA MEJORADA
--   Proyecto Final - Sistema completo de pedidos
-- ============================================
DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria;
USE pizzeria;

-- ============================================
--   TABLA: usuarios
-- ============================================
CREATE TABLE usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('CLIENTE','ADMIN') DEFAULT 'CLIENTE',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
--   TABLA: direcciones (Para delivery)
-- ============================================
CREATE TABLE direcciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    calle VARCHAR(200) NOT NULL,
    numero VARCHAR(20),
    distrito VARCHAR(100) NOT NULL,
    referencia VARCHAR(255),
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================
--   TABLA: categorias
-- ============================================
CREATE TABLE categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    orden INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
--   TABLA: productos (Pizzas, bebidas, etc.)
-- ============================================
CREATE TABLE productos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    imagen_url VARCHAR(500),
    categoria_id BIGINT,
    disponible BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- ============================================
--   TABLA: tamaños (Para pizzas)
-- ============================================
CREATE TABLE tamanios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,  -- Personal, Mediana, Grande, Familiar
    descripcion VARCHAR(100),
    multiplicador_precio DECIMAL(3,2) DEFAULT 1.00  -- 0.80, 1.00, 1.50, 2.00
);

-- ============================================
--   TABLA: ingredientes (Para personalización)
-- ============================================
CREATE TABLE ingredientes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio_adicional DECIMAL(10,2) DEFAULT 0.00,
    tipo ENUM('BASE','PROTEINA','VEGETAL','QUESO','EXTRA') NOT NULL,
    disponible BOOLEAN DEFAULT TRUE
);

-- ============================================
--   TABLA: producto_tamanio (Relación N:N)
-- ============================================
CREATE TABLE producto_tamanio (
    producto_id BIGINT NOT NULL,
    tamanio_id BIGINT NOT NULL,
    precio_ajustado DECIMAL(10,2),
    PRIMARY KEY (producto_id, tamanio_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (tamanio_id) REFERENCES tamanios(id) ON DELETE CASCADE
);

-- ============================================
--   TABLA: pedidos
-- ============================================
CREATE TABLE pedidos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    direccion_id BIGINT,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0.00,
    costo_delivery DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    tipo_entrega ENUM('DELIVERY','RECOJO') DEFAULT 'DELIVERY',
    metodo_pago ENUM('EFECTIVO','TARJETA','YAPE','PLIN') DEFAULT 'EFECTIVO',
    estado ENUM('PENDIENTE','EN_PREPARACION','EN_CAMINO','ENTREGADO','CANCELADO') DEFAULT 'PENDIENTE',
    observaciones TEXT,
    fecha_entrega_estimada DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

-- ============================================
--   TABLA: pedido_detalle
-- ============================================
CREATE TABLE pedido_detalle (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    pedido_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    tamanio_id BIGINT,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(255),  -- "Sin cebolla", "Extra queso", etc.
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (tamanio_id) REFERENCES tamanios(id)
);

-- ============================================
--   TABLA: detalle_ingredientes (Extras/Quitar)
-- ============================================
CREATE TABLE detalle_ingredientes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    pedido_detalle_id BIGINT NOT NULL,
    ingrediente_id BIGINT NOT NULL,
    accion ENUM('AGREGAR','QUITAR') NOT NULL,
    precio_adicional DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (pedido_detalle_id) REFERENCES pedido_detalle(id) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id)
);

-- ============================================
--   TABLA: promociones
-- ============================================
CREATE TABLE promociones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    codigo VARCHAR(50) UNIQUE,
    tipo_descuento ENUM('PORCENTAJE','MONTO_FIJO') NOT NULL,
    valor_descuento DECIMAL(10,2) NOT NULL,
    monto_minimo DECIMAL(10,2) DEFAULT 0.00,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    usos_maximos INT,
    usos_actuales INT DEFAULT 0
);

-- ============================================
--   TABLA: pedido_promocion (Cupones usados)
-- ============================================
CREATE TABLE pedido_promocion (
    pedido_id BIGINT NOT NULL,
    promocion_id BIGINT NOT NULL,
    descuento_aplicado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pedido_id, promocion_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (promocion_id) REFERENCES promociones(id)
);

-- ============================================
--   INSERTS: categorias
-- ============================================
INSERT INTO categorias (nombre, descripcion, orden, activo) VALUES
('Pizzas Clásicas', 'Nuestras pizzas tradicionales más vendidas', 1, TRUE),
('Pizzas Especiales', 'Combinaciones únicas y gourmet', 2, TRUE),
('Bebidas', 'Refrescos y jugos', 3, TRUE),
('Postres', 'Dulces tentaciones', 4, TRUE),
('Entradas', 'Para comenzar tu pedido', 5, TRUE),
('Combos', 'Ofertas especiales', 6, TRUE);

-- ============================================
--   INSERTS: tamaños
-- ============================================
INSERT INTO tamanios (nombre, descripcion, multiplicador_precio) VALUES
('Personal', '6 porciones - 25cm', 0.70),
('Mediana', '8 porciones - 30cm', 1.00),
('Grande', '10 porciones - 35cm', 1.40),
('Familiar', '12 porciones - 40cm', 1.80);

-- ============================================
--   INSERTS: ingredientes
-- ============================================
INSERT INTO ingredientes (nombre, precio_adicional, tipo, disponible) VALUES
-- Bases
('Salsa de tomate clásica', 0.00, 'BASE', TRUE),
('Salsa BBQ', 2.00, 'BASE', TRUE),
('Salsa Alfredo', 3.00, 'BASE', TRUE),

-- Proteínas
('Pepperoni', 5.00, 'PROTEINA', TRUE),
('Jamón', 4.00, 'PROTEINA', TRUE),
('Pollo', 5.00, 'PROTEINA', TRUE),
('Chorizo', 5.00, 'PROTEINA', TRUE),
('Tocino', 6.00, 'PROTEINA', TRUE),

-- Vegetales
('Champiñones', 2.00, 'VEGETAL', TRUE),
('Pimiento', 2.00, 'VEGETAL', TRUE),
('Cebolla', 1.50, 'VEGETAL', TRUE),
('Aceituna', 2.50, 'VEGETAL', TRUE),
('Tomate', 2.00, 'VEGETAL', TRUE),
('Piña', 2.50, 'VEGETAL', TRUE),

-- Quesos
('Mozzarella extra', 4.00, 'QUESO', TRUE),
('Queso cheddar', 4.50, 'QUESO', TRUE),
('Queso parmesano', 5.00, 'QUESO', TRUE),

-- Extras
('Orégano', 0.50, 'EXTRA', TRUE),
('Ají', 0.50, 'EXTRA', TRUE);

-- ============================================
--   INSERTS: productos (PIZZAS)
-- ============================================
INSERT INTO productos (nombre, descripcion, precio, imagen_url, categoria_id, disponible, destacado) VALUES
-- Pizzas Clásicas
('Pizza Margarita', 'Salsa de tomate, mozzarella fresca, albahaca y aceite de oliva', 25.00, 'margarita.jpg', 1, TRUE, TRUE),
('Pizza Pepperoni', 'Generosas rodajas de pepperoni sobre mozzarella derretida', 30.00, 'pepperoni.jpg', 1, TRUE, TRUE),
('Pizza Hawaiana', 'Jamón dulce y piña tropical con mozzarella', 28.00, 'hawaiana.jpg', 1, TRUE, FALSE),
('Pizza 4 Quesos', 'Mozzarella, cheddar, parmesano y queso azul', 35.00, '4quesos.jpg', 1, TRUE, TRUE),

-- Pizzas Especiales
('Pizza Suprema', 'Pepperoni, jamón, champiñones, pimiento y aceituna', 38.00, 'suprema.jpg', 2, TRUE, TRUE),
('Pizza BBQ Chicken', 'Pollo a la BBQ, cebolla morada, tocino y queso cheddar', 36.00, 'bbq.jpg', 2, TRUE, FALSE),
('Pizza Vegetariana', 'Champiñones, pimiento, cebolla, tomate y aceituna', 32.00, 'vegetariana.jpg', 2, TRUE, FALSE),
('Pizza Meat Lovers', 'Pepperoni, jamón, chorizo, tocino y carne molida', 42.00, 'meatlover.jpg', 2, TRUE, TRUE),

-- Bebidas
('Coca Cola 1.5L', 'Refresco sabor cola', 8.00, 'coca.jpg', 3, TRUE, FALSE),
('Inca Kola 1.5L', 'La bebida del Perú', 8.00, 'inca.jpg', 3, TRUE, FALSE),
('Agua Mineral 500ml', 'Agua sin gas', 3.00, 'agua.jpg', 3, TRUE, FALSE),
('Chicha Morada 1L', 'Bebida tradicional peruana', 7.00, 'chicha.jpg', 3, TRUE, FALSE),

-- Postres
('Tiramisú', 'Postre italiano con café y mascarpone', 12.00, 'tiramisu.jpg', 4, TRUE, FALSE),
('Cheesecake', 'Tarta de queso con frutos rojos', 14.00, 'cheesecake.jpg', 4, TRUE, TRUE),
('Helado de Vainilla', 'Bola de helado artesanal', 8.00, 'helado.jpg', 4, TRUE, FALSE),

-- Entradas
('Alitas BBQ (8 unid.)', 'Alitas de pollo bañadas en salsa BBQ', 18.00, 'alitas.jpg', 5, TRUE, TRUE),
('Pan al Ajo (6 unid.)', 'Pan crujiente con mantequilla de ajo', 10.00, 'panajo.jpg', 5, TRUE, FALSE),
('Tequeños (10 unid.)', 'Dedos de queso envueltos en masa', 15.00, 'teque.jpg', 5, TRUE, FALSE);

-- ============================================
--   INSERTS: producto_tamanio (Precios por tamaño)
-- ============================================
-- Pizza Margarita
INSERT INTO producto_tamanio (producto_id, tamanio_id, precio_ajustado) VALUES
(1, 1, 18.00),   -- Personal
(1, 2, 25.00),   -- Mediana
(1, 3, 35.00),   -- Grande
(1, 4, 45.00);   -- Familiar

-- Pizza Pepperoni
INSERT INTO producto_tamanio (producto_id, tamanio_id, precio_ajustado) VALUES
(2, 1, 21.00),
(2, 2, 30.00),
(2, 3, 42.00),
(2, 4, 54.00);

-- Pizza Hawaiana
INSERT INTO producto_tamanio (producto_id, tamanio_id, precio_ajustado) VALUES
(3, 1, 20.00),
(3, 2, 28.00),
(3, 3, 39.00),
(3, 4, 50.00);

-- (Continúa para todas las pizzas...)

-- ============================================
--   INSERTS: usuarios
-- ============================================
INSERT INTO usuarios (nombre, apellido, email, password, telefono, rol) VALUES
-- Clientes (password: 123456 - debe encriptarse con BCrypt)
('Juan', 'Pérez', 'juan.perez@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '987654321', 'CLIENTE'),
('María', 'López', 'maria.lopez@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '912345678', 'CLIENTE'),
('Carlos', 'García', 'carlos.garcia@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '965432187', 'CLIENTE'),

-- Administradores (password: admin123)
('Admin', 'General', 'admin@pizzeria.com', '$2a$10$8cjz47bjbR4Mn8GMg9IZx.vyjhLXR/SKKMSZ9.mP9vpMu0ssKi8GW', '999888777', 'ADMIN'),
('Sofía', 'Torres', 'sofia.admin@pizzeria.com', '$2a$10$8cjz47bjbR4Mn8GMg9IZx.vyjhLXR/SKKMSZ9.mP9vpMu0ssKi8GW', '988777666', 'ADMIN');

-- ============================================
--   INSERTS: direcciones
-- ============================================
INSERT INTO direcciones (usuario_id, calle, numero, distrito, referencia, es_principal) VALUES
(1, 'Av. Los Pinos', '123', 'San Isidro', 'Cerca al parque Kennedy', TRUE),
(1, 'Jr. Las Flores', '456', 'Miraflores', 'Frente a la iglesia', FALSE),
(2, 'Calle Los Olivos', '789', 'Surco', 'Casa azul con portón negro', TRUE),
(3, 'Av. Universitaria', '321', 'Los Olivos', 'Al costado del mercado', TRUE);

-- ============================================
--   INSERTS: promociones
-- ============================================
INSERT INTO promociones (nombre, descripcion, codigo, tipo_descuento, valor_descuento, monto_minimo, fecha_inicio, fecha_fin, activo, usos_maximos) VALUES
('Descuento Bienvenida', 'Primera compra con 20% de descuento', 'WELCOME20', 'PORCENTAJE', 20.00, 50.00, '2025-01-01', '2025-12-31', TRUE, 100),
('Promo Fin de Semana', 'S/10 de descuento en pedidos mayores a S/80', 'FINDE10', 'MONTO_FIJO', 10.00, 80.00, '2025-01-01', '2025-12-31', TRUE, NULL),
('2x1 Martes', 'Segundo producto al 50%', '2X1MARTES', 'PORCENTAJE', 50.00, 0.00, '2025-01-01', '2025-12-31', TRUE, NULL);

-- ============================================
--   INSERTS: pedidos de ejemplo
-- ============================================
INSERT INTO pedidos (usuario_id, direccion_id, fecha, subtotal, descuento, costo_delivery, total, tipo_entrega, metodo_pago, estado) VALUES
(1, 1, '2025-12-01 12:30:00', 65.00, 0.00, 5.00, 70.00, 'DELIVERY', 'EFECTIVO', 'ENTREGADO'),
(2, 3, '2025-12-02 18:45:00', 28.00, 0.00, 0.00, 28.00, 'RECOJO', 'TARJETA', 'PENDIENTE'),
(3, 4, '2025-12-03 14:20:00', 82.00, 10.00, 5.00, 77.00, 'DELIVERY', 'YAPE', 'EN_CAMINO');

-- ============================================
--   INSERTS: pedido_detalle
-- ============================================
-- Pedido 1: Pizza Margarita Grande + Coca Cola
INSERT INTO pedido_detalle (pedido_id, producto_id, tamanio_id, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 3, 1, 35.00, 35.00),  -- Pizza Margarita Grande
(1, 9, NULL, 2, 8.00, 16.00),  -- 2 Coca Colas
(1, 15, NULL, 1, 14.00, 14.00);  -- Cheesecake

-- Pedido 2: Pizza Hawaiana Mediana
INSERT INTO pedido_detalle (pedido_id, producto_id, tamanio_id, cantidad, precio_unitario, subtotal) VALUES
(2, 3, 2, 1, 28.00, 28.00);

-- Pedido 3: Pizza Suprema Familiar + Alitas
INSERT INTO pedido_detalle (pedido_id, producto_id, tamanio_id, cantidad, precio_unitario, subtotal, observaciones) VALUES
(3, 5, 4, 1, 64.00, 64.00, 'Sin cebolla'),
(3, 17, NULL, 1, 18.00, 18.00, 'Extra picante');