
SELECT *
FROM emp_test
ORDER BY empno;

--emp���̺� �����ϴ� �����͸� emp_test ���̺�� ����
--���� empno�� ������ �����Ͱ� �����ϸ�
--ename update : ename || '_merge'
--���� empno�� ������ �����Ͱ� �������� ���� ���
--emp���̺��� empno, ename emp_test �����ͷ� insert

--emp_test �����Ϳ��� ������ �����͸� ����
DELETE emp_test
WHERE empno >= 7788;
COMMIT;

--emp ���̺��� 14���� �����Ͱ� ����
--emp_test ���̺��� ����� 7788���� ����7���� �����Ͱ� ����
--emp���̺��� �̿��Ͽ� emp_test ���̺��� �����ϰ� �Ǹ�
--emp���̺��� �����ϴ� ����(����� 7788���� ũ�ų� ����) 7��
--emp_test �� ���Ӱ� insert�� �� ���̰�
--emp, emp_test�� �����ȣ�� �����ϰ� �����ϴ� 7���� �����ʹ�
--(����� 7788���� ���� ����) ename�÷��� ename || '_modify'�� ������Ʈ �Ѵ�.

/*
MERGE INTO ���̺��
USING ������� ���̺� | VIEW | SUBQUREY
ON (���̺��� ��������� �������)
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

-- emp_test ���̺� ����� 9999�� �����Ͱ� �����ϸ�
-- ename�� 'brown'���� UPDATE
-- �������� ������� empno, ename VALUES (9999, 'brown')���� INSERT
-- ���� �ó������� MERGE������ Ȱ���Ͽ� �ѹ��� SQL�� ����
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

--���� MERGE ������ ���ٸ� (** 2���� SQL�� �ʿ�)
--1. empno = 9999 �� �����Ͱ� �����ϴ��� Ȯ��
--2-1. 1�� ���׿��� �����Ͱ� �����ϸ� UPDATE
--2-2. 1�� ���׿��� �����Ͱ� �������� ������ INSERT


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

--�μ��� �޿� ��
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
UNION ALL 
--��ü ������ �޿���
SELECT NULL, SUM(sal)
FROM emp;

--ref--
--group function
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*) 
FROM emp;
--

--GROUP_AD1
--JOIN ������� Ǯ��
--emp ���̺��� 14�� �����͸� 28������ ����
-- ������ (1-14, 2-14)�� �������� GROUP BY
-- ������ 1 : �μ���ȣ ������� 14
-- ������ 2 : ��ü 14 row
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
    CONNECT BY LEVEL <= 2) b    --��������
GROUP BY DECODE(b.rn, 1, e.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, e.deptno, 2, null);

(SELECT ROWNUM rn
FROM dept
WHERE ROWNUM <= 2);


-----------------------------------------------------
--REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP(col1, ....)
--ROLLUP���� ����� �÷��� �����ʿ��� ���� ���� �����
--SUB GROUP�� �����Ͽ� �������� GROUP BY���� �ϳ��� SQL���� ����ǵ��� �Ѵ�.
GROUP BY ROLLUP(job, deptno)
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY --> ��ü ���� ������� GROUP BY

--emp���̺��� �̿��Ͽ� �μ���ȣ��, ��ü������ �޿����� ���ϴ� ������
--ROLLUP ����� �̿��Ͽ� �ۼ�
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

-- emp ���̺��� �̿��Ͽ� job, deptno �� sal + comm �հ�
--                   job�� sal + comm �հ�
--                  ��ü������ sal + comm �հ�
-- ROLLUP �� Ȱ���Ͽ� �ۼ�
SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY --> ��ü ROW �뼺
-- ������!
-- ROLLUP�� �÷������� ��ȸ ����� ������ ��ģ��. --** SQL �ڰ��� ���迡 ���� ���´� **--

GROUP BY ROLLUP (deptno, job);
-- GROUP BY deptno, job
-- GROUP BY deptno
-- GROUP BY --> ��ü ROW �뼺

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);


SELECT *
FROM emp;

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2
SELECT NVL(job, '�Ѱ�') job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GRUOPING ���
SELECT DECODE(GROUPING (job), 1, '�Ѱ�', 0, job) job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP_AD2 - 1
SELECT DECODE(GROUPING (job), 1, '��', 0, job) job,
    DECODE(GROUPING (deptno), 1, '�Ұ�', 0, deptno) deptno,
    SUM(sal + NVL(comm,0)) sal_sum,
    GROUPING (job),
    GROUPING (deptno)
FROM emp
GROUP BY ROLLUP (job, deptno);

--CASE �� ���(GROUP_AD2 - 1)
SELECT job, deptno, DECODE(GROUPING (job), 1, '��', 0, job) job,
    CASE 
        WHEN deptno IS NULL AND job IS NULL THEN '��'
        WHEN deptno IS NULL AND job IS NOT NULL THEN '�Ұ�'
        ELSE '' || deptno -- inconsistent datatype : expect CHAR got NUMBER >> deptno �� �ۼ�������
        --ELSE TO_
        CHAR(deptno)  -- �Ǵ�
    END,
    DECODE(GROUPING (deptno), 1, '�Ұ�', 0, deptno) deptno,
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
--UNION ALL�� ġȯ
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
--DB�� ��
SELECT dept.dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job,
            SUM(sal + NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP(deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);
--DB�� ��

SELECT d.dname, e.job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

SELECT *
FROM dept;

--GROUP_AD5

SELECT NVL(dept.dname, '�Ѱ�') dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job,
            SUM(sal + NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP(deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);

SELECT 
    CASE 
        WHEN d.dname IS NULL THEN '�Ѱ�'
        ELSE TO_CHAR(d.dname)
    END dname,
    e.job, SUM(sal + NVL(comm,0)) sal_sum
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;





