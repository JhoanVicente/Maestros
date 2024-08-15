USE movilSur;

-- TABLAS USERS
INSERT INTO users (first_name, last_name, type_document, number_document, email, phone, id_user)
VALUES ('Juan', 'Perez', 'DNI', '12345678', 'juanperez@gmail.com', '987654321', 3),
       ('Maria', 'Gomez', 'CNE', '87654321', 'mariagomez@hotmail.com', '912345678', 3),
       ('Luis', 'Diaz', 'DNI', '56789123', 'luisdiaz@outlook.com', '933456789', 2),
       ('Ana', 'Martinez', 'DNI', '34567891', 'anamartinez@gmail.com', '922345678', 3),
       ('Pedro', 'Chavez', 'DNI', '98765432', 'pedrochavez@hotmail.com', '945678912', 2),
       ('Sofia', 'Lopez', 'CNE', '65432178', 'sofialopez@gmail.com', '910123456', 2),
       ('Diego', 'Rojas', 'DNI', '45678912', 'diegorojas@hotmail.com', '977654321', 2),
       ('Fernanda', 'Sanchez', 'DNI', '23456789', 'fernanda.sanchez@gmail.com', '923456789', 2),
       ('Pablo', 'Ramirez', 'CNE', '78912345', 'pabloramirez@hotmail.com', '932156789', 2),
       ('Valeria', 'Torres', 'DNI', '56789123', 'valeriatorres@gmail.com', '911234567', 3);

-- Conductores
-- Establecer el formato de fecha
SET DATEFORMAT dmy;

INSERT INTO drivers (driving_license, date_of_birth, user_id, license_expiration, license_status)
VALUES ( 'ABC123', '15/05/1992', 3, '15/05/2025', 'A'), -- Datos para el usuario Luis Diaz
       ('DEF456', '20/08/1997', 5, '20/08/2024', 'A'), -- Datos para el usuario Pedro Chavez
       ('GHI789', '10/12/1986', 6, '10/12/2023', 'A'), -- Datos para el usuario Sofia Lopez
       ('JKL012', '25/03/1993', 7, '25/03/2024', 'A'), -- Datos para el usuario Diego Rojas
       ('MNO345', '05/09/1988', 8, '05/09/2025', 'A'), -- Datos para el usuario Fernanda Sanchez
       ('PQR678', '30/06/1991', 9, '30/06/2023', 'A'); -- Datos para el usuario Pablo Ramirez


select *
from drivers;
-- TABLA VEHICULOS
INSERT INTO vehicles (vehicle_id, model, passenger_capacity, license_plate, acquisition_date, vehicle_image, driver_id,
                      status)
VALUES (1, 'Toyota Camry', 5, 'ABC123', '2023-01-01', NULL, 1, 1),
       (2, 'Honda asdadsa Civic', 4, 'XYZ456', '2023-02-01', NULL, 2, 1),
       (3, 'Toyota asdasdaCamry', 5, 'ABC123', '2023-01-01', NULL, 1, 1),
       (4, 'Hondasdasda Civic', 4, 'XYZ456', '2023-02-01', NULL, 2, 1),
       (5, 'Toyotasdasda Camry', 5, 'ABC123', '2023-01-01', NULL, 1, 1),
       (6, 'Honasdda Civic', 4, 'XYZ456', '2023-02-01', NULL, 2, 1);

INSERT INTO usuario (user_name, user_password, user_state, user_rol)
VALUES ('isael', '123', 'A', 1),
       ('fatama', '1234', 'A', 2),
       ('fatama2', '1234', 'A', 1),
       ('isael1', '123', 'I', 3);

INSERT INTO usuario (user_name, user_password, user_state, user_rol)
VALUES ('Isael Javier', '123', 'A', 3);
INSERT INTO user_rol (rol_name, rol_state)
VALUES ('Administrador', 'A'),
       ('Conductor', 'A'),
       ('Cliente', 'A');

UPDATE user_rol
SET rol_name = 'Cliente'
WHERE id_rol = 3;
SELECT *
FROM users;
SELECT *
FROM drivers;
SELECT *
FROM vehicles;


-- PRUEBAS
SELECT u.id_user, r.rol_name
FROM usuario u
         INNER JOIN user_rol r ON r.id_rol = u.user_rol
WHERE u.user_state = 'A'
  AND u.user_name = 'isael'
  AND u.user_password = '123';

DELETE
FROM usuario
WHERE id_user = 3;
SELECT *
FROM usuario;
select *
from user_rol;
SELECT *
FROM users
WHERE id_user = 2;

EXEC sp_helptext 'CK__user_rol__rol_na__37A5467C';
SELECT *
FROM usuario;

-- TRIGGER

CREATE TRIGGER trg_update_license_status
    ON drivers
    AFTER INSERT, UPDATE
    AS
BEGIN
    UPDATE drivers
    SET license_status = CASE
                             WHEN license_expiration < GETDATE() THEN 'V'
                             ELSE 'A'
        END
    WHERE driver_id IN (SELECT driver_id FROM inserted);
END;

-- Forzar la actualización del estado de todas las licencias existentes
    UPDATE drivers
    SET license_status = CASE
                             WHEN license_expiration < GETDATE() THEN 'V'
                             ELSE 'A'
        END;


-- Actualizar el estado de las licencias vencidas
    UPDATE drivers
    SET license_status = 'V'
    WHERE license_expiration < GETDATE();


    -- query que me traiga todos los datos de un conductor
    -- CON ID
    SELECT u.first_name,
           u.last_name,
           u.type_document,
           u.number_document,
           u.email,
           u.phone,
           d.driving_license,
           d.date_of_birth,
           d.license_expiration,
           CASE
               WHEN d.license_status = 'A' THEN 'Activo'
               WHEN d.license_status = 'V' THEN 'Vencida'
               END AS license_status
    FROM users u
             INNER JOIN
         drivers d ON u.user_id = d.user_id
    WHERE d.driver_id = 4;

-- GENERAL

    SELECT u.first_name,
           u.last_name,
           CASE
               WHEN u.type_document = 'DNI' THEN 'Documento Nacional de Identidad'
               WHEN u.type_document = 'CNE' THEN 'Carnét de Extranjería'
               END AS type_document,
           u.number_document,
           u.email,
           u.phone,
           d.driving_license,
           d.date_of_birth,
           d.license_expiration,
           CASE
               WHEN d.license_status = 'A' THEN 'Activo'
               WHEN d.license_status = 'V' THEN 'Vencida'
               END AS license_status
    FROM users u
             INNER JOIN
         drivers d ON u.user_id = d.user_id;


    SELECT
        d.driver_id,
        u.first_name,
        u.last_name,
        CASE
            WHEN u.type_document = 'DNI' THEN 'Documento Nacional de Identidad'
            WHEN u.type_document = 'CNE' THEN 'Carnét de Extranjería'
            END AS type_document,
        u.number_document,
        u.email,
        u.phone,
        d.driving_license,
        d.date_of_birth,
        d.license_expiration,
        CASE
            WHEN d.license_status = 'A' THEN 'Activo'
            WHEN d.license_status = 'V' THEN 'Vencida'
            END AS license_status
    FROM
        users u
            INNER JOIN
        drivers d ON u.user_id = d.user_id
WHERE u.status = '1';



SELECT * FROM users;

    ALTER TABLE users MODIFY COLUMN status CHAR(1) DEFAULT 'A' CHECK (status IN ('A', 'I'));