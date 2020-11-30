USE GD2C2020
GO

/*Tiempo (año y mes) <-- DE ACÁ SE DESPRENDE QUE HAY QUE SUMARIZAR LA INFORMACIÓN POR MES
Cliente (edad, sexo)
Edad: 18 - 30 años / 31 – 50 años / > 50 años
Sexo: F / M / NULL
SE DESPRENDEN 3*3 = 9 REGISTROS
Sobre estas dimensiones se deberán realizar una serie de VISTAS que deberán <-- DICE ESPECIFICAMENTE VISTAS
proveer, en forma simple desde consultas directas la siguiente información:
Automóviles:
o Cantidad de automóviles, vendidos y comprados x sucursal y mes
o Precio promedio de automóviles, vendidos y comprados.
o Ganancias (precio de venta – precio de compra) x Sucursal x mes
o Promedio de tiempo en stock de cada modelo de automóvil.
o
Autopartes
o Precio promedio de cada autoparte, vendida y comprada.
o Ganancias (precio de venta – precio de compra) x Sucursal x mes
o Promedio de tiempo en stock de cada autoparte.
o Máxima cantidad de stock por cada sucursal (anual)
*/

/* TIPS:
ORDEN:
TABLAS -> INDICES  -> VISTAS  -> FUNCIONES  -> SP  ->TRIGGERS  -> LLENADO DE TABLAS  -> (CREACION DE INDICES?)
PARA SABER LAS FKS DE UNA TABLA:
EXEC sp_fkeys 'AUTOPARTES'
*/

/*********************************** CREACION DE TABLAS ***********************************/

IF OBJECT_ID('LOS_CAPOS.BI_HECHOS_COMPRAS_AUTOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_HECHOS_COMPRAS_AUTOS;

/*********************************** DIMENSIONES ***********************************/

/**** DIMENSION TIEMPO *****/

IF OBJECT_ID('LOS_CAPOS.BI_TIEMPO', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_TIEMPO;
CREATE TABLE LOS_CAPOS.BI_TIEMPO (
	id_tiempo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tiempo_mes nvarchar(255),
	/*tiempo_bimestre nvarchar(255),
	tiempo_trimestre nvarchar(255),
	tiempo_cuatrimestre nvarchar(255),
	tiempo_semestre nvarchar(255),*/
	tiempo_anio nvarchar(255),
	/*tiempo_quinquenio nvarchar(255)*/
);

/**** DIMENSION CLIENTES CPRAS *****/

IF OBJECT_ID('LOS_CAPOS.BI_CLIENTES_C', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_CLIENTES_C;
CREATE TABLE LOS_CAPOS.BI_CLIENTES_C (
	id_cliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cliente_sexo nvarchar(255),
	cliente_franja_edad nvarchar(255)
);

/**** DIMENSION CLIENTES VTAS *****/

IF OBJECT_ID('LOS_CAPOS.BI_CLIENTES_V', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_CLIENTES_V;
CREATE TABLE LOS_CAPOS.BI_CLIENTES_V (
	id_cliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cliente_sexo nvarchar(255),
	cliente_franja_edad nvarchar(255)
);

/**** DIMENSION AUTOS*****/

IF OBJECT_ID('LOS_CAPOS.BI_DIMENSION_AUTOS', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_DIMENSION_AUTOS;
CREATE TABLE LOS_CAPOS.BI_DIMENSION_AUTOS (
	id_auto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	tipo_motor_desc nvarchar(255),
	tipo_transmision_desc nvarchar(255),
	tipo_caja_descripcion nvarchar(255),
	tipo_auto_desc nvarchar(255),
	fabricante_nombre nvarchar(255),
	modelo_nombre nvarchar(255),
	cantidad_cambios int,
	potencia nvarchar(255),

);

/**** DIMENSION AUTOPARTES*****/

IF OBJECT_ID('LOS_CAPOS.BI_DIMENSION_AUTOPARTES', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_DIMENSION_AUTOPARTES;
CREATE TABLE LOS_CAPOS.BI_DIMENSION_AUTOPARTES (
	id_autoparte INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	autoparte_descripcion nvarchar(255),
	categoria nvarchar(255),
	rubro_autoparte nvarchar(255),
	fabricante_nombre nvarchar(255),
	modelo_nombre nvarchar(255),
	potencia nvarchar(255),
);


/**** DIMENSION SUCURSALES*****/

IF OBJECT_ID('LOS_CAPOS.BI_DIMENSION_SUCURSAL', 'U') IS NOT NULL
  DROP TABLE LOS_CAPOS.BI_DIMENSION_SUCURSAL;
CREATE TABLE LOS_CAPOS.BI_DIMENSION_SUCURSAL (
	id_sucursal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	sucursal_direccion nvarchar(255),
	sucursal_ciudad nvarchar(255),
);


/*********************************** HECHOS ***********************************/

/**** HECHOS COMPRAS AUTOS *****/

CREATE TABLE LOS_CAPOS.BI_HECHOS_COMPRAS_AUTOS (
	id_sucursal INT NOT NULL FOREIGN KEY REFERENCES LOS_CAPOS.BI_DIMENSION_SUCURSAL(id_sucursal),
	id_auto INT NOT NULL FOREIGN KEY REFERENCES LOS_CAPOS.BI_DIMENSION_AUTOS(id_auto),
	id_cliente_compra INT NOT NULL  FOREIGN KEY REFERENCES LOS_CAPOS.BI_CLIENTES_C(id_cliente),
	compra_cant decimal(18,0),
	compra_precio_unitario decimal(18,2),
	compra_precio_total decimal(18,2),
	id_hecho INT NOT NULL IDENTITY(1,1)
PRIMARY KEY,
	--PRIMARY KEY(  id_sucursal, id_auto, id_cliente_compra ) ,
);



/*********************************** IMPORT FUNCTIONS ***********************************/


/************** IMPORTAR CLIENTES COMPRAS **************/

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.calcularFranjaEdad') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 0 )
	DROP FUNCTION LOS_CAPOS.calcularFranjaEdad
GO
CREATE FUNCTION LOS_CAPOS.calcularFranjaEdad(@edad decimal) RETURNS nvarchar(255) AS BEGIN
	IF (@edad >= 18 AND @edad <= 30) 
		RETURN '18 - 30 años'
	
	IF (@edad >= 31 AND @edad <= 50) 
		RETURN '31- 50 años'
	
	IF (@edad > 50) 
	RETURN 'mayoes de 50 años'

	RETURN '-'
END
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.spImportarBIClientes_c') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.spImportarBIClientes_c
GO
CREATE PROCEDURE LOS_CAPOS.spImportarBIClientes_c AS
INSERT INTO LOS_CAPOS.BI_CLIENTES_C (cliente_franja_edad)
		
	SELECT DISTINCT LOS_CAPOS.calcularFranjaEdad (DATEDIFF(year, CC.cliente_fecha_nac, GETDATE()))
	FROM (SELECT cliente_fecha_nac FROM LOS_CAPOS.CLIENTES_COMPRAS) AS CC
	;
GO

EXEC LOS_CAPOS.spImportarBIClientes_c
GO
--SELECT * FROM LOS_CAPOS.BI_CLIENTES_C

/************** CLIENTES VENTAS **************/

IF EXISTS ( SELECT *  FROM   sysobjects
            WHERE  id = object_id(N'LOS_CAPOS.spImportarBIClientes_V') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.spImportarBIClientes_V
GO
CREATE PROCEDURE LOS_CAPOS.spImportarBIClientes_V AS
INSERT INTO LOS_CAPOS.BI_CLIENTES_V (cliente_franja_edad)
	
	SELECT DISTINCT LOS_CAPOS.calcularFranjaEdad (DATEDIFF(year, CV.cliente_v_fecha_nac, GETDATE()))
	FROM (SELECT cliente_v_fecha_nac FROM LOS_CAPOS.CLIENTES_VENTAS) AS CV
	;
GO

EXEC LOS_CAPOS.spImportarBIClientes_V
GO

/*
select * from LOS_CAPOS.clientes_ventas
SELECT * FROM LOS_CAPOS.Facturas
SELECT * FROM LOS_CAPOS.BI_CLIENTES_V
ORDER BY CLIENTE_EDAD
*/

/************** IMPORTAR TIEMPO **************/

IF OBJECT_ID ('tempdb..#FECHA_OPERACIONES') IS NOT NULL
	DROP TABLE #FECHA_OPERACIONES
SELECT * INTO #FECHA_OPERACIONES FROM(
SELECT DISTINCT
DATEADD(MONTH, DATEDIFF(MONTH, 0, compra_fecha), 0) AS fecha_operacion
FROM LOS_CAPOS.COMPRAS
UNION
SELECT DISTINCT
DATEADD(MONTH, DATEDIFF(MONTH, 0, factura_fecha), 0) AS fecha_operacion
FROM  LOS_CAPOS.Facturas
) AS FECHAS
GO
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.importar_tiempo') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.importar_tiempo
GO
CREATE PROCEDURE LOS_CAPOS.importar_tiempo AS
INSERT INTO LOS_CAPOS.BI_TIEMPO (tiempo_mes, tiempo_anio)
SELECT MONTH(fecha_operacion), YEAR(fecha_operacion)
FROM  #FECHA_OPERACIONES
GO

EXEC LOS_CAPOS.importar_tiempo
GO

--SELECT * FROM LOS_CAPOS.BI_TIEMPO

/**** IMPORTAR AUTOS*****/


IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.calcularPotencia') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 0 )
	DROP FUNCTION LOS_CAPOS.calcularPotencia
GO

CREATE FUNCTION LOS_CAPOS.calcularPotencia(@potencia decimal) RETURNS nvarchar(255) AS BEGIN
	IF (@potencia >= 50 AND @potencia <= 150) 
		RETURN '50 - 150 cv'
	
	IF (@potencia >= 151 AND @potencia <= 300) 
		RETURN '151- 300 cv'
	
		IF (@potencia > 300) 
		RETURN '> 300cv'
	
	RETURN '-'
END
GO

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.spImportarAutos') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.spImportarAutos
GO
CREATE PROCEDURE LOS_CAPOS.spImportarAutos AS
INSERT INTO LOS_CAPOS.BI_DIMENSION_AUTOS (tipo_motor_desc,
	tipo_transmision_desc,
	tipo_caja_descripcion,
	tipo_auto_desc,
	fabricante_nombre,
	modelo_nombre,
	potencia)
		
	SELECT  m.tipo_motor_desc, t.tipo_transmision_desc, c.tipo_caja_desc, ta.tipo_auto_desc, md.fabricante_nombre, md.modelo_nombre,
	LOS_CAPOS.calcularPotencia(md.modelo_potencia)
	FROM LOS_CAPOS.AUTOS a
	JOIN LOS_CAPOS.TRANSMISIONES t ON (a.id_transmision = t.id_transmision)
	JOIN LOS_CAPOS.CAJAS c ON (a.id_caja = c.id_caja)
	JOIN LOS_CAPOS.MOTORES m ON (a.id_motor = m.id_motor)
	JOIN LOS_CAPOS.TIPOS_AUTOS ta ON (a.id_tipo_auto = ta.id_tipo_auto)
	JOIN LOS_CAPOS.MODELOS md ON (a.id_modelo = md.id_modelo)
	;
GO

EXEC LOS_CAPOS.spImportarAutos
GO

--select * from LOS_CAPOS.BI_DIMENSION_AUTOS

/**** IMPORTAR AUTOPARTES *****/
--select * from LOS_CAPOS.BI_DIMENSION_AUTOPARTES

IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.spImportarAutopartes') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.spImportarAutopartes
GO
CREATE PROCEDURE LOS_CAPOS.spImportarAutopartes AS
INSERT INTO LOS_CAPOS.BI_DIMENSION_AUTOPARTES (autoparte_descripcion,
	categoria,
	fabricante_nombre,
	modelo_nombre,
	potencia)
		
	SELECT ap.autoparte_descripcion, ap.categoria, md.fabricante_nombre, md.modelo_nombre, LOS_CAPOS.calcularPotencia(md.modelo_potencia)
	FROM LOS_CAPOS.AUTOPARTES ap
	JOIN LOS_CAPOS.MODELOS md ON (ap.id_modelo = md.id_modelo)
	;
GO

EXEC LOS_CAPOS.spImportarAutopartes
GO



/**** IMPORTAR SUCURSALES *****/
IF EXISTS ( SELECT *  FROM   sysobjects 
            WHERE  id = object_id(N'LOS_CAPOS.spImportarSucursales') 
					and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE LOS_CAPOS.spImportarSucursales
GO
CREATE PROCEDURE LOS_CAPOS.spImportarSucursales AS
INSERT INTO LOS_CAPOS.BI_DIMENSION_SUCURSAL(sucursal_direccion, sucursal_ciudad)
		
	SELECT s.sucursal_direccion, s.sucursal_ciudad
	FROM LOS_CAPOS.SUCURSALES s
	;
GO

EXEC LOS_CAPOS.spImportarSucursales
GO

--select * from LOS_CAPOS.BI_DIMENSION_SUCURSAL


INSERT INTO LOS_CAPOS.BI_HECHOS_COMPRAS_AUTOS
(  id_auto, id_cliente_compra, id_sucursal, compra_cant, compra_precio_unitario, compra_precio_total)
SELECT
ISNULL(dim_a.id_auto, 0),
ISNULL(dim_cliente.id_cliente, 0),
ISNULL(dim_suc.id_sucursal, 0),
ISNULL(item.compra_cant, 0),
ISNULL(item.compra_precio_unitario, 0),
ISNULL(item.compra_precio_total, 0)
--SELECT *
FROM LOS_CAPOS.ITEMS_COMPRAS item
--TRAIGO DE LA RDB
INNER JOIN LOS_CAPOS.COMPRAS compras ON (compras.id_compras = item.id_compras)
INNER JOIN LOS_CAPOS.CLIENTES_COMPRAS cliente_compra ON (cliente_compra.id_clientes_compras = compras.id_clientes_compras)
INNER JOIN LOS_CAPOS.SUCURSALES suc ON (compras.id_sucursal = suc.id_sucursal)
INNER JOIN LOS_CAPOS.AUTOS auto ON (auto.id_auto = item.id_auto)
INNER JOIN LOS_CAPOS.MODELOS md	ON (md.id_modelo = auto.id_modelo)
--JOINEO CON LAS DIMENSIONES
INNER JOIN LOS_CAPOS.BI_DIMENSION_AUTOS dim_a ON (dim_a.modelo_nombre = md.modelo_nombre AND dim_a.fabricante_nombre = MD.fabricante_nombre)
INNER JOIN LOS_CAPOS.BI_CLIENTES_C dim_cliente ON (dim_cliente.cliente_franja_edad = LOS_CAPOS.calcularFranjaEdad (DATEDIFF(year, cliente_compra.cliente_fecha_nac, GETDATE())))
INNER JOIN LOS_CAPOS.BI_DIMENSION_SUCURSAL dim_suc ON (dim_suc.sucursal_direccion = suc.sucursal_direccion AND DIM_SUC.sucursal_ciudad = SUC.sucursal_ciudad)
WHERE item.id_auto IS NOT NULL

SELECT DISTINCT id_sucursal, id_auto, id_cliente_compra FROM LOS_CAPOS.BI_HECHOS_COMPRAS_AUTOS
GROUP BY id_sucursal, id_auto, id_cliente_compra
ORDER BY id_auto
select * from LOS_CAPOS.ITEMS_COMPRAS WHERE id_auto IS NOT NULL

/*
select * from LOS_CAPOS.CAJAS
select * from LOS_CAPOS.SUCURSALES
select * from LOS_CAPOS.motores
select * from LOS_CAPOS.transmisiones
select * from LOS_CAPOS.tipos_autos
select * from LOS_CAPOS.modelos
select * from LOS_CAPOS.AUTOS
select * from LOS_CAPOS.AUTOPARTES
select * from LOS_CAPOS.CLIENTES_COMPRAS ORDER BY cliente_fecha_nac
select * from LOS_CAPOS.COMPRAS
select * from LOS_CAPOS.ITEMS_COMPRAS
select * from LOS_CAPOS.clientes_ventas
SELECT * FROM LOS_CAPOS.Facturas
SELECT * FROM LOS_CAPOS.ITEMS_Facturas where id_auto is not null
SELECT * FROM gd_esquema.Maestra WHERE FACTURA_NRO IS NULL
*/