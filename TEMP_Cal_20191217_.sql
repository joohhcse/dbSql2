--EXERCISE


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
        dt - (d-1),
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


SELECT 
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= 35)
GROUP BY dt-(d-1)
ORDER BY dt-(d-1);

--JongMin Park
-- 12.18일까지 과제 -- 달력 출력후 NULL 도 모두 채우기
SELECT
    MAX(NVL(DECODE(d, 1, dt), dt - d + 1)) 일, MAX(NVL(DECODE(d, 2, dt), dt - d + 2)) 월, MAX(NVL(DECODE(d, 3, dt), dt - d + 3)) 화,
    MAX(NVL(DECODE(d, 4, dt), dt - d + 4)) 수, MAX(NVL(DECODE(d, 5, dt), dt - d + 5)) 목, MAX(NVL(DECODE(d, 6, dt), dt - d + 6)) 금, MAX(NVL(DECODE(d, 7, dt), dt - d + 7)) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);


--DB쌤 답
--201910 : 35, 첫주의 일요일 : 201909, 마지막 주의 토요일 : 20191102
-- 일(1), 월(2), 화(3), 수(4), 목(5), 금(6), 토(7)
SELECT ldt-fdt+1
FROM
    (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
           LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
           TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') - 1) fdt
    FROM dual);


SELECT
    MAX(DECODE(d, 1, dt)) 일, MAX(DECODE(d, 2, dt)) 월, MAX(DECODE(d, 3, dt)) 화,
    MAX(DECODE(d, 4, dt)) 수, MAX(DECODE(d, 5, dt)) 목, MAX(DECODE(d, 6, dt)) 금, MAX(DECODE(d, 7, dt)) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL-1) dt,              
            
            TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') -
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL-1),'D' ) d, 
            
            TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') -
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL),'IW' ) iw 
    FROM dual
    CONNECT BY LEVEL <= (SELECT ldt-fdt+1
                        FROM
                            (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
                               LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
                               TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') - 1) fdt
                            FROM dual)))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);
--DB쌤 답--

