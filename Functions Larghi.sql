-- Funciones personalizadas

USE insurance;

DELIMITER $$

-- Funcion para buscar internamente el id de vehiculo segun su patente

CREATE FUNCTION `vehicle_search` (car_plate VARCHAR(7)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE car_id INT DEFAULT 0;
    SELECT vehicle_id INTO car_id FROM vehicle WHERE plate = car_plate;
    RETURN car_id;
END$$

-- Funcion para calcular la comision de los agentes (5%) por prima minima de cada cobertura ya se auto o propiedad.

-- Los ahi a buscar son: Para autos 11;12;13;14;y15 y para propiedades 21;22;23;24;y25 (se describen en tabla 'coverage'.

CREATE FUNCTION `agents_5%_commission` (policy_coverage_number INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE min_price DECIMAL(10,2) DEFAULT 0;
    DECLARE commission DECIMAL(10,2) DEFAULT 0;
    SELECT price INTO min_price FROM coverage WHERE coverage_id = policy_coverage_number;
    SET commission = min_price*0.05;
    RETURN commission;
END$$

DELIMITER ;