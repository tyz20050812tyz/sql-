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
--inner join
select emp.ename,dept.dname
	from emp left join dept 
	on emp.deptno=dept.deptno;
