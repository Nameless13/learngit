1. 先停  Cloudera Management Service. Actions > Stop.
2. 改log 地址配置
2. sudo service cloudera-scm-server stop
3. parted -s $DEVICE mklabel gpt mkpart primary ext3 0% 100%
4. 改回权限
5. 重启 service cloudera-scm-server start
6. 重启 Cloudera Management Service