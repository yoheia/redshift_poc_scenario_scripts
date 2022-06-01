#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y%m%d%_H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
LOG_DIR=${LOG_DIR:-log}
cd $BASE_DIR

PGBENCH_PATH=${PGBENCH_PATH:-/usr/pgsql-13/bin/pgbench}
export PG_HOST=redshift-cluster-poc.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

# 定期的にシステムビューを S3 に UNLOAD する
nohup ../redshift_query_executer/redshift_query_executer.sh \
    > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1 &

# スループット検証実行
nohup ../redshift_concurrent_query_executer/executer/redshift_concurrent_workload_awsampledb.sh \
    > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1 &


exit 0
