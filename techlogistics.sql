-- ==========================================
-- Proyecto Integrador - TechLogistics S.A.
-- Script de creación e inserción de datos
-- ==========================================

-- 1. Crear base de datos
CREATE DATABASE IF NOT EXISTS techlogistics;
USE techlogistics;

-- 2. Tabla de Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT
);

-- 3. Tabla de Transportistas
CREATE TABLE IF NOT EXISTS Transportistas (
    transportista_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    empresa VARCHAR(100)
);

-- 4. Tabla de Productos
CREATE TABLE IF NOT EXISTS Productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

-- 5. Tabla de Pedidos
CREATE TABLE IF NOT EXISTS Pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- 6. Relación Pedidos-Productos
CREATE TABLE IF NOT EXISTS Pedido_Productos (
    pedido_id INT,
    producto_id INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- 7. Tabla de Rutas
CREATE TABLE IF NOT EXISTS Rutas (
    ruta_id INT AUTO_INCREMENT PRIMARY KEY,
    origen VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    distancia_km DECIMAL(10,2)
);

-- 8. Tabla de Estados de Envío
CREATE TABLE IF NOT EXISTS EstadosEnvio (
    estado_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    transportista_id INT NOT NULL,
    ruta_id INT NOT NULL,
    estado VARCHAR(50) NOT NULL,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitud DECIMAL(10,6) NULL,
    longitud DECIMAL(10,6) NULL,
    descripcion TEXT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (transportista_id) REFERENCES Transportistas(transportista_id),
    FOREIGN KEY (ruta_id) REFERENCES Rutas(ruta_id)
);

-- ==========================================
-- INSERTAR DATOS DE PRUEBA
-- ==========================================

-- Insertar Clientes
INSERT INTO Clientes (nombre, email, telefono, direccion) VALUES
('Ana Torres', 'ana.torres@email.com', '3001234567', 'Calle 10 #12-34'),
('Luis Gómez', 'luis.gomez@email.com', '3109876543', 'Carrera 45 #67-89');

-- Insertar Transportistas
INSERT INTO Transportistas (nombre, telefono, empresa) VALUES
('Carlos Méndez', '3015551111', 'TransExpress'),
('Marta López', '3024442222', 'Logística Rápida');

-- Insertar Productos
INSERT INTO Productos (nombre, descripcion, precio) VALUES
('Laptop Lenovo', 'Laptop 14 pulgadas, 8GB RAM', 2500000.00),
('Impresora HP', 'Impresora multifuncional', 800000.00),
('Mouse Logitech', 'Mouse inalámbrico', 120000.00);

-- Insertar Pedidos
INSERT INTO Pedidos (cliente_id, fecha_pedido, estado) VALUES
(1, '2025-09-16', 'Pendiente'),
(2, '2025-09-16', 'En Proceso');

-- Insertar relación Pedido-Productos
INSERT INTO Pedido_Productos (pedido_id, producto_id, cantidad) VALUES
(1, 1, 1),   -- Pedido 1 incluye 1 Laptop
(1, 3, 2),   -- Pedido 1 incluye 2 Mouse
(2, 2, 1);   -- Pedido 2 incluye 1 Impresora

-- Insertar Rutas
INSERT INTO Rutas (origen, destino, distancia_km) VALUES
('Bogotá', 'Medellín', 415.5),
('Cali', 'Barranquilla', 985.7);

-- Insertar Estados de Envío
INSERT INTO EstadosEnvio (pedido_id, transportista_id, ruta_id, estado) VALUES
(1, 1, 1, 'En camino'),
(2, 2, 2, 'Pendiente de despacho');

-- ==========================================
-- CONSULTAS DE VERIFICACIÓN
-- ==========================================

-- Listar clientes
SELECT * FROM Clientes;

-- Listar pedidos con clientes
SELECT p.pedido_id, c.nombre AS cliente, p.fecha_pedido, p.estado
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.cliente_id;

-- Listar productos de un pedido
SELECT pp.pedido_id, pr.nombre AS producto, pp.cantidad
FROM Pedido_Productos pp
JOIN Productos pr ON pp.producto_id = pr.producto_id
WHERE pp.pedido_id = 1;

-- Listar estados de envío
SELECT * FROM EstadosEnvio;
