
--SQL PART 2

--오라클의 대표적 객체들
--Table : 데이터 저장소(순서보장X)
--Index : 조회시 성능향상을 위해 정해진 컬럼순으로 정렬해놓은 객체
--View : 데이터 조회 쿼리를 객체로 생성하여 재사용하기 위한 객체
--Sequence : 중복되지 않는 숫자를 생성
--Synonym : 오라클 객체의 별칭

--테이블 컬럼명 규칙
-->영문자로 시작해야 한다
-->길이는 1-30글자
-->알파벳 대소문자 _ $ # 만 가능
-->해당 유저가 소유한 다른 객체와 이름이 겹치면 안됨
-->오라클 키워드와 객체명이 동일할 수 없음

--DROP
--테이블 객체를 삭제하는 query
--DROP (DDL) ROLLBACK 안됨

--DDL : TABLE 생성
--CREATE TABLE [사용자명.]테이블명(
--    컬럼명1 컬럼타입,
--    컬럼명1 컬럼타입, ...
--    컬럼명N 컬럼타입N
-- ranger_no NUMBER         : 레인저 번호
-- ranger_nm VARCHAR2(50)   : 레인저 이름
-- reg_dt DATE              : 레인저 등록일자
-- 테이블 생성 DDL : Data Definition Language(데이터 정의어)
-- DDL rollback이 없다(자동커밋 되므로 rollback을 할 수 없다)

CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE
);

DESC ranger;
--DDL 문장은 ROLLBACK 처리가 불가!!

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'RANGER'; --오라클에서는 객체 생성시 소문자로 생성하더라도 내부적으로는 대문자로 관리한다.


INSERT INTO ranger VALUES(1, 'brown', SYSDATE);
--데이터가 조회되는것 확인함
SELECT *
FROM ranger;

-- DML문은 DDL과 다르게 ROLLBACK이 가능하다
ROLLBACK;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--Oracle 주요 Data Type
--VARCHAR2(size) : 가변길이 문자열 size : 1~4000 byte
--CHAR(사용안해) : size보다 작게 텍스트 입력하면 남은공간은 빈 공백
--NUMBER(p, s) : 부동소수점 (p: 전체자리수, s: 소수점 자리수)
--DATE : 일자와 시간정보 / 시간은 초단위까지 관리 / 7 byte고정 
--        일자를 저장하기 위해 (yyyymmdd) 8byte 문자열로 사용하는 경우도 있음
--CLOB : Character Large Object : 장문의 문자열 (최대 4GB)
--BLOB : Binary Large Object : 바이너리 데이터 (최대 4GB) / 중요한 파일의 경우 db에 바이너리 형태로 저장
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


--DATE 타입에서 필드 추출하기
--EXTRACT(필드명 FROM 컬럼 / expression)
SELECT TO_DATE(SYSDATE, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'mm') mm,
        EXTRACT(year FROM SYSDATE) ex_yyyy
FROM dual;

SELECT EXTRACT(year FROM SYSDATE) ex_yyyy
FROM dual;

--DDL (Table - 제약조건)
--제약조건
--    데이터의 무결성을 지키기 위한 설정
--        NOT NULL
--            컬럼에 값이 반드시 들어와야 한다.
--        UNIQUE
--            해당 컬럼 중 같은 값을 같는 값이 없어야 함
--            컬럼 복합 조합도 가능
--        PRIMARY KEY = UNIQUE + NOT NULL
--        FOREIGN KEY 
--            해당 컬럼이 참조하는 다른 테이블에 값이 존재 해야함
--        CHECK
--            컬럼에 들어 갈 수 있는 값을 제한
--        FOREIGN KEY

--테이블 생성시 컬럼 레벨 제약조건 생성
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
--dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건이 있기 때문에
--deptno가 동일한 데이터를 입력하거나 수정할 수 없다.
--최초 데이터이므로 입력성공
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');

--dept_test 데이터에 deptno가 99번인 데이터가 있으므로
--primary key 제약조건에 의해 입력 될 수 없다
INSERT INTO dept_test VALUES(99, '대덕', '대전');

--ORA-00001 unique constraint 제약 위배
--위배되는 제약조건명 SYSTEM.SYS_C007094 제약조건 위배
--SYS-C007105 제약조건을 어떤 제약 조건인지 판단하기 힘드므로
--제약조건에 이름을 코딩 룰에 의해 붙여주는 편이 유지보수시 편하다


--테이블 삭제 후 제약조건 이름을 추가하여 재생성
--primary key : pk_테이블명
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

--INSERT 구문 복사
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '대덕', '대전');







