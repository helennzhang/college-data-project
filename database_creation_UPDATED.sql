DROP DATABASE IF EXISTS US_College;
CREATE DATABASE US_College;

DROP TABLE IF EXISTS education_mega;
CREATE TABLE education_mega(
UNITID MEDIUMINT UNSIGNED,
INSTNM TEXT,
CITY TEXT,
STABBR VARCHAR(2),
ZIP VARCHAR(9),
INSTURL TEXT,
NPCURL TEXT,
CONTROL TINYINT UNSIGNED,
ADM_RATE FLOAT,
ADM_RATE_ALL FLOAT,
SATVR25 SMALLINT UNSIGNED,
SATVR75 SMALLINT UNSIGNED,
SATMT25 SMALLINT UNSIGNED,
SATMT75 SMALLINT UNSIGNED,
SATWR25 SMALLINT UNSIGNED,
SATWR75 SMALLINT UNSIGNED,
SATVRMID SMALLINT UNSIGNED,
SATMTMID SMALLINT UNSIGNED,
SATWRMID SMALLINT UNSIGNED,
ACTCM25 TINYINT UNSIGNED,
ACTCM75 TINYINT UNSIGNED,
ACTEN25 TINYINT UNSIGNED,
ACTEN75 TINYINT UNSIGNED,
ACTMT25 TINYINT UNSIGNED,
ACTMT75 TINYINT UNSIGNED,
ACTWR25 TINYINT UNSIGNED,
ACTWR75 TINYINT UNSIGNED,
ACTCMMID TINYINT UNSIGNED,
ACTENMID TINYINT UNSIGNED,
ACTMTMID TINYINT UNSIGNED,
ACTWRMID TINYINT UNSIGNED,
SAT_AVG SMALLINT UNSIGNED,
SAT_AVG_ALL SMALLINT UNSIGNED,
UGDS INT UNSIGNED,
UGDS_WHITE FLOAT,
UGDS_BLACK FLOAT,
UGDS_HISPANIC FLOAT,
UGDS_ASIAN FLOAT,
UGDS_AIAN FLOAT,
UGDS_NHPI FLOAT,
UGDS_2MOR FLOAT,
UGDS_NRA FLOAT,
UGDS_UNKNOWN FLOAT,
UGDS_MEN FLOAT,
UGDS_WOMEN FLOAT,
COSTT4_A SMALLINT UNSIGNED,
TUITIONFEE_IN SMALLINT UNSIGNED,
TUITIONFEE_OUT SMALLINT UNSIGNED,
PCTFLOAN FLOAT,
PCTPELL FLOAT,
DEBT_MDN INT UNSIGNED,
PAR_ED_PCT_1STGEN FLOAT ,
DATA_YEAR YEAR
);

DROP TABLE IF EXISTS basic_info;
CREATE TABLE basic_info(
UNITID MEDIUMINT UNSIGNED NOT NULL,
INSTNM TEXT,
PRIMARY KEY basic_pk (UNITID)
);

DROP TABLE IF EXISTS school_profile;
CREATE TABLE school_profile(
UNITID MEDIUMINT UNSIGNED NOT NULL,
CONTROL TINYINT UNSIGNED,
NPCURL TEXT,
INSTURL TEXT,
PRIMARY KEY geo_pk (UNITID),
FOREIGN KEY geo_fk (UNITID) 
REFERENCES basic_info(UNITID)
);

DROP TABLE IF EXISTS years;
CREATE TABLE years(
DATA_YEAR YEAR NOT NULL,
PRIMARY KEY year_pk (DATA_YEAR)
);

DROP TABLE IF EXISTS admission;
CREATE TABLE admission(
UNITID MEDIUMINT UNSIGNED NOT NULL,
DATA_YEAR YEAR NOT NULL,
ADM_RATE FLOAT,
ADM_RATE_ALL FLOAT,
PRIMARY KEY adm_pk (UNITID, DATA_YEAR),
FOREIGN KEY adm_fk (UNITID) 
REFERENCES basic_info(UNITID),
FOREIGN KEY adm_fk2 (DATA_YEAR) 
REFERENCES years(DATA_YEAR)
);

DROP TABLE IF EXISTS geographical_data;
CREATE TABLE geographical_data(
UNITID MEDIUMINT UNSIGNED NOT NULL,
CITY TEXT,
STABBR VARCHAR(2),
ZIP VARCHAR(9),
PRIMARY KEY geo_pk (UNITID),
FOREIGN KEY geo_fk (UNITID) 
REFERENCES basic_info(UNITID)
);

DROP TABLE IF EXISTS demographic_data;
CREATE TABLE demographic_data(
UNITID MEDIUMINT UNSIGNED NOT NULL,
DATA_YEAR YEAR NOT NULL,
UGDS INT UNSIGNED,
UGDS_WHITE FLOAT,
UGDS_BLACK FLOAT,
UGDS_HISPANIC FLOAT,
UGDS_ASIAN FLOAT,
UGDS_AIAN FLOAT,
UGDS_NHPI FLOAT,
UGDS_2MOR FLOAT,
UGDS_NRA FLOAT,
UGDS_UNKNOWN FLOAT,
UGDS_MEN FLOAT,
UGDS_WOMEN FLOAT,
PAR_ED_PCT_1STGEN FLOAT,
PRIMARY KEY demo_pk (UNITID, DATA_YEAR),
FOREIGN KEY demo_fk (UNITID) 
REFERENCES basic_info(UNITID),
FOREIGN KEY demo_fk2 (DATA_YEAR) 
REFERENCES YEARS(DATA_YEAR)
);

DROP TABLE IF EXISTS act_stat;
CREATE TABLE act_stat(
UNITID MEDIUMINT UNSIGNED NOT NULL,
DATA_YEAR YEAR NOT NULL,
ACTCM25 TINYINT UNSIGNED,
ACTCM75 TINYINT UNSIGNED,
ACTEN25 TINYINT UNSIGNED,
ACTEN75 TINYINT UNSIGNED,
ACTMT25 TINYINT UNSIGNED,
ACTMT75 TINYINT UNSIGNED,
ACTWR25 TINYINT UNSIGNED,
ACTWR75 TINYINT UNSIGNED,
ACTCMMID TINYINT UNSIGNED,
ACTENMID TINYINT UNSIGNED,
ACTMTMID TINYINT UNSIGNED,
ACTWRMID TINYINT UNSIGNED,
PRIMARY KEY act_pk (UNITID, DATA_YEAR),
FOREIGN KEY act_fk (UNITID) 
REFERENCES basic_info(UNITID),
FOREIGN KEY act_fk2 (DATA_YEAR) 
REFERENCES years(DATA_YEAR)
);

DROP TABLE IF EXISTS sat_stats;
CREATE TABLE sat_stats(
UNITID MEDIUMINT UNSIGNED NOT NULL,
DATA_YEAR YEAR NOT NULL,
SAT_AVG SMALLINT UNSIGNED,
SAT_AVG_ALL SMALLINT UNSIGNED,
SATVR25 SMALLINT UNSIGNED,
SATVR75 SMALLINT UNSIGNED,
SATMT25 SMALLINT UNSIGNED,
SATMT75 SMALLINT UNSIGNED,
SATWR25 SMALLINT UNSIGNED,
SATWR75 SMALLINT UNSIGNED,
SATVRMID SMALLINT UNSIGNED,
SATMTMID SMALLINT UNSIGNED,
SATWRMID SMALLINT UNSIGNED,
PRIMARY KEY sat_pk (UNITID, DATA_YEAR),
FOREIGN KEY sat_fk (UNITID) 
REFERENCES basic_info(UNITID),
FOREIGN KEY sat_fk2 (DATA_YEAR) 
REFERENCES years(DATA_YEAR)
);

DROP TABLE IF EXISTS cost_earnings;
CREATE TABLE cost_earnings(
UNITID MEDIUMINT UNSIGNED NOT NULL,
DATA_YEAR YEAR NOT NULL,
COSTT4_A SMALLINT UNSIGNED,
TUITIONFEE_IN SMALLINT UNSIGNED,
TUITIONFEE_OUT SMALLINT UNSIGNED,
PCTFLOAN FLOAT,
PCTPELL FLOAT,
DEBT_MDN INT UNSIGNED,
PRIMARY KEY cost_pk (UNITID, DATA_YEAR),
FOREIGN KEY cost_fk (UNITID) 
REFERENCES basic_info(UNITID),
FOREIGN KEY cost_fk2 (DATA_YEAR) 
REFERENCES years(DATA_YEAR)
);

--  indexes for faster queries
CREATE INDEX adm_index ON admission(ADM_RATE_ALL);
CREATE INDEX sat_index ON sat_stats(SAT_AVG_ALL);

-- returns a view containing a mini overview of all schools
DROP VIEW profile_stats;
CREATE VIEW profile_stats AS
SELECT bi.INSTNM, gd.CITY, gd.STABBR, gd.ZIP, dd.UGDS, sp.NPCURL, a.ADM_RATE_ALL,
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
SELECT * FROM profile_stats;

