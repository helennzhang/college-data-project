-- PROCEDURES

-- filter for schools based on location inputs
DROP PROCEDURE filter_location;
DELIMITER //
CREATE PROCEDURE filter_location(IN city TEXT, 
IN stabbr VARCHAR(2), IN zip VARCHAR(9))

BEGIN 

	IF city != "" AND stabbr != "" AND zip != "" THEN
		SELECT * FROM profile_stats
		WHERE CITY = city AND STABBR = stabbr AND ZIP = zip;
    ELSEIF city != "" AND stabbr != "" THEN
		SELECT * FROM profile_stats
		WHERE CITY = city AND STABBR = stabbr;
    ELSEIF city != "" AND zip != "" THEN
		SELECT * FROM profile_stats
		WHERE CITY = city AND ZIP = zip;
    ELSEIF stabbr != "" AND zip != "" THEN
		SELECT * FROM profile_stats
		WHERE STABBR = stabbr AND ZIP = zip;
    ELSEIF stabbr != "" THEN
		SELECT * FROM profile_stats WHERE STABBR = stabbr;
    ELSEIF zip != "" THEN
		SELECT * FROM profile_stats WHERE ZIP = zip;
    ELSEIF city != "" THEN
		SELECT * FROM profile_stats WHERE CITY = city;
    ELSE 
		SELECT 'no input' AS msg;
    END IF;

END //
DELIMITER ;
    

-- filter for schools based on act
DROP PROCEDURE filter_act;
DELIMITER //
CREATE PROCEDURE act(IN low TINYINT UNSIGNED,
IN high TINYINT UNSIGNED, IN two BOOL)

BEGIN

	IF low > high OR low = 0 AND high = 0 THEN 
    SELECT "ERROR: low value > high" as msg;
    ELSEIF two = 1 THEN
    SELECT * FROM profile_stats 
    WHERE ACTCMMID >= low AND ACTCMMID =< high;
    ELSEIF high = 0 AND low THEN
    SELECT * FROM profile_stats
    WHERE ACTCMMID > low;
    ELSEIF low = 0
    SELECT * FROM profile_stats
    WHERE ACTCMID < high;
    END IF;
    
END //
DELIMITER ;

-- filter for schools based on sat
DROP PROCEDURE filter_sat;
DELIMITER //
CREATE PROCEDURE filter_sat(IN low SMALLINT UNSIGNED,
IN high SMALLINT UNSIGNED, IN two BOOL)

BEGIN

	IF low > high THEN 
    SELECT "ERROR: low value > high" as msg;
    ELSEIF two = 1 THEN
    SELECT * FROM profile_stats 
    WHERE SAT_AVG_ALL >= low AND SAT_AVG_ALL =< high;
    ELSEIF high = 0 AND low <= high THEN
    SELECT * FROM profile_stats
    WHERE SAT_AVG_ALL > low;
    ELSEIF low = 0
    SELECT * FROM profile_stats
    WHERE SAT_AVG_ALL< high;
    END IF;

END//

DELIMITER ;



    
    
    
    




    