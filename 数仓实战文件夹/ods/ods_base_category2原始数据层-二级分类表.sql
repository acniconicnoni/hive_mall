-- [hive][ods][原始数据层二级分类表]ods_base_category1

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层二级分类表，从MYSQL中导入数据
-- **************************************************************************
-- **************************** 修改日志 *************************************
--
-- **************************************************************************
--    
--
-- **************************************************************************
-- 
--
-- **************************************************************************
--
-- *******************  CURRENT_VERSION ： V.1.1  ***************************
-- **************************************************************************

--创建原始数据层二级分类表
CREATE TABLE IF NOT EXISTS mall_ods.base_category2
(
`id`              INT           COMMENT '编号',
`name`            VARCHAR(200)  COMMENT '二级分类名称',
`category1_id`    INT           COMMENT '一级分类编号'
)COMMENT '二级分类表'
row format delimited fields terminated by ',';

--从MYSQL中导入数据
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table base_category2 \
--target-dir /user/hive/warehouse/mall_ods.db/ods_base_category2 \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \