-- [hive][ods][原始数据层订单明细表]ods_order_detail

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-06
-- ** 功能描述 ：创建原始数据层订单明细表，从MYSQL导入数据
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

--创建原始数据层订单明细表
CREATE TABLE IF NOT EXISTS mall_ods.ods_order_detail(
  `id`          INT             COMMENT '编号',
  `order_id`    INT             COMMENT '订单编号',
  `sku_id`      INT             COMMENT 'sku_id',
  `sku_name`    VARCHAR(200)    COMMENT 'sku名称（冗余)',
  `img_url`     VARCHAR(200)    COMMENT '图片名称（冗余)',
  `order_price` DECIMAL(10,2)   COMMENT '购买价格(下单时sku价格）',
  `sku_num`     VARCHAR(200)    COMMENT '购买个数'
)COMMENT '订单明细表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ',';

--从MYSQL导入数据
sqoop import \
--connect "jdbc:mysql://master:3306/mall?useSSL=false" \
--username root \
--password 123456 \
--table order_detail \
--target-dir /user/hive/warehouse/mall_ods.db/ods_order_detail_tmp \
--fields-terminated-by ',' \
--m 1 \
--delete-target-dir \