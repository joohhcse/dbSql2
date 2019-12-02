
--OUTER JOIN : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는
--나오도록 하는 JOIN
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할때 조인에 실패하더라도 테이블1쪽의 데이터는
--조회가 되도록 한다
--조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시 된다.
--

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m
            ON (e.mgr = m.empno);


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);

--
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno )
WHERE m.deptno = 10;


--ORACLE outer join systax
--일반조인과 차이점은 컬럼명에 (+)표시
--(+)표시 : 데이터가 존재하지 않는데 나와야하는 테이블의 컬럼
-- 직원 LEFT OUTER JOIN 매니저
--      ON(직원.매니저번호 = 매니저.직원번호)
-- ORACLE OUTER
--WHERE 직원.매니저번호 = 매니저.직원번호(+) --매니저쪽 데이터가 존재하지 않음

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);

--ORACLE OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--매니저 부서번호 제한
--ANSI SQL ON 절에 기술한 형태
-- --> OUTER 조인이 적용되지 않는 상황
--**아우터 조인이 적용되어야 하는 테이블의 모든 컬럼에 (+)가 붙어야 된다
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ANSI SQL의 on절에 기술한 경우와 동일
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

-->Exam
--emp 테이블에서는 14명의 직원이 있고
--14명은 10, 20, 30 부서중에 한 부서에 속한다
--하지만 dept테이블에는 10, 20, 30, 40번 부서가 존재
--부서번호, 부서명, 해당부서에 속한 지원수가 나오도록 쿼리를 작성
--
/*
10 ACCOUNT      3
20 RESEARCH     5
30 SALES        6
40 OPERATIONS   0
*/
SELECT *
FROM dept;
SELECT *
FROM emp;

SELECT e.deptno, d.dname, COUNT(e.deptno)
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY e.deptno, d.dname;

SELECT NVL(e.deptno, 40) deptno, d.dname, COUNT(e.deptno) cnt
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY e.deptno, d.dname;

-->SOl>
--dept : deptno, dname
--inline : deptno, cnt(직원의 수)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept, 
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

--ANSI (SOL)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM 
dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt
                    FROM emp
                    GROUP BY deptno) emp_cnt
                    ON(dept.deptno = emp_cnt.deptno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);            

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
            ON (e.mgr = m.empno);            

--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복데이터 한건만 남기기
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m
            ON (e.mgr = m.empno);            
            
SELECT *
FROM buyprod bp, prod p
WHERE buy_date = '20050125';

SELECT *
FROM buyprod;    
SELECT *
FROM prod;

--outerjoin1
SELECT bp.buy_date, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id
AND bp.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--ANSI
SELECT bp.buy_date, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp RIGHT OUTER JOIN prod p
ON  (bp.buy_prod = p.prod_id
    AND bp.buy_date = TO_DATE('20050125', 'YYYYMMDD'));


--outerjoin2
SELECT NVL(bp.buy_date, '20050125'), bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id
AND bp.buy_date(+) = '20050125';

--outerjoin3
SELECT NVL(bp.buy_date, '20050125'), bp.buy_prod, p.prod_id, p.prod_name, NVL(bp.buy_qty, 0)
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id
AND bp.buy_date(+) = '20050125';

--outerjoin4
SELECT *
FROM cycle;
SELECT *
FROM product;
SELECT *
FROM customer;

--outerjoin4
SELECT c.pid, p.pnm, NVL(c.cid, 1) cid, NVL(c.day,0) day, NVL(c.cnt,0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1;

--outerjoin5
SELECT c.pid, p.pnm, NVL(c.cid, 1) cid, NVL(cst.cnm, 'brown') cnm, NVL(c.day,0) day, NVL(c.cnt,0) cnt
FROM cycle c, product p, customer cst
WHERE c.pid(+) = p.pid
AND c.cid = cst.cid(+)
AND c.cid(+) = 1;



        
            




            
            
            
            