#!/bin/bash
#Mysql表名
table_name = $1
#mysql库名
mysql_db_name = mall
#hive库名
hive_db_name = mall_ods
#接收日期
db_date = $2

if [$3 = "yesterday"]
then
  db_date = date -d "-1 day" +%Y%m%d
else
db_date = $2
fi

#sql语句获取原表数据
#base_category1一级分类表数据
base_category1_sql = "select * from base_category1 where 1=1"
#base_category2二级分类表数据
base_category2_sql = "select * from base_category2 where 1=1"
#base_category3三级分类表数据
base_category3_sql = "select * from base_category3 where 1=1"
#order_detail订单明细表数据
order_detail_sql = "select * from order_detail where 1=1"
#order_info订单表数据
order_info_sql = "select * from order_info where 1=1;"
#payment_info支付流水表数据
payment_info_sql = "select * from payment_info where 1=1;"
#sku_info库存单元表数据
sku_info_sql = "select * from sku_info where 1=1;"
#user_info用户表数据
user_info_sql = "select * from user_info where 1=1;"

#mysql本地数据导入hive指定目录文件
#$1 需要导入数据的表名
#$2 调用的sql语句，用于查询表中数据
function import_data() {
sqoop import \
--connect jdbc:mysql://master:3306/$mysql_db_name \
--username root \
--password 123456 \
--target-dir /jinx/$hive_db_name/$1/$db_date \
--delete-target-di \
--num-mappers 1 \
--fields-terminated-by "," \
--query "$2"' and $CONDITIONS;'
}

#调用import_data函数导入数据 函数内参数$1是表名，$2是
case $table_name in 
"base_category1")
import_data "base_category1" "$base_category1_sql"
;;
"base_category2")
import_data "base_category2" "$base_category2_sql"
;;
"base_category3")
import_data "base_category3" "$base_category3_sql"
;;
"order_detail")
import_data "order_detail" "$order_detail_sql"
;;
"order_info")
import_data "order_info" "$order_info_sql"
;;
"payment_info")
import_data "payment_info" "$payment_info_sql"
;;
"sku_info")
import_data "sku_info" "$sku_info_sql"
;;
"payment_info")
import_data "user_info" "$user_info_sql"
;;
"all")
import_data "base_category1" "$base_category1_sql"
import_data "base_category2" "$base_category2_sql"
import_data "base_category3" "$base_category3_sql"
import_data "order_detail" "$order_detail_sql"
import_data "order_info" "$order_info_sql"
import_data "payment_info" "$payment_info_sql"
import_data "sku_info" "$sku_info_sql"
import_data "user_info" "$user_info_sql"
;;
esac