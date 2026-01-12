-- [hive][dwd][明细层订单表]dwd_order_info_i

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：创建明细层订单表，从ods_order_info中导入数据
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

--创建明细层订单表
CREATE TABLE IF NOT EXISTS mall_dwd.dwd_order_info_i(
  `id`               INT             COMMENT '编号',
  `consignee`        VARCHAR(100)    COMMENT '收货人',
  `consignee_tel`    VARCHAR(20)     COMMENT '收件人电话',
  `total_amount`     DECIMAL(10,2)   COMMENT '总金额',
  `order_status`     VARCHAR(20)     COMMENT '订单状态',
  `user_id`          INT             COMMENT '用户id',
  `payment_way`      VARCHAR(20)     COMMENT '付款方式',
  `delivery_address` VARCHAR(1000)   COMMENT '送货地址',
  `order_comment`    VARCHAR(200)    COMMENT '订单备注',
  `out_trade_no`     VARCHAR(50)     COMMENT '订单交易编号（第三方支付用)',
  `trade_body`       VARCHAR(200)    COMMENT '订单描述(第三方支付用)',
  `create_time`      STRING          COMMENT '创建时间',
  `operate_time`     STRING          COMMENT '操作时间',
  `expire_time`      STRING          COMMENT '失效时间',
  `tracking_no`      VARCHAR(100)    COMMENT '物流单编号',
  `parent_order_id`  INT             COMMENT '父订单编号',
  `img_url`          VARCHAR(200)    COMMENT '图片路径',
  `etl_time`         STRING          COMMENT '清洗时间'
) COMMENT 'dwd订单表'
partitioned by (dt string comment '日期分区')
row format delimited fields terminated by ','
stored as orc tblproperties ("orc.compress"="SNAPPY");

--从ods表中导入数据
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
insert overwrite table mall_dwd.dwd_order_info_i partition(dt)
select distinct 
 id
,consignee
,consignee_tel
,total_amount
,order_status
,user_id
,payment_way
,delivery_address
,order_comment
,out_trade_no
,trade_body
,date_format(create_time,'yyyy-MM-dd HH:mm:ss') as create_time
,date_format(operate_time,'yyyy-MM-dd HH:mm:ss') as operate_time
,date_format(expire_time,'yyyy-MM-dd HH:mm:ss') as expire_time
,tracking_no
,parent_order_id
,img_url
,from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss') as etl_time
,date_format(current_date(),'yyyy-MM-dd') as dt
from mall_ods.ods_order_info
where id<>'' or id is not null;