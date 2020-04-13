--  indexes for faster queries
CREATE INDEX adm_index ON admission(ADM_RATE_ALL);
CREATE INDEX sat_index ON sat_stats(SAT_AVG_ALL);

-- returns a view containing a mini overview of all schools
DROP VIEW profile;
CREATE VIEW profile AS
SELECT bi.INSTNM, gd.CITY, gd.STABBR, gd.ZIP, dd.UGDS, sp.INSTURL, a.ADM_RATE_ALL,
act.ACTCM25, act.ACTCM75, act.ACTCMMID, sat.SAT_AVG_ALL
FROM basic_info bi INNER JOIN school_profile sp
	ON bi.UNITID = sp.UNITID
    INNER JOIN admission a
    ON bi.UNITID = a.UNITID AND a.DATA_YEAR = '2018'
    INNER JOIN geographical_data gd
    ON bi.UNITID = gd.UNITID
    INNER JOIN demographic_data dd
	ON bi.UNITID = dd.UNITID AND dd.DATA_YEAR = '2018'
    INNER JOIN act_stat act  
    ON bi.UNITID = act.UNITID AND act.DATA_YEAR = '2018'
    INNER JOIN sat_stats sat 
    ON bi.UNITID = sat.UNITID AND sat.DATA_YEAR = '2018';
    
-- select statement for view to check accuracy
SELECT * FROM profile;

-- filter for schools based on location inputs
DROP PROCEDURE filter_location;
DELIMITER //
CREATE PROCEDURE filter_location(IN city TEXT, 
IN stabbr VARCHAR(2), IN zip VARCHAR(9))

BEGIN 

	IF city != "" AND stabbr != "" AND zip != "" THEN
		SELECT * FROM profile
		WHERE CITY = city AND STABBR = stabbr AND ZIP = zip;
    ELSE IF city != "" AND stabbr != "" THEN
		SELECT * FROM profile
		WHERE CITY = city AND STABBR = stabbr;
    ELSE IF city != "" AND zip != "" THEN
		SELECT * FROM profile
		WHERE CITY = city AND ZIP = zip;
    ELSE IF stabbr != "" AND zip != "" THEN
		SELECT * FROM profile
		WHERE STABBR = stabbr AND ZIP = zip;
    ELSE IF stabbr != "" THEN
		SELECT * FROM profile WHERE STABBR = stabbr;
    ELSE IF zip != "" THEN
		SELECT * FROM profile WHERE ZIP = zip;
    ELSE IF city != "" THEN
		SELECT * FROM profile WHERE CITY = city;
    ELSE 
		SELECT 'no input' AS msg;
    END IF;

END //

DELIMITER ;
    

    
DROP PROCEDURE filter_act;

DELIMITER //
CREATE PROCEDURE act(IN low TINYINT UNSIGNED,
IN high TINYINT UNSIGNED, IN two BOOL)

BEGIN

	IF low > high OR low = 0 AND high = 0 THEN 
    SELECT "ERROR: low value > high" as msg;
    ELSE IF two = 1 THEN
    SELECT * FROM profile 
    WHERE ACTCMMID >= low AND ACTCMMID =< high;
    ELSE IF high = 0 AND low THEN
    SELECT * FROM profile
    WHERE ACTCMMID > low;
    ELSE IF low = 0
    SELECT * FROM profile
    WHERE ACTCMID < high;
    END IF;
    
END //

DELIMITER ;

DROP PROCEDURE filter_sat;
DELIMITER //
CREATE PROCEDURE filter_sat(IN low SMALLINT UNSIGNED,
IN high SMALLINT UNSIGNED, IN two BOOL)

BEGIN

	IF low > high THEN 
    SELECT "ERROR: low value > high" as msg;
    ELSE IF two = 1 THEN
    SELECT * FROM profile 
    WHERE SAT_AVG_ALL >= low AND SAT_AVG_ALL =< high;
    ELSE IF high = 0 AND low <= high THEN
    SELECT * FROM profile
    WHERE SAT_AVG_ALL > low;
    ELSE IF low = 0
    SELECT * FROM profile
    WHERE SAT_AVG_ALL< high;
    END IF;

END//

DELIMITER ;



    
    
    
    




    