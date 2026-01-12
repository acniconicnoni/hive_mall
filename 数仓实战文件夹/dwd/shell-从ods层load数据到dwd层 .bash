-- [hive][dwd][ods清洗导入数据到dwd层]load_dwd.sh
-- ***************************************************************************
-- ** 创建者   : jinx
-- ** 创建日期 : 2026-01-08
-- ** 功能描述 ：从ods_user_info中导入数据脚本，导入id非空的数据，   *********
-- **************并将dwd_user_info_i中的gender字段M改为男，F改为女   *********
-- ***************************************************************************
-- **************************** 修改日志 *************************************
-- **
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
#!/bin/bash
table_name=$1
case $table_name in
"dwd_order_info_i")
hive -f /root/temp/jinx/hive_dwd/load_dwd_order_info_i.sql
;;
"dwd_order_detail_i")
hive -f /root/temp/jinx/hive_dwd/load_dwd_order_detail_i.sql
;;
"dwd_payment_info_i")
hive -f /root/temp/jinx/hive_dwd/load_dwd_payment_info_i.sql
;;
"dwd_sku_info_i")
hive -f /root/temp/jinx/hive_dwd/load_dwd_sku_info_i.sql
;;
"dwd_user_info_i")
hive -f /root/temp/jinx/hive_dwd/load_dwd_user_info_i.sql
;;
"all")
hive -f /root/temp/jinx/hive_dwd/load_dwd_order_info_i.sql
hive -f /root/temp/jinx/hive_dwd/load_dwd_order_detail_i.sql
hive -f /root/temp/jinx/hive_dwd/load_dwd_payment_info_i.sql
hive -f /root/temp/jinx/hive_dwd/load_dwd_sku_info_i.sql
hive -f /root/temp/jinx/hive_dwd/load_dwd_user_info_i.sql
;;
esac