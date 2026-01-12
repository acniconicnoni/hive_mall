-- [hive][dwd][明细层用户表]dwd_user_info_i

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：创建明细层用户表，从ods_user_info中导入数据
-- **************************************************************************
-- **************************** 修改日志 *************************************
-- **修改gender数据类型varchar(1) 到string,varchar(1)长度不够接收不到汉字
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

--创建明细层用户表
CREATE TABLE IF NOT EXISTS mall_dwd.dwd_user_info_i(
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
  `gender`       STRING         COMMENT '性别 M男,F女',
  `create_time`  STRING         COMMENT '创建时间',
  `etl_time`     STRING         COMMENT '清洗时间'
)COMMENT  '明细层用户表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

--从ods层导入数据
--load_dwd_user_info_i.sql
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
insert overwrite table mall_dwd.dwd_user_info_i partition(dt)
select distinct 
 id
,login_name
,nick_name
,passwd
,name
,phone_num
,email
,head_img
,user_level
,birthday
,case when gender='F' then '女'
      when gender='M' then '男' end as gender
,date_format(create_time,'yyyy-MM-dd HH:mm:ss') as create_time
,from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss') as etl_time
,date_format(current_date(),'yyyy-MM-dd') as dt
from mall_ods.ods_user_info sku
where id<>'' or id is not null;