-- Compute average score for a student

DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;

DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser (
	IN user_id INT
)
BEGIN
	DECLARE avg_score FLOAT;

	-- Calculate average score from the corrections table
	SELECT AVG(score) INTO avg_score
	FROM  corrections
	WHERE corrections.user_id = user_id;

	-- Update the users table with the calculated average score
	UPDATE users
	SET average_score = avg_score
	WHERE users.id = user_id;

END //

DELIMITER ;
