smarn="arn:aws:states:us-east-1:323230709869:stateMachine:Deeksha_State_Machine"
# a file­based counter to generate unique messages for encode/decode
count=0
if [ -e .uniqcount ]
then  
    count=$(cat .uniqcount)
fi
count=$(expr $count + 1)
echo $count > .uniqcount
# JSON object to pass to Lambda Function, uses the unique $count 
json={"\"msg\"":"\"NEW-SQS-$count-­ServerlessComputingWithFaaS\",\"shift\"":22}
# Call the state machine
exearn=$(aws stepfunctions start-execution --state-machine-arn $smarn --input $json | jq -r ".executionArn")
echo $exearn
# get output from SQS 
msgs=$(aws sqs receive-message --queue-url https://sqs.us-east-1.amazonaws.com/323230709869/CaesarQ)
# show result from SQS queue
echo $msgs | jq
# delete the message from the queue using the receipt handle
receipthandle=$(echo $msgs | jq -r .Messages[0].ReceiptHandle)
aws sqs delete-message --queue-url https://sqs.us-east-1.amazonaws.com/323230709869/CaesarQ --receipt-handle $receipthandle 

exit
# poll output
output="RUNNING"
while [ "$output" == "RUNNING" ]
do  
  echo "Status check call..."
     alloutput=$(aws stepfunctions describe-execution --execution-arn $exearn)
  output=$(echo $alloutput | jq -r ".status")
  echo "Status check=$output"
done
echo ""
aws stepfunctions describe-execution --execution-arn $exearn | jq -r ".output" | jq
