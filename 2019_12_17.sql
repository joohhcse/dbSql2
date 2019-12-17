

-- WITH
-- WITH ����̸� AS (
-- ��������
-- )
--
-- SELECT *
-- FROM ����̸�

-- deptno, avg(sal) avg_sal
-- �ش� �μ��� �޿� ����� ��ü ������ �޿� ��պ��� ���� �μ��� ���� ��ȸ
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal) > (SELECT AVG(sal) FROM emp);

--WITH ���� ����Ͽ� ���� ������ �ۼ�
WITH dept_sal_avg AS(
    SELECT deptno, AVG(sal) avg_sal
    FROM emp
    GROUP BY deptno),
    emp_sal_avg AS(
        SELECT AVG(sal) avg_sal FROM emp
    )
SELECT *
FROM dept_sal_avg
WHERE avg_sal > (SELECT avg_sal FROM emp_sal_avg);



--��������
--�޷¸���� ��ǥ
-->�������� ���� ���� �ٲٴ� ���
-->����Ʈ �������� Ȱ�� �� �� �ִ� ���� ����

-- CONNECT BY LEVEL <= N
-- ���̺��� ROW�Ǽ��� N��ŭ �ݺ��Ѵ�
-- CONNECT BY LEVEL ���� ����� ����������
-- SELECT ������ LEVEL �̶�� Ư�� �÷��� ����� �� �ִ�.
-- ������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� ROWNUM�� �����ϳ�
-- ���� ���� �� START WITH, CONNECT BY ������ �ٸ����� ���� �ȴ�

-- 2019�� 11�� : 30�ϱ��� ����
-- 201911
-- ���� + ���� = ������ŭ �̷��� ��¥
-- 201911 --> �ش����� ��¥�� ���ϱ��� �����ϴ°�?
SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 30;

SELECT LAST_DAY() --30
FROM dual;

--201911 --> 30
--201912 --> 31
--202402 --> 29
--201902 --> 28
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') -- ��� : 30 , 29 ...
FROM dual;

--SELECT /*�Ͽ����̸� ��¥*/, /*ȭ�����̸� ��¥*/, .../*������̸� ��¥*/
SELECT 
        /*dt, d, iw,*/
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;
                    
                    
-------
SELECT 
        iw, /*dt, d, iw,DECODE(d, 1, iw+1, iw) iw,*/
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) ,'WW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;

----Exam
SELECT 
        --/*dt, d, iw*/dt - (d-1),  
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY dt - (d-1)
ORDER BY dt - (d-1);


--By JiSun KIM
SELECT
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY sat;

--Sales Table Exercise

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;

SELECT DECODE(
FROM sales
GROUP BY TODA

SELECT DECODE(
FROM sales
GROUP BY TO_DATE(201901, 'MM');

SELECT *
FROM sales
WHERE dt = TO_DATE(201901, 'YYYYMM');

SELECT *
FROM sales
WHERE TO_CHAR(dt, 'YYYYMM') = '201901';

SELECT TO_CHAR(dt, 'MM'), SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


WITH a AS (
SELECT TO_CHAR(dt, 'MM') month, SUM(sales) sum
FROM sales
GROUP BY TO_CHAR(dt, 'MM')
)
SELECT 
    (SELECT sum FROM sales WHERE month = 01) "JAN",
FROM
    a
GROUP BY TO_CHAR(dt, 'MM');

--DB�� ��
SELECT /*1�� �÷�, 2�� �÷�,*/
    NVL(MIN(DECODE(mm, '01', sales_sum)), 0)JAN, NVL(MIN(DECODE(mm, '02', sales_sum)), 0)FEB, 
    NVL(MIN(DECODE(mm, '03', sales_sum)), 0)MAR, NVL(MIN(DECODE(mm, '04', sales_sum)), 0)APR, 
    NVL(MIN(DECODE(mm, '05', sales_sum)), 0)MAY, NVL(MIN(DECODE(mm, '06', sales_sum)), 0)JUN
FROM
    (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales) sales_sum
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM'));
--DB�� ��--





