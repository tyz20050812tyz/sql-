create table tbl1(id varchar(10)
	name varchar(50)
	);--varchar是可变长度的
select * from tbl1; 
insert into tbl1 values('x1','xx');
--表是允许重复的
--添加约束：主码————非空约束，唯一性约束
drop table tbl1;
--销毁表
create table tbl1(id varchar(10) primary key,--直接添加primary key去设置主码
	name varchar(50)
	);--varchar是可变长度的
--设置好主码后，如果insert两个相同的值，就会报错：
--错误： 键值"(id)=(x1)" 已经存在重复键违反唯一约束"tbl1_pkey" 
--不允许同时存在多个主码，如果想将多个列设置为主码
create table tbl1(id varchar(10),
				name varchar(50),
				primary key(id,name)--通过单独的一个项作为多列的主码设置
	);
--如何命名？
create table tbl1(id varchar(10),
				name varchar(50),
				constraint pk_tbl1 primary key(id,name)--通过单独的一个项作为多列的主码设置
	);
--创建一个表tbl2，带有主键和外键，外键参照表A（id,name,numcol_a,numcol_b,fid）
select*from tbl2;
drop table tbl2;
create table tbl2( id varchar(10) primary key,--主码
	name varchar(50) not null unique,--非空约束,唯一约束
	numcol_a numeric(4,-1) ,
	numcol_b numeric(6,4) default 10,--如果不输入值，自动赋值
	fid varchar(20),
	constraint fk_tbl2 foreign key(fid) --外键
	references tbl1(id)--参照必须与其主码完全对应
);

insert into tbl2 values('1','tyz',3.5,4.23,'x1');
insert into tbl2 values('2','tyz2',3.55,4.235,'x1');
--还可以这么写
insert into tbl2(id,name,numcol_a,numcol_b,fid) 
	values('3','tyz3',3.555,4.2355,'x1');
insert into tbl2(id,name) 
	values('4','tyz4')
--也可以自定义顺序
insert into tbl2(name,id) 
	values('tyz4','4');
--外码必须存在在对应的列中
--numeric(m,n)
--先确定小数位数，小数有n位，然后在确定整数位数m-n位
--比如numeric(5,3),5.3514=5.351
--update 带条件更新

alter table tbl1 add column newcol varchar(20);
--增加一个新列 
--使用update去更新一个数值
update tbl2
	set numcol_a=50,numcol_b=80
	where id='1';
--记得使用where去约束
--预测以下语句执行结果
 update tbl2 set numcol_a=numcol_a+100,numcol_b=numcol_a+50
 where id='2';
--记住：整个关系都取自旧值
--delete 带条件删除
delete from tbl2
	where id='2';

--更改numcol数据类型，分析数值类型特点
alter table tbl2
	alter column numcol_a type varchar(40)
--更改numcol属性名numcol2
alter table tbl2
	rename column numcol_a to numcol_a2
--利用网上资源查找alter table的其他具体语句


--SELECT 核心要点： 1. 不区分大小写，2. 语法顺序固定，3. 输入输出都是表，4. 可以存在重复
--语法顺序：
select
from
where
group by
having
order by
limit
--运算逻辑顺序
from
where
group by
having
select
order by
limit
	
--FROM --基本含义
--查询所有部门的基本信息（部门编号、名称、地点）
select dname,deptno,loc
	from dept;
--显示员工姓名及其所属部门名称（提供四种写法）
--笛卡尔+过滤
select emp.ename,dept.dname
	from emp,dept--笛卡尔
	where emp.deptno=dept.deptno;
--join 
select emp.ename,dept.dname
	from emp join dept on emp.deptno=dept.deptno;
--natural join
select emp.ename,dept.dname
	from emp natural join dept ;
--确定相同属性，等值比较，只保留一个
--inner join
select emp.ename,dept.dname
	from emp left join dept 
	on emp.deptno=dept.deptno;

select * from salgrade
--查询工资在工资等级表中第2级的员工（不等值连接）
 select ename
	 from emp join salgrade on emp.sal>=salgrade.losal 
	and emp.sal<=salgrade.hisal
	where salgrade.grade=2;

--查询所有员工的姓名、部门名称及其工资等级（多表）


--列出每个部门（包括无员工的部门）的部门信息及员工列表，如果部门无员工，列出部门信息
--对比inner join与outer join
select ename,dname
	from emp right join dept on emp.deptno=emp.deptno; 
--保留员工。即使没有部门
select ename,dname
	from emp left join dept on emp.deptno=emp.deptno; 
--外连接 left right full
--所有员工信息
select * 
	from emp left  join dept on dept.deptno=emp.deptno
	 left  join salgrade on emp.sal>=salgrade.losal and emp.sal<=salgrade.hisal;
--只要前面有了left join 后面一定要是left join


insert into emp(empno,ename) values(123,'tyz')
--查询所有工资等级及其对应的员工（包括无员工的等级）
select salgrade.grade,emp.ename
	from emp right join salgrade on 
	emp.sal>=salgrade.losal 
	and emp.sal>=salgrade.hisal;

--显示部门和员工的对应关系（包括无员工的部门和无部门归属的员工）

--列出员工及其直接领导的姓名
--self join
select e1.ename ,e2.ename as 领导
	from emp e1 join emp e2 on
	e1.mgr=e2.empno;
select * from dept
--显示部门和工资等级的组合（给出三种写法）（笛卡尔积，恒等连接，交叉连接）
select * from dept, salgrade;
select dname,salgrade.grade
	from dept join salgrade on 1=1;
select * from dept cross join salgrade;
--交叉连接就是笛卡尔积
--找出工资相同的不同员工组合。
select e1.ename,e2.ename
	from emp e1 join emp e2 on e1.sal=e2.sal 
	and e1.ename>e2.ename;--只输出一行

--where 基本--数值比较，between and，元组比较，
--查询工资大于等于3000的员工信息
select *
	from emp
	where emp.sal>=3000

--查询部门编号为10或20的员工信息（三种方法，or, in, between and）
select *
	from emp
	where emp.deptno=10 
	or emp.deptno=20 
	or emp.deptno is null;--这样可以实现null
select *
	from emp
	where emp.deptno in (10,20);
select *
	from emp
	where emp.deptno between 10 and 20;
--betweem一定要左边小于右边的
select *
	from emp
	where emp.deptno between 20 and 10;
--null无法进行比较
--查询工资等级为2和3范围的员工信息
select *
	from emp join salgrade on emp.sal>=salgrade.losal
	and emp.sal<=salgrade.hisal
	where salgrade.grade in(2,3);
--查询入职日期在1981年1月1日至1981年12月31日之间的员工（日期类型）

--查询工资是1600，补助是300的员工的信息（两种方法，and, 元组相等比较）
select *
	from emp
	where hiredate>=to_date('1981.01.01','YYYY.MM.DD')
--to_date函数的使用，左侧是日期，右侧是对应的格式
--按以下条件筛选员工，优先筛选所有工资高于 1600 的员工；若工资刚好等于 1600，则进一步检查佣金是否高于200，显示这些员工的信息（元组不等值比较）
select *
	from emp
	where sal>1600 or (sal=1600 and comm>200)
--找出工资相同的不同员工组合，要求相同组合不能重复。
已经做了

--where --字符串比较（等值，大小）
--查询“SCOTT”的员工信息
select *
	from emp
	where ename='SCOTT';

--查询姓名以字母"S"开头的员工（like）
select *
	from emp
	where ename like 'S%'

	
--%代表0或任意多个字符
--_代表一个字符
--\代表转移字符
--escape可以自己定义转义字符

--where --模糊查找  like escape
--查询第二个字符是“L”的员工
select *
	from emp
	where ename like '_L%'
--查找姓名种包含下划线的员工
select *
	from emp
	where ename like '\_'
select *
	from emp
	where ename like 'M_' escape 'M'	
--where --集合成员性检验  in 
--查询部门编号为10或20的员工信息（两种方法，or, in）

--查询不在10号或20号部门的员工的信息


--尝试：--查询部门编号为10或20或没有部门的员工信息（ in）


--尝试： 用not in 方式查询不在10号或20号部门或没有部门的员工的信息

-- group by --含义
-- group by --聚集函数
--列出所有部门（包括无员工部门）的部门名称、员工数量，部门平均工资及部门最高工资等级。 
select dept.dname,emp.deptno+2 ,count(empno)--必须是原原本本的groupby的分组条件
	from emp join dept on emp.deptno=dept.deptno
	group by emp.deptno+2 ,dept.dname--整体作为分组条件
--调换位置也没关系
--列出所有部门（包括无员工部门）的部门名称、员工数量，部门平均工资及部门最高工资等级。
select dname,count(empno),avg(sal),max(sal),min(sal),sum(sal)
	from emp right join dept on dept.deptno=emp.deptno
	group by emp.deptno,dname
-- 查询每个部门中的每种职位的平均工资 
select avg(sal)
	from emp
	group by deptno
-- group by --无子句有聚集函数
-- 获得所有员工的最高工资，员工总人数
select max(sal) as 最高工资,count(empno) as 总人数
	from emp;
-- group by --对select影响
-- 查询每个职位的名称，职位平均工资，任该职位的人员名称列表--返回值要求是标量值，域的原子性
select job,avg(sal),STRING_AGG(ename,'-')--连接字符串
	from emp
	group by job
-- 查询每个部门中每种职位的平均工资，以及该部门的平均工资（单种分组规则不可行）
select deptno,job,avg(sal)
	from emp
	group by deptno,job
--上面用的完全依赖于下面的分组条件
-- having  --核心逻辑
-- 查询平均工资超过2000的部门编号。 
select deptno
	from emp
	group by deptno
	having avg(sal)>2000

-- 获得部门中工资在2200以上人数超过2个的部门的部门号，工资在2200以上员工人数
select deptno,count(empno)
	from emp
	where sal>2200
	group by deptno
	having count(empno)>=2
select deptno,count(empno)
	from emp
	group by deptno
	having count(sal>2200)>=2
	--这个就不行，因为sal>2200为true或false，都是非空
-- 思考：相同语句结构是否可已得到“获得部门中工资在2200以上人数超过2个的部门的部门号，工资在2200以上员工人数，部门总人数”？
select deptno,count(empno),count(case
	when sal>2200 then 1
	else null
	end)
	from emp
	group by deptno
	having count(case
	when sal>2200 then 1
	else null
	end)>=2
--不能实现
-- select子句 --本质
select 1 from emp;
-- 查询每个员工的姓名，工资，工资上涨10%的数值，入职年份，姓名采用首字母大写其他字母小写 -- initcap()
select initcap(ename),sal,sal*1.1,hiredate
from emp;
-- 利用网络资源查询postgresql可用的sql函数

-- select 重命名
-- 查询每个员工的姓名，工资，工资上涨10%的数值，入职年份，姓名采用首字母大写其他字母小写，姓名列命名为new name
select initcap(ename) newname,sal,sal*1.1 "new sal",hiredate
from emp;
--双引号去添加有空格的名称
-- case表达式
-- 计划对于1981年9月之前入职的员工，工资上涨10%，1981年9月之后至1982年9月份之前入职的员工，工资上涨5%。
select ename,hiredate,sal,
	case when hiredate<to_date('1981.09.01','YYYY.MM.DD') then sal*1.1
	when hiredate>=to_date('1981.09.01','YYYY.MM.DD')
			and hiredate<to_date('1982.09.01','YYYY.MM.DD') then sal*1.05
	else  sal
	end
	from emp

-- 查询如果这样变化的话工资数值的变化情况
-- 查询结果需要包括员工姓名，入职时间，原工资，计划更新工资。


-- 查询每个职位的名称，职位平均工资，任该职位的人员名称列表--返回值要求是标量值，域的原子性--string_agg
select job,avg(sal),string_agg(ename,'-')
	from emp
	group by job

-- select --distinct
-- 查询部门中至少有一名员工工资超过3000的部门名称--使用distinct实现
select dname,loc
	from emp natural join dept
	group by deptno,dname,loc
	having count(
	case
		when sal>2000 then 1
		else null
	end
	)>=1
--distinct是针对列表的去重
-- 查询每个部门的职位列表，查询结果包括部门名称，职位名称。每个部门中的职位列表不应该有重复。
select distinct dname,job
	from emp natural join dept
select dname,job
	from emp natural join dept
	group by dname,job
-- 思考：使用distinct是否能够处理“找出工资相同的不同员工组合，要求相同组合不能重复。”
select  e1.ename,e2.ename
	from emp e1 join emp e2 on e1.sal=e2.sal 
	and e1.empno>e2.empno

-- 查出每个部门的人数，职位种类数，工资在2200以上人数---聚集函数中的表达式
select count(empno),count( distinct job),count(
	case
		when sal>2000 then 1
		else null
	end
	)
	from emp
	group by deptno

-- order by
-- 查询所有员工的信息，结果按照工资从高到低排序。查询结果包括部门名称，员工名称，工资
select *
	from emp natural join dept
	order by deptno,sal desc
	
--desc 从高到低排序。不写就是升序
-- 查询所有员工的信息，结果按照部门编号和工资的从高到低排序，查询结果包括部门名称，部门编号，员工名称，（工资）
select *
	from emp
	order by deptno ,sal desc
select * from dept
-- 查询所有员工信息，research部门员工首先显示，再显示销售部门员工，再显示财务部门。
select *
	from emp natural join dept
	order by case
				when dname='RESEARCH' then 1
				when dname='SALES'then 2
				when dname='ACCOUNTING' then 3
				else 4
			end nulls first
--first null把null的放在首位
-- null 的处理 --判断为null
-- 找到所有补助（comm）为null的员工
select *
	from emp
	where comm is null
--is not null
-- 找到每个部门补助为null的员工人数，显示部门名称，补助为null的员工人数
select deptno,count(empno)
	from emp
	where comm is null
	group by deptno
select deptno,count(case  when comm is null then 1 else null   end)
	from emp
	group by deptno
-- null --in 使用in方式尝试
-- 查找补助为0或者null的员工编号，姓名，补助
select *
	from emp
	where comm in (0,null);

-- null --逻辑表达式--使用!=看是否符合要求？
-- 找到所有补助不为0的员工的员工编号，姓名，补助
select *
	from emp
	where comm != 0

-- null --聚集函数
-- 获得每个部门的人数，工资总额，补助总额
select count(empno),sum(sal),sum(comm)
	from emp
	group by deptno

-- 获得部门中工资在2200以上人数超过2个的部门的部门号，工资在2200以上员工人数，部门总人数
select deptno,count(case when sal>=2200 then 1 else null end),
	count(empno)
	from emp
	group by deptno
	having count(case when sal>=2200 then 1 else null end)>=2
select deptno,count(empno),count(empno)
	from emp
	where sal>2200
	group by deptno
--直接被过滤掉了
-- 预测查询结果形态，并解释形成原因
select avg(comm), sum(comm)/count(*),sum(comm)/count(comm),sum(comm)/count(sal),sum(comm)/sum(sal),sum(comm)/sum(empno)
from emp;

-- 预测查询结果形态，并解释形成原因
select count(*), count(sal), count(comm), count(1) 
	from emp;

select 1 from emp;
-- coalesce把null变为数字
-- 查询所有员工的员工姓名，工资，补助，总收入（工资+补助）
select ename,sal,comm,sal+coalesce(comm,0)
from emp

-- nullif把非空值变成null
-- 查询所有员工的员工姓名，工资，补助，工资是补助的多少倍
select ename,sal,comm,sal/nullif(comm,0)
from emp

-- 子查询保证形式正确就可以使用
--显示工资比所有员工平均工资高的员工的信息,包括员工号，员工姓名，员工工资（两种写法）
select *
from emp
where sal>(select avg(sal) from emp)
--这个是不相关子查询，不依赖于外面的表，直接当做一个值
select *
	from emp e1 join 
	(select avg(sal) avgsal from emp) e2 
	on e1.sal>e2.avgsal
--显示工资比某一个部门的平均工资高的员工的信息,包括员工号，员工姓名，员工工资++
select *
from emp
	where sal> all (select avg(sal) from emp
	group by deptno )
select distinct *
from emp e1 join (select avg(sal) avgsal from emp group by deptno) e2
on e1.sal>e2.avgsal
	select *
	from salgrade
--any some 表示其中某一个符合要求就可以
-- 查询每个部门的最高工资员工及其工资等级，显示部门编号，员工名称，工资
--我先找到每个部门的最高工资，连接条件保证是最高工资的员工，属于部门

	select emp.deptno,ename,sal
from emp join (select deptno,max(sal) maxsal from emp
	 group by deptno) maxemp on emp.sal=maxemp.maxsal and
emp.deptno=maxemp.deptno JOIN salgrade ON emp.sal > salgrade.losal
	AND emp.sal < salgrade.hisal;
   
-- with
--显示工资比所在部门平均工资高的员工的信息,包括员工号，员工姓名，员工工资，所在部门平均工资，所担任职位的整体职位平均工资
select empno,ename,e1.sal,e2.avgsal
from emp e1 join (select deptno,avg(sal) avgsal from emp
	group by deptno) e2 on e1.sal>e2.avgsal 
	and e1.deptno=e2.deptno join (select job,avg(sal) avgsal from emp
	group by job) e3 on e1.job=e3.job
--with这个更体现不相关子查询，已经当做两个临时的表
with e2 as (select deptno,avg(sal) avgsal from emp
	group by deptno),
	e3 as (select job,avg(sal) avgsal from emp
	group by job)
select empno,ename,e1.sal,e2.avgsal
from emp e1 join e2 on e1.sal>e2.avgsal 
	and e1.deptno=e2.deptno join e3 on e1.job=e3.job
--得到所有员工的信息,包括员工号，员工姓名，员工工资，所有员工的平均工资++
with t as (select avg(sal) from emp)
	select *
from emp join t on 1=1;
	select *
from emp join (select avg(sal) from emp) e2 on 1=1;
  select *,(select avg(sal) from emp)
from emp ;
--标量子查询,返回一行一列的一个值
--得到所有员工的信息,包括员工号，员工姓名，员工工资，所在部门平均工资，所担任职位平均工资
with e2 as (select deptno,avg(sal) from emp group by deptno)
	 ,e3 as (select job,avg(sal) from emp group by job)
select *
from emp e1 join e2 on e1.deptno=e2.deptno
join e3 on e3.job=e1.job 
--这个就是相关子查询,需要用到外面表格里面的数据,e1.deptno就是


--使用标量子查询实现以上查询 --得到所有员工的信息,包括员工号，员工姓名，员工工资，所在部门平均工资，所担任职位平均工资
select * from dept
--查找在纽约工作的员工，用=号比较查询实现
select *
from emp e1
where exists(select * from dept where e1.deptno=deptno
	and loc='NEW YORK')
select *
	from emp e1 join (select deptno,loc from dept )e2
	on e1.deptno =e2.deptno and e2.loc='NEW YORK'
select *
	from emp
	where deptno=(select deptno from dept 
	where loc='NEW YORK')
--查找在平均工资大于2500的部门工作的员工--使用=号,-->in,--->not in--null的影响
select *
	from emp
	where deptno=(select deptno from emp group by deptno 
	having avg(sal)>2500)
select *
	from emp
	where deptno in (select deptno from emp group by deptno 
	having avg(sal)>2500)
select *
	from emp
	where deptno not in (select deptno from emp group by deptno 
	having avg(sal)>2500 and depno is not null)
--相关子查询--exists
--查询有下属的员工（即担任领导的员工）（后述，子查询）（两种方式实现 in，exists）
--非相关子查询:先生成一个mgr的表,然后一一对应就好了
select *
from emp e1
where e1.empno in (select mgr from emp )
--相关子查询:对每一行,我都进行比较,然后用一个exists来判断是否存在
select *
from emp e1
where exists(select * from emp where mgr=e1.empno);
--查询部门中至少有2名员工工资超过3000的部门名称（in，exists 两种方法）
select distinct dname
from  dept
where deptno in (select deptno from emp where sal>2500
	group by deptno having count(empno)>=2)
select distinct dname
from dept
where exists(select deptno from emp 
	where sal>2500 and emp.deptno=dept.deptno 
	group by deptno 
	having  count(empno)>=2)
--（使用 where。。in。。方式）
 
--（使用 where。。> 。。比较方式）

--（使用 where。。exists 。。比较方式）

--查询工资高于所有CLERK职位的员工（使用两种子查询方式实现, any/all/some,聚集）

--列出工资等于30号部门某一员工工资的员工

--显示工资比20号部门所有员工的工资都高的员工的信息,包括员工号，员工姓名，员工工资(两种方式)

--找到比10号部门员工中某一位员工工资高的员工的姓名，工资

--显示工资比所在部门平均工资高的员工的信息,包括员工号，员工姓名，员工工资（两种方式实现，where,from）

--找到在平均工资小于3000的部门工作的员工,输出员工的姓名，工资，所在部门的平均工资(是否能使用where中子查询实现？)

--工资高于2000并且职位不是（CLERK及SALESMAN）中的某种职位的员工的员工号，姓名，工资，职位（两种方式，包含集合方式）

--回顾练习
---使用五种方法实现：找到人数小于3人的部门的部门名称，即使这个部门没有员工，也应该输出部门名称（连接方式，不相关子查询，不使用exists的相关子查询，exists，集合运算）
---普通的连接方法

---不相关子查询
select dname
	from dept 
	where deptno not in (select deptno from emp 
	group by deptno having count(empno)>=3)
---不使用exists的相关子查询
select dname from dept
	where (Select count(empno) from emp where
	deptno=dept.deptno )<3
--exists方式
select dname
	from dept
	where exists(select 1 from emp where dept.deptno=emp.deptno
	having count(empno)<3)
---集合运算
select dname
	from dept
	where not exists(
	
	)
--仔细分析查询结果是否符合要求
--假设一个员工的未分配部门
insert into dept values (50,'haha','dailian')
	select * from dept
--查询没有员工的部门,使用not in
select *
	from dept
	where deptno not in (select deptno 
	from emp where deptno is not null)
--使用not exists实现
select *
	from dept 
	where not exists(select 1 from emp
	where dept.deptno=emp.deptno)
--使用外连接实现
SELECT d.*
FROM dept d
LEFT  JOIN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;
--使用集合运算实现
SELECT deptno, dname
FROM dept
EXCEPT
SELECT deptno, dname
FROM dept
WHERE deptno IN (SELECT deptno FROM emp WHERE empno IS NOT NULL)
select 
select 
union 并集(基本运算)
intersect 交集
except(minus) 差集(基本运算)
自动去重
-- 关系除
-- 提供了所有平均工资高于2500的职位的部门
	select *
	from dept
	where not exists(
			select job
			from emp
			group by job
			having avg(sal)>3000
		except
			select job
			from emp
			where deptno=dept.deptno
	)
--综合
-- 查找在具有最低平均工资的部门中工作的员工。
SELECT e.*
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.deptno IN (
    SELECT deptno
    FROM emp
    GROUP BY deptno
    HAVING AVG(sal) = (
        SELECT MIN(avg_sal)
        FROM (
            SELECT deptno, AVG(sal) AS avg_sal
            FROM emp
            GROUP BY deptno
        ) AS avg_sal_subquery
    )
);
-- 提供职位涵盖工资在2000-5000之间所有职位的部门名称
select dname
	from dept 
	where not exists(
		select job 
		from emp
		group by job
		having MIN(sal) >= 2000 AND MAX(sal) <= 5000
	except
		select job
		from emp
		where emp.deptno=dept.deptno
	)
--为了做后续实验复制一个表emp中所有数据
-- 子查询应用 --create
create table emp_05 as 
	select * 
	from emp 
	where sal>2600
insert into emp_05 select * from emp where sal>2600
-- 子查询应用 --dml
-- 计划对于1981年9月之前入职的员工，工资上涨10%，1981年9月之后至1982年9月份之前入职的员工，工资上涨5%。
-- 查询如果这样变化的话工资数值的变化情况
-- 查询结果需要包括员工姓名，入职时间，原工资，计划更新工资。

--综合
--查询与员工"SMITH"部门和职位相同的员工（三种方法，from，元组比较，with，相关子查询）
select e1.ename
	from emp e1 join emp e2 on e2.ename='SMITH' 
	and e1.deptno=e2.deptno and e1.job=e2.job
with e2 as (select * from emp where ename='SMITH')
	
select *
	from emp join e2 on emp.deptno=e2.deptno 
	and emp.job=e2.job 
	
select *
	from emp e1
	where exists(select 1 from emp where ename='SMITH'
	and e1.deptno=deptno and e1.job=job)
--查询部门中至少有一名员工工资超过3000的部门名称（distinct,不相关子查询，相关子查询）

--- 视图
-- 创建视图，提供了所有平均工资高于2500的职位的部门，视图名称为vw_dept_2500
create view vw_dept_3000 as
select *
	from dept
	where not exists(
			select job
			from emp
			group by job
			having avg(sal)>3000
		except
			select job
			from emp
			where deptno=dept.deptno
	)
select * from vw_dept_3000
--扩展 --递归查询-- 对每个部门按照员工领导管理等级显示员工，即每个部门中最高领导首先显示，然后是次级领导，以此类推

--扩展 --窗口函数 --找到每个部门中各个员工的工资高低排名，从高到低排序，输出部门编号，员工编号，姓名，工资，排名排序号

--扩展 --行列转换
-- 查找每种职位在每个部门的人数分布，要求以职位为行标题，以部门名称为列标题

--自行完成学习 --授权管理







