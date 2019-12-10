
--�������� Ȱ��ȭ / ��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE OR DISABLE CONSTRAINT �������Ǹ�;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_TEST';

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007118;

SELECT *
FROM dept_test;

--dept_test ���̺��� deptno �÷��� ����� PRIMARY KEY ���������� ��Ȱ��ȭ�Ͽ� ������ �μ� ��ȣ�� ���� �����͸� �Է��� �� �ִ�.
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'DDIT', '����');

--dept_test ���̺��� PRIMARY KEY �������� Ȱ��ȭ
--�̹� ������ ������ �ΰ��� INSERT������ ���� ���� �μ���ȣ�� ���� �����Ͱ� �����ϱ� �빮�� PRIMARY KEY ���������� Ȱ��ȭ �� �� ����.
--Ȱ��ȭ�Ϸ��� �ߺ������͸� �����ؾ� �Ѵ�.
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007118;    --error

--�μ���ȣ�� �ߺ��Ǵ� �����͸� ��ȸ�Ͽ�
--�ش� �����Ϳ� ���� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� �ִ�.
SELECT deptno, COUNT(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >= 2;


--table_name, constraint_name, column_name
--position ���� (ASC)
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns
WHERE table_name = 'BUYER';

--���̺� ���� ����(�ּ�) VIEW
SELECT *
FROM user_tab_comments;

--���̺� �ּ�
--COMMENT ON TABLE ���̺�� IS '�ּ�';
COMMENT ON TABLE dept IS '�μ�';


--�÷� �ּ�
--COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�';
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ ����';

SELECT *
FROM user_col_comments
WHERE table_name = 'DEPT';


--comment1 �ǽ�
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
--    �÷�����
--    ���� ����ϴ� ������� ��Ȱ��
--    ���� ���� ����
    
--VIEW�� QUERY �̴� (O)
--���̺�ó�� �����Ͱ� ���������� �����ϴ� ���� �ƴϴ�. ������ ������ ���� ����
--���� ������ �� = QUERY
--VIEW�� ���̺� �̴� (X)
--VIEW ���� ���� �ʿ�
--    > system �������� ����
--VIEW�� �����ϴ� ���̺��� �����ϸ� VIEW���� ������ ��ģ��.


--VIEW ����
--CREATE OR REPLACE VIEW ���̸� [(�÷���Ī1, �÷���Ī2...)] AS
--SUBQUERY

--emp ���̺��� sal, comm �÷��� ������ ������ 6�� �÷��� ��ȸ�� �Ǵ� view -> v_emp �̸����� ����
CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

DESC emp;

--SYSTEM �������� �۾�
--VIEW ���� ������ JOO ������ �ο�
GRANT CREATE VIEW TO JOO;

SELECT *
FROM v_emp;

--INLINE VIEW
SELECT *
FROM
(SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp);

--emp ���̺��� �����ϸ� view�� ������ ������?
--KING �μ���ȣ�� ���� 10��
--emp ���̺��� KING�� �μ���ȣ �����͸� 30�����μ���(COMMIT���� ����)
--v_emp ���̺��� KING�� �μ���ȣ�� ����
UPDATE emp SET deptno = 30
WHERE ename = 'KING';

SELECT *
FROM emp
WHERE ename = 'KING';

ROLLBACK;

--���ε� ����� view�� ����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--emp ���̺��� KING ������ ����(COMMIT ���� ����)
DELETE emp
WHERE ename = 'KING';

SELECT *
FROM emp;
WHERE ename = 'KING';

--emp ���̺��� KING ������ ���� �� v_emp_dept view�� ��ȸ ��� Ȯ��
SELECT *
FROM v_emp_dept;

--INLINE VIEW
SELECT *
FROM
(SELECT emp.empno, ename, job, mgr, hiredate, deptno
FROM emp);

--emp ���̺��� empno �÷��� eno�� �÷��̸� ����
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno;

SELECT *
FROM v_emp_dept;

ROLLBACK;

--VIEW ����
--v_emp ����
DROP VIEW v_emp;

--DDL(View)
--VIEW DML
--    VIEW�� ���� : Simple VIew, Complex View
--    ���� ����, �� ���� ���� ����
--        >GROUP BY ���
--        >DISTINCT ���
--        >ROWNUM ���
--    Seqeunce
--        �����Ϳ� KEY �÷��� ���� �����ؾ� ��
--        ������ ���� ����� ���
--            >KEY TABLE (�̸� ���� ���� �ص� ���̺�)
--            >UUID / Ȥ�� ������ ���̺귯��
--            >sequence
--        ������ ���� ���� ������ �ִ� ����Ŭ ��ü
--            >pk�÷��� ������ ������ �� ����
--        ĳ�� ����� ���� �ӵ� ���            


--�μ��� ������ �޿� �հ�
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
--����Ŭ��ü�� �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
--CREATE SEQUENCE �������� 
--[�ɼ�...]
CREATE SEQUENCE seq_board;

--SEQUENCE
--NEXTVAL
--    �������� ���� ���� ��ȸ
--CURRVAL
--    ���� ������ ���� ��ȸ
--    NEXTVAL�� ���� ���� ������ �ڿ� ��밡��

--SEQEUNCE OPTION
--INCREMENT BY n : ������ ����ġ
--START WITH N : ������ ���� ��
--MAXVALUE n | NOMAXVALUE
--    ������ �ִ밪 | ���Ѵ�(9999...)
--MINVALUE n | NOMINVALUE
--    ������ �ּҰ� | ���Ѵ�(9999...)
--
--CACHE n | NOCACHE
--    >ĳ���� ����
--    >Unique �� ���� �����ؾ� �ϹǷ� ���ü� ��� �ʿ�
--    >�� ������ ��ü�� �����ϱ� ���� lock�� �ʿ��ѵ� �޸𸮿� �̸� �÷��ξ� lock������ �ؼ� �� �� �ִ�.
--    >�� ĳ�̵� ������ ������ �̹� ����� �Ȱ�
--    >ROLLBACK�ص� �������� �ʴ´�
--    >����ڰ� �������� ������� �ʾƵ� ������ ��⵿ �ϸ� ĳ�̵Ǿ��� ������ ���� ��������
--    >ĳ�� ����
--        -CACHE 20
--        -���������� ����� �� : 5
--        -���� ��⵿�� �ش� �������� 21���� ����
--    ORDER n | NOCACHE
--        ORACLE RAC ȯ�氰�� ��Ƽ ��������
--    CYCLE | NOCYCLE
--        �ִ밪 ���޽� �ּҰ����� �ٽ� �������� ����
--Sequence ���� / ����
--    ALTER SEQUENCE seq_emp CACHE 10;
--    DROP SEQUENCE seq_emp;

--������ ����� : ��������.nextval
SELECT seq_board.nextval
FROM dual;

SELECT seq_board.currval
FROM dual;


--DDL(Index)
--Index
--    -���̺��� �Ϻ� �÷��� �������� �����͸� ������ ��ü
--    -���̺��� row�� ����Ű�� �ּҸ� ���� �ִ�.(rowid)
--    -���ĵ� �ε����� �������� �ش� row�� ��ġ�� ������ �˻��Ͽ�
--    -���̺��� ���ϴ� �࿡ ������ ����
--    -���̺� �����͸� �Է��ϸ� �ε��� ������ ���ŵȴ�.
--Table
--    -�Է� ������� ������ ���� : �� �������� ���
--    -DELETE ������ �� �������� ��� ����
--    -��뷮 ���̺� �׼��� �� ������ ��� �б� �߻�
--        > multi block I/O
--Index
--    -�ּ����� ������ ��� �б⸦ ���� ���� ���
--    -��ǥ Ű�� row�� �ּ� ����(rowid)�� �̸� ����
--        >��ǥ Ű ���� ���� �̸� ���ĵ� �ε����� ���� �˻����row�� �ٷ� �׼���
--        >rowid�� ���� �׼����� ���� ���� ��ȸ ���
--    -��� ������ �׼��� : ���� ���� ���� ��ũ I/O
--        >single block I/O
        
-- table�� �ε��� scan / Index ���� /  

SELECT rowid, rownum, emp.*
FROM emp;


--emp ���̺� empno �÷����� PRIMARY KEY ���� ���� : pk_emp
--dept ���̺� deptno �÷����� PRIMARY KEY ���� ���� : pk_dept
--emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� �����ϵ��� FOREIGN KEY ���� �߰� : fk_dept_deptno
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY (deptno)
            REFERENCES dept (deptno);

--emp_test ���̺� ����
DROP TABLE emp_test;

--emp ���̺��� �̿��ؼ� emp_test ���̺� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test ���̺��� �ε����� ���� ����
--���ϴ� �����͸� ã�� ���ؼ��� ���̺��� �����͸� ��� �о���� �Ѵ�.
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

--�����ȹ�� ���� 7369 ����� ���� ���� ������ ��ȸ�ϱ� ���� ���̺��� 
--��� ������(14)�� �о� �������� ����� 7369�� �����͸� �����Ͽ� ����ڿ��� ��ȯ 
--**13���� �����ʹ� ���ʿ��ϰ� ��ȸ �� ����

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

--�����ȹ�� ���� �м��� �ϸ�
--empno �� 7369�� ������ index�� ���� �ſ� ������ �ε����� ����
--���� ����Ǿ� �ִ� rowid ���� ���� table�� ������ �Ѵ�
--table���� ���� �����ʹ� 7369��� ������ �ѰǸ� ��ȸ�� �ϰ� 
--������ 13�ǿ��� ���ؼ��� ���� �ʰ� ó��
-- 14--> 1
-- 1--> 1




