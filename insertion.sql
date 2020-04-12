-- FILE OR LOADING ALL DATA & INSERTS

-- load into mega table
LOAD DATA LOCAL INFILE '~/Downloads/CollegeScorecard_Raw_Data/N2018.csv' 
INTO TABLE education_mega FIELDS TERMINATED BY ',' ENCLOSED BY "" 
LINES TERMINATED BY '\n';

-- load information data from only most recent 2018
INSERT INTO basic_info
SELECT UNITID, INSTNM
FROM education_mega
WHERE UNITID != 16777215; -- remove duplicate error

DELETE FROM basic_info 
WHERE UNITID = 0;

-- load 2018 data into rest of normalized tables
INSERT INTO school_profile
SELECT UNITID, CONTROL, NPCURL, INSTURL
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info);

INSERT INTO years 
VALUES ('2018');

INSERT INTO admission
SELECT UNITID, '2018', ADM_RATE, ADM_RATE_ALL
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 

INSERT INTO geographical_data
SELECT UNITID, CITY, STABBR, ZIP
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 

INSERT INTO demographic_data
SELECT UNITID, '2018', UGDS, UGDS_WHITE, UGDS_BLACK, UGDS_HISPANIC,
UGDS_ASIAN, UGDS_AIAN, UGDS_NHPI, UGDS_2MOR, UGDS_UNKNOWN, UGDS_MEN,
UGDS_WOMEN, PAR_ED_PCT_1STGEN
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 

INSERT INTO act_stat
SELECT UNITID,'2018', ACTCM25, ACTCM75, ACTEN25, ACTEN75, ACTMT25, ACTMT75, ACTWR25,
ACTWR75, ACTCMMID, ACTENMID, ACTMTMID, ACTWRMID
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 

INSERT INTO sat_stats
SELECT UNITID,'2018', SAT_AVG,SAT_AVG_ALL, SATVR25, SATVR75, SATMT25,
SATMT75, SATWR25, SATWR75, SATVRMID, SATMTMID, SATWRMID
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 

INSERT INTO cost_earnings
SELECT UNITID, '2018', COSTT4_A, TUITIONFEE_IN, TUITIONFEE_OUT,
PCTFLOAN, PCTPELL, DEBT_MDN
FROM education_mega
WHERE UNITID IN (
SELECT UNITID
FROM basic_info); 