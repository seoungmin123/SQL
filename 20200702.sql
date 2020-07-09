GROUP 함수의 특징
1.NULL 은 그룹함수 연산에서 제외가 된다

부서번호별 사원의 sal, comm 컬럼의 총 합을 구하기

SELECT  deptno,
        SUM(sal+comm),--널에 대한 연산이 나온다
        SUM(sal+NVL(comm,0)), --널을 일단 0으로 만든 후 계산
        SUM(sal)+SUM(comm)
FROM emp
GROUP BY deptno;

NULL처리의 효율
SELECT  deptno,        
        SUM(sal)+NVL(SUM(comm),0),
        SUM(sal)+SUM(NVL(comm,0))        
FROM emp
GROUP BY deptno;

--실습 문제 1 p193
SELECT MAX(sal) max_sal, 
       MIN(sal) min_sal,
       ROUND(AVG(sal),2)avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal)cnt_sal,
       count(mgr)cnt_mgr,
       count(*) cnt_all
FROM emp;

--실습문제2 194
SELECT deptno,
       MAX(sal) max_sal, 
       MIN(sal) min_sal,
       ROUND(AVG(sal),2)avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal)cnt_sal,
       count(mgr)cnt_mgr,
       count(*) cnt_all
FROM emp
GROUP BY deptno;

--실습문제 3
SELECT DECODE(deptno, 10 ,'ACCOUNTING',
                      20 , 'RESRATCH',
                      30, 'SALES'
                      'DDIT')dname,
       MAX(sal) max_sal, 
       MIN(sal) min_sal,
       ROUND(AVG(sal),2)avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal)cnt_sal,
       count(mgr)cnt_mgr,
       count(*) cnt_all
FROM emp
GROUP BY  deptno;

--실습 4
SELECT TO_CHAR(hiredate,'YYYYMM')hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

--5
SELECT TO_CHAR(hiredate,'YYYY')hire_yyyy, COUNT(*)cnt
FROM emp
GROUP BY   TO_CHAR(hiredate,'YYYY') ;

--6 198
SELECT COUNT(deptno) cnt
FROM (SELECT deptno 
      FROM dept
      GROUP BY deptno;);
      
SELECT count(*)cnt
FROM dept;

--7 
SELECT COUNT(deptno) cnt
FROM (SELECT deptno 
      FROM emp
      GROUP BY deptno);

SELECT COUNT(COUNT(deptno))cnt
FROM emp
GROUP BY deptno;


JOIN : 컬럼을 확장하는 방법(데이터 연결) 
       다른 테이블의 컬럼을 가져온다.
RDBMS 가 중복을 최소화하는 구조이기 때문에
하나의 테이블에 데이터를 전부 담지않고, 목적에 맞게 설계한 테이블에
데이터가 분산이 된다.
하지만 데이터를 조회할 때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

ANSI-SQL :American National Standard Institute-SQL 
ORACLE-SQL 문법 : 

JOIN : ANSI-SQL 
       ORACLE-SQL 의 차이가 다소 발생



ANSI-SQL join
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결
               컬럼 이름뿐만 아니라 데이터 타입도 동일해야함.              
문법 :
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블 2    
--중복컬럼은 한번만 조회
        
emp, dept 두 테이블의 공통된 이름을 갖는 컬럼 : deptno;
-- 조인조건으로 사용된 컬럼(deptno)은 테이블 한정자를 사용하지 못한다 (ANSI-SQL)
-- d.deptno 안된다는 뜻
SELECT e.empno, e.ename , deptno, dname
FROM emp e NATURAL JOIN dept d;

위의 쿼리를 ORACLE 버전으로 수정
오라클에서는 조인조건을 WHERE절에 기술
행을 제한하는 조건, 조인조건 ==> WHERE 절에 기술 

SELECT e.* , e.deptno ,dname
--한정자를 안붙이고 deptno 쓰면 오류나서 한정자 필수
FROM emp e, dept d
WHERE e.deptno = d.deptno; 

-- 다를 때 조인 (10-20,30,40과 조인,20일떄 10,30,40)
SELECT e.* , e.deptno ,dname
FROM emp e, dept d
WHERE e.deptno != d.deptno; 

ANSI-SQL : JOIN WITH USING
조인 테이블간 동이란 이름의 컬럼이 복수개 인데
이름이 같은 컬럼중 일부로만 조인하고 싶을때 사용
SELECT *
FROM emp e JOIN dept d USING (deptno);

위의 쿼리를 ORACLE 조인으로 변경하면?
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;

ANSI_SQL : JOIN WITH ON
            위에서 배운 NATURAL JOIN, JOIN WITH USING의 경우 
            조인테이블의 조인컬럼이 이름이 같아야한다는 제약조건이 있음
            설계상 두 테이블 컬럼의 이름이 다를수도있음
            컬럼이름이 다를경우 개발자가 직접 조인조건을 기술 할 수 있도록 제공해주는 문법

SELECT *
FROM emp e JOIN dept d ON (e.deptno = d.deptno);

ORACLE-SQL 의 경우
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELF-JOIN : 동일한 테이블끼리 조인 할 때 지칭하는 명칭
            (별도의 키워드가 아니다)
                        
SELECT 사원번호, 사원이름 , 사원의상사 사원번호, 사원의 상사이름
FROM emp;
-- KING의 경우 상사가 없기 떄문에 조인에 실패한다
-- 총 행의 수는 13건이 조회된다
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

SELECT*
FROM emp;

사원중 사원의번호가 7369부터 7698인 사원만 대상으로 해당 사원의 
사원번호, 이름, 상사의 사원번호 ,상사의 이름
SELECT e.empno, e.ename, e.mgr mgr_empno, m.ename ename
FROM emp e JOIN emp m ON (e.mgr = m.empno) --매니저사번이가 사원사번이랑 같을때(매니저 정보(이름))
WHERE e.empno BETWEEN 7369 AND 7698 ;

ORACLE 문법
SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr 
        FROM emp 
        WHERE empno BETWEEN 7369 AND 7698) a, emp 
WHERE a.mgr = emp.empno;

ANSI-SQL 문법 
SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr 
        FROM emp 
        WHERE empno BETWEEN 7369 AND 7698) a JOIN emp ON (a.mgr = emp.empno);


NON-EQUI-JOIN :조인조건이 = 이 아닌 조인
              != 값이 다를때 연결

--직원들의 급여등급을 알고싶을때          
SELECT empno, ename , sal, s.grade 
FROM emp e, salgrade s
WHERE sal BETWEEN s.losal AND s.hisal;

SELECT * 
FROM emp;

--선분 데이터 (로우부터 하이까지 행을 직선으로 연결을 했을때 빠지는 값이 없는 데이터)
SELECT *
FROM salgrade;


--실습0
SELECT  e.EMPNO, e.ENAME, d.DEPTNO, d.DNAME
FROM emp e , dept d
WHERE e.deptno= d.deptno
ORDER BY d.deptno;

-- 실습 1
SELECT  e.EMPNO, e.ENAME, d.DEPTNO, d.DNAME
FROM emp e , dept d
WHERE e.deptno= d.deptno
  AND e.DEPTNO IN (10,30);

--실습2
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
ORDER BY d.deptno;

--실습 3
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
  AND e.empno > 7600
ORDER BY d.deptno;

--실습4
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
  AND e.empno > 7600
  AND d.dname IN ('RESEARCH')
ORDER BY d.deptno;

select *
from prod;

select * 
from lprod;

--데이터결합1
select p.prod_lgu, l.LPROD_NM, p.prod_id,p.prod_name
from prod p JOIN lprod l ON (p.prod_lgu = l.lprod_gu);

--데이터 결합2
select *
from buyer;

select *
from buyer b JOIN prod p ON (b.buyer_lgu = p.prod_lgu)

