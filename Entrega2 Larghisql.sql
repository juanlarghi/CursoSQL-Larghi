-- Curso SQL
-- Alumno: Juan Pablo Larghi
-- 2da Pre-Entrega - Proyecto Final

-- CREACION DE BASE DE DATOS Y TABLAS

CREATE DATABASE insurance;

USE insurance;

CREATE TABLE IF NOT EXISTS insurance.customer (
	customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) DEFAULT NULL,
    ssn CHAR(11) NOT NULL UNIQUE,
    dob DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (customer_id),
    INDEX name(first_name, last_name)
);
    
CREATE TABLE IF NOT EXISTS insurance.agent (
	agent_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    user_name VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (agent_id),
    INDEX name(first_name, last_name)
);
    
CREATE TABLE IF NOT EXISTS insurance.directory (
	phone_id INT AUTO_INCREMENT,
    agent_id INT,
    customer_id INT,
    phone_number VARCHAR(13) NOT NULL,
    primary_phone SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (phone_id),
    INDEX phone(phone_number),
    CONSTRAINT fk_directory_agent FOREIGN KEY (agent_id) REFERENCES agent(agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_directory_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
    
CREATE TABLE IF NOT EXISTS insurance.property (
	property_id INT AUTO_INCREMENT,
    customer_id INT,
    fmv DECIMAL(11,2) NOT NULL,
	property_type VARCHAR(50) NOT NULL,
    improvements DECIMAL(11,2) DEFAULT 0,
    details VARCHAR(1000) DEFAULT NULL,
    primary_residence SMALLINT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (property_id),
    CONSTRAINT fk_property_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.vehicle (
	vehicle_id INT AUTO_INCREMENT,
    customer_id INT,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year CHAR(4) NOT NULL,
    plate VARCHAR(7) NOT NULL UNIQUE,
    color VARCHAR(50) NOT NULL,
    doors INT NOT NULL,
    milage INT NOT NULL,
    customization SMALLINT(1) NOT NULL DEFAULT 0,
    observations VARCHAR(1000),
    PRIMARY KEY (vehicle_id),
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.address (
	address_id INT AUTO_INCREMENT,
    agent_id INT,
    property_id INT,
    street_address VARCHAR(50) NOT NULL,
    street_number CHAR(4) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    PRIMARY KEY (address_id),
    INDEX address(street_address, street_number),
	CONSTRAINT fk_address_agent FOREIGN KEY (agent_id) REFERENCES agent(agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_address_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.coverage (
	coverage_id INT AUTO_INCREMENT,
    coverage_type VARCHAR(50) NOT NULL,
    coverage_desc VARCHAR(500) NOT NULL,
    coverage_price DECIMAL(11,2) NOT NULL,
    max_coverage DECIMAL(11,2) NOT NULL,
	PRIMARY KEY (coverage_id)
);

CREATE TABLE IF NOT EXISTS insurance.policy (
    policy_id INT AUTO_INCREMENT,
    property_id INT,
    vehicle_id INT,
    policy_category VARCHAR(100) NOT NULL,
    coverage_id INT,
    issued_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    total_amount DECIMAL(11,2),
    policy_active SMALLINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (policy_id),
    INDEX policy_number (policy_id),
	CONSTRAINT fk_policy_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_coverage FOREIGN KEY (coverage_id) REFERENCES coverage(coverage_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.incident (
	report_number INT NOT NULL AUTO_INCREMENT,
    property_id INT,
    vehicle_id INT,
    incident_type VARCHAR(50) NOT NULL,
    incident_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    incident_location VARCHAR(100) NOT NULL,
    incident_record VARCHAR(1000),
    damage_estimate DECIMAL(11,2) NOT NULL,
    at_fault SMALLINT(1),
    PRIMARY KEY (report_number),
	CONSTRAINT fk_incident_property FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_incident_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS insurance.payment (
	payment_id INT AUTO_INCREMENT,
    agent_id INT,
    customer_id INT,
    policy_id INT,
    total_amount DECIMAL(11,2) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME NOT NULL DEFAULT (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 30 DAY)),
	paid_date DATE,
    payment_method VARCHAR(50) NOT NULL,
    debitorcredit SMALLINT NOT NULL,
    additional_info VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (payment_id),
    INDEX invoice_number (payment_id),
    CONSTRAINT fk_payment_agent FOREIGN KEY (agent_id) REFERENCES agent (agent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_payment_policy FOREIGN KEY (policy_id) REFERENCES policy (policy_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
    
CREATE TABLE IF NOT EXISTS insurance.license (
	license_id INT AUTO_INCREMENT,
	customer_id INT,
    lic_issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lic_expire_date DATETIME NOT NULL DEFAULT(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 5 YEAR)),
    license_active SMALLINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (license_id),
	INDEX driver_license (license_id),
    CONSTRAINT fk_license_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- SCRIPT DE INSERCION DE DATOS

USE insurance;

INSERT INTO insurance.customer (first_name, last_name, gender, ssn, dob, email)
VALUES
('Boot', 'Bassom', 'M', '279-34-9271', '1995-09-03', 'bbassom0@walmart.com'),
('Hobart', 'Callis', 'M', '614-55-3292', '1987-08-24', 'hcallis1@japanpost.jp'),
('Johannes', 'Seviour', 'M', '649-33-5412', '1985-12-18', 'jseviour2@japanpost.jp'),
('Elston', 'Rowbrey', 'M', '475-02-3768', '1997-06-05', 'erowbrey3@dyndns.org'),
('Katharine', 'Stiling', 'F', '263-82-1306', '1995-05-17', 'kstiling4@g.co'),
('Tabatha', 'Loges', 'F', '146-21-4463', '1982-02-18', 'tloges5@studiopress.com'),
('Charmain', 'McInility', 'F', '426-01-5174', '1993-08-11', 'cmcinility6@exblog.jp'),
('Galvin', 'Ca', 'M', '644-74-7660', '1990-10-19', 'gca7@princeton.edu'),
('Cully', 'Surfleet', 'M', '773-68-9397', '1988-10-18', 'csurfleet8@tripod.com'),
('Wain', 'Leipelt', 'M', '439-85-7526', '1979-01-18', 'wleipelt9@pbs.org'),
('Page', 'Folkard', 'F', '730-24-3604', '1996-05-19', 'pfolkarda@drupal.org'),
('Mahmoud', 'Carnall', 'M', '185-75-7184', '1980-08-28', 'mcarnallb@pagesperso-orange.fr'),
('Granthem', 'Tooby', 'M', '363-85-0196', '1974-03-04', 'gtoobyc@wikispaces.com'),
('Franz', 'Harrisson', 'M', '724-98-5080', '1976-04-19', 'fharrissond@friendfeed.com'),
('Husein', 'Pagen', 'M', '412-81-2221', '1983-01-09', 'hpagene@github.com'),
('Teodor', 'Points', 'M', '161-48-7360', '1995-04-11', 'tpointsf@ycombinator.com'),
('Daryl', 'Achromov', 'F', '231-40-2508', '1997-11-19', 'dachromovg@hao123.com'),
('Gregoor', 'Steptowe', 'M', '566-51-4958', '1980-08-17', 'gsteptoweh@economist.com'),
('Niki', 'Windross', 'M', '321-64-6928', '1976-01-18', 'nwindrossi@jigsy.com'),
('Clem', 'McNae', 'M', '131-21-8328', '1991-02-11', 'cmcnaej@wordpress.com'),
('Alwin', 'Dreye', 'M', '461-78-9439', '1989-07-17', 'adreyek@umn.edu'),
('Shena', 'Nice', 'F', '828-17-0858', '1996-03-01', 'snicel@salon.com'),
('Bobbee', 'Blundon', 'F', '892-54-1459', '1997-01-23', 'bblundonm@mozilla.org'),
('Bartolemo', 'Ricci', 'M', '397-50-8088', '1998-03-09', 'briccin@meetup.com'),
('Astrid', 'Douglas', 'F', '599-84-3227', '1972-11-26', 'adouglaso@trellian.com'),
('Monte', 'Brodeau', 'M', '723-61-7364', '1983-02-23', 'mbrodeaup@unicef.org'),
('Bambie', 'Turfes', 'F', '129-73-5104', '1999-01-07', 'bturfesq@adobe.com'),
('Haze', 'Rubie', 'M', '227-82-4882', '2001-01-21', 'hrubier@posterous.com'),
('Bartholomeus', 'Horribine', 'M', '284-65-7805', '1994-07-14', 'bhorribines@example.com'),
('Saunders', 'Eltone', 'M', '807-34-7218', '1988-03-28', 'seltonet@angelfire.com'),
('Clywd', 'Colgrave', 'M', '413-25-4832', '1994-08-20', 'ccolgraveu@google.pl'),
('Norah', 'Skippen', 'F', '167-27-7683', '1970-03-05', 'nskippenv@smh.com.au'),
('Chev', 'Durram', 'M', '380-02-4402', '1980-05-09', 'cdurramw@nih.gov'),
('Olwen', 'Paffitt', 'F', '593-39-7659', '1989-03-28', 'opaffittx@parallels.com'),
('Goldy', 'Sears', 'F', '851-38-8298', '1983-05-11', 'gsearsy@amazon.com'),
('Agustin', 'Hounsome', 'M', '103-54-0529', '1970-06-02', 'ahounsomez@miibeian.gov.cn'),
('Maxy', 'Hawkslee', 'M', '410-14-6521', '1987-11-17', 'mhawkslee10@jiathis.com'),
('Ebba', 'Gerb', 'F', '596-18-0589', '1971-07-24', 'egerb11@1und1.de'),
('Davie', 'McCaffery', 'M', '408-20-9116', '1988-08-26', 'dmccaffery12@samsung.com'),
('Barth', 'Toland', 'M', '807-70-4339', '1999-02-14', 'btoland13@nifty.com'),
('Gerrard', 'Van der Velde', 'M', '364-27-7792', '1985-04-01', 'gvandervelde14@paypal.com'),
('Ivie', 'Depka', 'F', '282-47-2488', '1991-01-04', 'idepka15@tripadvisor.com'),
('Angela', 'Axon', 'F', '231-69-0538', '1972-07-18', 'aaxon16@oakley.com'),
('Milzie', 'Simkovich', 'F', '573-23-0240', '1993-04-27', 'msimkovich17@altervista.org'),
('Aldwin', 'McLugish', 'M', '524-94-5523', '1993-06-14', 'amclugish18@delicious.com'),
('Norrie', 'Frier', 'F', '763-21-4477', '1974-08-29', 'nfrier19@moonfruit.com'),
('Denney', 'Barthelemy', 'M', '727-08-3434', '1982-12-18', 'dbarthelemy1a@tiny.cc'),
('Stacee', 'Skate', 'M', '515-08-3034', '1977-05-26', 'sskate1b@businessinsider.com'),
('Michaella', 'Laugharne', 'F', '381-22-1643', '1973-07-03', 'mlaugharne1c@ocn.ne.jp'),
('Fernanda', 'Hazell', 'F', '180-17-0327', '1986-08-07', 'fhazell1d@istockphoto.com'),
('Jameson', 'Treen', 'M', '576-18-0656', '1973-11-08', 'jtreen1e@wikimedia.org'),
('Ola', 'Tulloch', 'F', '108-66-0122', '1991-05-07', 'otulloch1f@example.com'),
('Shawn', 'Forrest', 'M', '521-18-7220', '1986-01-28', 'sforrest1g@odnoklassniki.ru'),
('Myrilla', 'Bovis', 'F', '655-04-2451', '1995-07-12', 'mbovis1h@a8.net'),
('Uta', 'Scragg', 'F', '272-05-6513', '1988-02-21', 'uscragg1i@usatoday.com'),
('Gearard', 'Tomaselli', 'M', '339-13-9993', '1981-04-04', 'gtomaselli1j@ibm.com'),
('Shay', 'Winter', 'M', '248-71-7009', '1974-07-12', 'swinter1k@census.gov'),
('Mureil', 'Sterzaker', 'F', '525-36-8271', '1985-01-21', 'msterzaker1l@guardian.co.uk'),
('Langston', 'Moss', 'M', '283-67-8684', '1977-01-26', 'lmoss1m@squarespace.com'),
('Vincenz', 'Tomsa', 'M', '600-66-1819', '1973-10-07', 'vtomsa1n@amazonaws.com'),
('Joseito', 'Tarply', 'M', '773-93-9690', '2000-12-22', 'jtarply1o@macromedia.com'),
('Bobbie', 'Dorrity', 'M', '777-89-6382', '1982-11-27', 'bdorrity1p@technorati.com'),
('Mateo', 'Rolley', 'M', '247-23-6384', '2002-02-08', 'mrolley1q@earthlink.net'),
('Sigismundo', 'Sharphurst', 'M', '453-97-1805', '1971-05-23', 'ssharphurst1r@ebay.com'),
('Claudelle', 'Ferns', 'F', '509-05-3328', '1993-08-01', 'cferns1s@blogtalkradio.com'),
('Brice', 'Braney', 'M', '462-47-6436', '1983-08-12', 'bbraney1t@reuters.com'),
('Vasily', 'Elcome', 'M', '483-67-5400', '1990-09-04', 'velcome1u@slideshare.net'),
('Tadeo', 'Frandsen', 'M', '372-51-9424', '1983-01-13', 'tfrandsen1v@webnode.com'),
('Joshuah', 'Greatreax', 'M', '262-29-3388', '1992-09-07', 'jgreatreax1w@umn.edu'),
('Rosie', 'Mauvin', 'F', '296-69-9123', '1978-07-25', 'rmauvin1x@state.tx.us'),
('Zabrina', 'Hutley', 'F', '324-18-3220', '1984-07-31', 'zhutley1y@shutterfly.com'),
('Stefano', 'Jasiak', 'M', '253-07-3554', '1974-03-19', 'sjasiak1z@huffingtonpost.com'),
('Yehudi', 'Bithany', 'M', '606-30-8000', '1983-12-11', 'ybithany20@vistaprint.com'),
('Lotte', 'Hufton', 'F', '674-98-1753', '1975-05-10', 'lhufton21@studiopress.com'),
('Chane', 'Hartwell', 'M', '800-05-6416', '1996-04-13', 'chartwell22@cargocollective.com'),
('Ilise', 'Tripcony', 'F', '418-22-2423', '1979-03-30', 'itripcony23@who.int'),
('Danyette', 'Kovacs', 'F', '128-15-6982', '1996-04-01', 'dkovacs24@bluehost.com'),
('Miquela', 'Wathen', 'F', '792-37-2690', '1988-08-11', 'mwathen25@pcworld.com'),
('Gregorio', 'Greatbatch', 'M', '194-05-9021', '1991-08-27', 'ggreatbatch26@about.me'),
('Jorgan', 'Pidgeley', 'M', '371-73-7537', '1971-02-10', 'jpidgeley27@mozilla.org'),
('Nike', 'De Blase', 'F', '285-67-5760', '1975-05-04', 'ndeblase28@last.fm'),
('Kameko', 'Hackin', 'F', '144-92-6967', '1977-01-20', 'khackin29@telegraph.co.uk'),
('Herold', 'Plewes', 'M', '828-16-1911', '1972-09-04', 'hplewes2a@mail.ru'),
('Roseanne', 'Funcheon', 'F', '699-49-4845', '1990-08-12', 'rfuncheon2b@over-blog.com'),
('Pearce', 'Geertje', 'M', '122-04-6991', '1976-05-15', 'pgeertje2c@stanford.edu'),
('Wilden', 'Wildbore', 'M', '727-13-6684', '1973-02-08', 'wwildbore2d@stanford.edu'),
('Sorcha', 'Denning', 'F', '186-66-1091', '1999-01-13', 'sdenning2e@google.de'),
('Denise', 'Simpkins', 'F', '890-42-3063', '1991-04-14', 'dsimpkins2f@ft.com'),
('Geno', 'Robertot', 'M', '828-13-3481', '1988-02-10', 'grobertot2g@reuters.com'),
('Haleigh', 'Gwilt', 'F', '470-99-4478', '1973-06-05', 'hgwilt2h@topsy.com'),
('Boycie', 'Macbeth', 'M', '574-19-2261', '1982-05-26', 'bmacbeth2i@mtv.com'),
('Claudianus', 'Reddick', 'M', '366-68-2483', '1995-09-25', 'creddick2j@comsenz.com'),
('Diana', 'McMurraya', 'F', '268-45-5999', '1982-06-01', 'dmcmurraya2k@cargocollective.com'),
('Morly', 'Wohler', 'M', '362-23-6581', '1993-02-12', 'mwohler2l@over-blog.com'),
('Man', 'Almeida', 'M', '684-11-8003', '1996-08-08', 'malmeida2m@list-manage.com'),
('Felipa', 'Brawn', 'F', '578-57-0561', '1974-09-24', 'fbrawn2n@yelp.com'),
('Jamill', 'Hatchman', 'M', '533-67-3791', '1983-01-01', 'jhatchman2o@eventbrite.com'),
('Joelynn', 'Siaskowski', 'F', '613-12-7992', '1982-09-07', 'jsiaskowski2p@webs.com'),
('Helyn', 'Ollier', 'F', '817-83-4419', '1998-12-28', 'hollier2q@diigo.com'),
('Ben', 'Dover', 'M', '627-49-4853', '1995-11-06', 'bendover@gmail.com');

INSERT INTO insurance.agent (first_name, last_name, user_name, password, email)
VALUES
('Kelly', 'Smith', 'kelly_smith', 'T2187h0Lh', 'kellysmith@insuranceabc.com'),
('Isaac', 'Clark', 'deadspace2', 'B3689*dnO9', 'isaacclark@insuranceabc.com'),
('John', 'Dore', 'johndoree2', 'DoreCcZY', 'dridoutt2@insuranceabc.com'),
('Mendel', 'Sellens', 'msellens3', 'W1387Cm4', 'msellens3@insuranceabc.com'),
('Grata', 'Ceschi', 'gceschi4', 'A2376wQZbBx41*', 'gceschi4@insuranceabc.com'),
('Shirl', 'Goolding', 'sgoolding5', 'O3089pbXIhjFU', 'sgoolding5@insuranceabc.com'),
('Jordanna', 'Surgood', 'jsurgood6', 'W39204wi', 'jsurgood6@insuranceabc.com'),
('Ryan', 'Kimbrey', 'rkimbrey7', 'RK345isu', 'rkimbrey7@insuranceabc.com'),
('James', 'Suderland', 'suderland23', 'JamesWork23', 'jsuderlandsh@insuranceabc.com'),
('Robert', 'Spyby', 'rspyby66', 'Theboss66', 'bob666@insuranceabc.com');

INSERT INTO insurance.directory (agent_id, customer_id, phone_number, primary_phone) 
VALUES 
(1, NULL, '455-147-8961', 0),
(2, NULL, '669-552-3021', 1),
(3, NULL, '449-635-9437', 0),
(4, NULL, '377-282-5336', 1),
(5, NULL, '388-130-8120', 1),
(6, NULL, '203-462-9077', 1),
(1, NULL, '455-867-5093', 1),
(6, NULL, '203-223-9394', 0),
(9, NULL, '805-464-9770', 1),
(7, NULL, '535-211-8954', 1),
(8, NULL, '123-313-7887', 1),
(10, NULL, '733-733-2350', 1),
(NULL, 1, '398-642-6570', 1),
(NULL, 2, '770-215-5220', 1),
(NULL, 3, '806-442-7369', 1),
(NULL, 4, '926-328-5122', 1),
(NULL, 5, '677-852-6249', 1),
(NULL, 6, '173-499-2851', 1),
(NULL, 7, '332-394-0578', 1),
(NULL, 8, '405-665-4163', 1),
(NULL, 9, '902-693-4861', 1),
(NULL, 10, '809-717-4387', 1),
(NULL, 11, '134-584-6958', 0),
(NULL, 12, '237-902-0010', 1),
(NULL, 13, '408-477-2426', 1),
(NULL, 4, '926-594-9906', 0),
(NULL, 14, '829-835-3198', 1),
(NULL, 15, '347-294-2172', 0),
(NULL, 16, '112-996-4762', 1),
(NULL, 17, '254-692-5728', 1),
(NULL, 18, '996-345-1589', 1),
(NULL, 19, '562-386-3826', 0),
(NULL, 20, '917-306-0189', 1),
(NULL, 13, '408-418-2435', 0),
(NULL, 14, '664-781-9503', 0),
(NULL, 15, '106-460-9732', 1),
(NULL, 16, '866-678-3451', 0),
(NULL, 17, '908-759-4432', 0),
(NULL, 18, '596-458-5382', 0),
(NULL, 19, '643-923-8520', 1),
(NULL, 20, '421-874-0484', 0),
(NULL, 21, '922-992-1911', 1),
(NULL, 22, '468-738-7415', 1),
(NULL, 23, '196-529-2429', 1),
(NULL, 24, '415-178-0413', 1),
(NULL, 22, '675-459-3546', 0),
(NULL, 25, '661-817-4091', 1),
(NULL, 26, '948-713-8331', 1),
(NULL, 27, '211-858-0712', 1),
(NULL, 28, '859-950-3186', 1),
(NULL, 29, '597-610-6493', 1),
(NULL, 30, '639-310-5034', 0),
(NULL, 31, '202-320-4247', 1),
(NULL, 32, '233-223-7267', 1),
(NULL, 33, '641-448-4381', 1),
(NULL, 34, '546-767-3386', 1),
(NULL, 35, '424-676-6290', 1),
(NULL, 36, '976-356-7274', 1),
(NULL, 37, '428-648-6115', 1),
(NULL, 38, '821-295-5940', 1),
(NULL, 39, '504-458-5013', 1),
(NULL, 40, '708-537-6597', 1),
(NULL, 41, '724-843-0302', 1),
(NULL, 42, '527-391-3430', 1),
(NULL, 43, '509-371-0084', 1),
(NULL, 44, '265-341-6733', 1),
(NULL, 45, '477-480-6710', 1),
(NULL, 46, '437-547-9642', 1),
(NULL, 42, '899-768-0910', 0),
(NULL, 47, '342-828-9626', 1),
(NULL, 48, '850-836-3293', 1),
(NULL, 49, '754-442-2934', 1),
(NULL, 50, '184-610-2330', 1),
(NULL, 51, '568-870-2008', 1),
(NULL, 52, '912-747-1659', 0),
(NULL, 53, '325-382-7412', 1),
(NULL, 54, '884-362-5218', 1),
(NULL, 55, '449-291-9194', 1),
(NULL, 53, '106-847-3129', 0),
(NULL, 56, '672-561-5146', 1),
(NULL, 56, '333-103-9860', 0),
(NULL, 57, '904-651-7446', 1),
(NULL, 58, '926-332-5467', 1),
(NULL, 59, '946-103-5843', 1),
(NULL, 60, '742-397-1362', 1),
(NULL, 61, '113-815-8144', 1),
(NULL, 62, '964-191-6676', 1),
(NULL, 63, '204-969-0530', 1),
(NULL, 64, '460-620-2108', 1),
(NULL, 65, '168-387-2087', 1),
(NULL, 66, '370-178-7754', 1),
(NULL, 67, '208-768-4833', 1),
(NULL, 68, '948-452-6405', 1),
(NULL, 69, '487-340-0507', 1),
(NULL, 70, '588-386-0639', 1),
(NULL, 69, '529-764-2751', 0),
(NULL, 71, '444-899-7425', 1),
(NULL, 72, '571-124-9090', 1),
(NULL, 68, '834-529-3491', 0),
(NULL, 66, '964-141-3753', 0),
(NULL, 52, '109-985-6466', 1),
(NULL, 73, '350-627-0868', 1),
(9, NULL, '534-492-3103', 0),
(NULL, 60, '594-955-7251', 0),
(NULL, 74, '871-997-0171', 1),
(NULL, 75, '342-293-2524', 1),
(NULL, 76, '426-380-3901', 1),
(NULL, 77, '724-308-3879', 1),
(NULL, 78, '999-224-6764', 1),
(NULL, 79, '373-461-8591', 1),
(NULL, 80, '371-605-5410', 1),
(NULL, 81, '834-888-7873', 1),
(NULL, 22, '281-502-3140', 0),
(NULL, 83, '434-868-0310', 1),
(NULL, 82, '635-196-7259', 1),
(NULL, 90, '327-468-5359', 0),
(NULL, 83, '987-240-8034', 0),
(NULL, 91, '237-977-1893', 1),
(NULL, 84, '914-930-1887', 1),
(NULL, 85, '111-976-9478', 1),
(NULL, 86, '440-334-6046', 1),
(NULL, 87, '751-217-9625', 1),
(NULL, 88, '195-234-5772', 1),
(NULL, 89, '390-317-7467', 1),
(NULL, 90, '317-434-7498', 1),
(NULL, 100, '216-453-4301', 0),
(NULL, 92, '662-332-9482', 1),
(NULL, 93, '500-474-7844', 1),
(NULL, 94, '438-521-2106', 1),
(2, NULL, '702-117-6638', 0),
(8, NULL, '715-556-3356', 0),
(1, NULL, '353-375-8912', 0),
(3, NULL, '733-193-9265', 1),
(NULL, 95, '238-552-4922', 1),
(NULL, 96, '238-544-4944', 1),
(NULL, 97, '238-556-4927', 1),
(NULL, 98, '238-665-6677', 1),
(NULL, 99, '238-767-5422', 1),
(NULL, 100, '238-525-7622', 1),
(NULL, 33, '238-353-4562', 0),
(NULL, 51, '238-595-4672', 0),
(NULL, 44, '238-131-4232', 0),
(NULL, 99, '238-139-4522', 0),
(NULL, 11, '238-565-8976', 1),
(NULL, 2, '238-555-4567', 0),
(NULL, 27, '238-462-3211', 0),
(NULL, 30, '238-572-4822', 1),
(NULL, 87, '238-212-4722', 0),
(NULL, 7, '238-323-4932', 0),
(NULL, 5, '238-545-4999', 0);

INSERT INTO insurance.property (customer_id, fmv, property_type, improvements, details, primary_residence)
VALUES 
(4, 170000.00, 'Residential', 20000.00, 'Family Residence', 1),
(9, 300000.00, 'Residential', 0.00, 'Family Residence', 1),
(3, 250000.00, 'Residential', 0.00, 'Family Residence', 1),
(1, 110000.00, 'Residential', 20000.00, 'Family Residence', 1),
(5, 100000.00, 'Residential', 15000.00, 'Family Residence', 1),
(6, 750000.00, 'Residential', 0.00, 'Family Residence', 1),
(7, 550000.00, 'Residential', 0.00, 'Family Residence', 1),
(8, 600000.00, 'Residential', 0.00, 'Family Residence', 1),
(2, 750000.00, 'Residential', 0.00, 'Family Residence', 1),
(10, 205000.00, 'Residential', 0.00, 'Family Residence', 1),
(11, 150000.00, 'Residential', 40000.00, 'Family Residence', 1),
(12, 300000.00, 'Residential', 0.00, 'Family Residence', 1),
(12, 800000.00, 'Commercial', 50000.00, 'Retail: Office', 0),
(14, 1000000.00, 'Residential', 0.00, 'Family Residence', 1),
(15, 375000.00, 'Residential', 0.00, 'Family Residence', 1),
(22, 250000.00, 'Residential', 0.00, 'Family Residence', 1),
(17, 180000.00, 'Residential', 0.00, 'Family Residence', 1),
(13, 140000.00, 'Residential', 0.00, 'Apartment', 1),
(18, 200000.00, 'Residential', 0.00, 'Apartment', 1),
(19, 160000.00, 'Residential', 0.00, 'Apartment', 1),
(20, 120000.00, 'Residential', 8000.00, 'Apartment', 1),
(21, 270000.00, 'Residential', 0.00, 'Apartment', 1),
(16, 180000.00, 'Residential', 0.00, 'Apartment', 1),
(23, 300000.00, 'Residential', 0.00, 'Apartment', 1),
(23, 450000.00, 'Residential', 15000.00, 'Vacation Property: Beach House', 0),
(25, 350000.00, 'Residential', 0.00, 'Apartment', 1),
(27, 105000.00, 'Residential', 0.00, 'Apartment', 1),
(28, 120000.00, 'Residential', 0.00, 'Apartment', 1),
(2, 700000.00, 'Residential', 0.00, 'Vacation Property: Lake House', 0),
(30, 290000.00, 'Residential', 0.00, 'Apartment', 1),
(31, 190000.00, 'Residential', 0.00, 'Apartment', 1),
(32, 230000.00, 'Residential', 0.00, 'Apartment', 1),
(33, 180000.00, 'Residential', 0.00, 'Apartment', 1),
(34, 150000.00, 'Residential', 10000.00, 'Apartment', 1),
(35, 130000.00, 'Residential', 30000.00, 'Apartment', 1),
(36, 150000.00, 'Residential', 0.00, 'Apartment', 1),
(37, 160000.00, 'Residential', 0.00, 'Apartment', 1),
(38, 150000.00, 'Residential', 20000.00, 'Apartment', 1),
(14, 250000.00, 'Residential', 0.00, 'Vacation Property: Beach House', 0),
(40, 370000.00, 'Residential', 0.00, 'Vacation Property: Beach House', 0),
(41, 155000.00, 'Residential', 0.00, 'Apartment', 1),
(24, 140000.00, 'Residential', 0.00, 'Apartment', 1),
(29, 150000.00, 'Residential', 0.00, 'Apartment', 1),
(40, 230000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(39, 235000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(41, 480000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(42, 230000.00, 'Commercial', 5000.00, 'Retail: Department Store', 0),
(43, 250000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(44, 230000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(45, 330000.00, 'Commercial', 5000.00, 'Retail: Department Store', 0),
(46, 330000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(47, 430000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(48, 230000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(49, 280000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(50, 180000.00, 'Commercial', 0.00, 'Retail: Department Store', 0),
(40, 250000.00, 'Residential', 0.00, 'Family Residence', 1),
(51, 220000.00, 'Residential', 0.00, 'Family Residence', 1),
(52, 150000.00, 'Residential', 0.00, 'Family Residence', 1),
(54, 280000.00, 'Residential', 0.00, 'Family Residence', 1),
(55, 250000.00, 'Residential', 0.00, 'Family Residence', 1),
(53, 240000.00, 'Residential', 0.00, 'Family Residence', 1),
(56, 250000.00, 'Residential', 7000.00, 'Family Residence', 1),
(57, 270000.00, 'Residential', 0.00, 'Family Residence', 1),
(58, 255000.00, 'Residential', 0.00, 'Family Residence', 1),
(60, 295000.00, 'Residential', 5000.00, 'Family Residence', 1),
(59, 350000.00, 'Residential', 0.00, 'Family Residence', 1),
(61, 250000.00, 'Residential', 0.00, 'Family Residence', 1),
(62, 225000.00, 'Residential', 0.00, 'Family Residence', 1),
(63, 550000.00, 'Residential', 0.00, 'Family Residence', 1),
(64, 1200000.00, 'Residential', 0.00, 'Vacation Property: Lake House', 0),
(69, 355000, 'Residential', 0.00, 'Family Residence', 1),
(65, 255000, 'Residential', 0.00, 'Family Residence', 1),
(66, 230000, 'Residential', 5000.00, 'Family Residence', 1),
(68, 400000, 'Residential', 0.00, 'Family Residence', 1),
(67, 255000, 'Residential', 0.00, 'Family Residence', 1),
(70, 290000, 'Residential', 0.00, 'Family Residence', 1),
(81, 155000, 'Commercial', 0.00, 'Family Residence', 1),
(89, 255000, 'Commercial', 0.00, 'Family Residence', 1),
(88, 255000, 'Commercial', 0.00, 'Family Residence', 1),
(87, 370000, 'Commercial', 0.00, 'Family Residence', 1),
(86, 355000, 'Commercial', 12000.00, 'Family Residence', 1),
(85, 255000, 'Commercial', 0.00, 'Family Residence', 1),
(84, 155000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(80, 250000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(83, 255000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(82, 355000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(100, 355000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(71, 250000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(73, 255000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(82, 355000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(72, 240000, 'Commercial', 0.00, 'Retail: Restaurant', 1),
(27, 255000, 'Commercial', 10000.00, 'Retail: Office', 0),
(1, 335000, 'Commercial', 0.00, 'Retail: Office', 0),
(99, 255000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(79, 255000, 'Commercial', 0.00, 'Retail: Office', 1),
(77, 240000, 'Commercial', 0.00, 'Retail: Office', 1),
(76, 155000, 'Commercial', 0.00, 'Retail: Office', 1),
(78, 230000, 'Commercial', 0.00, 'Retail: Office', 1),
(75, 355000, 'Commercial', 0.00, 'Retail: Office', 1),
(74, 125000, 'Residential', 25000.00, 'Family Residence', 1),
(64, 305000, 'Commercial', 0.00, 'Retail: Mall', 0),
(11, 325000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(21, 330000, 'Commercial', 0.00, 'Retail: Office', 0),
(36, 305000, 'Industrial', 0.00, 'Warehouse: Electronics', 0),
(70, 250000, 'Commercial', 0.00, 'Retail: Grocery Store', 0),
(45, 305000, 'Commercial', 0.00, 'Retail: Hotel', 0),
(48, 270000, 'Industrial', 0.00, 'Light Manufactoring: Clothing', 0),
(51, 305000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(18, 305000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(23, 305000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(88, 300000, 'Industrial', 0.00, 'Warehouse: Construction Materials', 0),
(4, 305000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(9, 180000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(35, 170000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(62, 305000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(58, 305000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(66, 20000000, 'Industrial', 0.00, 'Distribution Facility: Food', 0),
(69, 385000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(26, 255000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(99, 2185000, 'Industrial', 0.00, 'Light Manufactoring: Food Packaging', 0),
(82, 185000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(37, 4000000, 'Commercial', 0.00, 'Retail: Drug Store', 0),
(49, 145000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(6, 4450000, 'Industrial', 200000.00, 'Heavy Manufacturing: Steel Factory', 0),
(17, 165000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(13, 8250000, 'Commercial', 500000.00, 'Retail: Gas Station', 0),
(5, 290000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(4, 305000, 'Commercial', 15000.00, 'Retail: Restaurant', 0),
(1, 185000, 'Commercial', 0.00, 'Retail: Office', 0),
(3, 385000, 'Commercial', 0.00, 'Retail: Hardware Store', 0),
(15, 185000, 'Commercial', 0.00, 'Retail: Office', 0),
(16, 185000, 'Commercial', 0.00, 'Retail: Office', 0),
(23, 1185000, 'Commercial', 100000.00, 'Retail: Grocery Store', 0),
(22, 185000, 'Commercial', 0.00, 'Retail: Office', 0),
(19, 350000, 'Commercial', 0.00, 'Retail: Office', 0),
(91, 185000, 'Commercial', 0.00, 'Retail: Office', 0),
(92, 560000, 'Commercial', 0.00, 'Retail: Office', 0),
(28, 190000, 'Commercial', 0.00, 'Retail: Office', 0),
(42, 185000, 'Commercial', 0.00, 'Retail: Hotel', 0),
(77, 1200000, 'Commercial', 50000.00, 'Retail: Sport Center', 0),
(74, 935000, 'Commercial', 0.00, 'Retail: Grocery Store', 0),
(84, 165000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(86, 185000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(14, 8000000, 'Industrial', 500000.00, 'Heavy Manufactoring: Factory', 0),
(94, 3500000, 'Commercial', 70000.00, 'Retail: Supermarket', 0),
(9, 300000, 'Commercial', 0.00, 'Retail: Department Store', 0),
(1, 185000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(57, 235000, 'Commercial', 0.00, 'Retail: Restaurant', 0),
(40, 180000, 'Commercial', 10000.00, 'Retail: Flower Shop', 0),
(23, 240000, 'Commercial', 0.00, 'Retail: Restaurant', 0);

INSERT INTO insurance.vehicle (customer_id, make, model, year, plate, color, doors, milage)
VALUES
(3, 'Mazda', 'B-Series', 2011, 'KNA1541', 'Red', 3, 56175),
(1, 'Acura', 'RL', 2022, 'KMH1388', 'Blue', 3, 5077),
(4, 'BMW', 'M Roadster', 2007, 'WAK2381', 'Black', 5, 93078),
(5, 'Land Rover', 'Sterling', 1991, 'HKX7619', 'Brown', 5, 95702),
(6, 'Chevrolet', 'Malibu', 2002, 'MJK0236', 'Blue', 5, 54728),
(7, 'Toyota', 'Camry', 2009, 'GCF5914', 'Blue', 5, 66479),
(10, 'Chevrolet', 'Express', 2012, 'GWY5229', 'Silver', 5, 13221),
(9, 'BMW', 'M3', 2006, 'FFL3576', 'Gray', 3, 50196),
(8, 'Mazda', 'Miata MX-5', 2012, 'NJF5537', 'Orange', 5, 8699),
(29, 'Toyota', 'Celica', 1997, 'JEH8660', 'Gray', 5, 80615),
(11, 'Volkswagen', 'New Beetle', 2001, 'ALY0688', 'Pink', 5, 29959),
(12, 'Buick', 'Skyhawk', 1986, 'LBG3475', 'White', 5, 140458),
(12, 'Dodge', 'Magnum', 2008, 'LCG2930', 'Orange', 5, 75085),
(14, 'MINI', 'Cooper', 2008, 'XLA5255', 'Blue', 5, 18549),
(15, 'Nissan', 'Pathfinder', 2005, 'CD47355', 'Blue', 5, 23979),
(22, 'Mitsubishi', 'Starion', 1986, 'JHD9447', 'Gray', 5, 58388),
(17, 'Chevrolet', 'Lumina APV', 1992, 'VBH5933', 'Blue', 5, 75374),
(13, 'Kia', 'Sportage', 2006, 'WEV2791', 'Silver', 5, 5345),
(18, 'Hyundai', 'Tucson', 2011, 'WAU4560', 'Green', 3, 94483),
(19, 'Mitsubishi', 'Tundra', 2009, 'WVG7283', 'White', 4, 12975),
(20, 'GMC', '1500', 1995, 'WAU3125', 'White', 5, 11952),
(21, 'Dodge', 'Ram Van 1500', 1999, 'WEX9238', 'White', 5, 59430),
(16, 'Mitsubishi', 'Eclipse', 1996, 'SEM1412', 'Green', 5, 71495),
(23, 'Pontiac', 'Gemini', 1986, 'KNA7675', 'Gray', 5, 74960),
(23, 'BMW', 'X6', 2009, 'GEX8181', 'Silver', 5, 95619),
(25, 'Land Rover', 'Discovery Series II', 2002, 'TNT4863', 'Green', 5, 66429),
(27, 'Ford', 'F350', 2009, 'FCF3674', 'White', 5, 82195),
(28, 'Honda', 'CR-V', 2005, 'WBA3472', 'Gray', 5, 32501),
(31, 'Pontiac', 'Montana', 2001, 'HEY0897', 'White', 5, 60771),
(32, 'Toyota', '4Runner', 2002, 'XXC9647', 'Gray', 5, 5624),
(33, 'Mitsubishi', 'Lancer', 2004, 'GKD8573', 'Blue', 5, 49210),
(34, 'GMC', 'Vandura 1500', 1994, 'BYE3128', 'Blue', 5, 55431),
(35, 'Mitsubishi', '3000GT', 1997, 'JFK3214', 'Green', 5, 59580),
(36, 'Ford', 'Th!nk', 2001, 'WBV4410', 'Gray', 5, 2974),
(37, 'Mazda', 'MX-5', 2004, 'MDK5073', 'Blue', 3, 18236),
(38, 'Ford', 'Fiesta', 2012, 'KAC6624', 'Black', 5, 20483),
(14, 'Pontiac', 'Montana', 2004, 'MCD1724', 'Silver', 5, 89616),
(40, 'Isuzu', 'Rodeo', 1999, 'LCG4290', 'White', 5, 26658),
(41, 'Chevrolet', 'G-Series G20', 1994, 'GVD8071', 'White', 5, 60858),
(24, 'Volvo', 'V70', 2000, 'AEN3294', 'Orange', 5, 48839),
(29, 'Maybach', '62', 2003, 'AFA2489', 'Brown', 5, 45113),
(40, 'BMW', '1 Series', 2012, 'CNN4920', 'Black', 5, 34482),
(39, 'Lexus', 'LX', 2009, 'KFK1887', 'White', 5, 90474),
(41, 'Mercury', 'Mountaineer', 2005, 'MAC7339', 'Blue', 5, 43129),
(42, 'Saab', '9000', 1987, 'VUF5808', 'Red', 5, 5576),
(43, 'Chevrolet', 'Suburban 2500', 2008, 'TAE6050', 'Orange', 5, 12678),
(44, 'Chevrolet', 'Silverado 3500', 2003, 'TWA9339', 'White', 5, 65274),
(45, 'Ford', 'F350', 1996, 'CFG6927', 'Gray', 5, 73782),
(46, 'Ford', 'Laser', 1986, 'KAF9279', 'White', 5, 58004),
(47, 'Mercedes-Benz', 'S-Class', 2010, 'ALF7660', 'White', 5, 5449),
(48, 'Audi', 'TT', 2012, 'YCD7156', 'Red', 5, 55199),
(49, 'Acura', 'NSX', 2000, 'HXG2209', 'Blue', 5, 49542),
(50, 'Honda', 'Civic', 1988, 'FEJ2443', 'Silver', 5, 85487),
(40, 'Toyota', 'Venza', 2009, 'WPS3771', 'Silver', 5, 53342),
(51, 'Acura', 'MDX', 2009, 'JTH7063', 'Silver', 5, 45274),
(52, 'Mazda', 'MX-5', 1992, 'KBA6761', 'Gray', 5, 36620),
(54, 'Audi', 'A6', 2002, 'RFB9416', 'Gray', 5, 90993),
(55, 'Mazda', 'Protege', 1996, 'MDE7360', 'Blue', 5, 96141),
(53, 'Infiniti', 'M', 2009, 'KBF6365', 'Silver', 5, 61198),
(56, 'Kia', 'Sportage', 1996, 'TBD2159', 'Black', 5, 35050),
(57, 'Nissan', 'Armada', 2010, 'WBA9581', 'Gray', 5, 43898),
(58, 'Chrysler', 'Town & Country', 2011, 'XFG0992', 'Gray', 5, 18891),
(60, 'Ford', 'Expedition EL', 2008, 'AUN1456', 'Blue', 5, 19672),
(59, 'Chevrolet', 'G-Series 1500', 1997, 'DBT3775', 'Gold', 5, 13891),
(61, 'Toyota', 'MR2', 2001, 'VET9534', 'Brown', 5, 47351),
(62, 'Lincoln', 'MKS', 2011, 'GET7527', 'Green', 5, 88721),
(63, 'Mercury', 'Mountaineer', 2003, 'WEY7421', 'Red', 5, 4045),
(64, 'Bugatti', 'Veyron', 2011, 'WBA3515', 'Black', 5, 92942),
(69, 'Acura', 'Vigor', 1992, 'KMH8296', 'White', 3, 64979),
(66, 'Mazda', 'MX-6', 1993, 'VNK3195', 'White', 3, 44936),
(66, 'Audi', 'S4', 2012, 'VH11453', 'Gray', 5, 58336),
(68, 'Pontiac', 'Grand Prix', 1998, 'VWA4079', 'Silver', 5, 94078),
(67, 'Honda', 'Prelude', 1986, 'XOX5684', 'Blue', 5, 60502),
(70, 'Land Rover', 'Freelander', 2010, 'XXG2667', 'Blue', 5, 98196),
(81, 'Dodge', 'Caravan', 2004, 'WAU2903', 'Orange', 3, 77656),
(89, 'Mercedes-Benz', 'GLK-Class', 2010, 'EX66033', 'Red', 5, 58879),
(88, 'Mercury', 'Tracer', 1998, 'KUK2727', 'Silver', 5, 65792),
(87, 'Dodge', 'Stealth', 1996, 'GFB1163', 'Gray', 5, 79609),
(86, 'Subaru', 'XT', 1987, 'FTE8448', 'Red', 5, 72718),
(85, 'Volkswagen', 'Corrado', 1994, 'PEK2173', 'Black', 5, 69071),
(84, 'Cadillac', 'Seville', 1998, 'JNZ2490', 'Blue', 5, 34646),
(80, 'Mercury', 'Capri', 1994, 'KBC3707', 'Blue', 5, 37192),
(83, 'BMW', '7 Series', 1997, 'GCF3664', 'White', 5, 64145),
(82, 'Toyota', 'Sienna', 2002, 'MZF9608', 'Silver', 5, 8886),
(100, 'Mitsubishi', 'RVR', 1993, 'UXV9940', 'Gray', 5, 18397),
(65, 'Hyundai', 'Santa Fe', 2011, 'FAT0468', 'Black', 5, 74625),
(71, 'MINI', 'Clubman', 2011, 'NYZ7986', 'White', 5, 13346),
(73, 'Isuzu', 'VehiCROSS', 2000, 'WOW4118', 'Black', 5, 59009),
(82, 'Honda', 'Element', 2005, 'WAU9084', 'Gray', 5, 25530),
(72, 'Acura', 'SLX', 1996, 'JHS6997', 'Red', 5, 76703),
(27, 'Chevrolet', 'S10', 1997, 'VHZ5429', 'Blue', 5, 38697),
(99, 'GMC', 'Yukon XL 2500', 2009, 'JHC1493', 'Black', 5, 68599),
(79, 'Dodge', 'Nitro', 2010, 'RYD4985', 'Silver', 5, 39448),
(77, 'Mitsubishi', 'GTO', 1994, 'YAF3939', 'Silver', 5, 57742),
(76, 'Buick', 'LeSabre', 1996, 'WBA4280', 'Red', 5, 13371),
(78, 'Chevrolet', 'Tahoe', 2003, 'WAU7885', 'Silver', 5, 75083),
(75, 'Audi', '5000S', 1984, 'KNA3317', 'Silver', 5, 9669),
(74, 'Lamborghini', 'Countach', 1987, 'AG32572', 'Orange', 3, 92901),
(64, 'Buick', 'Regal', 1996, 'GBF3233', 'Black', 5, 83957),
(11, 'Scion', 'xA', 2005, 'LTK3591', 'Red', 5, 92469),
(21, 'Honda', 'Accord', 1987, 'JTH3617', 'Red', 5, 85089),
(36, 'Jaguar', 'XJ Series', 2000, 'AEF9013', 'Green', 3, 56558),
(2, 'Lamborghini', 'Murciélago LP640', 2008, 'TBG4609', 'Blue', 5, 8874),
(45, 'GMC', 'Sierra 2500', 2006, 'CFN5314', 'Green', 5, 50647),
(48, 'Honda', 'CR-Z', 2012, 'GKU0635', 'Blue', 5, 21602),
(51, 'Mitsubishi', 'Mirage', 1984, 'JKB3695', 'Red', 5, 21522),
(18, 'Mitsubishi', 'Truck', 1988, 'GFH8091', 'Blue', 5, 51367),
(23, 'Chevrolet', 'Express 2500', 2004, 'TGL8530', 'Black', 5, 15400),
(88, 'Ford', 'Laser', 1984, 'DBM4262', 'White', 5, 26257),
(35, 'Dodge', 'Stratus', 1995, 'SE20392', 'Green', 5, 44004),
(62, 'Toyota', 'MR2', 1993, 'KYX2858', 'Black', 5, 24782),
(58, 'Oldsmobile', 'LSS', 1998, 'DEY9268', 'Gray', 5, 45214),
(66, 'Suzuki', 'Sidekick', 1998, 'CXA5817', 'Black', 5, 33165),
(69, 'Ford', 'Laser', 1984, 'AE98350', 'White', 5, 95362),
(26, 'Toyota', 'Yaris', 2008, 'TSW5361', 'Blue', 5, 60606),
(12, 'Ford', 'Mustang', 2008, 'GYX4631', 'Silver', 5, 58096),
(82, 'Chevrolet', 'SSR', 2006, 'KBU7670', 'Silver', 5, 345),
(37, 'Lexus', 'SC', 1999, 'AB97169', 'Black', 5, 66544),
(49, 'Chevrolet', 'G-Series G30', 1992, 'AE40809', 'Gray', 5, 99905),
(70, 'Toyota', 'FJ Cruiser', 2007, 'SEC5425', 'Brown', 4, 26260);

INSERT INTO insurance.address (agent_id, property_id, street_address, street_number, city, state, zip_code)
VALUES
(null, 1, 'Merchant', '2176', 'Wichita', 'Kansas', '67230'),
(null, 2, 'Mallard', '8979', 'Reno', 'Nevada', '89510'),
(null, 3, 'Blaine', '68', 'Young America', 'Minnesota', '55551'),
(null, 4, 'Arkansas', '0164', 'Fort Worth', 'Texas', '76198'),
(null, 5, 'Ruskin', '7', 'Portland', 'Oregon', '97296'),
(null, 6, 'Loeprich', '949', 'Denver', 'Colorado', '80279'),
(null, 7, 'Westridge', '683', 'San Francisco', 'California', '94164'),
(null, 8, 'Pawling', '6216', 'Sacramento', 'California', '94291'),
(null, 9, 'Upham', '555', 'Danbury', 'Connecticut', '06816'),
(null, 10, 'Golden Leaf', '205', 'Vero Beach', 'Florida', '32969'),
(null, 11, 'Mockingbird', '8897', 'Dallas', 'Texas', '75367'),
(null, 12, 'Sycamore', '0341', 'Chicago', 'Illinois', '60604'),
(null, 13, 'Stone Corner', '5', 'Salt Lake City', 'Utah', '84115'),
(null, 14, 'Mariners Cove', '7', 'Roanoke', 'Virginia', '24020'),
(null, 15, 'Paget', '1273', 'Sacramento', 'California', '94273'),
(null, 16, 'Fisk', '1418', 'Sacramento', 'California', '95823'),
(null, 17, 'Pennsylvania', '70', 'Honolulu', 'Hawaii', '96810'),
(null, 18, 'Sommers', '3', 'Montgomery', 'Alabama', '36177'),
(null, 19, 'Butterfield', '085', 'Chattanooga', 'Tennessee', '37450'),
(null, 20, 'Killdeer', '8384', 'El Paso', 'Texas', '79928'),
(null, 21, 'Welch', '1737', 'Springfield', 'Illinois', '62794'),
(null, 22, 'Colorado', '7', 'Houston', 'Texas', '77266'),
(null, 23, 'Schmedeman', '2414', 'Pompano Beach', 'Florida', '33064'),
(null, 24, 'Garrison', '7084', 'New Orleans', 'Louisiana', '70149'),
(null, 55, 'Bartelt', '6', 'Decatur', 'Georgia', '30089'),
(null, 26, 'Maywood', '12', 'Billings', 'Montana', '59105'),
(null, 27, 'Little Fleur', '7', 'Birmingham', 'Alabama', '35225'),
(null, 28, 'Colorado', '49', 'Mobile', 'Alabama', '36616'),
(null, 29, 'Maryland', '4', 'Fresno', 'California', '93721'),
(null, 30, 'Elka', '270', 'Pittsburgh', 'Pennsylvania', '15255'),
(null, 31, 'Village Green', '2966', 'Reno', 'Nevada', '89505'),
(null, 32, 'Lyons', '2833', 'Charlotte', 'North Carolina', '28215'),
(null, 33, 'Forster', '70', 'Philadelphia', 'Pennsylvania', '19146'),
(null, 34, 'Gerald', '8188', 'Springfield', 'Missouri', '65898'),
(null, 35, 'Lighthouse Bay', '141', 'Cleveland', 'Ohio', '44191'),
(null, 36, 'Elgar', '7', 'Baton Rouge', 'Louisiana', '70810'),
(null, 37, 'Tennessee', '695', 'Houston', 'Texas', '77040'),
(null, 38, 'Fairview', '63', 'Louisville', 'Kentucky', '40215'),
(null, 39, 'Alpine', '71', 'Las Vegas', 'Nevada', '89160'),
(null, 115, 'Russell', '83', 'Los Angeles', 'California', '90060'),
(null, 41, 'Riverside', '1824', 'Athens', 'Georgia', '30610'),
(null, 42, 'Fieldstone', '027', 'San Diego', 'California', '92176'),
(null, 43, 'Kennedy', '2985', 'Austin', 'Texas', '78778'),
(null, 44, 'Lighthouse Bay', '61', 'Colorado Springs', 'Colorado', '80935'),
(null, 45, 'Loomis', '9', 'Frankfort', 'Kentucky', '40618'),
(null, 46, 'Autumn Leaf', '278', 'Huntsville', 'Alabama', '35895'),
(null, 47, 'Delladonna', '4', 'Anaheim', 'California', '92805'),
(null, 48, 'Norway Maple', '1570', 'Pasadena', 'California', '91109'),
(null, 49, 'Acker', '107', 'Bronx', 'New York', '10469'),
(null, 50, 'Daystar', '309', 'Kansas City', 'Missouri', '64144'),
(null, 51, 'Brown', '1', 'Philadelphia', 'Pennsylvania', '19184'),
(null, 52, 'Myrtle', '1', 'Concord', 'California', '94522'),
(null, 53, 'Bluejay', '683', 'Lansing', 'Michigan', '48919'),
(null, 54, 'Waubesa', '957', 'Houston', 'Texas', '77080'),
(null, 25, 'Washington', '9', 'Tampa', 'Florida', '33694'),
(null, 56, 'Anhalt', '93', 'Boston', 'Massachusetts', '02163'),
(null, 57, 'Walton', '565', 'El Paso', 'Texas', '79950'),
(null, 58, 'Grover', '5', 'Hartford', 'Connecticut', '06105'),
(null, 59, 'Orin', '065', 'Gastonia', 'North Carolina', '28055'),
(null, 60, 'Springs', '7264', 'Palmdale', 'California', '93591'),
(null, 61, 'Westridge', '2347', 'Lexington', 'Kentucky', '40546'),
(null, 62, 'Northridge', '01', 'Johnstown', 'Pennsylvania', '15906'),
(null, 63, 'Old Shore', '9795', 'Atlanta', 'Georgia', '30343'),
(null, 64, 'Hallows', '10', 'Salt Lake City', 'Utah', '84145'),
(null, 65, 'Darwin', '2', 'Dayton', 'Ohio', '45426'),
(null, 66, 'Clove', '4697', 'Washington', 'District of Columbia', '20380'),
(null, 67, 'Sachtjen', '070', 'Seattle', 'Washington', '98109'),
(null, 68, 'Rigney', '3894', 'Monroe', 'Louisiana', '71208'),
(null, 69, 'Sloan', '66', 'Fort Lauderdale', 'Florida', '33330'),
(null, 70, 'Ramsey', '424', 'Lexington', 'Kentucky', '40505'),
(null, 71, 'Mosinee', '6975', 'Kansas City', 'Missouri', '64144'),
(null, 72, 'Pond', '789', 'Memphis', 'Tennessee', '38136'),
(null, 73, 'Nova', '222', 'Yakima', 'Washington', '98907'),
(null, 74, 'Dryden', '7', 'Evansville', 'Indiana', '47712'),
(null, 75, 'Nelson', '8136', 'Albuquerque', 'New Mexico', '87115'),
(null, 76, 'Jackson', '688', 'Gary', 'Indiana', '46406'),
(null, 77, 'Longview', '304', 'Fort Lauderdale', 'Florida', '33325'),
(null, 78, 'Lien', '23', 'Baltimore', 'Maryland', '21275'),
(null, 79, 'Dorton', '182', 'Milwaukee', 'Wisconsin', '53225'),
(null, 80, '8th', '7758', 'Dayton', 'Ohio', '45490'),
(null, 81, 'Birchwood', '5432', 'Dallas', 'Texas', '75231'),
(null, 82, 'Golden Leaf', '8293', 'Southfield', 'Michigan', '48076'),
(null, 83, 'Bonner', '53', 'New York City', 'New York', '10249'),
(null, 84, 'Annamark', '7204', 'Cincinnati', 'Ohio', '45203'),
(null, 29, 'Corscot', '4501', 'Newport Beach', 'California', '92662'),
(null, 86, 'Warbler', '1226', 'Newton', 'Massachusetts', '02162'),
(null, 87, 'Fieldstone', '1515', 'Raleigh', 'North Carolina', '27610'),
(null, 88, 'Di Loreto', '4173', 'Saint Paul', 'Minnesota', '55108'),
(null, 89, 'Nancy', '78', 'Brockton', 'Massachusetts', '02405'),
(null, 90, 'Golf View', '63', 'Allentown', 'Pennsylvania', '18105'),
(null, 91, 'Brown', '424', 'Everett', 'Washington', '98206'),
(null, 92, 'Springs', '2078', 'Riverside', 'California', '92513'),
(null, 93, 'Bowman', '9450', 'Aurora', 'Colorado', '80044'),
(null, 94, 'Springs', '5729', 'Kansas City', 'Missouri', '64101'),
(null, 95, 'Lotheville', '93', 'Alhambra', 'California', '91841'),
(null, 96, 'Clarendon', '145', 'Dallas', 'Texas', '75342'),
(null, 97, 'Onsgard', '678', 'El Paso', 'Texas', '79989'),
(null, 98, 'Blackbird', '721', 'Idaho Falls', 'Idaho', '83405'),
(null, 99, 'Delaware', '456', 'Detroit', 'Michigan', '48275'),
(null, 100, 'Rigney', '0132', 'Miami', 'Florida', '33283'),
(null, 101, 'Sloan', '3186', 'Portsmouth', 'Virginia', '23705'),
(null, 102, 'Nevada', '9318', 'Omaha', 'Nebraska', '68164'),
(null, 103, 'Jenna', '390', 'Lake Charles', 'Louisiana', '70616'),
(null, 104, 'Ridgeway', '2131', 'Fort Smith', 'Arkansas', '72905'),
(null, 105, 'Sommers', '59', 'Alexandria', 'Virginia', '22309'),
(null, 106, 'Arapahoe', '2505', 'Van Nuys', 'California', '91499'),
(null, 107, 'Carpenter', '18', 'Anchorage', 'Alaska', '99507'),
(null, 108, 'Messerschmidt', '14', 'Springfield', 'Illinois', '62764'),
(null, 109, '3rd', '1305', 'Washington', 'District of Columbia', '20503'),
(null, 110, 'West', '814', 'Pittsburgh', 'Pennsylvania', '15220'),
(null, 111, 'Dahle', '91', 'Newport News', 'Virginia', '23605'),
(null, 112, 'Spaight', '3690', 'West Palm Beach', 'Florida', '33416'),
(null, 113, 'Morrow', '442', 'Little Rock', 'Arkansas', '72222'),
(null, 114, 'Melody', '6815', 'Charlottesville', 'Virginia', '22903'),
(null, 40, 'Debra', '420', 'Daytona Beach', 'Florida', '32118'),
(null, 116, 'Trailsway', '356', 'Kansas City', 'Missouri', '64142'),
(null, 117, 'Coolidge', '1037', 'Mount Vernon', 'New York', '10557'),
(null, 118, 'Manufacturers', '378', 'Philadelphia', 'Pennsylvania', '19184'),
(null, 119, 'Carberry', '70', 'Southfield', 'Michigan', '48076'),
(null, 120, 'Lukken', '5318', 'New York City', 'New York', '10029'),
(null, 121, 'Calypso', '27', 'San Antonio', 'Texas', '78215'),
(null, 122, 'Comanche', '992', 'Detroit', 'Michigan', '48295'),
(null, 123, 'Oak Valley', '838', 'Albuquerque', 'New Mexico', '87115'),
(null, 124, 'Main', '44', 'Syracuse', 'New York', '13251'),
(null, 125, 'Swallow', '346', 'Springfield', 'Illinois', '62756'),
(null, 126, 'Wayridge', '575', 'Buffalo', 'New York', '14269'),
(null, 127, 'Forest Run', '992', 'Sacramento', 'California', '95818'),
(null, 128, 'Golf', '8546', 'Dayton', 'Ohio', '45419'),
(null, 129, 'Memorial', '2289', 'Salt Lake City', 'Utah', '84105'),
(null, 130, 'Kipling', '9', 'New Orleans', 'Louisiana', '70154'),
(null, 131, 'Gateway', '120', 'Pensacola', 'Florida', '32505'),
(null, 132, 'La Follette', '243', 'Dallas', 'Texas', '75205'),
(null, 133, 'Reindahl', '45', 'Dallas', 'Texas', '75277'),
(null, 134, 'Stephen', '67', 'Delray Beach', 'Florida', '33448'),
(null, 135, 'Garrison', '580', 'New Orleans', 'Louisiana', '70187'),
(null, 136, 'Chinook', '45', 'Grand Rapids', 'Michigan', '49505'),
(null, 137, 'Havey', '6443', 'Irvine', 'California', '92717'),
(null, 138, 'Farwell', '809', 'Philadelphia', 'Pennsylvania', '19125'),
(null, 139, 'Forster', '41', 'New Orleans', 'Louisiana', '70183'),
(null, 140, 'Rockefeller', '139', 'Staten Island', 'New York', '10310'),
(null, 141, '7th', '8654', 'Bronx', 'New York', '10464'),
(null, 142, 'Cherokee', '4940', 'Greensboro', 'North Carolina', '27425'),
(null, 143, 'Badeau', '0877', 'Carol Stream', 'Illinois', '60158'),
(null, 144, 'Rigney', '158', 'Miami', 'Florida', '33196'),
(null, 145, 'Glendale', '66', 'Fresno', 'California', '93704'),
(null, 146, 'Sullivan', '2448', 'Denver', 'Colorado', '80299'),
(null, 147, 'Shopko', '484', 'Akron', 'Ohio', '44393'),
(null, 148, 'Hudson', '1235', 'Trenton', 'New Jersey', '08603'),
(null, 149, 'Leroy', '59', 'Duluth', 'Georgia', '30195'),
(null, 150, 'Northridge', '654', 'Norfolk', 'Virginia', '23520'),
(1, null, 'Merchant', '266', 'Wichita', 'Kansas', '67230'),
(2, null, 'Mallard', '89', 'Reno', 'Nevada', '89510'),
(3, null, 'Fisk', '3303', 'Sacramento', 'California', '95823'),
(4, null, 'Rigney', '256', 'Miami', 'Florida', '33283'),
(5, null, 'Bonner', '6013', 'New York City', 'New York', '10249'),
(6, null, 'Mariners Cove', '745', 'Roanoke', 'Virginia', '24020'),
(7, null, 'Annamark', '124', 'Cincinnati', 'Ohio', '45203'),
(8, null, '3rd', '5565', 'Washington', 'District of Columbia', '20503'),
(9, null, 'Sycamore', '5606', 'Chicago', 'Illinois', '60604'),
(10, null, 'Sachtjen', '230', 'Seattle', 'Washington', '98109');

INSERT INTO insurance.license (customer_id, lic_issued_date, lic_expire_date, license_active)
VALUES
(1, '2021-09-24', '2026-09-24', 1),
(2, '2020-06-18', '2025-06-18', 1),
(3, '2017-11-19', '2022-11-19', 0),
(4, '2023-08-10', '2028-08-10', 1),
(5, '2022-09-22', '2027-09-22', 1),
(6, '2022-10-22', '2027-10-22', 1),
(7, '2017-08-01', '2022-08-01', 0),
(8, '2016-07-08', '2021-07-08', 0),
(8, '2021-07-01', '2026-07-01', 1),
(10, '2022-11-23', '2027-11-23', 1),
(11, '2011-03-31', '2016-03-31', 0),
(12, '2021-05-17', '2026-05-17', 1),
(13, '2018-09-09', '2023-09-09', 1),
(14, '2020-02-08', '2025-02-08', 1),
(15, '2021-02-09', '2026-02-09', 1),
(16, '2020-09-22', '2025-09-22', 1),
(17, '2019-07-17', '2024-07-17', 1),
(18, '2021-09-13', '2026-09-13', 1),
(19, '2018-01-15', '2023-01-15', 0),
(19, '2023-02-13', '2028-02-13', 1),
(21, '2022-03-03', '2027-03-03', 1),
(22, '2016-07-18', '2021-07-18', 0),
(23, '2018-09-19', '2023-09-19', 1),
(24, '2022-08-16', '2027-08-16', 1),
(25, '2021-09-15', '2026-09-15', 1),
(26, '2020-11-22', '2025-11-22', 1),
(27, '2018-05-22', '2023-05-22', 0),
(28, '2020-08-13', '2025-08-13', 1),
(29, '2018-10-19', '2023-10-19', 1),
(30, '2021-10-16', '2026-10-16', 1),
(31, '2020-08-16', '2025-08-16', 1),
(32, '2019-08-12', '2024-08-12', 1),
(33, '2020-12-25', '2025-12-25', 1),
(34, '2018-06-19', '2023-06-19', 0),
(35, '2022-01-19', '2027-01-19', 1),
(36, '2013-07-14', '2018-07-14', 0),
(37, '2020-05-12', '2025-05-12', 1),
(38, '2019-05-18', '2024-05-18', 1),
(39, '2021-02-05', '2026-02-05', 1),
(40, '2017-11-23', '2022-11-23', 0),
(41, '2018-03-14', '2023-03-14', 0),
(42, '2021-02-21', '2026-02-21', 1),
(43, '2018-08-15', '2023-08-15', 1),
(44, '2020-11-11', '2025-11-11', 1),
(45, '2021-02-10', '2026-02-10', 1),
(46, '2022-07-31', '2027-07-31', 1),
(47, '2020-07-14', '2025-07-14', 1),
(48, '2016-10-29', '2021-10-29', 0),
(49, '2018-08-31', '2023-08-31', 1),
(50, '2022-01-20', '2027-01-20', 1),
(51, '2016-06-25', '2021-06-25', 0),
(52, '2018-12-31', '2023-12-31', 1),
(53, '2012-11-20', '2017-11-20', 0),
(53, '2017-11-12', '2022-11-12', 0),
(53, '2022-10-20', '2027-10-20', 1),
(56, '2021-02-12', '2026-02-12', 1),
(57, '2023-01-23', '2028-01-23', 1),
(58, '2020-10-28', '2025-10-28', 1),
(59, '2018-05-12', '2023-05-12', 0),
(60, '2018-02-07', '2023-02-07', 0),
(60, '2023-02-05', '2028-02-05', 1),
(62, '2022-02-22', '2027-02-22', 1),
(63, '2021-07-14', '2026-07-14', 1),
(64, '2023-01-27', '2028-01-27', 1),
(65, '2018-10-09', '2023-10-09', 1),
(66, '2022-02-25', '2027-02-25', 1),
(67, '2016-11-15', '2021-11-15', 0),
(67, '2021-11-10', '2026-11-10', 1),
(69, '2022-05-20', '2027-05-20', 1),
(70, '2018-12-08', '2023-12-08', 1),
(71, '2022-02-28', '2027-02-28', 1),
(72, '2019-04-23', '2024-04-23', 1),
(73, '2018-10-31', '2023-10-31', 1),
(74, '2021-10-13', '2026-10-13', 1),
(75, '2020-01-15', '2025-01-15', 1),
(76, '2019-05-25', '2024-05-25', 1),
(77, '2010-04-15', '2015-04-15', 0),
(78, '2020-07-15', '2025-07-15', 1),
(79, '2018-08-17', '2023-08-17', 1),
(80, '2019-03-08', '2024-03-08', 1),
(81, '2022-08-16', '2027-08-16', 1),
(82, '2020-02-14', '2025-02-14', 1),
(83, '2022-06-17', '2027-06-17', 1),
(84, '2020-04-23', '2025-04-23', 1),
(85, '2019-05-10', '2024-05-10', 1),
(86, '2014-11-25', '2019-11-25', 0),
(86, '2019-11-20', '2024-11-20', 1),
(88, '2021-01-13', '2026-01-13', 1),
(89, '2021-04-25', '2026-04-25', 1),
(90, '2022-04-17', '2027-04-17', 1),
(91, '2023-02-17', '2028-02-17', 1),
(92, '2021-02-09', '2026-02-09', 1),
(93, '2022-08-26', '2027-08-26', 1),
(94, '2022-07-10', '2027-07-10', 1),
(95, '2011-10-15', '2016-10-15', 0),
(95, '2016-10-13', '2021-10-13', 0),
(95, '2021-11-25', '2026-11-25', 1),
(98, '2017-04-12', '2022-04-12', 0),
(99, '2019-09-13', '2024-09-13', 1),
(100, '2018-03-28', '2023-03-28', 0),
(20, '2019-08-23', '2024-08-23', 1),
(55, '2023-04-30', '2028-04-30', 1),
(13, '2023-07-20', '2028-07-20', 1),
(61, '2019-06-28', '2024-06-28', 1),
(68, '2017-11-28', '2022-11-28', 0),
(87, '2018-08-25', '2023-08-25', 1),
(54, '2019-08-05', '2024-08-05', 1),
(9, '2021-06-04', '2026-06-04', 1),
(96, '2018-12-19', '2023-12-19', 1),
(97, '2021-03-28', '2026-03-28', 1),
(100, '2023-03-20', '2028-03-20', 1),
(98, '2022-04-18', '2027-04-18', 1),
(22, '2021-07-10', '2026-07-10', 1),
(77, '2015-04-08', '2020-04-08', 0),
(77, '2020-05-06', '2025-05-06', 1),
(36, '2018-08-01', '2023-08-01', 1),
(51, '2021-07-10', '2026-07-10', 1),
(11, '2016-04-04', '2021-04-04', 0),
(11, '2022-03-20', '2027-03-20', 1),
(68, '2022-12-05', '2027-12-05', 1);

INSERT INTO insurance.coverage (coverage_id, coverage_type, coverage_desc, coverage_price, max_coverage)
VALUES
(11, 'Liability coverage', 'Auto liability coverage is mandatory. This includes Bodily injury liability and Property damage liability', 200.00, 50000.00),
(12, 'Uninsured and underinsured motorist coverage', 'Covers medical bills or repairs to your vehicle if you are hit by a driver who does not have insurance or an underinsured driver', 100.00, 50000.00),
(13, 'Comprehensive coverage', 'Covers damage to your car from things like theft, fire, hail or vandalism. It may pay to repair or replace your vehicle.', 100.00, 10000.00),
(14, 'Collision coverage', 'Covers accident with another vehicle, or if you hit an object such as a fence. It may pay to repair or replace your vehicle', 100.00, 20000.00),
(15, 'Medical payments coverage', 'If you, your passengers or family members who are driving the insured vehicle are injured in an accident, it may pays costs associated with the injuries', 500.00, 500000.00),
(21, 'Home coverage', 'Protects homes against loss or damage caused due to theft, fire, or natural & manmade disasters', 200.00, 50000.00),
(22, 'Commercial coverage', 'Covers business units, shops, factories, warehouses, etc. Financial losses caused to commercial properties due to natural disasters are also covered', 5000.00, 3000000.00),
(23, 'Renters coverage', 'Covers loss or damages caused to the property by tenants. Electronic appliances, furniture, fittings, and other expensive installations are also covered', 50.00, 10000.00),
(24, 'Fire coverage', 'Protects properties against losses or damages caused due to fire. This plan covers fire accidents caused due to explosions, implosions, and lightning', 1000.00, 1000000.00),
(25, 'Public liability coverage', 'Protects property owners against the losses or damages caused within their property and losses caused to customers. Used on commercial properties such as restaurants and hotels', 2000.00, 2000000.00);

INSERT INTO insurance.policy (property_id, vehicle_id, policy_category, coverage_id, issued_date, expire_date, policy_active)
VALUES 
(1, null, 'Property Insurance', 21, '2022-11-02', '2023-11-02', 1),
(2, null, 'Property Insurance', 21, '2022-08-17', '2023-08-17', 1),
(3, null, 'Property Insurance', 21, '2023-07-07', '2024-07-06', 1),
(4, null, 'Property Insurance', 21, '2023-05-18', '2024-05-17', 1),
(5, null, 'Property Insurance', 21, '2023-05-28', '2024-05-27', 1),
(6, null, 'Property Insurance', 21, '2022-10-28', '2023-10-28', 1),
(7, null, 'Property Insurance', 21, '2023-05-08', '2023-05-08', 0),
(8, null, 'Property Insurance', 21, '2022-10-30', '2023-10-30', 1),
(9, null, 'Property Insurance', 21, '2023-03-02', '2024-03-01', 1),
(10, null, 'Property Insurance', 21, '2023-04-16', '2024-04-15', 1),
(11, null, 'Property Insurance', 21, '2022-11-23', '2023-11-23', 1),
(12, null, 'Property Insurance', 21, '2023-02-17', '2024-02-17', 1),
(13, null, 'Property Insurance', 22, '2022-12-17', '2023-12-17', 1),
(14, null, 'Property Insurance', 21, '2023-02-15', '2024-02-15', 1),
(15, null, 'Property Insurance', 21, '2022-07-30', '2023-07-30', 1),
(16, null, 'Property Insurance', 21, '2023-07-10', '2024-07-09', 1),
(17, null, 'Property Insurance', 21, '2022-10-11', '2023-10-11', 1),
(17, null, 'Property Insurance', 24, '2022-10-11', '2023-10-11', 1),
(18, null, 'Property Insurance', 21, '2022-12-12', '2023-12-12', 1),
(19, null, 'Property Insurance', 21, '2023-04-25', '2023-04-25', 0),
(20, null, 'Property Insurance', 21, '2022-11-16', '2022-11-16', 0),
(21, null, 'Property Insurance', 21, '2023-02-25', '2024-02-25', 1),
(22, null, 'Property Insurance', 21, '2023-01-21', '2024-01-21', 1),
(23, null, 'Property Insurance', 21, '2022-09-16', '2023-09-16', 1),
(24, null, 'Property Insurance', 21, '2022-10-07', '2022-11-01', 0),
(24, null, 'Property Insurance', 21, '2023-05-04', '2023-11-01', 1),
(26, null, 'Property Insurance', 21, '2023-04-07', '2024-04-06', 1),
(27, null, 'Property Insurance', 21, '2022-10-08', '2023-10-08', 1),
(28, null, 'Property Insurance', 21, '2022-10-24', '2023-10-24', 1),
(29, null, 'Property Insurance', 24, '2023-06-24', '2024-06-23', 1),
(30, null, 'Property Insurance', 21, '2022-08-29', '2023-08-29', 1),
(31, null, 'Property Insurance', 21, '2023-06-18', '2024-06-17', 1),
(32, null, 'Property Insurance', 21, '2023-06-14', '2024-06-13', 1),
(33, null, 'Property Insurance', 21, '2023-01-29', '2024-01-29', 1),
(34, null, 'Property Insurance', 21, '2022-08-22', '2023-08-22', 1),
(35, null, 'Property Insurance', 21, '2023-03-22', '2024-03-21', 1),
(36, null, 'Property Insurance', 21, '2022-10-04', '2023-10-04', 1),
(37, null, 'Property Insurance', 21, '2023-06-20', '2024-06-19', 1),
(38, null, 'Property Insurance', 21, '2023-06-26', '2024-06-25', 1),
(39, null, 'Property Insurance', 21, '2023-07-15', '2024-07-14', 1),
(40, null, 'Property Insurance', 21, '2023-05-01', '2024-04-30', 1),
(null, 48, 'Automobile Insurance', 11, '2022-08-13', '2023-08-13', 1),
(null, 48, 'Automobile Insurance', 12, '2022-08-13', '2023-08-13', 1),
(null, 49, 'Automobile Insurance', 11, '2022-10-12', '2023-10-12', 1),
(null, 50, 'Automobile Insurance', 11, '2022-12-02', '2023-12-02', 1),
(null, 51, 'Automobile Insurance', 11, '2022-11-03', '2023-11-03', 1),
(null, 52, 'Automobile Insurance', 11, '2023-01-03', '2024-01-03', 1),
(null, 53, 'Automobile Insurance', 11, '2023-01-25', '2024-01-25', 1),
(null, 54, 'Automobile Insurance', 11, '2022-10-08', '2023-10-08', 1),
(null, 54, 'Automobile Insurance', 12, '2022-10-08', '2023-10-08', 1),
(null, 54, 'Automobile Insurance', 15, '2022-10-08', '2023-10-08', 1),
(null, 55, 'Automobile Insurance', 11, '2022-09-02', '2023-09-02', 1),
(null, 56, 'Automobile Insurance', 11, '2023-03-04', '2024-03-03', 1),
(null, 57, 'Automobile Insurance', 11, '2022-10-15', '2023-10-15', 1),
(null, 58, 'Automobile Insurance', 11, '2022-09-06', '2022-09-06', 0),
(null, 58, 'Automobile Insurance', 11, '2022-08-18', '2023-09-03', 1),
(null, 58, 'Automobile Insurance', 12, '2022-08-18', '2023-09-03', 1),
(null, 60, 'Automobile Insurance', 11, '2023-02-13', '2024-02-13', 1),
(null, 61, 'Automobile Insurance', 11, '2023-02-22', '2024-02-22', 1),
(null, 62, 'Automobile Insurance', 11, '2023-06-30', '2024-06-29', 1),
(null, 62, 'Automobile Insurance', 12, '2023-06-30', '2024-06-29', 1),
(null, 62, 'Automobile Insurance', 13, '2023-06-30', '2024-06-29', 1),
(null, 63, 'Automobile Insurance', 11, '2023-03-24', '2024-03-23', 1),
(null, 64, 'Automobile Insurance', 11, '2023-03-26', '2024-03-25', 1),
(null, 65, 'Automobile Insurance', 11, '2023-02-26', '2024-02-26', 1),
(null, 66, 'Automobile Insurance', 11, '2023-03-28', '2024-03-27', 1),
(null, 67, 'Automobile Insurance', 11, '2022-12-05', '2023-12-05', 1),
(null, 68, 'Automobile Insurance', 11, '2023-01-12', '2024-01-12', 1),
(null, 68, 'Automobile Insurance', 12, '2023-01-12', '2024-01-12', 1),
(null, 68, 'Automobile Insurance', 13, '2023-01-12', '2024-01-12', 1),
(null, 69, 'Automobile Insurance', 11, '2023-07-04', '2024-07-03', 1),
(null, 70, 'Automobile Insurance', 11, '2023-04-21', '2021-04-21', 0),
(null, 71, 'Automobile Insurance', 11, '2022-08-14', '2023-08-14', 1),
(null, 72, 'Automobile Insurance', 11, '2023-01-12', '2024-01-12', 1),
(null, 73, 'Automobile Insurance', 11, '2023-07-06', '2024-07-05', 1),
(null, 73, 'Automobile Insurance', 12, '2023-07-06', '2024-07-05', 1),
(null, 74, 'Automobile Insurance', 11, '2023-04-15', '2024-04-14', 1),
(null, 75, 'Automobile Insurance', 11, '2022-08-24', '2023-08-24', 1),
(null, 76, 'Automobile Insurance', 11, '2022-09-01', '2023-09-01', 1),
(null, 77, 'Automobile Insurance', 11, '2023-03-19', '2024-03-18', 1),
(null, 77, 'Automobile Insurance', 12, '2023-03-19', '2024-03-18', 1),
(null, 78, 'Automobile Insurance', 11, '2023-02-07', '2024-02-07', 1),
(null, 78, 'Automobile Insurance', 12, '2023-02-07', '2024-02-07', 1),
(null, 79, 'Automobile Insurance', 11, '2022-12-04', '2023-12-04', 1),
(null, 80, 'Automobile Insurance', 11, '2023-02-22', '2024-02-22', 1),
(null, 81, 'Automobile Insurance', 11, '2023-05-28', '2024-05-27', 1),
(null, 81, 'Automobile Insurance', 12, '2023-05-28', '2024-05-27', 1),
(null, 82, 'Automobile Insurance', 11, '2023-05-05', '2024-05-04', 1),
(null, 83, 'Automobile Insurance', 11, '2022-08-21', '2023-08-21', 1),
(null, 84, 'Automobile Insurance', 11, '2023-01-06', '2023-01-06', 0),
(null, 85, 'Automobile Insurance', 11, '2023-01-03', '2024-01-03', 1),
(null, 86, 'Automobile Insurance', 11, '2022-10-08', '2023-10-08', 1),
(null, 87, 'Automobile Insurance', 11, '2023-01-20', '2024-01-20', 1),
(null, 88, 'Automobile Insurance', 11, '2023-06-08', '2024-06-07', 1),
(null, 89, 'Automobile Insurance', 11, '2023-01-22', '2024-01-22', 1),
(null, 90, 'Automobile Insurance', 11, '2023-01-02', '2024-01-02', 1),
(null, 91, 'Automobile Insurance', 11, '2023-05-22', '2024-05-21', 1),
(null, 92, 'Automobile Insurance', 11, '2022-08-09', '2023-08-09', 1),
(null, 92, 'Automobile Insurance', 12, '2022-08-09', '2023-08-09', 1),
(null, 93, 'Automobile Insurance', 11, '2023-01-24', '2024-01-24', 1),
(null, 94, 'Automobile Insurance', 11, '2023-03-02', '2024-03-01', 1),
(null, 95, 'Automobile Insurance', 11, '2023-07-07', '2024-07-06', 1),
(null, 96, 'Automobile Insurance', 11, '2023-03-27', '2024-03-26', 1),
(null, 97, 'Automobile Insurance', 11, '2023-02-24', '2024-02-24', 1),
(null, 98, 'Automobile Insurance', 11, '2022-09-05', '2023-09-05', 1),
(null, 99, 'Automobile Insurance', 11, '2023-01-26', '2021-01-25', 0),
(null, 102, 'Automobile Insurance', 11, '2022-12-02', '2023-12-02', 1),
(null, 103, 'Automobile Insurance', 11, '2022-10-05', '2023-10-05', 1),
(null, 103, 'Automobile Insurance', 12, '2022-10-05', '2023-10-05', 1),
(null, 103, 'Automobile Insurance', 13, '2022-10-05', '2023-10-05', 1),
(null, 103, 'Automobile Insurance', 14, '2022-10-05', '2023-10-05', 1),
(null, 103, 'Automobile Insurance', 15, '2022-10-05', '2023-10-05', 1),
(92, null, 'Property Insurance', 22, '2022-09-26', '2023-09-26', 1),
(93, null, 'Property Insurance', 22, '2023-03-29', '2024-03-28', 1),
(94, null, 'Property Insurance', 22, '2023-02-21', '2024-02-21', 1),
(94, null, 'Property Insurance', 25, '2023-02-21', '2024-02-21', 1),
(95, null, 'Property Insurance', 22, '2023-01-16', '2024-01-16', 1),
(96, null, 'Property Insurance', 22, '2023-05-02', '2024-05-01', 1),
(97, null, 'Property Insurance', 22, '2022-12-31', '2023-12-31', 1),
(98, null, 'Property Insurance', 22, '2022-09-21', '2023-09-21', 1),
(99, null, 'Property Insurance', 22, '2022-12-08', '2022-12-08', 0),
(99, null, 'Property Insurance', 22, '2023-03-24', '2023-12-08', 1),
(101, null, 'Property Insurance', 22, '2023-05-10', '2024-05-09', 1),
(101, null, 'Property Insurance', 25, '2023-05-10', '2024-05-09', 1),
(101, null, 'Property Insurance', 24, '2023-05-10', '2024-05-09', 1),
(102, null, 'Property Insurance', 22, '2023-03-31', '2024-03-30', 1),
(102, null, 'Property Insurance', 25, '2023-03-31', '2024-03-30', 1),
(103, null, 'Property Insurance', 22, '2022-10-03', '2023-10-03', 1),
(104, null, 'Property Insurance', 22, '2023-01-28', '2024-01-28', 1),
(104, null, 'Property Insurance', 24, '2023-01-28', '2024-01-28', 1),
(105, null, 'Property Insurance', 22, '2022-12-17', '2021-12-17', 0),
(105, null, 'Property Insurance', 22, '2022-11-12', '2022-12-10', 0),
(105, null, 'Property Insurance', 22, '2023-12-14', '2024-12-14', 1),
(106, null, 'Property Insurance', 25, '2023-03-16', '2024-11-16', 1),
(108, null, 'Property Insurance', 25, '2022-08-18', '2023-08-18', 1),
(109, null, 'Property Insurance', 25, '2023-06-12', '2024-06-11', 1),
(110, null, 'Property Insurance', 25, '2022-10-01', '2023-10-01', 1),
(111, null, 'Property Insurance', 22, '2022-10-16', '2023-10-16', 1),
(111, null, 'Property Insurance', 24, '2022-10-16', '2023-10-16', 1),
(112, null, 'Property Insurance', 22, '2023-01-25', '2024-01-25', 1),
(113, null, 'Property Insurance', 22, '2023-07-12', '2024-07-11', 1),
(114, null, 'Property Insurance', 22, '2022-12-06', '2023-12-06', 1),
(115, null, 'Property Insurance', 25, '2023-04-11', '2024-04-10', 1),
(116, null, 'Property Insurance', 25, '2023-03-22', '2023-03-22', 0),
(117, null, 'Property Insurance', 22, '2023-03-26', '2024-03-25', 1),
(117, null, 'Property Insurance', 24, '2023-03-26', '2024-03-25', 1),
(118, null, 'Property Insurance', 22, '2023-07-01', '2024-06-30', 1),
(119, null, 'Property Insurance', 22, '2023-02-07', '2024-02-07', 1),
(120, null, 'Property Insurance', 22, '2022-08-17', '2022-08-17', 0),
(120, null, 'Property Insurance', 24, '2022-08-17', '2022-08-17', 0),
(121, null, 'Property Insurance', 22, '2023-03-05', '2024-03-04', 1),
(122, null, 'Property Insurance', 22, '2022-11-13', '2023-11-13', 1),
(123, null, 'Property Insurance', 25, '2022-12-11', '2023-12-11', 1),
(124, null, 'Property Insurance', 22, '2023-07-07', '2024-07-06', 1),
(124, null, 'Property Insurance', 24, '2023-07-07', '2024-07-06', 1),
(124, null, 'Property Insurance', 25, '2023-07-07', '2024-07-06', 1),
(125, null, 'Property Insurance', 22, '2023-07-16', '2024-07-15', 1),
(126, null, 'Property Insurance', 22, '2023-02-05', '2024-02-05', 1),
(126, null, 'Property Insurance', 24, '2023-02-05', '2024-02-05', 1),
(126, null, 'Property Insurance', 25, '2023-02-05', '2024-02-05', 1),
(127, null, 'Property Insurance', 25, '2022-11-06', '2023-11-06', 1),
(128, null, 'Property Insurance', 25, '2022-09-01', '2023-09-01', 1),
(129, null, 'Property Insurance', 22, '2023-07-21', '2024-07-20', 1),
(130, null, 'Property Insurance', 23, '2023-01-14', '2024-01-14', 1),
(131, null, 'Property Insurance', 22, '2022-08-04', '2023-08-04', 1),
(132, null, 'Property Insurance', 23, '2023-06-11', '2024-06-10', 1),
(133, null, 'Property Insurance', 23, '2023-03-19', '2024-03-18', 1),
(134, null, 'Property Insurance', 22, '2023-02-02', '2024-02-02', 1),
(135, null, 'Property Insurance', 22, '2022-11-05', '2023-11-05', 1),
(136, null, 'Property Insurance', 23, '2023-04-14', '2024-04-13', 1),
(137, null, 'Property Insurance', 22, '2023-03-25', '2024-03-24', 1),
(138, null, 'Property Insurance', 22, '2023-03-03', '2024-03-02', 1),
(139, null, 'Property Insurance', 22, '2023-04-20', '2024-04-19', 1),
(140, null, 'Property Insurance', 23, '2022-09-27', '2023-09-27', 1),
(141, null, 'Property Insurance', 22, '2022-11-21', '2023-11-21', 1),
(null, 115, 'Automobile Insurance', 11, '2023-07-22', '2024-07-21', 1),
(null, 116, 'Automobile Insurance', 11, '2023-07-13', '2024-07-12', 1),
(null, 116, 'Automobile Insurance', 12, '2023-07-13', '2024-07-12', 1),
(null, 116, 'Automobile Insurance', 13, '2023-07-13', '2024-07-12', 1),
(null, 116, 'Automobile Insurance', 14, '2023-07-13', '2024-07-12', 1),
(null, 116, 'Automobile Insurance', 15, '2023-07-13', '2024-07-12', 1),
(null, 117, 'Automobile Insurance', 11, '2022-12-06', '2023-12-06', 1),
(null, 118, 'Automobile Insurance', 11, '2022-12-18', '2023-12-18', 1),
(null, 119, 'Automobile Insurance', 11, '2022-09-25', '2023-09-25', 1),
(null, 119, 'Automobile Insurance', 12, '2022-09-25', '2023-09-25', 1),
(null, 120, 'Automobile Insurance', 11, '2023-02-28', '2024-02-28', 1);

INSERT INTO insurance.incident (report_number, property_id, vehicle_id, incident_type, incident_date, incident_location, incident_record, damage_estimate, at_fault)
VALUES
(1, null, 1, 'Rear-end collision', '2023-07-21 20:09:08', 'Chinook Plaza & Badeau Crossing, Fort Smith, AR', null, 1561.39, 1),
(2, null, 2, 'T-bone accident', '2023-05-29 03:33:22', 'Amoth Court & Hoard Hill, Jackson, MS', null, 615.34, 1),
(3, null, 3, 'T-bone accident', '2023-07-01 16:41:23', 'Shasta Trail & Lake View Alley, Wichita, KS', null, 8205.23, 1),
(4, null, 4, 'Sideswipe accident', '2023-07-21 22:40:08', 'Carey Parkway & Orin Drive, Washington, DC', null, 9237.91, 0),
(5, null, 5, 'T-bone accident', '2023-05-25 11:32:44', 'Lindbergh Court & Sugar Crossing, Buffalo, NY', null, 2899.36, 0),
(6, null, 6, 'T-bone accident', '2023-04-27 11:34:54', 'Center Center & Rusk Lane, Las Cruces, NM', null, 8884.68, 1),
(7, null, 7, 'T-bone accident', '2023-07-17 21:47:44', 'Kings Park & Garrison Lane, El Paso, TX', null, 1123.18, 1),
(8, null, 8, 'T-bone accident', '2023-03-23 16:38:38', ' Morning Place & Barnett Way, Denver, CO', null, 6426.23, 0),
(9, null, 116, 'T-bone accident', '2023-05-15 09:34:34', 'Rutledge Place & Nobel Drive, Gulfport, MS', null, 7709.55, 1),
(10, null, 25, 'Sideswipe accident', '2023-03-06 07:33:10', 'Acker Hill & Sundown Park, Brooklyn, NY', null, 8290.50, 0),
(11, null, 26, 'Rear-end collision', '2023-04-12 09:20:39', 'Warner Drive & 2nd Point, Milwaukee, WI', null, 8471.44, 1),
(12, null, 27, 'Single-vehicle crash', '2023-02-15 04:25:41', 'Banding Court & Dayton Hill, San Diego, CA', null, 3177.17, 0),
(13, null, 28, 'Sideswipe accident', '2023-05-28 11:51:08', 'Monica Circle & Boyd Junction, Atlanta, GA', null, 6782.15, 1),
(14, null, 29, 'Rear-end collision', '2023-04-03 12:08:11', 'Mayer Plaza & Golf Place, Wilmington, DE', null, 1520.30, 1),
(15, null, 30, 'Rear-end collision', '2023-02-13 05:19:10', 'Schmedeman Place & Acker Terrace, Minneapolis, MN', null, 5390.42, 0),
(16, null, 31, 'Rear-end collision', '2023-05-11 08:01:12', 'Forest Avenue & Fair Oaks Street, Youngstown, OH', null, 6966.83, 0),
(17, null, 32, 'Rear-end collision', '2023-06-13 16:41:41', 'Moulton Crossing & 2nd Parkway, Buffalo, NY', null, 916.45, 1),
(18, null, 33, 'Single-vehicle crash', '2023-03-12 08:05:54', 'American Crossing & Briar Crest Junction, San Jose, CA', null, 3400.38, 1),
(19, null, 34, 'Rear-end collision', '2023-03-31 21:14:35', 'Nancy Center & Mandrake Hill, Santa Rosa, CA', null, 7909.87, 1),
(20, null, 35, 'Rear-end collision', '2023-03-29 04:15:06', '345 Lakewood Gardens Trail, Abilene, TX', null, 6416.80, 0),
(21, null, 36, 'Rear-end collision', '2023-02-19 23:24:11', '233 Hermina Plaza, Colorado Springs, CO', null, 5105.97, 0),
(22, null, 37, 'Rear-end collision', '2023-03-09 05:05:45', 'Anhalt Court & Russell Street, Akron, OH', null, 8280.58, 0),
(23, null, 38, 'Head-on collision', '2023-06-12 00:30:26', 'Sloan Court & Thompson Junction, Newport Beach, CA', null, 6199.65, 1),
(24, null, 39, 'Rear-end collision', '2023-05-21 07:04:10', 'Clyde Gallagher Point & Tony Trail, San Angelo, TX', null, 958.36, 1),
(25, null, 40, 'Low-speed accident', '2023-06-11 19:06:22', '3293 Mcguire Lane, Charlotte, NC', null, 9026.62, 0),
(26, null, 41, 'Single-vehicle crash', '2023-04-11 09:04:16', 'Forest Run Pass & Morning Street, Madison, WI', null, 8285.38, 1),
(27, null, 42, 'Rear-end collision', '2023-04-07 13:03:58', 'Veith Place & Arkansas Drive, Salt Lake City, UT', null, 2988.53, 1),
(28, null, 43, 'Rear-end collision', '2023-04-15 22:41:14', 'Manley Trail & Bobwhite Circle, Nashville, TN', null, 8632.10, 1),
(29, null, 44, 'Single-vehicle crash', '2023-02-06 12:53:36', 'Cody Trail & Thierer Plaza, Moreno Valley, CA', null, 8238.91, 0),
(30, null, 45, 'Rear-end collision', '2023-05-03 09:18:09', 'Schurz Lane & Maywood Center, Fort Wayne, IN', null, 8724.48, 0),
(31, 10, null, 'Water Damage', '2023-07-03 00:10:28', '205 Golden Leaf, Vero Beach, FL', null, 4105.28, null),
(32, 11, null, 'Fire Damage', '2023-04-11 17:49:12', '8897 Mockingbird, Dallas, TX', null, 5245.48, null),
(33, 12, null, 'Water Damage', '2023-07-17 23:57:44', '341 Sycamore, Chicago, IL', null, 1769.75, null),
(34, 13, null, 'Water Damage', '2023-04-05 16:53:58', '5 Stone Corner, Salt Lake City, UT', null, 660.76, null),
(35, 14, null, 'Water Damage', '2023-07-01 23:09:59', '7 Mariners Cove, Roanoke, VA', null, 7823.29, null),
(36, 15, null, 'Burglary and Theft Incident', '2023-07-01 08:42:08', '1273 Paget, Sacramento, CA', null, 9693.51, null),
(37, 16, null, 'Water Damage', '2023-05-01 17:32:12', '1418 Fisk, Sacramento, CA', null, 1303.40, null),
(38, 17, null, 'Water Damage', '2023-03-17 23:30:39', '70 Pennsylvania, Honolulu, HI', null, 9062.04, null),
(39, 18, null, 'Wind and Hail Damage', '2023-05-30 14:40:15', '3 Sommers, Montgomery, AL', null, 3196.50, null),
(40, 19, null, 'Fire Damage', '2023-05-26 09:40:41', '85 Butterfield, Chattanooga, TN', null, 4591.79, null),
(41, 25, null, 'Water  Damage', '2023-03-06 21:09:27', '9 Washington, Tampa, FL', null, 2988.64, null),
(42, 97, null, 'Fire Damage', '2023-07-17 05:35:19', '678 Onsgard, El Paso, TX', null, 6648.58, null),
(43, 98, null, 'Water Damage', '2023-07-24 14:07:36', '721 Blackbird, Idaho Falls, ID', null, 864.87, null),
(44, 99, null, 'Sinkhole Damage', '2023-05-01 23:47:39', '456 Delaware, Detroit, MI', null, 7990.23, null),
(45, 100, null, 'Hurricane Damage', '2023-06-30 07:41:15', '132 Rigney, Miami, FL', null, 7385.74, null),
(46, 101, null, 'Burglary and Theft Incident', '2023-03-27 15:01:34', '3186 Sloan, Portsmouth, VA', null, 8572.42, null),
(47, 102, null, 'Wind and Hail Damage', '2023-03-09 21:20:29', '9318 Nevada, Omaha, Nebraska', null, 6696.38, null),
(48, 103, null, 'Wind and Hail Damage', '2023-07-05 16:01:52', '390 Jenna, Lake Charles, LA', null, 8742.85, null),
(49, 104, null, 'Wind and Hail Damage', '2023-04-24 06:22:34', '2131 Ridgeway, Fort Smith, AR', null, 5840.48, null),
(50, 105, null, 'Wind and Hail Damage', '2023-05-05 06:44:11', '59 Sommers, Alexandria, VA', null, 3378.93, null),
(51, 106, null, 'Burglary and Theft Incident', '2023-07-17 04:52:39', '2505 Arapahoe, Van Nuys, CA', null, 9673.80, null),
(52, 107, null, 'Burglary and Theft Incident', '2023-04-15 06:44:20', '18 Carpenter, Anchorage, AK', null, 6215.31, null),
(53, 108, null, 'Tree Damage', '2023-05-03 18:19:07', '14 Messerschmidt, Springfield, IL', null, 2458.41, null),
(54, 109, null, 'Fire Damage', '2023-03-27 22:24:20', '1305 3rd, Washington, DC', null, 8429.46, null),
(55, 110, null, 'Wind and Hail Damage', '2023-06-08 21:11:02', '814 West, Pittsburgh, PA', null, 7797.48, null),
(56, 111, null, 'Burglary and Theft Incident', '2023-05-17 17:45:42', '91 Dahle, Newport News, VA', null, 4512.90, null),
(57, 112, null, 'Water Damage', '2023-03-29 10:04:41', '3690 Spaight, West Palm Beach, FL', null, 5987.38, null),
(58, 113, null, 'Wind and Hail Damage', '2023-05-28 12:21:21', '442 Morrow, Little Rock, AR', null, 4106.84, null),
(59, 114, null, 'Wind and Hail Damage', '2023-07-08 15:58:24', '6815 Melody, Charlottesville, VA', null, 1361.89, null),
(60, 115, null, 'Burglary and Theft Incident', '2023-04-19 13:00:51', '83 Russell, Los Angeles, CA', null, 4107.30, null);

INSERT INTO insurance.payment (payment_id, agent_id, customer_id, policy_id, total_amount, payment_method, debitorcredit)
VALUES
(1, 2, 4, 1, 280.50, 'visa', 2),
(2, 4, 60, 63, 220.30, 'visa', 2),
(3, 10, 6, 6, 200.00, 'mastercard', 1),
(4, 2, 12, 177, 1540.35, 'amex', 2),
(5, 8, 72, 96, 320.50, 'mastercard', 1);

-- CREACION DE VISTAS

# Lista de contactos: Asigna al id el prefijo A para agent y C para customer. Tambien inluye el numero de telefono de tabla 'directory' y trae solo los telefonos que son primarios.

USE insurance;

CREATE OR REPLACE VIEW `contact_info` AS
SELECT CONCAT('C', c.customer_id) AS id, c.first_name, c.last_name, c.email, d.phone_number, d.primary_phone
FROM insurance.customer c
INNER JOIN insurance.directory d ON c.customer_id = d.customer_id
	UNION
SELECT CONCAT('A', a.agent_id) AS id, a.first_name, a.last_name, a.email, d.phone_number, d.primary_phone
FROM insurance.agent a
INNER JOIN insurance.directory d ON a.agent_id = d.agent_id;

# Contactos primarios: filtra la vista de 'contact_info' devolviendo solo contactos primarios.

CREATE OR REPLACE VIEW `primary_contact_info` AS
SELECT id, first_name, last_name, email, phone_number FROM `contact_info`
WHERE primary_phone = 1
ORDER BY last_name ASC;

# Incidentes de vehiculos: visualiza incidentes en autos y los clientes que tuvieron la culpa del incidente y la compañia tiene que cubrir.

CREATE OR REPLACE VIEW `vehicle_incidents` AS
SELECT i.report_number, v.customer_id, i.vehicle_id, i.incident_type, i.incident_date, i.damage_estimate
FROM insurance.incident i
JOIN insurance.vehicle v ON i.vehicle_id = v.vehicle_id
WHERE at_fault = 1;

# Incidentes de propiedades: visualiza incidentes en propiedades que la compañia tiene que cubrir.

CREATE OR REPLACE VIEW `property_incidents` AS
SELECT i.report_number, p.customer_id, i.property_id, i.incident_type, i.incident_date, i.damage_estimate
FROM insurance.incident i
JOIN insurance.property p ON i.property_id = p.property_id
WHERE i.property_id IS NOT NULL;

# Polizas vencidas. Indiacan al agente que polizas necesitan renovacion.

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

-- CREACION DE FUNCIONES PERSONALIZADAS

USE insurance;

DELIMITER $$

# Funcion para buscar internamente el id de vehiculo segun su patente

CREATE FUNCTION `vehicle_search` (car_plate VARCHAR(7)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE car_id INT DEFAULT 0;
    SELECT vehicle_id INTO car_id FROM vehicle WHERE plate = car_plate;
    RETURN car_id;
END$$

# Funcion para calcular la comision de los agentes (5%) por prima minima de cada cobertura ya se auto o propiedad.

-- Los id a buscar son: Para autos 11;12;13;14;y15 y para propiedades 21;22;23;24;y25 (se describen en tabla 'coverage'.

CREATE FUNCTION `agents_5%_commission` (policy_coverage_number INT) RETURNS DECIMAL(11,2)
DETERMINISTIC
BEGIN
	DECLARE com_price DECIMAL(11,2) DEFAULT 0;
    DECLARE commission DECIMAL(11,2) DEFAULT 0;
    SELECT price INTO com_price FROM coverage WHERE coverage_id = policy_coverage_number;
    SET commission = com_price*0.05;
    RETURN commission;
END$$

DELIMITER ;

-- CREACION DE STORED PROCEDURES

USE insurance;

DELIMITER $$

# 1er Stored procedure para buscar por campo (variable 1) y ordenar en forma ascendente los resultados (variable 2).

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

# 2do Stored procedure para insertar datos personales de un nuevo cliente verificando que no se haya registrado previamente verificando su email.

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
    -- Si existe (email ya fue ingresado) count = 1 entonces ese registro no se inserta y el Action Output nos devuelve el mje "Customer already exists"'.
    ELSE
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Customer already exists';
    END IF;
    -- Cerramos la condicional y le pedimos que nos traiga el nuevo id creado (en caso de no existir [0]) o id 0 si ya existia.
	SELECT id;
END$$

# 3er Stored procedure para buscar un customer ya sea por nombre, apellido, social security number, o email.
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

-- CREACION DE TRIGGERS 

# 1er Trigger: creamos un log para guardar registro de claves de usuarios de los agentes de seguro cada vez que se actualiza la clave.

USE insurance;

CREATE TABLE IF NOT EXISTS insurance.password_log (
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

# 2do Trigger: Creamos un log para guardar registro historico de los precios de las distintas cobertura. Se registra cada cambio de precio.

CREATE TABLE IF NOT EXISTS insurance.price_log (
	log_id INT NOT NULL AUTO_INCREMENT,
    task VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
	old_price DECIMAL(11,2),
	new_price DECIMAL(11,2),
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
    VALUES ('Price Update', OLD.coverage_type, OLD.coverage_price, NEW.coverage_price, USER(), NOW());
END$$

DELIMITER ;

-- Test: actualizamos el precio de la cobertura con id 13 a $150. El precio era de $100.
UPDATE insurance.coverage SET coverage_price = 150 WHERE coverage_id = 13;

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
