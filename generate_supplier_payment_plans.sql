WITH payments AS (
  SELECT s.supplier_id,
         s.name AS supplier_name,
         i.invoice_amount AS balance_outstanding,
         last_day_of_month(CURRENT_DATE) AS payment_date,
         LEAST(1500, i.invoice_amount) AS payment_amount,
		 (row_number() OVER (PARTITION BY s.name ORDER BY i.invoice_amount DESC) - 1) AS pay_order
  FROM SUPPLIER s
  JOIN INVOICE i ON s.supplier_id = i.supplier_id
)
SELECT supplier_id, 
       supplier_name, 
       payment_amount, 
       balance_outstanding, 
       DATE_ADD('month',pay_order,payment_date) as payment_date
FROM payments;
