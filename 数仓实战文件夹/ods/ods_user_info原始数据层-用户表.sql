-- [hive][ods][原始数据层用户表]ods_user_info

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层用户表,从MYSQL导入数据
-- **************************************************************************
-- **************************** 修改日志 *************************************
--
-- **************************************************************************
--    
--
-- **************************************************************************
-- **************************** 遇到的问题 *************************************
-- **问题日期：2026-01-07
-- **问题描述：导入数据时，create_time接受不到数据。
-- **解决方法：将create_time数据类型从date改为string类型，hive中date类型数据接受
-- **          不到年月日时分秒的数据。
-- **************************************************************************
--
-- *******************  CURRENT_VERSION ： V.1.1  ***************************
-- **************************************************************************

--创建原始数据层用户表
CREATE TABLE IF NOT EXISTS mall_ods.ods_user_info (
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


--从MYSQL导入数据
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table user_info \
--target-dir /user/hive/warehouse/mall_ods.db/ods_user_info \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \