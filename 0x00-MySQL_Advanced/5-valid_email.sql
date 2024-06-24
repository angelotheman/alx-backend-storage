-- Email Validation

DELIMITER //

CREATE TRIGGER validate_email
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
	IF OLD.email != NEW.email THEN
		SET NEW.valid_email = 0;
	END IF;
END //

DELIMETER ;
