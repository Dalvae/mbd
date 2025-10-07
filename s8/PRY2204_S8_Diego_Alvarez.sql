-- Script Semana 8 - Minimarket Doña Marta
-- Base de datos normalizada con sentencias SQL


-- Secuencias para las tablas
CREATE SEQUENCE seq_salud_id START WITH 2050 INCREMENT BY 10 NOCACHE;
CREATE SEQUENCE seq_empleado_id START WITH 750 INCREMENT BY 3 NOCACHE;

-- tablas basicas
CREATE TABLE region (
    id_region NUMBER(4) NOT NULL,
    nom_region VARCHAR2(255) NOT NULL,
    CONSTRAINT region_pk PRIMARY KEY (id_region)
);

CREATE TABLE categoria (
    id_categoria NUMBER(3) NOT NULL,
    nombre_categoria VARCHAR2(255) NOT NULL,
    CONSTRAINT categoria_pk PRIMARY KEY (id_categoria)
);

CREATE TABLE marca (
    id_marca NUMBER(3) NOT NULL,
    nombre_marca VARCHAR2(25) NOT NULL,
    CONSTRAINT marca_pk PRIMARY KEY (id_marca)
);

CREATE TABLE medio_pago (
    id_mpago NUMBER(3) NOT NULL,
    nombre_mpago VARCHAR2(50) NOT NULL,
    CONSTRAINT medio_pago_pk PRIMARY KEY (id_mpago)
);

CREATE TABLE salud (
    id_salud NUMBER(4) NOT NULL,
    nom_salud VARCHAR2(40) NOT NULL,
    CONSTRAINT salud_pk PRIMARY KEY (id_salud)
);

-- Tablas con dependencias
CREATE TABLE comuna (
    id_comuna NUMBER(4) NOT NULL,
    nom_comuna VARCHAR2(100) NOT NULL,
    cod_region NUMBER(4) NOT NULL,
    CONSTRAINT comuna_pk PRIMARY KEY (id_comuna),
    CONSTRAINT comuna_fk_region FOREIGN KEY (cod_region) REFERENCES region(id_region)
);

CREATE TABLE proveedor (
    id_proveedor NUMBER(5) NOT NULL,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rut_proveedor VARCHAR2(10) NOT NULL,
    telefono VARCHAR2(10) NOT NULL,
    email VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    cod_comuna NUMBER(4) NOT NULL,
    CONSTRAINT proveedor_pk PRIMARY KEY (id_proveedor),
    CONSTRAINT proveedor_fk_comuna FOREIGN KEY (cod_comuna) REFERENCES comuna(id_comuna)
);

-- Tabla AFP con IDENTITY
CREATE TABLE afp (
    id_afp NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 6) NOT NULL,
    nom_afp VARCHAR2(255) NOT NULL,
    CONSTRAINT afp_pk PRIMARY KEY (id_afp)
);

-- Tabla Producto
CREATE TABLE producto (
    id_producto NUMBER(4) NOT NULL,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    origen_nacional CHAR(1) NOT NULL,
    stock_minimo NUMBER(3) NOT NULL,
    activo CHAR(1) NOT NULL,
    cod_marca NUMBER(3) NOT NULL,
    cod_categoria NUMBER(3) NOT NULL,
    cod_proveedor NUMBER(5) NOT NULL,
    CONSTRAINT producto_pk PRIMARY KEY (id_producto),
    CONSTRAINT producto_fk_marca FOREIGN KEY (cod_marca) REFERENCES marca(id_marca),
    CONSTRAINT producto_fk_categoria FOREIGN KEY (cod_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT producto_fk_proveedor FOREIGN KEY (cod_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Empleado recursiva
CREATE TABLE empleado (
    id_empleado NUMBER(4) NOT NULL,
    rut_empleado VARCHAR2(10) NOT NULL,
    nombre_empleado VARCHAR2(25) NOT NULL,
    apellido_paterno VARCHAR2(25) NOT NULL,
    apellido_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER(10),
    activo CHAR(1) NOT NULL,
    tipo_empleado VARCHAR2(25) NOT NULL,
    cod_empleado NUMBER(4),
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER(5) NOT NULL,
    CONSTRAINT empleado_pk PRIMARY KEY (id_empleado),
    CONSTRAINT empleado_fk_salud FOREIGN KEY (cod_salud) REFERENCES salud(id_salud),
    CONSTRAINT empleado_fk_afp FOREIGN KEY (cod_afp) REFERENCES afp(id_afp),
    CONSTRAINT empleado_fk_jefe FOREIGN KEY (cod_empleado) REFERENCES empleado(id_empleado)
);

-- Tablas de especialización
CREATE TABLE administrativo (
    id_empleado NUMBER(4) NOT NULL,
    CONSTRAINT admin_pk PRIMARY KEY (id_empleado),
    CONSTRAINT admin_fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE vendedor (
    id_empleado NUMBER(4) NOT NULL,
    comision_venta NUMBER(5,2) NOT NULL,
    CONSTRAINT vendedor_pk PRIMARY KEY (id_empleado),
    CONSTRAINT vendedor_fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- Venta
CREATE TABLE venta (
    id_venta NUMBER(4) GENERATED ALWAYS AS IDENTITY (START WITH 5050 INCREMENT BY 3) NOT NULL,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    cod_mpago NUMBER(3) NOT NULL,
    cod_empleado NUMBER(4) NOT NULL,
    CONSTRAINT venta_pk PRIMARY KEY (id_venta),
    CONSTRAINT venta_fk_vendedor FOREIGN KEY (cod_empleado) REFERENCES vendedor(id_empleado),
    CONSTRAINT venta_fk_mpago FOREIGN KEY (cod_mpago) REFERENCES medio_pago(id_mpago)
);

-- Tabla Detalle Venta
CREATE TABLE detalle_venta (
    cod_venta NUMBER(4) NOT NULL,
    cod_producto NUMBER(4) NOT NULL,
    cantidad NUMBER(6) NOT NULL,
    CONSTRAINT detalle_venta_pk PRIMARY KEY (cod_venta, cod_producto),
    CONSTRAINT det_venta_fk_venta FOREIGN KEY (cod_venta) REFERENCES venta(id_venta),
    CONSTRAINT det_venta_fk_prod FOREIGN KEY (cod_producto) REFERENCES producto(id_producto)
);
--
ALTER TABLE empleado ADD CONSTRAINT empleado_ck_sueldo_base CHECK (sueldo_base >= 400000);
ALTER TABLE vendedor ADD CONSTRAINT vendedor_ck_comision CHECK (comision_venta BETWEEN 0 AND 0.25);
ALTER TABLE producto ADD CONSTRAINT producto_ck_stock_minimo CHECK (stock_minimo >= 3);
ALTER TABLE proveedor ADD CONSTRAINT proveedor_un_email UNIQUE (email);
ALTER TABLE marca ADD CONSTRAINT marca_un_nombre UNIQUE (nombre_marca);
ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_ck_cantidad CHECK (cantidad >= 1);

-- Poblar tablas

-- Regiones
INSERT INTO region (id_region, nom_region) VALUES (1, 'Región Metropolitana');
INSERT INTO region (id_region, nom_region) VALUES (2, 'Valparaíso');
INSERT INTO region (id_region, nom_region) VALUES (3, 'Biobío');
INSERT INTO region (id_region, nom_region) VALUES (4, 'Los Lagos');

-- Medios de pago
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

-- AFP
INSERT INTO afp (nom_afp) VALUES ('Habitat');
INSERT INTO afp (nom_afp) VALUES ('Cuprum');
INSERT INTO afp (nom_afp) VALUES ('Provida');
INSERT INTO afp (nom_afp) VALUES ('PlanVital');

-- Salud
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud_id.NEXTVAL, 'Fonasa');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud_id.NEXTVAL, 'Isapre Colmena');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud_id.NEXTVAL, 'Isapre Banmédica');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud_id.NEXTVAL, 'Isapre Cruz Blanca');

-- Comunas
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (1, 'Santiago', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (2, 'Providencia', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (3, 'Viña del Mar', 2);

-- Proveedores
INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1, 'Distribuidora Norte', '12345678-9', '222222222', 'contacto@norte.cl', 'Av. Principal 123', 1);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (2, 'Mayorista Sur', '98765432-1', '233333333', 'ventas@mayoristasur.cl', 'Calle Secundaria 456', 2);

-- Categorías
INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (1, 'Abarrotes');
INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (2, 'Lácteos');
INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (3, 'Bebidas');

-- Marcas
INSERT INTO marca (id_marca, nombre_marca) VALUES (1, 'Soprole');
INSERT INTO marca (id_marca, nombre_marca) VALUES (2, 'Costa');
INSERT INTO marca (id_marca, nombre_marca) VALUES (3, 'Coca-Cola');

-- Productos
INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (1, 'Leche Entera 1L', 1200, 'S', 10, 'S', 1, 2, 1);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (2, 'Arroz Grado 2 1Kg', 1500, 'S', 15, 'S', 2, 1, 2);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (3, 'Bebida Cola 2L', 2000, 'S', 8, 'S', 3, 3, 1);

-- Empleados
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '11111111-1', 'Marcela', 'González', 'Pérez', '15-03-2022', 950000, 80000, 'S', 'Administrativo', NULL, 2050, 210);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '22222222-2', 'José', 'Muñoz', 'Ramírez', '10-07-2021', 900000, 75000, 'S', 'Administrativo', NULL, 2060, 216);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '33333333-3', 'Verónica', 'Soto', 'Alarcón', '05-01-2020', 880000, 70000, 'S', 'Vendedor', 750, 2060, 228);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '44444444-4', 'Luis', 'Reyes', 'Fuentes', '01-04-2023', 560000, NULL, 'S', 'Vendedor', 750, 2070, 228);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '55555555-5', 'Claudia', 'Fernández', 'Lagos', '15-04-2023', 600000, NULL, 'S', 'Vendedor', 753, 2070, 216);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '66666666-6', 'Carlos', 'Navarro', 'Vega', '01-05-2023', 610000, NULL, 'S', 'Administrativo', 753, 2060, 210);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '77777777-7', 'Javiera', 'Pino', 'Rojas', '10-05-2023', 650000, NULL, 'S', 'Administrativo', 750, 2050, 210);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '88888888-8', 'Diego', 'Mella', 'Contreras', '12-05-2023', 620000, NULL, 'S', 'Vendedor', 750, 2060, 216);
INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '99999999-9', 'Fernanda', 'Salas', 'Herrera', '18-05-2023', 570000, NULL, 'S', 'Vendedor', 753, 2070, 228);

INSERT INTO empleado VALUES (seq_empleado_id.NEXTVAL, '10101010-0', 'Tomás', 'Vidal', 'Espinoza', '01-06-2023', 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222);


-- Poblar tablas de especialización
INSERT INTO administrativo (id_empleado) VALUES (750);
INSERT INTO administrativo (id_empleado) VALUES (753);
INSERT INTO administrativo (id_empleado) VALUES (765);
INSERT INTO administrativo (id_empleado) VALUES (768);

INSERT INTO vendedor (id_empleado, comision_venta) VALUES (756, 0.15);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (759, 0.10);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (762, 0.12);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (771, 0.12);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (774, 0.10);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (777, 0.10);

-- Ventas
INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('12-05-2023', 225990, 12, 771);
INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('23-10-2023', 524990, 13, 777);
INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('17-02-2023', 466990, 11, 759);

-- Detalles de venta
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5050, 1, 2);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5050, 2, 1);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5053, 3, 3);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5056, 1, 1);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5056, 2, 2);

COMMIT;

-- Consultas para los informes

-- Informe 1: Sueldo total estimado para empleados activos con bono
SELECT
    id_empleado AS "IDENTIFICADOR",
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS "SALARIO",
    bono_jefatura AS "BONIFICACION",
    sueldo_base + bono_jefatura AS "SALARIO SIMULADO"
FROM
    empleado
WHERE
    activo = 'S' AND bono_jefatura IS NOT NULL
ORDER BY
    "SALARIO SIMULADO" DESC,
    apellido_paterno DESC;

-- Informe 2: Empleados con sueldo entre $550.000 y $800.000 con aumento del 8%
SELECT
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "EMPLEADO",
    sueldo_base AS "SUELDO",
    sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base + (sueldo_base * 0.08) AS "SALARIO SIMULADO"
FROM
    empleado
WHERE
    sueldo_base BETWEEN 550000 AND 800000
ORDER BY
    "SUELDO" ASC;
