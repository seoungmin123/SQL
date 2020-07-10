SELECT *
FROM emp;

SELECT *
FROM dept;

DELETE emp
WHERE empno > 9000;

DELETE dept
WHERE deptno>=90;
commIt;
SELECT *
FROM dept;

UPDATE: 상수값으로 업데이트 ==> 서브쿼리 사용가능

INSERT INTO emp (empno, ename , job)
        VALUES (9999, 'brown', 'RANGER');
        
방금 입력한 9999번 사번번호를 갖는 사원의 deptno와 job컬럼의 값을 
SMITH사원의 deptno와 job값으로 업데이트            

UPDATE emp SET deptno = '값'
                job = '값 '
WHERE emp no =9999;
ROLLBACK;

SELECT *
FROM emp;

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename= 'SMITH')
                job = (SELECT job FROM emp WHERE ename= 'SMITH')
WHERE empno = 9999;
 ==> UPDATE 쿼리1 실행 할때 안쪽 SELECT 쿼리가 2개 포함됨 => 비효율적
 고정된 값을 업데이트 하는게 아니라 다른 테이블에있는 값을 통해서 업데이트 할때 비효율이 존재
 ==> MERGE 구문을 통해 보다 효율적으로 업데이트가 가능
 
 
DELETE : 테이블의 행을 삭제하는 SQL
특정컬럼만 삭제하는것은 UPDATE
DELETE구문은 행 자체를 삭제
1.어떤 테이블에서 삭제할지
2.테이블의 어떤 행을 삭제할지
문법: 
DELETE [FROM] 테이블명
WHERE 삭제할 행을 선택하는 조건;

UPDATE 쿼리 실습시 9999번 사원을 등록함, 해당 사원을 삭제하는 쿼리를 작성 

DELETE emp
WHERE empno =9999;
 
DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE 절과 동일
서브쿼리 사용가능 

사원중에 mgr 가 7698인 사원들만 삭제 
DELETE emp
WHERE mgr =7698;

DELETE emp
WHERE mgr IN (SELECT empno
             FROM emp
             WHERE mgr = 7698);
서브쿼리안에있는 내용이 단일 값이 아니라서 = 연산을 IN 으로 바꿔준다
ROLLBACK;


DBMS(전반적 모습 2페이지)의 경우 데이터의 복구를 위해서
DML 구문을 실행할 때마다 항상 로그를 생성
파일에 저장을 하려면 위치를 찾아가서 수정을 해야하는데
로그는 파일의 마지막에 붙이깁만해서 빨리 입력할 수있다
그래서혹시 정전됐을때에도 빠른저장을 한 로그에서 복구가능

로그를 남기지않고 빠른 삭제 할땐 TRUNCATE
대신 로그가없어서 복구가안됨 
주로 개발 데이터베이스에서사용 운영디비에서는 사용안함
WHERE 절이없다 그냥 싹다 지워버림

대량의 데이터를 지울때는 로그기록도 부하가되기때문에
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서
TRUNCATE TABLE테이블명; 명령을 통해 

로그를 남기지않고 빠르게 삭제가능 
단, 로그가 없기떄문에 복구가 불가능하다.

emp 테이블을 이용해서 새로운 테이블을 생성
CREATE TABLE emp_copy AS 
SELECT*
FROM emp;

SELECT *
FROM emp_copy;

DELETE emp_copy;
TRUNCATE TABLE emp_copy;

========================


TRANSACTION; 

SELECT *
FROM dept;

LEVEL 2: repeatable read;
선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하게끔 막아 
선행 특랜잭션안에서 항상 동일한 데이터가 조회되도록 보장하는 레벨

선행트랜잭션에서 추가하고 다른 트랜잭션에서 수정하지못하도록 내가 입력한거 
막고싶어!!! 그럴때 FOR UPDATE 
후행트랜잭션에서 내가 업데이트한거 바꾸지않았으면해
왜냐면 난 아직 작업이 안끝나서 
방지할 수있는거가 (오라클에서는 공식적으로 지원은 하지않지만  FOR UPDATE (특수키워드)으로 같은  효과를 낼 수 있어)
SELECT *
FROM dept
WHERE deptno = 99
FOR UPDATE ; 

그러면 후헹 트랜잭션에서는 deptno = 99을 읽을 수는 있지만 수정은 불가능 하다 .
선행 트랜잭션에서 수정가능하다고 할때까지 후행트랜잭션의 수정은 불가
(동시성을 잃음 LOCK 을 걸었다 )
lock 을 건다는것은 내가 원하는테이블의 데이터에 대해서는 후행트랜잭션이 접근하지 못하도록 할 수있는데 
후행트랜잭션이 같은 테이블에대해서 새로운데이터를 입력하는것은 막을 수는 없다 : 팬텀리드 현상
선행 트랜잭션 조회시 후행 트랜잭션에서 추가하고 선행에서 조회하면 없던 데이터가 생가는것이 팬텀리드

LV2에서는 테이블에 존재하는 데이터에 대해 후행트랜잭션에서 작업하짐 ㅗㅅ하도록 막을 수는 있지만 후행 트랜잭션에서 신규로 입력하는 데이터는 막을 수 없다
즉 선행 트랜잭션에서 처음읽은데이터와 후행트랜잭션에서 신규 입력 후 커밋한 이후에 조회한 데이터가 불일치 알 수 있다
(없단 데이터가 갑자기 생성되는 현상)


LEVEL 3 : Serializable Read (직렬화)
:후행트랜잭션이 데이터를 입력, 수정, 삭제하더라도 선행트랜잭션에서는 트랜잭션 시작 시점의 데이터가 보이도록 보장 
LV2 단점인 팬텀리드 극뽁
후행트랜잭션에서 수정 입력 삭제된 데이터가 선행 트랜잭션에 영향을 주지 않는다. 
선행 트랜잭션의 데이토 조회기준은 선행 트랜잭션이 시작한 시점
즉 후행 트랜잭션에서 신규 데이트를 입력해도 선행 트랜잭션에서 조회되지않음!

SET TRANSACTION ISOLATION LEVEL
 SERIALIZABLE; 
 위의 명령으로 레벨을 바꿔줘야한다 
 
 직렬화
 요청이 병렬로 들어오는데 직렬로 처리한다는뜻 
 
 -- DBMS의 특성을 생각하지 않고 일관성 레벨을 임의로 수정하는것은 위험 하다


LEVEL 2: repeatable read;
 
 ===========
 DML (Data Manipulation[조작] Language): 데이터를 다루는 SQL
 SELECT, INSERT, UPDATE, DELETE
 
 DDL (Data Definition[정의] Language) : 데이터를 정의하는 SQL 
 DDL 은 자동커밋, ROLLBACK 불가
 ex) 테이블 생성 DDL 실행 ==> 롤백이 불가
    ==> 테이블 삭제 DDL 실행 
 
 데이터가 들어갈 공간 (table) 생성, 삭제
 컬럼 추가 , 
 각종 객체 생성 , 수정 , 삭제;
 
 접속뷰의 보이는것들이 대부분 다 객체
 
 테이블 삭제 
 문법 
 DROP 객체종류 객체이름;
 DROP TABLE emp_copy;
 
 삭제한 테이블과 관련된 데이터도 함께삭제
 [ 나중에 배울 내용 제약조건 ] 이런것들도 전부 삭제
 테이블과 관련된 내용은 전부 삭제;
 
 삭제된 테이블 때문에 에러 
 SELECT *
 FROM emp_copy;
 
 SELECT *
 FROM emp;
---------------------------------
DML 문과 DDL문을 혼합해서 사용할 경우 발생할 수 있는 문제점 
==> 의도와 다르게 DML문에서 COMMIT 될 수 있다 
-----------
INSERT INTO emp (empno, ename) VALUES (9999,'brown');
--15
SELECT COUNT(*)
FROM emp;

DROP TABLE batch;
[COMMIT]; --자동커밋
ROLLBACK;

SELECT COUNT(*)
FROM emp;

테이블 생성
문법
CREATE TABLE 테이블명(
    컬럼명1 컬럼 1타입, 
    컬럼명2 컬럼 2타입, 
    컬럼명3 컬럼 3타입 DEFAULT 기본값 
)

ranger 라는 이름의 테이블 생성
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    red_dt DATE DEFAULT SYSDATE
);


SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES (100,'brown');

데이터 무결성 : 잘못된 데이터가 들어가는 것을 방지하는 성격
ex) 1. 사원 테이블에 중복된 사원번호가 등록되는 것을 방지 
    2. 반드시 입력이 되어야하는 컬럼의 값을 확인 
=> 파일 시스템이 갖을 수 없는 성격 

오라클에서 제공하는 데이터 무결성을 지키기 위해 제공하는 
제약조건 5가지 (4가지)

1. NOT NULL 
    해당컬럼의 값이 NULL 들어오는것을 제약 , 방지
    (ex.emp 테이블의 empno컬럼)
    
2. UNIQUE
    전체 행중에 해당 컬럼의 값이 중복이 되면 안된다.
    (ex. emp 테이블에서 empno 컬럼이 중복되면 안된다)
    다느 NULL에 대한 중복은 허용
    
3. PRIMARY KEY = UNIQUE + NOT NULL
    
4. FOREIGN KEY
    연관된 테이블에 해당 데이터가 존재해야만 입력이 가능
    emp 테이블과 dept 테이블은 deptno 컬럼으로 연결이 되어있음
    emp테이블에 데이터를 입력할때 dept테이블에 존재하지않는
    deptno값을 입력하는 것을 방지
    
5. CHECK
    컬럼에 들어오는 값을 정해진 로직에 따라 제어
    (ex. 어떤 테이블에 성별이라는 컬럼이 존재하면
         남성 = m / 여성 = f
         m ,f  두가지 값만 저장될 수 있도록 제어
         
         c 라는 성별을 입력하면?? 시스템 요구사항을 정의할때
         정의하지 않은 값이기 때문에 추후문제가 될 수도 있다.
         )
         
제약조건 생성하는 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어 불가
    
2. 테이블 생성시, 모든 컬럼을 기술하고 나서 
    제약조건만 별도로 기술
    1번 방법보다 세세하게 제어하는게 가능

3. 테이블 생성이후,
    객체 수정 명령을 통해 제약조건을 추가 
    
    
1번 방법으로 PRIMARY KEY 생성
dept 테이블과동일한 컬럼명, 타입으로 dept_test 라는 테이블 이름으로 생성
    1. dept 테이블의 컬럼의 구성 정보확인 
           DESC dept;
           
CREATE TABLE dept_test (
      DEPTNO NUMBER(2)PRIMARY KEY,   
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13) 
);
SELECT *
FROM dept_test;

PRIMARY KEY 제약조건 확인 
 UNIQUE + NOT NULL
 
 1. NULL값 입력 테스트
 PRIMARY KEY 제약조건에 의해 deptno 컬럼에는 null값이 들어갈 수 없다
 INSERT INTO dept_test VALUES (null, 'ddit','deajeon');

 2. 값 중복 테스트
 PRIMARY KEY 제약조건에 의해 deptno 컬럼에는 null값이 들어갈 수 없다
 INSERT INTO dept_test VALUES (99, 'ddit','deajeon');
 
 SELECT *
 FROM dept_test;

 INSERT INTO dept_test VALUES (99, 'ddit2','대전');
 -- deptno 컬럼의 값이 99번인 데이터가 이미 존재하기때문에
 -- 중복데이터로 입력이 불가능
 
 현시점에서 dept 테이블에는 deptno컬럼에 PRIMARY KEY제약이 걸려있지않은 상황 
 SELECT *
 FROM dept;
 이미존재하는 10번부서를 추가로 등록 
 INSERT INTO dept VALUES (10,  'ddit', 'deajron');
 rollback;
 
 1-1 테이블 생성시 제약조건 명을 설정한 경우
 DROP TABLE dept_test;
 
 컬럼명 컬럼타입 CONSTRAINT 제약조건이름 제약조건타입[PRIMARY KEY]
 PRIMARY KEY 제약조건 명명규칙 PK_테이블명
 
 CREATE TABLE dept_test (
      DEPTNO NUMBER(2)CONSTRAINT PK_dept_test PRIMARY KEY,   
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13) 
);
 INSERT INTO dept_test VALUES (99, 'ddit2','대전');
 
 SELECT *
 FROM dept_test;
 
 INSERT INTO dept_test VALUES (99, 'ddit','deajeon');
 --제약조건에 DEPTNO 중복안됨 
 오류 보고 -
ORA-00001: unique constraint (SMLEE.PK_DEPT_TEST) violated
오류를 보여줄때 PK_DEPT_TEST 라고 제약조건이름을 만든걸 보여주니까
무엇을 위배했는지 한번에 알기쉽다 ( 원래는 숫자로 보여줌 )