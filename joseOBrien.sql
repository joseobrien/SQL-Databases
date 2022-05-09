/*
Nombre: José O'Brien
Módulo: Base de datos SQL
Universidad Complutense de Madrid
*/

-- se utiliza el comnando drop database if exists para borrar la bbdd en caso ya existe; luego se procede a crear la bbdd
DROP DATABASE IF EXISTS joseOBrien;
CREATE DATABASE joseOBrien;
USE joseOBrien;

-- se hace lo mismo para las tablas a crear, se borran en caso ya existan y luego se procede a crearlas
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS empresa_servicios;
DROP TABLE IF EXISTS app;
DROP TABLE IF EXISTS tienda;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS contiene;
DROP TABLE IF EXISTS trabaja;
DROP TABLE IF EXISTS descarga;
DROP TABLE IF EXISTS app_categoria;

-- la tabla empleado tiene una clave primaria (dni) y otro campo que no puede estar nulo (nombreE)
CREATE TABLE empleado (
dni char(8),
nombreE varchar(50) not null,
calleE varchar(50),
numeroE char(5),
codigo_postalE char(5),
emailE varchar(100),
telefonoE numeric(9,0),
PRIMARY KEY(dni)
);

-- la tabla empresa_servicios tiene una clave primaria (nombreES) y otro campo que no puede estar nulo (pais_impuestos)
CREATE TABLE empresa_servicios (
nombreES varchar(50),
pais_impuestos varchar(50) not null,
año_creacion year,
emailES varchar(100),
pagina_webES varchar(200),
PRIMARY KEY(nombreES)
);

-- la tabla app tiene una clave primaria (nombreA), otro campo que no puede estar nulo (codigoA) y 2 foreign keys (idEmpresa e idDirigente) las cuales provienen de las tablas empresa_servicios y empleado
CREATE TABLE app (
nombreA varchar(50),
codigoA char(5) not null,
espacio integer,
precio numeric(6,2),
fecha_inicio date,
fecha_fin date,
idEmpresa varchar(50),
idDirigente char(8),
PRIMARY KEY(nombreA),
FOREIGN KEY(idEmpresa) REFERENCES empresa_servicios(nombreES)
	ON DELETE cascade 
    ON UPDATE cascade,
FOREIGN KEY(idDirigente) REFERENCES empleado(dni)
	ON DELETE cascade 
    ON UPDATE cascade 
);
-- se coloca restricción para asegurarnos que la fecha_fin no sea anterior a la fecha_inicio
alter table app add constraint check(fecha_fin>fecha_inicio); 

-- la tabla tienda tiene una clave primaria (nombreT) y otro campo que no puede estar nulo (empresa_gestora)
CREATE TABLE tienda (
nombreT varchar(50),
empresa_gestora varchar(50) not null,
pagina_web varchar(200),
PRIMARY KEY(NombreT)
);

-- la tabla usuario tiene una clave primaria (numero_cuenta) y otro campo que no puede estar nulo (nombreU)
CREATE TABLE usuario (
numero_cuenta char(10),
nombreU varchar(50) not null,
calleU varchar(50),
numeroU numeric(5,0),
ciudadU varchar(50),
codigo_postalU char(5),
paisU varchar(50),
telefonoU numeric(9,0), 
PRIMARY KEY(numero_cuenta)
);

-- la tabla contiene tiene 2 claves primarias que son las foreign keys de las tablas tienda y app
CREATE TABLE contiene (
idTienda varchar(50),
idApp varchar(50),
PRIMARY KEY(idTienda, idApp),
FOREIGN KEY(idTienda) REFERENCES tienda(nombreT) 
	ON DELETE cascade
    ON UPDATE cascade,
FOREIGN KEY(idApp) REFERENCES app(nombreA) 
	ON DELETE cascade
    ON UPDATE cascade
);

-- la tabla trabaja tiene 3 claves primarias que son las foreign keys de las tablas empresa_servicios y empleado, así como la fecha_ingreso
CREATE TABLE trabaja (
idEmpleador varchar(50),
idTrabajador char(8),
fecha_ingreso date not null,
fecha_egreso date,
PRIMARY KEY(idEmpleador, idTrabajador, fecha_ingreso),
FOREIGN KEY(idEmpleador) REFERENCES empresa_servicios(nombreES) 
	ON DELETE cascade 
    ON UPDATE cascade,
FOREIGN KEY(idTrabajador) REFERENCES empleado(dni) 
	ON DELETE cascade 
    ON UPDATE cascade 
);
alter table trabaja add constraint check(fecha_egreso>fecha_ingreso);

-- la tabla descarga tiene 2 claves primarias que son las foreign keys de las tablas app y usuario
CREATE TABLE descarga (
idNombreApp varchar(50),
idUsuario char(10),
fecha_descarga date not null,
puntuacion tinyint,
comentario text,
PRIMARY KEY(idNombreApp, idUsuario),
FOREIGN KEY(idNombreApp) REFERENCES app(nombreA) 
	ON DELETE cascade 
    ON UPDATE cascade,
FOREIGN KEY(idUsuario) REFERENCES usuario(numero_cuenta) 
	ON DELETE cascade 
    ON UPDATE cascade 
);

-- la tabla app-categoria tiene 2 claves primarias, de las cuales una es foreign key de la tablas app 
CREATE TABLE app_categoria (
categoria varchar(50),
idNombreAppCategoria varchar(50),
PRIMARY KEY(categoria, idNombreAppCategoria),
FOREIGN KEY(idNombreAppCategoria) REFERENCES app(nombreA) 
);

-- se crea un trigger para colocar los nombres de los empleados en mayúscula
drop trigger if exists nuevo_empleado;
create trigger nuevo_empleado
before insert on joseobrien.empleado
for each row
set new.nombreE = upper (new.nombreE);

-- carga de datos en la tabla 'empleado' y ' empresa_servicios' a través de la función 'insert into'
INSERT INTO empleado VALUES ('11111111', 'jose obrien', 'Villavicencio', '1219', '15071', 'jobrien@somosapps.com', 999999991);
INSERT INTO empleado VALUES ('22222222', 'katherine yesquen', 'Prescott', '2691', '15072', 'kyesquen@somosapps.com', 999999992);
INSERT INTO empleado VALUES ('33333333', 'jorge zegarra', 'Cornejo', '1010', '15073', 'jzegarra@nuestrasapps.com', 999999993);
INSERT INTO empleado VALUES ('44444444', 'claudia moscoso', 'Vallejo', '222', '15074', 'cmoscoso@appsgalore.com', 999999994);
INSERT INTO empleado VALUES ('55555555', 'roberto reyna', 'Corregidor', '1955', '15075', 'rreyna@nuestrasapps.com', 999999995);

INSERT INTO empresa_servicios(nombreES, pais_impuestos, año_creacion, emailES, pagina_webES)
VALUES ('Somos Apps', 'Peru', 2010, 'general@somosapps.com', 'http://www.somosapps.com');
INSERT INTO empresa_servicios(nombreES, pais_impuestos, año_creacion, emailES, pagina_webES)
VALUES ('Nuestras Apps', 'España', 2010, 'general@nuestrasapps.com', 'http://www.nuestrasapps.com');
INSERT INTO empresa_servicios(nombreES, pais_impuestos, año_creacion, emailES, pagina_webES)
VALUES ('Apps Galore', 'USA', 2010, 'admin@appsgalore.com', 'http://www.appsgalore.com');

/*
Hice el intento de cargar datos a través del comando load data infile pero tuve un error al lanzar el query; sin embargo a continuación detallo el script que utilice.

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/app.csv'
INTO TABLE app
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
;

Cabe mencionar que el resto de los datos fueron cargados a través del Table Data Import Wizard
*/

-- A continuación se detallan las 15 consultas creadas para el proyecto, de las cuales todas fueron validadas correctamente
 
-- Consulta #1: Busca identificar cuantas descargas se realizaron por mes y ordenar los resultados por orden descendiente  
select year(fecha_descarga), month(fecha_descarga), count(*)
from joseobrien.descarga
group by year(fecha_descarga), month(fecha_descarga)
order by count(*) desc;

-- Consulta #2: Busca identificar el país de los usuarios que más aplicaciones se han descargado y ordernar los resultados en orden descendiente
select paisU as pais, count(paisU) as cantidadDescargas
from joseobrien.usuario as u inner join joseobrien.descarga as d on u.numero_cuenta=d.idUsuario
group by pais
order by count(paisU) desc;

-- Consulta #3: Busca identificar la puntuación promedia de todas las apps y ordenar los resultados por orden descendiente  
select idNombreApp as App, avg (puntuacion) as Puntuacion
from joseobrien.descarga
group by idNombreApp
order by avg (puntuacion) desc;

-- Consulta #4: Busca identificar las tiendas de apps que tienen apps con más de 10 descargas y ordenar los resultados por orden descendiente  
select idTienda as Tienda, count(idTienda) as Descargas
from joseobrien.contiene as c inner join joseobrien.descarga as d on c.idApp=d.idNombreApp
group by idTienda
having count(idTienda) > 10
order by count(idTienda) desc;

-- Consulta #5: Busca identificar el app con mayor nivel de ventas (número de descargas multiplicado por precio unitario)  
create view ventasPorApp as
select idNombreApp as App, (count(idNombreApp) * precio) Ventas
from joseobrien.descarga as d inner join joseobrien.app as a on d.idNombreApp=a.nombreA
group by idNombreApp;
select * from ventasPorApp order by Ventas desc limit 1;

-- Consulta #6: Busca identificar los usuarios que descargaron apps en dispositivos que no sean móviles dado que no tienen registrados sus teléfonos, así como el número de descargas correspondientes  
select nombreU as Usuario, count(idNombreApp) as Descargas
from joseobrien.usuario as u inner join joseobrien.descarga as d on u.numero_cuenta=d.idUsuario
where telefonoU is null
group by nombreU
order by Usuario;

-- Consulta #7: Busca generar un trigger que ponga en mayúscula el nombre y apellido de empleados en la tabla "empleado"
drop trigger if exists nuevo_empleado;
create trigger nuevo_empleado
before insert on joseobrien.empleado
for each row
set new.nombreE = upper (new.nombreE);

-- Consulta #8: Busca identificar el app con mayor tiempo de desarrollo  
select nombreA as App, datediff (fecha_fin, fecha_inicio) + 1 as Tiempo_desarrollo
from joseobrien.app
order by Tiempo_desarrollo desc limit 1;

-- Consulta #9: Busca identificar empleados que hayan trabajando para más de 1 una empresa de servicios y el nombre de sus empresas anteriores  
select idTrabajador as Empleado, nombreE as Nombre, idEmpleador as Empresa
from joseobrien.trabaja as t inner join joseobrien.empleado as e on t.idTrabajador=e.dni
where fecha_egreso is not null
order by Nombre;

-- Consulta #10: Busca identificar el promedio de apps que cada empleado dirige
select count(distinct(nombreA)) / count(distinct(idDirigente)) as promedioAppsDirigidas
from joseobrien.app
order by idDirigente;

-- Consulta #11: Busca identificar el país con la mayor cantidad de usuarios que descargan apps
select paisU, cantidadDescargas from
(
    select count(*) as cantidadDescargas, paisU 
    from joseobrien.usuario 
    group by paisU
) tmp
order by cantidadDescargas desc limit 1;

-- Consulta #12: Busca identificar el país con el menor nivel de ventas de apps
select paisU as pais, sum(precio) as ventas
from joseobrien.usuario as u inner join joseobrien.descarga as d on u.numero_cuenta=d.idUsuario
inner join joseobrien.app as a on d.idNombreApp=a.nombreA
group by paisU
order by ventas limit 1; 

-- Consulta #13: Busca identificar las apps que tienen más de una categoría asignadas
select idNombreAppCategoria as App, count(idNombreAppCategoria) as cantidadCategorias
from joseobrien.app_categoria
group by idNombreAppCategoria
having cantidadCategorias > 1;

-- Consulta #14: Busca identificar las tiendas que cuentan con la app con la mejor puntuación promedia 
select idTienda as Tienda
from joseobrien.contiene
where idApp = (
select idNombreApp as App
from joseobrien.descarga
group by App
order by avg (puntuacion) desc limit 1
);

-- Consulta #15: Busca identificar a los usuarios que tienen un promedio más de 1 y menos de 5 y ordernar los resultados por orden descendiente 
select nombreU as Usuario, avg (puntuacion) as Promedio
from joseobrien.usuario as u inner join joseobrien.descarga as d on u.numero_cuenta=d.idUsuario
group by nombreU
having Promedio < 5 and Promedio > 1
order by Promedio desc;