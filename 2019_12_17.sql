

-- WITH
-- WITH 블록이름 AS (
-- 서브쿼리
-- )
--
-- SELECT *
-- FROM 블록이름

-- deptno, avg(sal) avg_sal
-- 해당 부서의 급여 평균이 전체 직원의 급여 평균보다 높은 부서에 한해 조회
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal) > (SELECT AVG(sal) FROM emp);

--WITH 절을 사용하여 위의 쿼리를 작성
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



--계층쿼리
--달력만들기 목표
-->데이터의 행을 열로 바꾸는 방법
-->레포트 쿼리에서 활용 할 수 있는 예제 연습

-- CONNECT BY LEVEL <= N
-- 테이블의 ROW건수를 N만큼 반복한다
-- CONNECT BY LEVEL 절을 사용한 쿼리에서는
-- SELECT 절에서 LEVEL 이라는 특수 컬럼을 사용할 수 있다.
-- 계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하나
-- 추후 배우게 될 START WITH, CONNECT BY 절에서 다른점을 배우게 된다

-- 2019년 11월 : 30일까지 존재
-- 201911
-- 일자 + 정수 = 정수만큼 미래의 날짜
-- 201911 --> 해당년월의 날짜가 몇일까지 존재하는가?
SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 30;

SELECT LAST_DAY() --30
FROM dual;

--201911 --> 30
--201912 --> 31
--202402 --> 29
--201902 --> 28
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') -- 결과 : 30 , 29 ...
FROM dual;

--SELECT /*일요일이면 날짜*/, /*화요일이면 날짜*/, .../*토요일이면 날짜*/
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

--DB쌤 답
SELECT /*1월 컬럼, 2월 컬럼,*/
    NVL(MIN(DECODE(mm, '01', sales_sum)), 0)JAN, NVL(MIN(DECODE(mm, '02', sales_sum)), 0)FEB, 
    NVL(MIN(DECODE(mm, '03', sales_sum)), 0)MAR, NVL(MIN(DECODE(mm, '04', sales_sum)), 0)APR, 
    NVL(MIN(DECODE(mm, '05', sales_sum)), 0)MAY, NVL(MIN(DECODE(mm, '06', sales_sum)), 0)JUN
FROM
    (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales) sales_sum
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM'));
--DB쌤 답--





