-- [hive][dwd][明细层订单明细表]dwd_order_detail_i

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：创建明细层订单明细表，从ods_order_detail中导入数据
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

--创建明细层订单明细表
CREATE TABLE IF NOT EXISTS mall_dwd.dwd_order_detail_i(
  `id`          INT             COMMENT '编号',
  `order_id`    INT             COMMENT '订单编号',
  `sku_id`      INT             COMMENT 'sku_id',
  `sku_name`    VARCHAR(200)    COMMENT 'sku名称（冗余)',
  `img_url`     VARCHAR(200)    COMMENT '图片名称（冗余)',
  `order_price` DECIMAL(10,2)   COMMENT '购买价格(下单时sku价格）',
  `sku_num`     VARCHAR(200)    COMMENT '购买个数',
  `etl_time`    STRING          COMMENT '购买个数'
)COMMENT '订单明细表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

--从ods层导入数据
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
insert overwrite table mall_dwd.dwd_order_detail_i partition(dt)
select distinct 
 id
,order_id
,sku_id
,sku_name
,img_url
,order_price
,sku_num
,from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss') as etl_time
,date_format(current_date(),'yyyy-MM-dd') as dt
from mall_ods.ods_order_detail
where id<>'' or id is not null;