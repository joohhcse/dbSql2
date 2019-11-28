



--����
-- SALES --> MARKET SALES
-- �� 6���� ������ ������ �ʿ��ϴ�
-- ���� �ߺ��� �ִ� ����(�� ������)
--UPDATE emp SET dname = 'MARKET SALES'
--WHERE dname = 'SALES';
--����

--emp ���̺�, dept ���̺� ����
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  -- sql ������ �Ʒ��� ������� �ؼ����ص� ��
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
WHERE emp.deptno = dept.deptno  -- sql ������ �Ʒ��� ������� �ؼ����ص� ��
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

--natural join : ���� ���̺� ���� Ÿ��, ���� �̸��� �÷�����
--                ���� ���� ���� ��� ����
DESC emp;
DESC dept;
--ALTER TABLE emp DROP COLUMN dname;



--ANSI SQL
SELECT deptno, emp.empno, ename     --deptno : JOIN�Ǵ� �÷��� �׳� �ۼ�(xxx. �Ⱥ���)
FROM emp NATURAL JOIN dept;

--Oracle ����
SELECT emp.deptno, empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--JOIN USING
--JOIN �Ϸ����ϴ� ���̺� ������ �̸��� �÷��� �ΰ� �̻��� ��
--JOIN �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN with ON 
--���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ� ��
--�����ڰ� ���� ������ ���� ������ ��
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : ���� ���̺� �� ����
--emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
--������ ������ ������ ��ȸ
--�����̸� , �������̸�
--drill : spread�� �׷��� ���غ���
--ANSI
--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--ORACLE
SELECT e.ename, m.ename     --3rd �ؼ�
FROM emp e, emp m           --1st �ؼ�
WHERE e.mgr = m.empno;      --2nd �ؼ�

--Drill > Ʈ������
--1.�����̸�, 2.������ ������ �̸�, 3.������ �����ڰ� ������ �̸�
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

--1.�����̸�, 2.������ ������ �̸�, 3.������ �����ڰ� ������ �̸�, 4.������ �������� �������� �̸�
SELECT e.ename, m.ename, p.ename, l.ename
FROM emp e, emp m, emp p, emp l
WHERE e.mgr = m.empno
AND m.mgr = p.empno
AND p.mgr = l.empno;

--�������̺��� ANSI JOIN�� �̿��� JOIN
--1.�����̸�, 2.������ ������ �̸�, 3.������ �����ڰ� ������ �̸�
--1.�����̸�, 2.������ ������ �̸�, 3.������ �����ڰ� ������ �̸�, 4.������ �������� �������� �̸�
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
    JOIN emp t ON ( m.mgr = t.empno)
    JOIN emp k ON ( t.mgr = k.empno);

--������ �̸���, �ش� ������ ������ �̸��� ��ȸ�Ѵ�.
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ
SELECT s.ename, m.ename
FROM emp s, emp m
WHERE s.empno BETWEEN 7369 AND 7698
AND s.mgr = m.empno;

--ANSI
SELECT s.ename, m.ename
FROM emp s JOIN emp m ON( s.mgr = m.empno )
WHERE s.empno BETWEEN 7369 AND 7698;

--NON-EQUI JOIN : ���� ������ =(equal)�� �ƴ� JOIN
-- != , BETWEEN AND
SELECT *
FROM salgrade;

SELECT empno, ename, sal /* �޿� grade*/
FROM emp;

--Oracle >>
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

--ANSI >>
SELECT empno, ename, sal, grade, emp.sal
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--�����Ͱ��� �ǽ�
--join0
SELECT e.empno, e.ename, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

-- �μ���ȣ�� 10, 30�� �����͸� ��ȸ
--join0_1
SELECT e.empno, e.ename, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND d.deptno IN(10, 30);

-- �޿��� 2500 �ʰ�
--join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
ORDER BY e.deptno;

-- �޿� 2500 �ʰ�, ����� 7600���� ū ����
--join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno > 7600
ORDER BY e.deptno;

-- �޿� 2500 �ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����
--join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno > 7600
AND d.dname = 'RESEARCH'
ORDER BY e.deptno;





























