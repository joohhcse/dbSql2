

--DDL(Index)
--Index
--    -테이블의 일부 컬럼을 기준으로 데이터를 정렬한 객체
--    -테이블의 row를 가리키는 주소를 갖고 있다.(rowid)
--    -정렬된 인덱스를 기준으로 해당 row의 위치를 빠르게 검색하여
--    -테이블의 원하는 행에 빠르게 접근
--    -테이블에 데이터를 입력하면 인덱스 구조도 갱신된다.
--Table
--    -입력 순서대로 데이터 저장 : 비 순차적인 블록
--    -DELETE 등으로 비 연속적인 블록 구성
--    -대용량 테이블 액세스 시 과도한 블록 읽기 발생
--        > multi block I/O
--Index
--    -최소한의 데이터 블록 읽기를 통한 성능 향상
--    -대표 키와 row의 주소 정보(rowid)만 미리 정렬
--        >대표 키 값을 통해 미리 정렬된 인덱스를 통해 검색대상row만 바로 액세스
--        >rowid를 통한 액세스가 가장 빠른 조회 경로
--    -블록 단위의 액세스 : 가장 작은 단위 디스크 I/O
--        >single block I/O
        
-- table과 인덱스 scan / Index 구조 /  

SELECT rowid, rownum, emp.*
FROM emp;


--emp 테이블 empno 컬럼으로 PRIMARY KEY 제약 생성 : pk_emp
--dept 테이블 deptno 컬럼으로 PRIMARY KEY 제약 생성 : pk_dept
--emp 테이블의 deptno 컬럼이 dept 테이블의 deptno 컬럼을 참조하도록 FOREIGN KEY 제약 추가 : fk_dept_deptno
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY (deptno)
            REFERENCES dept (deptno);

--emp_test 테이블 삭제
DROP TABLE emp_test;

--emp 테이블을 이용해서 emp_test 테이블 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test 테이블에는 인덱스가 없는 상태
--원하는 데이터를 찾기 위해서는 테이블의 데이터를 모두 읽어봐야 한다.
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

--실행계획을 통해 7369 사번을 갖는 직원 정보를 조회하기 위해 테이블의 
--모든 데이터(14)를 읽어 본다음에 사번이 7369인 데이터만 선택하여 사용자에게 반환 
--**13건의 데이터는 불필요하게 조회 후 버림

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

--실행계획을 통해 분석을 하면
--empno 가 7369인 직원을 index를 통해 매우 빠르게 인덱스에 접근
--같이 저장되어 있는 rowid 값을 통해 table에 접근을 한다
--table에서 읽은 데이터는 7369사번 데이터 한건만 조회를 하고 
--나머지 13건에서 대해서는 읽지 않고 처리
-- 14--> 1
-- 1--> 1

--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어 낼 수 있는 경우

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

--emp 테이블의 모든 컬럼을 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;
SELECT *
FROM TABLE(dbms_xplan.display);
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

--emp 테이블의 empno 컬럼을 조회 --빨라
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;
SELECT *
FROM TABLE(dbms_xplan.display);
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------

--DDL(unique Index가 있다면 : PK = unique + not null
--unique index
--    >인덱스 컬럼에 중복되는 값이 존재할 수 없다.
--    >row마다 다른값
--    >ex : pk 컬럼
--    PK 제약을 생성하며 empno 값을 기준으로 인덱스 생성
--        > empno값을 기준으로 정렬
--    PK제약은 unique + not null 이므로 pk 컬럼에 해당하는 값은 해당 테이블에 한번만 존재함을 보장
--    인덱스는 정렬된 개게이므로 찾고자 하는 값의 위치를 빠르게 검색
--    인덱스에 저장된 rowid 를 통해 테이블의 행 위치를 찾아 필요로하는 나머지 컬럼들을 테이블을 통해 조회
--    사용자가 요청한 데이터는 empno 컬럼 하나이므로 굳이 테이블에 접근할 필요가 없음
--    테이블 접근 없이 인덱스 unique scan으로 검색 종료
        
--DDL(non-unique Index)가 있다면
--non-unique index
--    >중복이 가능한 컬럼
--    >ex : 주문 테이블의 주문일자
--    empno값을 기준으로 non-unique 인덱스 생성    p81
--        > empno값을 기준으로 정렬
--    non-unique index 이므로 같은 값이 여러번 올 수 있다.
--    인덱스는 정렬된 객체이므로 찾고자 하는 값의 위치를 빠르게 검색
--        > empno=7782
--    non-unique 인덱스 이므로 계속해서 인덱스를 스캔한다
--        > empno=7788인 값을 만나고 나서야 empno=7782 인 값이 더 이상 존재하지 않음을 알 수 있다. (n+1 scan)
--    job값을 기준으로 non-unique 인덱스 생성    p83
--        job값을 기준으로 정렬
--    non-unique index 이므로 같은 값이 여러번 올 수 있다.
--    인덱스는 정렬된 객체이므로 찾고자 하는 값의 위치를 빠르게 검색
--        >ename = 'MANAGER'
--        >rowid를 이용해 테이블에 접근하여 나머지 컬럼값을 조회
--    non-unique 인덱스이므로 계속해서 인덱스를 스캔한다
--        >ename = 'PRESIDENT' 인 값을 만나고 나서야 ename = 'MANAGER' 인 값이 더이상 존재하지 않음을 알 수있다. (n+1 scan)
--    job 값을 기준으로 non-unique 인덱스 생성   p85
--        >job값을 기준으로 정렬
--    non-unique index이므로 같은 값이 여러번 올 수 있다.
--    인덱스는 정렬된 객체이므로 찾고자 하는 값의 위치를 빠르게 검색
--        >job = 'MANAGER'
--        >rowid 를 이용해 테이블에 접근하여 나머지 컬럼값을 조회
--    테이블 접근후 ename LIKE 'C%' 인 데이터만 filterling
--    3건의 테이블 데이터에 접근 후 실제 조건에 만족하는 1건만 조회

--기존인덱스 제거
--pk_emp 제약조건 삭제 --> unique 제약 삭제 --> pk_emp 인덱스 삭제
--INDEX 종류 (컬럼 중복 여부)
--UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 없는 인덱스
--              (emp.empno, dept.deptno)
--NON-UNIQUE INDEX : 인덱스 컬럼의 값이 중복될수 있는 인덱스
--                  (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE idx_n_emp_01 ON emp (empno);

--위쪽 상황이랑 달라진 것은 EMPNO컬럼으로 생성된 인덱스가
--UNIQUE -> NON-UNIQUE 인덱스로 변경됨
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;
SELECT *
FROM TABLE(dbms_xplan.display);

--7782
INSERT INTO emp (empno, ename) VALUES(7782, 'brown');
COMMIT;

--emp 테이블에 job컬럼으로 non-unique 인덱스 생성
--인덱스명 : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);
    
SELECT job, rowid
FROM emp
ORDER BY job;

SELECT job, rowid
FROM emp
ORDER BY job;

SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 인덱스
-- emp 테이블에는 인덱스가 2개 존재
-- 1. empno
-- 2. job
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--IDX_03
--idx_n_emp_03
--emp 테이블의 job, ename 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_03 ON emp(job, ename);

SELECT job, ename, rowid
FROm emp
ORDER BY job, ename;

--idx_n_emp_04
-- ename, job 컬럼으로 emp 테이블에 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_04 ON emp( ename, job);
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

--JOIN 쿼리에서의 인덱스
--emp 테이블은 empno컬럼으로 PRIMARY KEY 제약조건이 존재
--dept 테이블은 deptno 컬럼으로 PRIMARY KEY 제약조건이 존재
--emp 테이블은 PRIMARY KEY 제약을 삭제한 상태이므로 재생성
DELETE emp WHERE ename = 'brown';
COMMIT;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    33 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     0   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     4 |    80 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
순서 : 4 > 3 > 5 > 2 > 6 > 1 > 0

--DB실무 --쿼리 패턴 정리
--TB_COUNSEL
--ACCESS PATH
--1. cims_cd(=)
--2. cs_rcv_id(=) , cs_rcv_dt(between)
--3. cs_rcv_dt(between), lv1 lv2 lv3 .. 

--인덱스를 없애고 다시만들때 : 테이블 데이터 삽입 > 

--DDL ( index vs table full access )
--    index access
--        소수의 데이터 조회시 유리 (응답속도 중요할때)
--        I/O 기준이 single block : 다량 데이터를 인덱스로 접근함녀 테이블 전체조회보다 오히려 느리다
--        
--    Table full access
--        테이블의 모든 데이터를 읽어서 처리하는 경우라면 인덱스보다 유리
--        I/O 기준이 multi block
--        전체 처리 속도가 중요할때


DROP TABLE dept_test;
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS 
SELECT *
FROM dept
WHERE 1=1;

--deptno 컬럼으로 UNIQUE INDEX
CREATE UNIQUE INDEX idx_u_dept_test_01 ON dept_test (deptno);   --CREATE INDEX idx_unique_dept ON dept_test (deptno);
--dname 컬럼으로 NON_UNIQUE INDEX
CREATE INDEX idx_u_dept_test_02 ON dept_test (dname);   --CREATE INDEX idx_non_unique_dept ON dept_test (dname);
--deptno, dname 컬럼으로 NON-UNIQUE INDEX
CREATE INDEX idx_u_dept_test_03 ON dept_test (deptno, dname);

--idx2
DROP INDEX idx_u_dept_test_01;
DROP INDEX idx_u_dept_test_02;
DROP INDEX idx_u_dept_test_03;











