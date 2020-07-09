
한행에 다음과 같이 컬럼이 구성되면 공식을 쉽게 적용할 수 있다

시도, 시군구, kfc 개수 , 버거킹 개수, 맥도날드 개수, 롯데리아 개수

주어진것 : 점포 하나하나의 주소 
1.시도, 시군구 ,프렌차이즈 별로 GROUP BY 
    1.1 시도, 시군구, kfc 개수
    1.2 시도, 시군구, 맥도날드 개수
    1.3 시도, 시군구, 버거킹 개수
    1.4 시도, 시군구, 롯데리아 개수
1.1~1.4 4개의 데이터셋을 이용해서 컬럼을 확장이 가능 ==> join
시도,시군구 같은 데이터끼리 조인

2. 시도, 시군구 ,프렌차이즈 별로 GROUP BY *2
    2.1 시도, 시군구, 분자 프렌차이즈 합 개수
    2.2 시도, 시군구, 분모 프렌차이즈(롯데리아) 합 개수
    2.1~2.1 2개의 데이터셋을 이용해서 컬럼을 확장이 가능 ==> join
    시도,시군구 같은 데이터끼리 조인
    
3.모든 프렌차이즈를 한번만 읽고 처리하는 방법
    3.1 fastfood 테이블의 한 행은 하나의 프렌차이즈에 속함
    3.2 가상의 컬럼을 4개를 생성
        3.2.1 해당 row가 kfc 면  1
        3.2.2 해당 row가 버거킹 이면 1
        3.2.3 해당 row가 맥도날드 면  1
        3.2.4 해당 row가 롯데리아 면 1
    3.2 과정에서 생성된 컬럼 4개 중에 값이 존재하는 컬럼은 하나만 존재함
        (하나의 행은 하나의 프렌차이즈의 주소를 나타내는 정보)
    3.3 시도, 시군구 별로 3.2과정에서 생성한 컬럼을 더하면 
        우리가 구하고자하는 프렌차이즈별 건수가된다;
        
SELECT sido, sigungu, 
       ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0)+
       NVL(SUM(DECODE(gb, '버거킹', 1)),0)+
       NVL(SUM(DECODE(gb, '맥도날드', 1)),0))/
       NVL(SUM(DECODE(gb, '롯데리아', 1)),0.1),2) score
FROM fastfood
WHERE gb IN ('KFC', '버거킹', '맥도날드' , '롯데리아')
GROUP BY sido, sigungu
ORDER BY score DESC;

SELECT sido, sigungu, 
       ROUND((NVL(SUM(DECODE(STORECATEGORY, 'KFC', 1)),0)+
               NVL(SUM(DECODE(STORECATEGORY, 'BURGER KING', 1)),0)+
               NVL(SUM(DECODE(STORECATEGORY, 'MACDONALD', 1)),0))/
               NVL(SUM(DECODE(STORECATEGORY, 'LOTTERIA', 1)),1),2) score
FROM burgerstore
WHERE STORECATEGORY IN ('BURGER KING', '버거킹', 'MACDONALD' , 'LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC;

SELECT *
FROM tax;

도시발전순위 순위, 햄버거 발전지수 시도,햄버거 발전지수 시군구, 햄버거 발전지수 , 
근로소득 순위 ,근로소득 시도,근로소득 시군구 ,1인당 근로소득액

같은 순위끼리 하나의 행에 데이터가 보여지도록 

1 서울 강남구 6.4 1 울산 동구 80
2. 강원 춘천시 6 2 서울 강남구 70

SELECT *
FROM tax;

SELECT ROWNUM rank, sido, sigungu,m_sal
FROM(SELECT sido, sigungu, ROUND(sal/people,2)m_sal
     FROM tax
     ORDER BY m_sal) ;
=============================
수업시작
SELECT ROWNUM rank ,  sido, sigungu, score
FROM 
(SELECT sido, sigungu, 
       ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)), 0) + 
             NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)), 0) +
             NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)), 0)) /
             NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)), 1), 2) score
FROM burgerstore
WHERE storecategory IN ('MACDONALD', 'KFC', 'BURGER KING', 'LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC);

====================
SELECT *
FROM (SELECT ROWNUM rank, sido, sigungu, score
      FROM (SELECT sido, 
                  sigungu, 
                  ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)), 0) + 
                         NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)), 0) +
                         NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)), 0)) /
                         NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)), 1), 2) score
            FROM burgerstore
            WHERE storecategory IN ('MACDONALD', 'KFC', 'BURGER KING', 'LOTTERIA')
            GROUP BY sido, sigungu
            ORDER BY score DESC))bg ,
      (SELECT ROWNUM rank, sido, sigungu,m_sal
      FROM(SELECT sido, sigungu, ROUND(sal/people,2)m_sal
           FROM tax
           ORDER BY m_sal DESC))city
WHERE city.rank = bg.rank (+)
ORDER BY city.rank;

============================
수업
CROSS JOIN : 테이블간 조인 조건을 기술하지 않는 형태로
             두 테이블의 행간 모든 가능한 조합으로 조인이 되는 형태
             크로스조인의 조회결과를 필요로하는 메뉴는 거의없음
             * SQL의 중간단계에서 필요한 경우는 존재
emp : 14
dept : 4;
원래 하려던것 : emp 에 있는 부서번호를 이용하여 dept쪽에 있는 dname, loc컬럼을 가져오는것 ;
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d;
==>56건 (크로스조인 14*4건)
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno= d.deptno;
==> 연결조건시 14건

크로스 조인 문법
ANSI
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e CROSS JOIN dept d;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e JOIN  dept d ON(1=1);

오라클 (WHERE 절에 별다른 조건기술 없을때)
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d;

--실습 p258
SELECT cid , cnm, pid, pnm
FROM customer, product;

SUBQUERY : SQL 내부에서 사용된 SQL (main쿼리에서 사용된 쿼리)
    ㄱ.사용위치에 따른 분류
        1. SELECT 절 : scalar(단일의) subquery
        2. FROM 절 : INLINE-VIEW
        3. WHERE 절 : subquery   
        
    ㄴ. 반환하는 행, 컬럼수에따라 분류
        1. 단일행, 단일컬럼
        2. 단일행, 복수컬럼
        3. 다중행, 단일컬럼
        4. 다중행, 복수컬럼

    ㄷ. 서브쿼리에서 메인쿼리의 컬럼을 사용유무에 따른 분류
        1. 서브쿼리에서 메인 쿼리의 컬럼사용 : correlated subquery ==> 상호연관 서브쿼리
            => 서브쿼리 단독실행 불가능
        2. 서브쿼리에서 메인커리의 컬럼 미사용 : non correlated subquery ==> 비상호연관 서브쿼리
            => 서브쿼리 단독실행 가능
            
SMITH 사원이 속한 부서에 속하는 사원들은 누가있을까
2번의 쿼리가 필요
1. 스마스가 속한 부서의 번호를 확인하는 쿼리
2. 1번에서 확인한 부서번호로 해당 부서에 속하는 사원들을 조회하는 쿼리

1.번쿼리
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2번쿼리 
SELECT *
FROM emp
WHERE deptno =20;

SMITH가 현재 상황에서 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이되어야한다 
WHERE deptno =20; ==> WHERE deptno =300;
우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회하는 것이 아니라
SMITH 가 속한 부서를 통해 데이터를 조회 ==> SMITH가 속한 부서가 바뀌더라도
쿼리를 수정하지 않도록하는것 

위에서 작성한 두개의 쿼리를 하나로 합칠 수 있다
==> SMITH의 부서번호가 변경되더라도 우리가 원하는 데이터 셋을
쿼리수정없이 조회할 수 있다 ==> 코드변경이 필요없다 => 유지보수가 편하다 
 (바깥쪽에 있는것 메인쿼리 속에있는거 서브쿼리 p262 )
 
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
                ELECT 절 : scalar(단일의) subquery
        2. FROM 절 : INLINE-VIEW
        3. WHERE 절 : subquery
                
1. scalar subquery (스칼라서브쿼리 )
    : SELECT 절에서 사용된 서브쿼리
    * 제약사항: 반드시 서브쿼리가 하나의 행 , 하나의 컬럼을 반환해야된다.
    
스칼라서브쿼리가 다중행 복수컬럼을 리턴하는경우 (X)   
SELECT empno, ename,(SELECT deptno, dname FROM dept)
FROM emp; --너무많아서안돼
스칼라서브쿼리가 단일행 복수컬럼을 리턴하는 경우 (X)            
SELECT empno, ename,(SELECT deptno, dname FROM dept WHERE deptno=10)
FROM emp;
스칼라 서브쿼리가 단일행 단일컬럼을 리턴하는경우 (o)
SELECT empno, 
       ename,
       (SELECT deptno FROM dept WHERE deptno=10)deptno,
       (SELECT dname FROM dept WHERE deptno=10)dname
FROM emp;

메인쿼리의 컬럼을 사용하는 스칼라 서브쿼리(비상호)
SELECT empno, 
       ename,
       deptno,
       (SELECT dname FROM dept WHERE deptno=emp.deptno)dname
FROM emp;

SELECT empno, 
       ename,
       deptno,
       (SELECT dname FROM dept WHERE dept.deptno=emp.deptno)dname
FROM emp;

SELECT *
FROM dept
WHERE dept = 10;


인라인뷰
: 그동안 많이 사용


서브쿼리 : WHERE 절에서 사용된 것 
스미스가 속한 부서에 속하는 사원들조회
WHERE 절에서 서브쿼리 사용시 주의점
연산자와 서브쿼리의 반환행수 주의
= 연산자를 사용시 서브쿼리에서 여러개의 행(값)을 리턴하면 논리적으로 맞지않다
 IN 연산자를 사용시 서브쿼리에서 리턴하는여러개 행 (값)을 비교가능
스미스 20 엘런 30
--웨어절에 =쓰면 에러 (=는 싱글결과일때만)
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','ALLEN'));
--웨어절에 IN사용 (복수결과가 궁금하면 IN 사용)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','ALLEN'));
            --= WHERE deptno = (20,30); 여러개를 비교할땐 =안됨            
            --= WHERE deptno IN (20,30); 여러개를 비교할땐 IN (OR의 의미니까)
            
            
--서브쿼리 실습 265
SELECT ROUND( AVG(sal),2) AVG
FROM emp;

SELECT COUNT(*)cnt
FROM emp
WHERE sal > (SELECT ROUND( AVG(sal),2) AVG 
             FROM emp);

--서브쿼리 실습2
SELECT *
FROM emp
WHERE sal > (SELECT ROUND( AVG(sal),2) AVG 
             FROM emp);
