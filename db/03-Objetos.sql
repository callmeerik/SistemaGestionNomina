/*
	Documento con objetos pertenecientes a la base de datos
	nominaDB
*/

USE nominaDB
GO

-- OBJETOS

/*Generar un informa de todos los empleados de la empresa
incluye su ci, nombre, apellido y fecha de ingreso*/

CREATE OR ALTER VIEW VW_EMPLOYEES_REPRT AS
	SELECT
		ci,
		first_name,
		last_name,
		hire_date
	FROM
		employees
GO

-- Generar un informe de todos los empleados que ganen mas de $2000
CREATE OR ALTER VIEW VW_SALARY_REPORT AS
SELECT
	e.emp_no, 
	e.first_name,
	e.last_name,
	s.from_date,
	s.to_date
FROM
	(
		SELECT *,
			ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY s.from_date DESC) AS rn
		FROM salaries s
		WHERE salary > 2000
	) AS s
JOIN employees e ON e.emp_no = s.emp_no
WHERE s.rn = 1 
GO

/*====================================
�		STORED PROCEDURES
=====================================*/
CREATE OR ALTER PROCEDURE sp_departmentInformation 
AS
	select * from departments
GO

-- Visualizar todos los cargos que ha obtenido un empleado

CREATE OR ALTER PROCEDURE sp_EmployeesTitles @ci varchar(50) AS
SELECT
	e.first_name, e.last_name,
	t.title, t.from_date, t.to_date
FROM employees e
INNER JOIN titles t
ON e.emp_no = t.emp_no
WHERE e.ci = @ci
GO

EXEC sp_EmployeesTitles '1709846732'
GO

-- Simular la actualizacion del salario de un empleado

-- Parametros
--	ci
--	salary
--	message

CREATE OR ALTER PROCEDURE sp_salaryUpdate
	@emp_no INT,
	@salary INT,
	@message varchar(150) output
AS
	BEGIN
		--validacion de xistencia de usuario
		IF NOT EXISTS (SELECT * FROM employees WHERE emp_no = emp_no)
			BEGIN
				SET @message = 'No existe registro del empleado'
			END
		ELSE 
			BEGIN
				IF NOT EXISTS (SELECT * FROM salaries WHERE emp_no=emp_no)
					BEGIN
						INSERT INTO salaries (emp_no, salary, from_date, to_date)
						VALUES
							(@emp_no, 1795, CONVERT(VARCHAR(50), GETDATE(), 103), CONVERT(VARCHAR(50), GETDATE()+1000, 103))
						set @message = 'El salario del empleado ha sido agregado'
					END
				ELSE
					BEGIN
						UPDATE salaries
						SET salary = @salary WHERE emp_no = @emp_no

						set @message = 'El salario del empleado ha sido actualizado'
					END
			END
	END
GO

declare @mensaje varchar(150)
exec sp_salaryUpdate 2, 4500, @mensaje output
select @mensaje

select * from salaries
GO


CREATE OR ALTER PROCEDURE sp_salaryTitles
@emp_no INT,
@message VARCHAR(250) output
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM employees WHERE emp_no = @emp_no)
		BEGIN
			SET @message = 'Empleado no encontrado'
		END
	ELSE
		BEGIN
			SELECT
				e.first_name,
				e.last_name,
				t.title,
				t.from_date AS title_from,
				t.to_date AS title_to,
				s.salary,
				s.from_date AS salary_from,
			    s.to_date AS salary_to
			FROM employees e
			INNER JOIN titles t
			ON e.emp_no = t.emp_no
			INNER JOIN salaries s
			ON e.emp_no = s.emp_no
				AND s.from_date <= t.to_date
				AND s.to_date >= t.from_date
			WHERE e.emp_no = @emp_no
		END

END
go

declare @message varchar(250)
exec sp_salaryTitles 8, @message output
select @message
GO
-- TRIGGERS
-- Accion sobre una tabla (UPDATE, DELETE, INSERT, SELECT)
-- Antes o despues de realizar la accion sobre la tabla
-- generalmente sirve para insertar informacion en la tabla
-- utiles en controles de auditoria

-- RF02: Cada vez que se cree un registro del salario de un empleado, necesito conocer la auditoria de quien crea el registro

-- Quien hizo el cambio
-- cuando lo hizo
-- cual fue el cambio

	-- usuario
	-- fecha de cambio
	-- detalle del cambio
	-- salario cambiado
	-- codigo del empleado


-- creacion del trigger
CREATE OR ALTER TRIGGER tr_employeeChangeSalary
	on salaries
	after insert
AS
	BEGIN
		DECLARE @salary bigint
		DECLARE @emp_no int

		--tomando los valores durante la accion en la tabla
		set @emp_no = (SELECT emp_no FROM inserted)
		set @salary = (SELECT salary FROM inserted)

		-- insertar datos en la tabla de auditoria de salarios
		INSERT INTO Log_AuditoriaSalarios(usuario, fecha_actualizacion, detalle_cambio, salario, emp_no)
		VALUES
			(SUSER_SNAME(), GETDATE(), 'Nuevo empleado', @salary, @emp_no)
	END
GO

INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date)
VALUES
    ('1708913621', '1998-07-12', 'Daniela', 'Albertoni', 'F', Getdate())

INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES
	(31, 5, getdate(), '2050-12-31')

INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES
	(31, 'Analista de TI', getdate(), '2050-12-31')

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES
  (31, 1700, getdate(), '2050-12-31')

select * from salaries where emp_no = 31
select * from Log_AuditoriaSalarios
Go
use nominaDB

-- Procedure para Autenticacion de usuarios
-- Procedure de autenticacion
CREATE OR ALTER PROCEDURE sp_userAuthentication
@usuario varchar(150),
@clave varchar(10),
@message varchar(100) output
AS
Begin
	If Not Exists (Select * from employees e join users u on e.emp_no = u.emp_no Where e.correo = @usuario)
	Begin
		Set @message = 'El usuario ingresado no existe en el sistema'
	End
	Else
	Begin
		If Not Exists (Select * From users Where clave = @clave)
		Begin
			Set @message = 'El password es incorrecto'
		End
		Else
		Begin
			set @message = 'Autenticacion exitosa'
			Select 
				u.usuario, 
				concat(e.first_name, ' ', e.last_name) As nombre,
				e.correo, 
				e.ci as ci
			From users u
			join employees e
			on e.emp_no = u.emp_no
			where e.correo = @usuario
				And clave = @clave
		End
	End
End
Go

-- Usuario existente
declare @message varchar(100)
Exec sp_userAuthentication 'rocio.espinoza@correo.com', 'usu2021', @message output
Select @message
go

select * from employees
go

--==========================================
-- Procedure ingresar empleado y usuarios
--==========================================
CREATE OR ALTER PROCEDURE sp_insertEmployee
    @ci varchar(10),
    @birth_date varchar(20),
    @first_name varchar(50),
    @last_name varchar(50),
    @correo varchar(100),
    @gender char(1),
    @clave varchar(12),
    @mensaje NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar duplicado de CI
    IF EXISTS (SELECT 1 FROM employees WHERE ci = @ci)
    BEGIN
        SET @mensaje = 'El número de cédula ya existe en la base de datos.';
        RETURN;
    END;

    -- Verificar duplicado de correo
    IF EXISTS (SELECT 1 FROM employees WHERE correo = @correo)
    BEGIN
        SET @mensaje = 'El correo ya existe en la base de datos.';
        RETURN;
    END;

    -- Validar que el empleado sea mayor de 18 años
    DECLARE @edad INT;
    DECLARE @fecha_nacimiento DATE;

    -- Convertir la fecha de nacimiento de VARCHAR a DATE
    -- Usamos el formato 103 (dd/mm/yyyy) para la conversión
    SET @fecha_nacimiento = CONVERT(DATE, @birth_date, 103);
    
    -- Calcular la edad
    SET @edad = DATEDIFF(yy, @fecha_nacimiento, GETDATE());

    -- Ajustar la edad si el cumpleaños no ha pasado este año
    IF (MONTH(@fecha_nacimiento) > MONTH(GETDATE())) OR (MONTH(@fecha_nacimiento) = MONTH(GETDATE()) AND DAY(@fecha_nacimiento) > DAY(GETDATE()))
    BEGIN
        SET @edad = @edad - 1;
    END;

    IF @edad < 18
    BEGIN
        SET @mensaje = 'El empleado debe ser mayor de 18 años.';
        RETURN;
    END;

    -- Inserción de empleado
    INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date, correo)
    VALUES (
        @ci,
        @birth_date, -- Mantienes el formato original
        @first_name,
        @last_name,
        @gender,
        GETDATE(), -- Usar GETDATE() directamente para la fecha de contratación
        @correo
    );

    -- Obtener ID de empleado recién insertado
    DECLARE @emp_no INT = SCOPE_IDENTITY();

    -- Generación de usuario automático
    DECLARE @usr VARCHAR(40);
    SET @usr = LOWER(LEFT(@first_name, 1) + @last_name);

    -- Insertar usuario
    INSERT INTO users (emp_no, usuario, clave)
    VALUES (@emp_no, @usr, @clave);

    -- Mensaje de éxito
    SET @mensaje = 'Empleado y usuario registrados correctamente.';
END;
GO
declare @mensaje varchar(100)
exec sp_insertEmployee '1245763307', '12/09/2001', 'Roberto', 'Borja', 
				'robert@correo.com', 'M', 'rovert3', @mensaje output
select @mensaje

go

-- procedure para lista todos los empleados
CREATE OR ALTER PROCEDURE sp_getEmployees
    @query VARCHAR(100) = NULL,
    @estado VARCHAR(20) = 'Todos'
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFORMAT dmy;

    SELECT 
        emp_no, 
        ci, 
        first_name, 
        last_name, 
        gender, 
        birth_date,
        hire_date, 
        correo,
        is_active,
        DATEDIFF(YEAR, CAST(birth_date AS DATE), GETDATE()) 
            - CASE 
                WHEN (MONTH(CAST(birth_date AS DATE)) > MONTH(GETDATE())) 
                     OR (MONTH(CAST(birth_date AS DATE)) = MONTH(GETDATE()) 
                         AND DAY(CAST(birth_date AS DATE)) > DAY(GETDATE())) 
                THEN 1 
                ELSE 0 
              END AS age
    FROM employees
    WHERE 
        -- Filtro de búsqueda (si viene vacío, no se aplica)
        (
            @query IS NULL 
            OR ci LIKE '%' + @query + '%'
            OR first_name LIKE '%' + @query + '%'
            OR last_name LIKE '%' + @query + '%'
            OR correo LIKE '%' + @query + '%'
        )
        AND
        -- Filtro por estado (Activo/Desactivado/Todos)
        (
            @estado = 'Todos'
            OR (@estado = 'Activo' AND is_active = 1)
            OR (@estado = 'Desactivado' AND is_active = 0)
        );
END;
GO

declare @query NVARCHAR(100) 
declare @estado NVARCHAR(20) 

exec sp_getEmployees @query=Null, @estado='Desactivado'


select * from employees
select * from users
GO

-- SQP para actualizar datos del empleado
CREATE OR ALTER PROCEDURE sp_updateEmployeePassword
    @emp_no INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @gender CHAR(1),
    @correo VARCHAR(100),
    @clave VARCHAR(50) = NULL -- parámetro opcional
AS
BEGIN
    -- Actualizar datos del empleado
    UPDATE employees
    SET 
        first_name = @first_name,
        last_name = @last_name,
        gender = @gender,
        correo = @correo
    WHERE emp_no = @emp_no;

    -- Actualizar clave solo si se proporciona
    IF @clave IS NOT NULL
    BEGIN
        -- Aquí puedes hashear la clave si es necesario
        UPDATE users
        SET clave = @clave
        WHERE emp_no = @emp_no;
    END
END
GO

-- Procedure para actualizar estado de empleado
CREATE OR ALTER PROCEDURE sp_updateEmployeeState
    @emp_no INT
AS
BEGIN
    UPDATE employees
    SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END
    WHERE emp_no = @emp_no;
END
GO

-- procedure para obtener empleados por emp_no
CREATE OR ALTER PROCEDURE sp_getEmployeeById
    @emp_no INT
AS
BEGIN
    SELECT emp_no, ci, first_name, last_name, correo, gender, birth_date, hire_date, is_active
    FROM employees
    WHERE emp_no = @emp_no;
END
GO


-- Procedure para obtener resumen numero d emepleados, deptos y avg salario
CREATE OR ALTER PROCEDURE sp_getCurrentStaffReportDepartment
    @dept_name VARCHAR(40),
    @fecha_inicio_str VARCHAR(10),
    @mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_inicio DATE;

    -- Intentar convertir la cadena a DATE
    BEGIN TRY
        SET @fecha_inicio = CONVERT(DATE, @fecha_inicio_str, 103);
    END TRY
    BEGIN CATCH
        SET @mensaje = 'Error: La fecha debe estar en formato dd/mm/yyyy.';
        RETURN;
    END CATCH;

    -- Validar existencia del departamento
    IF NOT EXISTS (SELECT 1 FROM departments WHERE dept_name = @dept_name)
    BEGIN
        SET @mensaje = 'Error: El departamento especificado no existe.';
        RETURN;
    END;

    -- Consulta de empleados con salarios y deptos vigentes a partir de la fecha indicada
    SELECT
        e.emp_no,
        e.first_name,
        e.last_name,
        s.salary,
        s.from_date AS salary_from_date,
        ISNULL(CONVERT(VARCHAR(10), s.to_date, 103), 'Vigente') AS salary_to_date,
        d.dept_name,
        de.from_date AS dept_from_date,
        ISNULL(CONVERT(VARCHAR(10), de.to_date, 103), 'Vigente') AS dept_to_date
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE
        d.dept_name = @dept_name
        -- Vigencia en el departamento (to_date NULL)
        AND de.to_date IS NULL
        -- Solo registros con fecha de inicio igual o mayor a la indicada
        AND TRY_CONVERT(DATE, s.from_date, 103) >= @fecha_inicio
    ORDER BY e.last_name, e.first_name;

    SET @mensaje = 'Reporte generado correctamente.';
END;
GO

declare @mensaje varchar(100)
exec sp_getCurrentStaffReportDepartment'Finanzas', '02/01/2017', @mensaje output
Go


CREATE OR ALTER PROCEDURE sp_getDashboardMetrics
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM employees) AS TotalEmpleados,
        (SELECT COUNT(*) FROM departments) AS TotalDepartamentos,
        (SELECT AVG(salary) FROM salaries WHERE to_date IS NULL) AS PromedioSalarioVigente;
END;
GO





/*
PROCEDUREs Departamentos

*/



CREATE OR ALTER PROCEDURE sp_insertDeparment
@nombreDepar varchar(50)
AS
BEGIN
	--Validación si ya existe departamento con el mismo nombre
	IF  EXISTS(SELECT 1 FROM dbo.departments WHERE dept_name = @nombreDepar)
	BEGIN
	RAISERROR(N'El departamento ya existe.',16,1);
	RETURN;
	END

	INSERT INTO departments (dept_name) VALUES
	(@nombreDepar)
END
GO

/*
--EXEC sp_insertDeparment 'Prueba'
--GO
*/


CREATE OR ALTER PROCEDURE sp_getDeparments
AS
BEGIN
	SELECT  dept_no AS Id, dept_name AS Departamento FROM departments
END
GO

EXEC sp_getDeparments


CREATE OR ALTER PROCEDURE sp_getDept_manager
AS
BEGIN
SELECT  e.emp_no AS Id,
        e.ci AS CI,
        e.birth_date AS F_Nacimiento,
        CONCAT(e.first_name, ' ', e.last_name) AS Nombres,
        e.hire_date AS F_Ingreso,
        s.dept_name AS Departamento,
		d.from_date AS Desde,
		d.to_date AS Hasta
     
FROM employees   e
JOIN dept_emp    d ON e.emp_no  = d.emp_no
JOIN departments s ON d.dept_no = s.dept_no;
END
GO

EXEC sp_getDept_manager


--- busca el empleado al que se le va a realizar la actualizacion de departamento

CREATE OR ALTER PROCEDURE sp_getAsigDepartEmpl
@ci varchar(50)
AS
BEGIN
	--Validación si ya existe departamento con el mismo nombre
	IF  NOT EXISTS(SELECT 1 FROM dbo.employees WHERE ci = @ci)
	BEGIN
	RAISERROR(N'No existe empleado con ese número de cédula.',16,1);
	RETURN;
	END


SELECT  e.emp_no AS Id,
        e.ci AS CI,
        CONCAT(e.first_name, ' ', e.last_name) AS Nombres,
		d.dept_no AS Id_Departamento,
		s.dept_name AS Departamento,
		d.from_date AS Desde,
		d.to_date AS Hasta
     
FROM employees   e
JOIN dept_emp    d ON e.emp_no  = d.emp_no 
JOIN departments s ON d.dept_no = s.dept_no WHERE e.ci = @ci;

END
GO

EXEC sp_getAsigDepartEmpl '1708913678'
GO


---Realiza la modificacion del departamento del empleado y agrega nuevo registro a la tabla dept_emp-------
CREATE OR ALTER PROCEDURE sp_setAsigDepartEmpl
@emp_no int,
@dept_no int,
@dept_no_nuevo int

AS
BEGIN

    IF @dept_no = @dept_no_nuevo
    BEGIN
        RAISERROR('El departamento nuevo es igual al actual.', 16, 1);
        RETURN;
    END
	--DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
	DECLARE @hoy VARCHAR(50) = CONVERT(varchar(10), GETDATE(), 103); -- formato dd/mm/yyyy


	--- Actualizacion de regitro to_date en registro actual
    UPDATE dept_emp SET to_date = @hoy WHERE emp_no = @emp_no
       AND dept_no = @dept_no AND to_date = NULL; -- Sera NULL
     
    -- Agregar nuevo registro con to_date = NULL
    INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
    VALUES (@emp_no, @dept_no_nuevo, @hoy, NULL); -- Sera NULL

END
GO

