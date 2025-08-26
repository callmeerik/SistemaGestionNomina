use nominaDB
go

/*
===============================================
        OBJETOS AUTENTICACION
===============================================
*/

-- Store procedure para Login

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


-- Store procedure para Registro

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
        Cast(GETDATE() AS DATE),     -- Fecha actual como DATE
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

-- Store procedure para el cambio de Role en usuarios.

CREATE OR ALTER PROCEDURE dbo.sp_cambiarRolUsuario
    @usuario NVARCHAR(50),
    @nuevoRol NVARCHAR(50),
    @message NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM dbo.users WHERE usuario = @usuario)
    BEGIN
        SET @message = 'El usuario no existe';
        RETURN;
    END

    -- Actualizar el rol del usuario
    UPDATE dbo.users
    SET rol = @nuevoRol
    WHERE usuario = @usuario;

    SET @message = 'Rol actualizado correctamente';
END;
GO


/*

DECLARE @msg NVARCHAR(100);

EXEC dbo.sp_cambiarRolUsuario 
    @usuario = 'erubiales',
    @nuevoRol = 'Admin',
    @message = @msg OUTPUT;

SELECT @msg AS Resultado;


use nominaDB
select * from users
*/




/*
==================================================
    OBJETOS DE CARGOS
==================================================
*/


--listar todos los empleados consu cargo actual--


CREATE OR ALTER PROCEDURE sp_listEmployeesCurrentTitles
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH CargosOrdenados AS
    (
        SELECT e.emp_no,
               e.ci,
               e.first_name,
               e.last_name,
               t.title,
               t.from_date,
               t.to_date,
               ROW_NUMBER() OVER(PARTITION BY e.emp_no ORDER BY t.from_date DESC) AS rn
        FROM employees e
        LEFT JOIN titles t ON e.emp_no = t.emp_no
    )
    SELECT emp_no, ci, first_name, last_name, title, from_date, to_date
    FROM CargosOrdenados
    WHERE rn = 1 OR rn Is null
END
Go


--Asignar un nuevo Cargo a un empleado----
CREATE OR ALTER PROCEDURE sp_assignTitle

    @emp_no INT,
    @title VARCHAR(50),
    @message NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el empleado exista
    IF NOT EXISTS (SELECT 1 FROM employees WHERE emp_no = @emp_no)
    BEGIN
        SET @message = 'El empleado no existe.';
        RETURN;
    END

    -- Verificar si ya tiene el mismo cargo activo
    IF EXISTS (SELECT 1 FROM titles WHERE emp_no = @emp_no AND title = @title AND to_date IS NULL)
    BEGIN
        SET @message = 'El empleado ya tiene asignado ese cargo actualmente.';
        RETURN;
    END

    -- Cerrar cualquier cargo activo anterior
    UPDATE titles
    SET to_date = GETDATE()
    WHERE emp_no = @emp_no AND to_date IS NULL;

    -- Insertar el nuevo cargo
    INSERT INTO titles (emp_no, title, from_date, to_date)
    VALUES (@emp_no, @title, GETDATE(), NULL);

    SET @message = 'Cargo asignado correctamente.';
END;
GO



--Historial de Cargos de un empleado---
CREATE OR ALTER PROCEDURE sp_titlesHistory
    @emp_no INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        title,
        from_date,
        to_date,
        CASE 
            WHEN to_date IS NULL THEN 'Vigente'
            ELSE CONVERT(VARCHAR(10), to_date, 120)
        END AS estado,
        DATEDIFF(MONTH, from_date, ISNULL(to_date, GETDATE())) AS meses_duracion
    FROM titles
    WHERE emp_no = @emp_no
    ORDER BY from_date;
END
GO

/*
=======================================================
        OBJETOS DE EMPLEADOS
=======================================================
*/

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


-- oBTENER EMPLEADO POR EMP_NO

CREATE OR ALTER PROCEDURE sp_getEmployeeById
    @emp_no INT
AS
BEGIN
    SELECT emp_no, ci, first_name, last_name, correo, gender, birth_date, hire_date, is_active
    FROM employees
    WHERE emp_no = @emp_no;
END
GO




-- Actualizar empleado

CREATE OR ALTER PROCEDURE sp_updateEmployeePassword
    @emp_no INT,
    @ci VARCHAR(10),
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @gender CHAR(1),
    @birth_date DATE,
    @hire_date DATE,
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


-- actualizar estado del empleado

CREATE OR ALTER PROCEDURE sp_updateEmployeeState
    @emp_no INT
AS
BEGIN
    UPDATE employees
    SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END
    WHERE emp_no = @emp_no;
END
GO






/*
====================================================
    OBJETOS DE SALARIOS
====================================================
*/


CREATE OR ALTER VIEW VW_EmpleadosSalarioActual
AS
SELECT 
    e.emp_no,
    e.ci,
    e.first_name,
    e.last_name,
    e.hire_date,
    ISNULL(s.salary, 0) AS salary,
    s.from_date,
    s.to_date
FROM employees e
LEFT JOIN salaries s
    ON e.emp_no = s.emp_no
   AND s.to_date IS NULL;
GO


-- Vista historial de salarios
CREATE OR ALTER VIEW VW_HistorialSalarios
AS
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary,
    s.from_date,
    s.to_date
FROM employees e
INNER JOIN salaries s
    ON e.emp_no = s.emp_no;
GO

 
-- Procedure para registrar nuevo salario
CREATE OR ALTER PROCEDURE sp_registrarSalario
    @emp_no INT,
    @new_salary BIGINT,
    @changed_by VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @old_salary bigint;
    DECLARE @from_date DATE = CAST(GETDATE() AS DATE);

    -- Validar salario negativo
    IF @new_salary < 0
    BEGIN
        RAISERROR('El nuevo salario no puede ser negativo.', 16, 1);
        RETURN;
    END;

    -- Obtener salario vigente
    SELECT @old_salary = salary
    FROM salaries
    WHERE emp_no = @emp_no AND to_date IS NULL;

    IF @old_salary IS NULL
    BEGIN
        -- Primer salario
        INSERT INTO salaries (emp_no, salary, from_date, to_date)
        VALUES (@emp_no, @new_salary, @from_date, NULL);

        INSERT INTO Log_AuditoriaSalarios (usuario, fecha_actualizacion, detalle_cambio, salario, emp_no)
        VALUES (
            ISNULL(@changed_by,'Sistema'),
            @from_date,
            CONCAT('Salario inicial: ', @new_salary),
            @new_salary,
            @emp_no
        );
    END
    ELSE IF @old_salary <> @new_salary
    BEGIN
        -- Cerrar salario anterior
        UPDATE salaries
        SET to_date = DATEADD(day, -1, @from_date)
        WHERE emp_no = @emp_no AND to_date IS NULL;

        -- Insertar nuevo salario
        INSERT INTO salaries (emp_no, salary, from_date, to_date)
        VALUES (@emp_no, @new_salary, @from_date, NULL);

        INSERT INTO Log_AuditoriaSalarios (usuario, fecha_actualizacion, detalle_cambio, salario, emp_no)
        VALUES (
            ISNULL(@changed_by,'Sistema'),
            @from_date,
            CONCAT('Cambio de salario de ', @old_salary, ' a ', @new_salary),
            @new_salary,
            @emp_no
        );
    END
    -- Si @old_salary = @new_salary → no hacer nada
END;
GO


select * from Log_AuditoriaSalarios
go







/*
=======================================================
        OBJETOS DEPARTAMENTOS
=======================================================
*/





CREATE OR ALTER PROCEDURE dbo.SPinsertDepartment
    @nombreDepar VARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.departments ( dept_name)
    VALUES (@nombreDepar);
END
GO





CREATE OR ALTER PROCEDURE dbo.SPgetDepartments
AS
BEGIN
	SELECT  dept_no AS Id, dept_name AS Departamento FROM dbo.departments
END
GO





CREATE OR ALTER PROCEDURE dbo.SPgetDept_manager
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








CREATE OR ALTER PROCEDURE dbo.SPgetEmpleadosSD
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  
        e.emp_no                                AS Id,
        e.ci                                    AS CI,
        e.birth_date                            AS F_Nacimiento,
        CONCAT(e.first_name, ' ', e.last_name)  AS Nombres,
        e.hire_date                             AS F_Ingreso,
        e.hire_date                             AS Desde,
        CAST(NULL AS INT)                       AS Id_Departamento
    FROM dbo.employees e
    WHERE e.emp_no IS NOT NULL
      AND NOT EXISTS (
            SELECT 1
            FROM dbo.dept_emp d
            WHERE d.emp_no = e.emp_no

      );
END
GO








CREATE OR ALTER PROCEDURE dbo.SPgetDepartmentsActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT d.dept_no, d.dept_name
    FROM dbo.departments d
    WHERE ISNULL(d.is_active, 1) = 1
    ORDER BY d.dept_name;
END
GO



CREATE OR ALTER PROCEDURE dbo.SPgetAsigDepartEmpl
@ci varchar(50)
AS
BEGIN
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






CREATE OR ALTER PROCEDURE dbo.SPinsertDeptEmpActual
    @emp_no  INT,
    @dept_no INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.employees WHERE emp_no = @emp_no)
    BEGIN
        RAISERROR('Empleado no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.departments WHERE dept_no = @dept_no AND ISNULL(is_active,1)=1)
    BEGIN
        RAISERROR('Departamento no existe o está inactivo.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM dbo.dept_emp WHERE emp_no = @emp_no AND to_date IS NULL)
    BEGIN
        RAISERROR('El empleado ya tiene una asignación activa.', 16, 1);
        RETURN;
    END

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);

    INSERT INTO dbo.dept_emp (emp_no, dept_no, from_date, to_date)
    VALUES (@emp_no, @dept_no, @hoy, NULL);
END
GO





--EXEC dbo.SPinsertDeptEmpActual @emp_no = 25, @dept_no = 5;
--SELECT * FROM employees WHERE ci='1705748392'
--SELECT * FROM dept_emp WHERE emp_no = 25
--SELECT * FROM departments WHERE dept_no = 5
--SELECT * FROM dbo.dept_emp WHERE emp_no = 25 AND to_date IS NOT NULL


USE nominaDB

CREATE OR ALTER PROCEDURE dbo.SPsetAsigDepartEmpl
    @emp_no          INT,
    --@dept_no         INT,
    @dept_no_nuevo   INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @dept_no_actual INT;

    -- 1) Obtener el departamento vigente del empleado
    SELECT @dept_no_actual = d.dept_no
    FROM dbo.dept_emp AS d
    WHERE d.emp_no = @emp_no
      AND d.to_date IS NULL;          

    IF @dept_no_actual IS NULL
        THROW 50001, 'El empleado no tiene una asignación vigente.', 1;

    ------ 2) Verificar que el dept actual coincide con el proporcionado
    --IF @dept_no_actual <> @dept_no
    --    THROW 50002, 'El departamento actual no coincide con el proporcionado.', 1;

    -- 3) Evitar reasignación al mismo departamento
    IF @dept_no_nuevo = @dept_no_actual
        THROW 50003, 'El departamento nuevo es igual al actual.', 1;

    -- 4) Evitar duplicar una asignación vigente al nuevo depto
    IF EXISTS (
        SELECT 1
        FROM dbo.dept_emp
        WHERE emp_no  = @emp_no
          AND dept_no = @dept_no_nuevo
    )
        THROW 50004, 'Ya existe una asignación vigente al nuevo departamento.', 1;

    BEGIN TRAN;

        -- 5) Cerrar la asignación actual (IMPORTANTE: usar IS NULL, no = NULL)
        UPDATE dbo.dept_emp
        SET to_date = @hoy
        WHERE emp_no  = @emp_no
          AND dept_no = @dept_no_actual
          AND to_date IS NULL;

        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRAN;
            THROW 50005, 'No se pudo cerrar la asignación vigente (ninguna fila afectada).', 1;
        END

        -- 6) Insertar la nueva asignación
        INSERT INTO dbo.dept_emp (emp_no, dept_no, from_date, to_date)
        VALUES (@emp_no, @dept_no_nuevo, @hoy, NULL);

    COMMIT TRAN;
END
GO


--EXEC SPsetAsigDepartEmpl @emp_no=1, @dept_no=2, @dept_no_nuevo=3;




--SELECT * FROM employees WHERE ci='1708913678'
--SELECT * FROM dept_emp WHERE emp_no = 1
--SELECT * FROM departments WHERE dept_no = 2
--SELECT * FROM departments WHERE dept_no = 7
--SELECT * FROM dbo.dept_emp WHERE emp_no = 1 AND to_date IS  NULL




/*
========================================
    PROCEDURE PARA DASHBOARD
========================================
*/

CREATE OR ALTER PROCEDURE dbo.sp_dashboardNomina
AS
BEGIN
    SET NOCOUNT ON;

    -- Total empleados activos
    SELECT COUNT(*) AS total_empleados
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE de.to_date IS NULL;

    -- Distribución por género
    SELECT e.gender, COUNT(*) AS cantidad
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE de.to_date IS NULL
    GROUP BY e.gender;

    -- Total departamentos
    SELECT COUNT(*) AS total_departamentos
    FROM departments;

    -- Empleados por departamento
    SELECT d.dept_name, COUNT(*) AS total_empleados
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    WHERE de.to_date IS NULL
    GROUP BY d.dept_name;

    -- Promedio de salarios
    SELECT AVG(s.salary) AS promedio_salario
    FROM salaries s
    WHERE s.to_date IS NULL;

    -- Promedio de salarios por departamento
    SELECT d.dept_name, AVG(s.salary) AS promedio_salario
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.to_date IS NULL AND s.to_date IS NULL
    GROUP BY d.dept_name;
END;
GO


