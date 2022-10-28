CREATE DATABASE Pharmacy;

CREATE TABLE product_sales(Distributor varchar(50),
						   Customer_Name varchar(200),
						   City varchar(50),
						   Country varchar(20),
						   Latitude float,
						   Longitude float,
						   Channel varchar(50),
						   Sub_channel varchar(50),
						   Product_Name varchar(50),
						   Product_Class varchar(50),
						   Quantity int,
						   Price int,
						   Sales int,
						   Month varchar(20),
						   Year int,
						   Name_of_Sales_Rep varchar(50),
						   Manager varchar(50),
						   Sales_Team varchar(10)
);

/*Display the product_sales columns details*/
SELECT *
FROM product_sales

/*Clean the city name*/
UPDATE product_sales
SET city = REPLACE(city,'?','')
WHERE city LIKE '%?' OR city LIKE '?%' OR city LIKE '%?%'

/*Add column QUARTER*/
ALTER TABLE product_sales
ADD Quarter varchar(2);

/*Insert values into column Quarter,according to the year quarter*/
UPDATE product_sales
SET quarter = CASE WHEN month IN ('January','February','March') THEN 'Q1'
              WHEN month IN ('April','May','June') THEN 'Q2'
			  WHEN month IN ('July','August','September') THEN 'Q3'
			  ELSE 'Q4' END;

/*Which customer has the pharmacy generated highest sales from*/
SELECT DISTINCT customer_name,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC

/*Which customer from poland has the pharmacy generated highest sales from*/
SELECT DISTINCT customer_name,SUM(sales) AS total_sales
FROM product_sales
WHERE country = 'Poland'
GROUP BY 1
ORDER BY 2 DESC;

/*Which distributor has the pharmacy generated highest sales from*/
SELECT DISTINCT distributor,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which country has the pharmacy generated highest sales from*/
SELECT DISTINCT country,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which city did the pharmacy generate more sales*/
SELECT DISTINCT city,country,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1,2
ORDER BY 3 DESC;

/*Which manager has highest sales*/
SELECT manager,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which pharmacy product has highest sales*/
SELECT DISTINCT product_name,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which pharmacy product class has highest sales*/
SELECT DISTINCT product_class,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which sales rep has highest sales*/
SELECT DISTINCT name_of_sales_rep,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which sales team has highest sales*/
SELECT DISTINCT sales_team,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which channel has highest sales*/
SELECT DISTINCT channel,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which sub_channel has highest sales*/
SELECT DISTINCT sub_channel,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which year has highest sales*/
SELECT DISTINCT year,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which month of the 4 years did the pharmacy generate highest sales*/
SELECT DISTINCT month,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which year did August have the highest sales*/
SELECT year,month,SUM(sales) AS total_sales
FROM product_sales
WHERE month IN ('August')
GROUP BY 1,2
ORDER BY 3 DESC;

/*Which quarter of the 4 years did the pharmacy generate highest sales*/
SELECT quarter,SUM(sales) AS total_sales
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which distributor ordered the most product in quantity*/
SELECT distributor,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which customer ordered the most product in quantity*/
SELECT customer_name,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which city has the most product ordered in quantity for the 4 years*/
SELECT city,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which country has the most product ordered in quantity for the 4 years*/
SELECT country,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which channel has the most product ordered in quantity*/
SELECT channel,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which sub_channel has the most product ordered in quantity*/
SELECT sub_channel,SUM(quantity) AS total_quantity
FROM product_sales
GROUP BY 1
ORDER BY 2 DESC;

/*Which product was the most ordered in quantity between 2019-2020*/
SELECT product_name,SUM(quantity) AS total_quantity
FROM product_sales
WHERE year BETWEEN 2019 AND 2020
GROUP BY 1
ORDER BY 2 DESC;

/*Which product class was the most ordered in quantity between 2019-2020 during Q4*/
SELECT product_class,SUM(quantity) AS total_quantity
FROM product_sales
WHERE year IN(2019,2020) AND quarter ='Q4'
GROUP BY 1
ORDER BY 2 DESC;

/*Which month was Mood Stabilizers ordered in quantity between 2019-2020 during Q1*/
SELECT month,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class LIKE 'M%' AND year IN(2019,2020) AND quarter ='Q1'
GROUP BY 1
ORDER BY 2 DESC;

/*Which year was Antimalaria drugs ordered in high quantity between 2019-2020*/
SELECT month,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class LIKE '%ma%' AND year IN(2019,2020)
GROUP BY 1
ORDER BY 2 DESC;

/*Which quarter was Antimalaria drugs ordered in high quantity between 2019-2020*/
SELECT quarter,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class LIKE 'Anti%' AND product_class NOT LIKE '%tics' AND year IN(2019,2020)
GROUP BY 1
ORDER BY 2 DESC;

/*Which sales rep has the highest quantity ordered for Antimalarial drugs in Q4 of 2020*/
SELECT DISTINCT name_of_sales_rep,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class LIKE '%mala%' AND year IN(2020) AND quarter ='Q4'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*Which manager has the highest quantity ordered for Mood Stabilizers drugs in Q4 of the 4 years*/
SELECT DISTINCT manager,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class LIKE 'Mood%'  AND quarter ='Q4'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*Which sales team has the highest quantity ordered for Mood Stabilizers and Antimalarial drugs in Q4 during the  4 years*/
SELECT DISTINCT sales_team,SUM(quantity) AS total_quantity
FROM product_sales
WHERE product_class IN('Mood Stabilizers','Antimalarial')  AND quarter ='Q4'
GROUP BY 1
ORDER BY 2 DESC;


