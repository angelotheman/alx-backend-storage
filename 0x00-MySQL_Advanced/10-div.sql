-- Function for division

DROP FUNCTION IF EXISTS SafeDiv;

DELIMITER //

CREATE FUNCTION SafeDiv (a INT, b INT)
RETURNS FLOAT
BEGIN
	DECLARE result FLOAT default 0;

	IF b != 0 THEN
		SET result = a / b;
	END IF;

	RETURN result;
END //

DELIMITER ;
