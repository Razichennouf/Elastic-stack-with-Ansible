#To fully manage Fleet server and Elastic Agents we need to group moving parts:
#	1- Create Policy
#	2- Add fleet server integration to policy 
#        3- Enroll Fleet server using agent package and policy token
#	4- Create Enrollment Token
#	4- 

fleet_policy_id=$(curl --request POST \
  --url 'https://localhost:5601/api/fleet/agent_policies?sys_monitoring=true' \
  --header 'Accept: */*' \
  --header 'Authorization: Basic elastic:06+-Ir=1ckgY+XSjH80p \
  --header 'Cache-Control: no-cache' \
  --header 'Connection: keep-alive' \
  --header 'Content-Type: application/json' \
  --header 'kbn-xsrf: anything' \
  --data '{
  "name": "Agent policy 11",
  "description": "",
  "namespace": "default",
  "monitoring_enabled": [
    "logs",
    "metrics"
  ]
}' --insecure | jq -r '.item.id')

echo $fleet_policy_id

response=$(curl --request POST \
  --url 'https://localhost:5601/api/fleet/package_policies' \
  --header 'Authorization: Basic elastic:06+-Ir=1ckgY+XSjH80p\
  --header 'Content-Type: application/json' \
  --header 'kbn-xsrf: anything' \
  --data '{
  "name": "Fleet",
  "policy_id": "$fleet_policy_id",
  "package": {
    "name": "fleet_server",
    "version": "1.2.0"
  }

}' --insecure)

#echo $response
#curl -X POST http://localhost:5601/api/fleet/agent_policies -H "Content-Type: application/json" -H "kbn-xsrf: 'anything'" -d '{"name: "Test_policy", "description": "", "namespace": "default", "monitoring_enabled":["logs", "metrics"], "inactivity_timeout": 1209600, "is_protected": false, "sys_monitoring": true}'
