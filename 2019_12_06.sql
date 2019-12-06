



SELECT *
FROM dept;

--dept 테이블에 부서번호 99, 부서명 ddit, 위치 daejeon
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');
COMMIT;

--UPDATE : 테이블에 저장된 컬럼의 값을 변경
--UPDATE 테이블명 SET 컬럼명1 = 적용하려고하는 값1, 컬럼명2=적용하려고하는 값2....
--[WHERE row 조회 조건]

--부서번호가 99번인 부서의 부서명을 대덕IT로, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

--★★★☆☆☆업데이트전에 업데이트 하려고 하는 테이블을 WHERE절에 기술한 조건으로 
--SELECT를 하여 업데이트 대상 ROW를 확인해보자☆☆☆★★★
SELECT *
FROM dept
WHERE deptno = 99;

--다음 QUERY를 실행하면 WHERE 절에 ROW 제한 조건이 없기 때문에 
--dept 테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다.
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';

ROLLBACK;

--SUBQUERY 를 이용한 UPDATE
--emp 테이블에 신규 데이터 입력
--사원번호 9999, 사원이름 brown, 업무 : null
INSERT INTO emp(empno, ename) VALUES(9999, 'brown');

SELECT *
FROM emp
WHERE empno = 9999;

COMMIT;

--사원번호가 9999인 사원의 소속 부서와 담당업무를 SMITH사원의 부서, 업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename='SMITH') /*20*/, 
                job = (SELECT job FROM emp WHERE ename='SMITH') /*CLERK*/
WHERE empno = 9999;

SELECT *
FROM emp;

--DELECT : 조건에 해당하는 ROW를 삭제
--컬럼의 값을 삭제?? (NULL)값으로 변경하려면 >>> UPDATE

--DELETE 테이블명
--[WHERE 조건]

--UDPATE 쿼리와 마찬가지로 DELETE 쿼리 실행전에는 해당 테이블 
--WHERE 조건을 동일하게 하여 SELECT를 실행, 삭제될 ROW를 먼저 확인해보자

--emp테이블에 존재하는 사원번호 9999인 사원을 삭제
DELETE emp
WHERE empno = 9999;

--DELETE emp; --테이블에 존재하는 모든 데이터 삭제(WHERE 절 없음)

SELECT *
FROM emp
WHERE empno = 9999;

--매니저가 7698인 모든 사원을 삭제
--서브쿼리를 사용
SELECT *
FROM emp
WHERE mgr = 7698;

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
          
SELECT *
FROM emp;
ROLLBACK;
                
--위 쿼리는 아래 쿼리와 동일
DELETE emp WHERE mgr = 7698;

--로그를 남기지 않고 보다 빠른 삭제방법 > TRUNCATE
--DDL
--복구불가
--주로 개발(테스트) 데이터베이스에서 사용

--Transaction
--트랜잭션 :여러단계의 과정을 하나의 작업행위로 묶는 단위
--Transaction : 논리적인 일의 단위
--(트랜잭션 발생 예)
-->관련된 여러 DML문장을 하나로 처리하기위해 사용
-->첫번째DML문을 실행함과 동시에 트랜잭션 시작
-->이후 다른 DML문 실행
-->commit : 트랜잭션을 종료, 데이터를 확정
-->rollback : 트랜잭션에서 실행한 DML문을 취소하고 트랜잭션 종료
-->게시글 입력시(제목,내용,복수개의 첨부파일)
-->게시글 테이블, 게시글 첨부파일 테이블
-->1.DML : 게시글입력
-->2.DML : 게시글 첨부파일 입력
-->1번 DML은 정상적으로 실행 후 2번 DML 실행시 에러가 발생한다면?
--
-->DCL/DDL
-->자동 commit(묵시적commit)
-->rollback 불가

--읽기 일관성(ISOLATION LEVEL)
--DML문이 다른 사용자에게 어떻게 영향을
--미치는지 정의한 레벨(lv 0-3)
--A사용자 B사용자
--A사용자 DELETE / B사용자 DELETE > LOCK 걸려서 접근불가
--LOCK해제 (TCL): COMMIT, ROLLBACK


--읽기 일관성(ISOLATION LEVEL)
--ISOLATION LEVEL
--    LV 0 : Read Uncommitted
--        dirty read
--        선행 트랜잭션의 커밋되지 않은 데이터를
--        후행 트랜잭션에서 볼 수 있는 설정
--        오라클은 미지원
--    LV 1 : Read committed
--        대부분의 DBMS의 기본설정
--        커밋되지 않은 데이터는 후행 트랜잭션에서 볼 수 없다
--    LV 2 : Repeatable Read
--        선행 트랜잭션이 읽은 데이터를 후행 트랜잭션에서 데이터를
--        '수정', '삭제'하지 못함
--          > 선행 트랜잭션에서 같은 조회 쿼리를 실행시 결과가 같음
--          > repeatable read
--        하지만 후행 트랜잭션에서 신규 입력은 가능
--          > Phantom Read : 없던 데이터가 새로 조회되는 현상
--        Oracle에서는 공식적으로 지원 X,
--          > FOR UPDATE 절을 이용해 효과를 낼 수 있음

----------------------------------
SELECT *
FROM dept
WHERE deptno = 40
FOR UPDATE;

--다른 트랜잭션에서 수정을 못하기 때문에
--현 트랜잭션에서 해당 ROW는 항상
--동일한 결과값으로 조회 할 수 있다.

--하지만 후행 트랜잭션에서 신규 데이터
--입력후 COMMIT을 하면 현 트랜잭션에서 
--조회가 된다. (phantom read / 유령읽기)

--    LV 3 : Serializable Read
--        후행 트랜잭션에서 수정, 입력, 삭제된 데이터가 선행 트랜잭션에 영향을 주지 않음
--        선행 트랜잭션의 데이터 조회 기준은 선행 트랜잭션이 시작된 시점
--        즉 후행 트랜잭션에서 신규 데이터를 입력해도 선행 트랜잭션에서 조회되지 않음

--        트랜잭션의 데이터 조회 기준이 트랜잭션 시작 시점으로 맞춰진다.
--        즉 후행 트랜잭션에서 데이터를 신규 입력, 수정, 삭제 후 COMMIT을 하더라도
--        선행 트랜잭션에서는 해당 데이터를 보지 않는다.
--        DBMS의 특성을 생각하지 않고 일관성 레벨을 임의로 수정하는 것은 위험
--        약은 약사에게 DB는 DBA에게 
--        Oracle은 locking 메카니즘이 다른 dbms와 차이가 있음
--        하지만 메카니즘의 차이로 다른 DBMS에 없는 에러가 있음 
--        SNAPSHOT TOO OLD


SELECT *
FROM dept;
DELETE dept
WHERE deptno = 99;
COMMIT;

--트랜잭션 레벨 수정(serializable read)
SET TRANSACTION isolation LEVEL SERIALIZABLE;

--SQL PART 1 END --------------------------------------------------------------------------
--SQL PART 1 END --------------------------------------------------------------------------
--SQL PART 1 END --------------------------------------------------------------------------
--SQL PART 1 END --------------------------------------------------------------------------












