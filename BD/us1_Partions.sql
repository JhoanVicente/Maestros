CREATE PARTITION FUNCTION PF_Reservations (DATETIME)
    AS RANGE RIGHT FOR VALUES ('2022-01-01', '2023-01-01', '2024-01-01');

ALTER DATABASE movilSur
    ADD FILEGROUP movil_2
GO

ALTER DATABASE movilSur
    ADD FILE
        (
            NAME = movil_2,
            Filename = '/opt/mssql/MovilSur.ndf',
            size = 10 MB,
            MAXSIZE = unlimited,
            FILEGROWTH = 64 MB
            ) TO FILEGROUP movil_2;


CREATE PARTITION SCHEME PS_Reservations
    AS PARTITION PF_Reservations
    TO ([PRIMARY],default,movil_2);

CREATE TABLE reservations
(
    reservationID       INT,
    reservationDateTime DATETIME,
    price               DECIMAL(10, 2),
    departureDateTime   DATETIME,
    seatCount           INT CHECK (seatCount BETWEEN 1 AND 7),
    routeID             INT,
    vehicleID           INT,
    CONSTRAINT reservations_pk PRIMARY KEY (reservationID)
)
    ON PS_Reservations
(
    reservationDateTime
);
