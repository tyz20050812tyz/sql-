
# SQL 学习第一天总结
## 一、学习内容概述
今天我学习了 SQL 中 SELECT 语句的基础知识，包括其核心要点、语法顺序以及运算逻辑顺序，并通过实际示例掌握了如何查询数据以及不同类型的表连接查询方法。
## 二、详细知识点总结
### SELECT 语句核心要点:

不区分大小写 ：SQL 语句中的关键字如 SELECT、FROM 等，不区分大小写，编写时可根据喜好选择，但为了提高代码可读性，通常会采用大写形式。

语法顺序固定 ：在书写 SELECT 语句时，必须按照特定的语法顺序，依次为 SELECT、FROM、WHERE、GROUP BY、HAVING、ORDER BY、LIMIT 等子句，虽然不一定全部使用，但顺序不能颠倒。

运算逻辑顺序 ：SQL 查询的运算逻辑顺序为 FROM、WHERE、GROUP BY、HAVING、SELECT、ORDER BY、LIMIT，了解这一顺序有助于正确理解查询结果的生成过程。

输入输出都是表 ：SELECT 语句的输入可以是表或视图等，经过查询处理后，输出的结果也是一个逻辑上的表，方便后续进一步操作。

可以存在重复 ：查询结果中可能会包含重复的行，若要避免重复，可使用 DISTINCT 关键字。

### FROM 子句
FROM 子句用于指定查询数据的来源表，在简单查询中至少需要一个表，从该表中获取数据进行后续处理。

### 基本查询示例
查询 dept 表中的部门编号（deptno）、部门名称（dname）和部门地点（loc）信息，通过 select dname, deptno, loc from dept 来实现，这是 SELECT 语句最基础的应用，直接从指定表中提取所需的列数据。
表连接查询

笛卡尔积 + 过滤 ：通过 emp 和 dept 两个表的笛卡尔积，再利用 where 子句 emp.deptno = dept.deptno 进行过滤，从而得到员工姓名（ename）及其所属部门名称（dname）的匹配结果，这是早期实现表连接的一种方式，但存在性能和可读性方面的不足。

JOIN 连接 ：使用 emp join dept on emp.deptno = dept.deptno，明确指定了连接条件，以更直观和高效的方式查询员工姓名和对应的部门名称，JOIN 连接是现代 SQL 中常用且推荐的表连接方式。

NATURAL JOIN 自然连接 ：emp natural join dept 会自动根据同名列（前提是两个表有同名且数据类型兼容的列）来连接，无需显式指定连接条件，但要注意可能出现的意外连接结果，因为它依赖于列名的匹配。

LEFT JOIN 左连接 ： emp left join dept on emp.deptno = dept.deptno 用于查询员工信息，并保留 emp 表中所有的行，即使 dept 表中没有匹配的行，结果中 dept 表对应的列会显示为 null，这有助于获取完整的结果集，尤其在需要包含所有左侧表记录时非常有用。
