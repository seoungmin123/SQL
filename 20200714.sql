DDL 
오라클 객체
1. table : 데이터를 저장할 수 있는 공간
    제약조건 
    NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK
    
2. view : SQL => 실제 데이터가 존재하는 것이 아님
            논리적인 데이터 집합의 정의
            * VIEW TABLE 잘못된 표현
            
    IN-LINE VIEW 
    
view 생성 문법
CREATE              TABLE
CREATE              INDEX
CREATE [OR REPLACE] VIEW 뷰이름 [colum1,colum2,,,] AS
SELECT 쿼리; 

emp 테이블에서 급여정보인 sal, comm컬럼을 제외하고 나머지 6개 컬럼만
조회 할 수 있는 SELECT 쿼리를 v_emp 이름의 view 로 생성

CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp ;

--system 계정에서 실행해야함
smlee 계정에게 VIEW 를 생성할 수 있는 권한 부여
GRANT CREATE VIEW TO smlee;

오라클 view 객체를 생성해서 조회
SELECT *
FROM v_emp;

inline view 를 이용하여 조회
SELECT * 
FROM(
    SELECT empno, ename, job, mgr, hiredate, deptno
    FROM emp) ;
    
VIEW 객체를 통해 얻을 수 있는 이점
1. 코드를 재사용 할 수 있다
2. SQL 코드가 짧아진다. 

hr 계정에게 emp 테이블이아니라 v_emp 에 대한 접근권한을 부여
hr계정에서는 emp 테이블의 sal , comm컬럼을 볼 수 가없다
==> 급여정보에 대한 부분을 비관련자로부터 차단을 할 수가 있다.

GRANT CREATE VIEW TO smlee; --권한에 대한 권한 sysdate 에서 해야한다. 

GRANT SELECT ON v_emp TO hr; --객체에 대한 권한
--hr 계정으로 접속하여 테스트
v_emp view 는 smlee계정이 hr 계정에게 select 권한을 주었기때문에 정상조회가능  
SELECT *
FROM smlee.v_emp; 권한을 줘서 실행가능
emp view 는 smlee계정이 hr 계정에게 권한을 준적이없어서 에러
SELECT *
FROM smlee.emp; 권한이 없어서 실행 할 수없다. 

VIEW : SQL 
emp 테이블에서 신규데이터를 추가하고 view 조회해도 똑같이 조회가능
VIEW 라고 하는것은 실체가없는 데이터 집합을 정의 하는 SQL 이기떄문에 
해당 SQL에서 사용하는 테이블의 데이터가 변경이되면  VIEW에도 영향을 미친다.

VIEW 는 SQL 이기 때문에 조인된 결과나, 그룹함수를 적용하여 행의 건수가
달라지는 sql도 view 로 생성하는 것이 가능 

emp,dept테이블의 경우 업무상 자주 같이 쓰일 수 밖에 없는 테이블 
부서명, 사원번호, 사원 이름, 담당업무, 입사일자
다섯개의 컬럼을 갖는 view를 v_emp_dept 로 생성

CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT d.dname, e.empno, e.ename, e.job , e.hiredate
FROM emp e, dept d
WHere e.deptno = d.deptno;

SELECT *
FROM v_emp_dept;

SEQUENCE : 중복되지 않은 정수값을 반환해주는 오라클 객체
시작값(default 1, 혹은 개발자가 설정가능)부터 1씩 순차적으로
증가한 값을 반환한다.

문법 :
CREATE SEQUENCE 시퀀스명;
[옵션  . . . ..]

seq_emp 이름으로 SEQUENCE 생성
CREATE SEQUENCE seq_emp;

시퀀스 객체를 통해중복되지 않은 값을 조회
시퀀스 객체에서 제공하는 함수
1. nextval (next value)(다음값 새로운값 보여주는거고)
    시퀀스 객체의 다음 값을 요청하는 함수
    함수를 호출하면 시퀀스 객체의 값이 하나 증가하여 다음번 호출시
    증가된 값을 반환하게 된다 
2. currval (current value)(현재값뭔지만 보여주는거고)
    nextval함수를 사용하고 나서 사용 할 수 있는 함수
    nextval함수를 통해 얻은 값을 다시 확인 할 때 사용
    시퀀스 객체가 다음에 리턴 할 값에 대해 영향을 미치지않음

nextval 사용전에 currval 사용한 경우 ==> 에러
SELECT seq_emp.currval
FROM dual; 

SELECT seq_emp.nextval
FROM dual; 

SELECT seq_emp.currval
FROM dual; 

테이블 : 정렬이 안되어있음 (집합)
==> ORDER BY 

emp 테이블에서 empno = 7698 인 데이터를 조회

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE (dbms_xplan.display);
(c언어 포인터
java : TV tv = new TV() tv에는 메모리공간
        int a  =5 a 에는 실제 5)

ROWID 특수컬럼 : 행의 주소 
SELECT ROWID , emp.*
FROM emp
WHERE empno = 7698;

ROWID값을 알고있으면 테이블에 빠르게 접근 하는 것이 가능

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACNAAF';

SELECT *
FROM TABLE (dbms_xplan.display);

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY(deptno)
                                    REFERENCES dept (deptno);


emp 테이블의 pk_emp PRIMARY KEY 제약조건을 통해 empno컬럼으로
인덱스 생성이 되어있는 상태
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE (dbms_xplan.display);
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    36 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    36 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7698)
   
   emp 테이블에 primary key 제약조건을 생성하고 나서 변경된점
    * 오라클 입장에서는 데이트를 조회할 떄 사용할 수 있는 전략이 하나 더 생김
    1. table full scan
    2. pk_emp 인덱스를 이용하여 사용자가 원하는 행을 빠르게 찾아가서 
       필요한 컬럼들은 인덱스에 저장된 rowid 를 이용하여 테이블의 행으로 바로접근
    3. 
    
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE (dbms_xplan.display);
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 Predicate Information (identified by operation id):
--------------------------------------------------- 
   1 - access("EMPNO"=7698)
  --------------- 
emp 컬럼의 인덱스를 unique 인덱스가 아닌 일반 인덱스 (중복이 가능한)로 생성한 경우
1.   fk_emp_dept 제약조건 삭제
2.pk_emp 제약조건 삭제
ALTER TABLE emp DROP CONSTRAINT fk_emp_dept;
ALTER TABLE emp DROP CONSTRAINT pk_emp;

SELECT *
FROM 인덱스 --> 안된다

1. NON-UNIQUE 인덱스 생성(중복가능)
UNIQUE 명명규칙 : IDX_U 테이블명_01;
 NON-UNIQUE 명명규칙 : IDX_NU 테이블명_01;
CREATE (UNIQUE) INDEX 인덱스명 ON 테이블(인덱스로 구성할 컬럼);

CREATE INDEX idx_nu_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE (dbms_xplan.display);
--아래 잘못나온듯,,?
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    36 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    36 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7698)   --//81