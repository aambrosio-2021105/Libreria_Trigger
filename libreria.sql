DROP DATABASE IF EXISTS db_trigger_andy_ambrosio;
CREATE DATABASE IF NOT EXISTS db_trigger_andy_ambrosio;
USE db_trigger_andy_ambrosio;

-- CREAR LAS TABLAS --
DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users(
	username VARCHAR(30) NOT NULL,
    pass VARCHAR(30) NOT NULL,
    PRIMARY KEY (username)
);
DROP TABLE IF EXISTS previous_password;
CREATE TABLE IF NOT EXISTS previous_password (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    pass VARCHAR(30) NOT NULL,
	new_pass VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);


DROP TABLE IF EXISTS libros;
CREATE TABLE IF NOT EXISTS libros(
	id INT NOT NULL AUTO_INCREMENT,
    titulos VARCHAR(45),
    autor VARCHAR(45),
    editorial VARCHAR(45),
    precio DECIMAL(6,2),
    stok INT,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS ventas;
CREATE TABLE IF NOT EXISTS ventas(
	id INT NOT NULL AUTO_INCREMENT,
    precio DECIMAL(6,2),
    cantidad INT,
    libro_id INT,
    PRIMARY KEY(id),
    CONSTRAINT fk_ventas_libros
		FOREIGN KEY (libro_id) 
        REFERENCES libros(id)
);

INSERT INTO libros (titulos,autor,editorial,precio,stok)
VALUES("Clear code","Robert C. Martin","Multimedia",194.67,75);

INSERT INTO libros (titulos,autor,editorial,precio,stok)
VALUES("Java para novatos","Voz mediano","Save creative",130.00,10);

INSERT INTO libros (titulos,autor,editorial,precio,stok)
VALUES("Programacion en C","Luis Aguilar","Mc Grail Gill",210.25,8);

INSERT INTO users(username, pass)
VALUES ("josue","12345");

UPDATE users SET pass="admin" WHERE username="josue";
SELECT * FROM users;

DELIMITER $$
DROP TRIGGER IF EXISTS tr_users_before_update $$
CREATE TRIGGER tr_users_before_update
BEFORE UPDATE
ON users
FOR EACH ROW
BEGIN
	INSERT INTO previous_password(username, pass, new_pass)
    VALUES (OLD.username, OLD.pass,NEW.pass);
    
END $$
DELIMITER ;

UPDATE users SET pass="aDmiinn" WHERE username="josue";
SELECT * FROM users;
SELECT * FROM previous_password;

-- nueva conbtraseña 
UPDATE users SET pass="fifu5@" WHERE username="josue";
SELECT * FROM previous_password;


DELIMITER $$
DROP TRIGGER IF EXISTS tr_ventas_before_insert $$
CREATE TRIGGER  tr_ventas_before_insert
BEFORE INSERT
ON ventas
FOR EACH ROW
BEGIN
	UPDATE libros SET stok=stok-NEW.cantidad 
    WHERE NEW.libro_id=libros.id;

END $$
DELIMITER ;

INSERT INTO ventas(precio, cantidad, libro_id)
VALUES (260,2,2);

SELECT * FROM libros;


-- au,emtar el stock cuando se hagan devoluciones
DROP TRIGGER IF EXISTS tr_ventas_before_delete;

DELIMITER $$
CREATE TRIGGER tr_ventas_before_delete
BEFORE DELETE
ON ventas
FOR EACH ROW
BEGIN

	UPDATE libros SET stok=stok + OLD.cantidad 
    WHERE OLD.libro_id=id;

END $$
DELIMITER ;

DELETE FROM ventas WHERE id=1;


SELECT * FROM ventas;
SELECT * FROM libros;





