

--날짜관련 함수
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : 해당 날짜가 속한 월의 마지막 일자(DATE)

--월 : 1,3,5,7,8,10,12 : 31일
--  : 2 -윤년 여부 28, 29
--  : 4,6,9,11 : 30일

SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;

--fn3 '201912' --> date 타입으로 변경하기
--해당 날짜의 마지막 날짜로 이동
--일자필드만 추출
--DATE --> 일자컬럼(DD)만 추출
--DATE --> 문자열(DD)
--TO_CHAR(DATE, '포맷')
--DATE : LAST_DAY(TO_DATE('201912', 'YYYYMM'))
--포맷 : 'DD'

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

--SYSDATE를 YYYY/MM/DD 포맷의 문자열로 변경 (DATE -> CHAR)
--'2019/11/26' 문자열 --> DATE
-- 문자열 : TO_CHAR(SYSDATE, 'YYYY/MM/DD')
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD'),
        --YYYY-MM-DD HH24:MI:SS 문자열로 변경
        TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'),
        'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--EMPNO    NOT NULL NUMBER(4)
--HIREDATE          DATE
DESC emp;

--empno가 7369인 직원 정보 조회하기
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

--DATE타입의 묵시적 형변환은 사용을 권하지 않음
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

--숫자 --> 문자열
--문자열 --> 숫자
--숫자 : 1000000 --> 1,000,000.00 (한국)
--숫자 : 1000000 --> 1.000.000,00 (독일)
--날짜 포맷 : YYYY, MM, DD, HH24, MI, SS
--숫자 포맷 : 숫자 표현 : 9, 자리맞춤을 위한 0표시 : 0, 화폐단위 : L
--          1000자리 구분 : , 소수점 : .
--숫자 -> 문자열 TO_CHAR(숫자, '포맷')
--숫자 포맷 길어질경우 숫자 자리수를 충분히 표현
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999') fm_sal
FROM emp;

--NULL 처리 함수 : NVL, NVL2, NULLIF, COALESCE

--NVL(exprl, expr2) : 함수 인자 두개
--expr1이 NULL이면 expr2를 반환
--expr1이 NULL이 아니면 expr1 을 반환
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--study test
SELECT empno, comm, nvl2(comm, /*NOT NULL*/ 000000, /*NULL*/ 999999) nvl_test
FROM emp;

--NVL2(expr1, expr2, expr3)
--expr1 IS NOT NULL expr2 리턴
--expr1 IS NULL expr3 리턴
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL을 리턴
--expr1 != expr2 expr1을 리턴
--comm이 NULL일때 comm+500 : NULL
--  NULLIF(NULL, NULL) : NULL
--comm이 NULL이 아닐때 comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

--COALESCE(expr1, expr2, expr3......)
--인자중에 첫번째로 등장하는 NULL이 아닌 exprN을 리턴
--expr1 IS NOT NULL epxr1을 리턴하고
--expr1 IS NULL COALESCE(expr2, expr3.....)
SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal_sal
FROM emp;

--null 실습
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
--emp.job 컬럼을 기준으로
-- 'SALESMAN'이면 sal * 1.05를 적용한 값 리턴
-- 'MANAGER'이면 sal * 1.10를 적용한 값 리턴
-- 'PRESIDENT'이면 sal * 1.20를 적용한 값 리턴
-- 위 3가지 직군이 아닐경우 sal 리턴
-- empno, ename, sal, 요율적용한 급여 AS bonus
SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
        END bonus,
        comm,        
        --NULL처리 함수 사용하지 않고 CASE 절을 이용하여
        --ccomm이 NULL일 경우 -10을 리턴하도록 구성
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


--condition 실습 cond1
--emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서
--다음과 같이 조회하는 쿼리를 작성하세요
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


--condition 실습 cond2
--emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진대상자인지
--조회하는 쿼리를 작성하세요
--(생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)

--1. 올해년도가 짝수/홀수 인지
--2. hiredate에서 입사년도가 짝수/홀수 인지

--1. TO_CHAR(SYSDATE, 'YYYY')
--> 올해년도 구분 ( 0:짝수, 1:홀수)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) 
FROM dual;

--2
SELECT empno, ename, 
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) =
             MOD(TO_CHAR(SYSDATE, 'YYYY', 2)
        THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contact_to_doctor
FROM emp;

--2.
--내년도 건강검진 대상자를 조회하는 쿼리를 작성해보세요
--2020
SELECT empno, ename, 
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) =
             MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
        THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contact_to_doctor
FROM emp;



--SELECT empno, ename, 
--    CASE 
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 1 THEN '건강검진 대상자'
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 THEN '건강검진 비대상자'
--        ELSE 'DEFAULT'
--    END
--FROM emp;


SELECT empno, ename, MOD(TO_CHAR(hiredate, 'YYYY'), 2) test
FROM emp;










