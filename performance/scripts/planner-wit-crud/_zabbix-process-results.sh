#!/bin/bash

source _setenv.sh

export ZABBIX_LOG=$1
export ZABBIX_TIMESTAMP=`date +%s`

./__zabbix-process-load.sh '"GET","api-spaces"' "api-spaces" >> $ZABBIX_LOG
./__zabbix-process-load.sh '"POST","api-space-create"' "api-space-create" >> $ZABBIX_LOG
./__zabbix-process-load.sh '"POST","api-workitem-create"' "api-workitem-create" >> $ZABBIX_LOG
./__zabbix-process-load.sh '"GET","api-workitem-by-id"' "api-workitem-by-id" >> $ZABBIX_LOG
./__zabbix-process-load.sh '"PATCH","api-workitem-update"' "api-workitem-update" >> $ZABBIX_LOG
./__zabbix-process-load.sh '"DELETE","api-space-delete"' "api-space-delete" >> $ZABBIX_LOG