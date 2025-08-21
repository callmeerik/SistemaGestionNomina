
/*
Documento con datos de prueba para insertar en tablas
de BBDD nominaDB
*/

USE nominaDB
GO

--===========================
-- Insercion de Datos
--===========================
USE nominaDB
INSERT INTO departments (dept_name) 
VALUES
    ('Finanzas'), 
    ('Marketing'),
    ('Ventas'),
    ('Atención al Cliente'),
    ('Tecnología'),
    ('Comunicaciones'),
    ('Data Analytics'),
    ('Recursos Humanos'),
    ('Legal'),
    ('Seguridad');
GO

-- Tabla employees
USE nominaDB
INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date, correo)
VALUES
('1708913678', '1982-12-09', 'Erika', 'Rubiales', 'F', '2018-09-10', LOWER(TRANSLATE('Erika','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Rubiales','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1702384512', '1990-03-17', 'Carlos', 'Lozano', 'M', '2018-09-10', LOWER(TRANSLATE('Carlos','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Lozano','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0609674321', '1985-07-22', 'Lucia', 'Martinez', 'F', '2019-06-01', LOWER(TRANSLATE('Lucia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Martinez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601247839', '1992-11-05', 'Diego', 'Paredes', 'M', '2020-03-18', LOWER(TRANSLATE('Diego','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Paredes','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709846732', '1988-09-30', 'Sofia', 'Mendoza', 'F', '2019-11-12', LOWER(TRANSLATE('Sofia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Mendoza','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1702389671', '1979-04-15', 'Marcos', 'Gomez', 'M', '2018-09-10', LOWER(TRANSLATE('Marcos','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Gomez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602876543', '1995-05-11', 'Natalia', 'Salinas', 'F', '2021-02-25', LOWER(TRANSLATE('Natalia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Salinas','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709654871', '1986-01-26', 'Javier', 'Herrera', 'M', '2021-10-14', LOWER(TRANSLATE('Javier','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Herrera','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709328475', '1991-10-19', 'Camila', 'Rios', 'F', '2019-05-07', LOWER(TRANSLATE('Camila','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Rios','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602389472', '1983-08-03', 'Alejandro', 'Crespo', 'M', '2018-12-22', LOWER(TRANSLATE('Alejandro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Crespo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601283745', '1989-06-14', 'Valentina', 'Moreno', 'F', '2019-04-09', LOWER(TRANSLATE('Valentina','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Moreno','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709765432', '1984-02-27', 'Andr�s', 'Peralta', 'M', '2018-09-18', LOWER(TRANSLATE('Andres','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Peralta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0603847629', '1993-09-09', 'Elena', 'Navarro', 'F', '2022-01-30', LOWER(TRANSLATE('Elena','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Navarro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0608473659', '1987-12-01', 'Luis', 'Serrano', 'M', '2018-09-11', LOWER(TRANSLATE('Luis','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Serrano','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1701238746', '1996-04-20', 'Fernanda', 'Silva', 'F', '2023-06-11', LOWER(TRANSLATE('Fernanda','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Silva','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709384756', '1981-02-06', 'Manuel', 'Vera', 'M', '2018-09-18', LOWER(TRANSLATE('Manuel','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Vera','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602398476', '1990-01-13', 'Gabriela', 'Delgado', 'F', '2018-09-15', LOWER(TRANSLATE('Gabriela','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Delgado','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1704758392', '1985-10-07', 'Ivan', 'Zamora', 'M', '2018-09-23', LOWER(TRANSLATE('Ivan','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Zamora','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709348572', '1983-11-29', 'Patricia', 'Acosta', 'F', '2018-09-22', LOWER(TRANSLATE('Patricia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Acosta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602847561', '1982-07-04', 'Tomas', 'Carrillo', 'M', '2018-09-12', LOWER(TRANSLATE('Tomas','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Carrillo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1701947352', '2000-03-15', 'Ismael', 'Cedeño', 'M', '2021-01-10', LOWER(TRANSLATE('Ismael','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Cedeno','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602847932', '1991-09-28', 'Rocio', 'Espinoza', 'F', '2018-09-12', LOWER(TRANSLATE('Rocio','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Espinoza','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1703849576', '1987-06-11', 'Pedro', 'Ruiz', 'M', '2022-05-20', LOWER(TRANSLATE('Pedro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Ruiz','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0609837452', '1995-07-23', 'Maria', 'Quiñonez', 'F', '2019-03-09', LOWER(TRANSLATE('Maria','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Quinonez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1705748392', '2001-01-02', 'Kevin', 'Chavez', 'M', '2022-11-17', LOWER(TRANSLATE('Kevin','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Chavez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602948573', '1989-10-17', 'Lorena', 'Muñoz', 'F', '2018-09-28', LOWER(TRANSLATE('Lorena','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Munoz','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709483746', '2002-04-17', 'Dayana', 'Pico', 'F', '2023-02-10', LOWER(TRANSLATE('Dayana','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Pico','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0603748569', '1984-08-09', 'Mauricio', 'Villacota', 'M', '2018-12-15', LOWER(TRANSLATE('Mauricio','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Villacorta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1703829471', '1990-05-06', 'Tatiana', 'Guaman', 'F', '2018-10-13', LOWER(TRANSLATE('Tatiana','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Guamon','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601928743', '1993-12-29', 'Alvaro', 'Corozo', 'M', '2020-03-03', LOWER(TRANSLATE('Alvaro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Corozo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com');
GO


-- Insert dept_emp
use nominaDB
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES
    (1, 1, '2018-09-18', Null),
    (2, 3, '2018-09-18', Null),
    (3, 1, '2019-06-01', '2024-12-03'),
    (4, 1, '2020-03-18', Null),
    (5, 2, '2019-11-12', '2023-09-10'),
    (5, 3, '2023-09-11', Null),
    (6, 2, '2018-09-10', Null),
    (7, 4, '2021-02-23', Null),
    (8, 7, '2021-10-14', Null),
    (9, 3, '2019-07-07', Null),
    (10, 9, '2018-12-22', '2024-01-30'),
    (11, 8, '2019-04-09', '2021-12-12'),
    (12, 4, '2018-09-10', Null),
    (13, 5, '2022-01-30', Null),
    (14, 5, '2018-09-11', Null),
    (15, 9, '2023-06-17', Null),
    (16, 10, '2018-09-18', '2022-12-31'),
    (17, 9, '2018-05-15', '2025-06-30'),
    (18, 10, '2018-09-23', Null),
    (19, 9, '2018-09-22', Null),
    (20, 6, '2018-09-12', Null),
    (21, 8, '2021-01-10', Null),
    (22, 7, '2018-09-12', '2020-07-20'),
    (23, 6, '2022-05-25', Null),
    (24, 6, '2019-03-09', '2025-04-01'),
    (25, 7, '2022-11-17', Null),
    (26, 7, '2018-09-28', Null),
    (27, 3, '2023-02-10', '2025-05-30'),
    (28, 8, '2018-09-15', Null),
    (29, 1, '2018-10-15', Null),
    (30, 1, '2020-03-02', '2022-12-04'),
    (30, 3, '2022-12-05', Null);
GO

-- Insert dept_manager: igual, solo comentar correctamente
use nominaDB
INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date)
VALUES
    (1, 1, '2018-09-10', Null),
    (6, 2, '2018-09-10', Null),
    (2, 3, '2018-09-10', Null),
    (12, 4, '2018-09-10', Null),
    (14, 5, '2018-09-10', Null),
    (20, 6, '2018-09-10', Null),
    (22, 7, '2018-09-10', '2022-07-20'),
    (26, 7, '2022-07-22', Null),
    (28, 8, '2018-09-10', Null),
    (17, 9, '2023-09-12', '2025-06-30'),
    (19, 9, '2018-09-10', Null),
    (18, 10, '2018-09-10', Null);
GO

-- Tabla titles
INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES
	(1, 'Director Financiero', '2018-09-10', Null),
	(2, 'Director Ventas', '2018-09-10', Null),
	(5, 'Analista de Publicidad', '2019-11-12', '2023-09-10'),
	(5, 'Ejecutivo de Ventas', '2023-09-11', Null),
	(3, 'Auxiliar Contable', '2019-06-01', Null),
	(13, 'Desarrollador Front-End', '2022-01-30', '2024-08-22'),
	(18, 'Director de Seguridad', '2018-09-23', Null),
	(4, 'Analista Financiero', '2020-03-18', Null),
	(13, 'Desarrollador Full Stack', '2024-08-23', Null),
	(6, 'Director de Marketing', '2018-09-10', Null),
	(7, 'Supervisor de Atencion al Cliente', '2021-02-25', Null),
	(26, 'Director de Data Analytics', '2022-07-20', Null),
	(26, 'Data Scientist Sr', '2018-09-28', '2022-07-18'),
	(8, 'Data Analyst Jr', '2021-10-14', '2023-02-20'),
	(8, 'Data Analyst Ssr', '2023-02-21', '2023-12-30'),
	(8, 'Data Scientist Ssr', '2024-01-01', Null)
Go

-- Tabla salaries
INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES
  (1, 4600, '2018-09-10', Null),  
  (2, 4200, '2018-09-10', Null),  
  (5, 1650, '2019-11-12', '2023-09-10'),  
  (5, 2300, '2023-09-11', Null),  
  (3, 1350, '2019-06-01', Null),  
  (13, 2250, '2022-01-30', '2024-08-22'), 
  (13, 2700, '2024-08-23', Null), 
  (18, 4400, '2018-09-23', Null), 
  (4, 2100, '2020-03-18', Null),  
  (6, 4000, '2018-09-10', Null),  
  (7, 1900, '2021-02-25', Null),  
  (26, 4700, '2022-07-20', Null), 
  (26, 2600, '2018-09-28', '2022-07-18'), 
  (8, 1250, '2021-10-14', '2023-02-20'),  
  (8, 1550, '2023-02-21', '2023-12-30'),  
  (8, 2200, '2024-01-01', Null);  
Go

-- 1. Añadir la columna 'rol' a la tabla 'users' con un valor por defecto.
--ALTER TABLE users
--ADD rol VARCHAR(50) NOT NULL DEFAULT 'user';
--GO

-- 2. Insertar los datos en la tabla 'users'.
-- Ahora la columna 'rol' ya existe y se llenará automáticamente con 'user'.
INSERT INTO users (emp_no, usuario, clave)
SELECT
    emp_no,
    LOWER(
        LEFT(
            TRANSLATE(first_name, 'ÁÉÍÓÚáéíóúÑñ', 'AEIOUaeiouNn')
            ,1
        )
        + TRANSLATE(last_name, 'ÁÉÍÓÚáéíóúÑñ', 'AEIOUaeiouNn')
    ) AS usuario,
    'usu' + CAST(ROW_NUMBER() OVER (ORDER BY emp_no) + 1999 AS VARCHAR(64)) AS clave
FROM employees;
GO

INSERT INTO Log_AuditoriaSalarios (usuario, fecha_actualizacion, detalle_cambio, salario, emp_no)
VALUES
('admin', '2025-08-19', 'Cambio de salario de 4000 a 4600', 4600, 1),
('admin', '2025-08-19', 'Cambio de salario de 3800 a 4200', 4200, 2),
('admin', '2025-08-19', 'Ajuste de salario por desempeño', 2300, 5),
('admin', '2025-08-19', 'Incremento anual de salario', 2700, 13),
('usuario1', '2025-08-19', 'Corrección de salario previo', 1250, 8);
GO


/*
Select * from departments

Select * from employees

Select * from dept_emp
Select * from dept_manager

Select * from Log_AuditoriaSalarios
Select * from salaries
Select * from titles
Select * from users

*/
Select * from users