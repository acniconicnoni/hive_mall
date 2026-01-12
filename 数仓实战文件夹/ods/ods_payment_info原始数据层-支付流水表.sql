-- [hive][ods][原始数据层支付流水表]ods_payment_info

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层支付流水表，从MYSQL导入数据
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

--创建原始数据层支付流水表
CREATE TABLE IF NOT EXISTS mall_ods.ods_payment_info(
`id`              INT            COMMENT '编号',
`out_trade_no`    VARCHAR(20)    COMMENT '对外业务编号',
`order_id`        VARCHAR(20)    COMMENT '订单编号',
`user_id`         VARCHAR(20)    COMMENT '用户编号',
`alipay_trade_no` VARCHAR(20)    COMMENT '支付宝交易流水编号',
`total_amount`    DECIMAL(16,2)  COMMENT '支付金额',
`subject`         VARCHAR(20)    COMMENT '交易内容',
`payment_type`    VARCHAR(20)    COMMENT '支付方式',
`payment_time`    VARCHAR(20)    COMMENT '支付时间'
)COMMENT '支付流水表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ',';


--从MYSQL导入数据
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table payment_info \
--target-dir /user/hive/warehouse/mall_ods.db/ods_payment_info_tmp \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \

