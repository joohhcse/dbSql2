

ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY java;

--join 8
SELECT r.region_id, r.region_name, c.country_name
FROM regions r, countries c
WHERE r.region_id = c.region_id
AND r.region_name = 'Europe';

--join 9
--row 9 - france, denmark, belgium 3개 국가에 속하는 location 정보는 미존재
--나머지 5개 중 다수의 location 정보를 갖고 있는 국가가 존재한다.
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM regions r, countries c, locations l
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND r.region_name = 'Europe';

--join 10
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM regions r, countries c, locations l, departments d
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND d.location_id = l.location_id
AND r.region_name = 'Europe';

--join11
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name, e.first_name || e.last_name name
FROM regions r, countries c, locations l, departments d, employees e
WHERE r.region_id = c.region_id
AND c.country_id = l.country_id
AND d.location_id = l.location_id
AND e.department_id = d.department_id
AND r.region_name = 'Europe';

--join12
SELECT e.employee_id, e.first_name || e.last_name name, j.job_id, j.job_title
FROM employees e, jobs j
WHERE j.job_id = e.job_id;

--join13
SELECT tbl.mng_id, tbl.mng_name, tbl.employee_id, tbl.name, tbl.job_id, tbl.job_title 
FROM 
    (SELECT e.manager_id mng_id, e.first_name || e.last_name mng_name, e.employee_id employee_id, 
    e.first_name || e.last_name name, j.job_id job_id, j.job_title job_title
    FROM employees e, jobs j
    WHERE j.job_id = e.job_id
    ORDER BY e.employee_id) tbl
WHERE tbl.mng_id = 100;

--join13
--Sol>
SELECT e.manager_id mgr_id,
        mng.first_name || mng.last_name mgr_name,
        e.first_name || e.last_name name,
        j.job_id, j.job_title
FROM    employees e, jobs j, employees mng
WHERE j.job_id = e.job_id
AND e.manager_id = mng.employee_id;




--OUTER JOIN : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는
--나오도록 하는 JOIN
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할때 조인에 실패하더라도 테이블1쪽의 데이터는
--조회가 되도록 한다















