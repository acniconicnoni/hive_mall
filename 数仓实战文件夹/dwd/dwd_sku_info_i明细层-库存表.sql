-- [hive][dwd][明细层库存表]dwd_sku_info_i

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：创建明细层库存表，从ods_sku_info,ods_base_category3,
-- **            ods_base_category2,ods_base_category1中导入数据
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

--创建明细层库存表

CREATE TABLE IF NOT EXISTS mall_dwd.dwd_sku_info_i(
  `id`               INT             COMMENT '库存id(itemID)',
  `spu_id`           INT             COMMENT '商品id',
  `price`            DECIMAL(10,0)   COMMENT '价格',
  `sku_name`         VARCHAR(200)    COMMENT 'sku名称',
  `sku_desc`         VARCHAR(2000)   COMMENT '商品规格描述',
  `weight`           DECIMAL(10,2)   COMMENT '重量',
  `tm_id`            INT             COMMENT '品牌(冗余)', 
  `category3_id`     INT             COMMENT '三级分类id（冗余)',
  `category3_name`   STRING          COMMENT '三级分类name（冗余)',
  `category2_id`     INT             COMMENT '二级分类id（冗余)',
  `category2_name`   STRING          COMMENT '二级分类name（冗余)',
  `category1_id`     INT             COMMENT '一级分类id（冗余)',
  `category1_name`   STRING          COMMENT '一级分类name（冗余)',
  `sku_default_img`  VARCHAR(200)    COMMENT '默认显示图片(冗余)',
  `create_time`      STRING          COMMENT '创建时间',
  `etl_time`         STRING          COMMENT '清洗时间'
)COMMENT '明细层库存单元表'
partitioned by (dt string COMMENT '日期分区')
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");


--从ods层导入数据
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
insert overwrite table mall_dwd.dwd_sku_info_i partition(dt)
select distinct 
 sku.id
,spu_id
,price
,sku_name
,sku_desc
,weight
,tm_id
,b3.id as category3_id
,b3.name as category3_name
,b2.id as category2_id
,b2.name as category2_name
,b1.id as category1_id
,b1.name as category1_name
,sku_default_img
,date_format(create_time,'yyyy-MM-dd HH:mm:ss') as create_time
,from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss') as etl_time
,date_format(current_date(),'yyyy-MM-dd') as dt
from mall_ods.ods_sku_info sku
left join mall_ods.ods_base_category3 b3 on sku.category3_id=b3.id
left join mall_ods.ods_base_category2 b2 on  b3.category2_id=b2.id
left join mall_ods.ods_base_category1 b1 on  b2.category1_id=b1.id
where sku.id<>'' or sku.id is not null;
