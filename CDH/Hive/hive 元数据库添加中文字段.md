# hive 元数据库添加中文字段

alter table COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;

alter table TABLE_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;

alter table PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;



alter table TBLS modify column `VIEW_EXPANDED_TEXT` mediumtext character set utf8;

alter table TBLS modify column `VIEW_ORIGINAL_TEXT` mediumtext character set utf8;
