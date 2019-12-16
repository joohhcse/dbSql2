



--GROUPING SETS(col1, col2)
-- ��������� ����
-- �����ڰ� GROUP BY�� ������ ���� ����Ѵ�.
-- ROLLUP�� �޸� ���⼺�� ���� �ʴ´� 
-- GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- emp ���̺��� ������ job�� �޿�(sal) + ��(comm) ��,
--                   deptno(�μ�)�� �޿�(sal) + ��(comm) �� ���ϱ�
-- ���� ���(GROUP FUNCTION) : 2 ���� SQL �ۼ� �ʿ�(UNION / UNION ALL)
SELECT job, NULL deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL
SELECT '', deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

-- GROUPING SETS ������ �̿��Ͽ� ���� SQL�� ���տ����� ������� �ʰ�
-- ���̺��� �ѹ� �о ó��
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno);

-- job, deptno�� �׷����� �� sal+comm ��
-- mgr�� �׷����� �� sal + comm ��
-- GROUP BY job, deptno
-- UNION ALL
-- GORUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

-- CUBE (col1, col2, ...)
-- ������ �÷��� ��� ������ �������� GROUP BY subset �� �����
-- CUBE�� ������ �÷��� 2���� ��� : ������ ���� 4��
-- CUBE�� ������ �÷��� 3���� ��� : ������ ���� 8��
-- CUBE�� ������ �÷����� 2�� ���� �� ����� ������ ���� ������ �ȴ�. (2^n)
-- �÷��� ���ݸ� �������� ������ ������ ���ϱ޼������� �þ� ���� ������ ���� ��������� �ʴ´�...

--job, deptno�� �̿��Ͽ� CUBE ����
--NULL	            NULL	        31225      --GROUP BY ��ü��
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

--job, deptno�� �̿��Ͽ� CUBE ����
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY CUBE(job, deptno);

--job, deptno
--1,   1,   --> GROUP BY job, deptno
--1,   0,   --> GROUP BY job
--0,   1,   --> GROUP BY deptno
--0,   0,   --> GROUP BY --emp ���̺��� ����࿡ ���� GROUP BY

--GROUP BY ����
--GROUP BY, ROLLUP, CUBE�� ���� ����ϱ�
--������ ������ �����غ��� ���� ����� ������ �� �ִ�.
--GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

--sub_a1
-- subquery�� �̿��Ͽ� dept_test ���̺��� empcnt �÷��� �ش� �μ��� ���� UPDATE �ϴ� ������ �ۼ��ϼ���
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

--DB�� ��
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno);
                                
--10	ACCOUNTING	NEW YORK	3
--20	RESEARCH	DALLAS	5
--30	SALES	CHICAGO	6
--40	OPERATIONS	BOSTON	0

DROP TABLE dept_test;

--sub_a1
-- emp ���̺��� �������� ������ �ʴ� �μ� ���� �����ϴ� ������ ���������� �̿��Ͽ� �ۼ��ϼ���
-- ��ü deptno : 10, 20, 30, 40, 98, 99
-- ���� deptno : 40, 98, 99
CREATE TABLE dept_test AS
SELECT *
FROM dept;
INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES(98, 'it2', 'daejeon');

SELECT *
FROM dept_test;

DELETE dept_test WHERE dept_test.deptno NOT IN(10, 20, 30); --�ϵ��ڵ� HardCoding

DELETE dept_test WHERE dept_test.deptno NOT IN(10, 20, 30);

-->DB�� ��
DELETE dept_test WHERE dept_test.deptno NOT IN(SELECT deptno
                                                FROM emp);

--sub_a3
--subquery�� �̿��Ͽ� emp_test ���̺��� ������ ���� �μ���(sal) ��� �޿����� 
--�޿��� ���� ������ �޿��� �� �޿����� 200�� �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ��ϼ���
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
                        
--DB �� ��
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
--DB �� ��--



--MERGE ������ �̿��� ������Ʈ >>> ON ���� ���� �÷����� ������Ʈ �Ҽ�����
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
        FROM emp_test
        GROUP BY deptno) b
ON ( a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
    WHERE a.sal < b.avg_sal;    --WHERE�� ���⿡ �߰��ؼ� ���� ����(GOOD)
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
--DB �� ��--









