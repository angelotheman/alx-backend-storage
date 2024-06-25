DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;

    -- Declare cursor to iterate through all users
    DECLARE cur CURSOR FOR SELECT id FROM users;

    -- Declare NOT FOUND handler to exit the loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO user_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Initialize variables for calculating weighted average
        SET total_weighted_score = 0;
        SET total_weight = 0;

        -- Cursor to fetch weighted scores for the user
        DECLARE cur_scores CURSOR FOR
            SELECT c.score * p.weight AS weighted_score, p.weight
            FROM corrections c
            JOIN projects p ON c.project_id = p.id
            WHERE c.user_id = user_id;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        OPEN cur_scores;

        read_scores_loop: LOOP
            FETCH cur_scores INTO total_weighted_score, total_weight;
            
            IF done THEN
                LEAVE read_scores_loop;
            END IF;

            -- Accumulate total weighted score and total weight
            SET total_weighted_score = total_weighted_score + weighted_score;
            SET total_weight = total_weight + weight;
        END LOOP;

        CLOSE cur_scores;

        -- Calculate average weighted score if there are scores
        IF total_weight > 0 THEN
            SET total_weighted_score = total_weighted_score / total_weight;
        ELSE
            SET total_weighted_score = 0; -- default if no scores found
        END IF;

        -- Update average_score for the user
        UPDATE users SET average_score = total_weighted_score WHERE id = user_id;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;
