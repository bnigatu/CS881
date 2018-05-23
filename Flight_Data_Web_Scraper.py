# -*- coding: utf-8 -*-    
"""  
Date: 5/2/18 6:19 PM (GMT-07:00) 
      
@author: bnigatu  
"""    
  
# In[1]: Import libraries  
  
from pandas import Series, DataFrame  
from selenium import webdriver as wd  
from selenium.webdriver.support.ui import WebDriverWait  
from zipfile import ZipFile  
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
  
# it is better if you chose an empty folder so that when it extact  
# it wont extract with your existing zip files  
downloadFolder = r"D:\CS881\Data"  
os.chdir(downloadFolder)  
  
  
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
  "download.default_directory": downloadFolder,  
  "download.prompt_for_download": False,  
  "download.directory_upgrade": True,  
  "safebrowsing.enabled": True  
})  
browser = wd.Chrome(chrome_options=options)  
browser.maximize_window()  
browser.get(flight_page)  
browser.find_element_by_id('DownloadZip').click()  
  
months = ('January',    'February','March','April', 'May',  'June','July','August','September','October','November','December')  
  
# Download 10 year files  
year = int(time.strftime("%Y")) # or "%y"  
for y in range(10):      
    browser.find_element_by_id('XYEAR').click()  
    browser.find_element_by_xpath("//select [@id='XYEAR']/option[text()='"+str(year-y)+"']").click()  
    for m in months:         
        if y == 0 and (m != 'January' and   m!='February'): #this will prevent any errors for year 2018  
            break  
        else:  
            browser.find_element_by_id('FREQUENCY').click()  
            browser.find_element_by_xpath("//select [@id='FREQUENCY']/option[text()='"+str(m)+"']").click()  
            browser.find_element_by_name('Download2').click()  
  
# Wait for all downloads to finish  
while True:  
    if os.path.isfile("On_Time_On_Time_Performance_"+str(year-y)+"_12.zip"):  
        time.sleep(10)  
    elif os.path.isfile("On_Time_On_Time_Performance_"+str(year-y)+"_12.zip"):  
        break  
    else:  
        time.sleep(10)  
# Close browser              
browser.quit()  
# this part is better to do it hear since I have a threading part at the tap that  
# waits for all files to be downloaded first  
print('Extracting all the files now...')  
#for all zip file in the download folder  
for fileName in os.listdir(downloadFolder):  
    with ZipFile(fileName, 'r') as zipfile:          
        zipfile.printdir()  
        zipfile.extractall()# extracting all the files          
print('Done!')