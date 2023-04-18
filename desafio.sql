CREATE DATABASE prueba_sql;

\c prueba_sql;

-- creo tabla peliculas
CREATE TABLE peliculas (
  id INTEGER PRIMARY KEY,
  nombre VARCHAR(255),
  anno INTEGER
);

-- creo tabla tags
CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  tag VARCHAR(32)
);

-- creo tabla intermedia para crear realciones entre las otras dos tablas
CREATE TABLE peliculas_tags (
  pelicula_id INTEGER REFERENCES peliculas(id),
  tag_id INTEGER REFERENCES tags(id),
  PRIMARY KEY (pelicula_id, tag_id)
);

-- inserto los datos en la tabla peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES
  (1, 'Pelicula 1', 2021),
  (2, 'Pelicula 2', 2020),
  (3, 'Pelicula 3', 2019),
  (4, 'Pelicula 4', 2018),
  (5, 'Pelicula 5', 2017);

--inserto los datos en la tabla tags
INSERT INTO tags (id, tag) VALUES
  (1, 'Accion'),
  (2, 'Comedia'),
  (3, 'Drama'),
  (4, 'Ciencia Ficcion'),
  (5, 'Thriller');

-- inserto las relaciones de las peliculas con los tags acomodanome a la solicitud de la prueba
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 4),
  (2, 5);


-- selecciona el id y el nombre de la tabla peliculas.
-- utiliza left join para relacionar tabla peliculas con tabla peliculas_tags
-- despues se utiliza la función count para contar los tag_id asociados a cada pelicula
-- finalmente se agrupa por id y nombre de la pelicula y se ordena por id de la pelicula
SELECT p.id, p.nombre, COUNT(pt.tag_id) AS num_tags
FROM peliculas p
LEFT JOIN peliculas_tags pt ON p.id = pt.pelicula_id
GROUP BY p.id, p.nombre
ORDER BY p.id;

---

-- se crea tabla preguntas
CREATE TABLE preguntas (
  id INTEGER PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);

-- se crea tabla usuarios
CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY,
  nombre VARCHAR(255),
  edad INTEGER
);

-- se crea tabla con claves foraneas para relacionar otras tablas
CREATE TABLE respuestas (
  id INTEGER PRIMARY KEY,
  respuesta VARCHAR(255),
  usuario_id INTEGER REFERENCES usuarios(id),
  pregunta_id INTEGER REFERENCES preguntas(id)
);

-- agregamos datos a tabla usuarios
INSERT INTO usuarios (id, nombre, edad) VALUES
  (1, 'Usuario 1', 25),
  (2, 'Usuario 2', 30),
  (3, 'Usuario 3', 35),
  (4, 'Usuario 4', 40),
  (5, 'Usuario 5', 45);

-- agregamos datos a tabla preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
  (1, '¿Cuál es la capital de Chile?', 'Santiago'),
  (2, '¿Cuál es el río más largo de Chile?', 'Río Loa'),
  (3, '¿Cuál es la unidad monetaria oficial de Chile?', 'Peso chileno'),
  (4, '¿Quién fue la primera mujer en ser presidenta de Chile?', 'Michelle Bachelet'),
  (5, '¿Cuál es el baile nacional de Chile?', 'La Cueca');

-- insertamos valores a tabla respuestas con las condiciones dispuestas en el desafio
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
    (1, 'Santiago', 1, 1),
    (2, 'Santiago', 2, 1),
    (3, 'Río Loa', 3, 2),
    (4, 'Río Maule', 4, 2),
    (5, 'Peso argentino', 5, 3);

-- 06
-- se selecciona el id y el nombre de la tabla usuarios y se cuenta el total de preguntas correctas contando el id de respuestas
-- se realiza un left join entre las tablas usuarios y respuestas.
-- después se hace un inner join entre los resultados y la tabla preguntas, donde se compara que pregunta_id de respuestas sea igual al id de preguntas y que respuesta de tabla respuestas sea igual a respuesta_correcta de tabla preguntas
-- finalmente la consulta agrupa los resultados por id y nombre de ususario y ordena los resultados por el id del usuario
SELECT u.id, u.nombre, COUNT(r.id) AS respuestas_correctas
FROM usuarios u
LEFT JOIN respuestas r ON u.id = r.usuario_id
INNER JOIN preguntas p ON r.pregunta_id = p.id AND r.respuesta = p.respuesta_correcta
GROUP BY u.id, u.nombre
ORDER BY u.id;

-- 07
-- seleccionamos las columnas id y pregunta de la tabla preguntas, se realiza un left join con la tabla respuestas y se condiciona que la pregunta_id en tabla respuestas y que respuesta_correcta de la tabla preguntas sean iguales a respuesta de la tabla respuestas.
-- finalmente se agrupa por id y pregunta de la tabla preguntas y cuenta la cantidad de respuestas por cada pregunta
-- se ordena por id de la pregunta
SELECT p.id, p.pregunta, COUNT(r.id) AS respuestas_correctas
FROM preguntas p
LEFT JOIN respuestas r ON p.id = r.pregunta_id AND p.respuesta_correcta = r.respuesta
GROUP BY p.id, p.pregunta
ORDER BY p.id;

-- 08
-- Eliminar restricción de clave foranea con drop constraint y se agrega la restriccion de la nueva clave foranea con borrado en cascada
ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey FOREIGN KEY (usuario_id)
REFERENCES usuarios(id) ON DELETE CASCADE;
-- eliminamos el primer usuario, y al eliminarlo eliminaremos tambien todas las respuestas asociadas a su usuario.
DELETE FROM usuarios WHERE id = 1;

-- 09
-- para agregar una restricción de edad para que no ingresen usuarios menores de 18 años debemos agregar un check a la columna edad de la tabla usuarios.
ALTER TABLE usuarios
ADD CONSTRAINT edad_minima CHECK (edad >= 18);
-- probamos lo establecido
INSERT INTO usuarios (id, nombre, edad) VALUES
  (6, 'Usuario 6', 17);

-- 10
-- para agregar una nueva columna a la tabla usuarios con la restricción UNIQUE debemos usar ALTER TABLE una vez mas
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;
