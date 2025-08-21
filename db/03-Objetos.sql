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
		STORED PROCEDURES
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
		INSERT INTO log_auditorySalary (username, update_date, change_detail, salary, emp_no)
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
select * from log_auditorySalary
Go

/*
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


*/
/*
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

    -- Inserción de empleado
    INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date, correo)
    VALUES (
        @ci,
        @birth_date,
        @first_name,
        @last_name,
        @gender,
        CONVERT(VARCHAR(100), GETDATE(), 103),
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
exec sp_insertEmployee '1245763307', '2001-09-12', 'Roberto', 'Borja', 
				'robert@correo.com', 'M', 'rovert3', @mensaje output
select @mensaje

go
*/

-- procedure para lista todos los empleados
CREATE OR ALTER PROCEDURE sp_getEmployees
    @query NVARCHAR(100) = NULL,
    @estado NVARCHAR(20) = 'Todos'
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
    @ci VARCHAR(10),
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @gender CHAR(1),
    @birth_date VARCHAR(20),
    @hire_date varchar(20),
    @correo VARCHAR(100),
    @clave VARCHAR(50) = NULL -- parámetro opcional
AS
BEGIN
    -- Actualizar datos del empleado
    UPDATE employees
    SET 
        ci = @ci,
        first_name = @first_name,
        last_name = @last_name,
        gender = @gender,
        birth_date = @birth_date,
        hire_date = @hire_date,
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











-- Store procedure para Login
-- CREACION DE AUTENTICACION
CREATE OR ALTER PROCEDURE sp_userAuthentication
    @usuario nvarchar(50),
    @clave nvarchar(64),
    @message nvarchar(100) OUTPUT
AS
BEGIN
    -- Verificar si el usuario existe
    IF NOT EXISTS (
        SELECT 1 
        FROM users u
        WHERE u.usuario = @usuario
    )
    BEGIN
        SET @message = 'El usuario ingresado no existe en el sistema';
    END
    ELSE
    BEGIN
        -- Verificar si la clave coincide con el usuario
        IF NOT EXISTS (
            SELECT 1
            FROM users u
            WHERE u.usuario = @usuario
              AND u.clave = @clave
        )
        BEGIN
            SET @message = 'El password es incorrecto';
        END
        ELSE
        BEGIN
            -- Autenticación exitosa
            SET @message = 'Autenticacion exitosa';

            SELECT 
                u.usuario, 
                u.clave,
                u.rol
            FROM users u
            WHERE u.usuario = @usuario
              AND u.clave = @clave;
        END
    END
END
GO

DECLARE @mensajeSalida varchar(100);

EXEC sp_userAuthentication
    @usuario = 'lserrano',
    @clave = 'usu2013',
    @message = @mensajeSalida OUTPUT;

SELECT @mensajeSalida AS Resultado;

-- Store procedure para Registro


USE nominaDB
GO

CREATE OR ALTER PROCEDURE sp_insertEmployee
    @ci VARCHAR(10),
    @birth_date DATE,           -- Cambiado a DATE
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @correo VARCHAR(100),
    @gender CHAR(1),
    @clave VARCHAR(64),
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

    -- Inserción de empleado
    INSERT INTO employees (ci, birth_date, first_name, last_name, gender, hire_date, correo)
    VALUES (
        @ci,
        @birth_date,
        @first_name,
        @last_name,
        @gender,
        GETDATE(),     -- Fecha actual como DATE
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

-- Ejemplo de ejecución
DECLARE @mensajeSalida NVARCHAR(200);

EXEC sp_insertEmployee 
    @ci = '1212363307', 
    @birth_date = '2001-09-12',  -- Ya como DATE
    @first_name = 'Roberto', 
    @last_name = 'Borja', 
    @correo = 'robesdarasfdst@correo.com', 
    @gender = 'M', 
    @clave = 'usu2asfdsasfafasfasdsafsad030', 
    @mensaje = @mensajeSalida OUTPUT;

SELECT @mensajeSalida AS Resultado;
