#!/bin/bash
#JSON object to pass Lambda Function
json1={"\"msg\"":"\"ServerlessComputingWithFaaS\"","\"shift\"":"10"}
echo "Invoking Lambda function using API Gateway"
time encode=`curl -s -H "Content-Type: application/json" -X POST -d $json1 https://dgezm82p52.execute-api.us-east-1.amazonaws.com/encode_dev`
echo "JSON RESULT FOR ENCODING:"
echo $encode | jq
decode_string=`echo $encode | jq '.value'`
json2={"\"msg\"":$decode_string,"\"shift\"":"10"}
time decode=`curl -s -H "Content-Type: application/json" -X POST -d $json2 https://x67mguk97d.execute-api.us-east-1.amazonaws.com/decode_dev`
echo ""
echo "JSON RESULT FOR DECODING:"
echo $decode |jq   
echo ""

