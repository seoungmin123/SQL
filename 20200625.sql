
SELECT *
FROM emp;

SELECT *
FROM dept;

--expression : 
--컬럼값을 가공하거나 , 존재하지 않는 새로운 상수값
--연산을 통해 새로운 컬럼을 조회 할 수 있다.
--연산을 하더라도 해동 SQL 조회결과에만 나올 뿐이고 실제 테이블의 데이터에는 영향을 주지 안는다
-- SELECT 구문은 테이블의 데이터에 영향을 주지않음

SELECT  sal, sal+500 as sAll, 33 
FROM emp;

--날짜에 사칙연산 : 수학적으로 정의가 되어있지않음
--SQL에서는 날짜데이터에 +- 정수 => 정수를 일수 취급

'2020년 6월 25일' + 5 : 2020년 6월 25일 부터 5일 이후 날짜
'2020년 6월 25일' - 5 : 2020년 6월 25일 부터 5일 이전 날짜

--데이터 베이스에서 주로 사용하는 데이터타입 : 문자, 숫자, 날짜 
EMPNO : 숫자 
ENAME : 문자 
JOB : 문자
MGR : 숫자 
HIREDATE : 날짜
SAL : 숫자 
COMM : 숫자 
DEPTNO : 숫자

테이블의 컬럼 정보확인
DESC 테이블명 (DESCRIBE 테이블명)
DESC emp;
--
--날짜를 일수취급한다 날짜연산 가능 
SELECT hiredate, hiredate+5, hiredate -5
FROM emp;

--users 테이블의 컬럼타입을 확인하고
-- rgd_dt 컬럽 값에 5일 뒤 날짜를 새로운 컬럼으로 표현
--조회컬럼 :userid, reg_dt, reg_dt 의 5일 뒤 날짜

DESC users;

SELECT userid, reg_dt, reg_dt + 5
FROM users;

--NULL: 아직 모르는 값 , 할당되지 않은 값
--null과 숫자타입의 0은 다르다
--null과 문자타입의 공백은 다르다
-- 널의 중요한 특징 
-- 널을 피연산자로 하는 연산의 결과는 항상 null이다 
--ex) null + 500 = null

--문제-===============
--emp테이블에서 sal 컬럼과 comm컬럼의 합을 새로운 컬럼으로 표현 
--조회컬럼은 empno, ename , sal , comm, sal 컬럼과 comm의 합 
SELECT empno 
      ,ename 
      ,sal s 
      ,comm as "com  mit ion" 
      ,sal+comm AS sum
FROM emp;
--alias : 컬럼이나 expression에 새로운 이름을 부여
--적용방법 : 컬럼 ,expression [as] 별칭명
--별칭이름을 소문자로 쓰고싶으면 "" 안에 넣는다
--더블 쿼테이션"" 공백을 쓰고싶을때도 "아 나 아 라" 이런식으로 적용

--실습
SELECT prod_id as id, prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id as 바이어아이디, buyer_name as 이름
FROM buyer;

--literal : 값 자체--
--literal 표기법 : 값을 표현하는 방법
--ex)test 라는 문자열을 표기하는 방법
--java : system.out.printin("test"), java에서는 더블 쿼테이션으로 문자열을 표기
--       system.out.printin('test'), java에서는 싱글 쿼테이션이면 오류-
--SQL : 'test', sql 에서는 싱글 쿼테이션으로 문자열을 표기

-- 번외 =는 대입연산자
-- java에서는 대입연산자가 =
-- pi/sql에서는 대입연산자가  :=
-- 언어 마다 연산자 표기, literal 표기법이 다르기 떄문에 해당 언어에서 지정하는 방식을 잘 따라야 한다.

-- 문자열 연산 : 결합
--일상생활에서 문자열 결합 연산자가 존재? 
-- 자바 문자열 결합 연산자 + 
-- sql 에서 문자열결합 연산자 ||
-- sql 에서 문자열결합 함수 CONCAT(문자열1,문자열2) ==> 문자열1||문자열2
--                       * 두개의 문자열을 인자로 받아서 결합결과를 리턴

--users 테이블의 userid 컬럼과 usernm 컬럼을 결합
SELECT userid
       ,usernm
       ,userid || usernm as sum  
FROM users;
---------------------------
SELECT userid
       ,usernm
       ,CONCAT(userid, usernm)as sum  
FROM users;

임의의 문자열 결합 (sal+500, '아이디 : ' || userid)

SELECT '아이디 : '||userid as id, 500 ,'test'
FROM users;

SELECT 'SELECT * FROM '||TABLE_NAME ||';' as Query
FROM user_tables;

SELECT CONCAT( 'SELECT * FROM ',TABLE_NAME)||';' as query
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ',TABLE_NAME),';') as query
FROM user_tables;

-----------------------
--WHERE : 테이블에서 조회할 행의 조건을 기술
--        WHERE절에 기술한 조건이 참일떄 해당 행을 조회한다. 
--        SQL 에서 가장 어려운 부분, 많은 응용이 발생하는 부분
    
SELECT * 
FROM users
WHERE userid = 'brown';

emp 테이블에서 deptno컬럼의 값이 30보다 크거나 같은 행을 조회, 컬럼은 모든 컬럼 
SELECT * 
FROM emp
WHERE deptno >= 30;

emp14건
SELECT * 
FROM emp
WHERE 1=1;

DATE타입에 대한 WHERE 절 조건기술
emp테이블에서 hiredate 값이 1982 1월1일 이후인 사원들만 조회
SQL 에서 DATE 리터럴 표기법 'YY/MM/DD'
단 서버 설정마다 표기법이 다르다 
한국 : yy/mm/dd
미국 : mm/dd/yy

'12/11/01' => 국가별로 다르게 해석이 가능하기 떄문에 DATE 리터럴보다는
문자열 DATE 타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜 문자열','첫번쨰 인자의 형식')

SELECT * 
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yyyy/mm/dd');

SELECT * 
FROM emp
WHERE hiredate >= '1982/01/01';

--날짜에 대한 형식 확인 
SELECT * 
FROM NLS_SESSION_PARAMETERS;

-- BETWEEN AND : 두 값사이에 위치한 값을 참으로 인식
-- 사용방법 비교값 BETWEEN 시작값 AND 종료값
-- 비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

--emp 테이블에서 sal 값이 1000보다 크거나 같고 2000보다 작거나 같은 사원들만(행들만)조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--sal BETWEEN 1000 AND 2000; 를 부등호로 나타내면 
SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal <= 2000;

SELECT *
FROM emp
WHERE sal >= 1000 OR sal <= 2000;


--실습 pt1 p83

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','yyyy/mm/dd') 
  AND TO_DATE('1983/01/01','yyyy/mm/dd');
  
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yyyy/mm/dd')
  AND hiredate <= TO_DATE('1983/01/01','yyyy/mm/dd');
  
--p85
SELECT *
FROM emp
WHERE deptno IN (10,20);

--IN 연산자 : 비교값이 나열된 값에 포함될 떄 참으로 인식
-- 사용방법 : 비교값 IN (비교대상 값 1,비교대상 값 2,비교대상 값 3,...)

SELECT *
FROM emp
WHERE deptno=10
   OR deptno=20 ;
  
SELECT *
FROM emp
WHERE deptno=10
  AND deptno=20 ;
  