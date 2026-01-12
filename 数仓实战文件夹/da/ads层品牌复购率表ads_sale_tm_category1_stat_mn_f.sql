-- [hive][ads][品牌复购率表]ads_sale_tm_category1_stat_mn_f
-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-09
-- ** 功能描述 ：创建品牌复购率表
-- **            
-- **
-- **************************************************************************
-- **************************** 修改日志 *************************************
--
-- **************************************************************************
-- 依赖表：mall_tmp.buycount,mall_tmp.twice,mall_tmp.3times
--
-- **************************************************************************
-- 
--
-- **************************************************************************
--
-- *******************  CURRENT_VERSION ： V.1.1  ***************************
-- **************************************************************************

--创建用户购买商品明细表
create table if not exists mall_ads.ads_sale_tm_category1_stat_mn_f(
 tm_id	                  string	              COMMENT '品牌id'
,category1_id	          string	              COMMENT '1级品类id'
,category1_name	          string	              COMMENT '1级品类名称'
,buycount	              bigint	              COMMENT '购买人数'
,buy_twice_last    	      bigint	              COMMENT '两次以上购买人数'
,buy_twice_last_ratio	  decimal(16,2)	          COMMENT '单次复购率'
,buy_3times_last	      bigint	              COMMENT '三次以上购买人数'
,buy_3times_last_ratio	  decimal(16,2)	          COMMENT '多次复购率'
,stat_mn	              string	              COMMENT '统计月份'
,stat_date	              string	              COMMENT '汇总日期'
)COMMENT '品牌复购率表'
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

--插入数据
insert overwrite table mall_ads.ads_sale_tm_category1_stat_mn_f
select 
 t1.sku_tm_id                             as tm_id
,t1.sku_category1_id                      as category1_id
,t2.sku_category1_name                    as category1_name
,t1.buycount                              as buycount
,nvl(t2.buy_twice_last,0)                 as buy_twice_last 
,nvl(t2.buy_twice_last,0) /t1.buycount    as buy_twice_last_ratio
,nvl(t3.buy_3times_last,0)                as buy_3times_last
,nvl(t3.buy_3times_last,0) /t1.buycount   as buy_3times_last_ratio
,date_format(current_date(),'yyyy-MM')    as stat_mn
,date_format(current_date(),'yyyy-MM-dd') as stat_date
from mall_tmp.buycount t1
left join mall_tmp.twice t2 on t1.sku_tm_id = t2.sku_tm_id and t1.sku_category1_id = t2.sku_category1_id
left join mall_tmp.3times t3 on t1.sku_tm_id = t3.sku_tm_id and t1.sku_category1_id = t3.sku_category1_id
;