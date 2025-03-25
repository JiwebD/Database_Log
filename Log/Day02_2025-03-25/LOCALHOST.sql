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

--제품 그룹별 판매 금액 합계(!)
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
 SELECT Name, height FROM userTbl ORDER BY height DESC, name ASC;
 
 --------------------------
-- 서브쿼리
--------------------------
--  Oracle 꿀템 키워드 Rownum(LIMIT) 행마다 기본적으로 부여되는 num
select rownum as RN, usertbl.* from usertbl where RN = 2; -- 에러
-- 서브쿼리로 안쓰고 where절 쓰면 기본 실행 순서가
-- from > where > group by > select > order by라서
-- select에서 정한 rownum as RN 컬럼을 먼저실행되는 where절에서 사용할 수 없다.

select * from
(select rownum as RN, usertbl.* from usertbl) where RN = 2;
-- (select rownum as RN, usertbl.* from usertbl) 를 테이블로 사용중
-- 이와 같이 서브쿼리를 사용하면 가능!!

select * from
(select rownum as RN, usertbl.* from usertbl) where RN>=2 and RN<=4;


