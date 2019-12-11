

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

--INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� �����͸� ����� �� �� �ִ� ���

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

--emp ���̺��� ��� �÷��� ��ȸ
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

--emp ���̺��� empno �÷��� ��ȸ --����
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

--DDL(unique Index�� �ִٸ� : PK = unique + not null
--unique index
--    >�ε��� �÷��� �ߺ��Ǵ� ���� ������ �� ����.
--    >row���� �ٸ���
--    >ex : pk �÷�
--    PK ������ �����ϸ� empno ���� �������� �ε��� ����
--        > empno���� �������� ����
--    PK������ unique + not null �̹Ƿ� pk �÷��� �ش��ϴ� ���� �ش� ���̺� �ѹ��� �������� ����
--    �ε����� ���ĵ� �����̹Ƿ� ã���� �ϴ� ���� ��ġ�� ������ �˻�
--    �ε����� ����� rowid �� ���� ���̺��� �� ��ġ�� ã�� �ʿ���ϴ� ������ �÷����� ���̺��� ���� ��ȸ
--    ����ڰ� ��û�� �����ʹ� empno �÷� �ϳ��̹Ƿ� ���� ���̺� ������ �ʿ䰡 ����
--    ���̺� ���� ���� �ε��� unique scan���� �˻� ����
        
--DDL(non-unique Index)�� �ִٸ�
--non-unique index
--    >�ߺ��� ������ �÷�
--    >ex : �ֹ� ���̺��� �ֹ�����
--    empno���� �������� non-unique �ε��� ����    p81
--        > empno���� �������� ����
--    non-unique index �̹Ƿ� ���� ���� ������ �� �� �ִ�.
--    �ε����� ���ĵ� ��ü�̹Ƿ� ã���� �ϴ� ���� ��ġ�� ������ �˻�
--        > empno=7782
--    non-unique �ε��� �̹Ƿ� ����ؼ� �ε����� ��ĵ�Ѵ�
--        > empno=7788�� ���� ������ ������ empno=7782 �� ���� �� �̻� �������� ������ �� �� �ִ�. (n+1 scan)
--    job���� �������� non-unique �ε��� ����    p83
--        job���� �������� ����
--    non-unique index �̹Ƿ� ���� ���� ������ �� �� �ִ�.
--    �ε����� ���ĵ� ��ü�̹Ƿ� ã���� �ϴ� ���� ��ġ�� ������ �˻�
--        >ename = 'MANAGER'
--        >rowid�� �̿��� ���̺� �����Ͽ� ������ �÷����� ��ȸ
--    non-unique �ε����̹Ƿ� ����ؼ� �ε����� ��ĵ�Ѵ�
--        >ename = 'PRESIDENT' �� ���� ������ ������ ename = 'MANAGER' �� ���� ���̻� �������� ������ �� ���ִ�. (n+1 scan)
--    job ���� �������� non-unique �ε��� ����   p85
--        >job���� �������� ����
--    non-unique index�̹Ƿ� ���� ���� ������ �� �� �ִ�.
--    �ε����� ���ĵ� ��ü�̹Ƿ� ã���� �ϴ� ���� ��ġ�� ������ �˻�
--        >job = 'MANAGER'
--        >rowid �� �̿��� ���̺� �����Ͽ� ������ �÷����� ��ȸ
--    ���̺� ������ ename LIKE 'C%' �� �����͸� filterling
--    3���� ���̺� �����Ϳ� ���� �� ���� ���ǿ� �����ϴ� 1�Ǹ� ��ȸ

--�����ε��� ����
--pk_emp �������� ���� --> unique ���� ���� --> pk_emp �ε��� ����
--INDEX ���� (�÷� �ߺ� ����)
--UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���
--              (emp.empno, dept.deptno)
--NON-UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��ɼ� �ִ� �ε���
--                  (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE idx_n_emp_01 ON emp (empno);

--���� ��Ȳ�̶� �޶��� ���� EMPNO�÷����� ������ �ε�����
--UNIQUE -> NON-UNIQUE �ε����� �����
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

--emp ���̺� job�÷����� non-unique �ε��� ����
--�ε����� : idx_n_emp_02
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

--IDX_02 �ε���
-- emp ���̺��� �ε����� 2�� ����
-- 1. empno
-- 2. job
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--IDX_03
--idx_n_emp_03
--emp ���̺��� job, ename �÷����� non-unique �ε��� ����
CREATE INDEX idx_n_emp_03 ON emp(job, ename);

SELECT job, ename, rowid
FROm emp
ORDER BY job, ename;

--idx_n_emp_04
-- ename, job �÷����� emp ���̺� non-unique �ε��� ����
CREATE INDEX idx_n_emp_04 ON emp( ename, job);
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

--JOIN ���������� �ε���
--emp ���̺��� empno�÷����� PRIMARY KEY ���������� ����
--dept ���̺��� deptno �÷����� PRIMARY KEY ���������� ����
--emp ���̺��� PRIMARY KEY ������ ������ �����̹Ƿ� �����
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
���� : 4 > 3 > 5 > 2 > 6 > 1 > 0

--DB�ǹ� --���� ���� ����
--TB_COUNSEL
--ACCESS PATH
--1. cims_cd(=)
--2. cs_rcv_id(=) , cs_rcv_dt(between)
--3. cs_rcv_dt(between), lv1 lv2 lv3 .. 

--�ε����� ���ְ� �ٽø��鶧 : ���̺� ������ ���� > 

--DDL ( index vs table full access )
--    index access
--        �Ҽ��� ������ ��ȸ�� ���� (����ӵ� �߿��Ҷ�)
--        I/O ������ single block : �ٷ� �����͸� �ε����� �����Գ� ���̺� ��ü��ȸ���� ������ ������
--        
--    Table full access
--        ���̺��� ��� �����͸� �о ó���ϴ� ����� �ε������� ����
--        I/O ������ multi block
--        ��ü ó�� �ӵ��� �߿��Ҷ�


DROP TABLE dept_test;
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS 
SELECT *
FROM dept
WHERE 1=1;

--deptno �÷����� UNIQUE INDEX
CREATE UNIQUE INDEX idx_u_dept_test_01 ON dept_test (deptno);   --CREATE INDEX idx_unique_dept ON dept_test (deptno);
--dname �÷����� NON_UNIQUE INDEX
CREATE INDEX idx_u_dept_test_02 ON dept_test (dname);   --CREATE INDEX idx_non_unique_dept ON dept_test (dname);
--deptno, dname �÷����� NON-UNIQUE INDEX
CREATE INDEX idx_u_dept_test_03 ON dept_test (deptno, dname);

--idx2
DROP INDEX idx_u_dept_test_01;
DROP INDEX idx_u_dept_test_02;
DROP INDEX idx_u_dept_test_03;











