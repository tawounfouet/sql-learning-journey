
-- CREATE table analytics.date_dim

-- create the table
--DROP table if exists analytics.retail_sales;
CREATE table analytics.retail_sales
(
sales_month date
,naics_code varchar
,kind_of_business varchar
,reason_for_null varchar
,sales decimal
)
;

-- populate the table with data from the csv file. Download the file locally before completing this step
COPY analytics.retail_sales 
-- FROM '/localpath/us_retail_sales.csv' -- change to the location you saved the csv file
FROM 'C:\Users\awounfouet\formation\sql\sql-book-analytics\Chapter 3_ Time Series Analysis\us_retail_sales.csv'
DELIMITER ','
CSV HEADER
;
