

--PRIMARY KEY ���� : UNIQUE + NOT NULL

UNIQUE : �ش� �÷��� ������ ���� �ߺ��� �� ����.
        (EX : emp���̺���empno(���)
                dept���̺��� deptno(�μ���ȣ)
        �ش� �÷��� NULL���� �� �� �ִ�.
        
NOT NULL : ������ �Է½� �ش� �÷��� ���� �ݵ�� ���;� �Ѵ�.

--�÷� ������ PRIMARY KEY ���� ����
--����Ŭ�� �������� �̸��� ���Ƿ� ����(SYS-C000701)
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    
--����Ŭ ���������� �̸��� ���Ƿ� ���
--PRIMARY KEY : pk_���̺��
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_test_test PRIMARY KEY, ;
    
--PAIRWISE : ���� ����
--����� PRIMARY KEY ���� ������ ��� �ϳ��� �÷��� ���������� ����
--���� �÷��� �������� PRIMARY KEY �������� ������ �� �ִ�.
--�ش� ����� ���� �� ���� ���� ó�� �÷� ���������� ������ �� ����.
--> TABLE LEVEL ���� ���� ����

--������ ������ dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--�÷������� �ƴ�, ���̺� ������ �������� ����
CREATE TABLE dept_test(
    deptno NUMBER(2), 
    dname VARCHAR2(14),
    loc VARCHAR2(13),   --������ �÷� ���� �� �ĸ� ������ �ʱ�

    --deptno, dname �÷��� ������ ������(�ߺ���) �����ͷ� �ν�    
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname)
);

--�μ���ȣ, �μ��̸� ���������� �ߺ� �����͸� ����
--�Ʒ� �ΰ��� insert ������ �μ���ȣ�� ������
--�μ����� �ٸ��Ƿ� ���� �ٸ� �����ͷ� �ν� --> INSERT ����
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');

SELECT *
FROM dept_test;

--�ι�° INSERT ������ Ű ���� �ߺ��ǹǷ� ����
INSERT INTO dept_test VALUES(99, '���', 'û��');
INSERT INTO dept_test VALUES(99, 'û��', 'û��');

--NOT NULL ��������
--�ش� �÷��� NULL���� ������ ���� ������ �� ���

DROP TABLE dept_test;

--�÷������� �ƴ�, ���̺� ������ �������� ����
--dname �÷��� NULL ���� ������ ���ϵ��� NOT NULL �������� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY, 
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

--deptno �÷��� primary key ���࿡ �ɸ��� �ʰ�
--loc �÷��� NULLABLE�̱� ������ NULL ���� �Է� �� �� �ִ�.
INSERT INTO dept_test VALUES(99, 'ddit', NULL);
--deptno �÷��� primary key ���࿡ �ɸ��� �ʰ�(�ߺ��� ���� �ƴϴϱ�)
--dname �÷��� NOT NULL ���������� ����
INSERT INTO dept_test VALUES(98, NULL, '����');


DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY, 
    --deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    --dname VARCHAR2(14) NOT NULL,
    dname VARCHAR2(14) CONSTRAINT NN_dname NOT NULL,
    loc VARCHAR2(13)
);

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY, 
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    --CONSTRAINT pk_dept_test PRIMARY KEY(deptno, dname)
    --CONSTRAINT NN_dname NOT NULL(dname) : --������ ����
);

--1.�÷�����
--2.�÷����� �������� �̸� ���̱�
--3.���̺� ����
--[4.���̺� ������ �������� ����]

--UNIQUE ��������
--�ش� �÷��� ���� �ߺ��Ǵ� ���� ����
--�� NULL ���� ���
--GLOBAL Solution�� ��� ������ ���� ���� ������ �ٸ��� ������
--PK ���ຸ�ٴ� UNIQUE ������ ����ϴ� ���̸�, ������ ���� ������
--APPLICATION �������� üũ�ϵ��� �����ϴ� ������ �ִ�.

--���� ������ ���̺� ����(drop)
DROP TABLE dept_test;

--�÷� ���� UNIQUE ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY, 
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);



--�ΰ��� INSERT ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ����������
--����� �� ����
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����');

--<< UNIQUE ���� 3 >>
DROP TABLE dept_test;
--���̺� ���� unique ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),

    CONSTRAINT IDX_U_dept_test_01 UNIQUE (dname)
);
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����');


--FOREIGN KEY ��������
--�ٸ� ���̺� �����ϴ� ���� �Է� �� �� �ֵ��� ����

--emp_test.deptno -> dept_test.deptno �÷��� �����ϵ���
--FOREIGN KEY ���� ���� ����

--dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--dept_test ���̺� ���� (deptno �÷� PRIMARY KEY ����)
--dept ���̺�� �÷��̸�, Ÿ�� �����ϰ� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13) );
INSERT INTO dept_test VALUES(99, 'DDIT', 'daejeon');
COMMIT;

DESC emp;
--empno, ename, deptno : emp_test
--empno PRIMARY KEY
--deptno dept_test.deptno FOREIGN KEY

--�÷� ���� FOREIGN KEY
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno) );
    
--dept_test ���̺� �����ϴ� deptn�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);

--dept_test ���̺� �������� �ʴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 98); --98 : parent key not found


--emp_test ����
DROP TABLE emp_test;

-->>>
--�÷� ���� FOREIGN KEY(�������� �� �߰�)
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
--    empno NUMBER(4) CONSTRAINT ���������̸� PRIMARY KEY,
    ename VARCHAR2(10),
--    deptno NUMBER(2) REFERENCES dept_test (deptno) );
    deptno NUMBER(2),
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) );
    
--dept_test ���̺� �����ϴ� deptn�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);

--dept_test ���̺� �������� �ʴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 98); --98 : parent key not found

DELETE dept_test
WHERE deptno = 99;
--> �μ������� ������� ��������ϴ� �μ���ȣ�� �����ϴ� ���������� ���� �Ǵ� deptno �÷��� NULL ó�� 
--> EMP -> DEPT


----�ܷ�Ű FOREIGN KEY ���ǻ���
--�����Ϸ��� �÷��� �ε����� �����Ǿ� �־�� �Ѵ�.
--emp_test.deptno -> dept_test.deptno
--dept_test ���̺� deptno �÷��� �����÷����� �ϴ� �ε����� �����Ǿ� �־���Ѵ�
--�����Ϸ��� �÷��� �ε����� �����Ǿ� �־�� �Ѵ�
--    ���̺��� �����Ϳ��� ������ ����
--    �ε����� ���ٸ� ���̺��� ��� �����͸� �˻�
--    >�ε����� ���� �ӵ� ���� ����
--    Oracle������ �ӵ����� �̽��� �ε����� �ݵ�� �����ϵ��� ����
--    dept_test ���̺� �ε����� ������ ������ ���� ����
--        ->PRIMARY KEY = UNIQUE + NOT NULL
--        UNIQUE �������� ������ �ش� �÷����� UNIQUE INDEX �ڵ�����
--
--<< OPTION >>
--    ON DELETE CASCADE : �θ������ �����ϰ� �ִ� �ڽ� �÷��� �����͵� ���� ����
--    ON DELETE SET NULL : �θ������ �����ϰ� �ֶ� �ڽ� �÷��� �����͸� NULL�� ����


--<<<< �ܷ�Ű OPTION �׽�Ʈ >>>>
--1
--���� ���̺� ����(DROP)
DROP TABLE emp_test;
--FOREIGN KEY OPTION -ON DELETE CASCADE
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE CASCADE);
    
--dept_test ���̺� �����ϴ� deptn�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

--������ �Է� Ȯ��
SELECT *
FROM emp_test;

--ON DELETE CASCADE �ɼǿ� ���� dept �����͸� ������ ��� �ش� �����͸� �����ϰ� �ִ� EMP���̺��� ��� �����͵� �����ȴ�.
DELETE dept_test
WHERE deptno = 99;
ROLLBACK;


--2
--���� ���̺� ����(DROP)
DROP TABLE emp_test;
--FOREIGN KEY OPTION -ON DELETE SET NULL
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE SET NULL);
    
--dept_test ���̺� �����ϴ� deptn�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

--������ �Է� Ȯ��
SELECT *
FROM emp_test;

--ON DELETE SET NULL �ɼǿ� ���� dept �����͸� ������ ��� �ش� �����͸� �����ϰ� �ִ� EMP���̺��� deptno�÷��� NULL�� ����
DELETE dept_test
WHERE deptno = 99;


--CHECK ��������
--�÷��� ���� ���� ������ ��
--EX : �޿� �÷����� ���� 0 ���� ū ���� ������ üũ
--      ���� �÷����� ��/�� Ȥ�� F/M ���� ������ ����
--
--emp_test ���̺� ����(DROP)
DROP TABLE emp_test;

--emp_test ���̺� �÷�
--empno NUMBER(4)
--ename VARCHAR2(10)
--sal NUMBER(7,2)   --0���� ū ���ڸ� �Է� �ǵ��� ����
--emp_gb VARCHAR2(2) --���� ���� 01-������, 02-����
DESC emp;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER(7,2) CHECK (sal > 0),
    emp_gb VARCHAR2(2) CHECK (emp_gb IN('01', '02')) );

--emp_test �������Է�
INSERT INTO emp_test VALUES (9999, 'brown', -1, '01'); --sal �÷� check ��������(sal > 0)�� ���ؼ� ���� ���� �Է� �� �� ����.
INSERT INTO emp_test VALUES (9999, 'brown', 1000, '01'); --check �������� ���� ���� �����Ƿ� ���� �Է� (sal, emp_gb)
INSERT INTO emp_test VALUES (9999, 'sally', 1000, '03'); --emp_gb check ���ǿ� ���� (emp_gb IN('01', '02'))

--CHECK �������� �������� �̸� ����
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    --empno NUMBER(4) CONSTRAINT �������� �� PRIMARY KEY,
    
    ename VARCHAR2(10),
    --sal NUMBER(7,2) CHECK (sal > 0),
    sal NUMBER(7,2) CONSTRAINT C_SAL CHECK (sal > 0),
        
    --emp_gb VARCHAR2(2) CHECK (emp_gb IN('01', '02')) );    
    emp_gb VARCHAR2(2) CONSTRAINT C_EMP_GB
                                CHECK (emp_gb IN('01', '02')) );    
    
DROP TABLE emp_test;

--TABLE LEVEL CHECK �������� �̸�����
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    sal NUMBER(7,2),
    emp_gb VARCHAR2(2),

    CONSTRAINT nn_ename CHECK (ename IS NOT NULL),
    CONSTRAINT C_SAL CHECK (sal > 0),
    CONSTRAINT C_EMP_GB CHECK (emp_gb IN ('01', '02') )
    );    

--���̺� ���� : CREATE TABLE ���̺�� ( 
--                  �÷� �÷�Ÿ�� .....);

--���� ���̺��� Ȱ���ؼ� ���̺� �����ϱ�
-- Create Table AS : CTAS (��Ÿ��)
--      CREATE TABLE ���̺�� [(�÷�1, �÷�2, �÷�3...)] AS
--      SELECT col1, col2..
--      FROM �ٸ� ���̺��
--      WHERE ����
--      

--emp_test ���̺� ����(DROP)
DROP TABLE emp_test;

--emp ���̺��� �����͸� �����ؼ� emp_test ���̺��� ����
CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

SELECT *
FROM emp_test
INTERSECT
SELECT *
FROM emp;
emp - emp_test = ������
emp_test - emp = ������
SELECT *
FROM emp
MINUS
SELECT *
FROM emp_test;

--emp_test ���̺� ����(DROP)
DROP TABLE emp_test;

--<< CTAS (��Ÿ��) >>
--emp ���̺��� �����͸� �����ؼ� emp_test ���̺��� �÷����� �����Ͽ� ����
CREATE TABLE emp_test (c1, c2, c3, c4, c5, c6, c7, c8) AS
    SELECT *
    FROM emp;

SELECT *
FROM emp_test;

--emp_table ���̺� ����
DROP TABLE emp_test;

--�����ʹ� �����ϰ� ���̺��� ��ü(�÷� ����)�� �����Ͽ� ���̺� ����
CREATE TABLE emp_test AS 
    SELECT *
    FROM emp
    WHERE 1=2;

--<< CTAS (��Ÿ��) >>
--������ ����� ���̺� CREATE
CREATE TABLE emp_20191209 AS
SELECT *
FROM emp;

--<< Table - create table as : CTAS (��Ÿ��) >>
--NOT NULL ���� �����̿��� ���������� ������� �ʴ´�.
--���߽�
--    ������ ���
--    �׽�Ʈ ����

--<< Table - alter >>
--�̹� ������ ���̺���
--    ���ο� �÷� �߰�
--    �÷� ���� / ����
--        > �����Ͱ� �ִ� �÷��� ��� �÷� ���� ������ ����
--        > ����� ����� ���
--    �������� �߰�

DROP TABLE emp_test;

--empno, ename, deptno �÷����� emp_test ����
CREATE TABLE emp_test AS
    SELECT empno, ename, deptno
    FROM emp
    WHERE 1=2;

SELECT *
FROM emp_test;

--emp_test ���̺� �ű� �÷� �߰�
--HP VARCHAR2(20) DEFAULT '010'
--ALTER TABLE ���̺�� ADD (�÷��� �÷� Ÿ�� [default value]);
ALTER TABLE emp_test ADD (hp VARCHAR2(20) DEFAULT '010');

--���� �÷� ����
--ALTER TABLE ���̺�� MODIFY (�÷� �÷� Ÿ�� [default value]);
--hp �÷� Ÿ���� VARCHAR2(20) -> VARCHAR2(30)
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));

--���� emp_test ���̺� �����Ͱ� ���� ������ �÷� Ÿ���� �����ϴ°��� �����ϴ�
ALTER TABLE emp_test MODIFY (hp NUMBER);
DESC emp_test;

--�÷��� ����
--�ش� �÷��� PK, UNIQUE, NOT NULL, CHECK���� ���ǽ� ����� �÷��� ���ؼ��� �ڵ������� ������ �ȴ�.
--hp �÷� hp_n
--ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �����÷���;
















