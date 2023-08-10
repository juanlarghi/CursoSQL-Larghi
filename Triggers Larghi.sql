-- Triggers 

-- 1er Trigger: creamos un log para guardar registro de claves de usuarios de los agentes de seguro cada vez que se actualiza la clave.

USE insurance;

CREATE TABLE insurance.password_log (
	log_id INT NOT NULL AUTO_INCREMENT,
    task VARCHAR(50) NOT NULL,
    agent_user VARCHAR(15) NOT NULL,
	old_password VARCHAR(64) NOT NULL,
	session_user VARCHAR(15) NOT NULL, 
	change_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id)
);

-- Creamos el trigger con la clausula BEFORE para que haga una copia del usuario y la clave vieja.
-- El password_log registra el tipo de tarea realizada (Cambio de password), usurario, clave vieja, user, y fecha y hora del cambio.

DELIMITER $$

CREATE TRIGGER `before_password_change`
BEFORE UPDATE ON `agent`
FOR EACH ROW
BEGIN
	INSERT INTO `password_log` (task, agent_user, old_password, session_user, change_date)
	VALUES ('Password Changed', OLD.user_name, OLD.password, USER(), NOW());
END$$

DELIMITER ;

-- Test: actualizamos (cambiamos) la clave para el agente cuyo nombre es 'James'.
UPDATE insurance.agent SET password = 'silenthill3' WHERE first_name = 'James';

-- 2do Trigger: Creamos un log para guardar registro historico de los precios de las distintas cobertura. Se registra cada cambio de precio.

CREATE TABLE insurance.price_log (
	log_id INT NOT NULL AUTO_INCREMENT,
    task VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
	old_price DECIMAL(10,2),
	new_price DECIMAL(10,2),
    session_user VARCHAR(15) NOT NULL, 
	change_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id)
);

-- Creamos el trigger con la clausula AFTER para que genere un registro del cambio de precio.
-- El price_log registra el tipo de tarea (Actualizacion de precio), tipo de cobertura, precio viejo, precio nuevo, usuario y fecha y hora.

DELIMITER $$

CREATE TRIGGER `after_price_change`
AFTER UPDATE ON `coverage`
FOR EACH ROW
BEGIN
	INSERT INTO `price_log` (task, type, old_price, new_price, session_user, change_date)
    VALUES ('Price Update', OLD.coverage_type, OLD.price, NEW.price, USER(), NOW());
END$$

DELIMITER ;

-- Test: actualizamos el precio de la cobertura con id 13 a $150. El precio era de $100.
UPDATE insurance.coverage SET price = 150 WHERE coverage_id = 13;

