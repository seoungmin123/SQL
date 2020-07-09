
0. 조회하려고 하는 컬럼이 어떤 테이블에서부터 오는지 생각을 해야한다.
1. 요구사항을 만족시키는 코드를 작성 (하드코딩 상관없음)
1.5.  테스트 중간점검
2. 그다음에 코드를 깨끗하게 ==> 리팩토링(코드 동작은 그대로 유지한체 깔끔하게 정리하는것 ) 

행확장 UNION
컬럼을 확장하는것 JOIN

--서브쿼리 실습 7 p284
SELECT a.cid, c.cnm, a.pid, p.pnm,a.day, a.cnt
FROM
    (SELECT * 
    FROM cycle 
    WHERE cid =1 
      AND pid IN (SELECT pid 
                  FROM cycle 
                  WHERE cid =2))a , product p, customer c
WHERE p.pid = a.pid
  AND a.cid = c.cid;
  
SELECT *
FROM customer;


SELECT cy.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM cycle cy , product p, customer c
WHERE cy.cid =1 
  AND cy.pid IN (SELECT pid 
                  FROM cycle 
                  WHERE cid =2)
  AND cy.cid = c.cid
  AND p.pid = cy.pid;


EXIST 연산자 
  : 서브쿼리에서 반환하는 행이 존재하는지 체크하는 연산자
    서브쿼리에서 반환하는 행이 하나라도 존재하면 TRUE
    서브쿼리에서 반환하는 행이 하나라도 존재하지않으면 FALSE
    
연산자 : 항이 몇개가 필요한 연산지인지
 피연산자 + 피연산자2 (항 2개 필요) 
 피연산1++; 피연산자 1개필요
 (조건)?참:거짓 삼항연산자 (항이 3개)
 
 IN 연산자 :
 컬럼 IN (서브쿼리, 값을 나열하거나) 
 컬럼 LIKE '패턴문자열' 
           
앞에 컬럼이 오지않는다.
문법 : EXISTS (서브쿼리)   ;-- 인덱스라는걸 배우고나서 같이 활용가능
--아래쿼리에서 서브쿼리가 동작하면 emp 테이블의 값을 출력해라 
-- 1. 서브쿼리 단독으로 실행가능? 넹 (비상호연관이기때문)
==> 서브쿼리의 실행결과가 메인쿼리의 행 값과 관계없이 항상 실행되고
    반환되는 행의 수는 1개의 행이다.

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dual);

일반적으로 EXISTS 연산자는 상호연관 서브쿼리에서 실행된다
(반드시 그럴필요는 없지만 대부분 그럼); => 문법적으로는 비상호써도되는데 별로 의미는없기때문에
1.사원정보를 조회하는데 
 WHERE m.empno = e.mgr 조건을 만족하는 사원만 조회
 
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' --X의의미 : 값이 중요하지않고 행의 갯수가 중요하기때문에 관습적으로 엑스를 쓴다
              FROM emp m
              WHERE m.empno = e.mgr); --이조건이 한개라도 있으면 조회
==> 매니저 정보기 존재하는 사원 조회 (13건)                                                  
위의 쿼리는 안에있는 서브쿼리 단독으로 실행 할 수는 없다
실행 순서는 메인쿼리의 e 먼제 실행하고 그 후 서브쿼리 실행 하기떄문에

==> 서브쿼리가 [확인자]로 사용되었다  
    비상호 연관의 경우 서브쿼리가 먼저 실행 될 수도 있다
        =>서브쿼리가 [제공자]로 사용되었다

특이점 . : 1. WHERE 절에서 사용
          2. MAIN 테이블의 컬럼이 항으로 사용되지않음
          3. 비상호연관서브쿼리, 상호연관 서브쿼리 둘 다 사용가능하지만
             주로 상호연관 서브쿼리[확인자]와 사용된다.
          4. 서브쿼리의 컬럼값은 중요하지 않다.
                =>서브쿼리의 행이 존재하는지만 체크
                그래서 관습적으로 SELECT 'X'를 주로사용 

--실습 8 p 286
매니저가 존재하는 사원정보 조회,단 서브쿼리를 사용하지않고 
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp b
              WHERE b.empno = a.mgr); --매니저가 널인건 안나온다는뜻
--위의 쿼리를 서브쿼리를 사용하지 않고 작성           
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
--조인으로 조인에 성공하는 사람들만 나오니까 
SELECT *
FROM emp e, emp m
WHERE e.mgr = m.empno; --e 테이블의 매니저번호가 m테이블의 사번에있는지 메니저가 없는건안나온다느뜻

--서브쿼리 실습 9 
SELECT * 
FROM product p
WHERE EXISTS(SELECT 'X' FROM cycle c WHERE cid =1 AND c.pid= p.pid ) ;

--IN 연산자를 통해서
SELECT * 
FROM product
WHERE pid IN (SELECT pid FROM cycle WHERE cid =1) ;


--서브쿼리 10 
SELECT * 
FROM product p
WHERE NOT EXISTS(SELECT 'X' FROM cycle c WHERE cid =1 AND c.pid= p.pid ) ;

집합연산 SQL 에서 데이터를 확장하는 방법
가로확장(컬럼을 확장) : JOIN 
세로확장(행을 확장) : 집합연산 
                  집합연산을 하기 위해서는 연산에 참여하는 
                  두개의 SQL(집합)이 동일한 컬럼 개수와 타입을 가져야한다.

수학시간에 배운 집합의 개념과 동일
집합의 특징 :    
     1. 순서가 없다 {1,3}{3,1} 동일한 집합
     2. 요소의 중복이없다 {1,1,3} => {1,3}
     3. 컬럼명이 동일하지 않아도됨
        단 , 조회결과는 첫번째 집합의 컬럼을 따른다 
        컬럼의 순서는 맞춰야한다 
     4. 정렬이 필요한 경유 마지막 집합 뒤에다가 기술하면 된다 
     5. UNION ALL 을 제외한 경우 중복제가 작업이 들어간다

SQL 에서 제공하는 집합연산자
1. 합집합 UNION : 두개의 집합을 하나로 합칠때, 두집합에 속하는 요소는 한번만 표현된다
        {1,2,3}U{1,4,5} ==> {1,1,2,3,4,5}==>{1,2,3,4,5}
2. 교집합 INTERSECT : 두개의 집합에서 서로 중복되는 요소만 별도의 집합으로 생성
        {1,2,3} 교집합 {1,4,5}==> {1,1} ==> {1}
3. 차집합 MINUS : 앞의 선언된 집합의 요소중 뒤에 선언된 집합의 요소를 제거하고 남은 요소로 새로운 집합을 생성
        {1,2,3} - {1,4,5} ==> {2,3}
 교환법칙 : 항의 위치를 수정해도 결과가 동일한 연산
 ex) a + b == b + a(교환법칙성립)
     a - b != b - a (교환법칙 성립 안함)
 차집합의 경우 교환법칙이 성립되지 않음 
    {1,2,3} - {1,4,5} ==> {2,3}
    {1,4,5} - {1,2,3} ==> {4,5}
    --원하는 결과를 얻기위해서 앞에 어떤 집합이 먼저올지 생각해야한다 
4. UNION ALL
UNION 과  UNION ALL의 차이점
UNION 수학의 집합연산과 동일
      위의 집합과 아래집합에서 중복되는 데이터를 한번 제거
      중복되는 데이터를 찾아야함 ==> 속도가 느리다, 연산이필요(어떤행이 같은데이터를 같는지 찾아야함 )
UNION ALL 합집합의 정의와 다르게 중복을 허용 
          이의 집합과 아래집합의 행을 붙이는 행위만 실시 
          중복을 찾는 과정이 없기때문에 속도면에서 빠르다.
==> 개발자가 두 집합의 중복이 없다는 것을 알고있으면 UNION 보다 UNION ALL 을 사용하는것이 더 좋다


ex);
1. UNION 연산자;
집합연산을 하려는 두개의 집합이 동일하기 때문에 합집합을 하면 중복을 허용하지 않기때문에
7566 7698 사번을 갖는 사원이 한번씩만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)
    UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698);

2. UNION ALL 연산자;
중복을 허용한다, 위의 집합과 아래집합을 단순히 합친다. ;

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)
    UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698);

3. INTERSECT 연산자
교집합 두집합에서 공통된 부분만 새로운 집합으로 생성 

SELECT empno, ename
FROM emp
WHERE empno IN (7369,7566,7499)
    INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698);

4. MINUS 연산자
차집합 한쪽 집합에서 다른쪽 집합을 뺸것 

SELECT empno, ename
FROM emp
WHERE empno IN (7369,7566,7499)
    MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698);

정렬은 마지;막에
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)
    UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)
ORDER BY ename ;

DML-INSERT 테이블에 데이터를 입력하는 SQL 문장 
1. 어떤 테이블에 데이터를 입력 할지테이블을 정한다.
2. 해당 테이블의 어떤 컬럼에 어떤 값을 입력할 지 정한다. 
문법
INSERT INTO 테이블 (컬럼1,컬럼2...)
        VALUES (컬럼1값, 컬럼2값 ,....) ;
        
        
dept 테이블에 99번 부서번호를 갖는 ddit를 부서명으로 deajeon지역에 위치하는 부서를 등록
1.컬럼명을 나열할 때 테이블 정의에 따른 컬럼순서를 반드시 따를 필요는 없다
다만 VALUES 절에 기술한 해당 컬럼에 입력할 값의 위치만 지키면된다 
INSERT INTO dept (deptno, dname, loc)
        VALUES (99,'ddit' , 'deajeon');
        --컬럼나열이랑 입력할 값 순서만 맞으면되고 앞의 컬럼나열의 순서자체는 크게 관계없음 
2. 만약 테이블의 모든 컬럼에 대해 값을 입력하고자 할 경우는 컬럼을 나열하지않아도 상관없다
단 VALUES 절에 입력할 값을 기술 할 순서는 테이블에 정의된 ㅅ컬럼의 순서와 동일해야한다. 

테이블의 컬럼정의 : DESC 테이블명 ;
DESC dept;
-- 결과
이름     널? 유형           
------ -- ------------ 
DEPTNO    NUMBER(2)    
DNAME     VARCHAR2(14) 
LOC       VARCHAR2(13) 

INSERT INTO dept
        VALUES (98,'ddit2' , '대전');

모든 컬럼에 값을 입력하지 않을 수도 있다
다느 해당 컬럼이 NOT NULL 제약조건이 걸려있는 경우는 
컬럼에 반드시 값이 들어가야한다
컬럼에 NOT NULL 제약 조건적용여부는 DESC 테이블 ;를 통해 확인 가능
DESC emp;
-- 결과 EMPNO 는 반드시 값이 있어야하고 나머지는 없던 있던 상관 없음 
이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)    
--실패쿼리 
empno컬럼에는 NOT NULL 제약조건이 존재하기 때문에 반드시 값을 입력해야한다. 
INSERT INTO emp(ename , job)
    VALUES ('brown','RANGER');
--명령의 263 행에서 시작하는 중 오류 발생 -
INSERT INTO emp(ename , job)
    VALUES ('brown','RANGER')
오류 보고 -
ORA-01400: cannot insert NULL into ("SMLEE"."EMP"."EMPNO")

data 타입에 대한 INSERT 
emp 테이블에 sally 사원을 오늘 날짜로 입사할때
신규데이터 입력 job= RANGER, empno=9998

INSERT INTO emp (hiredate, job, empno)VALUES (SYSDATE, 'RANGER', 9998);
INSERT INTO emp (hiredate, job, empno, ename)
VALUES (TO_DATE('2020/07/01','YYYY/MM/DD'), 'RANGER', 9997,'moon');
--위에서 실행한 INSERT 구문들이 모두 취소 
ROLLBACK;

SELECT 쿼리 결과를 테이블에 입력
SELECT 쿼리 결과는 여러건의 행이 될수도있음 
여러건의 데이터를 하나의 INSERT 구문을 통해서 입력
문법
INSERT INTO 테이블명 (컬럼1,컬럼2...)
SELECT 컬럼1, 컬럼2
FROM ....;
    
SELECT SYSDATE, 'RANGER', 9998, NULL --컬럼의 갯수가 다르기때문에 NULL을 넣었음 
FROM dual
UNION ALL
SELECT TO_DATE('2020/07/01','YYYY/MM/DD'), 'RANGER', 9997,'moon'
FROM dual;    
--INSERT SELECT 절 사용
INSERT INTO emp(hiredate, job, empno, ename)
SELECT SYSDATE, 'RANGER', 9998, NULL  
FROM dual
UNION ALL
SELECT TO_DATE('2020/07/01','YYYY/MM/DD'), 'RANGER', 9997,'moon'
FROM dual;    

SELECT * 
FROM emp;
ROLLBACK;

UPDATE 테이블에 존재하는데이터를 수정하는것 
1. 어떤 테이블을 업데이트 할건지
2. 어떤 컬럼을 어떤값으로 업데이트할건지 
3. 어떤 행에대해서 업데이트할건지 (SELECT 쿼리의 WHERE절과 동일)
문법
UPDATE 데이블명 SET 컬럼명1 = 변경할값1 ,
                  컬럼명2 = 변경할값 2,
WHERE 변경할행을 제한 할 조건 ; 

SELECT *
FROM dept;

deptno가 90, dname 이 ddit, loc가 대전인 데이터를 dept 테이블에 입력하는 쿼리작성
INSERT INTO dept (deptno, dname, loc) VALUES (90,'ddit','대전');

부서번호가 90번인 부서의 부서명을 '대덕 it' 위치정보를 'deajeon'으로 업데이트
UPDATE dept SET dname ='대덕it',
                loc = 'deajeon'
WHERE deptno = 90;

업데이트 쿼리를 작성할때 주의점
1. WHERE 절이 있는지 없는지 확인..!!!! (데이터 전체가 업데이트될수가있음..)
    WHERE 절이 없다는건 모든행에 대해서 UPDATE 연산을 행한다는 의미
2.UPDATE 하기전에 기술한 WHERE 절을 SELECT 절에 적용하여 업데이트 대상
    데이터를 눈으로 확인하고 실행
    
    
    
    
