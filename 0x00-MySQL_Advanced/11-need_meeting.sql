-- View to list all students that have scored under 80
-- and no last_meeting or more than 1 month

DROP VIEW IF EXISTS need_meeting;

CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80
AND (last_meeting IS NULL OR last_meeting < DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
