import boto3
import botocore

import json
import os

alphav = os.environ['alphav']

s3 = boto3.client('s3')
req = botocore.requests
req2 = boto3.requests
print(req)
print(req2)

def alphav(event, context):
    bucket = 'ian-patent-stock'

    data = {'somedata':42}
    search = 'AAPL'
    filename = f'{search}.json'
    search = req2.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=AAPL&apikey={alphav}&datatype=json')
    data = search.json()

    bytedata = bytes(json.dumps(data).encode('UTF-8'))
    s3.put_object(Bucket=bucket, Key=filename, Body=bytedata)

    print('Upload complete')

    
    '''
    spdf = pd.read_csv("./data/sp.csv")
    
    #import env vars
    file = open(".env", "r")
    content = file.read()
    file.close()
    envdata = content.split("\n")
    env = {}
    for i in envdata:
        d = i.split("=")
        env[d[0]] = d[1]
    
    
    #alpha vantage ticker symbol search
    #search = requests.get(f'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=apple&apikey={env["alphav"]}')
    #data = search.json()
    #pp.pprint(data)
    
    #alphavantage api data 25 calls per day
    #csv
    ##alvc = requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=IBM&apikey={env["alphav"]}&datatype=csv')
    #json
    def get_from_alphav(start,stop):
        dailyd = []
        for i in spdf['symbol'][start:stop]:
            print(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={i}&outputsize=full&apikey={env["alphav"]}')
            alv_response = requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={i}&outputsize=full&apikey={env["alphav"]}',verify=False)
            #index 0 will be data index 1 is data symbol
            dailyd.append([alv_response,i])
            time.sleep(42)
        dfs = []
        for i in dailyd:
            json_data = i[0].json()
            print(json_data)
            json_nometa = json_data['Time Series (Daily)']
            df = pd.DataFrame.from_dict(json_nometa, orient='index')
            ndf = df.reset_index()
            fdf = ndf.rename(columns={"index":"date","1. open": "open", "2. high": "high","3. low":"low","4. close":"close","5. volume":"volume","delta":"delta"})
            #again index 0 is data index 1 is data symbol
            dfs.append([fdf,i[1]])
            #write api calls to json file incase sparksession hdfs write does not work
            fdf.to_csv(f'./data/{i[1]}.csv',index=False)
            ##with open(f'./data/{i[1]}.json', 'w') as outfile:
            ##outfile.write(str(i[0].json()))
        return dfs
    
    #call to get data from api
    dfs = []
    dfs = get_from_alphav(5,6)
    ##pdf = pd.read_json('./data/ABBV.json', lines=True)
    ##print(pdf)
    ##dfs.append(pdf)
    
    
    # Create SparkSession 
    spark = SparkSession.builder \
        .master("local[1]") \
        .appName("alphav_data") \
        .getOrCreate() 
    
    for i in dfs:
        #convert pandas dfs to pyspark dfs
        df_spark = spark.createDataFrame(i[0])
        df_spark.show()
        #write to parquet file on hdfs
        ##df_spark.write.parquet(f'./data/{i[1]}.parquet',  mode='append')
        ##df_spark.write.parquet(f'/user/ec2-user/UKUSMarHDFS/ian/{i[1]}.parquet',  mode='append')
    
        df_spark.write.save(f'hdfs://ip-172-31-3-80.eu-west-2.compute.internal:8020/user/ec2-user/UKUSMarHDFS/ian/proj/data/{i[1]}.csv', format='csv', mode='append')
        ##df_spark.write.save(f'hdfs://localhost:8020/user/ec2-user/UKUSMarHDFS/ian/proj/data/{i[1]}.json', format='json', mode='append')

'''
