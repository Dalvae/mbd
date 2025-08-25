### Contexto de negocio: Línea aérea BT\&Airways

---

Se te ha asignado la tarea de brindar asesoría a la aerolínea **BT\&Airways**, que lleva más de 25 años operando en el mercado de transporte de pasajeros a nivel global. En los últimos 10 años, la compañía ha experimentado un crecimiento significativo, pero ha enfrentado diversos problemas en sus plataformas de TI, especialmente en el módulo destinado al registro de la venta de vuelos. Actualmente, se manejan aproximadamente 35 mil vuelos, y se estima que este número podría triplicarse en los próximos años. Debido a esto, la empresa ha decidido recopilar toda la información relevante para implementar una base de datos de calidad óptima a largo plazo.

En esta etapa, se solicita que generes el modelo entidad-relación (MER), según las especificaciones detalladas a continuación.

---

### Reglas de negocio

---

- La compañía se dedica al transporte de pasajeros a diferentes destinos, y para llevar a los pasajeros a su destino, se deben vender pasajes de avión, que por simplicidad denominaremos vuelos. A continuación, se presenta una imagen del vuelo N°567890).

---

### Descripción del Boleto de Avión (Vista de Usuario 1)

El boleto de avión, que representa la información de un vuelo y un pasajero, contiene los siguientes datos clave:

- **Nombre del Pasajero**: Se muestra el nombre completo de la persona que viaja, en este caso, **Juan Ordoñez Barrios**. Este dato está etiquetado como "Name (Nombre Pasajero)".

- **Puntos de Vuelo**:
  - **Origen**: Se indica el lugar de partida, que en este ejemplo es **Santiago (SCL)**, etiquetado como "Desde (from)".
  - **Destino**: Se muestra el lugar de llegada, **Buenos Aires (EZE)**, etiquetado como "Hasta (To)".

- **Detalles del Vuelo**:
  - **Fecha de Salida**: La fecha programada para el despegue, "Enero 10, 2025".
  - **Hora de Salida**: La hora de partida del vuelo, "13:00".

- **Asiento Asignado**: Se especifica el número de asiento del pasajero, que es **21A**. Este dato está etiquetado como "Asiento (seat)".

- **Número de Vuelo**: Un código numérico único para identificar el vuelo, que en la imagen es **567890**. Este número aparece tanto de forma numérica como en un código de barras.

La información del boleto se presenta en dos secciones idénticas (izquierda y derecha), lo que sugiere que una parte podría ser para el registro del pasajero y la otra como comprobante para el viajero.

    > Figura 1: Ejemplo de un boleto de avión con detalles de pasajero y vuelo (vista de usuario 1)

    > Nota: La figura ilustra un boleto de avión que contiene información clave para el pasajero.

- La línea aérea dispone de una flota de **25 aviones**. Para cada avión existe una **matrícula** numérica que es única, la **marca** y el **modelo** de la aeronave, y la **capacidad** (que va desde los 200 a los 800 asientos).

- Cuando un pasajero realiza una reserva del vuelo, se debe registrar un **número de reserva**, la **fecha de la reserva**, la **fecha del viaje**, y el **estado** (que puede ser _confirmado_ o _nula_). Un pasajero puede reservar y viajar en más de una oportunidad, y cada reserva le corresponde a un único pasajero.

- En ocasiones puede ocurrir que un pasajero no confirme la reserva.

- En un vuelo como mínimo debe existir un pasajero y podrían viajar de acuerdo con la capacidad de cada avión.

- Cada vuelo está asociada a un sólo avión, pero el mismo avión puede volar muchas veces.

- Un empleado administrativo de la compañía atenderá al pasajero y, a través del sistema, le asignará un **número de vuelo**. La compañía tiene **450 empleados** de los que se registra: **RUT**, **nombre completo**, **dirección**, **sueldo base**, **fecha de ingreso** a la compañía, **género** (M, F, O), **teléfono móvil** y algún **teléfono de contacto** si es que lo posee.

- Un empleado puede ser **piloto** o **administrativo**, y conviene registrar esta característica. Para los **pilotos** se debe registrar además la **cantidad de horas de vuelos acumuladas** y la **AFP** a la que pertenece. En cambio, para los empleados **administrativos** se debe registrar la **cantidad de horas extras** y la **AFP** a la que se afiliaron.

- De cada vuelo se requiere almacenar la siguiente información: **fecha de despegue**, **fecha de llegada** al aeropuerto de destino, la **ciudad destino**, **número de vuelo**, **hora salida** del aeropuerto y la **ciudad origen**. Una reserva está siempre asociada a un único vuelo, pero el mismo lo pueden reservar muchos pasajeros.

- Para cada pasajero, se requiere almacenar los siguientes datos: **número de pasaporte o cédula de identidad**, **nombre completo**, **fecha de nacimiento**, **nacionalidad**, y un **número de teléfono de contacto** o **correo electrónico** (si es que la persona lo proporciona), y el **equipaje asociado**.

- Si un pasajero lleva equipaje, éste se debe registrar mediante un **código**, el **color** de la maleta, el **peso** y opcionalmente una **descripción**. Una maleta debe estar asociada a un único pasajero. El peso de la maleta se registra en kilogramos, por ejemplo: 25, 9 kg. Es conveniente que el equipaje quede identificado por su dueño.

- Un pasajero podría llevar varias maletas (equipaje).
