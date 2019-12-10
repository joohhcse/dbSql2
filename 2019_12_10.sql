
--제약조건 활성화 / 비활성화
--ALTER TABLE 테이블명 ENABLE OR DISABLE CONSTRAINT 제약조건명;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_TEST';

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007118;

SELECT *
FROM dept_test;

--dept_test 테이블의 deptno 컬럼에 적용된 PRIMARY KEY 제약조건을 비활성화하여 동일한 부서 번호를 갖는 데이터를 입력할 수 있다.
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'DDIT', '대전');

--dept_test 테이블의 PRIMARY KEY 제약조건 활성화
--이미 위에서 실행한 두개의 INSERT구문에 의해 같은 부서번호를 갖는 데이터가 존재하기 대문에 PRIMARY KEY 제작조건을 활성화 할 수 없다.
--활성화하려면 중복데이터를 삭제해야 한다.
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007118;    --error

--부서번호가 중복되는 데이터만 조회하여
--해당 데이터에 대해 수정후 PRIMARY KEY 제약조건을 활성화 할 수 있다.
SELECT deptno, COUNT(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >= 2;


--table_name, constraint_name, column_name
--position 정렬 (ASC)
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns
WHERE table_name = 'BUYER';

--테이블에 대한 설명(주석) VIEW
SELECT *
FROM user_tab_comments;

--테이블 주석
--COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON TABLE dept IS '부서';


--컬럼 주석
--COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';
COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치 지역';

SELECT *
FROM user_col_comments
WHERE table_name = 'DEPT';


--comment1 실습
SELECT *
FROM user_col_comments
WHERE table_name = 'CUSTOMER';
SELECT *
FROM user_col_comments
WHERE table_name = 'PRODUCT';
SELECT *
FROM user_col_comments
WHERE table_name = 'CYCLE';
SELECT *
FROM user_col_comments
WHERE table_name = 'DAILY';
SELECT *
FROM user_tab_comments
WHERE table_name = 'CUSTOMER';

SELECT tab.table_name, tab.table_type, tab.comments tab_comment,
        col.column_name, col.comments col_comment
FROM user_tab_comments tab, user_col_comments col
WHERE tab.table_name = col.table_name 
AND tab.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');


--DDL(View)
--    컬럼제한
--    자주 사용하는 결과물의 재활용
--    쿼리 길이 단축
    
--VIEW는 QUERY 이다 (O)
--테이블처럼 데이터가 물리적으로 존재하는 것이 아니다. 논리적인 데이터 정의 집합
--논리적 데이터 셋 = QUERY
--VIEW는 테이블 이다 (X)
--VIEW 생성 권한 필요
--    > system 계정에서 실행
--VIEW가 참조하는 테이블을 수정하면 VIEW에도 영향을 미친다.


--VIEW 생성
--CREATE OR REPLACE VIEW 뷰이름 [(컬럼별칭1, 컬럼별칭2...)] AS
--SUBQUERY

--emp 테이블에서 sal, comm 컬럼을 제외한 나머지 6개 컬럼만 조회가 되는 view -> v_emp 이름으로 생성
CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

DESC emp;

--SYSTEM 계정에서 작업
--VIEW 생성 권한을 JOO 계정에 부여
GRANT CREATE VIEW TO JOO;

SELECT *
FROM v_emp;

--INLINE VIEW
SELECT *
FROM
(SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp);

--emp 테이블을 수정하면 view에 영향이 있을까?
--KING 부서번호가 현재 10번
--emp 테이블의 KING의 부서번호 데이터를 30번으로수정(COMMIT하지 말것)
--v_emp 테이블에서 KING의 부서번호를 관찰
UPDATE emp SET deptno = 30
WHERE ename = 'KING';

SELECT *
FROM emp
WHERE ename = 'KING';

ROLLBACK;

--조인된 결과를 view로 생성
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--emp 테이블에서 KING 데이터 삭제(COMMIT 하지 말것)
DELETE emp
WHERE ename = 'KING';

SELECT *
FROM emp;
WHERE ename = 'KING';

--emp 테이블에서 KING 데이터 삭제 후 v_emp_dept view의 조회 결과 확인
SELECT *
FROM v_emp_dept;

--INLINE VIEW
SELECT *
FROM
(SELECT emp.empno, ename, job, mgr, hiredate, deptno
FROM emp);

--emp 테이블의 empno 컬럼을 eno로 컬럼이름 변경
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno;

SELECT *
FROM v_emp_dept;

ROLLBACK;

--VIEW 삭제
--v_emp 삭제
DROP VIEW v_emp;

--DDL(View)
--VIEW DML
--    VIEW의 종류 : Simple VIew, Complex View
--    보통 가능, 단 다음 사항 제외
--        >GROUP BY 사용
--        >DISTINCT 사용
--        >ROWNUM 사용
--    Seqeunce
--        데이터에 KEY 컬럼은 값이 유일해야 함
--        유일한 값을 만드는 방법
--            >KEY TABLE (미리 값을 정의 해둔 테이블)
--            >UUID / 혹은 별도의 라이브러리
--            >sequence
--        유일한 정수 값을 생성해 주는 오라클 객체
--            >pk컬럼에 저장할 임의의 값 생성
--        캐쉬 기능을 통한 속도 향상            


--부서별 직원의 급여 합계
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_sal
WHERE deptno = 20;

SELECT *
FROM
(SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno)
WHERE deptno = 20;

--SEQUENCE
--오라클객체로 중복되지 않는 정수 값을 리턴해주는 객체
--CREATE SEQUENCE 시퀀스명 
--[옵션...]
CREATE SEQUENCE seq_board;

--SEQUENCE
--NEXTVAL
--    시퀀스의 다음 값을 조회
--CURRVAL
--    현재 시퀀스 값을 조회
--    NEXTVAL을 통해 값을 가져온 뒤에 사용가능

--SEQEUNCE OPTION
--INCREMENT BY n : 시퀀스 증가치
--START WITH N : 시퀀스 시작 값
--MAXVALUE n | NOMAXVALUE
--    시퀀스 최대값 | 무한대(9999...)
--MINVALUE n | NOMINVALUE
--    시퀀스 최소값 | 무한대(9999...)
--
--CACHE n | NOCACHE
--    >캐싱할 개수
--    >Unique 한 값을 생성해야 하므로 동시성 제어가 필요
--    >즉 시퀀스 객체에 접근하기 위한 lock이 필요한데 메모리에 미리 올려두어 lock경합을 해소 할 수 있다.
--    >단 캐싱된 시퀀스 값들은 이미 사용이 된것
--    >ROLLBACK해도 복원되지 않는다
--    >사용자가 시퀀스를 사용하지 않아도 서버를 재기동 하면 캐싱되었던 시퀀스 값은 없어진다
--    >캐싱 예시
--        -CACHE 20
--        -마지막으로 사용한 값 : 5
--        -서버 재기동시 해당 시퀀스는 21부터 시작
--    ORDER n | NOCACHE
--        ORACLE RAC 환경같이 멀티 서버에서
--    CYCLE | NOCYCLE
--        최대값 도달시 최소값부터 다시 시작할지 여부
--Sequence 수정 / 삭제
--    ALTER SEQUENCE seq_emp CACHE 10;
--    DROP SEQUENCE seq_emp;

--시퀀스 사용방법 : 시퀀스명.nextval
SELECT seq_board.nextval
FROM dual;

SELECT seq_board.currval
FROM dual;


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




