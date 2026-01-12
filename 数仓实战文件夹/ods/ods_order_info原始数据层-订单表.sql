-- [hive][ods][原始数据层订单表]ods_order_info

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层订单表，从MYSQL导入数据
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


--创建原始数据层订单表
DROP TABLE mall_ods.ods_order_info;
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
CREATE TABLE IF NOT EXISTS mall_ods.ods_order_info(
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
  `img_url`          VARCHAR(200)    COMMENT '图片路径'
) COMMENT '订单表'
partitioned by (dt string comment '日期分区')
row format delimited fields terminated by ',';

--从MYSQL导入数据,先导入到临时表中，再从临时表加入
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table order_detail \
--target-dir /user/hive/warehouse/mall_ods.db/ods_order_detail_tmp \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \

--从临时表中插入订单表
insert overwrite table mall_ods.ods_order_info partition(dt)
select *,DATE_FORMAT(create_time,'yyyy-MM')as dt from mall_ods.ods_order_info_tmp;
