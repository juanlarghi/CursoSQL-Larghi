-- CREACION DE USUARIOS Y PERMISOS EN MYSQL

USE mysql;

# Se crea un usuario para auditoria. Este usuario es exlusivamente para auditores internos de la compañia.
CREATE USER 'audit'@'localhost' IDENTIFIED BY 'abc8482';
-- Se concede al usuario de auditoria solo permisos de lectura para toda la base de datos.
GRANT SELECT ON insurance.* TO 'audit'@'localhost';

# Se crea un usuario de administrador. Este usuario es exclusivamente para gerente general de la compañia.
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'insurance213';
-- Se concede al usuario de gerente general permisos de lectura, insercion y actualizacion para toda la base de datos.
GRANT SELECT, INSERT, UPDATE ON insurance.* TO 'admin'@'localhost';

-- Grants check
SHOW GRANTS for 'audit'@'localhost';

SHOW GRANTS for 'admin'@'localhost';