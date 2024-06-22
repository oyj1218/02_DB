/* 
[JOIN 용어 정리]
오라클                 SQL : 1999표준(ANSI)
------------------------------------------------------------------------------
등가 조인              내부 조인(INNER JOIN), JOIN USING / ON
                    + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
------------------------------------------------------------------------------
포괄 조인              왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                    + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
-----------------------------------------------------------------------------
자체 조인, 비등가 조인            JOIN ON
-----------------------------------------------------------------------------
카테시안(카티션) 곱               교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI)
    미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용
-- 수행 결과는 하나의 RESULT SET으로 나옴

/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨. 
*/

--------------------------------------------------------------------------------
-- 기존에 서로 다른 테이블의 데이터를 조회할 경우 따로 조회함.

-- 직원번호, 직원명, 부서코드 (EMPLOYEE)
-- 부서명 (DEPARTMENT)을 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 연결할 때
-- DEPT_CODE 컬럼과 DEPT_ID 컬럼이 같은 값을 가지고 있으므로
-- 해당 컬럼들을 기준으로 연결

-- 1. 내부 조인(INNER JOIN) (== 등가 조인(EQUAL JOIN))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.(== 일치하는 값이 없는 행은 조인에서 제외됨)

-- 1) 연결에 사용할 두 컬럼명이 다른 경우

-- EMPLOYEE 테이블, DEPARTMENT 테이블을 참조하여
-- 사번, 이름, 부서코드, 부서명 조회

-- EMPLOYEE 테이블에 DEPT_CODE 컬럼과 DEPARTMENT 테이블에 DEPT_ID 컬럼은
-- 서로 같은 부서 코드를 나타낸다.
--> 이를 통해 두 테이블의 관계가 있음을 알고 조인을 통해서 데이터 추출 가능.

-- ANSI
-- 연결에 사용할 컬럼명이 다른 경우 ON()을 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM DEPARTMENT
JOIN EMPLOYEE ON(DEPT_CODE = DEPT_ID);

-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM DEPARTMENT, EMPLOYEE   -- FROM절에 사용할 테이블을 모두 작성
WHERE DEPT_CODE = DEPT_ID;  -- WHERE절에 같은 값을 가지고 있는 컬럼을 작성

-- DEPARTMENT 테이블, LOCATION 테이블을 참조하여
-- 부서명, 지역명 조회

-- ANSI 방식
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 오라클 방식
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 연결에 사용할 두 컬럼명이 같은 경우
-- EMPLOYEE 테이블, JOB 테이블을 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

-- ANSI
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용함
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- ORACLE -> 별칭 사용
-- 테이블 별로 별칭을 등록할 수 있음
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- *** 내부 조인의 문제점 ***
-- 연결에 사용되는 컬럼의 값이 NULL이면 조회 결과에 포함되지 않는다

-- EX) EMPLOYEE, DEPARTMENT 조인 시 하동운, 이오리 포함 X

-------------------------------------------------------------

-- 2. 외부 조인(OUTER JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
--> *반드시 OUTER JOIN임을 명시해야 한다

-- OUTER JOIN과 비교할 INNER JOIN 쿼리문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
INNER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의
-- 컬럼수를 기준으로 JOIN

-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
--> JOIN 구문 기준으로 왼쪽에 작성된 테이블의 모든 행이 결과(RESULT SET)에 포함됨

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- 왼쪽 테이블 컬럼과 오른쪽 테이블 컬럼에 같은 값이 없으면
-- 오른쪽을 억지로 추가(NULL)

-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중
-- 오른편에 기술된 테이블의 컬럼수를 기준으로 JOIN

-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
--> JOIN 구문 기준으로 오른쪽에 작성된 테이블의 모든 행이 결과(RESULT SET)에 포함됨

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;
-- 왼쪽 테이블 컬럼과 오른쪽 테이블 컬럼에 같은 값이 없으면
-- 왼쪽을 억지로 추가(NULL)

-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ** 오라클 구문은 FULL OUTER JOIN 사용 X
-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- EMPLOYEE 테이블의 하동운, 이오리
-- DEPARTMENT 테이블의 마케팅부, 국내영업부, 해외영업3부 모두 결과에 포함

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);
-- 오라클은 FULL OUTER JOIN 불가

-------------------------------------------------------------------------

-- 3. 교차 조인 (CROSS JOIN == CARTESIAN PRODUCT)
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합)

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

--------------------------------------------------------------------------

-- 4. 비등가 조인(NON EQUAL JOIN)

-- '='(등호)를 사용하지 않는 조인문
-- 지정한 컬럼 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

SELECT EMP_NAME, SALARY, E.SAL_LEVEL, S.SAL_LEVEL 
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블을 조인
-- 자기 자신과 조인을 맺음
--> 똑같은 테이블 두개가 조인

-- 사번, 이름, 사수 번호, 사수 이름 조회
SELECT * FROM EMPLOYEE;

-- ANSI
SELECT E.EMP_ID, E.EMP_NAME, NVL(E.MANAGER_ID, '없음') "사수 번호", NVL(M.EMP_NAME, '없음') "사수 이름"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (M.EMP_ID = E.MANAGER_ID);

-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, NVL(E.MANAGER_ID, '없음') "사수 번호", NVL(M.EMP_NAME, '없음') "사수 이름"
FROM EMPLOYEE E, EMPLOYEE M 
WHERE M.EMP_ID (+)= E.MANAGER_ID;

--------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
--JOIN JOB USING(JOB_CODE);
-- 반드시  원래 정상적인 조인 코드
NATURAL JOIN JOB;

-------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조회할 때 사용(순서 중요)
-- ** JOIN 순서대로 하나씩 진행된다 **

-- EMPLOYEE, DEPARTMENT, LOCATION

-- ANSI
SELECT EMP_NAME, DEPLT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN LOCATION ON (LOCATTION = LOCAL,NAME);

---오라클
SELECT EMP_NAME, DEPLT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOACCAINS
JOIN LOCATION ON (LOCATTION = LOCAL,NAME);

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하시오.

-- ANSI 
SELECT EMP_NO, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
WHERE JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';

-- 오라클
SELECT EMP_NO, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
AND E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND J.JOB_NAME = '대리'
AND L.LOCAL_NAME LIKE 'ASIA_';

------------------------------------------------------------------------

-- [연습문제]

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 
-- 사원명, 주민번호, 부서명, 직급명을 조회하시오.

-- ANSI
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EMP_NO LIKE '7%' AND 
      SUBSTR(EMP_NO, 8, 1) = 2 AND 
      EMP_NAME LIKE '전%';

-- 오라클
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE AND
EMP_NO LIKE '7%' AND SUBSTR(EMP_NO, 8, 1) = 2 AND EMP_NAME LIKE '전%';

-- 2. 이름에 '형'자가 들어가는 직원의 사번, 사원명, 부서명을 조회

-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE '%형%';

-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND EMP_NAME LIKE '%형%';

-- 3. 해외영업 1부, 2부에 근무하는 사원의
-- 사원명, 직급명, 부서코드, 부서명 조회

-- ANSI
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
JOIN EMPLOYEE ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');

-- 오라클
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM DEPARTMENT D, EMPLOYEE E, JOB J
WHERE DEPT_ID = DEPT_CODE AND E.JOB_CODE = J.JOB_CODE
AND DEPT_TITLE IN ('해외영업1부', '해외영업2부');

-- 4. 보너스포인트를 받는 직원의 사원명, 보너스포인트, 부서명, 근무지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN JOB USING (JOB_CODE);

-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의
-- 사원명, 직급명, 급여, 연봉(보너스포함)을 조회하시오
SELECT EMP_NAME, JOB_NAME, SALARY, ((NVL(BONUS, 0)+1) * SALARY) * 12 "연봉(보너스포함)"
FROM EMPLOYEE
JOIN SAL_GRADE USING(SAL_LEVEL)
JOIN JOB USING (JOB_CODE)
WHERE SALARY > MIN_SAL;

-- 7. 한국과 일본에 근무하는 직원들의
-- 사원명, 부서명, 지역명, 국가명을 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');

-- 8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오
-- SELF JOIN 사용
SELECT E1.EMP_NAME, E1.DEPT_CODE, E2.EMP_NAME
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.DEPT_CODE = E2.DEPT_CODE AND E1.EMP_NAME != E2.EMP_NAME;

-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의
-- 사원명, 직급명, 급여를 조회
-- 단, JOIN, IN 사용할 것
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE JOB_CODE IN ('J4','J7') AND BONUS IS NULL;



