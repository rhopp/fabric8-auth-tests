#!/bin/bash

# 'true" if locust test is to be run locally (i.e. no master, no slaves, no remote execution).
#export RUN_LOCALLY=true

# Should be provided by Jenkins.
#export JOB_BASE_NAME=planner-wit-crud

# Should be provided by Jenkins.
#export BUILD_NUMBER=0

# Auth server HTTP scheme http/https
#export SERVER_SCHEME=http

# A SSH hostname for the server machine.
#export SSH_SERVER_HOST=localhost

# Auth server machine address.
#export SERVER_HOST=$SSH_SERVER_HOST:8080

# Locust SSH user. (Only for RUN_LOCALLY != true)
#export SSH_USER=centos

# Locust node workdir. (Only for RUN_LOCALLY != true)
#export SSH_WORKDIR=/home/centos

# A number of simulated user accounts
#export ACCOUNTS=10

# A number of users to spawn.
#export USERS=100

# A hatch rate (number of users to spawn per second).
#export USER_HATCH_RATE=10

# A name of the file where the user tokens are saved
export TOKENS_FILE=/tmp/osioperf.users.tokens

# A file where USER_TOKENS environmental variable is supposed to be set.
# This file is copied to locust master/slaves to be sources by BASH before executing the locust itself.
# So the locust process get's passed the USER_TOKENS variable.
export ENV_FILE=/tmp/osioperf.users.env

# 'true' if a report will be sent to a Zabbix instance
#export ZABBIX_REPORT_ENABLED=false

# An address of Zabbix server
#export ZABBIX_SERVER=zabbix.devshift.net

# A port of Zabbix server used by zabbix_sender utility
#export ZABBIX_PORT=10051

# A hostname in Zabbix the report is for
#export ZABBIX_HOST=localhost

# A number of seconds for how long the test should run
#export DURATION=300