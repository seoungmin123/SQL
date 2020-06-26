--WHERE 절에서 사용가능한 연산자 : LIKE
--사용용도 : 문자의 일부분으로 검색을 하고 싶을 때 사용
--    ex : ename 컬럼의 값이 S 로 시작하는 사원들을 조회
--사용방법: 컬럼 LIKE '패턴문자열'
--마스킹 문자열 : 1. % : 문자가 없거나, 어떤 문자든지 여러개의 문자열
 --                   'S%' : S로 시작하는 모든 문자열을 조회
  --                          => S, SS , SMITH
   --           2. _ : 어떤 문자든 딱 하나의 문자를 의미 
    --                'S_' : S로 시작하고 두번쨰 문자가 어떤 문자든 하나의 문자가 오는 2자리 문자열을 의미 
     --               "S____' : S로 시작하고 문자열의 길이가 5글자인 문자열 
                    
--emp 테이블에서 ename 컬럼의 값이 S로 시작하는 사원들만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--실습4 p87
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--실습5 p88
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

UPDATE member set mem_name = '쁜이'
WHERE mem_id = 'b001';

UPDATE member set mem_name = '신이환'
WHERE mem_id = 'c001';


----null 
--null 비교 : = 연산자로 비교 불가 ==> IS
--NULL을 = 비교하여 조회
SELECT empno, ename , comm
FROM emp
WHERE comm = NULL;
--WHERE 6번 문제 
--NULL 값에 대한 비교는= 이 아니라 IS 연산자를 사용한다. 
SELECT empno, ename , comm
FROM emp
WHERE comm IS NULL;

--emp 테이블에서 comm 값이 null이 아닌 데이터를 조회
SELECT empno, ename , comm
FROM emp
WHERE comm IS NOT NULL;

--논리연산자 : AND, OR
--AND: 참 거짓 판단식1 AND 참 거짓 판단식2 ==> 식 두개를 동시에 만족하는 행만 참
--       일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다 (전부를 만족해야하니까)
--OR: 참 거짓 판단식1 OR 참 거짓 판단식2 ==> 식 두개를 하나라도 만족하면 참
--      (조건들중에 한개만 만족하면됨) 즉 일반적으로 OR 조건이 많이 붙으면 행의 수가 늘어난다
-- NOT : 조건을 반대로 해석하는 부정형 연산
--      NOT IN :  
--      IS NOT NULL : 


--emp 테이블에서 mgr 컬럼값이 7698이면서 sal 컬럼의 값이 1000보다 큰 사원 조회 
--2가지 조건을 동시에 만족하는 사원리스트 
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000 ;
-- mrg 값이 7698 이거나 (5건)
-- sal 값이 1000보다 크거나(12건) 두개의 조건을 하나라도 만족하는 행을 조회
SELECT *
FROM emp
WHERE mgr = 7698
  OR sal > 1000 ;

--emp 테이블에서 mgr 가 7698, 7839가 아닌 사원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839);

SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839);

-- WHERE mgr IN (7698,7839);
-- => mgr =7698 OR mgr = 7839 

-- WHERE mgr NOT IN (7698,7839);
-- => !(mgr =7698 OR mgr = 7839) 
-- ==> (mgr != 7698 AND mgr != 7839) 

-- **** mgr 컬럼에 NULL값이 있을 경우 비교연산으로 NULL 비교가 불가하기 떄문에
-- **** NULL행은 무시가 된다. 

SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr !=7839;


--WHERE 실습 7
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 AND hiredate >= TO_DATE('19810601','yyyymmdd') ;

--WHERE 실습 8
SELECT *
FROM emp 
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601','yyyymmdd');

--WHERE실습 9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
 AND hiredate >= TO_DATE('19810601','yyyymmdd');
 
-- -WHERE실습 10
SELECT *
FROM emp
WHERE deptno IN (20,30)
 AND hiredate >= TO_DATE('19810601','yyyymmdd');
 
 -- WHERE실습 11 p98
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
--     job = 'SALESMAN'
 OR hiredate >= TO_DATE('19810601','yyyymmdd') ;
 
-- WHERE실습 12 p99
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
--     job = 'SALESMAN'
 OR empno LIKE '78%'; --형변환 : 명시적 , 묵시적 
 
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 OR ((empno >= 7800
   AND empno <= 7899)
   OR (empno >= 780
   AND empno <= 789)
   OR (empno >= 78
   AND empno < 79));
 
-- WHERE실습 13 p100
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 OR empno BETWEEN 7800 AND 7899
 OR empno BETWEEN 780 AND 789
 OR empno = 78;

--NOT  
----emp 테이블에서 mgr 가 7698이 아니고 7839가 아닌 사원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839);

--emp 테이블에서 mgr 가 7698이 아니고 7839가 아니고 NULL이 아닌 사원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839,NULL);
--데이터가 왜 안나왔는지 ? 
mgr가 (7698,7839,NULL)에 포함된다 

WHERE mgr IN (7698,7839,NULL); 
=> mgr = 7698 OR mgr =7839 OR mgr = NULL

WHERE mgr NOT IN (7698,7839,NULL); 
=> mgr != 7698 AND mgr !=7839 AND mgr != NULL
-- NULL은 =연산자 안쓰고 IS로 연산하자나 
--즉 조회가 안된다 (AND) 참 AND 참 => 참

-- 하지만 OR 는 앞의 연산자에 따라서 값이 나올 수도 있고 아닐수도있다
-- 참 OR 거짓=>참 둘중하나면 참이면되니까

-- 연산자 우선순위
-- *, / > +, -

-- WHERE실습 14
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 OR empno LIKE '78%'
 AND hiredate >= TO_DATE('19810601','yyyymmdd');
 
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR ((empno BETWEEN 7800 AND 7899
   OR  empno BETWEEN 780 AND 789
   OR  empno = 78)
  AND hiredate >= TO_DATE('19810601','yyyymmdd'));
  
-- 오라클에서 실행하는 순서 
-- 1. SELECT    3
-- 2. FROM      1
-- 3. WHERE     2
-- 4. ORDER BY  4 

--정렬 
-- RDBMS 집합적인 사상을 따른다
-- 집합에는 순서가 없다. {1, 3, 5} == {3, 5, 1}
-- 집합에는 중복이 없다. {1, 3, 5, 1} == {3, 5, 1}
  
  
SELECT *
FROM emp 
ORDER BY ename;

SELECT *
FROM emp 
ORDER BY ename desc;

SELECT *
FROM emp 
ORDER BY 2;

--정렬방법 : ORDER BY 절을 통해 정렬 기준 컬럼을 명시
--            컬럼뒤에 [ASC|DESC]을 기술하여 오름차순, 내림차순을 지정할 수 있다. 
-- 1. ORDER BY 컬럼
-- 2. ORDER BY 별칭
-- 3. ORDER BY SELCT 절에 나열된 컬럼의 인덱스 번호 

-- 별칭으로 ORDER BY
SELECT empno, ename , sal , sal*12 salay
FROM emp
ORDER BY salay;

--  SELCT 절에 기술된 컬럼순서(인덱스)로 정렬 
SELECT empno, ename , sal , sal*12 salay
FROM emp
ORDER BY 4;


--실습 order by 1 p109
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

--실습 order by2 p110
SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm != 0
ORDER BY comm DESC, empno DESC ;

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno DESC ;

--실습 order by3 p111
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job , empno DESC;

--실습 order by4 p111
SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY job , ename DESC;
