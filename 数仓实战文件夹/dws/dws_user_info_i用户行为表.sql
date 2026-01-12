-- [hive][dws][数据汇总层用户行为表]dws_user_action_f

-- **************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-09
-- ** 功能描述 ：创建数据汇总用户行为表，从dwd_user_info_i,dwd_order_info_i
-- **            dwd_payment_info_i ,dim_date中导入数据
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


--创建数据汇总用户行为表，从dwd_user_info_i
create table if not exists mall_dws.dws_user_action_f(
user_id             bigint      COMMENT '用户ID',
order_date          string      COMMENT '日期',
order_count         bigint      COMMENT '订单数',
order_amount        decimal     COMMENT '订单金额',
payment_count       bigint      COMMENT '支付单数',
payment_amount      decimal     COMMENT '支付金额'
)comment '用户行为表'
row format delimited fields terminated by ','
stored as orc
tblproperties ("orc.compress"="SNAPPY");



--插入数据语句
insert overwrite table mall_dws.dws_user_action_f
select 
 ui.id                         as user_id
,dd.date_full                  as order_date
,count(oi.id)                  as order_count
,sum(nvl(oi.total_amount,0))   as order_amount
,count(`pi`.id)                as payment_count
,sum(nvl(`pi`.total_amount,0)) as payment_amount
from  
mall.dim_date dd 
left join mall_dwd.dwd_user_info_i ui  on 1=1
left join mall_dwd.dwd_order_info_i oi on ui.id=oi.user_id and dd.date_full=date_format(oi.create_time,'yyyy-MM-dd')
left join mall_dwd.dwd_payment_info_i `pi` on ui.id=`pi`.user_id and dd.date_full = date_format(`pi`.payment_time,'yyyy-MM-dd')
group by ui.id,dd.date_full;
