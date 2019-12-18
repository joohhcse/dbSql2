--EXERCISE


--��������
--�޷¸���� ��ǥ
-->�������� ���� ���� �ٲٴ� ���
-->����Ʈ �������� Ȱ�� �� �� �ִ� ���� ����

-- CONNECT BY LEVEL <= N
-- ���̺��� ROW�Ǽ��� N��ŭ �ݺ��Ѵ�
-- CONNECT BY LEVEL ���� ����� ����������
-- SELECT ������ LEVEL �̶�� Ư�� �÷��� ����� �� �ִ�.
-- ������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� ROWNUM�� �����ϳ�
-- ���� ���� �� START WITH, CONNECT BY ������ �ٸ����� ���� �ȴ�

-- 2019�� 11�� : 30�ϱ��� ����
-- 201911
-- ���� + ���� = ������ŭ �̷��� ��¥
-- 201911 --> �ش����� ��¥�� ���ϱ��� �����ϴ°�?
SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 30;

SELECT LAST_DAY() --30
FROM dual;

--201911 --> 30
--201912 --> 31
--202402 --> 29
--201902 --> 28
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') -- ��� : 30 , 29 ...
FROM dual;

--SELECT /*�Ͽ����̸� ��¥*/, /*ȭ�����̸� ��¥*/, .../*������̸� ��¥*/
SELECT 
        /*dt, d, iw,*/
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;
                    
                    
-------
SELECT 
        iw, /*dt, d, iw,DECODE(d, 1, iw+1, iw) iw,*/
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) ,'WW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;

----Exam
SELECT 
        --/*dt, d, iw*/dt - (d-1),
        dt - (d-1),
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY dt - (d-1)
ORDER BY dt - (d-1);


--By JiSun KIM
SELECT
        
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY sat;


SELECT 
        MAX(DECODE(d, 1, dt)) s, MAX(DECODE(d, 2, dt)) m, MAX(DECODE(d, 3, dt)) t,
        MAX(DECODE(d, 4, dt)) w, MAX(DECODE(d, 5, dt)) t, MAX(DECODE(d, 6, dt)) f,
        MAX(DECODE(d, 7, dt)) sat
FROM
        (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,                 --20191130(LEVEL -1)
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,  
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL) ,'IW') iw       --20191201 (LEVEL)
         FROM dual
         CONNECT BY LEVEL <= 35)
GROUP BY dt-(d-1)
ORDER BY dt-(d-1);

--JongMin Park
-- 12.18�ϱ��� ���� -- �޷� ����� NULL �� ��� ä���
SELECT
    MAX(NVL(DECODE(d, 1, dt), dt - d + 1)) ��, MAX(NVL(DECODE(d, 2, dt), dt - d + 2)) ��, MAX(NVL(DECODE(d, 3, dt), dt - d + 3)) ȭ,
    MAX(NVL(DECODE(d, 4, dt), dt - d + 4)) ��, MAX(NVL(DECODE(d, 5, dt), dt - d + 5)) ��, MAX(NVL(DECODE(d, 6, dt), dt - d + 6)) ��, MAX(NVL(DECODE(d, 7, dt), dt - d + 7)) ��
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);


--DB�� ��
--201910 : 35, ù���� �Ͽ��� : 201909, ������ ���� ����� : 20191102
-- ��(1), ��(2), ȭ(3), ��(4), ��(5), ��(6), ��(7)
SELECT ldt-fdt+1
FROM
    (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
           LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
           TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') - 1) fdt
    FROM dual);


SELECT
    MAX(DECODE(d, 1, dt)) ��, MAX(DECODE(d, 2, dt)) ��, MAX(DECODE(d, 3, dt)) ȭ,
    MAX(DECODE(d, 4, dt)) ��, MAX(DECODE(d, 5, dt)) ��, MAX(DECODE(d, 6, dt)) ��, MAX(DECODE(d, 7, dt)) ��
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL-1) dt,              
            
            TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') -
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL-1),'D' ) d, 
            
            TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') -
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL),'IW' ) iw 
    FROM dual
    CONNECT BY LEVEL <= (SELECT ldt-fdt+1
                        FROM
                            (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
                               LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
                               TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') - 1) fdt
                            FROM dual)))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);
--DB�� ��--

