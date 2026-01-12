#!/bin/bash
ods_table_name=$1
hive_db_name=mall_ods

if [ $2 = "yesterday" ]
then
 db_date= `date -d "-1 day" +%F`
else
  db_date=$2
fi
#从HDFS目录中load数据进目标
case $ods_table_name in
 "ods_base_category1")
 hive -e "load data inpath '/jinx/mall_ods/base_category1/2026-01-07' overwrite into table mall_ods.ods_base_category1;"
 ;;
 "ods_base_category2")
 hive -e "load data inpath '/jinx/mall_ods/base_category2/2026-01-07' overwrite into table mall_ods.ods_base_category2;"
 ;;
 "ods_base_category3")
 hive -e "load data inpath '/jinx/mall_ods/base_category3/2026-01-07' overwrite into table mall_ods.ods_base_category3;"
 ;;
 "ods_sku_info")
 hive -e "load data inpath '/jinx/mall_ods/sku_info/2026-01-07' overwrite into table mall_ods.ods_sku_info;"
 ;;
 "ods_user_info")
 hive -e "load data inpath '/jinx/mall_ods/user_info/2026-01-07' overwrite into table mall_ods.ods_user_info;"
 ;;
 "ods_order_info")
 hive -e "load data inpath '/jinx/mall_ods/order_info/2026-01-07' overwrite into table mall_ods.ods_order_info partition(dt='$db_date');"
 ;;
 "ods_order_detail")
 hive -e "load data inpath '/jinx/mall_ods/order_detail/2026-01-07' overwrite into  table mall_ods.ods_order_detail partition(dt='$db_date');"
 ;;
"ods_payment_info")
 hive -e "load data inpath '/jinx/mall_ods/payment_info/2026-01-07' overwrite into  table mall_ods.ods_payment_info partition(dt='$db_date');"
 ;;
 "all")
 hive -e "load data inpath '/jinx/mall_ods/base_category1/2026-01-07' overwrite into table mall_ods.ods_base_category1;
		  load data inpath '/jinx/mall_ods/base_category2/2026-01-07' overwrite into  table mall_ods.ods_base_category2;
		  load data inpath '/jinx/mall_ods/base_category3/2026-01-07' overwrite into table mall_ods.ods_base_category3;
		  load data inpath '/jinx/mall_ods/sku_info/2026-01-07' overwrite into table mall_ods.ods_sku_info;
		  load data inpath '/jinx/mall_ods/user_info/2026-01-07' overwrite into table mall_ods.ods_user_info;
		  load data inpath '/jinx/mall_ods/order_info/2026-01-07' overwrite into table mall_ods.ods_order_info partition(dt='$db_date');
		  load data inpath '/jinx/mall_ods/order_detail/2026-01-07' overwrite into table mall_ods.ods_order_detail partition(dt='$db_date');
		  load data inpath '/jinx/mall_ods/payment_info/2026-01-07' overwrite into table mall_ods.ods_payment_info partition(dt='$db_date');"
;;
esac
