
--EXCEPTION
--에러 발생시 프로그램을 종료시키지 않고
--해당 예외에 대해 다른 로직을 실행 시킬수 있게 끔 처리한다

--예외가 발생했는데 예외처리가 없는 경우 : pl/sql 블록이 에러와 함께 종료된다.
--여러건의 SELECT 결과가 존재하는 상황에서 스칼라 변수에 값을 넣는 상황

-- emp 테이블에서 사원 이름을 조회
SET SERVEROUTPUT ON;
DECLARE
    -- 사원 이름을 저장할 수 있는 변수
    v_ename emp.ename%TYPE;
BEGIN
    -- 14의 SELECT 결과가 나오는 SQL -> 스칼라 변수에 저장이 불가하다 (에러)
    SELECT ename
    INTO v_ename
    FROM emp;
EXCEPTION
    /*WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('여러건의 SELECT 결과가 존재');*/
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('WHEN OTHERS');
END;
/

-- 사용자 정의 예외
-- 오라클에서 사전에 정의한 예외 이외에도 개발자가 해당 사이트에서 비즈니스 로직으로 정의한 예외를 생성, 사용할 수 있다.
-- 예를 들어 SELECT 결과가 없는 상황에서 오라클에서는 NO_DATA_FOUND 예외를 던지면 해당 예외를 잡아 NO_EMP라는 개발자가 정의한 예외로 재정의하여
-- 예외를 던질 수 있다.


--
DECLARE
    -- emp 테이블 조회 결과가 없을 때 사용할 사용자 정의 예외
    -- 예외명 EXCEPTION;
    no_emp EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    -- NO_DATA_FOUND
    BEGIN 
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 7000;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE no_emp;       --java throw new NoEmpException()
END;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/

-- 사번을 입력받아서 해당 직원의 이름을 리턴하는 함수
-- getEmpName(7369) --> SMITH

SELECT *
FROM emp;

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE)
RETURN VARCHAR2 IS
    -- 선언부
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/

SELECT getEmpName(7369) -- SMITH
FROM dual;

SELECT getempname(empno)
FROM emp;

SELECT *
FROM dept;

-- 부서번호를 파라미터로 입력받고 해당 부서의 이름을 리턴하는 함수 getdeptname을 작성
--function1
CREATE OR REPLACE FUNCTION getDeptName (p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 IS
    -- 선언부
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT getdeptname(10)
FROM dual;

-- cache : 20
-- 데이터 분포도
-- deptno (중복 발생가능) : 분포도가 좋지 못하다 
-- empno (중복이 없다) : 분포도가 좋다

-- emp 테이블의 데이터가 100만건인 경우 
-- 100건중에서 deptno의 종류는 4건 (10~40)
SELECT getdeptname(deptno),    --4가지
       getempname(empno)       --row 수만큼 데이터가 존재
FROM emp;


--function2
SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;

--indent라는 이름의 함수로 대체 --인자와 리턴값을 각자 생각해보기
--function2
CREATE OR REPLACE FUNCTION indent(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 IS
    -- 선언부
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptnm
    FROM dept_h
    START WITH p_deptcd IS NULL
    CONNECT BY PRIOR deptcd = p_deptcd;
    
    RETURN LPAD(' ', (LEVEL - 1) * 4, ' ');
END;
/

--db쌤 답
CREATE OR REPLACE FUNCTION indent(p_lv NUMBER, p_dname VARCHAR2)
RETURN VARCHAR2 IS
    v_dname VARCHAR2(200);
BEGIN
--    SELECT LPAD(' ', (p_lv - 1) * 4, ' ') || p_dname
--    INTO v_dname
--    FROM dual;
    v_dname := LPAD(' ', ( p_lv - 1 ) * 4, ' ') || p_dname;
    
    RETURN v_dname;
END;
/

SELECT deptcd, indent(LEVEL, deptnm) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;
--db쌤 답--


--trigger

--user 테이블의 비밀번호 컬럼이 변경이 생겼을 때
--기본에 사용하던 비밀번호 컬럼 이력을 관리하기 위한 테이블
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt date
);


CREATE OR REPLACE TRIGGER make_history
    --timing
    BEFORE UPDATE ON USERS
    FOR EACH ROW        --행트리거, 행의 변경이 있을 때마다 실행한다.
    --현재 데이터 참조 : OLD
    --갱신 데이터 참조 : NEW
BEGIN
        --user 테이블의 pass 컬럼을 변경할 때 trigger 실행
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history
                VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
        -- 다른 컬럼에 대해서는 무시한다
END;
/





