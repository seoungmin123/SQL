--숙제 8-13번 까지 

-- 8번
SELECT r.region_id, r.region_name , c.country_name
FROM countries c JOIN regions r ON c.region_id = r.region_id
WHERE r.region_name = 'Europe';

--9번
SELECT r.region_id, r.region_name , c.country_name , l.city
FROM countries c JOIN regions r ON c.region_id = r.region_id
    JOIN locations l ON c.country_id = l.country_id
WHERE r.region_name = 'Europe';

--10번
SELECT r.region_id, r.region_name , c.country_name , l.city, d.department_name
FROM countries c JOIN regions r ON c.region_id = r.region_id
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON l.location_id =  d.location_id 
WHERE r.region_name = 'Europe';

SELECT*
FROM employees
;
--11번
SELECT r.region_id, r.region_name , c.country_name , l.city, d.department_name , CONCAT(e.first_name,e.last_name)
FROM countries c JOIN regions r ON c.region_id = r.region_id
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON l.location_id =  d.location_id 
    JOIN employees e ON d.manager_id = e.manager_id
WHERE r.region_name = 'Europe';

--12번
SELECT e.employee_id, CONCAT(e.first_name,e.last_name), j.job_id, j.job_title
FROM jobs j JOIN employees e ON j.job_id = e.job_id;

--13번
SELECT e.manager_id,  CONCAT(m.first_name,m.last_name)mgr_name, e.employee_id, 
       CONCAT(e.first_name,e.last_name)emp_name, j.job_id,j.job_title 
FROM employees e JOIN employees m ON e.manager_id = m.employee_id
    JOIN jobs j ON j.job_id = e.job_id ;