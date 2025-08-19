-- Creacion de usuario para base de datos

CREATE LOGIN kratos
WITH PASSWORD = 'acronixFaz2412';

USE nominaDB;
CREATE USER kratos FOR LOGIN kratos;

ALTER ROLE db_owner ADD MEMBER kratos;