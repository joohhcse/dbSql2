
/******************************************************/
/******************************************************/
/**********************SQL 응용*************************/
/******************************************************/
/******************************************************/

--------------------SQL 응용--PART3

--multiple insert
--emp 테이블의 empno, ename 컬럼으로 emp_test, emp_test2 테이블을 생성(CTAS, 데이터도 같이 복사)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--unconditional insert
--여러 테이블에 데이터를 동시 입력
--brown, cony 데이터를 emp_test, emp_test2 테이블에 동시에 입력
INSERT ALL 
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;

SELECT *
FROM emp_test
WHERE empno > 9000;

SELECT *
FROM emp_test2
WHERE empno > 9000;

ROLLBACK;
-- 테이블 별 입력되는 데이터의 컬럼을 제어 가능
INSERT ALL 
    INTO emp_test(empno, ename) VALUES(eno, enm)
    INTO emp_test2(empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;

SELECT *
FROM emp_test
WHERE empno > 9000
UNION ALL
SELECT *
FROM emp_test2
WHERE empno > 9000;

ROLLBACK;

--conditional insert
--조건에 따라 테이블에 데이터를 입력

/*
    CASE
        WHEN 조건 THEN --
        WHEN 조건 THEN --
        ELSE --
    END
*/

ROLLBACK;
--3개 행이 삽입됨 --INSERT ALL
INSERT ALL
    WHEN eno > 9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno > 9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;
        
SELECT * FROM emp_test;
SELECT * FROM emp_test2 WHERE empno > 8000;

--2개 행이 삽입됨 --INSERT FIRST
INSERT FIRST
    WHEN eno > 9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno > 9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;



