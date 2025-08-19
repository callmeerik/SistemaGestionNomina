/*
Documento con datos de prueba para insertar en tablas
de BBDD nominaDB
*/

USE nominaDB
GO

--===========================
-- Inserci�n de Datos
--==========================?
INSERT INTO departments (dept_name) 
VALUES
	('Finanzas'), 
	('Marketing'),
	('Ventas'),
	('Atenci�n al Cliente'),
	('Tecnolog�a'),
	('Comunicaciones'),
	('Data Analytics'),
	('Recursos Humanos'),
	('Legal'),
	('Seguridad')
Go

-- Tabla employees
INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date, correo)
VALUES
('1708913678', '09/12/1982', 'Erika', 'Rubiales', 'F', '10/09/2018', LOWER(TRANSLATE('Erika','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Rubiales','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1702384512', '17/03/1990', 'Carlos', 'Lozano', 'M', '10/09/2018', LOWER(TRANSLATE('Carlos','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Lozano','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0609674321', '22/07/1985', 'Lucia', 'Martinez', 'F', '01/06/2019', LOWER(TRANSLATE('Luc�a','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Mart�nez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601247839', '05/11/1992', 'Diego', 'Paredes', 'M', '18/03/2020', LOWER(TRANSLATE('Diego','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Paredes','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709846732', '30/09/1988', 'Sofia', 'Mendoza', 'F', '12/11/2019', LOWER(TRANSLATE('Sof�a','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Mendoza','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1702389671', '15/04/1979', 'Marcos', 'Gomez', 'M', '10/09/2018', LOWER(TRANSLATE('Marcos','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('G�mez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602876543', '11/05/1995', 'Natalia', 'Salinas', 'F', '25/02/2021', LOWER(TRANSLATE('Natalia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Salinas','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709654871', '26/01/1986', 'Javier', 'Herrera', 'M', '14/10/2021', LOWER(TRANSLATE('Javier','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Herrera','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709328475', '19/10/1991', 'Camila', 'Rios', 'F', '07/05/2019', LOWER(TRANSLATE('Camila','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('R�os','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602389472', '03/08/1983', 'Alejandro', 'Crespo', 'M', '22/12/2018', LOWER(TRANSLATE('Alejandro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Crespo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601283745', '14/06/1989', 'Valentina', 'Moreno', 'F', '09/04/2019', LOWER(TRANSLATE('Valentina','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Moreno','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709765432', '27/02/1984', 'Andr�s', 'Peralta', 'M', '10/09/2018', LOWER(TRANSLATE('Andr�s','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Peralta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0603847629', '09/09/1993', 'Elena', 'Navarro', 'F', '30/01/2022', LOWER(TRANSLATE('Elena','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Navarro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0608473659', '01/12/1987', 'Luis', 'Serrano', 'M', '11/09/2018', LOWER(TRANSLATE('Luis','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Serrano','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1701238746', '20/04/1996', 'Fernanda', 'Silva', 'F', '17/06/2023', LOWER(TRANSLATE('Fernanda','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Silva','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709384756', '06/03/1981', 'Manuel', 'Vera', 'M', '18/09/2018', LOWER(TRANSLATE('Manuel','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Vera','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602398476', '13/01/1990', 'Gabriela', 'Delgado', 'F', '15/09/2018', LOWER(TRANSLATE('Gabriela','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Delgado','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1704758392', '07/10/1985', 'Ivan', 'Zamora', 'M', '23/09/2018', LOWER(TRANSLATE('Iv�n','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Zamora','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709348572', '29/11/1983', 'Patricia', 'Acosta', 'F', '22/09/2018', LOWER(TRANSLATE('Patricia','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Acosta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602847561', '04/07/1982', 'Tomas', 'Carrillo', 'M', '12/09/2018', LOWER(TRANSLATE('Tom�s','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Carrillo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1701947352', '15/03/2000', 'Ismael', 'Cedeño', 'M', '10/01/2021', LOWER(TRANSLATE('Ismael','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Cede�o','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602847932', '28/09/1991', 'Rocio', 'Espinoza', 'F', '12/09/2018', LOWER(TRANSLATE('Roc�o','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Espinoza','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1703849576', '11/06/1987', 'Pedro', 'Ruiz', 'M', '20/05/2022', LOWER(TRANSLATE('Pedro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Ruiz','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0609837452', '23/07/1995', 'Maria', 'Quiñonez', 'F', '09/03/2019', LOWER(TRANSLATE('Mar�a','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Qui��nez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1705748392', '02/01/2001', 'Kevin', 'Chavez', 'M', '17/11/2022', LOWER(TRANSLATE('Kevin','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Ch�vez','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0602948573', '17/10/1989', 'Lorena', 'Muñoz', 'F', '28/09/2018', LOWER(TRANSLATE('Lorena','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Mu�oz','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1709483746', '19/04/2002', 'Dayana', 'Pico', 'F', '10/02/2023', LOWER(TRANSLATE('Dayana','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Pico','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0603748569', '09/08/1984', 'Mauricio', 'Villacota', 'M', '15/12/2018', LOWER(TRANSLATE('Mauricio','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Villacorta','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('1703829471', '06/05/1990', 'Tatiana', 'Guaman', 'F', '13/10/2018', LOWER(TRANSLATE('Tatiana','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Guam�n','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com'),
('0601928743', '29/12/1993', 'Alvaro', 'Corozo', 'M', '03/03/2020', LOWER(TRANSLATE('�lvaro','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '.' + LOWER(TRANSLATE('Corozo','ÁÉÍÓÚáéíóúÑñ','AEIOUaeiouNn')) + '@correo.com');
GO


-- Tabla dept_managers
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES
	(1, 1, '10/09/2018', Null),
	(2, 3, '10/09/2018', Null),
	(3, 1, '01/06/2019', '30/12/2024'),
	(4, 1, '18/03/2020', Null),
	(5, 2, '12/11/2019', '10/09/2023'),
	(5, 3, '11/09/2023', Null),
	(6, 2, '10/09/2018', Null),
	(7, 4, '25/02/2021', Null),
	(8, 7, '14/10/2021', Null),
	(9, 3, '07/05/2019', Null),
	(10, 9, '22/12/2018', '30/01/2024'),
	(11, 8, '09/04/2019', '12/12/2021'),
	(12, 4, '10/09/2018', Null),
	(13, 5, '30/01/22', Null),
	(14, 5, '11/09/2018', Null),
	(15, 9, '17/06/2023', Null),
	(16, 10, '18/09/2018', '31/12/2022'),
	(17, 9, '15/09/2018', '30/06/2025'),
	(18, 10, '23/09/2018', Null),
	(19, 9, '22/09/2018', Null),
	(20, 6, '12/09/2018', Null),
	(21, 8, '10/01/2021', Null),
	(22, 7, '12/09/2018', '20/07/2020'),
	(23, 6, '20/05/2022', Null),
	(24, 6, '09/03/2019', '01/04/2025'),
	(25, 7, '17/11/2022', Null),
	(26, 7, '28/09/2018', Null),
	(27, 3, '10/02/2023', '30/05/2025'),
	(28, 8, '15/09/2018', Null),
	(29, 1, '13/10/2018', Null),
	(30, 1, '03/03/2020', '04/12/2022'),
	(30, 3, '05/12/2022', Null)
Go	

-- Tabla dept_managers
INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date)
VALUES
	(1, 1, '10/09/2018', Null),
	(6, 2, '10/09/2018', Null),
	(2, 3, '10/09/2018', Null),
	(12, 4, '10/09/2018', Null),
	(14, 5, '11/09/2018', Null),
	(20, 6, '12/09/2018', Null),
	(22, 7, '12/09/2018', '20/07/2022'),
	(26, 7, '20/07/2022', Null),
	(28, 8, '15/09/2018', Null),
	(17, 9, '15/09/2018', '30/06/2025'),
	(19, 9, '01/07/2025', Null),
	(18, 10, '23/09/2018', Null)
Go	

-- Tabla titles
INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES
	(1, 'Director Financiero', '10/09/2018', Null),
	(2, 'Director Ventas', '10/09/2018', Null),
	(5, 'Analista de Publicidad', '12/11/2019', '10/09/2023'),
	(5, 'Ejecutivo de Ventas', '11/09/2023', Null),
	(3, 'Auxiliar Contable', '01/06/2019', Null),
	(13, 'Desarrollador Front-End', '30/01/2022', '22/08/2024'),
	(18, 'Director de Seguridad', '23/09/2018', Null),
	(4, 'Analista Financiero', '18/03/2020', Null),
	(13, 'Desarrollador Full Stack', '23/08/2024', Null),
	(6, 'Director de Marketing', '10/09/2018', Null),
	(7, 'Supervisor de Atenci�n al Cliente', '25/02/2021', Null),
	(26, 'Director de Data Analytics', '20/07/2022', Null),
	(26, 'Data Scientist Sr', '28/09/2018', '18/07/2022'),
	(8, 'Data Analyst Jr', '14/10/2021', '20/02/2023'),
	(8, 'Data Analyst Ssr', '21/02/2023', '30/12/2023'),
	(8, 'Data Scientist Ssr', '01/01/2024', Null)
Go

-- Tabla salaries
INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES
  (1, 4600, '10/09/2018', Null),  
  (2, 4200, '10/09/2018', Null),  
  (5, 1650, '12/11/2019', '10/09/2023'),  
  (5, 2300, '11/09/2023', Null),  
  (3, 1350, '01/06/2019', Null),  
  (13, 2250, '30/01/2022', '22/08/2024'), 
  (13, 2700, '23/08/2024', Null), 
  (18, 4400, '23/09/2018', Null), 
  (4, 2100, '18/03/2020', Null),  
  (6, 4000, '10/09/2018', Null),  
  (7, 1900, '25/02/2021', Null),  
  (26, 4700, '20/07/2022', Null), 
  (26, 2600, '28/09/2018', '18/07/2022'), 
  (8, 1250, '14/10/2021', '20/02/2023'),  
  (8, 1550, '21/02/2023', '30/12/2023'),  
  (8, 2200, '01/01/2024', Null);  
Go

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
    'usu' + CAST(ROW_NUMBER() OVER (ORDER BY emp_no) + 1999 AS VARCHAR(10)) AS clave
FROM employees;
GO

