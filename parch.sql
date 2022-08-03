/*write a query to find the average for each paper qty and average amount in usd*/
SELECT AVG(standard_qty) AS standard_qty_avg,
AVG(gloss_qty) AS gloss_qty_avg,
AVG(poster_qty) AS poster_qty_avg,
AVG(standard_amt_usd) AS standard_amt_avg,
AVG(gloss_amt_usd) AS gloss_amt_avg,
AVG(poster_amt_usd) AS poster_amt_avg
FROM orders

/*write a query to display three group low,middle,top base on total amount greater than 200000(top), total amount between 100000 and 200000(middle) and total amount below 100000(low) for year 2016 and 2017 only, order from highest to lowest*/
SELECT accounts.name,SUM(total_amt_usd) AS total,occurred_at,
CASE WHEN SUM(total_amt_usd) >=200000 THEN 'top'
WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'middle' 
WHEN SUM(total_amt_usd) <100000 THEN 'low' END AS level
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
GROUP BY 1,3
ORDER BY 2 DESC

/*Write a window function query to display the standard fourth quartile of account id and standard paper qty*/
SELECT account_id,occurred_at,SUM(standard_qty) standard,
NTILE(4) OVER (PARTITION BY account_id ORDER BY SUM(standard_qty) ) standard_quartile
FROM orders
GROUP BY 1,2

/*Provide the name of the sales_reps in each region with the largest amount of total_amt_usd*/
SELECT t3.rep_name,t3.reg_name,t3.total
FROM
(SELECT reg_name, MAX(total) total
FROM
(SELECT sales_reps.name rep_name,region.name reg_name,SUM(total_amt_usd) total
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1,2
ORDER BY 3 DESC) t1
GROUP BY 1
ORDER BY 1 DESC)t2
JOIN
(SELECT sales_reps.name rep_name,region.name reg_name,SUM(total_amt_usd) total
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE  region.name IN ('Northeast','West','Southeast','Midwest')
GROUP BY 1,2
ORDER BY 3 DESC)t3
ON t3.reg_name= t2.reg_name AND t3.total=t2.total

/*create a column that divides standard_amt_usd by the standard_qty to find the unit price include id and account_id,limit to 10*/
SELECT id,account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10

/*find the percentage of revenue that comes from poster_amt_usd paper for each order,include id,account_id and limit to 10*/
SELECT id,account_id, poster_amt_usd/100 AS revenue
FROM orders
LIMIT 10

/*find all the company that start with 'C' and it details in account table*/
SELECT *
FROM accounts
WHERE name LIKE 'C%'

/*find name,primary_poc,sales_rep_id for account name Walmart,Target and Nordstrom from account table*/
SELECT name,primary_poc,sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom')

/*write a query that returns all the orders where standard_qty >1000,poster_qty is 0 and gloss_qty is 0*/
SELECT standard_qty,poster_qty,gloss_qty
FROM orders
WHERE standard_qty > 1000 AND poster_qty=0 AND gloss_qty=0

/*write a query to show region_name,sales_rep_name,account_name for 'Midwest' region only and sort alphabetically*/
SELECT region.name AS region_name,sales_reps.name AS sales_name,accounts.name AS account_name
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
WHERE region.name IN ('Midwest')
ORDER BY accounts.name 

/*write a query to show region_name,unit_price(total_amt_usd/total),account_name, where standard_qty>100 and poster_qty>50,order the unit_price from largest to lowest*/
SELECT region.name AS region_name,total_amt_usd/total AS unit_price,accounts.name AS account_name
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE standard_qty>100 AND poster_qty>50
ORDER BY unit_price DESC

/*write a query to show the channels used by account_id '1001'*/
SELECT  DISTINCT(web_events.channel), accounts.name AS account_name,web_events.account_id
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id 
WHERE web_events.account_id IN (1001)

/*write a query to show orders that occurred in year 2015 include occrred_at,account_name,total,total_amt_usd*/
SELECT  orders.occurred_at, accounts.name,orders.total,orders.total_amt_usd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
WHERE orders.occurred_at >= '2015-01-01' AND orders.occurred_at <='2015-12-31'

/*find the total amount spent on standard_amt_usd an gloss_amt_usd*/
SELECT SUM(standard_amt_usd) AS total_standard, SUM(gloss_amt_usd) AS total_gloss
FROM orders

/*when was the first order placed*/
SELECT MIN(occurred_at)
FROM orders


/*write a query to return the account name with the earliest order ascendingly*/
SELECT accounts.name,MIN(orders.occurred_at)
FROM accounts
JOIN orders
ON accounts.id =orders.account_id
GROUP BY 1
ORDER BY 2

/*write a query to find the total number of times each channel are used*/
SELECT channel, COUNT(channel)
FROM web_events
GROUP BY 1

/*write a query to return the number of sales rep available for each region in ascending order*/
SELECT region.name,COUNT(sales_reps.name)
FROM region
JOIN sales_reps
ON region.id =sales_reps.region_id
GROUP BY 1
ORDER BY 2

/*write a query to find out how many times a sales rep uses different channel, order the numbers from highest to lowest*/
SELECT channel,COUNT(channel) AS times,sales_reps.name
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
GROUP BY 1,3
ORDER BY 2 DESC

/*write a qury to return sales rep with more than 5 accounts,order from the lowest to highest*/
SELECT sales_reps.name,COUNT(accounts.name) AS account_numbers
FROM sales_reps
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
GROUP BY 1
HAVING COUNT(accounts.name) >5
ORDER BY 2

/*write a query to return the accounts with more than 30000 orders*/
SELECT accounts.name,SUM(total)
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1
HAVING SUM(total) >30000

/*write a query to return the year in which parch and posey has the highest sales in amount,order from highest to lowest*/
SELECT DATE_PART('year',occurred_at), SUM(total)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

/*write q query to return the month in which 'Walmart',spend the most on gloss paper in terms of dollars*/
SELECT DATE_TRUNC('month',occurred_at), SUM(gloss_amt_usd),accounts.name
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
WHERE accounts.name IN ('Walmart')
GROUP BY 1,3
ORDER BY 2 DESC
LIMIT 1

/*write a query to display for each order,account id,total amount in dollar and level of the order-large or small- depending on if the order is 3000 or more or smaller than 3000*/
SELECT accounts.id,SUM(total) AS total,
CASE WHEN SUM(total) >=3000 THEN 'large'
ELSE 'small' END AS level
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1

/*write a query to display the number of orders in each of three categories based on total number of items in each order.the three categories are 'Atleast2000','Between 1000 and 2000' and 'less than 1000'*/
SELECT accounts.name,SUM(total) AS total,
CASE WHEN SUM(total) >=2000 THEN 'Atleast2000'
WHEN SUM(total) BETWEEN 1000 AND 2000 THEN 'middle' 
WHEN SUM(total) <1000 THEN 'less than 1000' END AS level
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1


/*write a query to identify the top performing sales rep associated with more than 200 orders as (top) and below 200 as (not)*/
SELECT sales_reps.name, COUNT(total),
CASE WHEN COUNT(total) >=200 THEN 'top'
ELSE 'not' END AS target
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
GROUP BY 1
ORDER BY 2 DESC

/*write a query to identify the top performing sales rep in total qty greater than or equal to 200 and total amount greater than 750000 as top,total qty greater than or equals to 150 and total amount greater than or equals to 500000 as middle and total below 150 and total amount below 500000 as low*/
SELECT sales_reps.name, COUNT(total) AS total_qty,SUM(total_amt_usd) AS total_amt,
CASE WHEN COUNT(total) >=200 AND SUM(total_amt_usd) >=750000 THEN 'top'
WHEN COUNT(total) >=150 AND SUM(total_amt_usd) >=500000 THEN 'middle'
ELSE 'low' END AS target
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
GROUP BY 1
ORDER BY 3 DESC


/*Write a query to display each region with the largest total amt usd and count of total orders*/
SELECT region.name reg_name,SUM(total_amt_usd) total,COUNT(total)
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1
ORDER BY 3 DESC

/*Write a query to display the proportion of account names that start with either number or letter*/
SELECT SUM(Num) Number,SUM(Letter) Letter
FROM
(SELECT accounts.name,
CASE WHEN LEFT(name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS Num,
CASE WHEN LEFT(name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS Letter
FROM accounts)t1

/*Write a query to display the proportion of account names that start with vowel or others*/
SELECT SUM(Vowel) Vowel,SUM(Other) Other
FROM
(SELECT accounts.name,
CASE WHEN LEFT(name,1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS Vowel,
CASE WHEN LEFT(name,1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS Other
FROM accounts)t1

/*Write a query to display the first and last name separately in a column for primary poc*/
SELECT primary_poc,
LEFT(primary_poc, STRPOS(primary_poc,' ')-1) first_name,
RIGHT(primary_poc,LENGTH(primary_poc)- STRPOS(primary_poc,' ')) last_name
FROM accounts

/*Write a query to display the first and last name separately in a column for primary poc and 
create an email with account name*/
SELECT first_name,last_name, CONCAT(first_name,'',last_name,'@',REPLACE(name,' ',''),'.com') email
FROM
(SELECT primary_poc,
LEFT(primary_poc, STRPOS(primary_poc,' ')-1) first_name,
RIGHT(primary_poc,LENGTH(primary_poc)- STRPOS(primary_poc,' ')) last_name,name
FROM accounts)t1

/*Write a query to display a window function of running total from standard amt usd by year*/
SELECT DATE_TRUNC('year',occurred_at),standard_amt_usd,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY occurred_at) running_total
FROM orders

/*Write a window function query to display account id by rank from highest to lowest*/
SELECT id,account_id,total,
RANK() OVER (PARTITION BY account_id ORDER BY total DESC) rank
FROM orders


/*Write a self join query for web events column*/
SELECT w1.id AS w1_id,
w1.account_id AS w1_account_id,
w1.occurred_at AS w1_occurred_at,
w1.channel AS w1_channel,
w2.id AS w2_id,
w2.account_id AS w2_account_id,
w2.occurred_at AS w2_occurred_at,
w2.channel AS w2_channel
FROM web_events w1
JOIN web_events w2
ON w1.id= w2.id
