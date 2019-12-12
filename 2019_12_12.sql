

--별칭 : 테이블, 컬럼을 다른 이름으로 지칭
--    [AS] 별칭명
--    SELECT empno [AS] eno
--    FROM emp e
--    
--    SYNONYM(동의어)
--    오라클 객체를 다른이름으로 부를 수 있도록 하는 것
--    만약에 emp 테이블을 e라고 하는 synonym(동의어)로 생성을 하면
--    다음과 같이 SQL을 작성할 수 있다.
--    SELECT *
--    FROM e;

--개인 계정에 SYNONYM 생성 권한을 부여
GRANT CREATE SYNONYM TO JOO;
    
--    emp 테이블을 사용하여 synonym e를 생성
--CREATE SYNONYM 시노님 이름 FOR 오라클객체;    
CREATE SYNONYM e FOR emp;

--emp 라는 테이블 명 대신에 e라고 하는 시노님을 사용하여 쿼리를 작성 할 수 있다
SELECT *
FROM e;

--JOO 계정에 fastfood 테이블을 hr계정에서도 볼 수 있도록 테이블 조회 권한을 부여
GRANT SELECT ON daily TO hr;

SELECT *
FROM sem.fastfood;
-- sem.fastfood --> fastfood 시노님으로 생성
-- 생성후 다음 sql이 정상적으로 동작하는지 확인
CREATE SYNONYM fastfood FOR sem.fastfood;


SELECT *
FROM fastfood;
SELECT *
FROM USER_TABLES;
SELECT *
FROM ALL_TABLES
WHERE OWNER = 'JOO';

--Data dictionary 조회
SELECT *
FROM dictionary;

--Oracle 객체 정보
SELECT *
FROM user_objects;
SELECT *
FROM all_objects;
SELECT *
FROM dba_objects;
--table 테이블 정보
SELECT * FROM user_tables;
SELECT * FROM all_tables;
SELECT * FROM dba_tables;
--tab_columns 테이블의 컬럼 정보
--...
--indexes 인덱스 정보
--...
--ind_columns 인덱스 컬럼 정보
--...
--constraints 제약조건 정보
--...
--cons_columns 제약조건 컬럼 정보
--...


-- 동일한 SQL의 개념에 따르면 아래 SQL들은 다르다
SELECT /*201911_205*/ * FROM emp;
SELECT /*201911_205*/ * FROM EMP;
SELECt /*201911_205*/ * FROM EMP;

SELECt /*201911_205*/ * FROM EMP WHERE empno = 7369;
SELECt /*201911_205*/ * FROM EMP WHERE empno = 7499;
SELECt /*201911_205*/ * FROM EMP WHERE empno = :empno;


/******************************************************/
--system 계정에서 조회하기
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%201911_205%';
/******************************************************/

    
    
    
    