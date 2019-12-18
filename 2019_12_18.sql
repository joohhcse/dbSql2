--�������� �̾...

--Sales Table Exercise
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;

SELECT DECODE(
FROM sales
GROUP BY TODA

SELECT DECODE(
FROM sales
GROUP BY TO_DATE(201901, 'MM');

SELECT *
FROM sales
WHERE dt = TO_DATE(201901, 'YYYYMM');

SELECT *
FROM sales
WHERE TO_CHAR(dt, 'YYYYMM') = '201901';

SELECT TO_CHAR(dt, 'MM'), SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


WITH a AS (
SELECT TO_CHAR(dt, 'MM') month, SUM(sales) sum
FROM sales
GROUP BY TO_CHAR(dt, 'MM')
)
SELECT 
    (SELECT sum FROM sales WHERE month = 01) "JAN",
FROM
    a
GROUP BY TO_CHAR(dt, 'MM');

--DB�� ��
SELECT /*1�� �÷�, 2�� �÷�,*/
    NVL(MIN(DECODE(mm, '01', sales_sum)), 0)JAN, NVL(MIN(DECODE(mm, '02', sales_sum)), 0)FEB, 
    NVL(MIN(DECODE(mm, '03', sales_sum)), 0)MAR, NVL(MIN(DECODE(mm, '04', sales_sum)), 0)APR, 
    NVL(MIN(DECODE(mm, '05', sales_sum)), 0)MAY, NVL(MIN(DECODE(mm, '06', sales_sum)), 0)JUN
FROM
    (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales) sales_sum
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM'));
--DB�� ��--

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'           -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (�̹� �о��� �༮)

/*
    dept0(XXȸ��)
        dept0_00(�����κ�)
            dept0_00_0(��������)
        dept0_01(������ȹ��)
            dept0_01_0(��ȹ��Ʈ)
                dept0_00_0_0(��ȹ��Ʈ)
        dept0_02(�����ý��ۺ�)
            dept0_02_0(����1��)
            dept0_02_1(����1��)
            
*/

--*********XXȸ��
SELECT LPAD('XX', 15, '*'),
        LPAD('XX', 15)
FROM dual;

--�����
--PRIOR p_deptcd = deptcd
--���� ���� ������.�����μ��ڵ� = ������ ���� ������.�μ��ڵ�

--��������
--h1
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'           -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;


--�����ý��ۺ��� ������ �μ����� ������ ����ȭ�ϴ� ���� 
--h2
SELECT dept_h.*
FROM dept_h;

SELECT LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'            -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (�̹� �о��� �༮)

SELECT LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'            -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;    -- PRIOR (�̹� �о��� �༮)
--h2--

SELECT *
FROM dept_h;

--h3
-- ��������(dept0_00_0)�� �������� ����� �������� �ۼ�
-- �ڱ� �μ��� �θ� �μ��� ������ �Ѵ�.
SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
--CONNECT BY deptcd = PRIOR p_deptcd;       --PRIOR �� ���� ���� ��
--CONNECT BY deptcd = PRIOR p_deptcd AND = PRIOR col2;
--h3--


create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

--h4
SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id, value, LEVEL
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
--h4--

--h5
--���������� ��ũ��Ʈ.sql ���̺� ����
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);
commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id, value, LEVEL
FROM no_emp
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

--h5 Answer
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd, LEVEL
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
----

SELECT *
FROM no_emp;
--h5--


-- pruning branch (����ġ��)
-- ���� ������ �������
-- FROM --> START WITH ~ CONNECT BY --> WHERE
-- ������ CONNECT BY ���� ����� ���
-- . ������ ���� ���� ROW�� ������ �ȵǰ� ����
-- ������ WHERE ���� ����� ���
-- . START WITH ~ CONNECT BY ���� ���� ���������� ���� �����
-- WHERE ���� ����� ��� ���� �ش��ϴ� �����͸� ��ȸ

--�ֻ��� ��忡�� ��������� Ž��

--CONNECT BY���� deptnm != '������ȹ��' ������ ����� ���
--WHERE ���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';

--FROM -> START WITH CONNECT BY -> WHERE

SELECT *
FROM dept_h
--WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;






-- ���� �������� ��� ������ Ư�� �Լ�
-- CONNNECT_BY_ROOT(col) ���� �ֻ��� row�� col ���� �� ��ȸ
-- SYS_CONNECT_BY_PATH(col, ������) : �ֻ��� row���� ���� �ο���� col���� �����ڷ� �������� ���ڿ�
-- CONNECT_BY_ISLEAF : �ش� ROW�� ������ �������(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path,
        CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


--h6
--�Խñ��� �����ϴ� board_test ���̺��� �̿��Ͽ� ���������� �ۼ��Ͻÿ�
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT *
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR parent_seq = seq;
ORDER SIBLINGS BY DECODE(parent_seq, NULL, seq,0, seq);

SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path,
        CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--h6
--DB�� ��
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;
--DB�� ��--

--h7(ORDER BY seq DESC), 8 (ORDER SIBLINGS BY)    
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;







