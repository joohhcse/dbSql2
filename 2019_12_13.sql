
SELECT *
FROM emp_test
ORDER BY empno;

--emp테이블에 존재하는 데이터를 emp_test 테이블로 머지
--만약 empno가 동일한 데이터가 존재하면
--ename update : ename || '_merge'
--만약 empno가 동일한 데이터가 존재하지 않을 경우
--emp테이블의 empno, ename emp_test 데이터로 insert

--emp_test 데이터에서 절반의 데이터를 삭제
DELETE emp_test
WHERE empno >= 7788;
COMMIT;

--emp 테이블에는 14건의 데이터가 존재
--emp_test 테이블에는 사번이 7788보다 작은7명의 데이터가 존재
--emp테이블을 이용하여 emp_test 테이블을 머지하게 되면
--emp테이블에만 존재하는 직원(사번이 7788보다 크거나 같은) 7명
--emp_test 로 새롭게 insert가 될 것이고
--emp, emp_test에 사원번호가 동일하게 존재하는 7명의 데이터는
--(사번이 7788보다 작은 직원) ename컬럼을 ename || '_modify'로 업데이트 한다.

/*
MERGE INTO 테이블명
USING 머지대상 테이블 | VIEW | SUBQUREY
ON (테이블명과 머지대상의 연결관계)
WHEN MATCHED THEN
    UPDATE .....
WHEN NOT MATCHED THEN
    INSERT .....
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

-- emp_test 테이블에 사번이 9999인 데이터가 존재하면
-- ename을 'brown'으로 UPDATE
-- 존재하지 않을경우 empno, ename VALUES (9999, 'brown')으로 INSERT
-- 위의 시나리오를 MERGE구문을 활용하여 한번의 SQL로 구현
-- :empno - 9999, :ename - 'brown'
MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (:empno, :ename);
    
SELECT *
FROM emp_test
WHERE empno = 9999;

--만약 MERGE 구문이 없다면 (** 2번의 SQL이 필요)
--1. empno = 9999 인 데이터가 존재하는지 확인
--2-1. 1번 사항에서 데이터가 존재하면 UPDATE
--2-2. 1번 사항에서 데이터가 존재하지 않으면 INSERT


--report group function
--GROUP_AD1
SELECT *
FROM emp;

SELECT *
FROM 
    (SELECT deptno, SUM(sal) sal
    FROM emp
    GROUP BY deptno) a
UNION
SELECT null, SUM(sal)
FROM emp;

--부서별 급여 합
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
UNION ALL 
--전체 직원의 급여합
SELECT NULL, SUM(sal)
FROM emp;

--ref--
--group function
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*) 
FROM emp;
--

--GROUP_AD1
--JOIN 방식으로 풀이
--emp 테이블의 14건 데이터를 28건으로 생성
-- 구분자 (1-14, 2-14)를 기준으로 GROUP BY
-- 구분자 1 : 부서번호 기분으로 14
-- 구분자 2 : 전체 14 row
SELECT DECODE(b.rn, 1, e.deptno, 2, null) deptno,
        SUM(e.sal) sal
FROM 
    emp e,
    (SELECT ROWNUM rn
    FROM dept
    WHERE ROWNUM <= 2) b
GROUP BY DECODE(b.rn, 1, e.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, e.deptno, 2, null);


SELECT DECODE(b.rn, 1, e.deptno, 2, null) deptno,
        SUM(e.sal) sal
FROM 
    emp e,
    (SELECT LEVEL rn
    FROM dual
    CONNECT BY LEVEL <= 2) b    --계층쿼리
GROUP BY DECODE(b.rn, 1, e.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, e.deptno, 2, null);

(SELECT ROWNUM rn
FROM dept
WHERE ROWNUM <= 2);


-----------------------------------------------------
--REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP(col1, ....)
--ROLLUP절에 기술된 컬럼을 오른쪽에서 부터 지원 결과로
--SUB GROUP을 생성하여 여러개의 GROUP BY절을 하나의 SQL에서 실행되도록 한다.
GROUP BY ROLLUP(job, deptno)
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY --> 전체 행을 대상으로 GROUP BY

--emp테이브을 이용하여 부서번호별, 전체직원별 급여합을 구하는 쿼리를
--ROLLUP 기능을 이용하여 작성
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

-- emp 테이블을 이용하여 job, deptno 별 sal + comm 합계
--                   job별 sal + comm 합계
--                  전체직원의 sal + comm 합계
-- ROLLUP 을 활용하여 작성
SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY --> 전체 ROW 대성
-- 주의점!
-- ROLLUP은 컬럼순서가 조회 결과에 영향을 미친다. --** SQL 자격증 시험에 자주 나온다 **--

GROUP BY ROLLUP (deptno, job);
-- GROUP BY deptno, job
-- GROUP BY deptno
-- GROUP BY --> 전체 ROW 대성

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);


SELECT *
FROM emp;

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2
SELECT NVL(job, '총계') job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GRUOPING 사용
SELECT DECODE(GROUPING (job), 1, '총계', 0, job) job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2 - 1
SELECT DECODE(GROUPING (job), 1, '총', 0, job) job,
    DECODE(GROUPING (deptno), 1, '소계', 0, deptno) deptno,
    SUM(sal + NVL(comm,0)) sal_sum,
    GROUPING (job),
    GROUPING (deptno)
FROM emp
GROUP BY ROLLUP (job, deptno);

--CASE 문 사용(GROUP_AD2 - 1)
SELECT job, deptno, DECODE(GROUPING (job), 1, '총', 0, job) job,
    CASE 
        WHEN deptno IS NULL AND job IS NULL THEN '계'
        WHEN deptno IS NULL AND job IS NOT NULL THEN '소계'
        ELSE '' || deptno -- inconsistent datatype : expect CHAR got NUMBER >> deptno 만 작성했을때
        --ELSE TO_
        CHAR(deptno)  -- 또는
    END,
    DECODE(GROUPING (deptno), 1, '소계', 0, deptno) deptno,
    SUM(sal + NVL(comm,0)) sal_sum,
    GROUPING (job),
    GROUPING (deptno)
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD3
SELECT deptno, job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (deptno, job);

--GROUP_AD3
--UNION ALL로 치환
SELECT deptno, job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY deptno, job
UNION ALL
SELECT deptno, NULL, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL, NULL, SUM(sal + NVL(comm,0)) sal_sum
FROM emp;


--GROUP_AD4
--DB쌤 답
SELECT dept.dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job,
            SUM(sal + NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP(deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);
--DB쌤 답

SELECT d.dname, e.job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

SELECT *
FROM dept;

--GROUP_AD5

SELECT NVL(dept.dname, '총계') dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job,
            SUM(sal + NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP(deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);

SELECT 
    CASE 
        WHEN d.dname IS NULL THEN '총계'
        ELSE TO_CHAR(d.dname)
    END dname,
    e.job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;





