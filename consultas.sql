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
insert into empleado values ('66666666', 'raquel aymar', 'Larco', '439', '15076', 'raymar@appsgalore.com', 999999996);

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









