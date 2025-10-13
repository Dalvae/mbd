-- =============================================
-- Script Final y Definitivo - PRY2204_EFT_S9_Cristaleria_Andina.sql
-- =============================================

-- FASE 1: Limpieza Completa (Tablas y Secuencias)
DROP TABLE Asignacion_Turno CASCADE CONSTRAINTS;
DROP TABLE Orden_Mantencion CASCADE CONSTRAINTS;
DROP TABLE Maquina CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Turno CASCADE CONSTRAINTS;
DROP TABLE Planta CASCADE CONSTRAINTS;
DROP TABLE Comuna CASCADE CONSTRAINTS;
DROP TABLE Region CASCADE CONSTRAINTS;
DROP TABLE Tipo_Maquina CASCADE CONSTRAINTS;
DROP TABLE Afp CASCADE CONSTRAINTS;
DROP TABLE Sistema_Salud CASCADE CONSTRAINTS;

DROP SEQUENCE Seq_Region;
DROP SEQUENCE Seq_Empleado;
DROP SEQUENCE Seq_Orden_Mantencion;
DROP SEQUENCE Seq_Asignacion_Turno;
DROP SEQUENCE Seq_Tipo_Maquina;
DROP SEQUENCE Seq_Afp;
DROP SEQUENCE Seq_Sistema_Salud;

-- FASE 2: Creación de Tablas
CREATE TABLE Region (
    id_region NUMBER NOT NULL,
    nombre_region VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (id_region),
    CONSTRAINT uk_region_nombre UNIQUE (nombre_region)
);
CREATE TABLE Comuna (
    id_comuna NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1050 INCREMENT BY 5) NOT NULL,
    nombre_comuna VARCHAR2(100) NOT NULL,
    region_id NUMBER NOT NULL,
    CONSTRAINT pk_comuna PRIMARY KEY (id_comuna),
    CONSTRAINT fk_comuna_region FOREIGN KEY (region_id) REFERENCES Region(id_region)
);
CREATE TABLE Planta (
    id_planta NUMBER NOT NULL,
    nombre_planta VARCHAR2(100) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    comuna_id NUMBER NOT NULL,
    CONSTRAINT pk_planta PRIMARY KEY (id_planta),
    CONSTRAINT fk_planta_comuna FOREIGN KEY (comuna_id) REFERENCES Comuna(id_comuna)
);
CREATE TABLE Sistema_Salud (
    id_sistema_salud NUMBER NOT NULL,
    nombre_sistema_salud VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_sistema_salud PRIMARY KEY (id_sistema_salud),
    CONSTRAINT uk_sistema_salud_nombre UNIQUE (nombre_sistema_salud)
);
CREATE TABLE Afp (
    id_afp NUMBER NOT NULL,
    nombre_afp VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_afp PRIMARY KEY (id_afp),
    CONSTRAINT uk_afp_nombre UNIQUE (nombre_afp)
);
CREATE TABLE Tipo_Maquina (
    id_tipo_maquina NUMBER NOT NULL,
    nombre_tipo_maquina VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_tipo_maquina PRIMARY KEY (id_tipo_maquina),
    CONSTRAINT uk_tipo_maquina_nombre UNIQUE (nombre_tipo_maquina)
);
CREATE TABLE Turno (
    id_turno NUMBER NOT NULL,
    nombre_turno VARCHAR2(50) NOT NULL,
    hora_inicio CHAR(5) NOT NULL,
    hora_fin CHAR(5) NOT NULL,
    CONSTRAINT pk_turno PRIMARY KEY (id_turno),
    CONSTRAINT uk_turno_nombre UNIQUE (nombre_turno),
    CONSTRAINT ck_turno_horas CHECK ((hora_inicio LIKE '__:__' AND hora_fin LIKE '__:__'))
);
CREATE TABLE Empleado (
    id_empleado NUMBER NOT NULL,
    rut VARCHAR2(12) NOT NULL,
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10,2) NOT NULL,
    estado_activo CHAR(1) DEFAULT 'S' NOT NULL,
    planta_id NUMBER NOT NULL,
    afp_id NUMBER NOT NULL,
    sistema_salud_id NUMBER NOT NULL,
    jefe_id NUMBER NULL,
    tipo_empleado VARCHAR2(20) NOT NULL,
    area_responsabilidad VARCHAR2(100) NULL,
    max_operarios NUMBER NULL,
    categoria_proceso VARCHAR2(50) NULL,
    certificacion VARCHAR2(100) NULL,
    horas_estandar_turno NUMBER DEFAULT 8 NULL,
    especialidad VARCHAR2(50) NULL,
    nivel_certificacion VARCHAR2(50) NULL,
    tiempo_respuesta_estandar NUMBER NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT fk_empleado_planta FOREIGN KEY (planta_id) REFERENCES Planta(id_planta),
    CONSTRAINT fk_empleado_afp FOREIGN KEY (afp_id) REFERENCES Afp(id_afp),
    CONSTRAINT fk_empleado_sistema_salud FOREIGN KEY (sistema_salud_id) REFERENCES Sistema_Salud(id_sistema_salud),
    CONSTRAINT fk_empleado_jefe FOREIGN KEY (jefe_id) REFERENCES Empleado(id_empleado),
    CONSTRAINT uk_empleado_rut UNIQUE (rut),
    CONSTRAINT ck_empleado_activo CHECK (estado_activo IN ('S', 'N')),
    CONSTRAINT ck_empleado_tipo CHECK (tipo_empleado IN ('JEFE_TURNO', 'OPERARIO', 'TECNICO_MANTENCION'))
);
CREATE TABLE Maquina (
    numero_maquina NUMBER NOT NULL,
    planta_id NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    estado_activo CHAR(1) DEFAULT 'S' NOT NULL,
    tipo_maquina_id NUMBER NOT NULL,
    CONSTRAINT pk_maquina PRIMARY KEY (numero_maquina, planta_id),
    CONSTRAINT fk_maquina_planta FOREIGN KEY (planta_id) REFERENCES Planta(id_planta),
    CONSTRAINT fk_maquina_tipo FOREIGN KEY (tipo_maquina_id) REFERENCES Tipo_Maquina(id_tipo_maquina),
    CONSTRAINT ck_maquina_activo CHECK (estado_activo IN ('S', 'N'))
);
CREATE TABLE Orden_Mantencion (
    id_orden NUMBER NOT NULL,
    maquina_numero NUMBER NOT NULL,
    maquina_planta_id NUMBER NOT NULL,
    tecnico_id NUMBER NOT NULL,
    fecha_programada DATE NOT NULL,
    fecha_ejecucion DATE NULL,
    descripcion VARCHAR2(500) NOT NULL,
    CONSTRAINT pk_orden_mantencion PRIMARY KEY (id_orden),
    CONSTRAINT fk_orden_maquina FOREIGN KEY (maquina_numero, maquina_planta_id) REFERENCES Maquina(numero_maquina, planta_id),
    CONSTRAINT fk_orden_tecnico FOREIGN KEY (tecnico_id) REFERENCES Empleado(id_empleado),
    CONSTRAINT ck_orden_fechas CHECK (fecha_ejecucion >= fecha_programada OR fecha_ejecucion IS NULL)
);
CREATE TABLE Asignacion_Turno (
    id_asignacion NUMBER NOT NULL,
    empleado_id NUMBER NOT NULL,
    turno_id NUMBER NOT NULL,
    maquina_numero NUMBER NOT NULL,
    maquina_planta_id NUMBER NOT NULL,
    fecha DATE NOT NULL,
    rol VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_asignacion_turno PRIMARY KEY (id_asignacion),
    CONSTRAINT fk_asignacion_empleado FOREIGN KEY (empleado_id) REFERENCES Empleado(id_empleado),
    CONSTRAINT fk_asignacion_turno FOREIGN KEY (turno_id) REFERENCES Turno(id_turno),
    CONSTRAINT fk_asignacion_maquina FOREIGN KEY (maquina_numero, maquina_planta_id) REFERENCES Maquina(numero_maquina, planta_id),
    CONSTRAINT uk_empleado_fecha UNIQUE (empleado_id, fecha)
);

-- FASE 3: Secuencias y Poblamiento
CREATE SEQUENCE Seq_Region START WITH 21 INCREMENT BY 1;
CREATE SEQUENCE Seq_Empleado START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE Seq_Orden_Mantencion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Asignacion_Turno START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Tipo_Maquina START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Afp START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Sistema_Salud START WITH 1 INCREMENT BY 1;

INSERT INTO Region (id_region, nombre_region) VALUES (21, 'Región de Valparaíso');
INSERT INTO Region (id_region, nombre_region) VALUES (22, 'Región Metropolitana');
INSERT INTO Comuna (nombre_comuna, region_id) VALUES ('Quilpué', 21);
INSERT INTO Comuna (nombre_comuna, region_id) VALUES ('Maipú', 22);
INSERT INTO Planta (id_planta, nombre_planta, direccion, comuna_id) VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);
INSERT INTO Planta (id_planta, nombre_planta, direccion, comuna_id) VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);
INSERT INTO Turno (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES (1, 'Mañana', '07:00', '15:00');
INSERT INTO Turno (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES (2, 'Noche', '23:00', '07:00');
INSERT INTO Turno (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES (3, 'Tarde', '15:00', '23:00');

COMMIT;

-- FASE 4: Consultas
-- INFORME 1
SELECT ROWNUM as "#", id_turno || ' - ' || nombre_turno as "TURNO", hora_inicio as "ENTRADA", hora_fin as "SALIDA" FROM Turno WHERE hora_inicio > '20:00' ORDER BY hora_inicio DESC;
-- INFORME 2
SELECT ROWNUM as "#", nombre_turno || ' (' || id_turno || ')' as "TURNO", hora_inicio as "ENTRADA", hora_fin as "SALIDA" FROM Turno WHERE hora_inicio BETWEEN '06:00' AND '14:59' ORDER BY hora_inicio ASC;
