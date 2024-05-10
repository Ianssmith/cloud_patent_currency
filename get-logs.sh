#!/bin/bash
zip -u lambda_s3.zip alphav.py
aws lambda invoke --function-name get_data_put_s3 --cli-binary-format raw-in-base64-out --payload '{"key": "value"}' out.txt
sed -i'' -e 's/"//g' out.txt
sleep 15
aws logs get-log-events --log-group-name /aws/lambda/get_data_put_s3 --log-stream-name stream1 --limit 10
