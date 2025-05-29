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
