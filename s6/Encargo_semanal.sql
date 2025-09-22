-- Script para crear la base de datos del Consultorio Medico Santa Gema
-- Modelo clasico, sin validacion de formato de RUT en la base de datos

-- limpieza de tablas y secuencias anteriores por si ejecutamos de nuevo
DROP TABLE PAGO CASCADE CONSTRAINTS;
DROP TABLE DETALLE_RECETA CASCADE CONSTRAINTS;
DROP TABLE RECETA CASCADE CONSTRAINTS;
DROP TABLE MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE BANCO CASCADE CONSTRAINTS;
DROP TABLE DIGITADOR CASCADE CONSTRAINTS;
DROP TABLE MEDICO CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE TIPO_RECETA CASCADE CONSTRAINTS;
DROP TABLE METODO_PAGO CASCADE CONSTRAINTS;
DROP TABLE VIA_ADMINISTRACION CASCADE CONSTRAINTS;
DROP TABLE TIPO_MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;

DROP SEQUENCE comuna_seq;
DROP SEQUENCE especialidad_seq;


-- creando las secuencias para los ids autoincrementales
CREATE SEQUENCE comuna_seq START WITH 1101 INCREMENT BY 1;
CREATE SEQUENCE especialidad_seq START WITH 1 INCREMENT BY 1;


-- creando tablas base, los catalogos
CREATE TABLE REGION (
    id_region NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE CIUDAD (
    id_ciudad NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    id_region NUMBER(5) NOT NULL,
    CONSTRAINT ciudad_region_fk FOREIGN KEY (id_region) REFERENCES REGION(id_region)
);

CREATE TABLE COMUNA (
    id_comuna NUMBER(5) PRIMARY KEY, -- se llena con la secuencia comuna_seq
    nombre VARCHAR2(50) NOT NULL,
    id_ciudad NUMBER(5) NOT NULL,
    CONSTRAINT comuna_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES CIUDAD(id_ciudad)
);

CREATE TABLE ESPECIALIDAD (
    id_especialidad NUMBER(3) PRIMARY KEY, -- se llena con la secuencia especialidad_seq
    nombre_especialidad VARCHAR2(50) NOT NULL
);

CREATE TABLE TIPO_MEDICAMENTO (
    id_tipo_medicamento NUMBER(3) PRIMARY KEY,
    nombre_tipo VARCHAR2(50) NOT NULL
);

CREATE TABLE VIA_ADMINISTRACION (
    id_via_administra NUMBER(3) PRIMARY KEY,
    nombre_via VARCHAR2(50) NOT NULL
);

CREATE TABLE TIPO_RECETA (
    id_tipo_receta NUMBER(3) PRIMARY KEY,
    nombre_tipo VARCHAR2(50) NOT NULL
);

CREATE TABLE METODO_PAGO (
    id_metodo_pago NUMBER(4) PRIMARY KEY,
    nombre_metodo VARCHAR2(50) NOT NULL
);


-- creando tablas principales
CREATE TABLE PACIENTE (
    rut_pac VARCHAR2(20) PRIMARY KEY,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25),
    fecha_nacimiento DATE NOT NULL,
    telefono NUMBER(11) NOT NULL,
    calle VARCHAR2(25) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    id_comuna NUMBER(5) NOT NULL,
    CONSTRAINT paciente_comuna_fk FOREIGN KEY (id_comuna) REFERENCES COMUNA(id_comuna)
);

CREATE TABLE MEDICO (
    rut_med VARCHAR2(20) PRIMARY KEY,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25),
    id_especialidad NUMBER(3) NOT NULL,
    telefono NUMBER(11) UNIQUE NOT NULL,
    CONSTRAINT medico_especialidad_fk FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD(id_especialidad)
);

CREATE TABLE DIGITADOR (
    id_digitador NUMBER(20) PRIMARY KEY,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25)
);

CREATE TABLE DIAGNOSTICO (
    cod_diagnostico NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);

CREATE TABLE MEDICAMENTO (
    cod_medicamento NUMBER(7) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL,
    id_tipo_medicamento NUMBER(3) NOT NULL,
    id_via_administra NUMBER(3) NOT NULL,
    precio_unitario NUMBER(10,2),
    CONSTRAINT medicamento_tipo_fk FOREIGN KEY (id_tipo_medicamento) REFERENCES TIPO_MEDICAMENTO(id_tipo_medicamento),
    CONSTRAINT medicamento_via_fk FOREIGN KEY (id_via_administra) REFERENCES VIA_ADMINISTRACION(id_via_administra),
    CONSTRAINT precio_valido CHECK (precio_unitario BETWEEN 1000 AND 2000000)
);

CREATE TABLE BANCO (
    cod_banco NUMBER(2) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);


-- creando las tablas de transacciones
CREATE TABLE RECETA (
    cod_receta NUMBER(7) PRIMARY KEY,
    observaciones VARCHAR2(500),
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    id_digitador NUMBER(20) NOT NULL,
    pac_rut VARCHAR2(20) NOT NULL,
    id_diagnostico NUMBER(3) NOT NULL,
    med_rut VARCHAR2(20) NOT NULL,
    id_tipo_receta NUMBER(3) NOT NULL,
    CONSTRAINT receta_digitador_fk FOREIGN KEY (id_digitador) REFERENCES DIGITADOR(id_digitador),
    CONSTRAINT receta_paciente_fk FOREIGN KEY (pac_rut) REFERENCES PACIENTE(rut_pac),
    CONSTRAINT receta_diagnostico_fk FOREIGN KEY (id_diagnostico) REFERENCES DIAGNOSTICO(cod_diagnostico),
    CONSTRAINT receta_medico_fk FOREIGN KEY (med_rut) REFERENCES MEDICO(rut_med),
    CONSTRAINT receta_tipo_fk FOREIGN KEY (id_tipo_receta) REFERENCES TIPO_RECETA(id_tipo_receta)
);

CREATE TABLE DETALLE_RECETA (
    id_medicamento NUMBER(7),
    id_receta NUMBER(7),
    descripcion_dosis VARCHAR2(25) NOT NULL,
    cantidad NUMBER(5) NOT NULL,
    dias_tratamiento NUMBER(3) NOT NULL,
    CONSTRAINT detalle_pk PRIMARY KEY (id_medicamento, id_receta),
    CONSTRAINT detalle_medicamento_fk FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTO(cod_medicamento),
    CONSTRAINT detalle_receta_fk FOREIGN KEY (id_receta) REFERENCES RECETA(cod_receta)
);

CREATE TABLE PAGO (
    cod_boleta NUMBER(6) PRIMARY KEY,
    id_receta NUMBER(7) NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_total NUMBER(10,2) NOT NULL,
    id_metodo_pago NUMBER(4) NOT NULL,
    id_banco NUMBER(2),
    CONSTRAINT pago_receta_fk FOREIGN KEY (id_receta) REFERENCES RECETA(cod_receta),
    CONSTRAINT pago_metodo_fk FOREIGN KEY (id_metodo_pago) REFERENCES METODO_PAGO(id_metodo_pago),
    CONSTRAINT pago_banco_fk FOREIGN KEY (id_banco) REFERENCES BANCO(cod_banco)
);


-- carga de datos iniciales
INSERT INTO METODO_PAGO (id_metodo_pago, nombre_metodo) VALUES (1, 'EFECTIVO');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre_metodo) VALUES (2, 'TARJETA');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre_metodo) VALUES (3, 'TRANSFERENCIA');

INSERT INTO TIPO_RECETA (id_tipo_receta, nombre_tipo) VALUES (1, 'Digital');
INSERT INTO TIPO_RECETA (id_tipo_receta, nombre_tipo) VALUES (2, 'Magistral');
INSERT INTO TIPO_RECETA (id_tipo_receta, nombre_tipo) VALUES (3, 'Retenida');
INSERT INTO TIPO_RECETA (id_tipo_receta, nombre_tipo) VALUES (4, 'General');
INSERT INTO TIPO_RECETA (id_tipo_receta, nombre_tipo) VALUES (5, 'Veterinaria');

COMMIT;


-- para ver si las tablas se crearon bien
SELECT table_name FROM user_tables ORDER BY table_name;

-- mensaje final para confirmar que el script termino
SELECT 'script finalizado' AS "status" FROM DUAL;