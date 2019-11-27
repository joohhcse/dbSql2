

--��¥���� �Լ�
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : �ش� ��¥�� ���� ���� ������ ����(DATE)

--�� : 1,3,5,7,8,10,12 : 31��
--  : 2 -���� ���� 28, 29
--  : 4,6,9,11 : 30��

SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;

--fn3 '201912' --> date Ÿ������ �����ϱ�
--�ش� ��¥�� ������ ��¥�� �̵�
--�����ʵ常 ����
--DATE --> �����÷�(DD)�� ����
--DATE --> ���ڿ�(DD)
--TO_CHAR(DATE, '����')
--DATE : LAST_DAY(TO_DATE('201912', 'YYYYMM'))
--���� : 'DD'

SELECT TO_DATE('201912', 'YYYYMM')  --2019/12/01
FROM dual;

SELECT LAST_DAY(TO_DATE('201912', 'YYYYMM'))
FROM dual;

--fn3
SELECT '201912' PARAM, TO_CHAR( LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD' ) DT
FROM dual;

-- :yyyymm 
SELECT :yyyymm param, 
    TO_CHAR( LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD' ) DT
FROM dual;

--SYSDATE�� YYYY/MM/DD ������ ���ڿ��� ���� (DATE -> CHAR)
--'2019/11/26' ���ڿ� --> DATE
-- ���ڿ� : TO_CHAR(SYSDATE, 'YYYY/MM/DD')
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD'),
        --YYYY-MM-DD HH24:MI:SS ���ڿ��� ����
        TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'),
        'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--EMPNO    NOT NULL NUMBER(4)
--HIREDATE          DATE
DESC emp;

--empno�� 7369�� ���� ���� ��ȸ�ϱ�
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


--Plan hash value: 3956160932
----------------------------------------------------------------------------
--| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
--|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
--|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------
--Predicate Information (identified by operation id):
-----------------------------------------------------
--   1 - filter("EMPNO"=7369)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369 + '69';

SELECT *
FROM TABLE(dbms_xplan.display);


SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATEŸ���� ������ ����ȯ�� ����� ������ ����
--YY -> 19
--RR -> 50 / 19, 20
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('81/06/01', 'RRRR/MM/DD');      --
--WHERE hiredate >= '81/06/01';      


SELECT TO_DATE('50/05/05', 'RR/MM/DD'),
    TO_DATE('49/05/05', 'RR/MM/DD')
FROM dual;


SELECT TO_DATE('50/05/05', 'RR/MM/DD'),
    TO_DATE('49/05/05', 'RR/MM/DD')
FROM dual;

--���� --> ���ڿ�
--���ڿ� --> ����
--���� : 1000000 --> 1,000,000.00 (�ѱ�)
--���� : 1000000 --> 1.000.000,00 (����)
--��¥ ���� : YYYY, MM, DD, HH24, MI, SS
--���� ���� : ���� ǥ�� : 9, �ڸ������� ���� 0ǥ�� : 0, ȭ����� : L
--          1000�ڸ� ���� : , �Ҽ��� : .
--���� -> ���ڿ� TO_CHAR(����, '����')
--���� ���� �������� ���� �ڸ����� ����� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999') fm_sal
FROM emp;

--NULL ó�� �Լ� : NVL, NVL2, NULLIF, COALESCE

--NVL(exprl, expr2) : �Լ� ���� �ΰ�
--expr1�� NULL�̸� expr2�� ��ȯ
--expr1�� NULL�� �ƴϸ� expr1 �� ��ȯ
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--study test
SELECT empno, comm, nvl2(comm, /*NOT NULL*/ 000000, /*NULL*/ 999999) nvl_test
FROM emp;

--NVL2(expr1, expr2, expr3)
--expr1 IS NOT NULL expr2 ����
--expr1 IS NULL expr3 ����
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL�� ����
--expr1 != expr2 expr1�� ����
--comm�� NULL�϶� comm+500 : NULL
--  NULLIF(NULL, NULL) : NULL
--comm�� NULL�� �ƴҶ� comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

--COALESCE(expr1, expr2, expr3......)
--�����߿� ù��°�� �����ϴ� NULL�� �ƴ� exprN�� ����
--expr1 IS NOT NULL epxr1�� �����ϰ�
--expr1 IS NULL COALESCE(expr2, expr3.....)
SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal_sal
FROM emp;

--null �ǽ�
--fn4
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, 
    NVL2(mgr, mgr, 9999) mgr_n_1, 
    COALESCE(mgr, 9999) mgr_n_2
FROM emp;

--fn5
SELECT *
FROM users;

SELECT userid, usernm, reg_dt, n_reg_dt
FROM
(SELECT ROWNUM e, userid, usernm, reg_dt, COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users)
WHERE e BETWEEN 2 AND 5;

-->fn5 > Sol
SELECT userid, usernm, reg_dt, COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid NOT IN ('brown');

SELECT *
FROM users;

DESC users;

--condition
--case
--emp.job �÷��� ��������
-- 'SALESMAN'�̸� sal * 1.05�� ������ �� ����
-- 'MANAGER'�̸� sal * 1.10�� ������ �� ����
-- 'PRESIDENT'�̸� sal * 1.20�� ������ �� ����
-- �� 3���� ������ �ƴҰ�� sal ����
-- empno, ename, sal, ���������� �޿� AS bonus
SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
        END bonus,
        comm,        
        --NULLó�� �Լ� ������� �ʰ� CASE ���� �̿��Ͽ�
        --ccomm�� NULL�� ��� -10�� �����ϵ��� ����
        CASE
            WHEN comm IS NULL THEN -10
            ELSE comm
        END case_null
FROM emp;


--DECODE
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDENT', sal * 1.20,
                             sal) bonus
FROM emp;

SELECT empno, ename, 
    DECODE(deptno, 10, 'ACCOUNTING', 
                    20, 'RESEARCH', 
                    30, 'SALES', 
                    40, 'OPERATIONS',
                    'DDIT') dname
FROM emp;


--condition �ǽ� cond1
--emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� �����ؼ�
--������ ���� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT empno, ename,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END dname
FROM emp;

SELECT *
FROM emp;


--condition �ǽ� cond2
--emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� �������������
--��ȸ�ϴ� ������ �ۼ��ϼ���
--(������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�)

--1. ���س⵵�� ¦��/Ȧ�� ����
--2. hiredate���� �Ի�⵵�� ¦��/Ȧ�� ����

--1. TO_CHAR(SYSDATE, 'YYYY')
--> ���س⵵ ���� ( 0:¦��, 1:Ȧ��)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) 
FROM dual;

--2
SELECT empno, ename, 
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) =
             MOD(TO_CHAR(SYSDATE, 'YYYY', 2)
        THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END contact_to_doctor
FROM emp;

--2.
--���⵵ �ǰ����� ����ڸ� ��ȸ�ϴ� ������ �ۼ��غ�����
--2020
SELECT empno, ename, 
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) =
             MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
        THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END contact_to_doctor
FROM emp;



--SELECT empno, ename, 
--    CASE 
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 1 THEN '�ǰ����� �����'
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 THEN '�ǰ����� ������'
--        ELSE 'DEFAULT'
--    END
--FROM emp;


SELECT empno, ename, MOD(TO_CHAR(hiredate, 'YYYY'), 2) test
FROM emp;










