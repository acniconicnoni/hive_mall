-- [hive][tmp][品牌复购率依赖临时表]mall_tmp.buycount，mall_tmp.twice,mall_tmp.3times
-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-09
-- ** 功能描述 ：创建品牌复购率依赖临时表
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

--mall_tmp.buycount
drop table if  exists mall_tmp.buycount;
create table if not exists mall_tmp.buycount(
sku_tm_id         string,
sku_category1_id  string,
buycount          int
)
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

select * from mall_tmp.buycount;

insert overwrite table mall_tmp.buycount
select sku_tm_id,sku_category1_id,count(DISTINCT user_id) as buy_count
from mall_dws.dws_sale_detail_daycount_f
group by sku_tm_id,sku_category1_id;


--mall_tmp.twice
drop table if exists mall_tmp.twice;
create table if not exists mall_tmp.twice(
sku_tm_id         string,
sku_category1_id  string,
sku_category1_name string,
buy_twice_last    int
)
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");


insert overwrite table mall_tmp.twice
select sku_tm_id,sku_category1_id,sku_category1_name,nvl(count(user_id),0) as  buy_twice_last
from 
(select sku_tm_id,sku_category1_id,sku_category1_name,user_id,count(user_id)
			from mall_dws.dws_sale_detail_daycount_f
			group by sku_tm_id,sku_category1_id,sku_category1_name,user_id
		    having count(user_id)>=2)a
group by sku_tm_id,sku_category1_id,sku_category1_name;

--mall_tmp.3times
drop table if exists mall_tmp.3times;
create table if not exists mall_tmp.3times(
sku_tm_id         string,
sku_category1_id  string,
buy_3times_last    int
)
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");

select  * from mall_tmp.3times;

insert overwrite table mall_tmp.3times
select sku_tm_id,sku_category1_id,nvl(count(user_id),0) as  buy_3times_last
from 
(select sku_tm_id,sku_category1_id,user_id,count(user_id)
			from mall_dws.dws_sale_detail_daycount_f
			group by sku_tm_id,sku_category1_id,user_id
		    having count(user_id)>=3)a
group by sku_tm_id,sku_category1_id;