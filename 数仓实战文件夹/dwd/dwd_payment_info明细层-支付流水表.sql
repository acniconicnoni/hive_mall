-- [hive][dwd][明细层支付流水表]dwd_dwd_payment_info_i

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：创建明细层支付流水表，从ods_payment_info中导入数据
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

--创建明细层支付流水表
CREATE TABLE IF NOT EXISTS mall_dwd.dwd_payment_info(
`id`              INT            COMMENT '编号',
`out_trade_no`    VARCHAR(20)    COMMENT '对外业务编号',
`order_id`        VARCHAR(20)    COMMENT '订单编号',
`user_id`         VARCHAR(20)    COMMENT '用户编号',
`alipay_trade_no` VARCHAR(20)    COMMENT '支付宝交易流水编号',
`total_amount`    DECIMAL(16,2)  COMMENT '支付金额',
`subject`         VARCHAR(20)    COMMENT '交易内容',
`payment_type`    VARCHAR(20)    COMMENT '支付方式',
`payment_time`    VARCHAR(20)    COMMENT '支付时间',
`etl_time`        STRING         COMMENT '清洗时间'
)COMMENT '支付流水表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

--从ods层导入数据
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
insert overwrite table mall_dwd.dwd_payment_info_i partition(dt)
select distinct 
 id
,out_trade_no
,order_id
,user_id
,alipay_trade_no
,total_amount
,subject
,payment_type
,payment_time
,from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss') as etl_time
,date_format(current_date(),'yyyy-MM-dd') as dt
from mall_ods.ods_payment_info
where id<>'' or id is not null;