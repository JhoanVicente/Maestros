-- Crear la base de datos movilSur si no existe y usarla
DROP DATABASE movilSur;

IF NOT EXISTS (SELECT *
               FROM sys.databases
               WHERE name = 'movilSur')
    BEGIN
        CREATE DATABASE movilSur;
    END
GO

USE movilSur
GO

-- Tablas maestras
CREATE TABLE user_rol
(
    id_rol    INT PRIMARY KEY IDENTITY (1,1),
    rol_name  VARCHAR(50) CHECK (rol_name IN ('Administrador', 'Conductor', 'Cliente')),
    rol_state CHAR(1) DEFAULT 'A' CHECK (rol_state IN ('A', 'I'))
);
CREATE TABLE usuario
(
    id_user       INT PRIMARY KEY IDENTITY (1,1),
    user_name     VARCHAR(50) DEFAULT NULL,
    user_password VARCHAR(50) DEFAULT NULL,
    user_state    CHAR(1)     DEFAULT 'A' CHECK (user_state IN ('A', 'I')),
    user_rol      INT         DEFAULT NULL,
    FOREIGN KEY (user_rol) REFERENCES user_rol (id_rol)
);

-- Table: users
CREATE TABLE users
(
    user_id         INT IDENTITY (1,1),
    first_name      VARCHAR(70),
    last_name       VARCHAR(80),
    type_document   CHAR(3) CHECK (type_document IN ('DNI', 'CNE')),
    number_document VARCHAR(15) CHECK (LEN(number_document) BETWEEN 8 AND 15),
    email           VARCHAR(50) CHECK (email LIKE '%_@__%.__%'),
    phone           CHAR(9) CHECK (LEN(phone) = 9),
    status          BIT DEFAULT 1 CHECK (status IN (0, 1)),
    id_user         INT,
    FOREIGN KEY (id_user) REFERENCES usuario (id_user),
    CONSTRAINT users_pk PRIMARY KEY (user_id)
);


-- Table: drivers
CREATE TABLE drivers
(
    driver_id       INT IDENTITY (1,1),
    driving_license VARCHAR(20),
    date_of_birth   DATE,
    user_id         INT,
    CONSTRAINT drivers_pk PRIMARY KEY (driver_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Table: vehicles
CREATE TABLE vehicles
(
    vehicle_id         INT IDENTITY (1,1),
    model              VARCHAR(100),
    passenger_capacity INT CHECK (passenger_capacity BETWEEN 4 AND 7),
    license_plate      CHAR(6),
    acquisition_date   DATE,
    vehicle_image      VARBINARY(MAX),
    driver_id          INT,
    status             CHAR(1) DEFAULT 1 CHECK (status IN (0, 1)),

    CONSTRAINT vehicles_pk PRIMARY KEY (vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers (driver_id)
);


-- Table: routes
CREATE TABLE routes
(
    route_id    INT IDENTITY (1,1),
    origin      VARCHAR(20),
    destination VARCHAR(20),
    distance    DECIMAL(10, 2),
    duration    TIME,
    description VARCHAR(255), -- Descripción opcional de la ruta
    status      CHAR(1) DEFAULT 1 CHECK (status IN (0, 1)),
    PRIMARY KEY (route_id)
);

-- Tablas transaccionales
-- Table: reservations
CREATE TABLE reservations
(
    reservation_id       INT IDENTITY (1,1),
    reservation_datetime DATETIME,
    price                DECIMAL(10, 2),
    departure_datetime   DATETIME,
    seat_count           INT CHECK (seat_count BETWEEN 1 AND 7),
    route_id             INT,
    vehicle_id           INT,
    CONSTRAINT reservations_pk PRIMARY KEY (reservation_id),
    FOREIGN KEY (route_id) REFERENCES routes (route_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id)
);

-- Table: payments
CREATE TABLE payments
(
    payment_id       INT IDENTITY (1,1),
    payment_datetime TIMESTAMP,
    reservation_id   INT,
    method_name      VARCHAR(50) CHECK (method_name IN ('Efectivo', 'Yape')),
    payment_status   VARCHAR(20), -- Estado del pago: Pendiente, Completo, Cancelado, etc.
    CONSTRAINT payments_pk PRIMARY KEY (payment_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id)
);

-- Table: reservation_details
CREATE TABLE reservation_details
(
    detail_id            INT IDENTITY (1,1),
    reservation_id       INT,
    user_id              INT,
    reservation_datetime DATETIME,
    status               VARCHAR(20) CHECK (status IN ('Activa', 'Cancelada', 'Finalizada')), -- Estados de la reserva: Activa, Cancelada, Finalizada, etc.
    PRIMARY KEY (detail_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id)
);


-- Table: booking_history
CREATE TABLE booking_history
(
    booking_id       INT IDENTITY (1,1),
    reservation_id   INT,
    user_id          INT,
    booking_datetime DATETIME,
    status           VARCHAR(20),
    PRIMARY KEY (booking_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Table: fares
CREATE TABLE fares
(
    fare_id      INT IDENTITY (1,1),
    route_id     INT,
    vehicle_type VARCHAR(20),
    start_time   TIME,
    end_time     TIME,
    price        DECIMAL(10, 2),
    PRIMARY KEY (fare_id),
    FOREIGN KEY (route_id) REFERENCES routes (route_id)
);

-- Table: feedback
CREATE TABLE feedback
(
    feedback_id    INT IDENTITY (1,1),
    reservation_id INT,
    user_id        INT,
    comment        TEXT,
    rating         INT,
    PRIMARY KEY (feedback_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

alter table dbo.drivers
    alter column date_of_birth DATE
go

ALTER TABLE drivers
    ADD license_expiration DATE;

ALTER TABLE drivers
    ADD license_status CHAR(1) DEFAULT 'A' CHECK (license_status IN ('A', 'V'));
ALTER TABLE drivers
    ADD driver_status CHAR(1) DEFAULT 'A' CHECK (driver_status IN ('A', 'I'));