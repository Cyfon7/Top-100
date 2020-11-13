-- DESAFIO TOP 100
-- 1.- Crear base de datos llamada películas
CREATE DATABASE peliculas;

-- 2.- Revisar los archivos peliculas.csv y reparto.csv, crear tablas:
-- * Tabla peliculas
CREATE TABLE peliculas (
    id INT,
    titulo VARCHAR(255),
    año_estreno INT,
    director VARCHAR(50),
    PRIMARY KEY (id)
);
-- * Tabla reparto
CREATE TABLE repartos (
    peliculas_id INT,
    actor VARCHAR(255),
    FOREIGN KEY (peliculas_id) REFERENCES peliculas(id)
);

-- 3.- Cargar ambos archivos a su tabla correspondiente
-- * Archivo peliculas
\copy peliculas FROM './peliculas.csv' csv header

-- * Archivo reparto
\copy repartos FROM './reparto.csv' csv

-- 4.- Listar todos los actores de 'Titanic', indicando:
--     Titulo de la película
--     Año de estreno
--     Director
--     Todo el reparto
SELECT titulo, año_estreno, director, actor
--INNER JOIN no toma valores vacios
FROM peliculas INNER JOIN repartos                                         
ON peliculas.id = repartos.peliculas_id 
WHERE titulo = 'Titanic';

-- 5.- Listar los titulos de las películas donde actúe:
-- * Harrison Ford
SELECT titulo --, actor
FROM peliculas INNER JOIN repartos
ON peliculas.id = repartos.peliculas_id
WHERE actor = 'Harrison Ford';

-- 6.- Listar los 10 directores mas populares, indicando:
-- * Nombre de Director
-- * En cuantas peliculas aparecen
SELECT director, count(*) as pelis_realizadas
FROM peliculas 
GROUP BY director 
ORDER BY pelis_realizadas DESC
LIMIT 10;

-- 7.- Indicar cuantos actores distintos hay
SELECT count(*) as cantidad_de_actores    -- Inspired by slack memes xD
--     Subquery que genera tabla donde se eliminaron
--     los nombres repetidos de actores
FROM (
    SELECT DISTINCT actor
    FROM repartos
) as actores;

-- 8.- Indicar las peliculas estrenadas entre 1990 y 1999 (incluidos)
--     Ordenadas por titulo de manera ascendente
SELECT titulo--, año_estreno
FROM peliculas
WHERE (año_estreno >= 1990 AND año_estreno <= 1999)
ORDER BY titulo ASC;

-- 9.- Listar reparto de peliculas lanzadas en el año 2001
SELECT actor--, año_estreno
FROM repartos INNER JOIN peliculas
ON repartos.peliculas_id = peliculas.id
WHERE año_estreno = 2001
ORDER BY actor ASC;

-- 10.- Listar los actores de la pelicula más nueva
SELECT actor--, año_estreno
FROM repartos INNER JOIN peliculas
ON repartos.peliculas_id = peliculas.id
-- Subquery que obtiene el valor maximo de la colummna
-- para poder usar el valor en la condicion
WHERE año_estreno = (          
    SELECT max(año_estreno)
    FROM peliculas
)
ORDER BY actor ASC;
