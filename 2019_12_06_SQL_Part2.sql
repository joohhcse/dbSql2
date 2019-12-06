
--SQL PART 2

--����Ŭ�� ��ǥ�� ��ü��
--Table : ������ �����(��������X)
--Index : ��ȸ�� ��������� ���� ������ �÷������� �����س��� ��ü
--View : ������ ��ȸ ������ ��ü�� �����Ͽ� �����ϱ� ���� ��ü
--Sequence : �ߺ����� �ʴ� ���ڸ� ����
--Synonym : ����Ŭ ��ü�� ��Ī

--���̺� �÷��� ��Ģ
-->�����ڷ� �����ؾ� �Ѵ�
-->���̴� 1-30����
-->���ĺ� ��ҹ��� _ $ # �� ����
-->�ش� ������ ������ �ٸ� ��ü�� �̸��� ��ġ�� �ȵ�
-->����Ŭ Ű����� ��ü���� ������ �� ����

--DROP
--���̺� ��ü�� �����ϴ� query
--DROP (DDL) ROLLBACK �ȵ�

--DDL : TABLE ����
--CREATE TABLE [����ڸ�.]���̺��(
--    �÷���1 �÷�Ÿ��,
--    �÷���1 �÷�Ÿ��, ...
--    �÷���N �÷�Ÿ��N
-- ranger_no NUMBER         : ������ ��ȣ
-- ranger_nm VARCHAR2(50)   : ������ �̸�
-- reg_dt DATE              : ������ �������
-- ���̺� ���� DDL : Data Definition Language(������ ���Ǿ�)
-- DDL rollback�� ����(�ڵ�Ŀ�� �ǹǷ� rollback�� �� �� ����)

CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE
);

DESC ranger;
--DDL ������ ROLLBACK ó���� �Ұ�!!

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'RANGER'; --����Ŭ������ ��ü ������ �ҹ��ڷ� �����ϴ��� ���������δ� �빮�ڷ� �����Ѵ�.


INSERT INTO ranger VALUES(1, 'brown', SYSDATE);
--�����Ͱ� ��ȸ�Ǵ°� Ȯ����
SELECT *
FROM ranger;

-- DML���� DDL�� �ٸ��� ROLLBACK�� �����ϴ�
ROLLBACK;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--Oracle �ֿ� Data Type
--VARCHAR2(size) : �������� ���ڿ� size : 1~4000 byte
--CHAR(������) : size���� �۰� �ؽ�Ʈ �Է��ϸ� ���������� �� ����
--NUMBER(p, s) : �ε��Ҽ��� (p: ��ü�ڸ���, s: �Ҽ��� �ڸ���)
--DATE : ���ڿ� �ð����� / �ð��� �ʴ������� ���� / 7 byte���� 
--        ���ڸ� �����ϱ� ���� (yyyymmdd) 8byte ���ڿ��� ����ϴ� ��쵵 ����
--CLOB : Character Large Object : �幮�� ���ڿ� (�ִ� 4GB)
--BLOB : Binary Large Object : ���̳ʸ� ������ (�ִ� 4GB) / �߿��� ������ ��� db�� ���̳ʸ� ���·� ����
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


--DATE Ÿ�Կ��� �ʵ� �����ϱ�
--EXTRACT(�ʵ�� FROM �÷� / expression)
SELECT TO_DATE(SYSDATE, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'mm') mm,
        EXTRACT(year FROM SYSDATE) ex_yyyy
FROM dual;

SELECT EXTRACT(year FROM SYSDATE) ex_yyyy
FROM dual;

--DDL (Table - ��������)
--��������
--    �������� ���Ἲ�� ��Ű�� ���� ����
--        NOT NULL
--            �÷��� ���� �ݵ�� ���;� �Ѵ�.
--        UNIQUE
--            �ش� �÷� �� ���� ���� ���� ���� ����� ��
--            �÷� ���� ���յ� ����
--        PRIMARY KEY = UNIQUE + NOT NULL
--        FOREIGN KEY 
--            �ش� �÷��� �����ϴ� �ٸ� ���̺� ���� ���� �ؾ���
--        CHECK
--            �÷��� ��� �� �� �ִ� ���� ����
--        FOREIGN KEY

--���̺� ������ �÷� ���� �������� ����
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
--dept_test ���̺��� deptno �÷��� PRIMARY KEY ���������� �ֱ� ������
--deptno�� ������ �����͸� �Է��ϰų� ������ �� ����.
--���� �������̹Ƿ� �Է¼���
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');

--dept_test �����Ϳ� deptno�� 99���� �����Ͱ� �����Ƿ�
--primary key �������ǿ� ���� �Է� �� �� ����
INSERT INTO dept_test VALUES(99, '���', '����');

--ORA-00001 unique constraint ���� ����
--����Ǵ� �������Ǹ� SYSTEM.SYS_C007094 �������� ����
--SYS-C007105 ���������� � ���� �������� �Ǵ��ϱ� ����Ƿ�
--�������ǿ� �̸��� �ڵ� �꿡 ���� �ٿ��ִ� ���� ���������� ���ϴ�


--���̺� ���� �� �������� �̸��� �߰��Ͽ� �����
--primary key : pk_���̺��
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

--INSERT ���� ����
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');







