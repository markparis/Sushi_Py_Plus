#uses the Sushi Py class to harvest COUNTER reports
import sushi_py

#Declare MySQL database variables (ignore if you are only using CSV)
hostname = 'UPDATE WITH SERVER NAME'
username = 'UPDATE WITH USERNAME'
password = 'UPDATE WITH PASSWORD'
database = 'usage'
sushiTable = 'counter_sushi'	#table containing parameters for SUSHI calls. 

#Create a dictionary to be passed in naming where each COUNTER report type goes. Location can be a CSV file name or a MySQL table (but not both currently).
#Directories must already exist for the csv functionality to work. The csv file itself does not have to exist already.
#Follow instructions for formatting the MySQL table or csv file.
reportTypeLocations = {
    'JR1':'counter_jr1', # or 'csv/JR1report.csv' for example
    'JR1a':'counter_jr1a',
    'JR1GOA':'counter_jr1_goa',
    'JR1 GOA':'counter_jr1_goa', #Vendors vary they way the represent this report; both versions place data in the same location.
    'JR2':'counter_jr2',
    'JR3':'counter_jr3',
    'JR4':'counter_jr4',
    'DB1':'counter_db1',
    'DB2':'counter_db2',
    'DB3':'counter_db3', #Counter 3 ONLY; replaced by PR1 in Counter 4
    'PR1':'counter_pr1',
    'MR1':'counter_mr1',
    'MR2':'counter_mr2',
    'BR1':'counter_br1',
    'BR2':'counter_br2',
    'BR3':'counter_br3',
    'BR4':'counter_br4',
    'BR5':'counter_br5',
    'TR1':'counter_tr1',
    'TR2':'counter_tr2',
    'TR3':'counter_tr3',
    'CR1':'counter_cr1'
    }

#create a SushiClient instance
sushi = sushi_py.SushiClient()

#enable debug mode
#sushi.DebugMode = True

#fetch a list of parameters for SUSHI requests either from a CSV or a MySQL table
#params = sushi.GetParamsCSV('csv/sushi.csv')
params = sushi.GetParamsSQL(hostname,username,password,database,sushiTable)

#loop through each of the parameters it found, make a request, and write it to a file/table
for i in range(0,len(params)):
	#print a message to console clarifying that a new item from the SUSHI list is running
	print "----------\r\nRunning report "+params[i]["reportDescription"] + ".----------"
		
	#call the SUSHI server to make a SOAP request with the parameters you just provided
	counterData = sushi.CallServer(params[i])

	#parse response from server into a CSV file or a MySQL table

	#sushi.WriteResponseCSV(counterData,reportTypeLocations)
	sushi.WriteResponseSQL(hostname,username,password,database,counterData,reportTypeLocations)
	
	if i == len(params) - 1:
		print "----------\r\nEnd of parameter list reached. Exiting..."
