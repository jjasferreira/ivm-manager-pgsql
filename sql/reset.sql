--------------------------------------------------
--- Drop tables if they exist
--------------------------------------------------

DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS simple_category CASCADE;
DROP TABLE IF EXISTS super_category CASCADE;
DROP TABLE IF EXISTS has_category CASCADE;
DROP TABLE IF EXISTS has_other CASCADE;
DROP TABLE IF EXISTS IVM CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS retail_point CASCADE;
DROP TABLE IF EXISTS installed_at CASCADE;
DROP TABLE IF EXISTS shelf CASCADE;
DROP TABLE IF EXISTS planogram CASCADE;
DROP TABLE IF EXISTS retailer CASCADE;
DROP TABLE IF EXISTS responsible_for CASCADE;
DROP TABLE IF EXISTS replenishment_event CASCADE;


--------------------------------------------------
--- Drop functions/procedures if they exist
--------------------------------------------------s

DROP FUNCTION IF EXISTS trigger_category;
DROP FUNCTION IF EXISTS trigger_replenishment_units;
DROP FUNCTION IF EXISTS trigger_product_on_shelf;


--------------------------------------------------
--- Create/re-create the tables/relations
--------------------------------------------------

CREATE TABLE category (
	name VARCHAR(255) NOT NULL,
	CONSTRAINT pk_category PRIMARY KEY(name)
);

CREATE TABLE simple_category (
	name VARCHAR(255) NOT NULL,
	CONSTRAINT pk_simple_category PRIMARY KEY(name),
	CONSTRAINT fk_category_simple_category FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE super_category (
	name VARCHAR(255) NOT NULL,
	CONSTRAINT pk_super_category PRIMARY KEY(name),
	CONSTRAINT fk_category_super_category FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE has_other (
	category VARCHAR(255) NOT NULL,
	super_category VARCHAR(255) NOT NULL,
	CONSTRAINT pk_has_other PRIMARY KEY(category),
	CONSTRAINT fk_has_other_category FOREIGN KEY(category) REFERENCES category(name),
	CONSTRAINT fk_has_other_super_category FOREIGN KEY(super_category) REFERENCES super_category(name)
);

CREATE TABLE product (
	ean INT NOT NULL,
	cat VARCHAR(255) NOT NULL,
	descr VARCHAR(255) NOT NULL,
	CONSTRAINT pk_product PRIMARY KEY(ean),
	CONSTRAINT fk_product_category FOREIGN KEY(cat) REFERENCES category(name)
);

CREATE TABLE has_category (
	ean INT NOT NULL,
	name VARCHAR(255) NOT NULL,
	CONSTRAINT fk_has_category_product FOREIGN KEY(ean) REFERENCES product(ean),
	CONSTRAINT fk_has_category_category FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE IVM (
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	CONSTRAINT pk_IVM PRIMARY KEY(serial_number, manufacturer)
);

CREATE TABLE retail_point (
	name VARCHAR(255) NOT NULL,
	county VARCHAR(255) NOT NULL,
	district VARCHAR(255) NOT NULL,
	CONSTRAINT pk_retail_point PRIMARY KEY(name)
);

CREATE TABLE installed_at (
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	place VARCHAR(255) NOT NULL,
	CONSTRAINT pk_installed_in PRIMARY KEY(serial_number, manufacturer),
	CONSTRAINT fk_installed_in_IVM FOREIGN KEY(serial_number, manufacturer) REFERENCES IVM(serial_number, manufacturer),
	CONSTRAINT fk_installed_in_retail_point FOREIGN KEY(place) REFERENCES retail_point(name)
);

CREATE TABLE shelf (
	nro INT NOT NULL,
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	height INT NOT NULL,
	name VARCHAR(255) NOT NULL,
	CONSTRAINT pk_shelf PRIMARY KEY(nro, serial_number, manufacturer),
	CONSTRAINT fk_shelf_IVM FOREIGN KEY(serial_number, manufacturer) REFERENCES IVM(serial_number, manufacturer),
	CONSTRAINT fk_shelf_categor FOREIGN KEY(name) REFERENCES category(name)
);

CREATE TABLE planogram (
	ean INT NOT NULL,
	nro INT NOT NULL,
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	faces INT NOT NULL,
	units INT NOT NULL,
	loc VARCHAR NOT NULL,
	CONSTRAINT pk_planogram PRIMARY KEY(ean, nro, serial_number, manufacturer),
	CONSTRAINT fk_planogram_shelf FOREIGN KEY(nro, serial_number, manufacturer) REFERENCES shelf(nro, serial_number, manufacturer),
	CONSTRAINT fk_planogram_product FOREIGN KEY(ean) REFERENCES product(ean)
);

CREATE TABLE retailer (
	tin INT NOT NULL,
	name VARCHAR(255) NOT NULL unique,
	CONSTRAINT pk_retailer PRIMARY KEY(tin)
);

CREATE TABLE responsible_for (
	name_cat VARCHAR(255) NOT NULL,
	tin INT NOT NULL,
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	CONSTRAINT pk_responsible_for PRIMARY KEY(serial_number, manufacturer),
	CONSTRAINT fk_responsible_for_IVM FOREIGN KEY(serial_number, manufacturer) REFERENCES IVM(serial_number, manufacturer),
	CONSTRAINT fk_responsible_for_retailer FOREIGN KEY(tin) REFERENCES retailer(tin),
	CONSTRAINT fk_responsible_for_category FOREIGN KEY(name_cat) REFERENCES category(name)
);

CREATE TABLE replenishment_event (
	ean INT NOT NULL,
	nro INT NOT NULL,
	serial_number INT NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	instant TIMESTAMP NOT NULL,
	units INT NOT NULL,
	tin INT NOT NULL,
	CONSTRAINT pk_replenishment_event PRIMARY KEY(ean, nro, serial_number, manufacturer, instant),
	CONSTRAINT fk_replenishment_event_planogram FOREIGN KEY(ean, nro, serial_number, manufacturer) REFERENCES planogram(ean, nro, serial_number, manufacturer),
	CONSTRAINT fk_replenishment_event_retailer FOREIGN KEY(tin) REFERENCES retailer(tin)
);