-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.

-- Crear Base de datos
CREATE DATABASE desafio3_macarena_osses_266;

--\c desafio3_macarena_osses_266;

-- Crear tablas
CREATE TABLE usuarios (
    id SERIAL,
    email VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR,
    rol VARCHAR CHECK (rol IN ('administrador', 'usuario'))
);

INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('valdesr@gmail.com', 'Roberto', 'Valdes', 'usuario'),
('camilag@gmail.com', 'Camila', 'Gutierrez', 'usuario'),
('lopezr@gmail.com', 'Rosa', 'Lopez', 'usuario'),
('gabrielt@gmail.com', 'Gabriel', 'Torres', 'administrador'),
('aoterlo@gmail.com', 'Amanda', 'Oterlo', 'usuario');


CREATE TABLE articulos (
    id SERIAL,
    titulo VARCHAR,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

INSERT INTO articulos (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Disfrutar de la vida','¡Vive alegre y a lo loco, que la vida dura poco!','2024-06-01','2024-06-15', TRUE, 4),
('Los errores que cometemos nos hacen crecer','Una vida aprovechada cometiendo errores no es sólo más honorable, sino que incluso más útil que vivirla haciendo nada','2024-06-30','2024-07-10', TRUE, 4),
('Vivir es el aquí y el ahora','Trata de vivir exclusivamente el día, sin querer resolver el problema de tu vida todo de una sola vez','2024-06-15','2024-06-25', TRUE, 1),
('Experiencias positivas','Cuando naciste, llorabas y todos a tu alrededor sonreían, vive tu vida, arriésgate por un amor si ese es el problema, no le tengas miedo a tus mayores, haz lo que te plazca, cuando tú naciste tú llorabas, vive tu vida de manera tal para que cuando tú te mueras tú te rías y todos alrededor tuyo lloren','2024-07-23','2024-07-31', TRUE, 3),
('El optimismo nos lleva lejos','La vida no es fácil y siendo fácil no es vida porque sin ser difícil entonces no hay vida, lo difícil de la vida es la muerte y sin vida no hay muerte por eso sin ser difícil no hay vida','2024-08-01','2024-08-13', TRUE, NULL);

CREATE TABLE comentarios (
    id SERIAL,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Primer comentario post 1','2024-06-17', 1, 1),
('Segundo comentario post 1','2024-06-20', 2, 1),
('Tercer comentario post 1','2024-06-28', 3, 1),
('Primer comentario post 2','2024-07-18', 1, 2),
('Segundo comentario post 2','2024-07-27', 2, 2);

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

SELECT u.nombre, u.email, a.titulo, a.contenido 
FROM usuarios u INNER JOIN articulos a ON u.id = a.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
--     a. El administrador puede ser cualquier id.

SELECT a.id, a.titulo, a.contenido 
FROM articulos a INNER JOIN usuarios u ON u.id = a.usuario_id 
WHERE u.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
--     a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT u.id, u.email, COUNT(a.id) AS cantidad_post 
FROM usuarios u INNER JOIN articulos a ON u.id = a.usuario_id 
GROUP BY u.id, u.email;

-- 5. Muestra el email del usuario que ha creado más posts.
--     a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email 
FROM usuarios u INNER JOIN articulos a ON u.id = a.usuario_id 
GROUP BY u.email ORDER BY COUNT(a.id) DESC LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT u.id, u.nombre, u.apellido MAX(a.fecha_creacion) AS fecha_ult_post
FROM usuarios u INNER JOIN articulos a ON u.id = a.usuario_id
GROUP BY u.id, u.nombre, u.apellido;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT a.titulo, a.contenido, COUNT(c.id) AS cant_comentarios
FROM articulos a INNER JOIN comentarios c ON a.id = c.post_id
GROUP BY a.titulo, a.contenido ORDER BY cant_comentarios DESC LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT a.titulos, a.contenido, c.contenido, u.email
FROM articulos a INNER JOIN comentarios c ON a.id = c.post_id
INNER JOIN usuarios u ON c.usuario_id = u.id;

-- 9. Muestra el contenido del último comentario de cada usuario

SELECT u.id, u.email, c.contenido AS ultimo_comentario, c.fecha_creacion 
FROM usuarios u JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(c1.fecha_creacion) 
                          FROM comentarios c1
                          WHERE c1.usuario_id = u.id)
ORDER BY u.id;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT u.email 
FROM usuarios u LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email HAVING count(c.usuario_id) = 0;
