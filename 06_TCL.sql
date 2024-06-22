-- TCL(Transaction Control Langauge) : 트랜잭션 제어 언어
-- COMMIT(트랜잭션 종료 후 저장), ROLLBACK(트랜잭션 취소), SAVEPOINT(임시저장)

-- DML : 뎅리터 조작 언어로 데이터의 삽입, 수정, 삭제
--> 트랜잭션은 DML과 관련되어 있음

/* TRANSACTION이란? 

- 데이터베이스의 논리적 연산 단위

- 데이터 변경 사항을 묶어 하나의 트랜잭션에 담아 처리함

- 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE (DML)

EX) INSERT 수행 -------------------------------------------> DB 반영(X)

    INSERT 수행 ------> 트랜잭션에 추가 ------> COMMIT ------> DB 반영(O)
    
    INSERT 10번 수행 -> 1개 트랜잭션에 10개 추가 -> ROLLBACK -> DB 반영(X)
    
    1) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
    
    2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
                마지막 COMMIT 상태로 돌아감
                
    3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
                 ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌 저장 지점까지만 일부 ROLLBACK


    [SAVEPOINT 사용법]
    
    SAVEPOINT 포인트명1;
    ...
    SAVEPOINT 포인트명2;
    ...
    ROLLBACK TO 포인트명1; -> 포인트명1 지점까지 데이터 변경사항 삭제
    
*/

-- DEPARTMENT2 테이블 현재 상태 확인
SELECT * FROM DEPARTMENT2;

-- D0, 경리부, L2 삽입
INSERT INTO DEPARTMENT2(DEPT_ID, DEPT_TITLE, LOCATION_ID)
VALUES ('D0', '경리부', 'L2' );

SELECT * FROM DEPARTMENT2;
ROLLBACK;

-- 롤백 후 다시 확인
SELECT * FROM DEPARTMENT2;

-- 다시 INSERT 후 COMMIT
INSERT INTO DEPARTMENT2 VALUES('D0', '경리부', 'L2' );
COMMIT;

-- 롤백 수행 후 경리부가 삭제되었는지 확인
ROLLBACK;
SELECT * FROM DEPARTMENT2;

--------------------------------------------------------------------------------

DELETE FROM DEPARTMENT2
WHERE DEPT_ID = 'D0';

-- D0 삭제 시점에 SAVEPOINT 지정
SAVEPOINT S1; -- Savepoint이(가) 생성되었습니다.

-- D9 삭제
DELETE FROM DEPARTMENT2 WHERE DEPT_ID = 'D9';
SELECT * FROM DEPARTMENT2;

-- 일반 ROLLBACK시 D9, D0가 복귀됨
ROLLBACK;

SELECT * FROM DEPARTMENT2;

-- S1까지 ROLLBACK
ROLLBACK TO S1;
SELECT * FROM DEPARTMENT2;

ROLLBACK; -- 처음으로 다시 돌아가는 ROLLBACK
SELECT * FROM DEPARTMENT2;

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------




--------------------------------------------------------------------------------




--------------------------------------------------------------------------------




--------------------------------------------------------------------------------

