
--OUTER JOIN : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� �����ʹ�
--�������� �ϴ� JOIN
--LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
--���̺�1�� ���̺�2�� �����Ҷ� ���ο� �����ϴ��� ���̺�1���� �����ʹ�
--��ȸ�� �ǵ��� �Ѵ�
--���ο� ������ �࿡�� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�� �ȴ�.
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
--�Ϲ����ΰ� �������� �÷��� (+)ǥ��
--(+)ǥ�� : �����Ͱ� �������� �ʴµ� ���;��ϴ� ���̺��� �÷�
-- ���� LEFT OUTER JOIN �Ŵ���
--      ON(����.�Ŵ�����ȣ = �Ŵ���.������ȣ)
-- ORACLE OUTER
--WHERE ����.�Ŵ�����ȣ = �Ŵ���.������ȣ(+) --�Ŵ����� �����Ͱ� �������� ����

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);

--ORACLE OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--�Ŵ��� �μ���ȣ ����
--ANSI SQL ON ���� ����� ����
-- --> OUTER ������ ������� �ʴ� ��Ȳ
--**�ƿ��� ������ ����Ǿ�� �ϴ� ���̺��� ��� �÷��� (+)�� �پ�� �ȴ�
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ANSI SQL�� on���� ����� ���� ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

-->Exam
--emp ���̺����� 14���� ������ �ְ�
--14���� 10, 20, 30 �μ��߿� �� �μ��� ���Ѵ�
--������ dept���̺��� 10, 20, 30, 40�� �μ��� ����
--�μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�
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
--inline : deptno, cnt(������ ��)
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

--FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ������� �ѰǸ� �����
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



        
            




            
            
            
            