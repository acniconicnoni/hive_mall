-- [hive][ads][用户分龄喜好表]ads_user_age_category1_stat_day_f
-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-09
-- ** 功能描述 ：创建用户分龄喜好表
-- **            
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
create table if not exists mall_ads.ads_user_age_category1_stat_day_f(
 sku_category1_id	   string  	  COMMENT '一级品类ID'
,sku_category1_name	   string	  COMMENT '一级品类名'
,age_range	           string	  COMMENT '用户年龄段'
,order_count	       bigint	  COMMENT '订单数 '
,order_amount	       decimal	  COMMENT '订单总金额'
,avg_amount	           decimal	  COMMENT '平均单价'
,cal_month	           string	  COMMENT '统计月份'
,cal_lastdate	       string	  COMMENT '统计截至日期'
)COMMENT '用户购买商品明细表'
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

--从dws层传入数据
insert overwrite table mall_ads.ads_user_age_category1_stat_day_f
select 
 sku_category1_id                           as sku_category1_id 
,sku_category1_name                         as sku_category1_name
,case when user_age >= 0 and user_age <10 then '0-9'
      when user_age >=10 and user_age <20 then '10-19'
      when user_age >=20 and user_age <30 then '20-29'
      when user_age >=30 and user_age <40 then '30-39'
      when user_age >=40 and user_age <50 then '40-49'
      when user_age >=50                  then '50+'
      end                                    as user_age_range
,count(order_count)                          as order_count
,sum(order_amount)                           as order_amount
,sum(order_amount)/count(order_count)        as avg_amount  
,DATE_FORMAT(current_date(),'yyyy-MM')       as cal_month
,DATE_FORMAT(current_date(),'yyyy-MM-dd')    as cal_lastdate
from mall_dws.dws_sale_detail_daycount_f
group by  
 sku_category1_id                         
,sku_category1_name                        
,case when user_age >= 0 and user_age <10 then '0-9'
      when user_age >=10 and user_age <20 then '10-19'
      when user_age >=20 and user_age <30 then '20-29'
      when user_age >=30 and user_age <40 then '30-39'
      when user_age >=40 and user_age <50 then '40-49'
      when user_age >=50                  then '50+'
      end
,DATE_FORMAT(current_date(),'yyyy-MM')
,DATE_FORMAT(current_date(),'yyyy-MM-dd');