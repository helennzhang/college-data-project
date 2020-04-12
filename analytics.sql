DROP VIEW profile;
CREATE VIEW profile AS
SELECT bi.INSTNM, gd.CITY, gd.STABBR, gd.ZIP, dd.UGDS, sp.INSTURL, a.ADM_RATE_ALL,
act.ACTCM25, act.ACTCM75, sat.SAT_AVG_ALL
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

SELECT * FROM profile;
    