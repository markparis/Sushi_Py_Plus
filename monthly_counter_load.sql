-- Adam Matthew Digital DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMD_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- Adam Matthew Digital MR1
LOAD DATA LOCAL INFILE 'AMD_MR1.tsv'
INTO TABLE counter_mr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Collection",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
media_requests=@col4
;
-- American Institute of Physics JR1
LOAD DATA LOCAL INFILE 'AIP_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Institute of Physics JR1a
LOAD DATA LOCAL INFILE 'AIP_JR1a.csv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 11 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Institute of Physics JR1goa
LOAD DATA LOCAL INFILE 'AIP_JR1goa.csv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Institute of Physics JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AIP_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 11 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: simultaneous/concurrent user licence limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- American Institute of Physics PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AIP_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- American Mathematical Society JR1
LOAD DATA LOCAL INFILE 'AMS_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Mathematical Society JR1goa
LOAD DATA LOCAL INFILE 'AMS_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col6,
ft_html=@col5,
ft_total=@col4
;
-- American Mathematical Society JR2
-- CREATE TEMPORARY TABLE counter_jr2_delta
-- (
-- print_issn VARCHAR(45),
-- online_issn VARCHAR(45),
-- doi VARCHAR(255),
-- proprietary_identifier VARCHAR(45),
-- platform VARCHAR(255),
-- publisher TEXT,
-- item_name TEXT,
-- data_type VARCHAR(45),
-- date_begin DATETIME,
-- date_end DATETIME,
-- access_denied_category VARCHAR(255),
-- reporting_period_total INT
-- )
-- ;
-- LOAD DATA LOCAL INFILE 'AMS_JR2.tsv'
-- INTO TABLE counter_jr2_delta
-- FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 10 LINES
-- (@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
-- SET print_issn=@col6,
-- online_issn=@col7,
-- doi=@col4,
-- proprietary_identifier=@col5,
-- platform=@col3,
-- publisher=@col2,
-- item_name=@col1,
-- data_type="Journal",
-- date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
-- date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
-- access_denied_category=@col8,
-- reporting_period_total=@col9
-- ;
-- INSERT INTO counter_jr2
-- (print_issn,
-- online_issn,
-- doi,
-- proprietary_identifier,
-- platform,
-- publisher,
-- item_name,
-- data_type,
-- date_begin,
-- date_end,
-- no_license,
-- turnaways,
-- other_reason
-- )
-- SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
--     SUM(
--         CASE
--             WHEN access_denied_category="Access Denied: content item not licensed"
--             THEN reporting_period_total
--             ELSE 0
-- 		END
-- 	) AS 'no_license',
--     SUM(
--         CASE
--             WHEN access_denied_category="Access Denied: concurrent/simultaneous user license limit exceeded"
--             THEN reporting_period_total
--             ELSE 0
-- 		END
-- 	) AS 'turnaways',
--     SUM(
--         CASE
--             WHEN access_denied_category="Access Denied: other"
--             THEN reporting_period_total
--             ELSE 0
-- 		END
-- 	) AS 'other_reason'
-- FROM counter_jr2_delta
-- GROUP BY item_name
-- ;
-- DROP TABLE counter_jr2_delta
-- ;
-- American Mathematical Society DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMS_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- American Mathematical Society PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMS_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- American Medical Association JR1
LOAD DATA LOCAL INFILE 'AMA_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Medical Association JR1a
LOAD DATA LOCAL INFILE 'AMA_JR1a.csv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 12 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Medical Association JR1goa
LOAD DATA LOCAL INFILE 'AMA_JR1goa.csv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Medical Association JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMA_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 12 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_jr2_delta
;
-- American Medical Association JR3
CREATE TEMPORARY TABLE counter_jr3_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
page_type VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMA_JR3.csv'
INTO TABLE counter_jr3_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 34 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
page_type=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr3
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
toc,
abstracts,
`references`,
ft_pdf,
ft_html,
ft_total
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN page_type="Table of Contents"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'toc',
    SUM(
        CASE
            WHEN page_type="Abstracts"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'abstracts',
    SUM(
        CASE
            WHEN page_type="References"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'references',
    SUM(
        CASE
            WHEN page_type="Full-text PDF"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'ft_pdf',
    SUM(
        CASE
            WHEN page_type="Full-text HTML"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'ft_html',
    SUM(
        CASE
            WHEN page_type="Full-text Total"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'ft_total'
FROM counter_jr3_delta
GROUP BY item_name, platform
;
DROP TABLE counter_jr3_delta
;
-- American Medical Association PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'AMA_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- American Speech-Language-Hearing Association JR1
LOAD DATA LOCAL INFILE 'ASHA_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Speech-Language-Hearing Association JR1a
LOAD DATA LOCAL INFILE 'ASHA_JR1a.csv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 11 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- American Speech-Language-Hearing Association JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'ASHA_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_jr2_delta
;
-- American Speech-Language-Hearing Association PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'ASHA_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- BioMed Central JR1
LOAD DATA LOCAL INFILE 'BMC_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- BioMed Central JR1goa
LOAD DATA LOCAL INFILE 'BMC_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- BioMed Central JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'BMC_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- BrillOnline JR1
LOAD DATA LOCAL INFILE 'BRILL_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- BrillOnline JR1goa
LOAD DATA LOCAL INFILE 'BRILL_JR1goa.csv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- BrillOnline JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'BRILL_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access Denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- BrillOnline PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'BRILL_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- BrillOnline BR1
LOAD DATA LOCAL INFILE 'BRILL_BR1.csv'
INTO TABLE counter_br1
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_issn=@col7,
print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_total=@col8
;
-- BrillOnline BR2
LOAD DATA LOCAL INFILE 'BRILL_BR2.csv'
INTO TABLE counter_br2
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- BrillOnline BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'BRILL_BR3.csv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name, isbn
;
DROP TABLE counter_br3_delta
;
-- CQ Press/Sage JR1
LOAD DATA LOCAL INFILE 'SAGE_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- CQ Press/Sage JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- CQ Press/Sage DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- CQ Press/Sage DB2
CREATE TEMPORARY TABLE counter_db2_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_DB2.tsv'
INTO TABLE counter_db2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db2
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
turnaways
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,SUM(reporting_period_total)
FROM counter_db2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_db2_delta
;
-- CQ Press/Sage PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- CQ Press/Sage BR2
LOAD DATA LOCAL INFILE 'SAGE_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- CQ Press/Sage BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_BR3.tsv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- CQ Press/Sage BR4
CREATE TEMPORARY TABLE counter_br4_delta
(
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SAGE_BR4.tsv'
INTO TABLE counter_br4_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET proprietary_identifier=@col4,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col5,
reporting_period_total=@col6
;
INSERT INTO counter_br4
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br4_delta
GROUP BY item_name
;
DROP TABLE counter_br4_delta
;
-- CQ Press/Sage MR1
LOAD DATA LOCAL INFILE 'SAGE_MR1.tsv'
INTO TABLE counter_mr1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Collection",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
media_requests=@col4
;
-- ScienceDirect JR1
LOAD DATA LOCAL INFILE 'SD_JR1.txt'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ScienceDirect JR1goa
LOAD DATA LOCAL INFILE 'SD_JR1goa.txt'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ScienceDirect JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SD_JR2.txt'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- ScienceDirect BR2
LOAD DATA LOCAL INFILE 'SD_BR2.txt'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- ScienceDirect BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SD_BR3.txt'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Content Item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: Other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- Wiley Online Library JR1
LOAD DATA LOCAL INFILE 'WILEY_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Wiley Online Library JR1a
LOAD DATA LOCAL INFILE 'WILEY_JR1a.tsv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 11 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Wiley Online Library JR1goa
LOAD DATA LOCAL INFILE 'WILEY_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Wiley Online Library JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WILEY_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- Wiley Online Library DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WILEY_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- Wiley Online Library DB2
CREATE TEMPORARY TABLE counter_db2_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WILEY_DB2.tsv'
INTO TABLE counter_db2_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db2
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
turnaways
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,SUM(reporting_period_total)
FROM counter_db2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_db2_delta
;
-- Wiley Online Library PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WILEY_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- Wiley Online Library BR2
LOAD DATA LOCAL INFILE 'WILEY_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- Wiley Online Library BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WILEY_BR3.tsv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- JSTOR JR1
LOAD DATA LOCAL INFILE 'JSTOR_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- JSTOR JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'JSTOR_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- JSTOR DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'JSTOR_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- JSTOR DB2
CREATE TEMPORARY TABLE counter_db2_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'JSTOR_DB2.tsv'
INTO TABLE counter_db2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db2
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
turnaways
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,SUM(reporting_period_total)
FROM counter_db2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_db2_delta
;
-- JSTOR PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'JSTOR_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- JSTOR BR2
LOAD DATA LOCAL INFILE 'JSTOR_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- JSTOR BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'JSTOR_BR3.tsv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- NewsBank JR1
LOAD DATA LOCAL INFILE 'NB_JR1.txt'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- NewsBank DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'NB_DB1.txt'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- NewsBank PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'NB_PR1.txt'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- OECD iLibrary JR1
LOAD DATA LOCAL INFILE 'OECD_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- OECD iLibrary JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'OECD_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 16 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- OECD iLibrary PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'OECD_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- OECD iLibrary BR1
LOAD DATA LOCAL INFILE 'OECD_BR1.tsv'
INTO TABLE counter_br1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_issn=@col7,
print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_total=@col8
;
-- OECD iLibrary BR2
LOAD DATA LOCAL INFILE 'OECD_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- OECD iLibrary BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'OECD_BR3.tsv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 16 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- Ovid JR1
LOAD DATA LOCAL INFILE 'OVID_JR1.CSV'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Ovid JR1a
LOAD DATA LOCAL INFILE 'OVID_JR1a.csv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 11 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Ovid JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'OVID_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user licence limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_jr2_delta
;
-- Ovid PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'OVID_PR1.CSV'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- Project MUSE JR1
LOAD DATA LOCAL INFILE 'PM_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Project MUSE JR1goa
LOAD DATA LOCAL INFILE 'PM_JR1goa.csv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- Project MUSE JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PM_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_jr2_delta
;
-- Project MUSE PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PM_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- Project MUSE BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PM_BR3.csv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- ProQuest JR1
LOAD DATA LOCAL INFILE 'PQ_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ProQuest JR1a
LOAD DATA LOCAL INFILE 'PQ_JR1a.tsv'
INTO TABLE counter_jr1a
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ProQuest JR1goa
LOAD DATA LOCAL INFILE 'PQ_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ProQuest JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PQ_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied. Content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied. Concurrent/simultaneous user license exceeded. (Currently N/A to all platforms)."
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied. Other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- ProQuest DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PQ_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- ProQuest DB2
CREATE TEMPORARY TABLE counter_db2_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PQ_DB2.tsv'
INTO TABLE counter_db2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db2
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
turnaways
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,SUM(reporting_period_total)
FROM counter_db2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_db2_delta
;
-- ProQuest PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'PQ_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- ProQuest BR1
LOAD DATA LOCAL INFILE 'PQ_BR1.tsv'
INTO TABLE counter_br1
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_issn=@col7,
print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_total=@col8
;
-- ProQuest BR2
LOAD DATA LOCAL INFILE 'PQ_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- IngentaConnect JR1
LOAD DATA LOCAL INFILE 'INGENTA_JR1.csv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- IngentaConnect JR1goa
LOAD DATA LOCAL INFILE 'INGENTA_JR1goa.csv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- IngentaConnect JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'INGENTA_JR2.csv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 31 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: simultaneous/concurrent user licence limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- IngentaConnect PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'INGENTA_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- SpringerLink JR1
LOAD DATA LOCAL INFILE 'SPRINGER_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- SpringerLink JR1goa
LOAD DATA LOCAL INFILE 'SPRINGER_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- SpringerLink JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SPRINGER_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- SpringerLink BR2
LOAD DATA LOCAL INFILE 'SPRINGER_BR2.tsv'
INTO TABLE counter_br2
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col9,
ft_total=@col8
;
-- SpringerLink BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SPRINGER_BR3.tsv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- SpringerOpen JR1
LOAD DATA LOCAL INFILE 'SPRINGEROPEN_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- SpringerOpen JR1goa
LOAD DATA LOCAL INFILE 'SPRINGEROPEN_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- SpringerOpen JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'SPRINGEROPEN_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- ThiemeConnect JR1
LOAD DATA LOCAL INFILE 'THIEME_JR1.tsv'
INTO TABLE counter_jr1
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ThiemeConnect JR1goa
LOAD DATA LOCAL INFILE 'THIEME_JR1goa.tsv'
INTO TABLE counter_jr1_goa
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
ft_pdf=@col10,
ft_html=@col9,
ft_total=@col8
;
-- ThiemeConnect JR2
CREATE TEMPORARY TABLE counter_jr2_delta
(
print_issn VARCHAR(45),
online_issn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'THIEME_JR2.tsv'
INTO TABLE counter_jr2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_issn=@col6,
online_issn=@col7,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Journal",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col8,
reporting_period_total=@col9
;
INSERT INTO counter_jr2
(print_issn,
online_issn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licensed"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user license limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_jr2_delta
GROUP BY item_name
;
DROP TABLE counter_jr2_delta
;
-- ThiemeConnect PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'THIEME_PR1.tsv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col4
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- Web of Science DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WOS_DB1.tsv'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches - federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- Web of Science DB2
CREATE TEMPORARY TABLE counter_db2_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'WOS_DB2.tsv'
INTO TABLE counter_db2_delta
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db2
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
turnaways
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,SUM(reporting_period_total)
FROM counter_db2_delta
GROUP BY item_name, platform
;
DROP TABLE counter_db2_delta
;
-- Ebrary BR2
LOAD DATA LOCAL INFILE 'EBRARY_BR2.csv'
INTO TABLE counter_br2
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET print_isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col10,
ft_total=@col9
;
-- Ebrary BR3
CREATE TEMPORARY TABLE counter_br3_delta
(
issn VARCHAR(45),
isbn VARCHAR(45),
doi VARCHAR(255),
proprietary_identifier VARCHAR(45),
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
access_denied_category VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'EBRARY_BR3.csv'
INTO TABLE counter_br3_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
SET issn=@col7,
isbn=@col6,
doi=@col4,
proprietary_identifier=@col5,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
access_denied_category=@col9,
reporting_period_total=@col10
;
INSERT INTO counter_br3
(print_isbn,
doi,
proprietary_identifier,
platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
no_license,
turnaways,
other_reason
)
SELECT isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN access_denied_category="Access denied: content item not licenced"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'no_license',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: concurrent/simultaneous user licence limit exceeded"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'turnaways',
    SUM(
        CASE
            WHEN access_denied_category="Access denied: other"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'other_reason'
FROM counter_br3_delta
GROUP BY item_name
;
DROP TABLE counter_br3_delta
;
-- Ebrary PR1
CREATE TEMPORARY TABLE counter_pr1_delta
(
platform VARCHAR(255),
publisher TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'EBRARY_PR1.csv'
INTO TABLE counter_pr1_delta
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 9 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col1,
publisher=@col2,
data_type="Platform",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col3,
reporting_period_total=@col5
;
INSERT INTO counter_pr1
(platform,
publisher,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_pr1_delta
GROUP BY platform, publisher
;
DROP TABLE counter_pr1_delta
;
-- EBSCOhost DB1
CREATE TEMPORARY TABLE counter_db1_delta
(
platform VARCHAR(255),
publisher TEXT,
item_name TEXT,
data_type VARCHAR(45),
date_begin DATETIME,
date_end DATETIME,
user_activity VARCHAR(255),
reporting_period_total INT
)
;
LOAD DATA LOCAL INFILE 'EBSCO_DB1.txt'
INTO TABLE counter_db1_delta
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 8 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Database",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
user_activity=@col4,
reporting_period_total=@col5
;
INSERT INTO counter_db1
(platform,
publisher,
item_name,
data_type,
date_begin,
date_end,
reg_searches,
fed_searches,
res_clicks,
rec_views
)
SELECT platform,publisher,item_name,data_type,date_begin,date_end,
    SUM(
        CASE
            WHEN user_activity="Regular Searches"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'reg_searches',
    SUM(
        CASE
            WHEN user_activity="Searches-federated and automated"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'fed_searches',
    SUM(
        CASE
            WHEN user_activity="Result Clicks"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'res_clicks',
    SUM(
        CASE
            WHEN user_activity="Record Views"
            THEN reporting_period_total
            ELSE 0
		END
	) AS 'rec_views'
FROM counter_db1_delta
GROUP BY item_name
;
DROP TABLE counter_db1_delta
;
-- Books24x7 BR2
LOAD DATA LOCAL INFILE 'BK24_BR2.csv'
INTO TABLE `usage`.counter_br2
FIELDS TERMINATED BY ',' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 10 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14)
SET print_isbn=@col4,
platform=@col3,
publisher=@col2,
item_name=@col1,
data_type="Book",
date_begin=DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH),
date_end=CONCAT(LAST_DAY(DATE_ADD(DATE_ADD(LAST_DAY(CURRENT_DATE()),INTERVAL 1 DAY),INTERVAL -2 MONTH)),' 23:59:59'),
sec_html=@col12,
ft_total=@col12
;