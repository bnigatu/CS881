
# coding: utf-8

# In[1]: Import libraries

from pandas import Series, DataFrame
from selenium import webdriver as wd
from selenium.webdriver.support.ui import WebDriverWait
import urllib.request as rqst
from bs4 import BeautifulSoup as bfs
import pandas as pd
import numpy as np
import os
import time
import matplotlib.pylab as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import sklearn.metrics


# In[2]: 
"""
Set working directory
"""
os.chdir("D:\CS881\Data")


# In[3]: Input and check each data

""""
Scrape the data from web
Load data from csv
and inspect the data
"""
# specify environment for chrom 
path="C:\Program Files (x86)\Google\Chrome\Application"
os.environ["PATH"] += os.pathsep + path
# specify the url
flight_page = "https://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time"
# query the website and return the html 
web_page = rqst.urlopen(flight_page)
page = web_page.read()
# parse the html using beautiful soup
soup = bfs(page, 'html.parser')
# Use selinum to interact with the page
options = wd.ChromeOptions()
options.add_experimental_option("prefs", {
  "download.default_directory": r"D:\CS881\Data",
  "download.prompt_for_download": False,
  "download.directory_upgrade": True,
  "safebrowsing.enabled": True
})
browser = wd.Chrome(chrome_options=options)
browser.maximize_window()
browser.get(flight_page)
browser.find_element_by_id('DownloadZip').click()

months = ('January',	'February','March','April',	'May',	'June','July','August','September','October','November','December')

# Download 10 year files
year = int(time.strftime("%Y")) # or "%y"
for y in range(10):    
    browser.find_element_by_id('XYEAR').click()
    browser.find_element_by_xpath("//select [@id='XYEAR']/option[text()='"+str(year-y)+"']").click()
    for m in months:       
        if y == 0 and (m != 'January' or	m!='February'): #this will prevent any errors for year 2018
            break
        else:
            browser.find_element_by_id('FREQUENCY').click()
            browser.find_element_by_xpath("//select [@id='FREQUENCY']/option[text()='"+str(m)+"']").click()
            browser.find_element_by_name('Download2').click()

# Wait for all downloads to finish
while True:
    if os.path.isfile("On_Time_On_Time_Performance_"+str(year-i)+"_12.zip"):
        time.sleep(10)
    elif os.path.isfile("On_Time_On_Time_Performance_"+str(year-i)+"_12.zip"):
        break
    else:
        time.sleep(10)
# Close browser            
browser.quit()



# In[4]: 

"""
Data Engineering
Cleans the data
"""

#low_memory=False
flight_data = pd.read_csv("2018.csv")
#flight_data = pd.concat(pd.read_csv("2017.csv"))
flight_data.dtypes     # show data type of each columns 
flight_data.describe() # show highlight of each columns
flight_data.head()     # sample each column

# Change data type to int        
flight_data.Distance = flight_data.Distance.astype(np.int64)
flight_data.Distance.dtypes 
flight_data.Origin.dtypes 

# Change empty DepTime to '0000'
flight_data.DepTime = flight_data.DepTime.replace(np.nan, '0000', regex=True)
flight_data.Distance = flight_data.Distance.replace(np.nan, 0, regex=True)
flight_data.DepDelay = flight_data.DepDelay.replace(np.nan, 0, regex=True)

# Change data type to int        
flight_data.DepTime = flight_data.DepTime.astype(np.int64)
flight_data.Distance = flight_data.Distance.astype(np.int64)
flight_data.DepDelay = flight_data.DepDelay.astype(np.int64)


# In[5]:Plot the data

# Find the Pearson correlation coefficient between variables
flight_data.corr()
#plot correlation
plt.scatter(flight_data.DepDelay, flight_data.DepTime)
plt.cla()
plt.scatter(flight_data.DayOfWeek, flight_data.DepDelay)
"""
plt.cla()
plt.boxplot([[flight_data.DepDelay[flight_data.DayOfWeek==1]],
             [flight_data.DepDelay[flight_data.DayOfWeek==2]],
             [flight_data.DepDelay[flight_data.DayOfWeek==3]],
             [flight_data.DepDelay[flight_data.DayOfWeek==4]],
             [flight_data.DepDelay[flight_data.DayOfWeek==5]],
             [flight_data.DepDelay[flight_data.DayOfWeek==6]],
             [flight_data.DepDelay[flight_data.DayOfWeek==7]]],
             labels=('1','2','3','4','5','6','7'))
"""
# In[6]: 


# In[7]:

"""
Simple Regression
Modeling and Prediction
"""
# Split into training and testing sets

#predictors = flight_data[["Year","Month","DayofMonth","DayOfWeek","DepTime","Distance","Origin"]]
predictors = flight_data[["Year","Month","DayofMonth","DayOfWeek","DepTime","Distance"]]
targets = flight_data.DepDelay

# Split training and testing data set
pred_train, pred_test, tar_train, tar_test  =   train_test_split(predictors, targets, test_size=.3)

# Check the shape of distribution
pred_train.shape
pred_test.shape
tar_train.shape
tar_test.shape


# In[8]:

#Build model on training data
model = LinearRegression()
model.fit(pred_train,tar_train)



# In[9]:

#save and load the model
import pickle
lm_string=pickle.dumps(model)
lm_string

model=pickle.loads(lm_string)

#Test on testing data
predictions = model.predict(pred_test)
predictions
print ( 'R-Squared : ', model.score(pred_test, tar_test))
sklearn.metrics.r2_score(tar_test, predictions)

#Viewing accuracy
plt.cla()
plt.plot(tar_test, tar_test, c='r')
plt.scatter(tar_test, predictions)

# == Predicting for a new data point ==
# year = 2018
# month = May
# Day = 1
# Departure Time = noon
# Flight Distance = 1,500 miles
model.predict([  2018 ,  5 ,  1,  1200, 1500 ])


# In[10]:

"""
Decision Tree

## Techniques Used

1. Decision Trees 
2. Training and Testing
3. Confusion Matrix
"""


# In[11]:

from pandas import Series, DataFrame
import pandas as pd
import numpy as np
import os
import matplotlib.pylab as plt
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import classification_report
import sklearn.metrics

os.chdir("D:\CS881")

# In[12]:
"""
Data Engineering and Analysis
"""
#Load the dataset

flight_data = pd.read_csv("2018.csv")

flight_data.dtypes
flight_data.describe()
flight_data.head()

# In[13]:

predictors = flight_data[["Year","Month","DayofMonth","DayOfWeek","DepTime","Distance"]]
targets = flight_data.DepDelay

pred_train, pred_test, tar_train, tar_test  =   train_test_split(predictors, targets, test_size=.3)

pred_train.shape
pred_test.shape
tar_train.shape
tar_test.shape

#Build model on training data
classifier=DecisionTreeClassifier()
classifier=classifier.fit(pred_train,tar_train)

predictions=classifier.predict(pred_test)

sklearn.metrics.confusion_matrix(tar_test,predictions)
sklearn.metrics.accuracy_score(tar_test, predictions)
sklearn.metrics.classification_report(tar_test, predictions)

# In[14]:
#Displaying the decision tree
from sklearn import tree
from IPython.display import Image
out = StringIO()
tree.export_graphviz(classifier, out_file=out)
import pydot
graph=pydot.graph_from_dot_data(out.getvalue())
Image(graph.create_png())


#Split into training and testing sets

#Only pick 2 features
predictors = flight_data[['DepTime','Distance']]
targets = flight_data.DepTime

pred_train, pred_test, tar_train, tar_test  =   train_test_split(predictors, targets, test_size=.3)

pred_train.shape
pred_test.shape
tar_train.shape
tar_test.shape

#Build model on training data
classifier=DecisionTreeClassifier()
classifier=classifier.fit(pred_train,tar_train)

predictions=classifier.predict(pred_test)

sklearn.metrics.confusion_matrix(tar_test,predictions)
sklearn.metrics.accuracy_score(tar_test, predictions)
sklearn.metrics.classification_report(tar_test, predictions)


"""
There is a big drop in accuracy score to 60% from 90% when
top predictor variables are removed from the dataset.
"""
# In[15]:
"""

           && Random Forests : Classifying Flight Delays &&

1. Random Forests
2. Training and Testing
3. Confusion Matrix
4. Indicator Variables
5. Binning
6. Variable Reduction
"""
from pandas import Series, DataFrame
import pandas as pd
import numpy as np
import os
import matplotlib.pylab as plt
from sklearn.cross_validation import train_test_split
from sklearn.tree import DecisionTreeClassifier
#from sklearn.metrics import classification_report
import sklearn.metrics



# In[16]:
"""
Data Engineering and Analysis
"""
#Load the dataset
os.chdir("D:\CS881")
flight_data = pd.read_csv("2018.csv", sep=",")
flight_data.dtypes
flight_data.describe()
flight_data.head()

"""
Data Transformations

Let us do the following transformations

1. Convert ArrDel15 into a binned range.
2. Convert DepDel15 status into indicator variables.
 
We could do the same for all other factors too, but we 
choose not to. Indicator variables may or may not improve 
predictions. It is based on the specific data set and need to
be figured out by trials.

ArrDel15 =Arrival Delay Indicator, 15 Minutes or More (1=Yes) 
DepDel15 =Departure Delay Indicator, 15 Minutes or More (1=Yes)
"""
flight_data['ArrDel15'] = pd.cut(flight_data.ArrDel15,[0, 1])
#flight_data = flight_data .join(pd.get_dummies(flight_data.DepDel15))
#del flight_data['DepDel15']
flight_data.head()


#Convert all strings to equivalent numeric representations
#to do correlation analysis
colidx=0
colNames=list(flight_data.columns.values)
for colType in flight_data.dtypes:
    if colType == 'object':
        flight_data[colNames[colidx]]=pd.Categorical.from_array(flight_data[colNames[colidx]]).labels
    colidx= colidx+1
    
flight_data.dtypes
flight_data.describe()

# Change empty DepTime to '0000'
flight_data.DepTime = flight_data.DepTime.replace(np.nan, '0000', regex=True)
flight_data.Distance = flight_data.Distance.replace(np.nan, 0, regex=True)
flight_data.DepDelay = flight_data.DepDelay.replace(np.nan, 0, regex=True)
flight_data.DepDel15 = flight_data.DepDel15.replace(np.nan, 0, regex=True)
flight_data.ArrDel15 = flight_data.ArrDel15.replace(np.nan, 0, regex=True)
# Change data type to int        
flight_data.DepTime = flight_data.DepTime.astype(np.int64)
flight_data.Distance = flight_data.Distance.astype(np.int64)
flight_data.DepDelay = flight_data.DepDelay.astype(np.int64)      
flight_data.DepDel15 = flight_data.DepDel15.astype(np.int64)
flight_data.ArrDel15 = flight_data.ArrDel15.astype(np.int64)

#Find correlations
flight_data.corr()

"""
Based on the correlation co-efficients, let us eliminate 
all diversion columns to make the prediction simple
"""
del flight_data['DivAirportLandings']
del flight_data['DivReachedDest']
del flight_data['DivActualElapsedTime']
del flight_data['DivArrDelay']
del flight_data['DivDistance']
del flight_data['Div1Airport']
del flight_data['Div1AirportID']
del flight_data['Div1AirportSeqID']
del flight_data['Div1WheelsOn']
del flight_data['Div1TotalGTime']
del flight_data['Div1LongestGTime']
del flight_data['Div1WheelsOff']
del flight_data['Div1TailNum']
del flight_data['Div2Airport']
del flight_data['Div2AirportID']
del flight_data['Div2AirportSeqID']
del flight_data['Div2WheelsOn']
del flight_data['Div2TotalGTime']
del flight_data['Div2LongestGTime']
del flight_data['Div2WheelsOff']
del flight_data['Div2TailNum']
del flight_data['Div3Airport']
del flight_data['Div3AirportID']
del flight_data['Div3AirportSeqID']
del flight_data['Div3WheelsOn']
del flight_data['Div3TotalGTime']
del flight_data['Div3LongestGTime']
del flight_data['Div3WheelsOff']
del flight_data['Div3TailNum']
del flight_data['Div4Airport']
del flight_data['Div4AirportID']
del flight_data['Div4AirportSeqID']
del flight_data['Div4WheelsOn']
del flight_data['Div4TotalGTime']
del flight_data['Div4LongestGTime']
del flight_data['Div4WheelsOff']
del flight_data['Div4TailNum']
del flight_data['Div5Airport']
del flight_data['Div5AirportID']
del flight_data['Div5AirportSeqID']
del flight_data['Div5WheelsOn']
del flight_data['Div5TotalGTime']
del flight_data['Div5LongestGTime']
del flight_data['Div5WheelsOff']
del flight_data['Div5TailNum']
flight_data.dtypes

# In[17]: Building model
"""
Modeling and Prediction
"""


#Split into training and testing sets
predictors = flight_data[['DepDel15','Year','Month','DayofMonth','DayOfWeek','DepTime','Distance','Origin']]
targets = np.asarray(flight_data['ArrDel15'], dtype="|S6") #flight_data.ArrDel15.values
pred_train, pred_test, tar_train, tar_test  =   train_test_split(predictors, targets, test_size=.3)
pred_train.shape
pred_test.shape
tar_train.shape
tar_test.shape


#Build model on training data
from sklearn.ensemble import RandomForestClassifier
classifier=RandomForestClassifier(n_estimators=25)
classifier=classifier.fit(pred_train,tar_train)
predictions=classifier.predict(pred_test)
sklearn.metrics.confusion_matrix(tar_test,predictions)
sklearn.metrics.accuracy_score(tar_test, predictions)
sklearn.metrics.classification_report(tar_test, predictions)

"""
Impact of tree size on predictio accuracy
Let us try to build different number of trees and see the effect
of that on the accuracy of the prediction
"""

trees=range(10)
accuracy=np.zeros(10)
for idx in range(len(trees)):
   classifier=RandomForestClassifier(n_estimators=idx + 1)
   classifier=classifier.fit(pred_train,tar_train)
   predictions=classifier.predict(pred_test)
   accuracy[idx]=sklearn.metrics.accuracy_score(tar_test, predictions)
   
plt.cla()
plt.plot(trees, accuracy)
