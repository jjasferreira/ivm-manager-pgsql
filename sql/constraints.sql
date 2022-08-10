--------------------------------------------------
--- Integrity Constraints
--------------------------------------------------

--------------------------------------------------
--- Category cannot contain itself
--------------------------------------------------

CREATE OR REPLACE FUNCTION trigger_category() 
   RETURNS TRIGGER

AS $$
BEGIN
	IF NEW.category = NEW.super_category THEN
   		RAISE EXCEPTION "Category cannot contain itself.";
    END IF;
    RETURN NEW;
END;
$$	LANGUAGE	plpgsql;

CREATE TRIGGER category
	BEFORE INSERT OR UPDATE
	ON has_other
	FOR EACH ROW
		EXECUTE PROCEDURE trigger_category();


--------------------------------------------------
--- Restock units must follow the planogram
--------------------------------------------------

CREATE OR REPLACE FUNCTION trigger_replenishment_units() 
   RETURNS TRIGGER 

AS $$
BEGIN
	IF EXISTS (
	SELECT planogram.units
	FROM planogram
	WHERE NEW.ean = planogram.ean
	AND NEW.nro = planogram.nro
	AND NEW.serial_number = planogram.serial_number
	AND NEW.manufacturer = planogram.manufacturer
	AND NEW.units > planogram.units) THEN
    	RAISE EXCEPTION "Replenishment units cannot exceed planogram units.";
    END IF;
    RETURN NEW; 
END;
$$	LANGUAGE	plpgsql;

CREATE TRIGGER replenishment_units
	BEFORE INSERT OR UPDATE
	ON replenishment_event
	FOR EACH ROW
		EXECUTE PROCEDURE trigger_replenishment_units();


--------------------------------------------------
--- Shelf category must match product category
--------------------------------------------------

CREATE OR REPLACE FUNCTION trigger_product_on_shelf() 
   RETURNS TRIGGER 

AS $$
BEGIN
	IF NOT EXISTS (
	SELECT *
	FROM product
	LEFT JOIN has_category
		ON product.ean = has_category.ean
	JOIN shelf
		ON shelf.name = product.cat OR shelf.name = has_category.name
	WHERE NEW.nro = shelf.nro
	AND NEW.serial_number = shelf.serial_number
	AND NEW.manufacturer = shelf.manufacturer) THEN
		RAISE EXCEPTION	"Shelf must contain category of product.";
	END IF;
	RETURN NEW;
END;
$$	LANGUAGE	plpgsql;

CREATE TRIGGER product_on_shelf
	BEFORE INSERT OR UPDATE
	ON replenishment_event
	FOR EACH ROW
		EXECUTE PROCEDURE trigger_product_on_shelf();