
--����̸�, �����ȣ, ��ü�����Ǽ�
SELECT ename, empno, COUNT(*),
FROM emp
GROUP BY ename, empno;


--ana0
SELECT ename, sal, deptno 
FROM emp
ORDER BY deptno, sal DESC;


--DB�� �� --ana0
SELECT a.ename, a.sal, a.deptno, b.rn
FROM 
(SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC)) a,
(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM 
    (SELECT ROWNUM rn
     FROM dual
     CONNECT BY level <= (SELECT COUNT(*) FROM emp)) a,
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn )) b
WHERE a.j_rn = b.j_rn;
--DB�� ��--

--ana0�� �м��Լ���
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) row_number
FROM emp;

--����� ��ü�޿� ����
--ana1
SELECT ename, sal, deptno,
        ROW_NUMBER() OVER (ORDER BY sal DESC) sal_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC) sal_row_number
--        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) dense_rank,
--        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal ) row_number
FROM emp;
    


SELECT ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;
    

--no_ana2
--������� ���� �����ȣ , ����̸�, �ش� ����� ���� �μ��� ������� ��ȸ
--�м��Լ� �Ⱦ�
SELECT b.empno, b.ename, b.deptno, a.cnt
FROM
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno) a,
    (SELECT empno, ename, deptno
    FROM emp) b
WHERE a.deptno = b.deptno
ORDER BY b.deptno;


--�����ȣ, ����̸�, �μ���ȣ, �μ��� ������
SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--ana2
SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg
FROM emp;

--ana3
SELECT empno, ename, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;
--ana4
SELECT empno, ename, deptno,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;


--ana5
-- ��ü����� ������� �޿������� �ڽź��� �Ѵܰ� ���� ����� �޿�
-- (�޿��� ���� ��� �Ի����ڰ� ���� ����� ���� ����) 
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
ORDER BY sal DESC, hiredate;

SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
ORDER BY sal DESC, hiredate;

--ana6
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

--no_ana3
--test
SELECT ROWNUM e_rn, e.empno, e.ename, e.sal
FROM 
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) e;

--test
SELECT e2.e_rn, e2.sal, DECODE(e2.sal, 
FROM
    (SELECT ROWNUM e_rn, e.empno, e.ename, e.sal
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) e) e2;

--no_ana3
SELECT e2.empno, e2.ename, e2.sal, SUM(sal) OVER(ORDER BY sal) c_sum
FROM   
    (SELECT ROWNUM rn
    FROM dual
    CONNECT BY level <= (SELECT COUNT(*) FROM emp)) d,
    (SELECT ROWNUM e_rn, e.empno, e.ename, e.sal
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) e) e2
WHERE d.rn = e2.e_rn;





















