-- Stored Procedures

USE insurance;

DELIMITER $$

-- 1er Stored procedure para buscar por campo (variable 1) y ordenar en forma ascendente los resultados (variable 2).

CREATE PROCEDURE `customer_order` (IN field VARCHAR(50))
BEGIN
	-- Establezco condicional: si el campo es distinto a '' entonces estable la clausula de orden asc
    IF field <> '' THEN
		SET @field_order = CONCAT(' ORDER BY ', field);
	-- Si el campo es nada o distinto al nombre de un campo entonces no hay clausula de orden y termina el SP.
    ELSE
		SET @field_order = '';
	END IF;
	-- Cerramos la condicional y si se ingresa un campo, le pedimos nos ordene todos los registros segun el campo ingresado y la clausula de orden.
    SET @order = CONCAT('SELECT * FROM customer', @field_order);
	PREPARE runSQL FROM @order;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL;
END$$

-- 2do Stored procedure para insertar datos personales de un nuevo cliente verificando que no se haya registrado previamente verificando su email.

-- Primero establecemos los parametros a ingresar (igual a customer table description)
CREATE PROCEDURE `insert_customer` (f_name VARCHAR(50), l_name VARCHAR(50), gen CHAR(1), social CHAR(11), birth DATE, emailc VARCHAR(100))
BEGIN
	-- Declaramos valores para verificar si el customer ya existe (1 o 0) y valor 'id'.
	DECLARE customer_exists INT;
    DECLARE id INT;
    -- Para verificar que el email ingresado es unico, creamos una subconsulta en la que contamos el customer que tenga el mismo email ingresado. 
    -- El count puede va a ser 1 (existe) o 0 (no existe).
    SET customer_exists = (SELECT COUNT(*) FROM insurance.customer WHERE emailc = email);
    -- Creamos un condicional para que inserte los datos ingresados en la tabla customer si el customer no existe (0)
    IF customer_exists = 0 THEN
		INSERT INTO insurance.customer (first_name, last_name, gender, ssn, dob, email) VALUES (f_name, l_name, gen, social, birth, emailc);
        SET id = LAST_INSERT_ID();
    -- Si existe (email ya fue ingresado) count = 1 entonces ese registro no se inserta y da '0'.
    ELSE
		SET id = 0;
    END IF;
    -- Cerramos la condicional y le pedimos que nos traiga el nuevo id creado (en caso de no existir [0]) o id 0 si ya existia.
	SELECT id;
END$$

-- 3er Stored procedure para buscar un customer ya sea por nombre, apellido, social security number, o email.
-- La busqueda puede ser incompleta y trae todos los registros que contengan la busqueda.
-- Me resulta mas util que el 1er SP y es una busqueda mas real.

CREATE PROCEDURE `search_customer` (search VARCHAR(100))
BEGIN
	SELECT first_name, last_name, gender, ssn, dob, email FROM customer WHERE
	first_name LIKE CONCAT('%',search,'%') OR
	last_name LIKE CONCAT('%',search,'%') OR
	ssn LIKE CONCAT('%',search,'%') OR
	email LIKE CONCAT('%',search,'%');
END$$

DELIMITER ;





