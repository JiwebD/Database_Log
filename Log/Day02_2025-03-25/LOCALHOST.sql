--------------------------
-- GROUP BY
--------------------------
--  ���� : �����͸� �׷�ȭ�Ͽ� ���� �Լ��� �Բ� ����ϴ� SQL ����
--    ���� �Լ� : SUM, AVG, COUNT, MAX, MIN ��

select *
from buytbl;

-- ����ں� �� ���ž� ���
select userid,sum(price*amount) as �����Ѿ�
from buytbl
group by userid;

-- ����ں� ���� Ƚ�� ���
select userid,count(*) as ����Ƚ��
from buytbl
group by userid;

-- ������ ����� �� ���
SELECT addr, COUNT(*) AS ����ڼ�
FROM userTbl
GROUP BY addr;

--��ǰ �׷캰 �Ǹ� �ݾ� �հ�(!)
SELECT groupName, SUM(price * amount) AS �Ǹž�
FROM buyTbl
--WHERE groupName IS NOT NULL
GROUP BY groupName;

-- ����⵵ ���� ����� ��
select birthyear, count(*) as �ο���
from userTbl
group by birthYear
order by birthYear;


--------------------------
-- ORDER BY  (����)
--------------------------
-- �������� asc
SELECT Name , mDate From userTbl ORDER BY mDate asc;
SELECT Name , mDate From userTbl ORDER BY name;
-- �������� desc
SELECT Name , mDate From userTbl ORDER BY mDate desc;

-- ����+����
 SELECT Name, height FROM userTbl ORDER BY height DESC, name ASC;
 
 --------------------------
-- ��������
--------------------------
--  Oracle ���� Ű���� Rownum(LIMIT) �ึ�� �⺻������ �ο��Ǵ� num
select rownum as RN, usertbl.* from usertbl where RN = 2; -- ����
-- ���������� �Ⱦ��� where�� ���� �⺻ ���� ������
-- from > where > group by > select > order by��
-- select���� ���� rownum as RN �÷��� ��������Ǵ� where������ ����� �� ����.

select * from
(select rownum as RN, usertbl.* from usertbl) where RN = 2;
-- (select rownum as RN, usertbl.* from usertbl) �� ���̺�� �����
-- �̿� ���� ���������� ����ϸ� ����!!

select * from
(select rownum as RN, usertbl.* from usertbl) where RN>=2 and RN<=4;


