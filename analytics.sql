-- PROCEDURES

-- filter for schools based on location inputs
DROP PROCEDURE IF EXISTS filter_location;
DELIMITER //
CREATE PROCEDURE filter_location(IN city TEXT, 
IN stabbr VARCHAR(2), IN zip VARCHAR(9))
BEGIN 
	IF city != "" AND stabbr != "" AND zip != "" THEN
		SELECT * FROM (SELECT * FROM profile) op
		WHERE op.CITY = city AND op.STABBR = stabbr AND op.ZIP = zip;
    ELSEIF city != "" AND stabbr != "" THEN
		SELECT * FROM (SELECT * FROM profile) op
		WHERE op.CITY = city AND op.STABBR = stabbr;
    ELSEIF city != "" AND zip != "" THEN
		SELECT * FROM (SELECT * FROM profile) op
		WHERE op.CITY = city AND op.ZIP = zip;
    ELSEIF stabbr != "" AND zip != "" THEN
		SELECT * FROM (SELECT * FROM profile) op
		WHERE op.STABBR = stabbr AND op.ZIP = zip;
    ELSEIF stabbr != "" THEN
		SELECT * FROM (SELECT * FROM profile) op WHERE op.STABBR = stabbr;
    ELSEIF zip != "" THEN
		SELECT * FROM (SELECT * FROM profile) op WHERE op.ZIP = zip;
    ELSEIF city != "" THEN
		SELECT * FROM (SELECT * FROM profile) op WHERE op.CITY = city;
    ELSE 
		SELECT 'no input' AS msg;
    END IF;

END //
DELIMITER ;

-- filter schools based on act
DROP PROCEDURE IF EXISTS filter_act;

DELIMITER //

CREATE PROCEDURE filter_act (IN low TINYINT UNSIGNED,
IN high TINYINT UNSIGNED)

BEGIN
	
   SELECT * FROM profile
    WHERE ACTCMMID > low AND ACTCMMID < high;
    
END //

DELIMITER ;

-- filer schools based on sat
DROP PROCEDURE IF EXISTS filter_sat;
DELIMITER //
CREATE PROCEDURE filter_sat(IN low SMALLINT UNSIGNED,
IN high SMALLINT UNSIGNED)

BEGIN

    SELECT * FROM profile 
    WHERE SAT_AVG_ALL > low AND SAT_AVG_ALL < high;


END//

DELIMITER ;


-- filter schools based on act & sat
DROP PROCEDURE IF EXISTS filter_test;
DELIMITER //
CREATE PROCEDURE filter_test(IN a_low SMALLINT UNSIGNED,
IN a_high SMALLINT UNSIGNED, IN s_low SMALLINT UNSIGNED,
IN s_high SMALLINT UNSIGNED)

BEGIN
    
SELECT * FROM (SELECT * FROM profile) op
WHERE op.SAT_AVG_ALL > s_low AND op.SAT_AVG_ALL < s_high 
AND op.ACTCMMID > a_low AND op.ACTCMMID < a_high;

END//

DELIMITER ;

-- Filtering cost demographics -- 
DROP PROCEDURE IF EXISTS filter_cost;
DELIMITER //
CREATE PROCEDURE filter_cost(IN low INT UNSIGNED,
IN high INT UNSIGNED, IN lim INT UNSIGNED)

BEGIN
    
SELECT * FROM demo_cost_stats d
WHERE d.TUITIONFEE_OUT > low AND d.TUITIONFEE_OUT < high 
LIMIT lim;

END//

DELIMITER ;















