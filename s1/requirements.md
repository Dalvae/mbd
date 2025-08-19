# Requerimientos - Actividad Formativa Semana 1
## Asignatura: Modelamiento de Bases de Datos (PRY2204)

### Descripción General
Durante la primera semana, se realizará una **actividad formativa en parejas** llamada **"Aplicando conceptos de modelamiento inicial"**.  
El objetivo es dar el primer paso en el proceso de modelado de bases de datos, aplicando conceptos básicos asociados al modelamiento de datos, como la identificación de estructuras y el conjunto de relaciones que permiten representar la información del mundo real.

---

## Contexto de Negocio
**Empresa: Línea Aérea BT&Airways**  

- Más de 25 años de actividad en el transporte de pasajeros por los 5 continentes.  
- Crecimiento sustancial en los últimos 10 años.  
- Problemas en las plataformas IT, especialmente en el módulo de registro de venta de vuelos.  
- Actualmente: ~35.000 vuelos, con proyecciones de triplicar la cifra.  

**Objetivo de la actividad:**  
Identificar todas las entidades del negocio, con sus atributos y tipos de datos (dominio).

---

## Datos Relevantes a Modelar

### Operaciones Principales
- Transporte de pasajeros a distintos destinos.  
- Venta de pasajes (denominados "vuelos").  
- Proceso de reserva de vuelos.  

### Información de **Reserva**
- Número de reserva.  
- Fecha de reserva.  
- Fecha del viaje.  
- Estado (confirmado / nulo).  

### Información de **Empleado**
- RUT.  
- Nombre completo.  
- Dirección.  
- Sueldo base.  
- Fecha de ingreso.  
- Género (masculino, femenino u otro).  
- Teléfono móvil y teléfono de contacto.  

### Información de **Vuelo**
- Número de vuelo.  
- Fecha de despegue.  
- Fecha de llegada.  
- Hora de salida.  

### Información de **Pasajero**
- Número de pasaporte o cédula.  
- Nombre completo.  
- Fecha de nacimiento.  
- Nacionalidad.  
- Teléfono o correo electrónico de contacto.  

---

## Instrucciones de la Actividad

### Paso 1: Modelado
1. Usar **Oracle SQL Data Modeler** (descarga: [enlace oficial](https://www.oracle.com/database/sqldeveloper/technologies/sql-data-modeler/download/)).  
2. Realizar:  
   - **Modelo Entidad-Relación (MER)** en notación Barker.  
   - **Modelo en notación Bachman** o Ingeniería de la Información.  
3. Insertar en este documento Word dos capturas:  
   - MER en notación Barker.  
   - Modelo Bachman o Ingeniería de la Información.  

### Paso 2: Exportación
- Guardar el diseño como archivo **.dmd** junto con su subcarpeta de recursos.  

### Paso 3: Compresión
- Comprimir el archivo .dmd y su subcarpeta en un **ZIP o RAR**.  

### Paso 4: Subida a GitHub
- Subir el documento Word al repositorio GitHub **sin comprimir**.  
- Generar enlace del proyecto en GitHub.  

### Paso 5: Entrega
- Subir al **AVA**:  
  - Documento Word (con capturas Barker y Bachman).  
  - Enlace del repositorio GitHub.  

---

## Pauta de Evaluación

### Niveles de Logro
- **CL - Completamente Logrado (100%)**: Manejo óptimo y completo.  
- **L - Logrado (80%)**: Logro con pequeñas dificultades.  
- **ML - Medianamente Logrado (60%)**: Logro mínimo aceptable.  
- **LI - Logro Insuficiente (30%)**: Varias dificultades que impiden el logro mínimo.  
- **NL - No Logrado (0%)**: Escaso, nulo o incorrecto logro.  

### Criterios de Evaluación
1. Uso correcto de simbología en Oracle SQL Data Modeler.  
2. Representación de entidades fuertes y débiles.  
3. Representación de atributos opcionales y obligatorios.  
4. Identificación correcta de claves primarias.  
5. Definición adecuada de tipos de datos para los atributos.  

---

© Fundación Instituto Profesional Duoc UC. Reservados todos los derechos.
