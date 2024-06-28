USE BSR_ImportStock
Select * FROM Sales_Data

Select MAX(Sales) Max_sale, Material FROM Sales_Data
group by Material                                                  --Max is used as aggregate function

Select Sales_Data.*, MAX(Net_Profit) Over(Partition by Material) as Max_Profit              -- Max is used as window function
FROM Sales_Data


SELECT * FROM (
Select Sales_Data.*, ROW_NUMBER() Over(Partition by Material order by Net_Profit DESC) as rn_profit             -- sorting by top 10 row and higher profit amount
FROM Sales_Data ) as X
WHERE X.rn_profit<11

Select Sales_Data.*, RANK() Over(Partition by Material order by Net_Profit DESC) as profit_rnk             -- sorting by rank and higher profit amount
FROM Sales_Data

SELECT * FROM
(
Select Sales_Data.*, RANK() Over(Partition by Material order by Net_Profit DESC) as profit_rnk             -- sorting by top 5 rank and higher profit amount
FROM Sales_Data
) as Y
WHERE Y.profit_rnk<6

SELECT * FROM
(
Select Sales_Data.*, RANK() Over(Partition by Material order by Net_Profit DESC) as profit_rnk,
DENSE_RANK() Over(Partition by Material order by Net_Profit DESC) as profit_densernk                       -- sorting by top 5 rank and dense rank(consecutive rank) and higher profit amount
FROM Sales_Data
) as W
WHERE W.profit_rnk<6


SELECT * FROM (
SELECT Sales_Data.*,
ROW_NUMBER() Over(Partition by Material order by Net_Profit DESC) as RowNum,
LAG(Sales) Over(Partition by Material order by Net_Profit DESC) as prev_sales,
LEAD(Sales) Over(Partition by Material order by Net_Profit DESC) as followig_sales        -- sorting by top 10 profit making sales with their previous sales and following sales
FROM Sales_Data
) AS A
WHERE A.RowNum<=10


SELECT Sales_Data.*,
LAG(Sales) Over(Partition by Material order by Net_Profit DESC) as prev_sales,
CASE	
	WHEN Sales_Data.Sales > LAG(Sales) Over(Partition by Material order by Net_Profit DESC) THEN 'sales is higher than previous sale'
	WHEN Sales_Data.Sales < LAG(Sales) Over(Partition by Material order by Net_Profit DESC) THEN 'sales is lower than previous sale'
	WHEN Sales_Data.Sales = LAG(Sales) Over(Partition by Material order by Net_Profit DESC) THEN 'sale is same as previous sale'               -- Previous sale data comparison
	END Comparison_to_previous_sale
FROM Sales_Data


SELECT * FROM (
SELECT Sales_Data.*,
RANK() OVER(PARTITION BY Material ORDER BY Sales DESC) AS Sale_Rnk,
CASE 
WHEN Sales>3000 THEN 'Prime Customers'
WHEN Sales<3000 THEN 'Regular Customers'
END AS Customer_Category
FROM Sales_Data
) AS X
Where X.Sale_Rnk<51

Select * From Customers_Data

SELECT SD.Customer_No, CD.Customer_Name, CD.City, SUM(SD.Sales) as Sales_From_customer, SUM(SD.Net_Profit) as Profit_From_Customer
FROM Sales_Data SD
JOIN Customers_Data CD ON SD.Customer_No = CD.Customer_ID 
Group By SD.Customer_No, CD.Customer_name,CD.City Order By Sales_From_customer DESC








