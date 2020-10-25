USE GD2C2020

/*
Todos los objetos de base de datos nuevos creados por el usuario deben pertenecer
a un esquema de base de datos creado con el nombre del grupo.

Todas las columnas creadas para las nuevas tablas deberán respetar los mismos
tipos de datos.

IMPORTANTE: El campo PASAJE_FECHA_COMPRA de la tabla maestra no debe tenerse en cuenta para la migración.
*/

--CREACIÓN DEL SCHEMA;
USE GD2C2020
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'LOS_CAPOS')
BEGIN
    EXEC ('CREATE SCHEMA LOS_CAPOS')
END
GO


-- CREACIÓN DE LAS TABLAS

/* TIPS:
ORDEN:
TABLAS -> INDICES  -> VISTAS  -> FUNCIONES  -> SP  ->TRIGGERS  -> LLENADO DE TABLAS  -> (CREACION DE INDICES?)

PARA SABER LAS FKS DE UNA TABLA:
EXEC sp_fkeys 'AUTOPARTES'
*/

/************** CREACION DE TABLAS **************/

/**** AUTOS *****/

IF OBJECT_ID('LOS_CAPOS.CLIENTES_VENTAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.CLIENTES_VENTAS;
CREATE TABLE LOS_CAPOS.CLIENTES_VENTAS (
	id_clientes_ventas INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cliente_v_apellido nvarchar(255),
	cliente_v_nombre nvarchar(255),
	cliente_v_direccion nvarchar(255),
	cliente_v_dni decimal(18,0),
	cliente_v_fecha_nac datetime2(3),
	cliente_v_mail nvarchar(255),
	id_factura int
);

IF OBJECT_ID('LOS_CAPOS.FACTURAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.FACTURAS;
CREATE TABLE LOS_CAPOS.FACTURAS (
	id_factura INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	factura_nro decimal(18,0),
	factura_fecha datetime2(3),
	fac_cliente_apellido nvarchar(255),
	fac_cliente_nombre nvarchar(255),
	fac_cliente_direccion nvarchar(255),
	fac_cliente_dni decimal(18,0),
	fac_cliente_fecha_nac datetime2(3),
	fac_cliente_mail nvarchar(255),
	fac_sucursal_direccion nvarchar(255),
	fac_sucursal_mail nvarchar(255),
	fac_sucursal_telefono decimal(18,0),
	fac_sucursal_ciudad nvarchar(255),
	id_item_factura int
);

IF OBJECT_ID('LOS_CAPOS.ITEMS_FACTURAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.ITEMS_FACTURAS;
CREATE TABLE LOS_CAPOS.ITEMS_FACTURAS (
	id_item INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	precio_unitario_facturado decimal(18,0),
	precio_total_facturado decimal(18,0),
	cant_facturada decimal(18,0),
	id_autoparte int,
	id_auto int
);

IF OBJECT_ID('LOS_CAPOS.AUTOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.AUTOS;
CREATE TABLE LOS_CAPOS.AUTOS (
	id_auto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_motor_codigo decimal(18,0),
	auto_nro_chasis nvarchar(255),
	auto_nro_motor nvarchar(255),
	auto_patente nvarchar(255),
	auto_fecha_alta datetime2(3),
	auto_cant_kms decimal(18,0),
	en_stock bit,
	id_motor int,
	id_caja int,
	id_transmision int,
	id_tipo_auto int
);

/* Ojo, Los motores no tienen desc, es una columna que creamos nosotros como parte de nuestro nuevo modelo*/
IF OBJECT_ID('LOS_CAPOS.MOTORES', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.MOTORES;
CREATE TABLE LOS_CAPOS.MOTORES (
	id_motor INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_motor_codigo decimal(18,0),
	tipo_motor_desc nvarchar(255),
);

IF OBJECT_ID('LOS_CAPOS.CAJAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.CAJAS;
CREATE TABLE LOS_CAPOS.CAJAS (
	id_caja INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_caja_codigo decimal(18,0),
	tipo_caja_desc nvarchar(255),
);

IF OBJECT_ID('LOS_CAPOS.CAJAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.CAJAS;
CREATE TABLE LOS_CAPOS.CAJAS (
	id_caja INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_caja_codigo decimal(18,0),
	tipo_caja_desc nvarchar(255),
);

 
IF OBJECT_ID('LOS_CAPOS.TRANSMISIONES', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.TRANSMISIONES;
CREATE TABLE LOS_CAPOS.TRANSMISIONES (
	id_transmision INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_transmision_codigo decimal(18,0),
	tipo_transmision_desc nvarchar(255),
);

IF OBJECT_ID('LOS_CAPOS.TIPOS_AUTOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.TIPOS_AUTOS;
CREATE TABLE LOS_CAPOS.TIPOS_AUTOS (
	id_tipo_auto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_auto_codigo decimal(18,0),
	tipo_auto_desc nvarchar(255),
);

IF OBJECT_ID('LOS_CAPOS.AUTOPARTES', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.AUTOPARTES;
CREATE TABLE LOS_CAPOS.AUTOPARTES (
	id_autoparte INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	autoparte_codigo decimal(18,0),
	autoparte_descripcion nvarchar(255),
	categoria nvarchar(255),
	en_stock bit,
	id_modelo int
);

IF OBJECT_ID('LOS_CAPOS.MODELOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.MODELOS;
CREATE TABLE LOS_CAPOS.MODELOS (
	id_modelo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	modelo_codigo decimal(18,0),
	modelo_nombre nvarchar(255),
	modelo_potencia decimal(18,0),
	fabricante_nombre nvarchar(255)
);

IF OBJECT_ID('LOS_CAPOS.CLIENTES_COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.CLIENTES_COMPRAS;
CREATE TABLE LOS_CAPOS.CLIENTES_COMPRAS (
	id_clientes_compras INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cliente_c_apellido  nvarchar(255),
	cliente_c_nombre nvarchar(255),
	cliente_c_dni decimal(18,0),
	cliente_c_mail nvarchar(255),
	id_compras int
);

IF OBJECT_ID('LOS_CAPOS.COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.COMPRAS;
CREATE TABLE LOS_CAPOS.COMPRAS (
	id_compras INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	compra_nro decimal(18,0),
	compra_fecha datetime2(3),
	id_item_compra int,
	id_sucursal int
);
 
IF OBJECT_ID('LOS_CAPOS.SUCURSALES', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.SUCURSALES;
CREATE TABLE LOS_CAPOS.SUCURSALES (
	id_sucursal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	sucursal_direccion  nvarchar(255),
	sucursal_mail nvarchar(255),
	sucursal_telefono decimal(18,0),
	sucursal_ciudad nvarchar(255),
);

IF OBJECT_ID('LOS_CAPOS.ITEMS_COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.ITEMS_COMPRAS;
CREATE TABLE LOS_CAPOS.ITEMS_COMPRAS (
	id_item INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	compra_cant decimal(18,0),
	compra_precio_unitario decimal(18,0),
	compra_precio_total decimal(18,0),
	id_autoparte int,
	id_auto int
);


/** AGREGAMOS FKs**/
ALTER TABLE LOS_CAPOS.AUTOS
 	ADD FOREIGN KEY (id_motor) REFERENCES LOS_CAPOS.MOTORES(id_motor),
     	FOREIGN KEY (id_caja) REFERENCES LOS_CAPOS.CAJAS(id_caja),
     	FOREIGN KEY (id_transmision) REFERENCES LOS_CAPOS.TRANSMISIONES(id_transmision),
     	FOREIGN KEY (id_tipo_auto) REFERENCES LOS_CAPOS.TIPOS_AUTOS(id_tipo_auto)

ALTER TABLE LOS_CAPOS.AUTOPARTES
	ADD FOREIGN KEY (id_modelo) REFERENCES LOS_CAPOS.MODELOS(id_modelo)

ALTER TABLE LOS_CAPOS.CLIENTES_VENTAS
	ADD FOREIGN KEY (id_factura) REFERENCES  LOS_CAPOS.FACTURAS(id_factura)

ALTER TABLE LOS_CAPOS.FACTURAS
	ADD FOREIGN KEY (id_item_factura) REFERENCES  LOS_CAPOS.ITEMS_FACTURAS(id_item)

ALTER TABLE LOS_CAPOS.ITEMS_FACTURAS
	ADD FOREIGN KEY (id_autoparte) REFERENCES LOS_CAPOS.AUTOPARTES(id_autoparte),
    	FOREIGN KEY (id_auto) REFERENCES LOS_CAPOS.AUTOS(id_auto)

ALTER TABLE LOS_CAPOS.CLIENTES_COMPRAS
	ADD FOREIGN KEY (id_compras) REFERENCES LOS_CAPOS.COMPRAS(id_compras)

ALTER TABLE LOS_CAPOS.COMPRAS
	ADD FOREIGN KEY (id_item_compra) REFERENCES LOS_CAPOS.ITEMS_COMPRAS(id_item),
    	FOREIGN KEY (id_sucursal) REFERENCES LOS_CAPOS.SUCURSALES(id_sucursal)



CREATE PROCEDURE importar_motores AS
INSERT INTO LOS_CAPOS.MOTORES (tipo_motor_codigo)
SELECT DISTINCT(tipo_motor_codigo)
FROM gd_esquema.Maestra
WHERE tipo_motor_codigo IS NOT NULL;
GO


CREATE PROCEDURE importar_cajas AS
INSERT INTO LOS_CAPOS.CAJAS (TIPO_CAJA_CODIGO, TIPO_CAJA_DESC)
SELECT DISTINCT(TIPO_CAJA_CODIGO), TIPO_CAJA_DESC
FROM gd_esquema.Maestra
WHERE TIPO_CAJA_CODIGO IS NOT NULL;
GO


CREATE PROCEDURE importar_transmisiones AS
INSERT INTO LOS_CAPOS.TRANSMISIONES (TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC)
SELECT DISTINCT(TIPO_TRANSMISION_CODIGO), TIPO_TRANSMISION_DESC
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL;
GO


CREATE PROCEDURE importar_tipos_autos AS
INSERT INTO LOS_CAPOS.TIPOS_AUTOS (tipo_auto_codigo, tipo_auto_desc)
SELECT DISTINCT(tipo_auto_codigo), TIPO_AUTO_DESC
FROM gd_esquema.Maestra
WHERE tipo_auto_codigo IS NOT NULL;
GO

EXEC importar_cajas
EXEC importar_motores
EXEC importar_transmisiones
EXEC importar_tipos_autos

select * from LOS_CAPOS.CAJAS
select * from LOS_CAPOS.motores
select * from LOS_CAPOS.transmisiones
select * from LOS_CAPOS.tipos_autos



/*
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_cajas') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE LOS_CAPOS.importar_cajas
END 
*/