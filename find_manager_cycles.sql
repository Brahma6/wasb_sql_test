SELECT e.employee_id, 
ARRAY_AGG(e.manager_id ) AS cycle 
FROM EMPLOYEE e
JOIN EMPLOYEE m
ON e.employee_id = m.manager_id and  e.manager_id = m.employee_id
group by e.employee_id
;

