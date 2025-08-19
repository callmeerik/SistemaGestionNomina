/*
	Este documento tiene los scripts de SQL para
	la creacion de la base de datos nominaDB t la
	creacion de tablas
*/

CREATE DATABASE nominaDB
Go

USE nominaDB
Go


--=========================================
--	CREACI�N DE TABLAS
--=========================================
-- Tabla departments
CREATE TABLE departments(
	dept_no		INT		PRIMARY KEY		IDENTITY(1, 1),
	dept_name	VARCHAR(50)		NOT NULL,
	is_active   BIT				DEFAULT 1
)
Go

-- Tabla employees
CREATE TABLE employees(
	emp_no		INT		PRIMARY KEY		IDENTITY(1, 1),
	ci			VARCHAR(50)		NOT NULL,
	birth_date	VARCHAR(50)		NOT NULL,
	first_name	VARCHAR(50)		NOT NULL,
	last_name	VARCHAR(50)		NOT NULL,
	gender		CHAR(1)			NOT NULL,
	hire_date	VARCHAR(50)		NOT NULL,
	correo		VARCHAR(120)	NOT NULL,
	is_active   BIT				DEFAULT 1
)
Go

-- Tabla dept_manager
CREATE TABLE dept_manager(
	emp_no		INT				NOT NULL,
	dept_no		INT				NOT NULL,
	from_date	VARCHAR(50)		NOT NULL,
	to_date		VARCHAR(50)		NULL,
	PRIMARY KEY	(emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
)
Go


-- Tabla dept_emp
CREATE TABLE dept_emp(
	emp_no		INT				NOT NULL,
	dept_no		INT				NOT NULL,
	from_date	VARCHAR(50)		NOT NULL,
	to_date		VARCHAR(50)		NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
)
Go

-- Table titles (cargos)
CREATE TABLE titles(
	emp_no		INT				NOT NULL,
	title		VARCHAR(50)		NOT NULL,
	from_date	VARCHAR(50)		NOT NULL,
	to_date		VARCHAR(50)		NULL, -- si es nulo cargo vigente
	PRIMARY KEY (emp_no, title, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
)
Go

-- Tabla salaries
CREATE TABLE salaries(
	emp_no		INT			NOT NULL,
	salary		BIGINT		NOT NULL,
	from_date	VARCHAR(50)	NOT NULL,
	to_date		VARCHAR(50) NULL,
	PRIMARY KEY (emp_no, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
)
Go

CREATE TABLE users(
	emp_no int not null,
	usuario varchar(150) not null,
	clave varchar(20) not null,
	rol VARCHAR (30),
	primary key (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
)
Go

CREATE TABLE Log_AuditoriaSalarios(
	id int identity(1, 1) primary key,
	usuario varchar(50) not null,
	fecha_actualizacion date not null,
	detalle_cambio varchar(250) not null,
	salario bigint not null,
	emp_no int not null,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
GO
