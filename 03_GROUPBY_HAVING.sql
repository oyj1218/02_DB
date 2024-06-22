/* SELECT문 해석 순서
    5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
    1 : FROM 참조할 테이블명
    2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
    3 : GROUP BY 그룹을 묶을 컬럼명
    4 : HAVING 그룹함수식 비교연산자 비교값
    6 : ORDER BY 컬럼명 | 별칭 | 컬럼순서 정렬방식 [NULLS FIRST | LAST];
*/

--------------------------------------------------------------------------------
-- *GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을
--               하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러개일 경우 오류 발생
-- 여러 개의 결과 값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용


-- EMPLOYEE 테이블에서 부서코드, 부서(그룹) 별 급여 합계 조회
SELECT DEPT_CODE 부서코드, SUM(SALARY)
FROM EMPLOYEE;
-- DEPT_CODE 컬럼은 23행, SUM(SALARY) 컬럼은 1행으로
-- 하나의 표에 작성할 수 없음.

-- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 부서별로 그룹을 지어 각 그룹의 합계 조회

-- EMPLOYEE 테이블에서
-- 부서코드, 부서 별 급여의 합계, 부서 별 급여의 평균(정수처리), 인원 수를 조회하고
-- 부서코드 순으로 정렬
SELECT DEPT_CODE 부서코드, SUM(SALARY) "급여 합", FLOOR(AVG(SALARY)) "급여 평균", COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서
-- 성별, 성별 별 급여 평균(정수처리), 급여 합계, 인원 수 조회하고
-- 인원수로 내림차순 정렬
SELECT DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여') 성별, 
        FLOOR(AVG(SUBSTR(EMP_NO,8,1))) "급여 평균", 
        SUM(SALARY) "급여 합계", 
        COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여') -- 별칭 사용 불가(해석X)
ORDER BY "인원 수" DESC;

-- * WHERE절 GROUP BY절 혼합하여 사용
--> WHERE절은 각 컬럼 값에 대한 조건(SELECT문 해석 순서 잘 기억!!)


-- EMPLOYEE 테이블에서 부서코드가 'D5', 'D6'인 부서의 평균 급여 조회
SELECT DEPT_CODE 부서, FLOOR(AVG(SALARY)) "부서의 평균 급여"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급 별 2000년도 이후 입사자들의 급여 합을 조회
SELECT JOB_CODE "직급 코드", FLOOR(SUM(SALARY)) "2000년도 이후 입사자 급여 합"
FROM EMPLOYEE
--WHERE SUBSTR(HIRE_DATE,1,4) >= 2000
WHERE HIRE_DATE >= '2000/01/01'
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹내 그룹이 가능하다
-- *** GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
-- SELECT절에 명시한 조회하려는 컬럼 중
-- 그룹함수가 적용되지 않은 컬럼은
-- 모두 GROUP BY절에 작성해야함

-- EMPLOYEE 테이블에서 부서 별로 같은 직급인 사원의 급여 합계를 조회하고
-- 부서 코드 오름차순으로 정렬
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 부서 별로 급여 등급이 같은 직원의 수를 조회하고
-- 부서코드, 급여 등급 오름차순으로 정렬
SELECT DEPT_CODE, SAL_LEVEL, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, SAL_LEVEL
ORDER BY DEPT_CODE, SAL_LEVEL;

----------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교 연산자 비교값

-- 부서별 평균 급여가 3000000원 이상인 부서를 조회하여 부서코드 오름차순으로 정렬
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
WHERE SALARY >= 3000000 -- 급여가 300만 이상인 직원의 부서별
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
HAVING AVG(SALARY) >= 3000000 -- 급여가 300만 이상인 직원의 부서별
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 부서별 그룹의 급여 합계 중 9백만원을 초과하는 부서코드와 급여 합계 조회
-- 부서 코드 순으로 정렬
SELECT DEPT_CODE "부서코드", FLOOR(SUM(SALARY)) "급여 합계"
FROM EMPLOYEE
HAVING SUM(SALARY)>9000000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;



SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
HAVING SUM(SALARY) >= 9000000
GROUP BY DEPT_CODE;


------ 연습 문제 ------

-- 1. EMPLOYEE 테이블에서 각 부서별 가장 높은 급여, 가장 낮은 급여를 조회하여
-- 부서 코드 오름차순으로 정렬하세요.
SELECT DEPT_CODE, MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 2.EMPLOYEE 테이블에서 각 직급별 보너스를 받는 사원의 수를 조회하여
-- 직급코드 오름차순으로 정렬하세요
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 3.EMPLOYEE 테이블에서 
-- 부서별 70년대생의 급여 평균이 300만 이상인 부서를 조회하여
-- 부서 코드 오름차순으로 정렬하세요
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "급여 평균"
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO, 1, 1) = 7
--WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79
WHERE SUBSTR(EMP_NO, 1, 2) LIKE '7%'
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE;

----------------------------------------------------

-- 집계함수(ROLLUP, CUBE)
-- 그룹 별 산출한 결과 값의 집계를 계산하는 함수
-- GROUP BY 절에만 작성하는 함수

-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
-- 그룹별로 묶어진 값에 대한 '중간 집계'와 '총 집계'를 계산하여 자동으로 추가하는 함수
-- * 인자로 전달받은 그룹 중에서 가장 먼저 지정한 그룹별 합계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서
-- 각 부서에 소속된 직급 별 급여합,
-- 부서 별 급여 합,
-- 전체 직원 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

---------------------------------------------------------

-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수
-- * 그룹으로 지정된 모든 그룹에 대한 집계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서 각 부서마다 직급별 급여 합,
-- 부서 전체 급여 합
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- ROLLUP 결과에 아래 두 SQL문의 결과가 추가됨
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;

--------------------------------------------------

-- * SET OPERATION (집합 연산)
-- 여러 개의 SELECT 결과물을 하나의 쿼리로 만드는 연산자
-- 여러가지의 조건이 있을 때 그에 해당하는 여러개의 결과값을 결합시키고 싶을때 사용
-- 초보자들이 사용하기 쉽다.
-- (주의) 집합 연산에 사용되는 SELECT문은 SELECT절이 동일해야함

-- UNION은 OR 같은 개념 (합집합) --> 중복 제거
-- INTERSECT는 AND 같은 개념 (교집합)
-- UNION ALL은 OR 결과 값에 AND 결과값이 더해진거(합집합 + 교집합) --> 중복 미제거
-- MINUS는 차집합 개념 

-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- 중복된 영역을 제외하여 하나로 합친다.

-- 부서코드가 'D5'인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION

-- 급여가 300만 초과인 사원의 사번, 이름 , 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION은 OR 연산의 결과와 같다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- MINUS : 선행 SELECT 결과에 다음 SELECT 결과와 겹치는 부분을을 제외한 나머지(교차집합)
-- MINUS는 AND 연산 + 비교연산 반대로 작성하면 됨
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY <= 3000000

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND SALARY <= 3000000;

-- 여러 SELECT 연산 합산 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';


SELECT EMP_NO, TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'), 'RR"년" MM"월" DD"일"')
FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

