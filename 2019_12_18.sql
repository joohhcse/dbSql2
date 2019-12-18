--계층쿼리 이어서...

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

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'           -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (이미 읽어준 녀석)

/*
    dept0(XX회사)
        dept0_00(디자인부)
            dept0_00_0(디자인팀)
        dept0_01(정보기획부)
            dept0_01_0(기획파트)
                dept0_00_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발1팀)
            
*/

--*********XX회사
SELECT LPAD('XX', 15, '*'),
        LPAD('XX', 15)
FROM dual;

--상향식
--PRIOR p_deptcd = deptcd
--현재 읽은 데이터.상위부서코드 = 앞으로 읽을 데이터.부서코드

--계층쿼리
--h1
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'           -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;


--정보시스템부의 하위의 부서계층 구조를 도식화하는 쿼리 
--h2
SELECT dept_h.*
FROM dept_h;

SELECT LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'            -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (이미 읽어준 녀석)

SELECT LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'            -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (이미 읽어준 녀석)
--h2--

SELECT *
FROM dept_h;

--h3
-- 디자인팀(dept0_00_0)을 기준으로 상향식 계층쿼리 작성
-- 자기 부서의 부모 부서와 연결을 한다.
SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
--CONNECT BY deptcd = PRIOR p_deptcd;       --PRIOR 는 내가 읽은 행
--CONNECT BY deptcd = PRIOR p_deptcd AND = PRIOR col2;
--h3--


create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

--h4
SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id, value, LEVEL
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
--h4--

--h5
--계층형쿼리 스크립트.sql 테이블 생성
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);
commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id, value, LEVEL
FROM no_emp
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

--h5 Answer
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd, LEVEL
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
----

SELECT *
FROM no_emp;
--h5--


-- pruning branch (가지치기)
-- 계층 쿼리의 실행순서
-- FROM --> START WITH ~ CONNECT BY --> WHERE
-- 조건을 CONNECT BY 절에 기술한 경우
-- . 조건을 따라 다음 ROW로 연결이 안되고 종료
-- 조건을 WHERE 절에 기술한 경우
-- . START WITH ~ CONNECT BY 절에 의해 계층형으로 나온 결과에
-- WHERE 절에 기술한 결과 값에 해당하는 데이터만 조회

--최상위 노드에서 하향식으로 탐색

--CONNECT BY절에 deptnm != '정보기획부' 조건을 기술한 경우
--WHERE 절에 deptnm != '정보기획부' 조건을 기술한 경우
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

--FROM -> START WITH CONNECT BY -> WHERE

SELECT *
FROM dept_h
--WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;






-- 계층 쿼리에서 사용 가능한 특수 함수
-- CONNNECT_BY_ROOT(col) 가장 최상위 row의 col 정보 값 조회
-- SYS_CONNECT_BY_PATH(col, 구분자) : 최상위 row에서 현재 로우까지 col값을 구분자로 연결해준 문자열
-- CONNECT_BY_ISLEAF : 해당 ROW가 마지막 노드인지(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path,
        CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


--h6
--게시글을 저장하는 board_test 테이블을 이용하여 계층쿼리를 작성하시오
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR parent_seq = seq;
ORDER SIBLINGS BY DECODE(parent_seq, NULL, seq,0, seq);

SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path,
        CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--h6
--DB쌤 답
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;
--DB쌤 답--

--h7(ORDER BY seq DESC), 8 (ORDER SIBLINGS BY)    
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;







