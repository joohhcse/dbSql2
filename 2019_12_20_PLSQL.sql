
-- PL/SQL
-- PL/SQL �⺻����
-- DECLARE : �����, ������ �����ϴ� �κ�
-- BEGIN : PL/SQL�� ������ ���� �κ�
-- EXCEPTION : ����ó����


-- DBMS_OUTPUT.PUT_LINE �Լ��� ����ϴ� ����� ȭ�鿡 �����ֵ��� Ȱ��ȭ
SET SERVEROUTPUT ON;
DECLARE --�����
--  java : Ÿ�� ������;
--  pl/sql : ������ Ÿ��;
    v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);
BEGIN 
    --dept ���̺��� 10�� �μ��� �μ� �̸�, LOC ������ ��ȸ
    SELECT dname, loc
/*  INTO ����, ����2 */
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    -- String a = "t";
    -- String b = "c";
    -- Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/   

--PL/SQL ����� ����

DESC dept;


--2
SET SERVEROUTPUT ON;
DECLARE --�����
--  java : Ÿ�� ������;
--  pl/sql : ������ Ÿ��;
--    v_dname VARCHAR2(14);
--    v_loc VARCHAR2(13);
    --���̺� �÷��� ���Ǹ� �����Ͽ� ������ Ÿ���� �����Ѵ�
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;

    
BEGIN 
    --dept ���̺��� 10�� �μ��� �μ� �̸�, LOC ������ ��ȸ
    SELECT dname, loc
/*  INTO ����, ����2 */
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    -- String a = "t";
    -- String b = "c";
    -- Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/   


-- 10�� �μ��� �μ��̸�, ��ġ������ ��ȸ�ؼ� ������ ���
-- ������ DBMS_OUTPUT.PUT_LINE�Լ��� �̿��Ͽ� console�� ���
CREATE OR REPLACE PROCEDURE printdept 
-- �Ķ���͸� IN/OUT Ÿ��
-- p_�Ķ�����̸�
( p_deptno IN dept.deptno%TYPE )
IS
--�����(�ɼ�)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
    
--�����
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--����ó����(�ɼ�)
END;
/

exec printdept(50);


-- procedure ���� �ǽ�
-- PRO_1
CREATE OR REPLACE PROCEDURE printtemp 
-- �Ķ���͸� IN/OUT Ÿ��
-- p_�Ķ�����̸�
( p_empno IN emp.empno%TYPE )
IS
--�����(�ɼ�)
    dname dept.dname%TYPE;
    ename emp.ename%TYPE;
    
--�����
BEGIN
    SELECT dname, ename
    INTO dname, ename       --������� ������ �尨
    FROM dept, emp
    WHERE dept.deptno = emp.deptno
    AND emp.empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ':' || ename);
--����ó����(�ɼ�)
END;
/

exec printtemp(7499);

-- procedure ���� �ǽ�
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



