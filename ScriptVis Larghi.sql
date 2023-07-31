-- Creacion de vistas


-- Contact_info: Asigna al id el prefijo A para agent y C para customer. Tambien inluye el numero de telefono de tabla 'directory' y trae solo los telefonos que son primarios.

USE insurance;

CREATE OR REPLACE VIEW `contact_info` AS
SELECT CONCAT('C', c.customer_id) AS id, c.first_name, c.last_name, c.email, d.phone_number, d.primary_phone
FROM insurance.customer c
INNER JOIN insurance.directory d ON c.customer_id = d.customer_id
	UNION
SELECT CONCAT('A', a.agent_id) AS id, a.first_name, a.last_name, a.email, d.phone_number, d.primary_phone
FROM insurance.agent a
INNER JOIN insurance.directory d ON a.agent_id = d.agent_id;

CREATE OR REPLACE VIEW `primary_contact_info` AS
SELECT id, first_name, last_name, email, phone_number FROM `contact_info`
WHERE primary_phone = 1
ORDER BY last_name ASC;

-- Incident_filter: visualiza incidentes en autos y los cientes que tuvieron la culpa del incidente y la compañia tiene que cubrir.

CREATE OR REPLACE VIEW `vehicle_incidents` AS
SELECT i.report_number, v.customer_id, i.vehicle_id, i.incident_type, i.incident_date, i.damage_estimate
FROM insurance.incident i
JOIN insurance.vehicle v ON i.vehicle_id = v.vehicle_id
WHERE at_fault = 1;

-- Incident_filter: visualiza incidentes en propiedades que la compañia tiene que cubrir.

CREATE OR REPLACE VIEW `property_incidents` AS
SELECT i.report_number, p.customer_id, i.property_id, i.incident_type, i.incident_date, i.damage_estimate
FROM insurance.incident i
JOIN insurance.property p ON i.property_id = p.property_id
WHERE i.property_id IS NOT NULL;

-- Polizas vencidas. Indiacan al agente que polizas necesitan renovacion.

CREATE OR REPLACE VIEW `policy_overdue` AS
SELECT p.policy_id, x.customer_id, p.policy_category, p.expire_date
FROM insurance.policy p
JOIN insurance.property x ON p.property_id = x.property_id
WHERE p.policy_active = 0
	UNION
SELECT p.policy_id, y.customer_id, p.policy_category, p.expire_date
FROM insurance.policy p
JOIN insurance.vehicle y ON p.vehicle_id = y.vehicle_id
WHERE p.policy_active = 0;








 