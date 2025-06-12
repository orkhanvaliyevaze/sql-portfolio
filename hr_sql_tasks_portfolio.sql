-- 1) Adında ‘a’ (və ya ‘A’) hərfi olan işçilərdən, 2005 və 2008-ci illər arasında işə başlayanların məlumatları

SELECT *
FROM hr.employees
WHERE LOWER(first_name) LIKE '%a%'
  AND EXTRACT(YEAR FROM hire_date) BETWEEN 2005 AND 2008;

-- 2) Employees cədvəlindən fərqli maaşların sayını və onların total cəmini çıxaran sorğu

SELECT COUNT(DISTINCT salary) AS distinct_salary_count,
       SUM(salary) AS total_salary_sum
FROM hr.employees;

-- 3) Maaşı 10000-dən yuxarı olan işçilərin işlədiyi şəhərlərin siyahısı (hər şəhər adı 1 dəfə çıxsın)

SELECT DISTINCT l.city
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations l ON d.location_id = l.location_id
WHERE e.salary > 10000;

--4) Maaşı 5000-dən yuxarı olan işçiləri department_id-yə görə qrupla, sayı 5-dən çox olanları göstər, çoxdan aza
SELECT department_id, COUNT(*) AS emp_count
FROM hr.employees
WHERE salary > 5000
GROUP BY department_id
HAVING COUNT(*) > 5
ORDER BY emp_count DESC;

--5) Ən tez işə girən işçinin yalnız ili
SELECT TO_CHAR(MIN(hire_date), 'YYYY') AS earliest_year
FROM hr.employees;

--6) Hər departamentdəki maksimum maaşı göstər (departament adı ilə birlikdə)
SELECT d.department_name,
       MAX(e.salary) AS max_salary
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

--7) Hər bir departament üzrə orta maaş 7000-dən yuxarı olanların siyahısı
SELECT d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 7000;

--8) ‘IT’ departamentində çalışan işçilərin ad və soyadlarını çıxart
SELECT e.first_name, e.last_name
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

--9) Bütün menecerlərin (manager_id) neçə işçiyə rəhbərlik etdiyini göstər
SELECT manager_id, COUNT(*) AS employee_count
FROM hr.employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY employee_count DESC;

--10) Ən yüksək maaş alan işçinin adı, soyadı və maaşı
SELECT first_name, last_name, salary
FROM hr.employees
WHERE salary = (SELECT MAX(salary) FROM hr.employees);

--11) İşçilərin maaşlarını artan sırada göstər, eyni maaş varsa soyadla sırala
SELECT first_name, last_name, salary
FROM hr.employees
ORDER BY salary ASC, last_name ASC;

--12) İşə 2007-ci ildə başlayanların sayı
SELECT COUNT(*) AS employee_count_2007
FROM hr.employees
WHERE TO_CHAR(hire_date, 'YYYY') = '2007';

--13) ‘Marketing’ və ‘IT’ departamentində çalışan işçilərin siyahısı
SELECT e.first_name, e.last_name, d.department_name
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name IN ('Marketing', 'IT');

--14) Hər bir işçinin neçə ildir şirkətdə işlədiyini göstər
SELECT first_name, last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)/12, 1) AS years_worked
FROM hr.employees;

--15) Hansı şəhərlərdə departament var və neçə departament yerləşir?
SELECT l.city, COUNT(d.department_id) AS department_count
FROM hr.departments d
JOIN hr.locations l ON d.location_id = l.location_id
GROUP BY l.city;

