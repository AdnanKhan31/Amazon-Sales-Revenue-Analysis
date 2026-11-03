Select * from cleaned_amazon;

#1Q. Which product category has the highest total quantity sold?
SELECT * FROM Category_Wise_Quantity_Sold;
CREATE VIEW Category_Wise_Quantity_Sold AS
SELECT "Category",
SUM("Quantity") AS "Total_Quantity_Sold"
FROM cleaned_amazon
GROUP BY "Category"
ORDER BY "Total_Quantity_Sold" DESC
LIMIT 1;

#2Q. Which product category has the highest total sales amount?
SELECT * FROM Category_Wise_Sale;
CREATE VIEW Category_Wise_Sale AS
SELECT "Category",
ROUND(SUM("TotalAmount")::numeric, 2) AS "Total_Sales_Amount"
FROM cleaned_amazon
GROUP BY "Category"
LIMIT 1;

#3Q. What is the distribution of orders by status?
SELECT * FROM Order_Status_Distribution;
CREATE VIEW Order_Status_Distribution AS
SELECT "OrderStatus",
COUNT("OrderID") AS "Total_Orders"
FROM cleaned_amazon
GROUP BY "OrderStatus";

#4Q. Which city has the highest number of delivered orders?
SELECT * FROM City_Wise_Delivered_Orders;
CREATE VIEW City_Wise_Delivered_Orders AS
SELECT "City",
COUNT("OrderID") AS "Delivered_Orders"
FROM cleaned_amazon
WHERE "OrderStatus" = 'Delivered'
GROUP BY "City";

#5Q. Which seller has the highest number of orders?
SELECT * FROM Seller_Wise_Orders;
CREATE OR REPLACE VIEW Seller_Wise_Orders AS
SELECT "SellerID",
COUNT("OrderID") AS "Total_Orders"
FROM cleaned_amazon
GROUP BY "SellerID"
ORDER BY "Total_Orders" DESC
LIMIT 1;

#6Q. Which brand has the highest total quantity sold?
SELECT * FROM Brand_Wise_Quantity_Sold;
CREATE VIEW Brand_Wise_Quantity_Sold AS
SELECT "Brand",
SUM("Quantity") AS "Total_Quantity_Sold"
FROM cleaned_amazon
GROUP BY "Brand";

#7Q. Which category and brand combinations have sold more than the average quantity sold across all category-brand combinations?
SELECT * FROM Above_Average_Category_Brand_Sales;
CREATE VIEW Above_Average_Category_Brand_Sales AS
SELECT "Category", "Brand",
SUM("Quantity") AS "Total_Quantity_Sold"
FROM cleaned_amazon
GROUP BY "Category", "Brand"
HAVING SUM("Quantity") > (
SELECT AVG("Total_Quantity")
FROM (
SELECT SUM("Quantity") AS "Total_Quantity"
FROM cleaned_amazon
GROUP BY "Category", "Brand"
) AS Category_Brand_Sales
)
ORDER BY "Total_Quantity_Sold" DESC;

#8Q. Which product categories have a higher percentage of cancelled orders compared with the overall cancellation rate?
SELECT * FROM Category_Wise_Cancellation_Rate;
CREATE VIEW Category_Wise_Cancellation_Rate AS
SELECT "Category",
COUNT(*) FILTER (WHERE "OrderStatus" = 'Cancelled') AS "Cancelled_Orders",
COUNT(*) AS "Total_Orders",
ROUND(
COUNT(*) FILTER (WHERE "OrderStatus" = 'Cancelled')::numeric * 100 / COUNT(*), 2
) AS "Cancellation_Rate"
FROM cleaned_amazon
GROUP BY "Category"
HAVING
COUNT(*) FILTER (WHERE "OrderStatus" = 'Cancelled')::numeric / COUNT(*) >
(
SELECT
COUNT(*) FILTER (WHERE "OrderStatus" = 'Cancelled')::numeric / COUNT(*)
FROM cleaned_amazon
)
ORDER BY "Cancellation_Rate" DESC;

#9Q. Which cities have an average order value higher than the overall average order value?
SELECT * FROM City_Wise_Average_Order_Value;
CREATE VIEW City_Wise_Average_Order_Value AS
SELECT "City",
ROUND(AVG("TotalAmount")::numeric, 2) AS "Average_Order_Value"
FROM cleaned_amazon
GROUP BY "City"
HAVING AVG("TotalAmount") > (
SELECT AVG("TotalAmount")
FROM cleaned_amazon
)
ORDER BY "Average_Order_Value" DESC;

#10Q. Which states contribute more than 10% to the overall sales amount?
SELECT * FROM State_Wise_Sales_Contribution;
CREATE VIEW State_Wise_Sales_Contribution AS
SELECT "State",
ROUND(SUM("TotalAmount")::numeric, 2) AS "Total_Sales_Amount",
ROUND(
SUM("TotalAmount")::numeric * 100 / (SELECT SUM("TotalAmount")::numeric FROM cleaned_amazon),2)::TEXT ||'%'
AS "Sales_Contribution_Percentage"
FROM cleaned_amazon
GROUP BY "State"
HAVING
SUM("TotalAmount") > (SELECT SUM("TotalAmount") * 0.10 FROM cleaned_amazon)
ORDER BY "Sales_Contribution_Percentage" DESC;

#11Q. Which payment methods generate above-average sales per order compared with the overall average sales per order?
SELECT * FROM Payment_Method_Sales_Analysis;
CREATE VIEW Payment_Method_Sales_Analysis AS
SELECT "PaymentMethod",
COUNT("OrderID") AS "Total_Orders",
ROUND(SUM("TotalAmount")::numeric, 2) AS "Total_Sales",
ROUND(AVG("TotalAmount")::numeric, 2) AS "Average_Sales_Per_Order"
FROM cleaned_amazon
GROUP BY "PaymentMethod"
HAVING AVG("TotalAmount") > (SELECT AVG("TotalAmount")
FROM cleaned_amazon
)
ORDER BY "Average_Sales_Per_Order" DESC;

#12Q. Which products have the highest return/cancellation rate, and how many orders were affected?
SELECT * FROM Product_Cancellation_Return_Analysis;
CREATE VIEW Product_Cancellation_Return_Analysis AS
SELECT "ProductName",
COUNT("OrderID") AS "Total_Orders",
COUNT(*) FILTER (
WHERE "OrderStatus" IN ('Cancelled', 'Returned')
) AS "Affected_Orders",
ROUND(
COUNT(*) FILTER (
WHERE "OrderStatus" IN ('Cancelled', 'Returned')
)::numeric * 100 / COUNT(*), 2
):: TEXT ||'%' AS "Cancellation_Return_Rate"
FROM cleaned_amazon
GROUP BY "ProductName"
HAVING COUNT(*) FILTER (
WHERE "OrderStatus" IN ('Cancelled', 'Returned')
) > 0
ORDER BY "Cancellation_Return_Rate" DESC
LIMIT 10;

#13Q. Which states have the highest number of distinct sellers?
SELECT * FROM State_Wise_Seller_Count;
CREATE VIEW State_Wise_Seller_Count AS
SELECT "State",
COUNT(DISTINCT "SellerID") AS "Total_Sellers",
RANK() OVER (
ORDER BY COUNT(DISTINCT "SellerID") DESC)
AS "State_Rank"
FROM cleaned_amazon
GROUP BY "State"
ORDER BY "State_Rank";

#14Q. Which brands offer an average discount higher than the overall average discount?
SELECT * FROM Brand_Wise_Average_Discount;
CREATE VIEW Brand_Wise_Average_Discount AS
SELECT "Brand",
ROUND(AVG("Discount")::numeric * 100, 2):: TEXT || '%' AS "Average_Discount_Percentage"
FROM cleaned_amazon
GROUP BY "Brand"
HAVING AVG("Discount") > (
SELECT AVG("Discount")
FROM cleaned_amazon
)
ORDER BY "Average_Discount_Percentage" DESC;










