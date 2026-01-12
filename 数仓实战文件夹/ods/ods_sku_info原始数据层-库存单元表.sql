-- [hive][ods][原始数据层库存单元表]ods_sku_info

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层库存单元表,从MYSQL中导入数据
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



--创建原始数据层库存单元表
DROP TABLE mall_ods.ods_user_info;
CREATE TABLE IF NOT EXISTS mall_ods.ods_user_info(
  `id`           INT            COMMENT '编号',
  `login_name`   VARCHAR(200)   COMMENT '用户名称',
  `nick_name`    VARCHAR(200)   COMMENT '用户昵称',
  `passwd`       VARCHAR(200)   COMMENT '用户密码',
  `name`         VARCHAR(200)   COMMENT '用户姓名',
  `phone_num`    VARCHAR(200)   COMMENT '手机号',
  `email`        VARCHAR(200)   COMMENT '邮箱',
  `head_img`     VARCHAR(200)   COMMENT '头像',
  `user_level`   VARCHAR(200)   COMMENT '用户级别',
  `birthday`     DATE           COMMENT '用户生日',
  `gender`       VARCHAR(1)     COMMENT '性别 M男,F女',
  `create_time`  STRING         COMMENT '创建时间'
)COMMENT  '原始数据层用户表'
row format delimited fields terminated by ',';

--从MYSQL中导入数据
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table sku_info \
--target-dir /user/hive/warehouse/mall_ods.db/ods_sku_info \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \

