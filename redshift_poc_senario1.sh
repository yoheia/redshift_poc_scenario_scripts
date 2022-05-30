#!/usr/bin/env bash

export LANG=C
BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

export PGBENCH_PATH=pgbench
export PG_HOST=redshift-cluster-poc.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com

# 定期的にシステムビューを S3 に UNLOAD する
nohup ./redshift_polling_unload/polling_unload.sh &

# スループット検証実行
nohup ./redshift_concurrent_query_executer/executer/redshift_concurrent_workload_awsampledb.sh &


exit 0
