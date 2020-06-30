날짜관련 오라클 내장함수
내장함수 : 탑재가 되어있다
         오라클에서 제공해주는 함수 (많이 사용하니까, 개발자가 별도록 개발하지 않도록)
         
(활용도:*) MONTHS_BETWEEN(date1,date2) : 두 날짜 사아의 개월수를 반환
            ==>  일자가 다르면 소수점으로 반환됨 1.21121개월
(활용도:*****)ADD_MONTHS(date1,NUMBER) : DATE1날짜에 NUMBER 만큼의 개월 수를 더하고
                                        뺀 날짜를 반환
 (활용도:***)NEXT_DAY(date1,주간요일(1~7)) : date1 이후에 등장하는 첫번째 주간요일의 날짜 반환
            ==> 20200630, 6 ==>6/30일이후에 등장하는 첫번쨰 금요일은 몇일인가?
                 ==> 07/03 (1일 2월3화4수5목6금7토)
(활용도:***)LAST_DAY(date1) : date1날짜가 속한 월의 마지막 날짜 반환   
            ==> 20200605 ==> 20200630
             모든 달의 첫번쨰 날짜는 1일로 정해져 있음
             하지만 달의 마지막 날짜는 다른 경우가 있음
             윤년의 경우 2월달이 29일임. ;
             
SELECT ename, 
       TO_CHAR(hiredate,'yyyy-mm-dd')hiredate,
       MONTHS_BETWEEN(SYSDATE,hiredate)
FROM emp;

ADD_MONTHS;
SYSDATE : 2020/06/30 ==> 2020/11/30, 2020/01/31
SELECT ADD_MONTHS(SYSDATE,5) aft5,
       ADD_MONTHS(SYSDATE,-5) bef5
FROM dual ;

NEXT_DAY : 해당날짜 이후에 등장하는 첫번쨰 주간 요일의 날짜
SYSDATE : 20200630 이후에 등장하는 첫번쨰 토요일(7)은 몇일인가
SELECT NEXT_DAY(SYSDATE,7)
FROM dual;

LAST_DAY : 해당 일자가 속한 월의 마지막 일자를 반환;
SYSDATE : 20200630 실습당일의 날짜가 월의 마지막이라 
          SYSDATE대신 임의의 날짜 문자열로 테스트
SELECT LAST_DAY(TO_DATE('2020/06/05','yyyy/mm/dd'))
FROM dual;
--그냥 '2020/06/05'자체는 문자열이기때문에 TO_DATE함수를 이용해서 날짜타입으로 변환

LAST_DAY는 있는데 FIRST_DAY는 없다 ==> 모든 월의 첫번쨰 날짜는 동일(1일)
FIRST_DAY를 직접 SQL로 구현

SYSDATE : 20200630 ==> 20200601
1. SYSDATE를 문자로 변경하는데 포맷은 yyyymm
2. 1번의 결과에다가 문자열 결합을 통해 '01'문자를 뒤에 붙여준다
   ==>yyyymmdd
3. 2번의 결과를 날짜 타입으로 변경

SELECT TO_DATE(CONCAT(TO_CHAR(SYSDATE,'YYYYMM'),'01'),'yyyymmdd')date1
FROM dual;

ADD_MONTHS(LAST_DAY('201912'),TO_DATE(CONCAT(TO_CHAR(SYSDATE,'YYYYMM'),'01'),'yyyymmdd'))
LAST_DAY('201912')

--실습 pt154;
SELECT '201912' param, 
        TO_CHAR(LAST_DAY(TO_DATE('201912'||'01','YYYYMMDD')),'DD')dt,
        '201911' param, 
        TO_CHAR(LAST_DAY(TO_DATE('201911'||'01','YYYYMMDD')),'DD')dt,
        '201602' param, 
        TO_CHAR(LAST_DAY(TO_DATE('201602'||'01','YYYYMMDD')),'DD')dt
FROM dual;

--변수를 지정해줘서 한번에 데이터를 고쳐서 유지보수하기가 쉬워진다
SELECT :param param, 
        TO_CHAR(LAST_DAY(TO_DATE( :param||'01','YYYYMMDD')),'DD')dt
FROM dual;

실행계획 : DBMS가 요청받은 SQL을 처리하기 위해 세운 절차
         SQL 자체에는 로직이 없다.(어떻게 처리해라? 가 없다. JAVA와 다른점)
         
 1. 실행계획 생성: 
    EXPLAIN PLAN FOR
    실행계획을 보고자하는 SQL;

 2. 실행계획 보는 단계;
    SELECT *
    FROM TABLE(dbms_xplan.display);
    
empno컬럼은 NUMBER타입이지만 형변환이 어떻게 일어났는지 확인하기 위하여
의도적으로 문자열 상수 비교를 진행;

EXPLAIN PLAN FOR
SELECT *    
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

--실행계획 아래--
실행계획 읽는 방법: (중요**)
1. 위에서 아래로
2. 단 자식 노드가 있으면 자식 노드부터 읽는다
    자식노드: 들여쓰기가 된 노드 (ex *1 =>1이 0의 자식)
    
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 --특수한정보들을 나타낸다 
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7369) --거른다는 의미 
                            --입력은 문자로했지만 숫자로변환(묵시적변환)
--두번째 계획보기
EXPLAIN PLAN FOR
SELECT *    
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);
 
 --------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')
   
   
--세번째 계획보기
EXPLAIN PLAN FOR
SELECT *    
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(dbms_xplan.display);

--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7369)
   
6,000,000 <==> 6000000
국제화 : i18n
   - 날짜 국가별로 형식이 다르다
       한국 : yyyy-mm-dd
       미국 : mm-dd-yyyy
   - 숫자
      한국 : 9,000,000.00
      독일 : 9.000.000,00
      
sal(NUMBER) 컬럼의 값을 문자열 포맷팅 적용      
SELECT ename,sal, TO_CHAR(sal,'L9,999.00')
FROM emp;

SELECT ename,sal, TO_NUMBER(TO_CHAR(sal,'L9,999.00'),'L9,999,00')
FROM emp;


NULL 과 관련된 함수 : NULL값을 다른값으로 치환하거나, 혹은 강제로 NULL을 만드는것
1. NVL(expr1, expr2)
    if(expr1 == null)
        expr2를 반환;
    else 
        expr1을 반환
--예시
SELECT empno, 
       sal , 
       comm, 
       NVL(comm,0) sal2,
       sal +comm sum,
       sal+NVL(comm,0)sum2
FROM emp;

2. NVL2(expr1, expr2, expr3)
-- java버전
if(expr1 != null)
    expr2반환;
else 
    expr3반환

SELECT empno, 
       sal , 
       comm, 
       NVL2(comm, comm, 0),
       sal +comm, sal+NVL2(comm,comm, 0),
       NVL2(comm,comm+sal,sal)
FROM emp;

3. NULLIF(expr1, expr2) : null 값을 생성하는 목적
if(expr1==expr2)
    null반환
else
    expr1을반환

SELECT ename, sal, comm, NULLIF(sal,3000)
FROM emp;


4. COALESCE(expr1, expr2, .....)
인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환
COALESCE(NULL,NULL,30,NULL) ==> 30
if(expr1 != null)
    expr1을 반환
else    
     COALESCE(expr2, .....)
     --첫번째 값을 제외하고 두번째값부터 다시

SELECT COALESCE(NULL,NULL,30,NULL,50)
FROM dual;

NULL처리 실습
emp 테이블에 14명의 사원이 존재, 한명을 추가(INSERT)

INSERT INTO emp(empno, ename, hiredate) VALUES (9999,'brown',NULL);
ROLLBACK;

SELECT *
FROM emp;

조회컬럼 : ename , mgr , mgr컬럼값이 null이면 111로 치환한 값 -NULL이 아니면 mgr컬럼값,
        hiredate, hiredate가 NULL 이면 SYSDATE로 표기 - NULL이 아니면 hiredate 컬럼값
        
SELECT ename, 
       mgr,
       NVL(mgr,111),
       hiredate,
       NVL(hiredate,SYSDATE)
FROM emp;

--실습4 pt171
SELECT  empno, 
        ename,
        mgr,
        NVL(mgr,9999)mgr_n,
        NVL2(mgr,mgr,9999)mgr_n1,
        COALESCE(mgr,9999)mgr_n2
FROM emp;
        

--실습5 pt172       
SELECT *
FROM users;

SELECT userid,
       usernm,
       reg_dt,
       NVL(reg_dt,SYSDATE)n_reg_dt
FROM users
WHERE userid NOT IN ('brown');     

SQL 진행 퍼센트율
SELECT ROUND((6/28)*100,2)||'%'
FROM dual;

SELECT 6/27
FROM dual;

SQL 조건문 
CASE
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값 
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값2
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값3
    ELSE 모든 WHEN 절을 만족시키지 못할때 반환할 기본값
END ==> 하나의 컬럼으로 취급 

emp 테이블에 저장된 job컬럼의 값을 기준으로 급여(sal)를 인상시키려고한다
sal컬럼과 함께 인상된 sal 컬럼의 값을 비교하고싶은 상황

급여인상기준 
job 이 SALESMAN :  sal *1.05
job 이 MANAGER :  sal *1.10
job 이 PRESIDENT :  sal *1.20
나머지 기타 직군은 sal 로 유지

con1;
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

--실습1
SELECT *
FROM emp;

SELECT *
FROM dept;

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
       DECODE(deptno, 10,'ACCOUNTING',
                      20,'RESEARCH',
                      30,'SALES',
                      40,'OPERATIONS',
                      'DDIT')
FROM emp;




    
