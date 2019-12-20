
-- PL/SQL
-- PL/SQL 기본구조
-- DECLARE : 선언부, 변수를 선언하는 부분
-- BEGIN : PL/SQL의 로직이 들어가는 부분
-- EXCEPTION : 예외처리부


-- DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를 화면에 보여주도록 활성화
SET SERVEROUTPUT ON;
DECLARE --선언부
--  java : 타입 변수명;
--  pl/sql : 변수명 타입;
    v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);
BEGIN 
    --dept 테이블에서 10번 부서의 부서 이름, LOC 정보를 조회
    SELECT dname, loc
/*  INTO 변수, 변수2 */
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    -- String a = "t";
    -- String b = "c";
    -- Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/   

--PL/SQL 블록을 실행

DESC dept;


--2
SET SERVEROUTPUT ON;
DECLARE --선언부
--  java : 타입 변수명;
--  pl/sql : 변수명 타입;
--    v_dname VARCHAR2(14);
--    v_loc VARCHAR2(13);
    --테이블 컬럼의 정의를 참조하여 데이터 타입을 선언한다
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;

    
BEGIN 
    --dept 테이블에서 10번 부서의 부서 이름, LOC 정보를 조회
    SELECT dname, loc
/*  INTO 변수, 변수2 */
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    -- String a = "t";
    -- String b = "c";
    -- Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/   


-- 10번 부서의 부서이름, 위치지역을 조회해서 변수에 담고
-- 변수를 DBMS_OUTPUT.PUT_LINE함수를 이용하여 console에 출력
CREATE OR REPLACE PROCEDURE printdept 
-- 파라미터명 IN/OUT 타입
-- p_파라미터이름
( p_deptno IN dept.deptno%TYPE )
IS
--선언부(옵션)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
    
--실행부
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--예외처리부(옵션)
END;
/

exec printdept(50);


-- procedure 생성 실습
-- PRO_1
CREATE OR REPLACE PROCEDURE printtemp 
-- 파라미터명 IN/OUT 타입
-- p_파라미터이름
( p_empno IN emp.empno%TYPE )
IS
--선언부(옵션)
    dname dept.dname%TYPE;
    ename emp.ename%TYPE;
    
--실행부
BEGIN
    SELECT dname, ename
    INTO dname, ename       --선언부의 변수가 드감
    FROM dept, emp
    WHERE dept.deptno = emp.deptno
    AND emp.empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ':' || ename);
--예외처리부(옵션)
END;
/

exec printtemp(7499);

-- procedure 생성 실습
-- PRO_2
CREATE OR REPLACE PROCEDURE registdept_test
(p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/
exec registdept_test(99, 'ddit', 'daejeon');
DESC dept_test;
SELECT *
FROM emp;
SELECT *
FROM dept;



