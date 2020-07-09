1. GROUP BY (여러개의 행을 하나의 행으로 묶는 행위)
2. JOIN
3. SUBQUERY (중요 **)
    1. 사용위치
    2. 반환하는 행 , 컬럼의 개수
    3. 컬럼 사용 유무(상호연관/ 비상호연관)
        ==> 메인쿼리의 컬럼을 서브쿼리에서 사용하는지(참조하는지) 유무
        : 비상호연관 서브쿼리의 경우 단독실행가능 (SQL 이 무가먼저 실행되는지 유리한걸 찾아서 실행 280)
        : 상호연관 서브쿼리의 경우 실행하기위해서 메인쿼리의 컬럼을 사용하기 때문에 단독실행불가
        
sub2 사원들의 급여평균보다 높은 급여를 받는 직원
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원정보조회
(참고, 스칼라서브쿼리를 이용해서 해당 사원이 속한 부서의
부서이름을 가져오도록 작성해봄);
--실습2 266
전체사원의 정보를 조회, 조인 없이 해당 사원이 속한 부서의 부서이름 가져오기
SELECT empno, ename.deptno , 부서명
FROM emp
WHERE sal > ();

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno=e.deptno);
             
부서평균
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;


SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE dname IN(SELECT dname FROM dept WHERE deptno=emp.deptno));


--실습 3
단일 값 비교는 =
복수행(단일컬럼) 비교는 IN
SELECT *
FROM
    (SELECT * 
    FROM emp e1
    WHERE deptno  = (SELECT deptno FROM emp WHERE ename='SMITH')
    OR deptno  = (SELECT deptno FROM emp WHERE ename='WARD'))aa
ORDER BY aa.deptno;

SELECT * 
FROM emp 
WHERE deptno IN (SELECT deptno FROM emp WHERE ename IN ('SMITH','WARD'));

=========================================================
--** IN 과 NOT IN 이용시 NULL 값의 존재 유무에따라 원하지 않는 결과가 나올수도있다
NULL 과 IN, NULL과 NOT IN
IN => OR
NOT IN => AND

WHERE mgr IN (7902,null)
=> mgr = 7902 OR mgr = null (널은 IS NULL 로만 비교가능 즉 두번재 조건은 무시하게됨)
=> mgr값이 7902 이거나 [mgr값이 null인 데이터]

SELECT *
FROM emp
WHERE mgr IN (7902, null);

WHERE mgr NOT IN (7902, null);
=> NOT (mgr = 7902 OR mgr = null )
=> !mgr = 7902 AND mgr != null 
(앤드는 둘다만족해야되는데 널은 무조건 이즈해야하는데 무조건 펄스 거짓 절대안나옴 데이터)
오류는 아닌데 안나옴 
==============================
pairwise, non-pairwise 274
한행의 컬럼값을 하나씩 비교하는것 : non-pairwise
한행의 복수컬럼을 비교하는것 : pairwise

SELECT *
FROM emp
WHERE job IN ('MANAGER','CLERK');

SELECT *
FROM emp
WHERE (job , deptno) IN (('MANAGER',20),('CLERK',20));

SELECT *
FROM emp
WHERE job IN ('MANAGER','CLERK')
  AND deptno =20;


페어와이즈6
아래의 쌍만 가능
7698,30 
7839,10
SELECT *
FROM emp
WHERE (mgr , deptno) IN (SELECT mgr ,deptno
                         FROM emp
                         WHERE empno IN (7499,7782));

논 페어와이즈7
위의 쌍만 가능한게아니라 크로스도 가능
7698,30 7698,10 
7839,10 7839,30
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr 
              FROM emp
              WHERE empno IN (7499,7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499,7782));     
               
               
--실습4
INSERT INTO dept VALUES (99,'ddit','daejeon'); 

SELECT *
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (10, 20, 30);
deptno 가 emp 테이블에 등록된 사언들이 소속된부서가 아닌것 

SELECT *
FROM dept 
WHERE deptno NOT IN (SELECT deptno FROM emp );

SELECT deptno 
FROM emp
GROUP BY deptno; --집합이라 중복된값잉 ㅣㅆ어도 상관없어서 위에서 안써줌

--실습5
SELECT * 
FROM cycle;

SELECT * 
FROM product;

SELECT *
FROM product 
WHERE pid NOT IN (SELECT pid FROM cycle WHERE cid =1) ;
  
--실습 6
SELECT * 
FROM cycle 
WHERE cid =1 
  AND pid IN (SELECT pid 
              FROM cycle 
              WHERE cid =2);
--선생님풀이
1번고객 100,400
2번고객 100, 200
단일값 = 단일값
단일값= 복수값 (사용 안됨)
하드코딩
SELECT * 
FROM cycle 
WHERE cid =1 
  AND pid =100;


