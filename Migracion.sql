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
EXEC sp_fkeys 'LOS_CAPOS.MODELOS'
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

IF OBJECT_ID('LOS_CAPOS.ITEMS_FACTURAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.ITEMS_FACTURAS;
CREATE TABLE LOS_CAPOS.ITEMS_FACTURAS (
	id_item INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	precio_unitario_facturado decimal(18,2),
	precio_total_facturado decimal(18,2),
	cant_facturada decimal(18,0),
	id_factura int,
	id_autoparte int,
	id_auto int
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
);

IF OBJECT_ID('LOS_CAPOS.AUTOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.AUTOS;
CREATE TABLE LOS_CAPOS.AUTOS (
	id_auto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	auto_nro_chasis nvarchar(255),
	auto_nro_motor nvarchar(255),
	auto_patente nvarchar(255),
	auto_fecha_alta datetime2(3),
	auto_cant_kms decimal(18,0),
	en_stock bit,
	id_modelo int,
	id_motor int,
	id_caja int,
	id_transmision int,
	id_tipo_auto int
);
/*
IF OBJECT_ID('LOS_CAPOS.MODELOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.MODELOS;
CREATE TABLE LOS_CAPOS.MODELOS (
	id_modelo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	modelo_codigo decimal(18,0),
	modelo_nombre nvarchar(255),
	modelo_potencia decimal(18,0),
	fabricante_nombre nvarchar(255)
);*/

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

IF OBJECT_ID('LOS_CAPOS.ITEMS_COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.ITEMS_COMPRAS;
CREATE TABLE LOS_CAPOS.ITEMS_COMPRAS (
	id_item INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	compra_cant decimal(18,0),
	compra_precio_unitario decimal(18,2),
	compra_precio_total decimal(18,2),
	id_autoparte int,
	id_auto int,
	id_compras int
);

IF OBJECT_ID('LOS_CAPOS.COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.COMPRAS;
CREATE TABLE LOS_CAPOS.COMPRAS (
	id_compras INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	compra_nro decimal(18,0),
	compra_fecha datetime2(3),
	id_sucursal int,
	id_clientes_compras int,
);

IF OBJECT_ID('LOS_CAPOS.CLIENTES_COMPRAS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.CLIENTES_COMPRAS;
CREATE TABLE LOS_CAPOS.CLIENTES_COMPRAS (
	id_clientes_compras INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cliente_c_apellido  nvarchar(255),
	cliente_c_nombre nvarchar(255),
	cliente_c_dni decimal(18,0),
	cliente_c_mail nvarchar(255),
	cliente_fecha_nac datetime2(3),
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

/** AGREGAMOS FKs**/

ALTER TABLE LOS_CAPOS.AUTOPARTES
	ADD FOREIGN KEY (id_modelo) REFERENCES LOS_CAPOS.MODELOS(id_modelo)

ALTER TABLE LOS_CAPOS.AUTOS
 	ADD 
		FOREIGN KEY (id_motor) REFERENCES LOS_CAPOS.MOTORES(id_motor),
     	FOREIGN KEY (id_caja) REFERENCES LOS_CAPOS.CAJAS(id_caja),
     	FOREIGN KEY (id_transmision) REFERENCES LOS_CAPOS.TRANSMISIONES(id_transmision),
     	FOREIGN KEY (id_tipo_auto) REFERENCES LOS_CAPOS.TIPOS_AUTOS(id_tipo_auto),
		FOREIGN KEY (id_modelo) REFERENCES LOS_CAPOS.MODELOS(id_modelo)
		
ALTER TABLE LOS_CAPOS.CLIENTES_VENTAS
	ADD FOREIGN KEY (id_factura) REFERENCES  LOS_CAPOS.FACTURAS(id_factura)

ALTER TABLE LOS_CAPOS.ITEMS_FACTURAS
	ADD FOREIGN KEY (id_autoparte) REFERENCES LOS_CAPOS.AUTOPARTES(id_autoparte),
    	FOREIGN KEY (id_auto) REFERENCES LOS_CAPOS.AUTOS(id_auto),
		FOREIGN KEY (id_factura) REFERENCES LOS_CAPOS.FACTURAS(id_factura)

ALTER TABLE LOS_CAPOS.COMPRAS
	ADD FOREIGN KEY (id_sucursal) REFERENCES LOS_CAPOS.SUCURSALES(id_sucursal),
		FOREIGN KEY (id_clientes_compras) REFERENCES LOS_CAPOS.CLIENTES_COMPRAS(id_clientes_compras)

ALTER TABLE LOS_CAPOS.ITEMS_COMPRAS
	ADD FOREIGN KEY (id_compras) REFERENCES LOS_CAPOS.COMPRAS(id_compras)

/***** CREACION DE PROCEDURES PARA IMPORTAR INFORMACION DE TABLA MAESTRA ****/

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_motores') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_motores
GO
CREATE PROCEDURE LOS_CAPOS.importar_motores AS
INSERT INTO LOS_CAPOS.MOTORES (tipo_motor_codigo)
SELECT DISTINCT(tipo_motor_codigo)
FROM gd_esquema.Maestra
WHERE tipo_motor_codigo IS NOT NULL;
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_cajas') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_cajas
GO
CREATE PROCEDURE LOS_CAPOS.importar_cajas AS
INSERT INTO LOS_CAPOS.CAJAS (TIPO_CAJA_CODIGO, TIPO_CAJA_DESC)
SELECT DISTINCT(TIPO_CAJA_CODIGO), TIPO_CAJA_DESC
FROM gd_esquema.Maestra
WHERE TIPO_CAJA_CODIGO IS NOT NULL;
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_transmisiones') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_transmisiones
GO
CREATE PROCEDURE LOS_CAPOS.importar_transmisiones AS
INSERT INTO LOS_CAPOS.TRANSMISIONES (TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC)
SELECT DISTINCT(TIPO_TRANSMISION_CODIGO), TIPO_TRANSMISION_DESC
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL;
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_tipos_autos') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_tipos_autos
GO
CREATE PROCEDURE LOS_CAPOS.importar_tipos_autos AS
INSERT INTO LOS_CAPOS.TIPOS_AUTOS (tipo_auto_codigo, tipo_auto_desc)
SELECT DISTINCT(tipo_auto_codigo), TIPO_AUTO_DESC
FROM gd_esquema.Maestra
WHERE tipo_auto_codigo IS NOT NULL;
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_modelos') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_modelos
GO
CREATE PROCEDURE LOS_CAPOS.importar_modelos AS
INSERT INTO LOS_CAPOS.MODELOS (modelo_codigo, modelo_nombre, modelo_potencia, fabricante_nombre)
SELECT DISTINCT(modelo_codigo), modelo_nombre, modelo_potencia, fabricante_nombre
FROM gd_esquema.Maestra
WHERE modelo_codigo IS NOT NULL;
GO

--EJECUTAMOS PROCEDURES
EXEC LOS_CAPOS.importar_cajas
EXEC LOS_CAPOS.importar_motores
EXEC LOS_CAPOS.importar_transmisiones
EXEC LOS_CAPOS.importar_tipos_autos
EXEC LOS_CAPOS.importar_modelos

/* Autopartes */
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_autopartes') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_autopartes
GO
CREATE PROCEDURE LOS_CAPOS.importar_autopartes AS
INSERT INTO LOS_CAPOS.AUTOPARTES (autoparte_codigo, autoparte_descripcion)
SELECT DISTINCT(auto_parte_codigo), auto_parte_descripcion
FROM gd_esquema.Maestra
WHERE auto_parte_codigo IS NOT NULL;
GO

EXEC LOS_CAPOS.importar_autopartes
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_autos') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_autos
GO
CREATE PROCEDURE LOS_CAPOS.importar_autos AS
INSERT INTO LOS_CAPOS.AUTOS(auto_nro_chasis, auto_nro_motor, auto_patente, auto_fecha_alta, auto_cant_kms, id_modelo, id_motor, id_caja, id_transmision, id_tipo_auto)
SELECT DISTINCT AUTO_NRO_CHASIS, AUTO_NRO_MOTOR, auto_patente, auto_fecha_alta, auto_cant_kms, id_modelo, id_motor, id_caja, id_transmision, id_tipo_auto
FROM (SELECT DISTINCT m.AUTO_NRO_CHASIS, m.AUTO_NRO_MOTOR, m.auto_patente, m.auto_fecha_alta, m.auto_cant_kms
		, LCMOD.id_modelo, LCMOT.id_motor, LCCJ.id_caja, LCTR.id_transmision, LCTA.id_tipo_auto
	  FROM gd_esquema.Maestra m
	  INNER JOIN LOS_CAPOS.MODELOS LCMOD ON LCMOD.modelo_codigo = m.MODELO_CODIGO
	  INNER JOIN LOS_CAPOS.MOTORES LCMOT ON LCMOT.tipo_motor_codigo = m.TIPO_MOTOR_CODIGO
	  INNER JOIN LOS_CAPOS.CAJAS LCCJ ON LCCJ.tipo_caja_codigo = m.TIPO_CAJA_CODIGO
	  INNER JOIN LOS_CAPOS.TRANSMISIONES LCTR ON LCTR.tipo_transmision_codigo = m.TIPO_TRANSMISION_CODIGO
	  INNER JOIN LOS_CAPOS.TIPOS_AUTOS LCTA ON LCTA.tipo_auto_codigo = m.TIPO_AUTO_CODIGO
	  WHERE m.AUTO_NRO_CHASIS IS NOT NULL 
	  AND m.AUTO_NRO_MOTOR IS NOT NULL 
	  AND m.AUTO_PATENTE IS NOT NULL
	  ) AS enM
GO
EXEC LOS_CAPOS.importar_autos
GO
--SELECT distinct auto_nro_motor FROM LOS_CAPOS.AUTOS
--SELECT * FROM LOS_CAPOS.AUTOS
--drop table LOS_CAPOS.AUTOS

IF OBJECT_ID('tempdb..#Modelos_de_Autopartes') IS NOT NULL 
    DROP TABLE #Modelos_de_Autopartes 
GO
SELECT DISTINCT(AUTO_PARTE_CODIGO) as cod_auto_parte, MODELO_CODIGO as cod_modelo
INTO #Modelos_de_Autopartes
FROM gd_esquema.Maestra
GO

IF OBJECT_ID('tempdb..#PK_De_Autopartes') IS NOT NULL 
    DROP TABLE #PK_De_Autopartes 
GO
select ID_MODELO as id_modelo, ap.cod_auto_parte as id_parte
INTO #PK_De_Autopartes
FROM LOS_CAPOS.MODELOS as m
JOIN #Modelos_de_Autopartes ap ON (m.modelo_codigo = ap.cod_modelo)

UPDATE LOS_CAPOS.AUTOPARTES 
SET id_modelo = (SELECT id_modelo FROM #PK_De_Autopartes WHERE autoparte_codigo = id_parte)

/******************** CLIENTES COMPRAS *************************/
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_clientes_compras') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_clientes_compras
GO
CREATE PROCEDURE LOS_CAPOS.importar_clientes_compras AS
INSERT INTO LOS_CAPOS.CLIENTES_COMPRAS(cliente_c_dni, cliente_c_apellido, cliente_c_nombre,  cliente_c_mail, cliente_fecha_nac)
SELECT DISTINCT(m.CLIENTE_DNI), m.CLIENTE_APELLIDO, m.CLIENTE_NOMBRE, m.CLIENTE_MAIL, m.CLIENTE_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.CLIENTE_DNI IS NOT NULL OR m.CLIENTE_APELLIDO IS NOT NULL;
GO

EXEC LOS_CAPOS.importar_clientes_compras

IF OBJECT_ID('tempdb..#Cliente_comprador') IS NOT NULL 
    DROP TABLE #Cliente_comprador
GO

SELECT m.CLIENTE_DNI, m.COMPRA_NRO, m.CLIENTE_APELLIDO
INTO #Cliente_comprador
FROM gd_esquema.Maestra m
GO

IF OBJECT_ID('tempdb..#NRO_COMPRAxCLIENTE') IS NOT NULL 
    DROP TABLE #NRO_COMPRAxCLIENTE
GO
SELECT distinct(CC.COMPRA_NRO), c.id_clientes_compras, CC.CLIENTE_DNI
INTO #NRO_COMPRAxCLIENTE
FROM LOS_CAPOS.CLIENTES_COMPRAS c
JOIN #Cliente_comprador cc ON c.cliente_c_dni = cc.CLIENTE_DNI AND c.cliente_c_apellido = cc.CLIENTE_APELLIDO
GO

-- SUCURSALES

IF EXISTS (SELECT *  FROM  sysobjects 
           WHERE  id = object_id(N'LOS_CAPOS.importar_sucursales') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_sucursales
GO
CREATE PROCEDURE LOS_CAPOS.importar_sucursales AS
INSERT INTO LOS_CAPOS.SUCURSALES(sucursal_direccion, sucursal_mail, sucursal_telefono, sucursal_ciudad)
SELECT DISTINCT(m.FAC_SUCURSAL_DIRECCION), m.SUCURSAL_MAIL, m.SUCURSAL_TELEFONO, m.SUCURSAL_CIUDAD
FROM gd_esquema.Maestra m
WHERE m.FAC_SUCURSAL_DIRECCION IS NOT NULL
GO
EXEC LOS_CAPOS.importar_sucursales

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_compras') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_compras
GO
CREATE PROCEDURE LOS_CAPOS.importar_compras AS
INSERT INTO LOS_CAPOS.COMPRAS(compra_nro, compra_fecha)
SELECT DISTINCT(m.COMPRA_NRO), COMPRA_FECHA
FROM gd_esquema.Maestra m
WHERE m.COMPRA_NRO IS NOT NULL
GO
EXEC LOS_CAPOS.importar_compras

IF OBJECT_ID('tempdb..#Direccion_De_Compra') IS NOT NULL 
    DROP TABLE #Direccion_De_Compra
GO
SELECT m.COMPRA_NRO, m.COMPRA_FECHA, m.SUCURSAL_DIRECCION, m.SUCURSAL_CIUDAD, m.SUCURSAL_TELEFONO
INTO #Direccion_De_Compra
FROM gd_esquema.Maestra m

UPDATE LOS_CAPOS.COMPRAS  
  SET id_sucursal = (SELECT distinct(s.id_sucursal)
					 FROM #Direccion_De_Compra dc
					 JOIN LOS_CAPOS.SUCURSALES s on dc.SUCURSAL_CIUDAD = s.sucursal_ciudad AND
													dc.SUCURSAL_DIRECCION = s.sucursal_direccion
					 WHERE dc.COMPRA_NRO = LOS_CAPOS.COMPRAS.compra_nro)

UPDATE LOS_CAPOS.COMPRAS
	SET LOS_CAPOS.COMPRAS.id_clientes_compras = (SELECT ncc.id_clientes_compras
												 FROM #NRO_COMPRAxCLIENTE ncc
												 WHERE LOS_CAPOS.COMPRAS.compra_nro = ncc.COMPRA_NRO)
GO

--> --> -->  ITEMS COMPRAS <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <--

IF EXISTS (SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_items_compras') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_items_compras
GO
CREATE PROCEDURE LOS_CAPOS.importar_items_compras AS
INSERT INTO LOS_CAPOS.ITEMS_COMPRAS(compra_cant, compra_precio_unitario, compra_precio_total, id_compras, id_autoparte, id_auto)
SELECT COMPRA_CANT, COMPRA_PRECIO, COMPRA_PRECIO, id_compras, id_autoparte, id_auto
FROM (SELECT m.COMPRA_NRO, m.COMPRA_CANT, m.COMPRA_PRECIO, LCC.id_compras, LCAP.id_autoparte, LCA.id_auto
	  FROM gd_esquema.Maestra m
		INNER JOIN LOS_CAPOS.COMPRAS LCC ON m.COMPRA_NRO = LCC.compra_nro
		LEFT JOIN LOS_CAPOS.AUTOPARTES LCAP ON m.AUTO_PARTE_CODIGO = LCAP.autoparte_codigo		
		LEFT JOIN LOS_CAPOS.AUTOS LCA ON LCA.auto_patente = M.AUTO_PATENTE
			AND LCA.auto_nro_motor = M.AUTO_NRO_MOTOR
			AND LCA.auto_nro_chasis =M.AUTO_NRO_CHASIS
	  WHERE m.COMPRA_NRO IS NOT NULL AND m.PRECIO_FACTURADO IS NULL
	  ) AS enM
GO
EXEC LOS_CAPOS.importar_items_compras
--SELECT * FROM LOS_CAPOS.ITEMS_COMPRAS

/*

UPDATE LOS_CAPOS.ITEMS_COMPRAS
	SET LOS_CAPOS.ITEMS_COMPRAS.id_autoparte = (SELECT LCAP.id_autoparte
	  FROM gd_esquema.Maestra m		
		LEFT JOIN LOS_CAPOS.AUTOPARTES LCAP ON m.AUTO_PARTE_CODIGO = LCAP.autoparte_codigo
	  WHERE m.COMPRA_NRO IS NOT NULL and m.FACTURA_NRO IS NULL)
GO

SELECT *
FROM LOS_CAPOS.ITEMS_COMPRAS IC
INNER JOIN LOS_CAPOS.AUTOPARTES AP ON IC.id_autoparte = AP.id_autoparte



SELECT *
FROM LOS_CAPOS.AUTOPARTES	*/
/*
SELECT * -- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EL SELECT QUE VA
FROM gd_esquema.Maestra
WHERE COMPRA_NRO IS NOT NULL and COMPRA_PRECIO = 3858303.25

--order by COMPRA_NRO*/

--> --> --> FINAL DE ITEMS COMPRAS <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- <-- 


/******************** VENTAS *************************/


--SELECT *
--FROM LOS_CAPOS.CLIENTES_VENTAS

-----------FACTURAS
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_facturas') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_facturas
GO
CREATE PROCEDURE LOS_CAPOS.importar_facturas AS
INSERT INTO LOS_CAPOS.FACTURAS(factura_nro, factura_fecha, fac_cliente_apellido, fac_cliente_nombre, fac_cliente_direccion,
								 fac_cliente_dni, fac_cliente_fecha_nac, fac_cliente_mail, fac_sucursal_direccion, fac_sucursal_mail,
								 fac_sucursal_telefono, fac_sucursal_ciudad)
SELECT DISTINCT(m.factura_nro), m.factura_fecha, m.fac_cliente_apellido, m.fac_cliente_nombre, m.fac_cliente_direccion,
								 m.fac_cliente_dni, m.fac_cliente_fecha_nac, m.fac_cliente_mail, m.fac_sucursal_direccion, m.fac_sucursal_mail,
								 m.fac_sucursal_telefono, m.fac_sucursal_ciudad
FROM gd_esquema.Maestra m
WHERE m.FAC_CLIENTE_APELLIDO IS NOT NULL
GO
EXEC LOS_CAPOS.importar_facturas

--CLIENTES VENTAS
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_clientes_Ventas') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_clientes_Ventas
GO
CREATE PROCEDURE LOS_CAPOS.importar_clientes_Ventas AS
INSERT INTO LOS_CAPOS.CLIENTES_VENTAS(cliente_v_apellido, cliente_v_nombre, cliente_v_direccion, cliente_v_dni, cliente_v_fecha_nac, cliente_v_mail, id_factura)
SELECT FAC_CLIENTE_APELLIDO, FAC_CLIENTE_NOMBRE, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_FECHA_NAC, FAC_CLIENTE_MAIL, id_factura
FROM (SELECT m.FAC_CLIENTE_APELLIDO, m.FAC_CLIENTE_NOMBRE, m.FAC_CLIENTE_DIRECCION, m.FAC_CLIENTE_DNI, m.FAC_CLIENTE_FECHA_NAC, m.FAC_CLIENTE_MAIL, F.id_factura
	  FROM  gd_esquema.Maestra m
JOIN LOS_CAPOS.FACTURAS F ON (F.factura_nro = m.FACTURA_NRO  AND F.fac_cliente_apellido = m.FAC_CLIENTE_APELLIDO
									AND F.fac_cliente_dni = m.FAC_CLIENTE_DNI AND F.fac_cliente_mail = m.FAC_CLIENTE_MAIL
									AND F.fac_cliente_nombre = m.fac_Cliente_nombre)
	  WHERE F.factura_nro IS NOT NULL) AS enM
GO
EXEC LOS_CAPOS.importar_clientes_Ventas

--SELECT *
--FROM LOS_CAPOS.FACTURAS

-------- ITEM_FACTURAS

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_items_facturas') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_items_facturas
GO
CREATE PROCEDURE LOS_CAPOS.importar_items_facturas AS
INSERT INTO LOS_CAPOS.ITEMS_FACTURAS(precio_total_facturado, cant_facturada, id_autoparte, id_auto, id_factura)
SELECT PRECIO_FACTURADO, CANT_FACTURADA, id_autoparte, id_auto, id_factura
FROM (SELECT M.PRECIO_FACTURADO, M.CANT_FACTURADA, LCAP.id_autoparte, LCA.id_auto, FACT.id_factura
	  FROM gd_esquema.Maestra M
	  LEFT JOIN LOS_CAPOS.AUTOPARTES LCAP ON LCAP.autoparte_codigo = M.AUTO_PARTE_CODIGO
	  LEFT JOIN LOS_CAPOS.AUTOS LCA ON LCA.auto_patente = M.AUTO_PATENTE
		AND LCA.auto_nro_motor = M.AUTO_NRO_MOTOR
		AND LCA.auto_nro_chasis =M.AUTO_NRO_CHASIS
	  right join LOS_CAPOS.FACTURAS FACT ON FACT.factura_nro = m.FACTURA_NRO	
	  WHERE M.FACTURA_NRO IS NOT NULL) AS enM
--WHERE m.PRECIO_FACTURADO IS NOT NULL AND m.CANT_FACTURADA IS NOT NULL
GO

EXEC LOS_CAPOS.importar_items_facturas
GO

UPDATE LOS_CAPOS.ITEMS_FACTURAS
SET precio_unitario_facturado = (SELECT (LOS_CAPOS.ITEMS_FACTURAS.precio_total_facturado / LOS_CAPOS.ITEMS_FACTURAS.cant_facturada) 
	 AS UNITARIO)
GO

UPDATE LOS_CAPOS.ITEMS_COMPRAS
SET compra_precio_unitario = (SELECT (LOS_CAPOS.ITEMS_COMPRAS.compra_precio_total / LOS_CAPOS.ITEMS_COMPRAS.compra_cant) 
	 AS UNITARIO)
GO

UPDATE LOS_CAPOS.AUTOPARTES 
SET en_stock = CASE WHEN
				EXISTS (SELECT ITC.id_autoparte 
				FROM LOS_CAPOS.ITEMS_COMPRAS ITC 
				WHERE LOS_CAPOS.AUTOPARTES.id_autoparte = ITC.id_autoparte)
				AND NOT EXISTS (SELECT ITF.id_autoparte 
				FROM LOS_CAPOS.ITEMS_FACTURAS ITF 
				WHERE LOS_CAPOS.AUTOPARTES.id_autoparte = ITF.id_autoparte)
				THEN 1
				ELSE
				 0
				END;
GO

UPDATE LOS_CAPOS.AUTOS 
SET en_stock = CASE WHEN
				EXISTS (SELECT ITC.id_auto
				FROM LOS_CAPOS.ITEMS_COMPRAS ITC 
				WHERE LOS_CAPOS.AUTOS.id_auto = ITC.id_auto)
				AND NOT EXISTS (SELECT ITF.id_auto 
				FROM LOS_CAPOS.ITEMS_FACTURAS ITF 
				WHERE LOS_CAPOS.AUTOS.id_auto = ITF.id_auto)
				THEN 1
				ELSE
				 0
				END;
GO

/*
SELECT *
FROM gd_esquema.Maestra M
LEFT JOIN LOS_CAPOS.AUTOPARTES LCAP ON LCAP.autoparte_codigo = M.AUTO_PARTE_CODIGO
LEFT JOIN LOS_CAPOS.AUTOS LCA ON LCA.auto_patente = M.AUTO_PATENTE
		AND LCA.auto_nro_motor = M.AUTO_NRO_MOTOR
		AND LCA.auto_nro_chasis =M.AUTO_NRO_CHASIS
WHERE FACTURA_NRO IS NOT NULL*/

-- PARA VER QUE SE LLENEN - DESPUES HAY QUE BORRAR
/*
select * from LOS_CAPOS.CAJAS
select * from LOS_CAPOS.SUCURSALES
select * from LOS_CAPOS.motores
select * from LOS_CAPOS.transmisiones
select * from LOS_CAPOS.tipos_autos
select * from LOS_CAPOS.modelos
select * from LOS_CAPOS.AUTOS
select * from LOS_CAPOS.AUTOPARTES
select * from LOS_CAPOS.CLIENTES_COMPRAS
select * from LOS_CAPOS.COMPRAS
select * from LOS_CAPOS.ITEMS_COMPRAS
select * from LOS_CAPOS.clientes_ventas
SELECT * FROM LOS_CAPOS.Facturas
SELECT * FROM LOS_CAPOS.ITEMS_Facturas
*/

/* HACER ALGO CON PRECIO UNITARIO DE LAS COMPRAS */