



--GROUPING SETS(col1, col2)
-- 다음결과가 동일
-- 개발자가 GROUP BY의 기준을 직접 명시한다.
-- ROLLUP과 달리 방향성을 갖지 않는다 
-- GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- emp 테이블에서 직원의 job별 급여(sal) + 상여(comm) 합,
--                   deptno(부서)별 급여(sal) + 상여(comm) 합 구하기
-- 기존 방식(GROUP FUNCTION) : 2 번의 SQL 작성 필요(UNION / UNION ALL)
SELECT job, NULL deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL
SELECT '', deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

-- GROUPING SETS 구문을 이용하여 위의 SQL을 집합연산을 사용하지 않고
-- 테이블을 한번 읽어서 처리
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno);

-- job, deptno를 그룹으로 한 sal+comm 합
-- mgr를 그룹으로 한 sal + comm 합
-- GROUP BY job, deptno
-- UNION ALL
-- GORUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

-- CUBE (col1, col2, ...)
-- 나열된 컬럼의 모든 가능한 조합으로 GROUP BY subset 을 만든다
-- CUBE에 나열된 컬럼이 2개인 경우 : 가능한 조합 4개
-- CUBE에 나열된 컬럼이 3개인 경우 : 가능한 조합 8개
-- CUBE에 나열된 컬럼수를 2의 제곱 한 결과가 가능한 조합 개수가 된다. (2^n)
-- 컬럼이 조금만 많아져도 가능한 조합이 기하급수적으로 늘어 나기 때문에 많이 사용하지는 않는다...

--job, deptno를 이용하여 CUBE 적용
--NULL	            NULL	        31225      --GROUP BY 전체행
--NULL	            10	            8750       --GROUP BY deptno
--NULL	            20	            10875
--NULL	            30          	11600
--CLERK	            NULL	        4150       --GROUP BY job
--CLERK	            10	            1300       --GROUP BY job, deptno
--CLERK	            20	            1900
--CLERK	            30	            950
--ANALYST	        NULL	        6000
--ANALYST	        20	            6000
--MANAGER	        NULL            8275
--MANAGER	        10	            2450
--MANAGER 	        20          	2975
--MANAGER	        30          	2850
--SALESMAN	        NULL            7800
--SALESMAN	        30	            7800
--PRESIDENT     	NULL            5000
--PRESIDENT     	10	            5000

--job, deptno를 이용하여 CUBE 적용
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY CUBE(job, deptno);

--job, deptno
--1,   1,   --> GROUP BY job, deptno
--1,   0,   --> GROUP BY job
--0,   1,   --> GROUP BY deptno
--0,   0,   --> GROUP BY --emp 테이블의 모든행에 대해 GROUP BY

--GROUP BY 응용
--GROUP BY, ROLLUP, CUBE를 섞어 사용하기
--가능한 조합을 생각해보면 쉽게 결과를 예측할 수 있다.
--GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

--sub_a1
-- subquery를 이용하여 dept_test 테이블의 empcnt 컬럼에 해당 부서원 수를 UPDATE 하는 쿼리를 작성하세요
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

--deptno = 10 --> empcnt = 3
--deptno = 20 --> empcnt = 5
--deptno = 30 --> empcnt = 6
SELECT *
FROM emp
WHERE deptno = 30;
SELECT *
FROM dept_test;

--DB쌤 답
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno);
                                
--10	ACCOUNTING	NEW YORK	3
--20	RESEARCH	DALLAS	5
--30	SALES	CHICAGO	6
--40	OPERATIONS	BOSTON	0

DROP TABLE dept_test;

--sub_a1
-- emp 테이블의 직원들이 속하지 않는 부서 정보 삭제하는 쿼리를 서브쿼리를 이용하여 작성하세요
-- 전체 deptno : 10, 20, 30, 40, 98, 99
-- 삭제 deptno : 40, 98, 99
CREATE TABLE dept_test AS
SELECT *
FROM dept;
INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES(98, 'it2', 'daejeon');

SELECT *
FROM dept_test;

DELETE dept_test WHERE dept_test.deptno NOT IN(10, 20, 30); --하드코딩 HardCoding

DELETE dept_test WHERE dept_test.deptno NOT IN(10, 20, 30);

-->DB쌤 답
DELETE dept_test WHERE dept_test.deptno NOT IN(SELECT deptno
                                                FROM emp);

--sub_a3
--subquery를 이용하여 emp_test 테이블에서 본인이 속한 부서의(sal) 평균 급여보다 
--급여가 작은 직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리를 작성하세요
DROP TABLE emp_test;

CREATE TABLE emp_test 
AS 
SELECT *
FROM emp;

SELECT *
FROM emp;

SELECT *
FROM emp_test;

SELECT et.empno, et.ename, et.job, et.sal, et.deptno, a.avg_sal 
FROM
    (SELECT deptno, AVG(sal) avg_sal
    FROM emp_test
    GROUP BY deptno) a,
    emp_test et
WHERE a.avg_sal < et.sal
AND a.deptno = et.deptno;
--
UPDATE emp_test SET sal = sal + 200
WHERE emp_test.empno = (SELECT et.empno
                        FROM
                            (SELECT deptno, AVG(sal) avg_sal
                            FROM emp_test
                            GROUP BY deptno) a,
                            emp_test et
                        WHERE a.avg_sal > et.sal
                        AND a.deptno = et.deptno);
                        
--DB 쌤 답
SELECT ROUND(AVG(sal), 2)
FROM emp
WHERE deptno = 10;

SELECT empno, ename, deptno, sal
FROM emp
ORDER BY deptno;

SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno
ORDER BY deptno;
------------------------------------------------
UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT ROUND(AVG(sal), 2)
            FROM emp
            WHERE deptno = emp_test.deptno);
------------------------------------------------
--DB 쌤 답--



--MERGE 구문을 이용한 업데이트 >>> ON 절에 오는 컬럼들은 업데이트 할수없다
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
        FROM emp_test
        GROUP BY deptno) b
ON ( a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
    WHERE a.sal < b.avg_sal;    --WHERE절 여기에 추가해서 병합 성공(GOOD)
ROLLBACK;    

MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
        FROM emp_test
        GROUP BY deptno) b
ON ( a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal = CASE  
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;
--DB 쌤 답--









