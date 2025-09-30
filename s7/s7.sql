CREATE TABLE REGION (
    id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2) NOT NULL,
    nombre_region VARCHAR2(25) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);

CREATE TABLE IDIOMA (
    id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3) NOT NULL,
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);

CREATE TABLE TITULO (
    id_titulo VARCHAR2(3) NOT NULL,
    descripcion_titulo VARCHAR2(60) NOT NULL,
    CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);

CREATE TABLE GENERO (
    id_genero VARCHAR2(3) NOT NULL,
    descripcion_genero VARCHAR2(25) NOT NULL,
    CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);

CREATE TABLE ESTADO_CIVIL (
    id_estado_civil VARCHAR2(2) NOT NULL,
    descripcion_est_civil VARCHAR2(25) NOT NULL,
    CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_estado_civil)
);

CREATE TABLE COMUNA (
    id_comuna NUMBER(5) NOT NULL,
    comuna_nombre VARCHAR2(25) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna, cod_region),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region)
        REFERENCES REGION(id_region)
);

CREATE TABLE COMPANIA (
    id_empresa NUMBER(2) NOT NULL,
    nombre_empresa VARCHAR2(25) NOT NULL,
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    renta_promedio NUMBER(10) NOT NULL,
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
    CONSTRAINT COMPANIA_UN_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region)
        REFERENCES COMUNA(id_comuna, cod_region)
);

CREATE TABLE PERSONAL (
    rut_persona NUMBER(8) NOT NULL,
    dv_persona CHAR(1) NOT NULL,
    primer_nombre VARCHAR2(25) NOT NULL,
    segundo_nombre VARCHAR2(25),
    primer_apellido VARCHAR2(25) NOT NULL,
    segundo_apellido VARCHAR2(25),
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR2(100),
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    sueldo NUMBER(10) NOT NULL, -- Corregido a NUMBER(10) para aceptar sueldos >= 450000
    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    cod_genero VARCHAR2(3) NOT NULL,
    cod_estado_civil VARCHAR2(2) NOT NULL,
    cod_empresa NUMBER(2) NOT NULL,
    encargado_rut NUMBER(8),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
    CONSTRAINT PERSONAL_FK_COMPANIA FOREIGN KEY (cod_empresa)
        REFERENCES COMPANIA(id_empresa),
    CONSTRAINT PERSONAL_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region)
        REFERENCES COMUNA(id_comuna, cod_region),
    CONSTRAINT PERSONAL_FK_ESTADO_CIVIL FOREIGN KEY (cod_estado_civil)
        REFERENCES ESTADO_CIVIL(id_estado_civil),
    CONSTRAINT PERSONAL_FK_GENERO FOREIGN KEY (cod_genero)
        REFERENCES GENERO(id_genero),
    CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (encargado_rut)
        REFERENCES PERSONAL(rut_persona)
);

CREATE TABLE TITULACION (
    cod_titulo VARCHAR2(3) NOT NULL,
    persona_rut NUMBER(8) NOT NULL,
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
    CONSTRAINT TITULACION_FK_PERSONAL FOREIGN KEY (persona_rut)
        REFERENCES PERSONAL(rut_persona),
    CONSTRAINT TITULACION_FK_TITULO FOREIGN KEY (cod_titulo)
        REFERENCES TITULO(id_titulo)
);

CREATE TABLE DOMINIO (
    id_idioma NUMBER(3) NOT NULL,
    persona_rut NUMBER(8) NOT NULL,
    nivel VARCHAR2(25) NOT NULL,
    CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
    CONSTRAINT DOMINIO_FK_IDIOMA FOREIGN KEY (id_idioma)
        REFERENCES IDIOMA(id_idioma),
    CONSTRAINT DOMINIO_FK_PERSONAL FOREIGN KEY (persona_rut)
        REFERENCES PERSONAL(rut_persona)
);


-- MODIFICACIONES DEL MODELO

ALTER TABLE PERSONAL ADD CONSTRAINT PERSONAL_UN_EMAIL UNIQUE (email);

ALTER TABLE PERSONAL ADD CONSTRAINT PERSONAL_CK_DV CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE PERSONAL ADD CONSTRAINT PERSONAL_CK_SUELDO CHECK (sueldo >= 450000);


--  POBLAMIENTO DEL MODELO

CREATE SEQUENCE SEQ_COMUNA START WITH 1101 INCREMENT BY 6;
CREATE SEQUENCE SEQ_COMPANIA START WITH 10 INCREMENT BY 5;

INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Arica', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Santiago', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Temuco', 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'SenTTy', 'Los Alamos', 3490, 897000, 0.025, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.035, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'TIC spa', 'FLORES S.A.', 4357, 857000, NULL, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757000, 0.015, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32', 509, 1857000, 0.025, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, NULL, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (SEQ_COMPANIA.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113, 11);

COMMIT;


-- RECUPERACIÓN DE DATOS

-- INFORME 1: Informe Simulación de Renta Promedio
SELECT
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección",
    renta_promedio AS "Renta Promedio",
    ROUND(renta_promedio * (1 + pct_aumento)) AS "Simulación de Renta"
FROM
    COMPANIA
ORDER BY
    "Renta Promedio" DESC,
    "Nombre Empresa" ASC;

-- INFORME 2: Nueva simulación renta promedio
SELECT
    id_empresa AS "CODIGO EMPRESA",
    nombre_empresa AS "EMPRESA",
    renta_promedio AS "PROM RENTA ACTUAL",
    pct_aumento + 0.15 AS "PCT AUMENTADO EN 15%",
    ROUND(renta_promedio * (1 + (pct_aumento + 0.15))) AS "RENTA AUMENTADA"
FROM
    COMPANIA
ORDER BY
    "PROM RENTA ACTUAL" ASC,
    "EMPRESA" DESC;
