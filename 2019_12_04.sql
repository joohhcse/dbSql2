

--1. tax ���̺��� �̿� �õ�/�ñ����� �δ� �������� �Ű�� ���ϱ�
--2. �Ű���� ���� ������ ��ŷ �ο��ϱ�
--��ŷ(1) �õ�(2) �ñ���(3) �δ翬������_�Ű��(4)
--
--1   ����Ư���� ���ʱ� 7000
--2   ����Ư���� ������ 6000


SELECT *
FROM tax;



SELECT ROWNUM rn, a.sido, a.sigungu, a.cal_sal
FROM
    (SELECT sido, sigungu, sal, people, ROUND(sal/people, 1) cal_sal
    FROM tax
    ORDER BY cal_sal DESC) a;

--ex2)
SELECT ROWNUM rn, sido, sigungu, cal_sal
FROM
    (SELECT sido, sigungu, sal, people, ROUND(sal/people, 1) cal_sal
    FROM tax
    ORDER BY cal_sal DESC);


SELECT ROWNUM rn, sido, sigungu, ���ù�������
FROM
(SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) AS ���ù�������
FROM
    (SELECT sido, sigungu, COUNT(*) cnt  --����ŷ, KFC, �Ƶ����� �Ǽ�
    FROM fastfood
    WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt  --�Ե����� �Ǽ�
    FROM fastfood
    WHERE gb = '�Ե�����'
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC);

--OUTER JOIN >>>
-->> Sol>>
SELECT *
FROM
    (SELECT ROWNUM rn, sido, sigungu, cal_sal
    FROM
        (SELECT sido, sigungu, sal, people, ROUND(sal/people, 1) cal_sal
        FROM tax
        ORDER BY cal_sal DESC)) tx,
    (SELECT ROWNUM rn, sido, sigungu, ���ù�������
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) AS ���ù�������
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt  --����ŷ, KFC, �Ƶ����� �Ǽ�
            FROM fastfood
            WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, COUNT(*) cnt  --�Ե����� �Ǽ�
            FROM fastfood
            WHERE gb = '�Ե�����'
            GROUP BY sido, sigungu) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY ���ù������� DESC)) bg
WHERE tx.rn = bg.rn(+)
ORDER BY tx.rn;


--���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ�����
--���� �������� ����
--���ļ����� tax ���̺��� id �÷������� ����
SELECT bg.rn, bg.sido, bg.sigungu, bg.���ù�������,
        tx.rn, tx.sido, tx.sigungu, tx.cal_sal
FROM
    (SELECT ROWNUM rn, sido, sigungu, cal_sal
    FROM
        (SELECT sido, sigungu, sal, people, ROUND(sal/people, 1) cal_sal
        FROM tax
        ORDER BY cal_sal DESC)) tx,
    (SELECT ROWNUM rn, sido, sigungu, ���ù�������
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) AS ���ù�������
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt  --����ŷ, KFC, �Ƶ����� �Ǽ�
            FROM fastfood
            WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, COUNT(*) cnt  --�Ե����� �Ǽ�
            FROM fastfood
            WHERE gb = '�Ե�����'
            GROUP BY sido, sigungu) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY ���ù������� DESC)) bg
WHERE tx.sido(+) = bg.sido
AND tx.sigungu(+) = bg.sigungu
ORDER BY tx.rn DESC;

--UPDATE tax SET sigungu = TRIM(sigungu);
--COMMIT;

--SELECT *
--FROM fastfood;
--SELECT *
--FROM tax
--ORDER BY sal DESC;

--��������
--SUBQUERY


--SMITH�� ���� �μ� ã�� --> 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20; -- a = b = c --> a = c

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--SCALAR SUBQUERY
--SELECT ���� ǥ���� ���� ����
--�� ��, �� COLUMN�� ��ȸ�ؾ��Ѵ�
SELECT empno, ename, deptno,
        (SELECT dname FROM dept) dname
FROM emp;

--INLINE VIEW
--FROM ���� ���Ǵ� ��������

--SUBQUERY
--WHERE�� ���Ǵ� ��������

--sub1
--��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�Ͻÿ�
SELECT *
FROM emp;

--AVG(sal) : 2073.214
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

--sub2
--��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ�Ͻÿ�
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

--sub3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN('SMITH', 'WARD') );

--sub3
--1.SMITH, WARD�� ���� �μ� ��ȸ -->20, 30
--2.1���� ���� ������� �̿��Ͽ� �ش� �μ���ȣ�� ���ϴ� ���� ��ȸ
--(1)
SELECT deptno
FROM emp
WHERE ename IN('SMITH', 'WARD');
--(2)
SELECT *
FROM emp
WHERE deptno IN(20, 30);

--SMITH Ȥ�� WARD ���� �޿��� ���� �޴� ���� ��ȸ
SELECT *
FROM emp
WHERE sal <= ANY (SELECT sal     --800, 1250 --> 1250���� ���� ���
                    FROM emp 
                    WHERE ename IN('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE sal <= ALL (SELECT sal     --800 && 1250 --> 1250���� ���� ���
                    FROM emp 
                    WHERE ename IN('SMITH', 'WARD'));

--������ ������ ���� �ʴ� ��� ���� ��ȸ

--�����ڰ� �ƴ� ���
--NOT IN ������ ���� NULL�� �����Ϳ� �������� �ʾƾ� �������Ѵ�
SELECT *
FROM emp --��� ���� ��ȸ --> ������ ������ ���� �ʴ�
WHERE empno NOT IN (SELECT NVL(mgr, -1) --NULL ���� �������� �������� �����ͷ� ġȯ
                    FROM emp);

SELECT *
FROM emp --��� ���� ��ȸ --> ������ ������ ���� �ʴ�
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT NULL);


--multi column subquery (pairwise)
--pairwise (���� �÷��� ���� ���ÿ� �����ؾ� �ϴ� ���)
--ALLEN, CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� �ٸ� ��� ���� ��ȸ
--(7698, 30)
--(7839, 10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                        SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));

--�Ŵ����� 7698�̰ų� 7839�̸鼭
--�ҼӺμ��� 10�� �̰ų� 30���� ���� ���� ��ȸ
--7698, 10
--7698, 30
--7839, 10
--7839, 30
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499, 7782))
AND deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));


--���ȣ ���� ���� ����
--���������� �÷��� ������������ ������� �ʴ� ������ ���� ����

--���ȣ ���� ���������� ��� ������������ ����ϴ� ���̺�,
--���������� ��ȸ ������ ���������� ������ ������ �Ǵ��Ͽ� ������ �����Ѵ�.
--���������� emp ���̺��� ���� �������� �ְ�, ���������� emp���̺��� ���� ���� ���� �ִ�. 

--���ȣ ���� ������������ ���������� ���̺��� ���� ���� ����
--���������� ������ ������ �ߴٶ�� �� �������� ǥ��
--���ȣ ���� ������������ ���������� ���̺��� ���߿� ���� ����
--���������� Ȯ���� ������ �ߴٶ�� �� �������� ǥ��

--������ �޿� ��պ��� ���� �޿��� �޴� �������� ��ȸ
--������ �޿� ���
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

--��ȣ���� ��������
--�ش������� ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ
SELECT *
FROM emp m --m : main query
WHERE sal > (SELECT AVG(sal)
            FROM emp
            WHERE deptno = m.deptno);

--10�� �μ��� �޿����
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

