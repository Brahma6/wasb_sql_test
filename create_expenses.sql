CREATE TABLE EXPENSE (
  employee_id TINYINT,
  unit_price DECIMAL(8, 2),
  quantity TINYINT
);


CREATE TABLE memory.default.EXPENSE_json (
expense_details VARCHAR
);


INSERT INTO memory.default.EXPENSE_json (expense_details)
VALUES ('{"Employee": "Alex Jacobson", "Items": "Drinks, lots of drinks", "Unit Price": 6.50, "Quantity": 14}'),
('{"Employee": "Alex Jacobson", "Items": "More Drinks", "Unit Price": 110.00, "Quantity": 20}'),
('{"Employee": "Alex Jacobson", "Items": "So Many Drinks!", "Unit Price": 22.00, "Quantity": 18}'),
('{"Employee": "Andrea Ghibaudi", "Items": "Flights from Mexico back to New York", "Unit Price": 300, "Quantity": 10}'),
('{"Employee": "Darren Poynton", "Items": "Ubers to get us all home", "Unit Price": 40.00, "Quantity": 9}'),
('{"Employee": "Umberto Torrielli", "Items": "I had too much fun and needed something to eat", "Unit Price": 17.50, "Quantity": 4}');


INSERT INTO expense
WITH EMP_EXPN_CTE AS 
(
SELECT emp.employee_id, emp.Employee_name, expn.*
FROM (
SELECT employee_id, first_name || ' ' || last_name || as Employee_name
from  EMPLOYEE ) emp
JOIN (
SELECT
    regexp_replace(json_query(expense_details,'lax $.Employee'),'"','') AS Employee_name,
	json_query(expense_details,'lax $.Items') AS Items,
	json_query(expense_details,'lax $."Unit Price"') AS unit_Price,
	json_query(expense_details,'lax $.Quantity') AS quantity		
FROM EXPENSE_json) expn
ON expn.Employee_name  = emp.Employee_name
)
SELECT employee_id, CAST(unit_price AS DECIMAL(8,2)) AS unit_price, CAST(quantity AS TINYINT) AS quantity
FROM EMP_EXPN_CTE;