/*
    Este documento tiene los scripts de SQL para
    la creación de la base de datos nominaDB y la
    creación de tablas
*/

CREATE DATABASE nominaDB
GO

USE nominaDB
GO


--=========================================
--  CREACIÓN DE TABLAS
--=========================================

-- Tabla departments
CREATE TABLE departments(
    dept_no     INT     PRIMARY KEY IDENTITY(1, 1),
    dept_name   VARCHAR(50) NOT NULL,
    is_active   BIT     DEFAULT 1
)
GO

-- Tabla employees
CREATE TABLE employees(
    emp_no      INT     PRIMARY KEY IDENTITY(1, 1),
    ci          VARCHAR(50) NOT NULL,
    birth_date  DATE    NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    gender      CHAR(1) NOT NULL,
    hire_date   DATE    NOT NULL,
    correo      VARCHAR(120) NOT NULL,
    is_active   BIT     DEFAULT 1
)
GO

-- Tabla dept_manager
CREATE TABLE dept_manager(
    emp_no      INT     NOT NULL,
    dept_no     INT     NOT NULL,
    from_date   DATE    NOT NULL,
    to_date     DATE    NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
)
GO

-- Tabla dept_emp
CREATE TABLE dept_emp(
    emp_no      INT     NOT NULL,
    dept_no     INT     NOT NULL,
    from_date   DATE    NOT NULL,
    to_date     DATE    NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
)
GO

-- Tabla titles (cargos)
CREATE TABLE titles(
    emp_no      INT     NOT NULL,
    title       VARCHAR(50) NOT NULL,
    from_date   DATE    NOT NULL,
    to_date     DATE    NULL, -- si es nulo, cargo vigente
    PRIMARY KEY (emp_no, title, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
GO

-- Tabla salaries
CREATE TABLE salaries(
    emp_no      INT     NOT NULL,
    salary      BIGINT  NOT NULL,
    from_date   DATE    NOT NULL,
    to_date     DATE    NULL,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
GO

-- Tabla users
CREATE TABLE users(
    emp_no      INT     NOT NULL,
    usuario     VARCHAR(150) NOT NULL,
    clave       VARCHAR(64) NOT NULL,
    rol         VARCHAR(30) NOT NULL DEFAULT 'user',
    PRIMARY KEY (emp_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
GO

-- Tabla Log_AuditoriaSalarios
CREATE TABLE Log_AuditoriaSalarios(
    id                  INT IDENTITY(1, 1) PRIMARY KEY,
    usuario             VARCHAR(50) NOT NULL,
    fecha_actualizacion DATE NOT NULL,
    detalle_cambio      VARCHAR(250) NOT NULL,
    salario             BIGINT NOT NULL,
    emp_no              INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
GO
