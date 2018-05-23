# -*- coding: utf-8 -*-  
""" 
Created on Sat May 12 08:56:57 2018 
 
@author: bnigatu 
"""  
  
from pyspark import SparkContext, SparkConf  
from pyspark.sql import SQLContext  
  
# if you are running this script on the spark shell or zeppelin  
# the spark context already defined as sc so just use   
# the following line to work using data frames instead of RDDs     
spark =  SQLContext(sc)  
  
# if you will by submit the script to as pyspark-submit then you   
# going to have to define your own spark context as   
  
#appName = "Flight Delay" #name of the spark app  
#master = "yarn" or "local[4]" the master can be yarn for claster or if run locally give the # of cores you want to allocate  
#conf = SparkConf().setAppName(appName).setMaster(master)  
#sc = SparkContext(conf=conf)  
  
# then run the script as   
# ./bin/pyspark --master local[4] --py-files machine_learning.py  
  
# Find all csv files stored in HDFS  
all_file_df = spark.read \  
    .format("com.databricks.spark.csv") \  
    .option("header", "true") \  
    .option("inferSchema", "true") \  
    .load("hdfs://nigatu01.nigatu9020/user/impala/flight/*.csv") #from hdfs  
      
all_file_df = spark.read \  
    .format("com.databricks.spark.csv") \  
    .option("header", "true") \  
    .option("inferSchema", "true") \  
    .load("D:\\CS881\\DATA\\*.csv") #from your local folders  
      
# if your machine can not handle all data or want to test it for a single  
# file you can uncomment the following line and use this      
#all_file_df = "D:\\CS881\\DATA\\On_Time_On_Time_Performance_2018_2.csv"      
  
  
# import data again if done separately  
flight_df = spark.read.csv(all_file_df, header=True, inferSchema=True)  
  
  
# we don''t need all columns so let us create a new one removing others  
flight_df = flight_df.select('Year', 'Quarter', 'Month', 'DayofMonth', 'DayOfWeek', \  
                             'ArrDel15', 'CarrierDelay', 'WeatherDelay', 'NASDelay', \  
                             'SecurityDelay', 'LateAircraftDelay','DepDelayMinutes')  
  
  
# null values are not allowed in mllib so fix them  
# create a new vectorized flight data frame  
assembler = VectorAssembler(inputCols=['Year', 'Quarter', 'Month', 'DayofMonth', \  
                                       'DayOfWeek', 'ArrDel15', 'CarrierDelay', \  
                                       'WeatherDelay', 'NASDelay', 'SecurityDelay', \  
                                       'LateAircraftDelay'], outputCol="features")  
flight_vector_df = assembler.transform(flight_df.na.fill(0.0))  
  
# as Bob suggested this yesterday  
# split the data to training and testing set  
split = flight_vector_df.randomSplit([0.6,0.4])  
train_df = split[0]  
test_df = split[1]  
  
""" 
Linear regression 
"""  
from pyspark.ml.linalg import Vectors  
from pyspark.ml.feature import VectorAssembler  
from pyspark.ml.regression import LinearRegression  
  
linear_regression = LinearRegression(maxIter=10, featuresCol = "features", labelCol="DepDelayMinutes" )  
lr_model = linear_regression.fit(flight_vector_df)  
  
# the output model detail  
lr_model.coefficients  
lr_model.intercept  
lr_model.summary.rootMeanSquaredError  
  
# full prediction of the test data  
lr_fullPrediction = lr_model.transform(flight_vector_df).cache()  
  
# compare predictions   
# i am just displaying 100 records for us to see here  
lr_fullPrediction.select("prediction","DepDel15").show(100)  
  
# save model  
lr_model.save("flight_delay.model")  
  
""" 
Decision tree algorithm 
 
"""  
from pyspark.ml.feature import VectorAssembler  
from pyspark.ml.regression import DecisionTreeRegressor  
	from pyspark.ml.evaluation import RegressionEvaluator  
	  
	# reat the same import process above or if you alredy loaded them  
	# we can repurpose that for the boosting model  
	  
	# build decision tree model  
	dt = DecisionTreeRegressor(featuresCol = "features", labelCol="DepDelayMinutes" )  
	dt_model = dt.fit(train_df)  
	dt_predictions = dt_model.transform(test_df)  
	  
	# evaluate the goodness of the model  
	dt_evaluator = RegressionEvaluator(labelCol="DepDelayMinutes", \  
	                                   predictionCol="prediction", metricName="rmse") #this is root mean squared error  
	  
	rmse = dt_evaluator.evaluate(dt_predictions)  
	  
	# the lower the root mean squared error is the better  
	# see the reslt of the prediction for our test data here as  
	rmse  
	  
	""" 
	# Gradient-boosted regression.
	 
	"""  
	  
	from pyspark.ml.feature import VectorAssembler  
	from pyspark.ml.regression import GBTRegressionModel, GBTRegressor  
	from pyspark.ml.evaluation import RegressionEvaluator  
	  
	  
	# reat the same import process above or if you alredy loaded them  
	# we can repurpose that for the boosting model  
	      
	      
	# train the model with training data    
	gbt = GBTRegressor(featuresCol = "features", labelCol="DepDelayMinutes" )  
	gbt_model =gbt.fit(train_df)  
	  
	# test the model with test data we created for the previous model  
	gbt_predictions = gbt_model.transform(test_df)  
	gbt_evaluator = RegressionEvaluator(labelCol="DepDelayMinutes", \  
	                                    predictionCol="prediction", metricName="rmse") #this is root mean squared error  
	gbt_rsme = gbt_evaluator.evaluate(gbt_predictions)  
	gbt_rsme