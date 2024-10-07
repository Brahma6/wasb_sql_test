CREATE TABLE memory.default.invoice_json (
invoice_details VARCHAR
);

INSERT INTO memory.default.invoice_json (invoice_details)
VALUES
('{"Company Name": "Party Animals", "Invoice Items": "[Zebra, Lion, Giraffe, Hippo]", "Invoice Amount": 6000, "Due Date": "3 months from now"}')
,('{"Company Name": "Catering Plus", "Invoice Items": "[Champagne, Whiskey, Vodka, Gin, Rum, Beer, Wine.]", "Invoice Amount": 2000, "Due Date": "2 months from now"}')
,('{"Company Name": "Catering Plus", "Invoice Items": "[Pizzas, Burgers, Hotdogs, Cauliflour Wings, Caviar]", "Invoice Amount": 1500, "Due Date": "3 months from now"}')
,('{"Company Name": "Dave''s Discos", "Invoice Items": "[Dave, Dave Equipment]", "Invoice Amount": 500, "Due Date": "1 month from now"}')
,('{"Company Name": "Entertainment tonight", "Invoice Items": "[Portable Lazer tag, go carts, virtual darts, virtual shooting, puppies.]", "Invoice Amount": 6000, "Due Date": "3 months from now"}')
,('{"Company Name": "Ice Ice Baby", "Invoice Items": "[Ice Luge, Lifesize ice sculpture of Umberto]", "Invoice Amount": 4000, "Due Date": "6 months from now"}')
;

CREATE TABLE supplier (
  supplier_id TINYINT,
  name VARCHAR
);

INSERT INTO memory.default.supplier
SELECT DISTINCT
cast(dense_rank() OVER (ORDER BY company_name ASC) as TINYINT) AS supplier_id
,company_name
FROM (
SELECT
    regexp_replace(json_query(invoice_details,'lax $."Company Name"'),'"','') AS company_name
FROM invoice_json) invjsn
;

CREATE TABLE invoice (
  supplier_id TINYINT,
  invoice_amount DECIMAL(8, 2),
  due_date DATE
);

INSERT INTO memory.default.invoice
SELECT 
cast(dense_rank() OVER (ORDER BY company_name ASC) as TINYINT) AS supplier_id
,cast(invoice_amount as DECIMAL(8, 2)) as invoice_amount
,last_day_of_month(DATE_ADD(regexp_split(str_due_date, '\s+')[2], cast(regexp_split(str_due_date, '\s+')[1] as int), CURRENT_DATE)) AS due_date
FROM (
SELECT
    json_query(invoice_details,'lax $."Company Name"') AS company_name,
	json_query(invoice_details,'lax $."Invoice Amount"') AS invoice_amount,
	regexp_replace(regexp_replace(json_query(invoice_details,'lax $."Due Date"'), 'months', 'month'),'"','') AS str_due_date
FROM invoice_json) invjsn
;