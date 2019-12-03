
--crossjoin1
SELECT *
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

--burger
--���ù�������
SELECT *
FROM FASTFOOD;
--WHERE sido = '����������';
--GROUP BY GB;

--���ù��������� ���� ������ ����
--���� ���� ���� (����ŷ+�Ƶ�����+KFC)/�Ե����� ����
--���� / �õ� / �ñ��� / ���ù�������(�Ҽ��� ��°�ڸ����� �ݿø�)
--1 / ����Ư���� / ���ʱ� / 7.5
--2 / ����Ư���� / ������ / 7.2
SELECT *
FROM FASTFOOD;

SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
FROM FASTFOOD
WHERE GB = '����ŷ'
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
FROM FASTFOOD
WHERE GB = '����ŷ'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) kfc_cnt
FROM FASTFOOD
WHERE GB = 'KFC'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) mac_cnt
FROM FASTFOOD
WHERE GB = '�Ƶ�����'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) lotte_cnt
FROM FASTFOOD
WHERE GB = '�Ե�����'
GROUP BY sido, sigungu
ORDER BY sido;

--
SELECT 
FROM
    (SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
    FROM FASTFOOD
    WHERE gb = '����ŷ' OR gb = 'KFC' OR gb = '�Ƶ�����'
    GROUP BY sido, sigungu
    ORDER BY sido) a,
    
    (SELECT sido, sigungu, COUNT(sigungu) lotte_cnt
    FROM FASTFOOD
    WHERE GB = '�Ե�����'
    GROUP BY sido, sigungu
    ORDER BY sido) b;
WHERE GB IN ('����ŷ', 'KFC', '�Ƶ�����', '�Ե�����');

--
SELECT a.sido, a.sigungu, a.cnt
FROM    
    (SELECT sido, sigungu, COUNT(sigungu) cnt
    FROM FASTFOOD
    WHERE GB IN ('����ŷ', 'KFC', '�Ƶ�����', '�Ե�����')
    GROUP BY sido, sigungu
    ORDER BY sido) a
ORDER BY a.cnt DESC;


--Sol>>>
--�ش� �õ�, �ñ����� ��������� �Ǽ��� �ʿ�
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

    
--�ϳ��� SQL�� �ۼ����� ������
--FASTFOOD  ���̺��� �̿��Ͽ� �������� SQL ���� �����
--������ ����ؼ� ���� ���������� ���
--������ ������ 4/8 = 0.5
--������ ���� 4/8 = 0.5
--������ ���� 13/12 = 1.1
--������ �߱� 6/6 = 1
--������ ����� 2/7 = 0.3

SELECT *
FROM fastfood
WHERE sido = '����������';

SELECT *
FROM fastfood
WHERE sido = '����������'
AND GB IN('����ŷ', 'kfc', '�Ƶ�����');

SELECT *
FROM fastfood
WHERE sido = '����������'
AND GB IN('�Ե�����');



--�������� ���� ���� ���� -- ����û 1���� �� �ο쿡 �����ϱ�
SELECT *
FROM tax;










