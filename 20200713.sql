제약조건 생성하는 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어 불가
    
2. 테이블 생성시, 모든 컬럼을 기술하고 나서 
    제약조건만 별도로 기술
    1번 방법보다 세세하게 제어하는게 가능

3. 테이블 생성이후,
    객체 수정 명령을 통해 제약조건을 추가 
    -- 복사해서 계속 쓸것
CREATE TABLE dept_test (
      DEPTNO NUMBER(2),   
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13) 
);
Drop table dept_test;
--------------------------
제약조건 생성방법 2번 : 테이블 생성시 컬럼 기술이후 별도로 제약조건을 기술하는 방법
dept_test 테이블의 deptno 컬럼을 대상으로 PRIMARY KEY 제약 조건 생성

CREATE TABLE dept_test (
      DEPTNO NUMBER(2),   
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13) ,
      CONSTRAINT pk_dept_test PRIMARY KEY (DEPTNO)
);

SELECT *
FROM dept_test;
dept_test 테이블에 deptno 가 동일한 값을 갖는 INSERT 쿼리 2개를 생성하여
2개의 커리가 정상적으로 동작하는지 테스트

INSERT INTO dept_test VALUES (10,  'ddit', 'deajron');
INSERT INTO dept_test VALUES (10,  'aa', 'aaaa');
ROLLBACK;


NOT NULL 제약조건 : 컬럼레벨에 기술 테이블 기술 없음, 테이블 수정시 변경 가능

INSERT INTO dept_test VALUES (20,  null, 'aaaa');
--널제약조건이 없을때 데이터값이 널이여도 삽입이 된다 

CREATE TABLE dept_test (
      DEPTNO NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,   
      DNAME VARCHAR2(14) NOT NULL,
      LOC VARCHAR2(13) 
);

INSERT INTO dept_test VALUES (20,  null, 'aaaa');
--널제약조건이 생성됐기때문에 행이 삽입이 되지않는다 

수업시간에 UNIQUE 제약조건 명명 규칙 : UK_테이블명_해당컬럼명
UNIQUE 제약조건 : 해당 컬럼의 값이 다른 행에 나오지 않도록(중복되지않도록)
                데이터 무결성을 지켜주는 조건
                (ex: 사번, 학번)
              
CREATE TABLE dept_test (
      DEPTNO NUMBER(2),   
      DNAME VARCHAR2(14) CONSTRAINT uk_dept_test UNIQUE  ,
      LOC VARCHAR2(13) 
);  
                
              
CREATE TABLE dept_test (
      DEPTNO NUMBER(2),   
      DNAME VARCHAR2(14) ,
      LOC VARCHAR2(13) ,
--dname loc를 결합해서 중복되는 데이터가 없으면됨
--다음 두개는 중복
--ddit,deajeon
--ddit,deajeon
--아래 는 부서명은 동일하지만 loc정보가 다르기때문에 dname loc 조합은 서로 다른 데이터
--ddit,deajeon
--ddit,대전
      CONSTRAINT uk_dept_test_dname UNIQUE(dname,loc)  
);  
             
             
SELECT *
FROM dept_test;

dname loc 컬럼 조합으로 중복된 데이터가 들어가는지 안들어가는지 테스트
조합이 동일한경우 --에러 (UNIQUE 제약조건에 의해서 )
INSERT INTO dept_test VALUES (20,  'ddit', 'deajeon');
INSERT INTO dept_test VALUES (20,  'ddit', 'deajeon');
ROLLBACK;

dname loc 컬럼 조합의 값이 하나의 컬럼만 동일한 데이터인경우 안들어가는지 테스트
INSERT INTO dept_test VALUES (20,  'ddit', 'deajeon');
INSERT INTO dept_test VALUES (20,  'ddit', '대전');


FOREIGN KEY : 참조키
한 테이블의 컬럼의 값의 참조하는 테이블의 컬럼 값 중에 존재하는 값만 입력되도록 제어하는 제약조건
즉, FOREIGN KEY 경우 두개의 테이블간의 제약조건

* 참조되는 테이블의 컬럼에는 (dept_test.deptno)인덱스가 생성되어 있어야한다
자세한 내용은 INDEX편에서 다시

CREATE TABLE dept_test (
      DEPTNO NUMBER(2),   
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13) ,
      CONSTRAINT pk_dept_test PRIMARY KEY(deptno)
);
테스트 데이터 준비
INSERT INTO dept_test VALUES (20,  'ddit', 'deajeon');
INSERT INTO dept_test VALUES (10,  'ddit', 'deajeon');
INSERT INTO dept_test VALUES (2,  'ddit', 'deajeon');
INSERT INTO dept_test VALUES (1,  'ddit', 'deajeon');

dept_test테이블의 dwptno컬럼을 참조하는 emp_test테이블을 생성 

DESC emp;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10)
      DEPTNO NUMBER(2) REFERENCES dept_test (deptno)
);

1.dept_test 테이블에는 부서번호가 1번인 부서가 존재
2. emp_test테이블의 deptno컬럼으로 dept_test.deptno컬럼을 참조
    ==> emp_test 테이블의 dept_test.deptno 컬럼에 존재하는 값만 입력하는것이 가능
    dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우
    INSERT INTO emp_test VALIES (9999,'brown',1)

dept_test 테이블에 존재하지않느ㅡㄴ 부서번호로  부서번호로 emp_test 테이블에 입력하는 경우

    INSERT INTO emp_test VALIES (9998,'sally',2)
    
    FK 제약조건을 테이블 컬럼 기술이후에 별도로 기술하는 경우
    CONSTRAINT 제약조건명 제약조건 타입 (대상컬럼) REFERENCES 참조테이블(참조테이블의 컬럼명)
    명명규칙 : FK_타켓테이블명 _ 참조테이블명(IDX)
    
    Drop table emp_test ;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2) REFERENCES dept_test (deptno),
      CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno)
                                    REFERENCES dept_test (deptno)
);

dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우
INSERT INTO emp_test VALIES (9999,'brown',1)

dept_test 테이블에 존재하지않느ㅡㄴ 부서번호로  부서번호로 emp_test 테이블에 입력하는 경우 ==>에러

INSERT INTO emp_test VALIES (9998,'sally',2)


참조되고있는 부모쪽 데이터를 삭제하는 경우
dept_test테이블에 1번 부서가 존재하고
emp_test 테이블의 brown사원이 1번 부서에 속한 상태에서 1번 부서를 삭제하는 경우
FK의 기본설정에서는 참조하는 데이터가 없어질수없기 떄문에 에러발생
 
SELECT *
FROM emp_test;

DELETE dept_test
WHERE deptno =1;


FK 생성시 옵셥 
0. DEFAULT 무결성이 위배되는 경우 에러
1. ON DELETE CASCADE : 부모데이터를 삭제할경우 참조하고있는 자식 데이터를 같이 삭제한다
    (dept_test 테이블에 1번부서를 삭제하면 1번부서에 소속된 brown 사원도 삭제)
2. ON DELETE SET NULL : 부모데이터를 삭제 할 경우 참조하는 자식 데이터의 컬럼을 NULL로 수정;


CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2) REFERENCES dept_test (deptno),
      CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno)
                                    REFERENCES dept_test (deptno) ON DELETE CASCADE
);

Drop table emp_test;

SELECT * 
FROM emp_test;

INSERT INTO emp_test VALUES (9999,'brown',1);
INSERT INTO emp_test VALUES (9998,'sally',2);

부모데이터 삭제
DELETE dept_test
WHERE deptno=2;

SELECT *
FROM emp_test;


-------------------
--
SET NULLL 옵션 확인
Drop table emp_test;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2) REFERENCES dept_test (deptno),
      CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno)
                                    REFERENCES dept_test (deptno) ON DELETE SET NULL
);


SELECT * 
FROM emp_test;

INSERT INTO emp_test VALUES (9999,'brown',1);
INSERT INTO emp_test VALUES (9998,'sally',2);

부모데이터 삭제
DELETE dept_test
WHERE deptno=2;

SELECT *
FROM emp_test;

CHECK 제약조건 : 컬럼에 입력되는 값을 검증하는 제약조건
(ex. salary 컬럼(급여)이 음수가 입력되는 것은 부자연스러움
    성별컬럼에 나므 여가 아닌 값이 들어오는것은 데이터가 잘못된것
    직원구분 컬럼에는 정직원, 임시직 2개만 존재한다고 할때 다른값이 들어오면 논리적으로 어긋남)
    
Drop table emp_test ;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
    --  sal NUMBER(7,2)CHECK (sal>0)
    sal NUMBER(7,2) CONSTRAINT sal_no_zero CHECK (sal>0)
  --  sal NUMBER(7,2) CONSTRAINT sal_no_zero CHECK (sal IS NOT NULL)
);

INSERT INTO emp_test VALUES (1,'ss',1500);
SELECT *
FROM emp_test;

sal 값이 음수인 데이터 입력
INSERT INTO emp_test VALUES (9999,'brown',-500);


테이블 생성 + [제약조건 포함]
: CTAS 
CREATE TABLE 테이블명 AS 
SELECT ....

백업
CREATE TABLE 멤버20200713 AS 
SELECT *
FROM 멤버;

CTAS 명령을 이용하여 emp 테이블의 모든 데이터를 바탕으로 emp_test 테이블 생성
CREATE TABLE emp_test AS 
SELECT *
FROM emp;

SELECT *
FROM emp_test;

CTAS 명령을 이용하여 emp 테이블의 구조만 복사하고싶을때 WHERE 절에 항상 FALSE 가되는
조건을 기술하여 생성가능
CREATE TABLE emp_test AS 
SELECT *
FROM emp
WHERE 1!=1 ; --조건을 만족하지 않기때문에 틀만

생성된 테이블을 변경
컬럼에 작업
1. 존재하지 않았던 새로운 컬럼추가 가능
    =>단 테이블의 컬럼 기술순서를 제어하는건 불가
    => 신규로 추가하는컬럼의 경우 컬럼순서가 항상 테이블의 마지막
    => 설계를 할 때 컬럼순서에 충분히 고려, 누락된 컬럼이 없는지도 고려
    
2. 존재하는 컬럼 삭제
    +> 제약조건 (fk)주의 

3. 존재하는 컬럼 변경
    컬럼명 변경 => fk와 관계없이 알라서 적용해줌
    그 외적인 부분에서는 사실상 불가능 하다고 생각하면 편함 
    (데이터가 이미 들어가있는 테이블의 경우)
    1. 컬럼 사이즈 변경
    2. 컬럼 타입변경
    ==> 설계시 충분한 고려
    
제약조건 작업
1.제약조건 추가
2. 제약조건 삭제
3. 제약조건 비활성/ 활성화

새롭게 만들고
CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2) 
);
테이블 수정
ALTER TABLE 테이블명 .....

1.신규컬럼 추가
ALTER TABLE emp_test ADD ( hp VARCHAR2(11) );

SELECT *
FROM emp_test;

DESC emp_test;

2.컬럼수정 (MODIFY)
** 데이터가 존재하지않을때는 비교적 자유롭게 수정가능
ALTER TABLE emp_test MODIFY (hp VARCHAR2 (5) );
ALTER TABLE emp_test MODIFY (hp NUMBER );
desc emp_test;

    컬럼의 기본값 설정
ALTER TABLE emp_test MODIFY (hp DEfAULT 123);
INSERT INTO emp_test(empno, ename, deptno)  VALUES (9999,'zz', NULL);

컬럼명칭변경(RENAME COLUMN 현재컬럼명 TO 변경할 컬럼명)
ALTER TABLE emp_test RENAME COLUMN hp TO cell;

SELECT *
FROM emp_test;

컬럼삭제 (DROP COLUMN, DROP)

ALTER TABLE emp_test DROP (cell);
ALTER TABLE emp_test DROP COLUMN cell;

3. 제약조건 추가 삭제(ADD , DROP)
            +
    테이블 레벨의 제약조건 생성 
    
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입 대상컬럼;

별도의 제약조건 없이 emp_test 테이블 생성
 Drop table emp_test ;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2)
      );
      
테이블 수정을 통해서 emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

제약조건 삭제 (DROP)
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;


제약조건 활성화 비활성화
제약조건 DROP 은 제약조건 자체를 삭제하는 행위
제약조건 비활성화는 제약조건 자체는 남겨두지만 사용하지않는 형태
때가되면 다시 활성화 하여 데이터 무결성에 대한 부분을 강제할 수 있음


Drop table emp_test ;

CREATE TABLE emp_test (
      EMPNO NUMBER(4),   
      ENAME VARCHAR(10),
      DEPTNO NUMBER(2)
);
테이블 수정 명령을 통해 emo_test 테이블의 emp_no 컬럼으로 PRIMARY KEY 제약 생성
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

제약조건을 활성화/ 비활성화 (ENABLE /DISABLE)
ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;

pk_emp_test 비활성화 되어있기 때문에 empno컬럼에 중복되는 값 입 력간으
INSERT INTO emp_test VALUES (9999,'bb',NULL);
INSERT INTO emp_test VALUES (9999,'bddb',NULL);
pk_emp_test 제약조건을 활성화

ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;

DICTIONARY
SELECT *
FROM user_tables;

SELECT *
FROM user_constraints;

SELECT *
FROM user_constraints
WHERE constraint_type = 'P';

SELECT *
FROM user_constraints
WHERE table_name = 'EMP_TEST';

SELECT * 
FROM user_cons_columns
WHERE TABLE_NAME = 'CYCLE'
  AND constraint_name = 'PK_CYCLE';

SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments; --코맨트 달때 47

테이블 , 컬럼 주석 달기
COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

emp_test 테이블, 컬럼에 주석 ;
COMMENT ON TABLE emp_test IS '사원_복제';
COMMENT ON COLUMN emp_test.empno IS '사번';
COMMENT ON COLUMN emp_test.ename IS '사원이름';
COMMENT ON COLUMN emp_test.deptno IS '소속부서번호';

SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;
WHERE table_name = 'EMP_TEST';

'CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY'

--실습1 47
SELECT t.*  ,c.table_name, c.comments
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name
AND c.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

SELECT *
FROM emp;

SELECT *
FROM dept;

ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY(deptno)
                                    REFERENCES dept (deptno);


