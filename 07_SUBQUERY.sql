/*
    * SUBQUERY(서브쿼리)
    - 하나의 SQL문 안에 포함된 또 다른 SQL(SELECT)문
    - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
    -- SELECT, FROM, WHERE, HAVING 절에서 사용 가능
*/

-- 서브쿼리 예시1,
-- 부서코드가 노옹철 사원과 같은 소속의 직원 이름, 부서코드 조회하기

-- 1) 사원명이 노옹철인 사람의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

-- 2) 부서코드가 D9인 직원을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
--> 위의 2단계를 하나의 쿼리로! --> 1) 쿼리문을 서브쿼리로 사용!

-- 메인쿼리
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');
                    -- 서브쿼리        
-- 서브쿼리 예시 2
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 직원들 중 급여가 3047663 평균 급여 이상인 사원의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, EMP_NO, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 3) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원 조회
SELECT EMP_ID, EMP_NAME, EMP_NO, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                FROM EMPLOYEE);  

/*  서브쿼리 유형

    - 단일행 (+ 단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 
    
    - 다중행 (+ 단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
    
    - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개 일 때
    
    - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때 
    
    - 상관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때 
                     메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
                     
    - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
    
   * 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름
*/

-- 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
--     서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--     단일행 서브쿼리 앞에는 비교 연산자 사용
--     <, >, <=, >=, =, !=/^=/<>

-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 이름, 직급, 부서, 급여를 직급 순으로 정렬하여 조회
SELECT EMP_NAME "이름" , JOB_CODE "직급" , DEPT_CODE "부서" , SALARY "급여"
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY JOB_CODE;


-- 가장 적은 급여를 받는 직원의 --> 서브쿼리
-- 사번, 이름, 직급코드, 부서코드, 급여, 입사일을 조회
SELECT EMP_NO, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);


-- 노옹철 사원의 급여보다 많이 받는 직원의
-- 사번, 이름, 부서, 직급, 급여를 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계

-- 1), 2)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;


-- 3) 위의 두 서브쿼리 합쳐 부서별 급여 합이 큰 부서의 부서명, 급여 합 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);


--------------------------------------------------------------------------------


/*
    >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 x
    
    - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
                    혹은 없다면 이라는 의미(가장 많이 사용!)
                    
    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
                     
    - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
                     가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
                     
    - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
    
*/

-- 부서별 최고 급여를 받는 직원의
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회

-- 1) 부서별 최고 급여
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 7행, 1열

-- 2) 1) 합치기
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- = 사용 못하니 IN 사용해야함


-- 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/직원)

-- 1) 사수에 해당하는 사원 번호 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급명 조회(부서 없는 사람 포함)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회(이 때 구분은 '사수')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사수' 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);
                
                
-- 4) 일반 직원에 해당하는 사원들 정보 조회(이 때 구분은 '사원')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사원' 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);

-- 5) 3,4의 조회 결과를 하나로 합침 -> SELECT절 SUBQUERY
-- * SELECT절에도 서브쿼리 사용할 수 있음

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
    CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL)
        THEN '사수'
        ELSE '사원'
    END 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);


-- UNION 사용 예제
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사수' 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL)
                
UNION -- 합집합(2개의 RESULT SET을 하나로 합침)
                
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사원' 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);

--------------------------------------------------------------------------------

-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ANY 혹은 < ANY 연산자를 사용

/*    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
*/                
                     
-- 1) 직급이 대리인 직원의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원
-- 3-1) MIN을 이용하여 단일행 서브쿼리를 만듦
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' 
AND SALARY < (SELECT MIN(SALARY)
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장');
                                        
-- 3-2) ANY를 이용하여 과장 중 가장 급여가 적은 직원을 초과하는 대리 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' 
AND SALARY > ANY (SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장');

-- 차장 직급 급여 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연산자를 사용하세요

-- 1) 과장 직급의 직원 사번, 이름, 직급, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 2) 차장 직급 급여의 가장 큰 값
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

-- 3) 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > (SELECT MAX(SALARY)
                                    FROM EMPLOYEE
                                    JOIN JOB USING(JOB_CODE)
                                    WHERE JOB_NAME = '차장');

-- 4) 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > ALL (SELECT SALARY
                                    FROM EMPLOYEE
                                    JOIN JOB USING(JOB_CODE)
                                    WHERE JOB_NAME = '차장');



-- 서브쿼리 중첩 사용(응용편!)
-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; -- L1(단일행 서브쿼리)

-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE
                    FROM LOCATION
                    WHERE NATIONAL_CODE = 'KO');

-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_ID
                    FROM DEPARTMENT
                    WHERE LOCATION_ID = (SELECT LOCAL_CODE
                                        FROM LOCATION
                                        WHERE NATIONAL_CODE = 'KO'));


--------------------------------------------------------------------------------

-- 3. 다중열 서브쿼리 (단일행 = 결과값은 한 행)
-- 서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회

-- 1) 퇴사한 여직원 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8,1) = 2 AND ENT_DATE IS NOT NULL;

-- 1, 2) 여직원과 같은 부서, 같은 직급
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                            FROM EMPLOYEE
                            WHERE SUBSTR(EMP_NO, 8,1) = 2 AND ENT_DATE IS NOT NULL)
AND JOB_CODE = (SELECT JOB_CODE
                            FROM EMPLOYEE
                            WHERE SUBSTR(EMP_NO, 8,1) = 2 AND ENT_DATE IS NOT NULL);

-- 1, 2, 3) 근데 코드 중복이 너무 많으니 간단화하기
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                            FROM EMPLOYEE
                            WHERE SUBSTR(EMP_NO, 8,1) = 2 AND ENT_DATE IS NOT NULL);


-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명
 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';

-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE 
                                FROM EMPLOYEE
                                WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);


--------------------------------------------------------------------------------

-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원 단위로 계산하세요
-- TRUNC(컬럼명, -4)

-- 1) 급여를 200만, 600만 받는 직원
SELECT EMP_ID, EMP_NAME,JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2000000, 6000000);

-- 2) 직급별 평균 급여
SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 3) 본인 직급의 평균 급여를 받고 있는 직원
SELECT EMP_ID, EMP_NAME,JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY)  IN (SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);

--------------------------------------------------------------------------------

-- 5. 상호연관 서브쿼리(상관 서브쿼리)
-- 메인쿼리 1행씩 우선 해석, 서브쿼리 나중에 해석
-- 상관 쿼리는 메인쿼리가 사용하는 테이블 값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블 값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조


-- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함



-- 직급별 급여 평균보다 급여를 많이 받는 직원의 이름, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E1
WHERE SALARY > (SELECT AVG(SALARY) 
                FROM EMPLOYEE E2
                WHERE E2.JOB_CODE = E1.JOB_CODE);

-- 1) 메인쿼리 1행 해석
-- 2) 해석된 메인쿼리 1행을 이용해 서브쿼리 조회
-- 3) 서브쿼리 결과를 이용해 메인쿼리 해석 중인 1행을 대상으로 조회


-- 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외

-- 특정 부서에서 가장 빠른 입사일
SELECT DEPT_CODE, MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE ENT_YN = 'N'
GROUP BY DEPT_CODE;

-- 상관쿼리 사용
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE) 
                    FROM EMPLOYEE SUB
                    WHERE SUB.DEPT_CODE = MAIN.DEPT_CODE
                    AND ENT_YN = 'N')
ORDER BY HIRE_DATE;


-- 사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회
-- EXISTS : 서브쿼리에 해당하는 행이 1개라도 존재하면 조회 결과에 포함

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EXISTS (SELECT EMP_ID 
                FROM EMPLOYEE SUB
                WHERE MAIN.MANAGER_ID = SUB.EMP_ID);


--------------------------------------------------------------------------------

-- 6. 스칼라 서브쿼리
-- SELECT절에 사용되는 서브쿼리 결과로 1행(단일행)만 반환\
-- --> SELECT 절에 작성하는 단일행 서브쿼리
-- SQL에서 단일 값을 가르켜 '스칼라'라고 함
-- 보통 상관 서브쿼리와 함께 사용됨

SELECT EMP_NAME, SALARY, (SELECT FLOOR(AVG(SALARY))FROM EMPLOYEE) "평균"
FROM EMPLOYEE;

-- 각 직원들이 속한 직급의 급여 평균 조회
SELECT EMP_NAME, SALARY, JOB_CODE, 
        (SELECT FLOOR(AVG(SALARY))FROM EMPLOYEE SUB
        WHERE SUB.JOB_CODE = MAIN.JOB_CODE) "평균"
FROM EMPLOYEE MAIN;

-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단, 관리자가 없는 경우 '없음'으로 표시
SELECT EMP_ID, EMP_NAME, NVL(MANAGER_ID, '없음'), 
NVL((SELECT EMP_NAME FROM EMPLOYEE E2
WHERE E2.EMP_ID = E1.MANAGER_ID), '없음') "관리자명"
-- 메인쿼리(E1)에서 MANAGER_ID를 얻어와 서브쿼리(E2)에서 같은 EMP_ID를 가진 사원의 이름을 조회
FROM EMPLOYEE E1;


--------------------------------------------------------------------------------

-- 7. 인라인 뷰
-- FROM 절에서 서브쿼리를 사용하는 경우로,
-- 서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신 사용

-- 인라인 뷰를 활용한 TOP-N 분석

-- 진 직원 중 급여가 높은 상위 5명의 순위, 이름, 급여 조회

-- 1) 급여 높은 순서로 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 2) 조회되는 행 앞에 1부터 순서대로 1씩 증가하는 번호 붙이기
-- ROWNUM : 행 번호를 나타내는 가상 컬럼(1부터 1씩 증가)
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE;


-- 3) ROWNUM을 조건에 사용하기
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE
WHERE ROWNUM <=5;

-- 4) 1,2,3번 토대로 급여 상위 5명 조회 시도
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <=5
ORDER BY SALARY DESC;

-- SELECT 해석 순서를 고려하지 않아서 제대로 조회되지 않음
--> 이 문제를 해결하기 위해서는 [인라인 뷰]가 필요

-- 해결 1) 급여 내림차순 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
--> 해결 1의 조회 결과(RESULT SET)을 가상의 테이블(== VIEW) 취급을 할 예정

-- 해결 2) 해결 1의 조회 결과를 FROM절에 사용한 후
--          상위 5행만 조회하기

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT ROWNUM, EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) -- FROM절 내부에 포함된 가상의 테이블 == 인라인 뷰
WHERE ROWNUM <=5;


-- 급여 평균이 3위 안에 드는 부서의 부서코드와 부서명, 평균 급여를 조회

-- 부서코드, 부서명, 평균 급여
SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY)) 평균급여
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY 평균급여 DESC;

SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, 평균급여
FROM (SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY)) 평균급여
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_CODE, DEPT_TITLE
        ORDER BY 평균급여 DESC)
WHERE ROWNUM <=3;

SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY))
FROM (SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY))
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_CODE, DEPT_TITLE
        ORDER BY  FLOOR(AVG(SALARY)) DESC)
WHERE ROWNUM <=3;


--------------------------------------------------------------------------------

-- 8. WITH
-- 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용 시 이름을 사용하게 함
-- 인라인뷰로 사용될 때 서브쿼리에 주로 사용됨
-- 실행 속도가 빨라진다는 장점이 있음

-- 전 직원의 급여 순위
-- 순위, 이름, 급여 조회
SELECT ROWNUM 순위, EMP_NAME 이름, SALARY 급여 
FROM (SELECT EMP_NAME, SALARY 
        FROM EMPLOYEE 
        ORDER BY SALARY DESC);
        

-- TOP_SAL 이라는 이름의 서브쿼리를 미리 생성
WITH TOP_SAL AS (SELECT EMP_NAME, SALARY 
                    FROM EMPLOYEE 
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM TOP_SAL;

--------------------------------------------------------------------------------

-- 9. RANK() OVER / DENSE_RANK() OVER

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
--                 EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위

SELECT RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;

-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
--                 EX) 공동 1위가 2명이면 다음 순위는 2위

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;

--------------------------------------------------------------------------------

-- 실습 문제

-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오(단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME ='전지연')
AND EMP_NAME != '전지연';

-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MAX(SALARY)
                FROM EMPLOYEE
                WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000);


-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오
-- 단, 노옹철 사원은 제외
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) =(SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME='노옹철')
AND EMP_NAME != '노옹철';

-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (JOB_CODE, DEPT_CODE) = (SELECT JOB_CODE, DEPT_CODE
                                FROM EMPLOYEE
                                WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

 -- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
 -- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID 
                                    FROM EMPLOYEE 
                                    WHERE SUBSTR(EMP_NO,1,2) = 77 
                                    AND SUBSTR(EMP_NO,8,1) = 2);

-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE E1
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE)
                    FROM EMPLOYEE E2
                    WHERE ENT_YN = 'N'
                    AND E2.DEPT_CODE = E1.DEPT_CODE
                    OR E2.DEPT_CODE IS NULL AND E1.DEPT_CODE IS NULL)
ORDER BY HIRE_DATE;

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE)
                    FROM EMPLOYEE
                    WHERE ENT_YN = 'N'
                    GROUP BY DEPT_CODE)
ORDER BY HIRE_DATE;

-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단, 연봉은 \124,800,000으로 출력되게0 하세요
-- (\:원 단위 기호)

SELECT EMP_ID, EMP_NAME, JOB_NAME, 
EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RRRR')))+1 나이,
TO_CHAR(SALARY*12*(1+NVL(BONUS,0)),'L999,999,999') "보너스 포함 연봉"
FROM EMPLOYEE E1
JOIN JOB J ON(E1.JOB_CODE = J.JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2) = (SELECT MAX(SUBSTR(EMP_NO,1,2))
                            FROM EMPLOYEE E2
                            WHERE E1.JOB_CODE = E2.JOB_CODE)
ORDER BY 나이 DESC;

--- 만나이 계산법 (MONTHS BETWEEN 사용)
SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'))/12)
FROM EMPLOYEE;

SELECT MAX(SUBSTR(EMP_NO,1,2))
FROM EMPLOYEE
GROUP BY JOB_CODE;
