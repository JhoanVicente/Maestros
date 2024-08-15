USE movilSur;

CREATE SCHEMA maestras AUTHORIZATION dbo
GO

CREATE SCHEMA transaccionales AUTHORIZATION dbo
GO

CREATE SCHEMA other AUTHORIZATION dbo
GO

-- TRANSFERIR TABLAS A SCHEMAS
-- Tablas maestras
ALTER SCHEMA maestras
    TRANSFER dbo.users
GO

ALTER SCHEMA maestras
    TRANSFER dbo.drivers
GO

ALTER SCHEMA maestras
    TRANSFER dbo.vehicles
GO

ALTER SCHEMA maestras
    TRANSFER dbo.routes
GO

-- Tablas transaccionales

ALTER SCHEMA transaccionales
    TRANSFER dbo.reservation_details
GO

ALTER SCHEMA transaccionales
    TRANSFER dbo.payments
GO

ALTER SCHEMA transaccionales
    TRANSFER dbo.reservations
GO

-- Tablas normales

ALTER SCHEMA other
    TRANSFER dbo.booking_history
GO

ALTER SCHEMA other
    TRANSFER dbo.fares
GO

ALTER SCHEMA other
    TRANSFER dbo.feedback
GO

-- DATA_TYPES

CREATE TYPE price FROM DECIMAL(10, 2);
GO

-- Tabla: reservations
ALTER TABLE reservations
    ALTER COLUMN price price;
GO

-- Tabla: fares
ALTER TABLE fares
    ALTER COLUMN price price;
GO
