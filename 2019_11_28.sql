



--참고
-- SALES --> MARKET SALES
-- 총 6건의 데이터 변경이 필요하다
-- 값의 중복이 있는 형태(반 정규형)
--UPDATE emp SET dname = 'MARKET SALES'
--WHERE dname = 'SALES';
--참고

--emp 테이블, dept 테이블 조인
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  -- sql 위에서 아래로 순서대로 해석안해도 됨
AND emp.deptno = 10;

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM deptno;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-----------------------------------------------------------------------------
--| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
--|   0 | SELECT STATEMENT   |      |    14 |   588 |     5  (20)| 00:00:01 |
--|*  1 |  HASH JOIN         |      |    14 |   588 |     5  (20)| 00:00:01 |
--|   2 |   TABLE ACCESS FULL| DEPT |     4 |    88 |     2   (0)| 00:00:01 |
--|   3 |   TABLE ACCESS FULL| EMP  |    14 |   280 |     2   (0)| 00:00:01 |
-----------------------------------------------------------------------------
-- 2-3-1-0

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  -- sql 위에서 아래로 순서대로 해석안해도 됨
AND emp.deptno = 10;

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno  -- 
AND emp.deptno = 10;

SELECT ename, job, deptno
FROM emp;

SELECT *
FROM dept;

-----------------------------------------------

--natural join : 조인 테이블간 같은 타입, 같은 이름의 컬럼으로
--                같은 값을 갖을 경우 조인
DESC emp;
DESC dept;
--ALTER TABLE emp DROP COLUMN dname;



--ANSI SQL
SELECT deptno, emp.empno, ename     --deptno : JOIN되는 컬럼은 그냥 작성(xxx. 안붙임)
FROM emp NATURAL JOIN dept;

--Oracle 문법
SELECT emp.deptno, empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--JOIN USING
--JOIN 하려고하는 테이블간 동일한 이름의 컬럼이 두개 이상일 때
--JOIN 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN with ON 
--조인 하고자 하는 테이블의 컬럼 이름이 다를 때
--개발자가 조인 조건을 직접 제어할 때
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : 같은 테이블 간 조인
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원의 관리자 정보를 조회
--직원이름 , 관리자이름
--drill : spread에 그려서 비교해보기
--ANSI
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--ORACLE
SELECT e.ename, m.ename     --3rd 해석
FROM emp e, emp m           --1st 해석
WHERE e.mgr = m.empno;      --2nd 해석

--Drill > 트리구조
--1.직원이름, 2.직원의 관리자 이름, 3.직원의 관리자가 관리자 이름
--MILLER CLARK KING
SELECT e.ename, m.ename, p.ename 
FROM emp e, emp m, emp p
WHERE e.mgr = m.empno
AND m.mgr = p.empno;

-->>>Solution
SELECT e.ename, m.ename, t.ename 
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;

--1.직원이름, 2.직원의 관리자 이름, 3.직원의 관리자가 관리자 이름, 4.직원의 관리자의 관리자의 이름
SELECT e.ename, m.ename, p.ename, l.ename
FROM emp e, emp m, emp p, emp l
WHERE e.mgr = m.empno
AND m.mgr = p.empno
AND p.mgr = l.empno;

--여러테이블을 ANSI JOIN을 이용한 JOIN
--1.직원이름, 2.직원의 관리자 이름, 3.직원의 관리자가 관리자 이름
--1.직원이름, 2.직원의 관리자 이름, 3.직원의 관리자가 관리자 이름, 4.직원의 관리자의 관리자의 이름
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
    JOIN emp t ON ( m.mgr = t.empno)
    JOIN emp k ON ( t.mgr = k.empno);

--직원의 이름과, 해당 직원의 관리자 이름을 조회한다.
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회
SELECT s.ename, m.ename
FROM emp s, emp m
WHERE s.empno BETWEEN 7369 AND 7698
AND s.mgr = m.empno;

--ANSI
SELECT s.ename, m.ename
FROM emp s JOIN emp m ON( s.mgr = m.empno )
WHERE s.empno BETWEEN 7369 AND 7698;

--NON-EQUI JOIN : 조인 조건이 =(equal)이 아닌 JOIN
-- != , BETWEEN AND
SELECT *
FROM salgrade;

SELECT empno, ename, sal /* 급여 grade*/
FROM emp;

--Oracle >>
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

--ANSI >>
SELECT empno, ename, sal, grade, emp.sal
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--데이터결합 실습
--join0
SELECT e.empno, e.ename, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

-- 부서번호가 10, 30인 데이터만 조회
--join0_1
SELECT e.empno, e.ename, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND d.deptno IN(10, 30);

-- 급여가 2500 초과
--join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
ORDER BY e.deptno;

-- 급여 2500 초과, 사번이 7600보다 큰 직원
--join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno > 7600
ORDER BY e.deptno;

-- 급여 2500 초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원
--join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno > 7600
AND d.dname = 'RESEARCH'
ORDER BY e.deptno;





























