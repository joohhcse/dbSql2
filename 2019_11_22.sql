

--
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE deptno <> 10 --<>, !=
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

--�̻�, ����, �ʰ�, �̸�

--where9
SELECT *
FROM emp
WHERE deptno NOT IN (10) 
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

--where10 (NOT IN ������ ������, IN �����ڸ� ��밡��)
--deptno �÷��� ���� 10, 20, 30�� �����Ѵ�
SELECT *
FROM emp
WHERE deptno IN (20, 30)        --20, 30
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

--where11
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate > TO_DATE('19810601', 'YYYYMMDD');

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

--where13(LIKE���� ������� ����)
--�������� : EMPNO�� ���ڿ����Ѵ�(DESC emp.empno NUMBER)
DESC emp;
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR 7800 <= empno AND empno <= 7899;


-- ������ �켱���� (AND > OR)
--���� �̸��� SMITH�̰ų�, �����̸��� ALLEN�̸鼭 ������ SALESMAN�� ����
SELECT *
FROM emp
WHERE enmae = 'SMITH'
OR ename = 'ALLEN'
AND job = 'SALESMAN';


SELECT *
FROM emp
WHERE ename = 'SMITH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');


--�����̸��� SMITH�̰ų� ALLEN �̸鼭 ������ SALESMAN�� ���
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') 
AND job = 'SALESMAN';

--where14
--job�� SALESMAN �̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981��6��1�� ������ ������ ������ ��ȸ
--SELECT *
--FROM emp
--WHERE job = 'SALESMAN' 
--OR (empno LIKE '78%'
--AND hiredate > TO_DATE('19810601','YYYYMMDD'));

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR (empno BETWEEN 7800 AND 7899
AND hiredate > TO_DATE('19810601','YYYYMMDD'));

--������ ����
--10,5,3,2,1
--
--�������� : 1,2,3,5,10
--�������� : 10,5,3,2,1
--
--�������� : ASC (ǥ�� ���Ұ�� default)
--�������� : DESC (���������� �ݵ�� ǥ��)

/*
SELECT col1, col2, .....
FROM ���̺��
WHERE col1 = '��'
ORDER BY ���ı����÷�1 [ASC / DESC], ���ı����÷�2.... [ASC / DESC]
*/

--���(emp) ���̺��� ������ ������ �����̸�(ename)���� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC; --���ı����� �ۼ����� ���� ��� �������� ����

--���(emp) ���̺��� ������ ������ �����̸�(ename)���� �������� ����
SELECT *
FROM emp
ORDER BY ename DESC;

--���(emp) ���̺��� ������ ������ �μ���ȣ()���� ��������(ASC) �����ϰ�
--�μ���ȣ�� ���� ���� sal ��������(DESC) ����
--�޿�(sal)�� �������� �̸����� ��������(ASC) �����Ѵ�.
SELECT *
FROM emp
ORDER BY deptno, sal DESC, ename ;

--���� �÷��� ALIAS�� ǥ��
SELECT deptno, sal, ename nm 
FROM emp
ORDER BY nm;

--��ȸ�ϴ� �÷��� ��ġ �ε����� ǥ�� ����
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; --��õ ������ ����(�÷� �߰��� �ǵ����� ���� ����� ���� �� ����)

--orderb1
--dept���̺��� ��� ������ �μ��̸����� ������������
SELECT *
FROM dept
ORDER BY dname;

--dept���̺��� ��� ������ �μ���ġ�� ��������
SELECT *
FROM dept
ORDER BY loc DESC;

--orderby2
--emp ���̺��� �������� �ִ� ����鸸 ��ȸ
--�󿩸� ���� �޴� ����� ���� ��ȸ�ǵ���(DESC)
--�� ������������� ��������(ASC)
SELECT *
FROM emp
WHERE comm IS NOT NULL
AND comm != 0
ORDER BY comm DESC, empno;


--orderby3
--emp ���̺��� �����ڰ� �ִ� ������ ��ȸ�ϰ� mgr NULL�� �ƴ� ������
--����(job)������ �������� ����
--������ ���� ��� �����ȣ�� ū����� ���� ��ȸ �ǵ���
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

--orderby4
--emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� �����
--�޿�(sal)�� 1500�Ѵ� ����鸸 ��ȸ
--�̸����� ��������DESC ���ĵǵ��� 
SELECT *
FROM emp
WHERE deptno IN(10, 30) --(deptno = 10 OR dept = 30)
AND sal > 1500
ORDER BY ename DESC;


--ROWNUM
SELECT ROWNUM, empno, ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2;   --ROWNUM = equal �񱳴� 1�� ����

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 2;   -- <= (<) ROWNUM�� 1���� ���������� ��ȸ�ϴ� ���� ����

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20;  -- 1���� �����ϴ� ��� ����

--SELECT ���� ORDER BY ������ �������
--SELECT -> ROWNUM -> ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--INLINE VIEW �� ���� ���� ���� �����ϰ�, �ش� ����� ROWNUM�� ����
-- SELECT ���� * ����ϰ�, �ٸ� �÷�|ǥ������ ���� ��� 
-- *�տ� ���̺���̳�, ���̺� ��Ī�� ����
SELECT ROWNUM, a.*                    --empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a;

SELECT ROWNUM, e.*
FROM emp e;


--row_1
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 10;

------------------------------------------
------------------------------------------
------------------------------------------
--row_2 --HINT : alias, inline-view
-- (ROWNUM�� 11~14�� ������)
SELECT e.*
FROM 
(SELECT ROWNUM rn, empno, ename
FROM emp) e
WHERE rn BETWEEN 11 AND 20;
------------------------------------------
------------------------------------------
------------------------------------------

--row_3
--emp���̺��� ename���� ������ ����� 11��°��� 14��°�ุ ��ȸ�ϴ� ������
--�ۼ��غ�����(empno, ename �÷��� ���ȣ�� ��ȸ)
SELECT e.*
FROM 
(SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename) e
WHERE rn BETWEEN 11 AND 20;

--row_3
--emp���̺��� ��������� �̸� ���������� ���� ���� ���� 11~14��°����
--������ ���� ��ȸ�ϴ� ������ �ۼ��غ�����
SELECT ROWNUM, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename) e;
--WHERE rn BETWEEN 11 AND 14;


--row_3
------------------------------------------
--My Query--------------------------------
------------------------------------------
SELECT e.rn, empno, ename
FROM
    (SELECT ROWNUM rn, empno, ename
     FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename)) e
WHERE rn BETWEEN 11 AND 14;
------------------------------------------
------------------------------------------
------------------------------------------























