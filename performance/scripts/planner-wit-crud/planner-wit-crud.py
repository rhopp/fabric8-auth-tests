import os
import threading
from locust import HttpLocust, TaskSet, task

serverScheme = "@@SERVER_SCHEME@@"
serverHost = "@@SERVER_HOST@@"

_users = -1
_userTokens = []
_userRefreshTokens = []
_currentUser = 0
_userLock = threading.RLock()
_spaceIndexLock = threading.RLock()

usenv = os.getenv("USER_TOKENS")
# usenv = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJiTnEtQkNPUjNldi1FNmJ1R1NhUHJVLTBTWFg4d2hoRGxtWjZnZWVua1RFIn0.eyJqdGkiOiJkMzU1MjU1ZC1iZjc3LTQ1MzMtOGU0My00Njk4YTM4OWE0ODEiLCJleHAiOjE1MjAwMDI5NzUsIm5iZiI6MCwiaWF0IjoxNTE3NDEwOTc1LCJpc3MiOiJodHRwczovL3Nzby5wcm9kLXByZXZpZXcub3BlbnNoaWZ0LmlvL2F1dGgvcmVhbG1zL2ZhYnJpYzgtdGVzdCIsImF1ZCI6ImZhYnJpYzgtb25saW5lLXBsYXRmb3JtIiwic3ViIjoiYTA2ZmE3ZTctNDZmMy00OTQ3LTk4OGItZDcwOGQ5OTBmNDkxIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZmFicmljOC1vbmxpbmUtcGxhdGZvcm0iLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0YTA4ZWE3Ni1kM2MwLTRhYTAtOWEzZS1iNTYzMWY0MGM3MDUiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHBzOi8vcHJvZC1wcmV2aWV3Lm9wZW5zaGlmdC5pbyIsImh0dHBzOi8vYXV0aC5wcm9kLXByZXZpZXcub3BlbnNoaWZ0LmlvIiwiaHR0cDovLzE5Mi4xNjguNDIuMjU0OjMxMDAwIiwiaHR0cDovL2xvY2FsaG9zdDo4MDgwIiwiaHR0cDovL21pbmlzaGlmdC5sb2NhbDozMTIwMCIsImh0dHA6Ly9taW5pc2hpZnQubG9jYWw6MzEwMDAiLCJodHRwOi8vYXV0aC1mYWJyaWM4LjE5Mi4xNjguNjQuMTAubmlwLmlvIiwiKiIsImh0dHBzOi8vYXBpLnByb2QtcHJldmlldy5vcGVuc2hpZnQuaW8iLCJodHRwOi8vbG9jYWxob3N0OjMwMDAiLCJodHRwOi8vbG9jYWxob3N0OjgwODkiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYnJva2VyIjp7InJvbGVzIjpbInJlYWQtdG9rZW4iXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sImFwcHJvdmVkIjp0cnVlLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJ0ZXN0dXNlciBleHBlcmltZW50cyIsInByZWZlcnJlZF91c2VybmFtZSI6InRlc3R1c2VyIiwiZ2l2ZW5fbmFtZSI6InRlc3R1c2VyIiwiZmFtaWx5X25hbWUiOiJleHBlcmltZW50cyIsImVtYWlsIjoidGVzdHVzZXJleHBlcmltZW50c0B0ZXN0Y29tIn0.M_NmtQUntPaUYYNy9Qm4RHFhqQ82pB2GZopbFVEbnsYcta_bFebtnvlZy3TentQ6N7Q1TDwoHJmeO1vklavla5vsHU-kZQ6BysAZeh90lhhdy42v39WdjbadYPgj3N_xwumdxNtQ9YgmhN-2hHw8YHoxPxEZHW2bJpPT5KgpESurNCl8GkBp8eZHeHBK5DK1mEUFIiqyQv49oe36ghmWHcc8pwQHPyLaf-lm4PiyNAGIIL3xpLLP5fupeEYyT-rLppPLZt5iWh6RhZhmM6Dewu1Uvs0uchDhulZ2CLU8Cjl4KB9s4fFsfWN9l0twBuKBrNa7J5JlnmMyUsDjRpQUCA;eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJiTnEtQkNPUjNldi1FNmJ1R1NhUHJVLTBTWFg4d2hoRGxtWjZnZWVua1RFIn0.eyJqdGkiOiJlYWM0OWYxMS1mNzBjLTQ2MzctOWQ5NC1kNDQyZDA1NTk2ZTIiLCJleHAiOjE1MjAwMDI5NzUsIm5iZiI6MCwiaWF0IjoxNTE3NDEwOTc1LCJpc3MiOiJodHRwczovL3Nzby5wcm9kLXByZXZpZXcub3BlbnNoaWZ0LmlvL2F1dGgvcmVhbG1zL2ZhYnJpYzgtdGVzdCIsImF1ZCI6ImZhYnJpYzgtb25saW5lLXBsYXRmb3JtIiwic3ViIjoiYTA2ZmE3ZTctNDZmMy00OTQ3LTk4OGItZDcwOGQ5OTBmNDkxIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImZhYnJpYzgtb25saW5lLXBsYXRmb3JtIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNGEwOGVhNzYtZDNjMC00YWEwLTlhM2UtYjU2MzFmNDBjNzA1IiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYnJva2VyIjp7InJvbGVzIjpbInJlYWQtdG9rZW4iXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX19.tW1cC0AZhUQgkn6lT6o5T0aEsyedPTOlE5l5QKpG_gnXgg15AHm8a8Pnr7s8GIh5JQh33F2xzAJz6Hmq2AAdV0E-E29akAUOxM2uonpDfBTXli9tPcwyB2muEfGC1aw2OCxHF7eNipxh8iivZojzrhLhgcob2dRe7EAHCUZ_Uvt4tn5dEnzjcOmPzAb0AOi4NaPePYwzURofa8RpPUlJXxz4Ot_bQqviniy5R7gSuxhfMcQrKDPhhfJCPhF2BL2XqkTNgtfrW0raOgaj_uQe7j3Rc5HJJ2mvw9rqoNciy3shYvpTRHHmYhvo9O1qVCI3IZyBQwtMogxeDgoHxblWmA"
lines = usenv.split('\n')

_users = len(lines)

for u in lines:
    up = u.split(';')
    _userTokens.append(up[0])
    _userRefreshTokens.append(up[1])


class WiBehavior(TaskSet):
    taskUser = -1
    taskSpaceId = ""
    taskSpaceIndex = -1
    # taskUserName = ""
    taskUserToken = ""

    # taskUserRefreshToken = ""

    def nextSpaceIndex(self):
        spaceIndex = -1
        _spaceIndexLock.acquire()
        self.taskSpaceIndex = self.taskSpaceIndex + 1
        spaceIndex = self.taskSpaceIndex
        _spaceIndexLock.release()
        return spaceIndex

    def on_start(self):
        global _currentUser, _users, _userLock, _userTokens, _userRefreshTokens
        _userLock.acquire()
        self.taskUser = _currentUser
        if _currentUser < _users - 1:
            _currentUser += 1
        else:
            _currentUser = 0
        _userLock.release()
        self.taskUserToken = _userTokens[self.taskUser]
        # self.taskUserRefreshToken = _userRefreshTokens[self.taskUser]
        # self.authUser()

    @task
    def listSpaces(self):
        response = self.client.get("/api/spaces", headers={"Authorization": "Bearer " + self.taskUserToken}, name="api-spaces", catch_response=True)
        content = response.content
        if not response.ok:
            response.failure("Got wrong response: [" + content + "]")
        else:
            response.success()

    @task
    def crudSpace(self):
        # CREATE

        si = str(self.taskUser) + "-" + str(self.nextSpaceIndex());
        space = {
            "data": {
                "type": "spaces",
                "attributes": {
                    "name": "Space" + si,
                    "description": "test space " + si
                }
            }
        }
        response = self.client.post("/api/spaces", headers={"Authorization": "Bearer " + self.taskUserToken, "Content-Type": "application/json"}, json=space, name="api-space-create", catch_response=True)
        content = response.content
        try:
            resp_json = response.json()
            if not response.ok:
                response.failure("Got wrong response: [" + content + "]")
                return
            else:
                spaceId = resp_json["data"]["id"]
                response.success()
        except ValueError:
            response.failure("Got wrong response: [" + content + "]")
            return

        # CREATE WI
        wi = {
            "data": {
                "type": "workitems",
                "attributes": {
                    "system.state": "new",
                    "system.title": "Scenario " + si,
                    "system.description": "Test scenario " + si
                },
                "relationships": {
                    "baseType": {
                        "data": {
                            "id": "71171e90-6d35-498f-a6a7-2083b5267c18",
                            "type": "workitemtypes"
                        }
                    }
                }
            }

        }
        response = self.client.post("/api/spaces/" + spaceId + "/workitems", headers={"Authorization": "Bearer " + self.taskUserToken, "Content-Type": "application/json"}, json=wi, name="api-workitem-create", catch_response=True)
        content = response.content
        try:
            resp_json = response.json()
            if not response.ok:
                response.failure("Got wrong response: [" + content + "]")
            else:
                wiId = resp_json["data"]["id"]
                response.success()
        except ValueError:
            response.failure("Got wrong response: [" + content + "]")
            return

        # READ WI
        response = self.client.get("/api/workitems/" + wiId, name="api-workitem-by-id", catch_response=True)
        content = response.content
        if not response.ok:
            response.failure("Got wrong response: [" + content + "]")
        else:
            response.success()

        # UPDATE WI
        wiUpdated = "{\"data\":{\"type\":\"workitems\",\"id\":\"" + wiId + "\",\"attributes\":{\"version\":\"0\",\"system.state\":\"in progress\"},\"relationships\":{\"baseType\":{\"data\":{\"id\":\"71171e90-6d35-498f-a6a7-2083b5267c18\",\"type\":\"workitemtypes\"}}}}}"
        response = self.client.patch("/api/workitems/" + wiId, headers={"Authorization": "Bearer " + self.taskUserToken, "Content-Type": "application/json"}, data=wiUpdated.encode("utf-8"), name="api-workitem-update", catch_response=True)
        content = response.content
        try:
            resp_json = response.json()
            if not response.ok:
                response.failure("Got wrong response: [" + content + "]")
            else:
                response.success()
        except ValueError:
            response.failure("Got wrong response: [" + content + "]")
            return

        # DELETE
        response = self.client.delete("/api/spaces/" + spaceId, headers={"Authorization": "Bearer " + self.taskUserToken}, name="api-space-delete", catch_response=True)
        if not response.ok:
            response.failure("Got wrong response: [" + str(response.status_code) + "]")
        else:
            response.success()


class WiUser(HttpLocust):
    host = serverScheme + "://" + serverHost
    task_set = WiBehavior
    min_wait = 1000
    max_wait = 1000
