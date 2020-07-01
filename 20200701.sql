DECODE : 조건에 따라 반환 값이 달라지는 함수 
        ==> 비교 , JAVA (if) , SQL - case와 비슷 
        단 비교연산이 (=) 만 가능
        CASE의 WHEN절에 기술할 수 있는 코드는 참 거짓 판단 할 수 있는 코드면 가능
        ex) sal > 1000
        이것ㄱ과 다르게 DECODE 함수에서는 sal = 1000, sal = 2000
        
DECODE 는 가변인자 (인자의 갯수가 정해지지 않음, 상황에따라 늘어날 수도 있다.)를 갖는 함수
문법 : DECODE (기준값[col|expression],
                비교값 1, 반환값 1, 
                비교값 2, 반환값 2, 
                비교값 3, 반환값 3,
                옵션[기준값이 비교값 중에 일치하는 값이 없을 때 기본적으로 반환할 값]
                )
==> java 
-- ==(equal만 가능하다 그렇지않은 경우를 구현 하고싶으면 case 문으로 구현)
if (기준값 == 비교값1)
    반환값1을 반환
else if (기준값 == 비교값 2)
    반환값 2를 반환해준다 
else if (기준값 == 비교값 3)
    반환값 3을 반환해준다 
else 
    마지막 인자가 있을경우 마지막 인자를 반환하고
    마지막 인자가 없을경우 null을 반환 

--CASAE 구문    
SELECT empno,
       ename,
       CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
       END dname
FROM emp;

--DECODE 로 하는 방법
SELECT empno,
       ename,
       deptno,
       DECODE(deptno, 10,'ACCOUNTING',
                      20,'RESEARCH',
                      30,'SALES',
                      40,'OPERATIONS',
                      'DDIT')dname 
FROM emp;

--CASE 문 
SELECT ename, 
       job, 
       sal,
       (CASE
        WHEN job = 'SALESMAN' THEN sal *1.05
        WHEN job = 'MANAGER' THEN sal *1.10
        WHEN job = 'PRESIDENT' THEN sal *1.20
        ELSE sal
       END)inc_sal
FROM emp ;

--DECODE로 CASE 문 바꾸기 
SELECT ename, 
       job,
       sal,
       DECODE (job ,'SALESMAN' , sal *1.05,
                     'MANAGER', sal *1.10,
                     'PRESIDENT', sal *1.20,
                     sal)inc_sal 
FROM emp;

--문제
SELECT *
FROM emp ;
--위으 문제처럼 job에 따라서 sal 인상
-- 단 추가 조건으로 job이 MANAGER 이면서 소속부서(deptno)가 30(SALES)이면 sal * 1.5

SELECT ename, 
       job, 
       sal,
       (CASE
        WHEN job = 'MANAGER' AND deptno = 30 THEN sal *1.5
        WHEN job = 'SALESMAN' THEN sal *1.05
        WHEN job = 'MANAGER' THEN sal *1.10
        WHEN job = 'PRESIDENT' THEN sal *1.20        
        ELSE sal
       END)inc_sal
FROM emp;


--CASE의 중첩
SELECT ename, 
       job, 
       sal,
       (CASE
        WHEN job = 'SALESMAN' THEN sal *1.05
        WHEN job = 'MANAGER' THEN 
                                (CASE
                                    WHEN deptno = 30 THEN sal *1.5
                                    ELSE sal *1.10
                                END)
        WHEN job = 'PRESIDENT' THEN sal *1.20        
        ELSE sal
       END)inc_sal
FROM emp;

--위의 문제를 DECODE로 변경
SELECT ename, 
       job, 
       sal,
       DECODE(job , 'SALESMAN' ,sal * 1.05,
                     'MANAGER' , DECODE(deptno, 30, sal * 1.5,
                                                sal * 1.10
                                          ),
                     'PRESIDENT', sal * 1.20 ,
                      sal)inc_sal
FROM emp;

--실습 2 p178
==> 홀수인지 짝수인지 구분 할 수있는 값 함수 MOD
어떤수를 X로 나눈 나머지는 항상 0 ~ x-1

--좌절 
-- JAVA : 배열 , 객체(Class), 스레드
-- SQL : GROUP 함수 

SELECT empno, ename, hiredate,
        CASE 
            WHEN MOD(TO_CHAR(hiredate,'YY'),TO_CHAR(SYSDATE,'YY'))=0 THEN '대상'
            ELSE '비대상'
         END aa
FROM emp;

--3번쨰 문제
SELECT userid, usernm, alias, reg_dt, 
        CASE 
            WHEN reg_dt IS NULL THEN '비대상'
            ELSE '대상'
        END COMTACTTODOCTOR
FROM users;

SELECT userid, usernm, reg_dt, 
        CASE 
            WHEN MOD(TO_CHAR(reg_dt,'YY'),TO_CHAR(SYSDATE,'YY'))=0 THEN '대상'
            ELSE '비대상'
        END COMTACTTODOCTOR
FROM users;

--DECODE로 구현 
SELECT userid, usernm, reg_dt, 
        DECODE (MOD(TO_CHAR(reg_dt,'YY'),2),
                        MOD(TO_CHAR(SYSDATE,'YY'), 2)
                        , '대상', '비대상') COMTACTTODOCTOR
FROM users;


SELECT *
FROM emp;

그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준1, 행들을 묶을 기준2 , 그룹함수
FROM 테이블명
[WHERE]
GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2
HAVING 
ORDER BY

1.부서번호별 sal 컬럼의 합
==>부서번호가 같은 행들을 하나의 행으로 만든다;
2. 부서번호 별 가장 큰 급여를 받는 사람 급여 액수
3. 부서번호 별 가장 작은 급여를 받는 사람 급여 액수
4. 부서번호 별 급여 평균 액수
5. 부서번호 별 급여가 존재하는 사람의수 (sal 컬럼이 null이 아닌 행의 수)

SELECT deptno, SUM(sal), MAX(sal),MIN(sal), ROUND(AVG(sal),2) --소수점 둘쨋자리까지
        ,COUNT(sal), --(sal 컬럼이 null이 아닌 행의 수)
        COUNT(*) ,--(sal 컬럼의 행수 (null포함))
        COUNT(comm)
FROM emp
GROUP BY deptno;

그룹함수의 특징 : 
1.  null값을 무시
    30번 부서의 사원 6중 2명은 comm 값이 NULL

SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

그룹함수의 특징 :
2.  GROUP BY 를 적용 여러행을 하나의 행으로 묶게되면은
    SELECT 절에 기술할 수있는 컬럼이 제한됨;
    ==> SELECT 절에 기술되는 일반 컬럼들은(그룹함수를 적용하지 않은)
        반드시 GROUP BY 절에 기술되어야 한다.
        * 단 그루핑에 영향을 주지않는 고정된 상수, 함수는 기술하는 것이 가능하다
--오류
SELECT deptno,ename , SUM(sal)
FROM emp
GROUP BY deptno;

--가능
SELECT deptno, MAX(ename) , SUM(sal)
FROM emp
GROUP BY deptno;

--컬럼의 수가 늘어남 
SELECT deptno,ename, SUM(sal)
FROM emp
GROUP BY deptno,ename;

-- 상수값(10,SYSDATE)같은 고정값은 그루핑에 영향을 주지않음
SELECT deptno, 10, SYSDATE , SUM(sal)
FROM emp
GROUP BY deptno,ename;

** 그룹함수 이해하기 힘들다 ==> 엑셀에 데이터를 그려보자 


그룹함수의 특징 : 
3. 일반함수를 WHERE 절에서 사용하는게 가능
    (WHERE UPPER ('smith') = 'SMITH';)
    그룹함수의 경우 WHERE 절에서 사용하는게 불가능
    하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다.

SELECT deptno ,  SUM(sal)
FROM emp
WHERE SUM(sal) > 9000
GROUP BY deptno;

SELECT deptno , SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- 위의 쿼리를 HAVING 절 없이 SQL 작성;
SELECT deptno,sal
FROM (SELECT deptno , SUM(sal)sal
        FROM emp
        GROUP BY deptno)
WHERE sal > 9000 ;

SELECT 쿼리 문법 총정리

SELECT 
FORM
WHERE 
GROUP BY 
HAVING
ORDER BY 

GROUP BY 절에 행을 그룹핑할 기준을 작성
예) 부서번호별로 그룹을 만들경우
    GROUP BY deptno
    
전체행을 기준으로 그루핑을 하려면 GROUP BY 절에 어떤컬럼을 기술해야할까?
emp 테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면? ==> 결과는 1개의 행
==> GROUP BY 절을 기술하지않는다;

SELECT SUM(sal)
FROM emp;

--에러
SELECT deptno ,SUM(sal)
FROM emp;

-- GROUP BY 절에 기술한 컬럼을 SELECT 절에 기술하지 않은경우??
 ==> 결과 나온다 있지만 보여주지않을뿐 
SELECT SUM(sal)
FROM emp
GROUP BY deptno;

그룹함수의 제한사항 
부서번호별 가장 높은 급여를 받는 사람의 급여액
그래서 그 사람이 누군데? (서브쿼리 , 분석함수를 사용해서 알 수 있다. 그룹함수로는 모름)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;





