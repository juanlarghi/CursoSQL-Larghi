-- sublenguaje TCL - Entrega nro 12

SELECT @@AUTOCOMMIT;

SET AUTOCOMMIT = 0;

#1 Eliminacion de registros - transaccion: Elimina las direcciones donde trabajan los agentes.

USE insurance;

START TRANSACTION;
DELETE FROM
address
WHERE
property_id IS NULL;

SELECT * FROM address
ORDER BY agent_id;

-- ROLLBACK;
-- COMMIT;

#2 Insercion de registros - transaccion:

USE insurance;

START TRANSACTION;
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('John', 'Lemon', 'M', '678-67-5553', '1995-08-15', 'johnlemon@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Emilly', 'Phillips', 'F', '558-44-7376', '1988-05-22', 'emphillips@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Jeniffer', 'Davis', 'F', '622-33-5775', '1995-10-02', 'jdavis02@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Matthew', 'Thomas', 'M', '634-12-5232', '1986-05-08', 'mattthomas@gmail.com');
SAVEPOINT batch1;
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Jerry', 'Maguire', 'M', '223-34-9577', '1995-06-10', 'jerrymag@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('David', 'Harrison', 'M', '348-44-7788', '1999-08-24', 'davidh99@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Eddie', 'Johnson', 'M', '626-23-5456', '1997-11-24', 'johnsonedd@gmail.com');
INSERT INTO customer (first_name, last_name, gender, ssn, dob, email) VALUES ('Eric', 'Smith', 'M', '639-22-7678', '1987-04-04', 'smith87@gmail.com');
SAVEPOINT batch2;
ROLLBACK TO batch1;
-- RELEASE SAVEPOINT batch1;
-- COMMIT;

SELECT * FROM customer;


