with CTE_emp_mgr_expn as
(SELECT e.employee_id, 
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
       e.manager_id,
       CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
       SUM(ex.unit_price * ex.quantity) AS total_expensed_amount
FROM EMPLOYEE e
JOIN EMPLOYEE m ON e.manager_id = m.employee_id
JOIN EXPENSE ex ON e.employee_id = ex.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, m.first_name, m.last_name, e.manager_id
)
select employee_id, employee_name, manager_id, manager_name, total_expensed_amount
from CTE_emp_mgr_expn
where total_expensed_amount > 1000
ORDER BY total_expensed_amount DESC;