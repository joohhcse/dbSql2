
/******************************************************/
/******************************************************/
/**********************SQL ����*************************/
/******************************************************/
/******************************************************/

--------------------SQL ����--PART3

--multiple insert
--emp ���̺��� empno, ename �÷����� emp_test, emp_test2 ���̺��� ����(CTAS, �����͵� ���� ����)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--unconditional insert
--���� ���̺� �����͸� ���� �Է�
--brown, cony �����͸� emp_test, emp_test2 ���̺� ���ÿ� �Է�
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
-- ���̺� �� �ԷµǴ� �������� �÷��� ���� ����
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
--���ǿ� ���� ���̺� �����͸� �Է�

/*
    CASE
        WHEN ���� THEN --
        WHEN ���� THEN --
        ELSE --
    END
*/

ROLLBACK;
--3�� ���� ���Ե� --INSERT ALL
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

--2�� ���� ���Ե� --INSERT FIRST
INSERT FIRST
    WHEN eno > 9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno > 9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;



