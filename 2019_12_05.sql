


INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

COMMIT;

SELECT *
FROM emp;
SELECT *
FROM dept;

SELECT *
FROM dept
WHERE deptno NOT IN('10', '20', '30');

SELECT d.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno != (SELECT *
                    FROM dept
                    WHERE deptno);

SELECT *
FROM dept
WHERE deptno NOT IN('10', '20', '30');

--Sol>
--직원이 존재하는 부서정보
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                FROM emp);

--직원이 존재하지 않는 부서정보
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
                    
                    
                    
--sub5
--cycle, product 테이블을 이용 
--cid=1인 고객이 애음하지 않는 제품을 조회하는 쿼리 작성
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid=1);
                    
--sub6
--cycle 테이블을 이용하여 cid=2인 고객이 애음하는 제품중 cid=1인
--고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요
SELECT *
FROM cycle
WHERE cid=2;

SELECT cid, pid, day, cnt
FROM cycle
WHERE cid=1
AND pid IN ('100');

-->>
SELECT *
FROM cycle
WHERE cid=1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid=2);

--sub7 ++JOIN : sub6의 결과에서 고객명, 제품명을 추가
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid
AND cy.pid = p.pid
AND c.cid = 1
AND cy.pid IN (SELECT pid
                FROM cycle
                WHERE cid=2);

-->>Sol >> Explain
SELECT *
FROM cycle
WHERE cycle.cid = 1;

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, 
    cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid=2);

--EXIST
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'x'
                FROM emp b
                WHERE b.empno = a.mgr);


--매니저가 존재하는 직원 정보 조회
SELECT *
FROM emp e
WHERE EXISTS (SELECT 1
                FROM emp m
                WHERE m.empno = e.mgr);

--sub8
SELECT *
FROM emp 
WHERE mgr IS NOT NULL;
--sub8
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;

--sub9
SELECT *
FROM product    --1. main query 먼저 읽음
WHERE EXISTS (SELECT 'X'    --2.sub query true/false
                FROM cycle
                WHERE cid = 1
                AND cycle.pid = product.pid); --AND cycle.pid = 100);

--sub10 // cid=1인 고객이 애음하지 않는 제품 조회
SELECT *
FROM product    --1. main query 먼저 읽음
WHERE NOT EXISTS (SELECT 'X'    --2.sub query true/false
                FROM cycle
                WHERE cid = 1
                AND cycle.pid = product.pid); --AND cycle.pid = 100);


--집합연산
--UNION : 합집합, 두 집합의 중복건은 제거한다
--담당업무가 SALESMAN인 직원의 직원번호, 직원 이름 조회
--위아래 결과셋이 동일하기 때문에 합집합 연산을 하게 될경우
--중복되는 데이터는 한번만 표현한다.
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';


--서로 다른 집합의 합집합
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'CLERK';

--UNION ALL
--합집합 연산시 중복 제거를 하지 않는다
--위아래 겨로가 셋을 붙여 주기만 한당
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--집합연산시 집합셋의 컬럼이 동일해야 한다
--컬럼의 개수가 다를경우 임의의 값을 넣는 방식으로 개수를 맞춰준다.

--INTERSECT : 교집합
--두 집합간 공통적인 데이터만 조회
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

INTERSECT

SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK');

--MINUS
--차집합 : 위, 아래 집합의 교집합을 위 집합에서 제거한 집합을 조회
--차집합의 경우 합집합, 교집합과 다르게 집합의 선언 순서가 결과집합에 영향을 준다
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')

MINUS

SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN');

--DML(insert)
--INSERT : 테이블에 새로운 데이터를 입력
--INSERT INTO table[(column [, column ..])]
--
--VALUES(value[, value]);
DESC emp;

SELECT *
FROM dept;
DELETE dept
WHERE deptno = 99;
COMMIT;

--INSERT 시 컬럼을 나열한 경우
--나열한 컬럼에 맞춰 입력할 값을 동일한 순서로 기술한다. 
--INSERT INTO 테이블명 (컬럼1, 컬럼2....)
--            VALUES (값1, 값2....)
--dept 테이블에 99번 부서번호, ddit 조직명, daejeon 지역명을 갖는 데이터 입력
INSERT INTO dept (deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');
ROLLBACK;
SELECT *
FROM dept;

--컬럼을 기술할 경우 테이블의 컬럼 정의 순서와 다르게 나열해도 상관이 없음
--dept 테이블의 컬럼 순서 : deptno, dname, loc
INSERT INTO dept (loc, deptno, dname)
            VALUES ('daejeon', 99, 'ddit');
            
--컬럼을 기술하지 않는 경우 : 테이블의 컬럼 정의 순서에 맞춰 값을 기술한다.
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--날짜 값 입력하기
--1.SYSDATE
--2.사용자로 부터 받은 문자열을 DATE 타입으로 변경하여 입력
DESC emp;
SELECT *
FROM emp;

INSERT INTO emp VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL);

--2019년 12월 2일 입사
INSERT INTO emp VALUES
(9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'),
500, NULL, NULL);

ROLLBACK;

--여러건의 데이터를 한번에 입력
--SELECT 결과를 테이블에 입력 할 수 있다.

INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'),
500, NULL, NULL
FROM dual;

ROLLBACK;












