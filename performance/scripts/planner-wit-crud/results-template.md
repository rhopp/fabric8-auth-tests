# Results (@@JOB_BASE_NAME@@ #@@BUILD_NUMBER@@ @@TIMESTAMP@@)
## Summary
The following tables show the final results taken and computed from a single test run - i.e. after and by running the login phase and the 5 minutes of the load phase.

The summary results of each run are uploaded to the
[Zabbix](https://zabbix.devshift.net:9443/zabbix/screens.php)
monitoring system to track the results' history.

### Load Test
| Scenario | Minimal | Median | Maximal | Average | Failed |
| :--- | ---: | ---: | ---: | ---: | ---: |
|`api-spaces`| @@AUTH_API_USER_MIN@@ ms | @@AUTH_API_USER_MEDIAN@@ ms | @@AUTH_API_USER_MAX@@ ms | @@AUTH_API_USER_AVERAGE@@ ms | @@AUTH_API_USER_FAILED@@ |
|`api-space-create`| @@AUTH_API_TOKEN_REFRESH_MIN@@ ms | @@AUTH_API_TOKEN_REFRESH_MEDIAN@@ ms | @@AUTH_API_TOKEN_REFRESH_MAX@@ ms | @@AUTH_API_TOKEN_REFRESH_AVERAGE@@ ms | @@AUTH_API_TOKEN_REFRESH_FAILED@@ |
|`api-workitem-create`| @@AUTH_API_USER_GITHUB_TOKEN_MIN@@ ms | @@AUTH_API_USER_GITHUB_TOKEN_MEDIAN@@ ms | @@AUTH_API_USER_GITHUB_TOKEN_MAX@@ ms | @@AUTH_API_USER_GITHUB_TOKEN_AVERAGE@@ ms | @@AUTH_API_USER_GITHUB_TOKEN_FAILED@@ |
|`api-workitem-by-id`| @@API_USER_BY_ID_MIN@@ ms | @@API_USER_BY_ID_MEDIAN@@ ms | @@API_USER_BY_ID_MAX@@ ms | @@API_USER_BY_ID_AVERAGE@@ ms | @@API_USER_BY_ID_FAILED@@ |
|`api-workitem-update`| @@API_USER_BY_NAME_MIN@@ ms | @@API_USER_BY_NAME_MEDIAN@@ ms | @@API_USER_BY_NAME_MAX@@ ms | @@API_USER_BY_NAME_AVERAGE@@ ms | @@API_USER_BY_NAME_FAILED@@ |
|`api-space-delete`| @@API_USER_BY_NAME_MIN@@ ms | @@API_USER_BY_NAME_MEDIAN@@ ms | @@API_USER_BY_NAME_MAX@@ ms | @@API_USER_BY_NAME_AVERAGE@@ ms | @@API_USER_BY_NAME_FAILED@@ |

## Test charts
The charts bellow show the whole duration of all the phases for each scenario - i.e. what lead to the final results shown above in the summary.

## Load Test
In these charts, the value shown in each point of time is the metric (minimal, median, maximal and average value) of the response time
computed for a time window from the start to the respective point of time. So it is a floating metric.

That is the reason for the values of the maximals always go up.
### `auth-api-user` Response Time
![api-spaces-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-response-time.png)
![api-spaces-minimal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-minimal-response-time.png)
![api-spaces-median-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-median-response-time.png)
![api-spaces-maximal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-maximal-response-time.png)
![api-spaces-average-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-average-response-time.png)
![api-spaces-rt-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-rt-histo.png)
### `auth-api-user` Failures
![api-spaces-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-spaces-failures.png)
### `auth-api-token-refresh` Response Time
![api-space-create-response-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-response-time.png)
![api-space-create-minimal-refresh-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-minimal-response-time.png)
![api-space-create-median-refresh-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-median-response-time.png)
![api-space-create-maximal-refresh-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-maximal-response-time.png)
![api-space-create-average-refresh-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-average-response-time.png)
![api-space-create-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-rt-histo.png)
### `auth-api-token-refresh` Failures
![api-space-create-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-POST_api-space-create-failures.png)
### `api-spaces-github-token` Response Time
![api-workitem-create-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-response-time.png)
![api-workitem-create-minimal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-minimal-response-time.png)
![api-workitem-create-median-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-median-response-time.png)
![api-workitem-create-maximal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-maximal-response-time.png)
![api-workitem-create-average-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-average-response-time.png)
![api-workitem-create-rt-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-rt-histo.png)
### `api-spaces-github-token` Failures
![api-workitem-create-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-create-failures.png)
### `api-user-by-id` Response Time
![api-workitem-by-id-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-response-time.png)
![api-workitem-by-id-minimal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-minimal-response-time.png)
![api-workitem-by-id-median-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-median-response-time.png)
![api-workitem-by-id-maximal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-maximal-response-time.png)
![api-workitem-by-id-average-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-average-response-time.png)
![api-workitem-by-id-rt-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-rt-histo.png)
### `api-user-by-id` Failures
![api-workitem-by-id-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workitem-by-id-failures.png)
###  `api-workspace-update` Response Time
![api-workspace-update-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-response-time.png)
![api-workspace-update-minimal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-minimal-response-time.png)
![api-workspace-update-median-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-median-response-time.png)
![api-workspace-update-maximal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-maximal-response-time.png)
![api-workspace-update-average-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-average-response-time.png)
![api-workspace-update-rt-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-rt-histo.png)
### `api-workspace-update` Failures
![api-workspace-update-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-workspace-update-failures.png)
###  `api-space-delete` Response Time
![api-space-delete-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-response-time.png)
![api-space-delete-minimal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-minimal-response-time.png)
![api-space-delete-median-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-median-response-time.png)
![api-space-delete-maximal-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-maximal-response-time.png)
![api-space-delete-average-reponse-time](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-average-response-time.png)
![api-space-delete-rt-histo](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-rt-histo.png)
### `api-space-delete` Failures
![api-space-delete-failures](./@@JOB_BASE_NAME@@-@@BUILD_NUMBER@@-GET_api-space-delete-failures.png)
