--------------------------
-- GROUP BY
--------------------------
--  목적 : 데이터를 그룹화하여 집계 함수와 함께 사용하는 SQL 구문
--    집계 함수 : SUM, AVG, COUNT, MAX, MIN 등

select *
from buytbl;

-- 사용자별 총 구매액 계산
select userid,sum(price*amount) as 구매총액
from buytbl
group by userid;

-- 사용자별 구매 횟수 계산
select userid,count(*) as 구매횟수
from buytbl
group by userid;

-- 지역별 사용자 수 계산
SELECT addr, COUNT(*) AS 사용자수
FROM userTbl
GROUP BY addr;

-- 제품 그룹별 판매 금액 합계(!)
SELECT groupName, SUM(price * amount) AS 판매액
FROM buyTbl
--WHERE groupName IS NOT NULL
GROUP BY groupName;

-- 출생년도 기준 사용자 수
select birthyear, count(*) as 인원수
from userTbl
group by birthYear
order by birthYear;


--------------------------
-- ORDER BY  (정렬)
--------------------------
-- 오름차순 asc
SELECT Name , mDate From userTbl ORDER BY mDate asc;
SELECT Name , mDate From userTbl ORDER BY name;
-- 내림차순 desc
SELECT Name , mDate From userTbl ORDER BY mDate desc;

-- 오름+내림
-- 키가 큰 사람부터 작은사람순으로 정렬, 키가 같은 사람이 있으면 이름순 정렬
 SELECT Name, height FROM userTbl ORDER BY height DESC, name ASC;
 
--------------------------
-- 서브쿼리
--------------------------
--  Oracle 꿀템 키워드 Rownum(LIMIT) 행마다 기본적으로 부여되는 num
select rownum as RN, usertbl.* from usertbl where RN = 2; -- 에러
-- 서브쿼리로 안쓰고 where절 쓰면 기본 실행 순서가
-- from > where > group by > having > select > order by라서
-- select에서 정한 rownum as RN 컬럼을 먼저실행되는 where절에서 사용할 수 없다.

select * from
(select rownum as RN, usertbl.* from usertbl) where RN = 2;
-- (select rownum as RN, usertbl.* from usertbl) 를 테이블로 사용중
-- 이와 같이 서브쿼리를 사용하면 가능!!

select * from
(select rownum as RN, usertbl.* from usertbl) where RN>=2 and RN<=4;

--------------------------
-- HAVING
--------------------------
--목적 : 그룹화한 후에 그룹을 필터링

--구매 금액 합계가 1000 이상인 사용자 조회
SELECT userID, SUM(price * amount) AS 총구매액
FROM buyTbl
GROUP BY userID
HAVING SUM(price * amount) >= 1000;

--평균 키가 175 이상인 지역 조회
SELECT addr, AVG(height) AS 평균키
FROM userTbl
GROUP BY addr
HAVING AVG(height) >= 175;

--구매 횟수가 2회 이상인 사용자의 총 구매액
SELECT userID, SUM(price * amount) AS 총구매액
FROM buyTbl
GROUP BY userID
HAVING COUNT(*) >= 2;

--최대 구매 금액이 500 이상인 물품별 통계
SELECT prodName, COUNT(*) AS 구매횟수, MAX(price * amount) AS 최대구매액
FROM buyTbl
GROUP BY prodName
HAVING MAX(price * amount) >= 500;

--총 구매 횟수가 3회 이상이고 총 구매액이 100 이상인 사용자
SELECT userID, COUNT(*) AS 구매횟수, SUM(price * amount) AS 총구매액
FROM buyTbl
GROUP BY userID
HAVING COUNT(*) >= 3 AND SUM(price * amount) >= 100;


-- -------------------
-- 복합 group by 
-- -------------------
--사용자 지역별, 제품 그룹별 구매액 합계
select * from userTbl;
select * from buyTbl;

SELECT u.addr, b.groupName, SUM(b.price * b.amount) AS 총구매액
FROM userTbl u
JOIN buyTbl b ON u.userID = b.userID
WHERE b.groupName IS NOT NULL
GROUP BY u.addr, b.groupName
ORDER BY u.addr, b.groupName;

SELECT u.addr, Coalesce(b.groupName, '미분류'), SUM(b.price * b.amount) AS 총구매액
FROM userTbl u
JOIN buyTbl b 
ON u.userID = b.userID
GROUP BY u.addr, b.groupName
ORDER BY 총구매액 desc;

--연령대별, 제품별 구매 통계
SELECT 
    FLOOR((2023 - birthYear) / 10) * 10 AS 연령대, 
    b.prodName, 
    COUNT(*) AS 구매횟수,
    SUM(b.price * b.amount) AS 총구매액
FROM userTbl u
JOIN buyTbl b ON u.userID = b.userID
GROUP BY FLOOR((2023 - birthYear) / 10) * 10, b.prodName
ORDER BY 연령대, b.prodName;

--지역별, 연도별 회원가입 수
SELECT 
    addr, 
    EXTRACT(YEAR FROM mDate) AS 가입연도, 
    COUNT(*) AS 회원수
FROM userTbl
GROUP BY addr, EXTRACT(YEAR FROM mDate)
HAVING COUNT(*) >= 2
ORDER BY addr, 가입연도;

-- -----------------------
-- GROUP BY 함수와 ROLLUP
-- -----------------------
-- ROLLUP
-- 소계와 합계를 자동으로 계산해주는 함수.

select nvl(groupName,'미분류'),sum(price*amount)
from buytbl
group by rollup(groupname);

-- -----------------------
-- GROUP BY 함수와 CUBE
-- -----------------------
-- 목적 : 모든 가능한 조합의 소계와 합계를 계산합니다.

SELECT groupName, prodName, SUM(price * amount) AS 판매액
FROM buyTbl
WHERE groupName IS NOT NULL
GROUP BY CUBE(groupName, prodName);

-- -----------------------
-- GROUPING SETS
-- -----------------------
-- 특정 그룹화 조합의 결과를 UNION ALL로 결합한 것과 같은 결과를 제공합니다.
SELECT groupName, prodName, SUM(price * amount) AS 판매액
FROM buyTbl
WHERE groupName IS NOT NULL
GROUP BY GROUPING SETS((groupName), (prodName), ());

select groupName,NULL as prodName,sum(price *amount) 
from buytbl
where groupname is not null
group by groupname

union all

select NULL as groupName,prodName,sum(price*amount)
from buytbl
where groupName is not null
group by prodName;

-- ------------------------
-- 문제 GROUP BY 문
-- ------------------------
-- 1) userTbl에서 지역(addr)별 사용자 수를 구하는 SQL문을 작성하시오.
select addr,count(*) from usertbl group by addr;

-- 2) buyTbl에서 사용자(userID)별 총 구매액을 구하는 SQL문을 작성하시오. 총 구매액은 가격(price)과 수량(amount)의 곱의 합으로 계산하시오.
select userid,sum(price * amount) from buytbl group by userid;

-- 3) buyTbl에서 제품 그룹(groupName)별 판매 수량의 합계를 구하는 SQL문을 작성하시오. NULL 값은 '미분류'로 표시하시오.
-- COALESCE = 가장 처음으로 NULL이 아닌 값을 반환함. = 여러값 중 null이 아닌 첫번째 값.
-- COALESCE(null,'a','b')  => a 출력
-- COALESCE(groupName,'미분류')
-- => groupName 값 이 null 이 아니면 = COALESCE('null이 아닌값','미분류') =null이 아닌값 출력
-- => groupName 값 이 null 이면 = COALESCE(null,'미분류') =null이 아닌값 출력 첫번째 값 '미분류'출력
select coalesce(groupName,'미분류') as 카테고리 ,sum(amount) from buytbl group by groupName;
-- NVL
select NVL(groupName,'미분류') as 카테고리 ,sum(amount) from buytbl group by groupName;
-- case - IS NULL THEN
select 
    case 
        when groupName IS NULL THEN '미분류!'
        else groupName
    end
    as 카테고리 ,sum(amount)
from buytbl
group by groupName;

-- 4) userTbl에서 출생년도(birthYear)별 평균 키(height)를 구하는 SQL문을 작성하시오.
select birthYear,avg(height) from usertbl group by birthYear;

-- 5) buyTbl에서 제품명(prodName)별 구매 횟수와 총 구매액을 구하는 SQL문을 작성하시오. 결과는 구매 횟수가 많은 순으로 정렬하시오.
select prodName,count(*) as "구매 횟수", sum(price*amount) as 총구매액 from buytbl group by prodName;

-- 6) userTbl에서 mobile1(통신사)별 가입자 수를 구하되, NULL 값은 '미입력'으로 표시하는 SQL문을 작성하시오.
select COALESCE(mobile1, '미입력') as 통신사 , count(*) as "가입자 수" from userTbl group by mobile1;

select * from userTbl;

-- 7) userTbl과 buyTbl을 조인하여 지역(addr)별 총 구매액을 구하는 SQL문을 작성하시오.

select u.addr,sum(b.price*b.amount) as 총구매액
from userTbl u
join buytbl b
on u.userid = b.userid
group by u.addr;

-- 8) buyTbl에서 사용자별 구매한 제품의 종류 수를 구하는 SQL문을 작성하시오.
select * from buyTbl;

select userid,groupname,count(groupName) from buyTbl group by userid,groupname;

-- 9) userTbl에서 가입 연도별(mDate의 연도 부분) 가입자 수를 구하는 SQL문을 작성하시오.
select SUBSTR(mDate,1,2),count(*) from usertbl group by SUBSTR(mDate,1,2);

SELECT EXTRACT(YEAR FROM mDate) AS 가입연도, COUNT(*) AS 가입자수
FROM userTbl
GROUP BY EXTRACT(YEAR FROM mDate)
ORDER BY 가입연도;

-- 10) buyTbl과 userTbl을 조인하여 연령대별(10대, 20대, ...) 구매 총액을 계산하는 SQL문을 작성하시오. 연령은 2023년 기준으로 계산하시오.
select *
from buyTbl;

select *
from userTbl;

select 2025-u.birthyear as 연령 , sum(b.price* b.amount)
from userTbl u
join buyTbl b
on u.userid = b.userid
group by u.birthyear;

SELECT FLOOR((2025 - u.birthYear) / 10) * 10 AS 연령대, 
       SUM(b.price * b.amount) AS 구매총액
FROM userTbl u
JOIN buyTbl b ON u.userID = b.userID
GROUP BY FLOOR((2025 - u.birthYear) / 10) * 10
ORDER BY 연령대;

-- ------------------------
-- 문제 having
-- ------------------------
-- 1) buyTbl에서 총 구매액이 1,000 이상인 사용자(userID)만 조회하는 SQL문을 작성하시오.
select * from buyTbl;

-- having사용
select userid, sum(price*amount) as 총구매액
      from buyTbl
      group by userid
      having sum(price*amount) >= 1000;

-- 서브쿼리 사용      
select * 
from (select userid, sum(price*amount) as 총구매액
      from buyTbl
      group by userid) 
where 총구매액 >= 1000;      
      

-- 2) userTbl에서 가입자 수가 2명 이상인 지역(addr)만 조회하는 SQL문을 작성하시오.
select * from userTbl;

-- having사용
select addr, count(*) as 가입자수
from userTbl
group by addr
having count(*) >= 2;

-- 서브쿼리 사용
select *
from
(select addr, count(*) as 가입자수
from userTbl
group by addr)
where 가입자수 >= 2;

-- 3) buyTbl에서 평균 구매액이 100 이상인 제품(prodName)만 조회하는 SQL문을 작성하시오.
select * from buyTbl;

-- having사용
select prodName, avg(price*amount) as 평균_구매액
from buyTbl
group by prodName
having avg(price*amount) >= 100;

-- 서브쿼리 사용
select *
from
(select prodName, avg(price*amount) as 평균_구매액
from buyTbl
group by prodName)
where 평균_구매액 >= 100;

-- 4) userTbl에서 평균 키가 175cm 이상인 출생년도를 조회하는 SQL문을 작성하시오.
select * from userTbl;

-- having사용
select birthyear, avg(height) as 평균키 from userTbl
group by birthyear
having avg(height) >= 175;

-- 서브쿼리 사용
select birthyear, 평균키
from (select birthyear, avg(height) as 평균키 from userTbl
     group by birthyear)
where 평균키 >= 175;



-- 5) buyTbl에서 최소 2개 이상의 제품을 구매한 사용자(userID)를 조회하는 SQL문을 작성하시오.
select * from buyTbl;

-- having 사용
select userId, sum(amount) as 구매개수
from buyTbl
group by userId
having sum(amount) >= 2;

-- 서브쿼리 사용
select *
from
(select userId,  sum(amount) as 구매개수
from buyTbl
group by userId)
where 구매개수 >= 2;

-- 6) userTbl과 buyTbl을 조인하여 구매 총액이 200 이상인 지역(addr)만 조회하는 SQL문을 작성하시오.
select * from userTbl;
select * from buyTbl;

select u.addr , sum(b.price * b.amount) as 구매총액
from userTbl u
join buyTbl b
on u.userid = b.userid
group by u.addr
having sum(b.price * b.amount) >= 200;

-- 7) buyTbl에서 구매 횟수가 3회 이상이고 총 구매액이 500 이상인 사용자(userID)를 조회하는 SQL문을 작성하시오.
select userid , count(*) as 구매횟수, sum(price*amount) as 총구매액
from buytbl
group by userid
having count(*)>=3 and sum(price*amount) >=500;

-- 8) userTbl에서 평균 키가 가장 큰 지역(addr)을 조회하는 SQL문을 작성하시오. (서브쿼리와 HAVING 사용)
select * from userTbl;

select addr, avg(height) as 평균키
from userTbl
group by addr
having avg(height) = (
    select max(평균키)
    from(
        select avg(height) as 평균키
        from userTbl
        group by addr
    )
);

select *
from (select addr,avg(height) as 평균키 from usertbl group by addr)
where 평균키 = (select max(avg(height)) as 평균키 from usertbl group by addr);


-- 9) buyTbl에서 구매 금액의 평균값보다 더 많은 금액을 사용한 사용자(userID)를 조회하는 SQL문을 작성하시오. (서브쿼리와 HAVING 사용)
select userid, avg(price*amount) as 평균금액
from buyTbl
group by userid
having avg(price*amount) > (
    select avg(price*amount)
    from buyTbl
    );

select avg(price*amount)
    from buyTbl;

    
-- 10) userTbl과 buyTbl을 조인하여 같은 지역(addr)에 사는 사용자들 중 구매 총액이 지역별 평균 구매액보다 높은 사용자(userID)를 조회하는 SQL문을 작성하시오. (서브쿼리와 HAVING 사용)

-- 풀이1)
select u.userid, u.addr, sum(b.price*b.amount) as 구매총액, avg(b.price*b.amount) as 지역별평균
from userTbl u
join buyTbl b
on u.userid = b.useridㄴ
group by u.userid, u.addr
having sum(b.price*b.amount) >=(
    select avg(b2.price*b2.amount)
    from userTbl u2
    join buyTbl b2
    on u2.userid = b2.userid
    where u2.addr = u.addr  -- 외부 쿼리의 addr을 참조
    );

    -- 사용자별 구매 총액
    (select u.userid, u.addr, sum(b.price*b.amount) as 구매총액
    from userTbl u
    join buyTbl b
    on u.userid = b.userid
    group by u.userid, u.addr);
    
     -- 지역별 평균 구매액
    (select u.addr, avg(b.price*b.amount) as 지역별평균
    from userTbl u
    join buyTbl b
    on u.userid = b.userid
    group by u.addr);
    
    
    
--    풀이2)
    select aa.userid, aa.addr, aa.구매총액, bb.지역별평균
    from (select u.userid, u.addr, sum(b.price*b.amount) as 구매총액
             from userTbl u
             join buyTbl b
             on u.userid = b.userid
             group by u.userid, u.addr) aa
    join
        (select  u.addr, avg(b.price*b.amount) as 지역별평균
         from userTbl u
         join buyTbl b
         on u.userid = b.userid
         group by u.addr) bb
    on aa.addr = bb.addr
    where aa.구매총액>=bb.지역별평균;


