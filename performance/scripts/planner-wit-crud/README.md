#Create Space
```
POST /api/spaces
Authorization: Bearer <TOKEN>
Content-Type: application/json

{
  "data": {
    "type": "spaces",
    "attributes": {
      "name": "<NAME>",
      "description": "<DESCRIPTION>"
    }
  }
}
```
---
```
SPACE_ID = JSON["data"]["id"]`
```

#Get Space
```
GET /api/spaces/<SPACE_ID>
```

#List Workitems
```
GET /api/spaces/<SPACE_ID>/workitems
```

#Create Workitem (Scenario)
```
POST /api/spaces/<SPACE_ID>/workitems
Authorization: Bearer <TOKEN>
Content-Type: application/json

{
  "data": {
    "type": "workitems",
    "attributes": {
      "system.state": "new",
      "system.title": "Scenario y"
    },
    "relationships":{
      "baseType": {
        "data": {
          "id": "71171e90-6d35-498f-a6a7-2083b5267c18",
          "type": "workitemtypes"
        }
      }
    }
  }
}
```
---
```
SCENARIO_ID = JSON["data"]["id"]
```

#Read Scenario
```
GET /api/workitems/<SCENARIO_ID>
```

#Update Scenario state
```
PATCH /api/workitems/<SCENARIO_ID>
Authorization: Bearer <TOKEN>
Content-Type: application/json

{
  "data": {
    "type": "workitems",
    "id":"<SCENARIO_ID>",
    "attributes": {
      "version": "0",
      "system.state": "in progress"
    },
    "relationships":{
      "baseType": {
        "data": {
          "id": "71171e90-6d35-498f-a6a7-2083b5267c18",
          "type": "workitemtypes"
        }
      }
    }
  }
}
```

#TODO: Create Scenario's Expecience (child)

#Delete space
```
DELETE /api/space/<SPACE_ID>
Authorization: Bearer <TOKEN>
```
