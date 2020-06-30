ROWNUM : SELECT 순서대로 행 번호를 부여해주는 가상 컬럼
특징 : WHERE 절에서 사용하는게 가능
    *** 사용할수 있는 형태가 정해져 있음
    WHERE ROWNUM = 1;
    WHERE ROWNUM <=(<) N;(ROWNUM이 N보다 작거나 같은 경우, 작은경우)
    WHERE ROWNUM BETWEEN 1 AND N;(ROWNUM이 1보다 크거나 같고 N보다 작거나 같은 경우)
        ==> ROWNUM은 1부터 순차적으로 읽는 환경에서만 사용이 가능
        
        ****안되는 경우
        WHERE ROWNUM = 2;
        WHERE ROWNUM >= 2;
        
ROWNUM 사용 용도 : 페이징 처리 
페이징 처리 : 네이버 카페에서 게시글 리스트를 한화면에 제한적인 갯수로 조회(100)
            카페에 전체 게시글 수는 굉장히 많음
            ==>한 화면에 못보여줌 (웹브라우저가 버벅임
                                사용자의 사용성이 굉장히 불편)
            ==>한 페이지당 건수를 정해놓고 해당 건수 만큼만 조회해서 화면에 보여준다
            
WHERE 절에서 사용 할 수 있는 형태        
SELECT ROWNUM ,empno, ename
FROM emp
WHERE ROWNUM = 1;


WHERE 절에서 사용 할 수 없는 형태        
SELECT ROWNUM ,empno, ename
FROM emp
WHERE ROWNUM >= 10;

ROWNUM과 ORDER BY 

** SELECT SQL 의 실행 순서 
FROM => WHERE => SELECT  => ORDER BY 

SELECT ROWNUM ,empno, ename
FROM emp
ORDER BY ename ;
--정렬된 상태에서 ROWNUM을 부여하고싶은데 부여후 오더바이해서 숫자가 뒤죽박죽임

ROWNUM의 결과를 정렬 이후에 반영을 하고 싶은 경우 => IN-LINE VIEW 
VIEW :SQL - DBMS에 저장되어있는 SQL 
IN-LINE : 직접 기술 했다, 어딘가에 저장을 한것이 아니라 그 자리에 직접기술

SELECT 절에 *만 단독으로 사용하지 않고 콤마를 통해
    다른 임의의 컬럼이나 expression을 표기한 경우 *앞에 어떤 테이블 (뷰)에서 
    온것인지 한정자 (테이블 이름, view 이름)를 붙여줘야 한다.

table , view 별칭 : table이나 view에도 SELECT절의 컬럼처럼 별칭을 부여 할 수 있다.
                    단 SELECT 절 처럼 AS 키워드는 사용하지 않는다
                    EX : FROM emp e
                         FROM(SELECT empno, ename 
                         FROM emp
                         ORDER BY ename) V_emp;

SELECT ROWNUM , a.* --한정자 테이블.*
FROM(SELECT empno, ename 
     FROM emp
     ORDER BY ename) a;

SELECT ROWNUM ,empno, ename
FROM(SELECT empno, ename 
     FROM emp
     ORDER BY ename);
     

요구사항 : 1 페이지당 10건의 사원 리스트가 보여야된다
페이지 번호, 페이지당 사이즈 
1 page : 1 ~ 10
2 page : 11 ~ 20
3 page : 21 ~ 30
.
.
.
n page :(n*10)-9 ~ n*10
        ((n-1)*10)+1 ~ n*10
        ((n-1)*PageSize)+1 ~ n*PageSize
        
--정렬을 하기 위해서 
페이징 처리 쿼리 1page :1~10;
SELECT ROWNUM , a.* 
FROM(SELECT empno, ename 
     FROM emp
     ORDER BY ename) a
WHERE ROWNUM BETWEEN 1 AND 10;

페이징 처리 쿼리 2page :11~20 --11부터 시작되서 사용할수없는 쿼리
--ROWNUM의 특성으로 1번부터 읽지 않는 형태이기 때문에 정삭적으로 동작하지 않는다;
SELECT ROWNUM , a.* 
FROM(SELECT empno, ename 
     FROM emp
     ORDER BY ename) a
WHERE ROWNUM BETWEEN 11 AND 20;

ROWNUM의 값을 별칭을 통해 새로운 컬럼으로 만들고 해당 SELECT SQL을 in-line view로
만들어 외부에서 ROWNUM에 부여한 별칭을 통해 페이징을 처리한다.

SELECT *
FROM (SELECT ROWNUM rn, a.* 
      FROM(SELECT empno, ename 
           FROM emp
           ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 20;

SQL 바인딩 변수 : java 변수
페이지 번호 : page
페이지 사이즈 : pageSize
SQL 바인딩 변수 표기 => :변수명 ==> :page , :pageSize


-- 바인딩 변수 적용 ((:page-1)*:PageSize)+1 ~ :page*:PageSize;
SELECT *
FROM (SELECT ROWNUM rn, a.* 
      FROM(SELECT empno, ename 
           FROM emp
           ORDER BY ename)a)
WHERE rn BETWEEN ((:page - 1) * :PageSize) + 1 AND :page * :PageSize;

--실습 로우1 p120
SELECT 
FROM 


FUNCTION : 입력을 받아들여 특정 로직을 수행 후 결과 값을 반환하는 객체
오라클에서의 함수 구분 : 입력되는 행의 수에 따라
    1. Single row function
        : 하나의 행이 입력되서 결과로 하나의 행이 나온다
    2.Multi row function
        : 여러개의 행이 입력되서 결과로 하나의 행이 나온다

dual 테이블 : 오라클의 sys계정에 존재하는 하나의 행,
            하나의 컬럼(dummy)을 갖는 테이블 
            누구나 사용 할 수 있도록 권한이 개방됨

-- dual 테이블용도
    1. 함수 실행 (테스트)
    2. 시퀀스 실행
    3. merge 구문
    4. 테이터 복제 ***
    
*LENGTH 함수 테스트;
SELECT LENGTH('TEST')
FROM dual;

SELECT LENGTH('TEST'),LENGTH('TEST'), emp.*
FROM emp ;

SELECT *
FROM dual;

 문자열 관련 함수 : 설명은 PT 참고
 억지로 외우지는 말ㅈㅏ;
 SELECT CONCAT('Hello',CONCAT(', ','World')) concat,
        SUBSTR('Hello, World',1,5) substr,
        LENGTH('Hello, World') length,
        INSTR ('Hello, World', 'o') instr,
        INSTR ('Hello, World', 'o', 9) instr2, 
        INSTR ('Hello, World', 'o', (INSTR ('Hello, World', 'o')+1 ) )instr2, 
        --첫번쨰o가 등장하는위치+1
        LPAD('Hello, World', 15 , '  ') lpad,
        RPAD('Hello, World', 15 , '  ') rpad,
        REPLACE ('Hello, World', 'o' , 'p')replace,
        TRIM ('  Hello, World  ') trim,
        TRIM ('d' FROM 'Hello, World') trim2,
        LOWER ('Hello, World') lower,
        UPPER ('Hello, World') upper,
        INITCAP('hello, world') initcap        
 FROM dual;
 
함수는 WHERE 절에서도 사용 가능 
사원이름이 smith인 사람

--1번만 적용해서 사용하면 됨 (빨라)
SELECT *
FROM emp
WHERE ename = UPPER('smith');

--ename 컬럼자체를 변경했기때문에 실행이 14건이됨 (쓰지마)
--좌변을 가공하는 형태 (좌변 - 테이블 컬럼을 의미)

SELECT *
FROM emp
WHERE LOWER(ename) ='smith';

오라클 숫자 관련 함수 
ROUND(숫자, 반올림 기준자리) : 반올림 함수
TRUNC(숫자, 내림 기준자리) : 내림 함수
MOD(피제수, 제수) : 나머지 값을 구하는 함수

SELECT ROUND(105.54,1) round,
       ROUND(105.55,1) round,
       ROUND(105.55,0) round,
       ROUND(105.55,-1) round,
       ROUND(105.55) round --소수점 없이 반올림
FROM dual;
       
SELECT TRUNC(105.54,1) trunc,
       TRUNC(105.55,1) trunc,
       TRUNC(105.55,0) trunc,
       TRUNC(105.55,-1) trunc,
       TRUNC(105.55) trunc --소수점 없이 내림
FROM dual;  

SELECT MOD(105.54,1) mod,
FROM dual;
sal을 1000으로 나눴을때의 나머자 ==> mod 함수, 별도의 연산자는 없다
몫 : quotient
나머지 : remider

SELECT ename,
       sal,
       TRUNC(sal/1000) quotient,
       mod(sal,1000)reminder
FROM emp ;

** 날짜관련 함수
SYSDATE : 
    오라클에서 제공해주는 특수함수      
    1. 인자가 없다
    2. 오라클이 설치된 서버의 현재 년, 월, 일, 시, 분 , 초 정보를 반환해주는 함수

SELECT *
FROM nls_session_parameters;

SELECT SYSDATE
FROM dual;

날짜 타입 +- 정수 : 정수를 일자취급, 정수만큼 미래, 혹은 과거날짜의 데이트 값을 반환

ex: 오늘 날짜에서 하루 더한 미래 날짜 값은?
SELECT SYSDATE +1
FROM dual; 

ex: 현재 날짜에서 3시간뒤 데이트를 구하려면?
    데이트 + 정수 (하루)
    하루 == 24시간
    1시간 ==>1/24
    3시간 ==>(1/24)*3 =3/24
    
SELECT SYSDATE + (1/24)*3
FROM dual; 

    1분 ==> ((1/24)/60)
    30분 ==> ((1/24)/60)*30
    
SELECT SYSDATE + ((1/24)/60)*30
FROM dual; 

데이트를 표현 하는 방법
1. 데이트 리터럴 nls_session_parameters 설정에 따르기 
    때문에 DBMS 환경 마다 다르게 인식 될 수있음.
    (서버에 따라설정이 달라서 내자리에서는 되는데 다른자리에서는 안될수도있다 인식이안되서)
2. TO_DATE : 문자열을 날짜로 변경해주는 함수 (올바른 방법)


--실습 date1
SELECT TO_DATE('20191231','yyyymmdd') LASTDAY,
       TO_DATE('20191231','yyyymmdd')-5 LASTDAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE-5 NOW_BEFORE5
FROM dual;

문자열 ==> 데이트
    TO_DATE(날짜 문자열, 날짜문자열의 패턴);
    
데이트 ==> 문자열 
          (보여주고 싶은 형식을 지정할 때)
    TO_CHAR(데이트 값, 표현하고싶은 문자열 패턴);
    
SYSDATE 현재 날짜를 년도4자리-월2자리-일2자리

--pt 114
SELECT SYSDATE , 
       TO_CHAR(SYSDATE, 'yyyy-mm-dd'),
       TO_CHAR(SYSDATE, 'D'),
       TO_CHAR(SYSDATE, 'IW')
FROM dual; 

날짜 포맷 :pt 참고
YYYY
MM
DD
HH24
MI
SS
D,IW

SELECT SYSDATE , 
       TO_CHAR(SYSDATE, 'yyyy-mm-dd'),
       TO_CHAR(SYSDATE, 'D'),
       TO_CHAR(SYSDATE, 'IW')
FROM dual; 
    
SELECT ename,
       hiredate,
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS')h1,
       TO_CHAR(hiredate+1, 'YYYY/MM/DD HH24:MI:SS')h2,
       TO_CHAR(hiredate+5, 'YYYY/MM/DD HH24:MI:SS')h3
FROM emp;


--실습 2 p145
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS')dt_dash_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY')dt_dd_mm_yyyy
FROM dual;
       
       