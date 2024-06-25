-- Compute the Average Weighted Scored For User

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (
	IN user_id INT
)
BEGIN
	DECLARE total_weight INT;
	DECLARE total_weighted_score FLOAT;

	-- Calculate total weight
	SELECT SUM(p.weight)
	INTO total_weight
	FROM corrections c
	JOIN projects p
		ON c.project_id = p.id
	WHERE c.user_id = user_id;

	-- Calculate total weighted score
	SELECT SUM(c.score * p.weight)
	INTO total_weighted_score
	FROM corrections c
	JOIN projects p
		ON c.project_id = p.id
	WHERE c.user_id = user_id;


	-- Update user's average_score
	IF total_weight > 0 THEN
		UPDATE users
		SET average_score = total_weighted_score / total_weight
		WHERE id = user_id;
	END IF;
END //

DELIMITER ;
