#!/bin/bash
source _setenv.sh

export COMMON="../_common"

if [ "$RUN_LOCALLY" == "true" ]; then
	echo " (Re)start the server"
	./_stop-server.sh
	./_start-server.sh
fi

echo " Wait for the server to become available"
./_wait-for-server.sh
if [ $? -gt 0 ]; then
	exit 1
fi

echo " Login users and get auth tokens"
rm -rf $TOKENS_FILE
./_generate-auth-tokens.sh $TOKENS_FILE

echo "#!/bin/bash
export USER_TOKENS=\"`cat $TOKENS_FILE`\"
" > $ENV_FILE-master;

echo " Prepare locustfile template"
./_prepare-locustfile.sh planner-wit-crud.py

echo " Shut any possible Locust master down"
$COMMON/__stop-locust-master-standalone.sh
echo " Run Locust locally"
$COMMON/__start-locust-master-standalone.sh

echo " Run test for $DURATION seconds"
sleep $DURATION

$COMMON/__stop-locust-master-standalone.sh TERM

echo " Extract CSV data from logs"
$COMMON/_locust-log-to-csv.sh 'GET api-spaces' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
$COMMON/_locust-log-to-csv.sh 'POST api-space-create' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
$COMMON/_locust-log-to-csv.sh 'POST api-workitem-create' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
$COMMON/_locust-log-to-csv.sh 'GET api-workitem-by-id' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
$COMMON/_locust-log-to-csv.sh 'PATCH api-workitem-update' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
$COMMON/_locust-log-to-csv.sh 'DELETE api-space-delete' $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log

echo " Generate charts from CSV"
export REPORT_CHART_WIDTH=1000
export REPORT_CHART_HEIGHT=600
for c in $(find *.csv | grep '\-POST_\+\|\-GET_\+\|\-PATCH_\+\|\-DELETE_\+'); do echo $c; $COMMON/_csv-response-time-to-png.sh $c; $COMMON/_csv-throughput-to-png.sh $c; $COMMON/_csv-failures-to-png.sh $c; done
function distribution_2_csv {
	HEAD=(`cat $1 | head -n 1 | sed -e 's,",,g' | sed -e 's, ,_,g' | sed -e 's,%,,g' | tr "," " "`)
	DATA=(`cat $1 | grep -F "$2" | sed -e 's,",,g' | sed -e 's, ,_,g' | tr "," " "`)
	NAME=`echo $1 | sed -e 's,-report_distribution,,g' | sed -e 's,\.csv,,g'`-`echo "$2" | sed -e 's,",,g' | sed -e 's, ,_,g;'`

	rm -rf $NAME-rt-histo.csv;
	for i in $(seq 2 $(( ${#HEAD[*]} - 1 )) ); do
		echo "${HEAD[$i]};${DATA[$i]}" >> $NAME-rt-histo.csv;
	done;
}
for c in $(find *.csv | grep '\-report_distribution.csv'); do
	distribution_2_csv $c '"GET api-spaces"';
	distribution_2_csv $c '"POST api-space-create"';
	distribution_2_csv $c '"POST api-workitem-create"';
	distribution_2_csv $c '"GET api-workitem-by-id"';
	distribution_2_csv $c '"PATCH api-workitem-update"';
	distribution_2_csv $c '"DELETE api-space-delete"';
done
for c in $(find *rt-histo.csv); do echo $c; $COMMON/_csv-rt-histogram-to-png.sh $c; done

echo " Prepare results for Zabbix"
rm -rvf *-zabbix.log
export ZABBIX_LOG=$JOB_BASE_NAME-$BUILD_NUMBER-zabbix.log
./_zabbix-process-results.sh $ZABBIX_LOG

if [[ "$ZABBIX_REPORT_ENABLED" = "true" ]]; then
	echo "  Uploading report to zabbix...";
	zabbix_sender -vv -i $ZABBIX_LOG -T -z $ZABBIX_SERVER -p $ZABBIX_PORT;
fi

RESULTS_FILE=$JOB_BASE_NAME-$BUILD_NUMBER-results.md
sed -e "s,@@JOB_BASE_NAME@@,$JOB_BASE_NAME,g" results-template.md |
sed -e "s,@@BUILD_NUMBER@@,$BUILD_NUMBER,g" > $RESULTS_FILE

# Create HTML report
function filterZabbixValue {
   VALUE=`cat $1 | grep $2 | head -n 1 | cut -d " " -f 4`
   sed -i -e "s,$3,$VALUE,g" $4
}
filterZabbixValue $ZABBIX_LOG "api-spaces-rt_min" "@@API_SPACES_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-spaces-rt_median" "@@API_SPACES_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-spaces-rt_max" "@@API_SPACES_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-spaces-rt_average" "@@API_SPACES_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-spaces-failed" "@@API_SPACES_FAILED@@" $RESULTS_FILE;

filterZabbixValue $ZABBIX_LOG "api-space-create-rt_min" "@@API_SPACE_CREATE_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-create-rt_median" "@@API_SPACE_CREATE_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-create-rt_max" "@@API_SPACE_CREATE_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-create-rt_average" "@@API_SPACE_CREATE_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-create-failed" "@@API_SPACE_CREATE_FAILED@@" $RESULTS_FILE;

filterZabbixValue $ZABBIX_LOG "api-workitem-create-rt_min" "@@API_WORKITEM_CREATE_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-create-rt_median" "@@API_WORKITEM_CREATE_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-create-rt_max" "@@API_WORKITEM_CREATE_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-create-rt_average" "@@API_WORKITEM_CREATE_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-create-failed" "@@API_WORKITEM_CREATE_FAILED@@" $RESULTS_FILE;

filterZabbixValue $ZABBIX_LOG "api-workitem-by-id-rt_min" "@@API_WORKITEM_BY_ID_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-by-id-rt_median" "@@API_WORKITEM_BY_ID_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-by-id-rt_max" "@@API_WORKITEM_BY_ID_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-by-id-rt_average" "@@API_WORKITEM_BY_ID_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-by-id-failed" "@@API_WORKITEM_BY_ID_FAILED@@" $RESULTS_FILE;

filterZabbixValue $ZABBIX_LOG "api-workitem-update-rt_min" "@@API_WORKITEM_UPDATE_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-update-rt_median" "@@API_WORKITEM_UPDATE_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-update-rt_max" "@@API_WORKITEM_UPDATE_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-update-rt_average" "@@API_WORKITEM_UPDATE_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-workitem-update-failed" "@@API_WORKITEM_UPDATE_FAILED@@" $RESULTS_FILE;

filterZabbixValue $ZABBIX_LOG "api-space-delete-rt_min" "@@API_SPACE_DELETE_MIN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-delete-rt_median" "@@API_SPACE_DELETE_MEDIAN@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-delete-rt_max" "@@API_SPACE_DELETE_MAX@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-delete-rt_average" "@@API_SPACE_DELETE_AVERAGE@@" $RESULTS_FILE;
filterZabbixValue $ZABBIX_LOG "api-space-delete-failed" "@@API_SPACE_DELETE_FAILED@@" $RESULTS_FILE;

REPORT_TIMESTAMP=`date '+%Y-%m-%d %H:%M:%S (%Z)'`
sed -i -e "s,@@TIMESTAMP@@,$REPORT_TIMESTAMP,g" $RESULTS_FILE

REPORT_FILE=$JOB_BASE_NAME-report.md
cat README.md $RESULTS_FILE > $REPORT_FILE
if [ -z "$GRIP_USER" ]; then
	grip --export $REPORT_FILE
else
	grip --user=$GRIP_USER --pass=$GRIP_PASS --export $REPORT_FILE
fi

if [ "$RUN_LOCALLY" == "true" ]; then
	echo " Stop the server"
	./_stop-server.sh
fi

echo " Check for errors in Locust master log"
if [[ "0" -ne `cat $JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log | grep 'Error report' | wc -l` ]]; then echo '[:(] THERE WERE ERRORS OR FAILURES!!!'; else echo '[:)] NO ERRORS OR FAILURES DETECTED.'; fi
