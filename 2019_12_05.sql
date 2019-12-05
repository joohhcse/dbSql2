


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
--������ �����ϴ� �μ�����
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                FROM emp);

--������ �������� �ʴ� �μ�����
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
                    
                    
                    
--sub5
--cycle, product ���̺��� �̿� 
--cid=1�� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ� ���� �ۼ�
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
--cycle ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ�� cid=1��
--���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���
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

--sub7 ++JOIN : sub6�� ������� ����, ��ǰ���� �߰�
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


--�Ŵ����� �����ϴ� ���� ���� ��ȸ
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
FROM product    --1. main query ���� ����
WHERE EXISTS (SELECT 'X'    --2.sub query true/false
                FROM cycle
                WHERE cid = 1
                AND cycle.pid = product.pid); --AND cycle.pid = 100);

--sub10 // cid=1�� ���� �������� �ʴ� ��ǰ ��ȸ
SELECT *
FROM product    --1. main query ���� ����
WHERE NOT EXISTS (SELECT 'X'    --2.sub query true/false
                FROM cycle
                WHERE cid = 1
                AND cycle.pid = product.pid); --AND cycle.pid = 100);


--���տ���
--UNION : ������, �� ������ �ߺ����� �����Ѵ�
--�������� SALESMAN�� ������ ������ȣ, ���� �̸� ��ȸ
--���Ʒ� ������� �����ϱ� ������ ������ ������ �ϰ� �ɰ��
--�ߺ��Ǵ� �����ʹ� �ѹ��� ǥ���Ѵ�.
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';


--���� �ٸ� ������ ������
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'CLERK';

--UNION ALL
--������ ����� �ߺ� ���Ÿ� ���� �ʴ´�
--���Ʒ� �ܷΰ� ���� �ٿ� �ֱ⸸ �Ѵ�
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--���տ���� ���ռ��� �÷��� �����ؾ� �Ѵ�
--�÷��� ������ �ٸ���� ������ ���� �ִ� ������� ������ �����ش�.

--INTERSECT : ������
--�� ���հ� �������� �����͸� ��ȸ
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

INTERSECT

SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK');

--MINUS
--������ : ��, �Ʒ� ������ �������� �� ���տ��� ������ ������ ��ȸ
--�������� ��� ������, �����հ� �ٸ��� ������ ���� ������ ������տ� ������ �ش�
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')

MINUS

SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN');

--DML(insert)
--INSERT : ���̺� ���ο� �����͸� �Է�
--INSERT INTO table[(column [, column ..])]
--
--VALUES(value[, value]);
DESC emp;

SELECT *
FROM dept;
DELETE dept
WHERE deptno = 99;
COMMIT;

--INSERT �� �÷��� ������ ���
--������ �÷��� ���� �Է��� ���� ������ ������ ����Ѵ�. 
--INSERT INTO ���̺�� (�÷�1, �÷�2....)
--            VALUES (��1, ��2....)
--dept ���̺� 99�� �μ���ȣ, ddit ������, daejeon �������� ���� ������ �Է�
INSERT INTO dept (deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');
ROLLBACK;
SELECT *
FROM dept;

--�÷��� ����� ��� ���̺��� �÷� ���� ������ �ٸ��� �����ص� ����� ����
--dept ���̺��� �÷� ���� : deptno, dname, loc
INSERT INTO dept (loc, deptno, dname)
            VALUES ('daejeon', 99, 'ddit');
            
--�÷��� ������� �ʴ� ��� : ���̺��� �÷� ���� ������ ���� ���� ����Ѵ�.
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--��¥ �� �Է��ϱ�
--1.SYSDATE
--2.����ڷ� ���� ���� ���ڿ��� DATE Ÿ������ �����Ͽ� �Է�
DESC emp;
SELECT *
FROM emp;

INSERT INTO emp VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL);

--2019�� 12�� 2�� �Ի�
INSERT INTO emp VALUES
(9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'),
500, NULL, NULL);

ROLLBACK;

--�������� �����͸� �ѹ��� �Է�
--SELECT ����� ���̺� �Է� �� �� �ִ�.

INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'),
500, NULL, NULL
FROM dual;

ROLLBACK;












