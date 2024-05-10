# S&P500 and Forex models on AWS!

## data sources
Open exchange rates api
    1000 free requests per month
alphavantage api
    25 requests per day
google patents public data
## Flow 
### apis -> hdfs -> hive/hbase -> models
[<img src="./imgs/aws_stock_proj.drawio.png">](https://link-to-your-URL/)

## beginning db model wip
[<img src="./imgs/db_model.png">](https://link-to-your-URL/)

## creating aws lambda and iam role
[<img src="./imgs/s3_terra_lambda.png">](https://github.com/Ianssmith/cloud_patent_currency/blob/master/imgs/s3_terra_lambda.png)

## creating and attaching s3 access policy for lambda 
[<img src="./imgs/create_attach_policy.png">](https://github.com/Ianssmith/cloud_patent_currency/blob/master/imgs/create_attach_policy.png)

## Querying api and inserting into s3
[<img src="./imgs/s3_data.png">](https://github.com/Ianssmith/cloud_patent_currency/blob/master/imgs/s3_data.png)
