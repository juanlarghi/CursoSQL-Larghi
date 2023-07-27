-- Curso SQL
-- Primera Pre Entrega - Proyecto Final

-- CREACION DE BASE DE DATOS Y TABLAS

CREATE DATABASE insurance;

USE insurance;

CREATE TABLE IF NOT EXISTS insurance.customer (
	customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(50) DEFAULT NULL,
    ssn CHAR(9) NOT NULL UNIQUE,
    dob DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (customer_id),
    INDEX name(first_name, last_name)
    );
    
CREATE TABLE IF NOT EXISTS insurance.agent (
	agent_id INT AUTO_INCREMENT,
    customer_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    user_name VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (agent_id),
    INDEX name(first_name, last_name),
    CONSTRAINT fk_agent_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
CREATE TABLE IF NOT EXISTS insurance.directory (
	phone_id INT AUTO_INCREMENT,
    agent_id INT,
    customer_id INT,
    phone_number CHAR(10) NOT NULL,
    primary_phone TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (phone_id),
    INDEX phone(phone_number),
    CONSTRAINT fk_directory_agent FOREIGN KEY (agent_id) REFERENCES agent(agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_directory_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
	);

CREATE TABLE IF NOT EXISTS insurance.property (
	property_id INT AUTO_INCREMENT,
    customer_id INT NOT NULL,
    fmv DECIMAL(10,2) NOT NULL,
	property_type VARCHAR(50) NOT NULL,
    improvements DECIMAL(10,2) DEFAULT 0,
    details VARCHAR(1000) DEFAULT NULL,
	PRIMARY KEY (property_id),
    CONSTRAINT fk_property_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.vehicle (
	vehicle_id INT AUTO_INCREMENT,
    customer_id INT,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year CHAR(4) NOT NULL,
    plate VARCHAR(7) NOT NULL UNIQUE,
    color VARCHAR(50) NOT NULL,
    doors INT NOT NULL,
    milage INT NOT NULL,
    customization TINYINT(1) NOT NULL DEFAULT 0,
    observations VARCHAR(1000) DEFAULT NULL,
    PRIMARY KEY (vehicle_id),
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.address (
	address_id INT AUTO_INCREMENT,
    agent_id INT,
    property_id INT,
    street_number CHAR(4) NOT NULL,
    street_address VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    PRIMARY KEY (address_id),
    INDEX address(street_address, street_number),
	CONSTRAINT fk_address_agent FOREIGN KEY (agent_id) REFERENCES agent(agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_address_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_address_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.policy (
    policy_id INT AUTO_INCREMENT,
    customer_id INT,
    agent_id INT,
    property_id INT,
    vehicle_id INT,
    policy_category VARCHAR(100) NOT NULL,
    coverage_id INT NOT NULL,
    issued_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    policy_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (policy_id),
    INDEX policy_number (policy_id),
    CONSTRAINT fk_policy_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_agent FOREIGN KEY (agent_id) REFERENCES agent(agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_policy_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_coverage FOREIGN KEY (coverage_id) REFERENCES coverage(coverage_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.accident (
	report_number INT AUTO_INCREMENT,
    property_id INT,
    vehicle_id INT,
    accident_type VARCHAR(50) NOT NULL,
    accident_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(50) NOT NULL,
    accident_record VARCHAR(1000),
    damage_estimate DECIMAL(10,2) NOT NULL,
    at_fault TINYINT(1),
    PRIMARY KEY (report_number),
	CONSTRAINT fk_accident_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_accident_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.coverage (
	coverage_id INT AUTO_INCREMENT,
    coverage_type VARCHAR(50) NOT NULL,
    coverage_desc VARCHAR(500) NOT NULL,
    min_payment DECIMAL(10,2) NOT NULL,
    max_coverage DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (coverage_id)
);

CREATE TABLE IF NOT EXISTS insurance.payment (
	payment_id INT AUTO_INCREMENT,
    customer_id INT,
    policy_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME NOT NULL DEFAULT (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 30 DAY)),
	paid_date DATE,
    payment_method VARCHAR(50) NOT NULL,
    debitorcredit TINYINT NOT NULL,
    additional_info VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (payment_id),
    INDEX invoice_number (payment_id),
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_payment_policy FOREIGN KEY (policy_id) REFERENCES policy (policy_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
    
CREATE TABLE IF NOT EXISTS insurance.license (
	license_id INT AUTO_INCREMENT,
	customer_id INT,
    lic_issued_date DATE NOT NULL,
    lic_expire_date DATE NOT NULL,
    license_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (license_id),
	INDEX driver_license (license_id),
    CONSTRAINT fk_license_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------------------------------------------------------------------------------------------
    
    
