

--��Ī : ���̺�, �÷��� �ٸ� �̸����� ��Ī
--    [AS] ��Ī��
--    SELECT empno [AS] eno
--    FROM emp e
--    
--    SYNONYM(���Ǿ�)
--    ����Ŭ ��ü�� �ٸ��̸����� �θ� �� �ֵ��� �ϴ� ��
--    ���࿡ emp ���̺��� e��� �ϴ� synonym(���Ǿ�)�� ������ �ϸ�
--    ������ ���� SQL�� �ۼ��� �� �ִ�.
--    SELECT *
--    FROM e;

--���� ������ SYNONYM ���� ������ �ο�
GRANT CREATE SYNONYM TO JOO;
    
--    emp ���̺��� ����Ͽ� synonym e�� ����
--CREATE SYNONYM �ó�� �̸� FOR ����Ŭ��ü;    
CREATE SYNONYM e FOR emp;

--emp ��� ���̺� �� ��ſ� e��� �ϴ� �ó���� ����Ͽ� ������ �ۼ� �� �� �ִ�
SELECT *
FROM e;

--JOO ������ fastfood ���̺��� hr���������� �� �� �ֵ��� ���̺� ��ȸ ������ �ο�
GRANT SELECT ON daily TO hr;

SELECT *
FROM sem.fastfood;
-- sem.fastfood --> fastfood �ó������ ����
-- ������ ���� sql�� ���������� �����ϴ��� Ȯ��
CREATE SYNONYM fastfood FOR sem.fastfood;


SELECT *
FROM fastfood;
SELECT *
FROM USER_TABLES;
SELECT *
FROM ALL_TABLES
WHERE OWNER = 'JOO';

--Data dictionary ��ȸ
SELECT *
FROM dictionary;

--Oracle ��ü ����
SELECT *
FROM user_objects;
SELECT *
FROM all_objects;
SELECT *
FROM dba_objects;
--table ���̺� ����
SELECT * FROM user_tables;
SELECT * FROM all_tables;
SELECT * FROM dba_tables;
--tab_columns ���̺��� �÷� ����
--...
--indexes �ε��� ����
--...
--ind_columns �ε��� �÷� ����
--...
--constraints �������� ����
--...
--cons_columns �������� �÷� ����
--...


-- ������ SQL�� ���信 ������ �Ʒ� SQL���� �ٸ���
SELECT /*201911_205*/ * FROM emp;
SELECT /*201911_205*/ * FROM EMP;
SELECt /*201911_205*/ * FROM EMP;

SELECt /*201911_205*/ * FROM EMP WHERE empno = 7369;
SELECt /*201911_205*/ * FROM EMP WHERE empno = 7499;
SELECt /*201911_205*/ * FROM EMP WHERE empno = :empno;


/******************************************************/
--system �������� ��ȸ�ϱ�
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%201911_205%';
/******************************************************/

    
    
    
    