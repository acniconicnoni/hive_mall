-- [hive][dws][数据汇总层用户购买商品明细表]dws_sale_detail_daycount	
-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-09
-- ** 功能描述 ：创建用户购买商品明细表，从dwd_order_info_i,dwd_order_detail_i
-- **            dwd_user_info_i,dwd_sku_info_i中导入数据
-- **
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

--创建用户购买商品明细表
create table if not exists dws_sale_detail_daycount_f(
user_id		          string    COMMENT'用户id'
,create_time		  string    COMMENT'日期'
,sku_id	              string    COMMENT'商品id'
,user_gender	      string    COMMENT'用户性别'
,user_age		      string    COMMENT'用户年龄'
,user_level		      string    COMMENT'用户等级'
,sku_price		      decimal   COMMENT'sku价格'
,sku_name		      string    COMMENT'商品名称'
,sku_tm_id		      string    COMMENT'品牌id'
,sku_category3_id	  string    COMMENT'商品三级品类id'
,sku_category2_id	  string    COMMENT'商品二级品类id'
,sku_category1_id	  string    COMMENT'商品一级品类id'
,sku_category3_name	  string    COMMENT'商品三级品类名称'
,sku_category2_name	  string    COMMENT'商品二级品类名称'
,sku_category1_name	  string    COMMENT'商品一级品类名称'
,spu id		          string    COMMENT'商品spu_id'
,sku_num		      bigint    COMMENT'购买个数'
,order_count		  bigint    COMMENT'当日下单单数'
,order_amount		  decimal   COMMENT'当日下单金额'
)comment '用户购买商品明细表'
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");


--从dwd层导入数据
insert overwrite table mall_dws.dws_sale_detail_daycount_f
select
 oi.user_id                                                as user_id
,DATE_FORMAT(oi.create_time,'yyyy-MM-dd')                  as create_time
,sku.id                                                    as sku_id
,ui.gender                                                 as user_gender
,floor(MONTHS_BETWEEN(current_date,ui.birthday)/12)        as user_age
,ui.user_level                                             as user_level
,sku.price                                                 as sku_price
,sku.sku_name                                              as sku_name
,sku.tm_id                                                 as sku_tm_id
,sku.category3_id                                          as sku_category3_id
,sku.category2_id                                          as sku_category2_id
,sku.category1_id                                          as sku_category1_id
,sku.category3_name                                        as sku_category3_name
,sku.category2_name                                        as sku_category2_name
,sku.category1_name                                        as sku_category1_name
,sku.spu_id                                                as spu_id
,sum(od.sku_num)                                           as sku_num
,count(od.order_id)                                        as order_count
,sum(od.order_price*od.sku_num)                            as order_amount
from      mall_dwd.dwd_user_info_i  ui 
left join mall_dwd.dwd_order_info_i oi    on ui.id  = oi.user_id
left join mall_dwd.dwd_order_detail_i od  on oi.id  = od.order_id
left join mall_dwd.dwd_sku_info_i  sku    on sku.id = od.sku_id
group by 
 oi.user_id                                               
,DATE_FORMAT(oi.create_time,'yyyy-MM-dd')                                            
,sku.id                                                
,ui.gender                                                  
,MONTHS_BETWEEN(current_date,ui.birthday)/12 
,ui.user_level                                             
,sku.price                                                 
,sku.sku_name                                              
,sku.tm_id                                                
,sku.category3_id                                        
,sku.category2_id                                        
,sku.category1_id                                          
,sku.category3_name                                      
,sku.category2_name                                      
,sku.category1_name                                        
,sku.spu_id
; 
                                          



