
--crossjoin1
SELECT *
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

--burger
--도시발전지수
SELECT *
FROM FASTFOOD;
--WHERE sido = '대전광역시';
--GROUP BY GB;

--도시발전지수가 높은 순으로 나열
--도시 발전 수준 (버거킹+맥도날드+KFC)/롯데리아 개수
--순위 / 시도 / 시군구 / 도시발전지수(소수점 둘째자리에서 반올림)
--1 / 서울특별시 / 서초구 / 7.5
--2 / 서울특별시 / 강남구 / 7.2
SELECT *
FROM FASTFOOD;

SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
FROM FASTFOOD
WHERE GB = '버거킹'
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
FROM FASTFOOD
WHERE GB = '버거킹'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) kfc_cnt
FROM FASTFOOD
WHERE GB = 'KFC'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) mac_cnt
FROM FASTFOOD
WHERE GB = '맥도날드'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, COUNT(sigungu) lotte_cnt
FROM FASTFOOD
WHERE GB = '롯데리아'
GROUP BY sido, sigungu
ORDER BY sido;

--
SELECT 
FROM
    (SELECT sido, sigungu, COUNT(sigungu) bgk_cnt
    FROM FASTFOOD
    WHERE gb = '버거킹' OR gb = 'KFC' OR gb = '맥도날드'
    GROUP BY sido, sigungu
    ORDER BY sido) a,
    
    (SELECT sido, sigungu, COUNT(sigungu) lotte_cnt
    FROM FASTFOOD
    WHERE GB = '롯데리아'
    GROUP BY sido, sigungu
    ORDER BY sido) b;
WHERE GB IN ('버거킹', 'KFC', '맥도날드', '롯데리아');

--
SELECT a.sido, a.sigungu, a.cnt
FROM    
    (SELECT sido, sigungu, COUNT(sigungu) cnt
    FROM FASTFOOD
    WHERE GB IN ('버거킹', 'KFC', '맥도날드', '롯데리아')
    GROUP BY sido, sigungu
    ORDER BY sido) a
ORDER BY a.cnt DESC;


--Sol>>>
--해당 시도, 시군구별 프렌차이즈별 건수가 필요
SELECT ROWNUM rn, sido, sigungu, 도시발전지수
FROM
(SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) AS 도시발전지수
FROM
    (SELECT sido, sigungu, COUNT(*) cnt  --버거킹, KFC, 맥도날드 건수
    FROM fastfood
    WHERE gb IN('KFC', '버거킹', '맥도날드')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt  --롯데리아 건수
    FROM fastfood
    WHERE gb = '롯데리아'
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY 도시발전지수 DESC);

    
--하나의 SQL로 작성하지 마세요
--FASTFOOD  테이블을 이용하여 여러번의 SQL 실행 결과를
--손으로 계산해서 도시 발전지수를 계산
--대전시 유성구 4/8 = 0.5
--대전시 동구 4/8 = 0.5
--대전시 서구 13/12 = 1.1
--대전시 중구 6/6 = 1
--대전시 대덕구 2/7 = 0.3

SELECT *
FROM fastfood
WHERE sido = '대전광역시';

SELECT *
FROM fastfood
WHERE sido = '대전광역시'
AND GB IN('버거킹', 'kfc', '맥도날드');

SELECT *
FROM fastfood
WHERE sido = '대전광역시'
AND GB IN('롯데리아');



--버거지수 제일 높은 지역 -- 국세청 1위랑 한 로우에 조인하기
SELECT *
FROM tax;










