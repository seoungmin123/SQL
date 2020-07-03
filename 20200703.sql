-- 데이터 결합1
SELECT p.prod_lgu, l.LPROD_NM, p.prod_id, p.prod_name
FROM prod p JOIN lprod l ON p.prod_lgu = l.lprod_gu;

ANSI_SQL 두 테이블의 연결 컬럼명이 다르기때문에
NATURAL JOIN, JOIN with USING은 사용이 불가하다.
--데이터 결합 2
SELECT b.buyer_id, b.buyer_name,p.prod_id, p.prod_name
FROM buyer b JOIN prod p ON b.buyer_id= p.prod_buyer ; 

--데이터 결합 3
--오라클 SQL      
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name,c.cart_qty
FROM prod p , cart c, member m 
WHERE p.prod_id = c.cart_prod
  AND c.cart_member = m.mem_id;
  
-- ANSI - SQL
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name,c.cart_qty
FROM (prod p JOIN cart c ON p.prod_id = c.cart_prod)
     JOIN member m ON c.cart_member = m.mem_id;
     
    CUSTOMER  : 고객
    PRODUCT   : 제품
    CYCLE(주기): 고객 제품 애음 주기 1 일요일 -7
    BATCH     :  
    DAILY     : 
     
-- 실습 4
SELECT cu.cid, cu.cnm, cy.pid, cy.day, cy.cnt
FROM customer cu JOIN cycle cy ON cu.cid =cy.cid 
WHERE cu.cid IN (1,2);

--실습 5
SELECT cu.cid, cu.cnm, p.pnm, cy.day, cy.cnt
FROM customer cu JOIN cycle cy ON cu.cid =cy.cid 
     JOIN product p ON cy.pid = p.pid
WHERE cu.cid IN (1,2);
     
--실습 6
SELECT cu.cid, cu.cnm, p.pid, p.pnm, SUM(cy.cnt)cnt
FROM customer cu JOIN cycle cy ON cu.cid =cy.cid 
     JOIN product p ON cy.pid = p.pid
GROUP BY cu.cid, cu.cnm, p.pid, p.pnm
ORDER BY cu.cid;

15조인 ==> 6group 
select * 
from (select cid , pid, SUM(cnt)
from cycle 
group by cid ,pid ), 

--실습 7
SELECT p.pid, p.pnm, SUM(cy.cnt)
FROM  cycle cy JOIN product p ON cy.pid = p.pid
GROUP BY  p.pid, p.pnm
ORDER BY p.pid;


--8번 부터 13번 숙제
조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조인방법
OUTER JOIN : 조인에 실패하더라도 개발자가 지정한 기준이 되는 테이블의 
             데이터는 나오도록 하는 조인 
OUTER <==> INNER JOIN
LEFT OUTER JOIN
RIGHT OUTER JOIN 
FULL OUTER JOIN(LEFT+ RIGHT)
복습 - 사원의 관리자 이름을 알고싶은 상황
    조회컬럼 : 사원의 사번, 사원의 이름, 사원의 관리자의 사번, 사원관리자의 이름
--매니저에 관한 정보는 직원 테이블에서 얻음
동일한 테이블 끼리 조인되었기 때문에 : SELF JOIN
조인 조건을 만족하는 데이터만 조회되었기 때문에 : INNER JOIN
SELECT e.empno, e.ename, e.mgr , m.ename
FROM emp e JOIN emp m ON e.mgr = m.empno ;

select *
from emp;
KING의 경우 PRESIDENT 이기 떄문에 mgr 컬럼의 값이 NULL ==> 조인 실패
==> KING의 데이터는 조회되지 않음 (총 14건의 데이터중 13건의 데이터만 조인 성공)

OUTER 조인을 이용하여 조인 테이블중 기준이 되는 테이블을 선택하멵
조인에 실패하더라도 기준 테이블의 데이터는 조회 되도록 할 수 있다
LEFT/RIGHT OUTER 

ANSI-SQL 
테이블1 JOIN 테이블2 ON (...)
테이블1 LEFT JOIN 테이블2 ON (...)
-- 위 쿼리는 아래와 동일
테이블2 RIGHT JOIN 테이블1 ON (...)

SELECT e.empno, e.ename, e.mgr , m.ename
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno ;
