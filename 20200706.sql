OUTER JOIN <==> INNER JOIN 

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪼의 
             데이터 (컬럼)은 조회가 되도록 하는 조인 방식
             

OUTER JOIN :
    LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
    RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
    FULL OUTER JOIN  : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복되는것 제외
    
ANSI-SQL 
FROM 테이블 1 LEFT OUTER JOIN 테이블2 ON (조인조건)

ORACLE=SQL :
데이터가 없는데 나와야하는 테이블의 컬럼에 +
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+)

ANSI-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

ORACLE=SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno(+);

OUTER JOIN시 조인 조건(ON 절에 기술)과 일반조건(WHERE절에 기술)적용시 주의사항
: OUTER JOIN을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올수 있다.
    ==> OUTER JOIN의 결과가 무시
    
조인 조건을 WHERE 절로 변경 한 경우     
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno )
WHERE m.deptno = 10;

위의 쿼리는 OUTER JOIN을 적용하지 않은 아래 쿼리(일반 조인)와 동일한 결과를 나타낸다 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno )
WHERE m.deptno = 10;

ORACLE-SQL(위의 ANSI와 같음 (잘못됨))
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;
====================

ORACLE-SQL (+가하나라도 빠지면 INNER JOIN과 결과가 동일하다 주의)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

 RIGHT OUTER JOIN : 기준 테이블이 오른쪽 ;    
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno );
--왼쪽에 데이터가 안나온다는것은 누군가의 매니저가 아니라 안나온다는 뜻

FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno ); : 14건
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno ); : 21건

FULL OUTER : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno ); : 22건 

ORACLE SQL 에서는 FULL OUTER JOIN 문법을 제공하지 않음 (오류)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.mgr(+) = m.empno(+);

A : {1, 3, 5}
B : {2, 3, 4}
A U B : {1, 2, 3, 4, 5}집합에서 중복의 개념은 없다

FULL OUTER 데이터 검증 (공집합이 나와야함)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
MINUS
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

A : {1, 3}
B : {2, 3}
C : {1,2,3}
A - B = 공집합
A-C : 공집합
C-A : {2}

FULL OUTER 데이터 검증 (공집합이 나와야함)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
INTERSECT
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);


--실습(숙제) 1 p248~5낒;
SELECT *
FROM buyprod;

중요 키워드
WHERE : 행을 제한
JOIN : 
GROUP FUNCTION :  


시도 : 서울 특별시, 충청남도 
시군구 : 강남구, 청주시
스토어 구분 : 



