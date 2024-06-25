-- Compute the Average Weighted Score for all users

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE user_id INT;

	-- Declare a cursor to iterate through all users
	DECLARE cur CURSOR FOR SELECT id FROM users;
	
	-- Declare a NOT FOUND handler to exit the loop
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


	OPEN cur;

	read_loop: LOOP
		FETCH cur INTO user_id;

		IF done THEN
			LEAVE read_loop;
		END IF;


		CALL ComputeAverageWeightedScoreForUser(user_id);
	END LOOP;

	CLOSE cur;
END //

DELIMITER ;
