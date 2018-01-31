#!/bin/bash

source _setenv.sh

TOKEN_FILE=${1:-user.tokens}

echo " Generating authentization tokens into $TOKEN_FILE"
for i in $(seq 1 $USERS);
do
   auth_resp=$(curl --silent -X GET --header 'Accept: application/json' $SERVER_SCHEME'://'$SERVER_HOST'/api/login/generate')
   access_token=$(echo $auth_resp | jq '.[0]["token"]["access_token"]' | tr -d '"');
   refresh_token=$(echo $auth_resp | jq '.[0]["token"]["refresh_token"]' | tr -d '"');
   if [[ "x" != "x$access_token" ]];
   then
      echo "$access_token;$refresh_token" >> $TOKEN_FILE;
   else
      echo "ERROR: Unable to acquire authentication token!";
      exit 1;
   fi;
done
