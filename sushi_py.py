#
#Gets the parameters for a SUSHI request either from a CSV file or MySQL database table.
#Makes a SUSHI request and parses results either to a CSV file or a MySQL database table.
#
#Last tested March 2016 with SUSHI 1.6/COUNTER 4
#
#Copyright 3.29.2012 Josh Welker
#jswelker@gmail.edu
#You are free to re-use under Creative Commons ShareAlike 3.0 License http://creativecommons.org/licenses/by-sa/3.0/ 
#(name, email, and date are sufficient attribution)
#
#Revised 3.2.2016 by Mark Paris
#meparis@brandies.edu

class SushiClient: #this class does all the work of importing parameters, making a SOAP request, and parsing the response

	#constructor
	def __init__(self):

		#Make default report and end date default to the first and last of the previous month (ie if today is Feb then report will be Jan 1 - Jan 31)
		#To override, make sure you use format yyyy-mm-dd 
		import datetime
		today = datetime.date.today()
		firstofmonth = datetime.date(today.year,today.month,1)
		delta = datetime.timedelta(days=1)
		self.EndDate = firstofmonth - delta
		self.StartDate = datetime.date(self.EndDate.year,self.EndDate.month,1)
		
		#set debug mode to default to "off"
		self.DebugMode = False
		
		
#class methods
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
	def GetParamsCSV(self,inputFile): #takes a CSV file location as input and reads the following variables to the class's properties
		import csv
		import sys
		
		#attempt to open csv file
		try:
			csvfile = open(inputFile,'rb')
			print "Parameter file opened."
		except:
			print "File could not be opened."
			sys.exit()
		
		#create reader object
		reader = csv.reader(csvfile)
		
		#loop through rows and write contents to a dictionary, then append that dictionary to a list
		sushiParams = []
		i = 0
		for row in reader:
			if currentrow != 0: #skip first row because it contains headers
				try:
					data = {
						'reportDescription' : row[0],
						'requestorID' : row[1],
						'requestorName' : row[2],
						'requestorEmail' : row[3],
						'customerID' : row[4],
						'customerName' : row[5],
						'counterRelease' : row[6],
						'counterReportType' : row[7],
						'wsdlURL' : row[8]
					}
				except:
					data = {}
				
				sushiParams.append(data)
			i += 1
		
		if csvfile:
			csvfile.close()
		
		return sushiParams

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------		
	def GetParamsSQL(self,hostname,username,password,database,table): #reads a MySQL table for the SUSHI parameters and writes them to the class's properties
		import MySQLdb as mdb
		import sys
		
		#define sql query
		sqlQuery = 'SELECT * FROM ' + table #+ ' WHERE id = x' #Use to re-run specific reports if necessary
	
		try:
			con = mdb.connect(hostname,username,password,database)
			cur = con.cursor(mdb.cursors.DictCursor)
			cur.execute(sqlQuery)
			
			#declare a list to hold the parameters
			sushiParams = []
			
			#get the rows returned
			numrows = int(cur.rowcount)
			
			#loop through rows and create a dictionary for each one containing the params, then add to the list we created
			for i in range(numrows):
				row = cur.fetchone()
				data = {
					'reportDescription' : row['description'],
					'requestorID' : row['requestorID'],
					'requestorName' : row['requestorName'],
					'requestorEmail' : row['requestorEmail'],
					'customerID' : row['customerID'],
					'customerName' : row['customerName'],
					'counterRelease' : row['counterRelease'],
					'counterReportType' : row['counterReportType'],
					'wsdlURL' : row['wsdlURL']
				}
					
				sushiParams.append(data)
			
			return sushiParams
			
		except mdb.Error, e:
			print "Error %d: %s" % (e.args[0],e.args[1])
			sys.exit(1)
		
		finally:
			if con:
				con.close()

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
	def CallServer(self,params): #makes a SOAP request to the SUSHI server and parses response
		
		#load libraries
		import sys
		import traceback
		import urllib2
		import suds
		from suds import WebFault
		from suds.client import Client
		from datetime import datetime
		
		now = datetime.now()
		isonow = datetime.isoformat(now)
				
		try:	
			#Use a plugin to manually modify the SOAP message since SUDS has a hard time 
			#with the Created and ID attributes of the RequestReport element
			from suds.plugin import MessagePlugin
			from suds.sax.attribute import Attribute
			
			#enable debugging if it has been set
			if self.DebugMode == True:
				import logging
				logging.basicConfig(level=logging.INFO)
				logging.getLogger('suds.client').setLevel(logging.DEBUG)
				logging.getLogger('suds.transport').setLevel(logging.DEBUG)
				logging.getLogger('suds.xsd.schema').setLevel(logging.DEBUG)
				logging.getLogger('suds.wsdl').setLevel(logging.DEBUG)

			
			class EnvelopeFixer(MessagePlugin):
				def marshalled(self, context):
					root = context.envelope.getRoot()
					reportrequest = root.getChild("Envelope").getChild("ns1:Body").getChild("ns2:ReportRequest")
					reportrequest.attributes.append(Attribute("ID","?"))
					reportrequest.attributes.append(Attribute("Created", isonow))

			#create client from WSDL definitions
			try:
				client = Client(params['wsdlURL'], plugins=[EnvelopeFixer()],timeout=1000)
			except Exception,e:
				client = None
				print "Failed to read WSDL for " + params["wsdlURL"]

			#create objects based on WSDL types and fill them with data that will be passed on to the request

			requestor = client.factory.create('ns1:Requestor')
			requestor.ID = params['requestorID']
			requestor.Name = params['requestorName']
			requestor.Email = params['requestorEmail']

			customer = client.factory.create('ns1:CustomerReference')
			customer.ID = params['customerID']
			customer.Name = params['customerName']

			reportDefinition = client.factory.create('ns1:ReportDefinition')
			reportDefinition._Release = params['counterRelease']
			reportDefinition._Name = params['counterReportType']
			filters = client.factory.create('ns1:Filters')
			range = client.factory.create('ns1:Range')
			range.Begin = self.StartDate
			range.End = self.EndDate
			filters.UsageDateRange = range
			reportDefinition.Filters = filters
		
		except Exception,e:
			print "Failed to build SOAP envelope for " + params["wsdlURL"]
			print e
		
		#try sending the request
		response = None
		while True:
			try:
				response = client.service.GetReport(requestor,customer,reportDefinition)
			except WebFault, e:
				print e
				response = None
			except urllib2.HTTPError, e:
				print "Service did not respond at " + params["wsdlURL"]
				print e
				response = None
			except urllib2.URLError,e:
				print "Service did not respond at " + params["wsdlURL"]
				print e
				response = None
			except Exception, e:
				print "Unspecified error reaching service at " + params["wsdlURL"]
				print e
				response = None
			break
		
		#loop through response and break it up into an array (dict)
		try:
			if response.Report != None:
				reportName = response.ReportDefinition._Name
				counterData = []
				for item in response.Report[0][0].Customer[0].ReportItems:
					#Apply different logic based on the report name (ie JR1 DB1 etc)
					#each of these writes the desired data into an array and returns the array
		
					temp_dict = dict()
					if reportName == 'JR1':
						try:
							temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						except AttributeError:
							temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: "",
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
								
					elif reportName == 'JR1a':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
						
					elif reportName == 'JR1GOA':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
								
					elif reportName == 'JR1 GOA':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
								
					elif reportName == 'JR2':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'NoLicense'	: "0",
							'Turnaways' : "0",
							'Other'		: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						try:
							for instance in item.ItemPerformance[0].Instance:
								if instance.MetricType == "no_license":
									temp_dict["NoLicense"] = str(instance.Count)
								elif instance.MetricType == "turnaway":
									temp_dict["Turnaways"] = str(instance.Count)
								elif instance.MetricType == "other":
									temp_dict["Other"] = str(instance.Count)
						except AttributeError:
							for instance in item.ItemPerformance[0].Instance:
								temp_dict["Other"] = str(instance.Count)
								
					elif reportName == 'JR3':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'Abstracts'	: "0",
							'TOC'		: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_EPUB'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						try:
							for instance in item.ItemPerformance[0].Instance:
								if instance.MetricType == "ft_pdf":
									temp_dict["FT_PDF"] = str(instance.Count)
								elif instance.MetricType == "ft_pdf_mobile":
									temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
								elif instance.MetricType == "ft_html":
									temp_dict["FT_HTML"] = str(instance.Count)
								elif instance.MetricType == "ft_html_mobile":
									temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
								elif instance.MetricType == "ft_epub":
									temp_dict["FT_EPUB"] = str(instance.Count)
								elif instance.MetricType == "ft_total":
									temp_dict["FT_TOTAL"] = str(instance.Count)
								elif instance.MetricType == "abstract":
									temp_dict["Abstracts"] = str(instance.Count)
								elif instance.MetricType == "toc":
									temp_dict["TOC"] = str(instance.Count)
						except AttributeError:
							temp_dict["FT_PDF"] = "0"
							temp_dict["FT_PDF_MOBILE"] = "0"
							temp_dict["FT_HTML"] = "0"
							temp_dict["FT_HTML_MOBILE"] = "0"
							temp_dict["FT_EPUB"] = "0"
							temp_dict["FT_TOTAL"] = "0"
							temp_dict["Abstracts"] = "0"
							temp_dict["TOC"] = "0"
								
					elif reportName == 'JR4':
						temp_dict = {
							'ReportName': reportName,
							'PropId'	: "",
							'Platform' 	: item.ItemPlatform,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'Searches'	: "0"
						}	
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set searches and sessions counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["Searches"] = str(instance.Count)
									
					elif reportName == 'DB1':
						temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'RegSearches'	: "0",
							'FedSearches'	: "0",
							'ResClicks'	: "0",
							'RecViews'	: "0"
						}	
					
						#loop through ItemPerformance Instances and test for/set searches and sessions counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["RegSearches"] = str(instance.Count)
							elif instance.MetricType == "search_fed":
									temp_dict["FedSearches"] = str(instance.Count)
							elif instance.MetricType == "result_click":
								temp_dict["ResClicks"] = str(instance.Count)
							elif instance.MetricType == "record_view":
									temp_dict["RecViews"] = str(instance.Count)
									
					elif reportName == 'DB2':
						temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'Turnaways'	: "0"
						}	
						
						#loop through ItemPerformance Instances and test for/set turnaways
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "count":
								temp_dict["Turnaways"] = str(instance.Count)
								
					elif reportName == 'DB3':
						temp_dict = {
							'ReportName': reportName,
							'PropID'	: "",
							'Platform' 	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'RegSessions'	: "0",
							'FedSessions'	: "0",
							'RegSearches'	: "0",
							'FedSearches'	: "0"
						}	
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
						
						#loop through ItemPerformance Instances and test for/set searches and sessions counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["RegSearches"] = str(instance.Count)
							elif instance.MetricType == "search_fed":
									temp_dict["FedSearches"] = str(instance.Count)
							elif instance.MetricType == "session_reg":
								temp_dict["RegSessions"] = str(instance.Count)
							elif instance.MetricType == "session_fed":
									temp_dict["FedSessions"] = str(instance.Count)
									
					elif reportName == 'PR1':
						try:
							temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher' : item.ItemPublisher,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'RegSearches'	: "0",
							'FedSearches'	: "0",
							'ResClicks'	: "0",
							'RecViews'	: "0"
						}
						except AttributeError:
							temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher' : "",
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'RegSearches'	: "0",
							'FedSearches'	: "0",
							'ResClicks'	: "0",
							'RecViews'	: "0"
						}
						#loop through ItemPerformance Instances and test for/set searches and click counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["RegSearches"] = str(instance.Count)
							elif instance.MetricType == "search_fed":
									temp_dict["FedSearches"] = str(instance.Count)
							elif instance.MetricType == "result_click":
								temp_dict["ResClicks"] = str(instance.Count)
							elif instance.MetricType == "record_view":
									temp_dict["RecViews"] = str(instance.Count)

						for instance in item.ItemPerformance[1].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["RegSearches"] = str(instance.Count)
							elif instance.MetricType == "search_fed":
									temp_dict["FedSearches"] = str(instance.Count)
							elif instance.MetricType == "result_click":
								temp_dict["ResClicks"] = str(instance.Count)
							elif instance.MetricType == "record_view":
									temp_dict["RecViews"] = str(instance.Count)
									
					elif reportName == 'MR1':
						temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'MediaRequests'	: "0"
						}	
						
						#loop through ItemPerformance Instances and test for/set turnaways
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "multimedia":
								temp_dict["MediaRequests"] = str(instance.Count)
								
					elif reportName == 'MR2':
						temp_dict = {
							'ReportName': reportName,
							'Platform' 	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'AudioRequests'	: "0",
							'VideoRequests'	: "0"
						}	
						
						#loop through ItemPerformance Instances and test for/set turnaways
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "audio":
								temp_dict["AudioRequests"] = str(instance.Count)
							elif instance.MetricType == "video":
								temp_dict["VideoRequests"] = str(instance.Count)
								
					elif reportName == 'BR1':
						try:
							temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_EPUB'	: "0",
							'FT_TOTAL'	: "0"
						}
						except AttributeError:
							temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: "",
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_EPUB'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "Online_ISBN":
								temp_dict["OnlineISBN"] = identifier.Value
							elif identifier.Type == "Print_ISBN":
								temp_dict["PrintISBN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
							elif instance.MetricType == "sectioned_html":
								temp_dict["SEC_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_epub":
								temp_dict["FT_EPUB"] = str(instance.Count)
								
					elif reportName == 'BR2':
						try:
							temp_dict = {
							'ReportName': reportName,
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_TOTAL'	: "0"
						}
						except AttributeError:
							temp_dict = {
							'ReportName': reportName,
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: "",
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						try:
							for identifier in item.ItemIdentifier:
								if identifier.Type == "Online_ISBN":
									temp_dict["OnlineISBN"] = identifier.Value
								elif identifier.Type == "Print_ISBN":
									temp_dict["PrintISBN"] = identifier.Value
								elif identifier.Type == "DOI":
									temp_dict["DOI"] = identifier.Value
								elif identifier.Type == "Proprietary":
									temp_dict["PropId"] = identifier.Value
						except AttributeError:
							temp_dict["PropId"] = "N/A"

						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "sectioned_html":
								temp_dict["SEC_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
								
					elif reportName == 'BR3':
						temp_dict = {
							'ReportName': reportName,
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'NoLicense'	: "0",
							'Turnaways' : "0",
							'Other'     : "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						try:
							for identifier in item.ItemIdentifier:
								if identifier.Type == "Online_ISBN":
									temp_dict["OnlineISBN"] = identifier.Value
								elif identifier.Type == "Print_ISBN":
									temp_dict["PrintISBN"] = identifier.Value
								elif identifier.Type == "DOI":
									temp_dict["DOI"] = identifier.Value
								elif identifier.Type == "Proprietary":
									temp_dict["PropId"] = identifier.Value
						except AttributeError:
							temp_dict["PropId"] = "N/A"
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						try:
							for instance in item.ItemPerformance[0].Instance:
								if instance.MetricType == "no_license":
									temp_dict["NoLicense"] = str(instance.Count)
								elif instance.MetricType == "turnaway":
									temp_dict["Turnaways"] = str(instance.Count)
								elif instance.MetricType == "other":
									temp_dict["Other"] = str(instance.Count)
						except AttributeError:
							temp_dict["NoLicense"] = "0"
							temp_dict["Turnaways"] = "0"
							temp_dict["Other"] = "0"
								
					elif reportName == 'BR4':
						temp_dict = {
							'ReportName': reportName,
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'NoLicense'	: "0",
							'Turnaways' : "0",
							'Other'     : "0"
						}
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "no_license":
								temp_dict["NoLicense"] = str(instance.Count)
							elif instance.MetricType == "turnaway":
								temp_dict["Turnaways"] = str(instance.Count)
							elif instance.MetricType =="other":
								temp_dict["Other"] = str(instance.Count)
								
					elif reportName == 'BR5':
						temp_dict = {
							'ReportName': reportName,
							'PropId'	: "",
							'Platform' 	: item.ItemPlatform,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'Searches'	: "0"
						}	
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set searches and sessions counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "search_reg":
								temp_dict["Searches"] = str(instance.Count)
								
					elif reportName == 'TR1':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "Online_ISBN":
								temp_dict["OnlineISBN"] = identifier.Value
							elif identifier.Type == "Print_ISBN":
								temp_dict["PrintISBN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
							elif instance.MetricType == "sectioned_html":
								temp_dict["SEC_HTML"] = str(instance.Count)
								
					elif reportName == 'TR2':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'NoLicense'	: "0",
							'Turnaways' : "0",
							'Other'		: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "Online_ISBN":
								temp_dict["OnlineISBN"] = identifier.Value
							elif identifier.Type == "Print_ISBN":
								temp_dict["PrintISBN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "no_license":
								temp_dict["NoLicense"] = str(instance.Count)
							elif instance.MetricType == "turnaway":
								temp_dict["Turnaways"] = str(instance.Count)
							elif instance.MetricType == "other":
								temp_dict["Other"] = str(instance.Count)
								
					elif reportName == 'TR3':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'Abstracts'	: "0",
							'TOC'		: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_EPUB'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "Online_ISBN":
								temp_dict["OnlineISBN"] = identifier.Value
							elif identifier.Type == "Print_ISBN":
								temp_dict["PrintISBN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_epub":
								temp_dict["FT_EPUB"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
							elif instance.MetricType == "abstract":
								temp_dict["Abstracts"] = str(instance.Count)
							elif instance.MetricType == "toc":
								temp_dict["TOC"] = str(instance.Count)
								
					elif reportName == 'CR1':
						temp_dict = {
							'ReportName': reportName,
							'PrintISSN'	: "",
							'OnlineISSN': "",
							'PrintISBN'	: "",
							'OnlineISBN': "",
							'DOI'		: "",
							'PropId'	: "",
							'Platform'	: item.ItemPlatform,
							'Publisher'	: item.ItemPublisher,
							'Name'		: item.ItemName,
							'Type'		: item.ItemDataType,
							'DateBeginSQL': item.ItemPerformance[0].Period.Begin.strftime('%Y%m%d'),
							'DateBegin'	: item.ItemPerformance[0].Period.Begin.strftime('%Y-%m-%d'),
							'DateEndSQL': item.ItemPerformance[0].Period.End.strftime('%Y%m%d')+"235959", #adds a string containing hour, minute, second to make it the end of the day 
							'DateEnd'	: item.ItemPerformance[0].Period.End.strftime('%Y-%m-%d'),
							'SEC_HTML'	: "0",
							'FT_HTML'	: "0",
							'FT_HTML_MOBILE'	: "0",
							'FT_PDF'	: "0",
							'FT_PDF_MOBILE'	: "0",
							'FT_TOTAL'	: "0"
						}
						#loop through ItemIdentifiers and test for/set print and online issns
						for identifier in item.ItemIdentifier:
							if identifier.Type == "Online_ISSN":
								temp_dict["OnlineISSN"] = identifier.Value
							elif identifier.Type == "Print_ISSN":
								temp_dict["PrintISSN"] = identifier.Value
							elif identifier.Type == "Online_ISBN":
								temp_dict["OnlineISBN"] = identifier.Value
							elif identifier.Type == "Print_ISBN":
								temp_dict["PrintISBN"] = identifier.Value
							elif identifier.Type == "DOI":
								temp_dict["DOI"] = identifier.Value
							elif identifier.Type == "Proprietary":
								temp_dict["PropId"] = identifier.Value
								
						#loop through ItemPerformance Instances and test for/set pdf, html, and total counts
						for instance in item.ItemPerformance[0].Instance:
							if instance.MetricType == "ft_pdf":
								temp_dict["FT_PDF"] = str(instance.Count)
							elif instance.MetricType == "ft_pdf_mobile":
								temp_dict["FT_PDF_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_html":
								temp_dict["FT_HTML"] = str(instance.Count)
							elif instance.MetricType == "ft_html_mobile":
								temp_dict["FT_HTML_MOBILE"] = str(instance.Count)
							elif instance.MetricType == "ft_total":
								temp_dict["FT_TOTAL"] = str(instance.Count)
							elif instance.MetricType == "sectioned_html":
								temp_dict["SEC_HTML"] = str(instance.Count)
							
					#loop through Item dictionary and replace None (null) data types with empty strings
					for key in temp_dict:
						if temp_dict[key] == None:
							temp_dict[key] = ''
						
					#add Item dictionary to counterData list
					counterData.append(temp_dict)
					
				#end FOR loop, return data	
				return counterData
		except Exception,e:
			print "Error parsing SOAP response from " + params["wsdlURL"]
			print e
		
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------		
			
	def WriteResponseCSV(self,counterData,files): #writes the SOAP response from the SUSHI server to a CSV file
		import csv
		
		#check report type of current counter data to determine which file to write to, and also declare what the column titles should be
		if counterData[0]["ReportName"] == "JR1":
			outputFile = files["JR1"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		elif counterData[0]["ReportName"] == "JR1a":
			outputFile = files["JR1a"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		elif counterData[0]["ReportName"] == "JR1GOA":
			outputFile = files["JR1GOA"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		elif counterData[0]["ReportName"] == "JR1 GOA":
			outputFile = files["JR1 GOA"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		elif counterData[0]["ReportName"] == "JR2":
			outputFile = files["JR2"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','No License','Turnaways','Other']
		elif counterData[0]["ReportName"] == "JR3":
			outputFile = files["JR3"]
			headerRow = ['PrintISSN','OnlineISSN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','abstracts','toc','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_epub','ft_total']
		elif counterData[0]["ReportName"] == "JR4":
			outputFile = files["JR4"]
			headerRow = ['PropId','Platform','Name','Item Type','Report Begin','Report End','Searches']
		elif counterData[0]["ReportName"] == "DB1":
			outputFile = files["DB1"]
			headerRow = ['Platform','Publisher','Name','Item Type','Report Begin','Report End','Regular Searches','Federated Searches','Result Clicks','Record Views']
		elif counterData[0]["ReportName"] == "DB2":
			outputFile = files["DB2"]
			headerRow = ['Platform','Publisher','Name','Item Type','Report Begin','Report End','Turnaways']
		elif counterData[0]["ReportName"] == "DB3":
			outputFile = files["DB3"]
			headerRow = ['Proprietary Identifier','Platform','Publisher','Name','Item Type','Report Begin','Report End','Regular Sessions','Federated Sessions','Regular Searches','Federated Searches']
		elif counterData[0]["ReportName"] == "PR1":
			outputFile = files["PR1"]
			headerRow = ['Platform','Publisher','Item Type','Report Begin','Report End','Regular Searches','Federated Searches','Result Clicks','Record Views']
		elif counterData[0]["ReportName"] == "MR1":
			outputFile = files["MR1"]
			headerRow = ['Platform','Publisher','Name','Item Type','Report Begin','Report End','Media Requests']
		elif counterData[0]["ReportName"] == "MR2":
			outputFile = files["MR1"]
			headerRow = ['Platform','Publisher','Name','Item Type','Report Begin','Report End','Audio Requests','Video Requests']
		elif counterData[0]["ReportName"] == "BR1":
			outputFile = files["BR1"]
			headerRow = ['PrintISSN','OnlineISSN','PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','Sectioned HTML','ft_html', 'ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_epub','ft_total']
		elif counterData[0]["ReportName"] == "BR2":
			outputFile = files["BR2"]
			headerRow = ['PrintISBN', 'OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','Sectioned HTML','ft_total']
		elif counterData[0]["ReportName"] == "BR3":
			outputFile = files["BR3"]
			headerRow = ['PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','No License','Turnaways','Other']
		elif counterData[0]["ReportName"] == "BR4":
			outputFile = files["BR4"]
			headerRow = ['Platform','Publisher','Name','Item Type','Report Begin','Report End','No License','Turnaways','Other']
		elif counterData[0]["ReportName"] == "BR5":
			outputFile = files["BR5"]
			headerRow = ['PropId','Platform','Name','Item Type','Report Begin','Report End','Searches']
		elif counterData[0]["ReportName"] == "TR1":
			outputFile = files["TR1"]
			headerRow = ['PrintISSN','OnlineISSN','PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','Sectioned HTML','ft_html', 'ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		elif counterData[0]["ReportName"] == "TR2":
			outputFile = files["TR2"]
			headerRow = ['PrintISSN','OnlineISSN','PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','No License','Turnaways','Other']
		elif counterData[0]["ReportName"] == "TR3":
			outputFile = files["TR3"]
			headerRow = ['PrintISSN','OnlineISSN','PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','abstracts','toc','ft_html','ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_epub','ft_total']
		elif counterData[0]["ReportName"] == "CR1":
			outputFile = files["CR1"]
			headerRow = ['PrintISSN','OnlineISSN','PrintISBN','OnlineISBN','DOI','PropId','Platform','Publisher','Name','Item Type','Report Begin','Report End','Sectioned HTML','ft_html', 'ft_html_mobile','ft_pdf','ft_pdf_mobile','ft_total']
		
		#read output file to see if it currently has data
		rowcount = 0
		try:
			reader = csv.reader(open(outputFile,'rb'))
			for row in reader:
				rowcount += 1
		except:
			rowcount = rowcount
		
		#create a writer object and fill file with data. 
		if rowcount == 0:
			#Use 'w' write mode if the file does not yet exist
			csvfile = open(outputFile, 'wb')
			writer = csv.writer(csvfile)
			#Write a header row with column names
			writer.writerow(headerRow)
		else:
			csvfile = open(outputFile, 'ab')
			writer = csv.writer(csvfile)
			#use 'a' append mode if file does exist already
		
		i = 0
		rowsWritten = 0
		for row in counterData:
			try:
				if counterData[0]["ReportName"] == "JR1":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],
							counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR1a":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],
							counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR1GOA":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],
							counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR1 GOA":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],
							counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR2":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['NoLicense'],
							counterData[i]['Turnaways'],counterData[i]['Other']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR3":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['Abstracts'],counterData[i]['TOC'],
							counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_EPUB'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "JR4":
					data = [
							counterData[i]['PropId'],counterData[i]['Platform'],
							counterData[i]['Name'],counterData[i]['Type'],counterData[i]['DateBegin'],
							counterData[i]['DateEnd'],counterData[i]['Searches']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "DB1":
					data = [
						counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['RegSearches'],counterData[i]['FedSearches'],counterData[i]['ResClicks'],counterData[i]['RecViews']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "DB2":
					data = [
						counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['Turnaways']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "DB3":
					data = [
						counterData[i]['PropId'],counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['RegSessions'],counterData[i]['FedSessions'],counterData[i]['RegSearches'],counterData[i]['FedSearches']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "PR1":
					data = [
						counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Type'],counterData[i]['DateBegin'],counterData[i]["DateEnd"],
						counterData[i]["RegSearches"],counterData[i]["FedSearches"],counterData[i]["ResClicks"],counterData[i]["RecViews"]
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "MR1":
					data = [
						counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['MediaRequests']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "MR2":
					data = [
						counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['AudioRequests'],counterData[i]['VideoRequests']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "BR1":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['SEC_HTML'],counterData[i]['FT_HTML'],
							counterData[i]['FT_HTML_MOBILE'],counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_EPUB'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "BR2":
					data = [
						counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
						counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['SEC_HTML'],counterData[i]['FT_TOTAL']
					]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "BR3":
					data = [
							counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropID'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['NoLicense'],
							counterData[i]['Turnaways'],counterData[i]['Other']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "BR4":
					data = [
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['NoLicense'],
							counterData[i]['Turnaways'], counterData[i]['Other']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "BR5":
					data = [
							counterData[i]['PropId'],counterData[i]['Platform'],
							counterData[i]['Name'],counterData[i]['Type'],counterData[i]['DateBegin'],
							counterData[i]['DateEnd'],counterData[i]['Searches']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "TR1":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['SEC_HTML'],counterData[i]['FT_HTML'],
							counterData[i]['FT_HTML_MOBILE'],counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "TR2":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['NoLicense'],
							counterData[i]['Turnaways'],counterData[i]['Other']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "TR3":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['Abstracts'],counterData[i]['TOC'],
							counterData[i]['FT_HTML'],counterData[i]['FT_HTML_MOBILE'],counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_EPUB'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				elif counterData[0]["ReportName"] == "CR1":
					data = [
							counterData[i]['PrintISSN'],counterData[i]['OnlineISSN'],counterData[i]['PrintISBN'],counterData[i]['OnlineISBN'],counterData[i]['DOI'],counterData[i]['PropId'],
							counterData[i]['Platform'],counterData[i]['Publisher'],counterData[i]['Name'],counterData[i]['Type'],
							counterData[i]['DateBegin'],counterData[i]['DateEnd'],counterData[i]['SEC_HTML'],counterData[i]['FT_HTML'],
							counterData[i]['FT_HTML_MOBILE'],counterData[i]['FT_PDF'],counterData[i]['FT_PDF_MOBILE'],counterData[i]['FT_TOTAL']
						]
					writer.writerow(data)
				#add a counter to track how many rows were written
				rowsWritten += 1
			except Exception,e:
				print "Failed to write on row " + str(i) + "."
				print e
			
			i += 1
			
		print str(rowsWritten) + " rows written to file " + outputFile + "."
		csvfile.close()
		
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
	def WriteResponseSQL(self,hostname,username,password,database,counterData,tableNames): #write the SOAP response from the SUSHI server to a MySQL table
		import MySQLdb as mdb
		import sys
		import unicodedata
		
		#start by looping through all the data and escaping characters to make it sql-friendly and also remove non-ascii unicode so python doesn't choke
		try:
			for i in range (0,len(counterData)):
				for key in counterData[i]:
					try:
						counterData[i][key].decode('ascii')
					except UnicodeEncodeError:
						counterData[i][key] = mdb.escape_string(unicodedata.normalize('NFKD',counterData[i][key]).encode('ascii','ignore'))		
					else:
						counterData[i][key] = mdb.escape_string(counterData[i][key])
					# try:
						# counterData[i][key] = unicodedata.normalize('NFKD',mdb.escape_string(counterData[i][key])).encode('ascii','ignore')
					# except Exception:
						# counterData[i][key] = mdb.escape_string(counterData[i][key])
			
			try:
				#declare a placeholder string for the insert query
				insertQuery = ''
				
				#loop through each counterData item and add it to the query
				for i in range (0,len(counterData)):
				
					#create a query based on the COUNTER report type
					if counterData[i]["ReportName"] == 'JR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR1"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ','  + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR1a':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR1a"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ','  + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR1GOA':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR1GOA"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ','  + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR1 GOA':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR1 GOA"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ','  + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR2':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR2"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,no_license,turnaways,other_reason)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\r\n\
							\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['NoLicense'] + ',' + counterData[i]['Turnaways'] + ',' + counterData[i]['Other']+ ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR3':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR3"] + ' \
							(print_issn,online_issn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,abstracts,toc,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_epub,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['Abstracts'] + ',' + counterData[i]['TOC'] + ',' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ','  + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_EPUB'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'JR4':
						
						queryPart1 = 'INSERT INTO ' + tableNames["JR4"] + ' \
							(proprietary_identifier,platform,item_name,data_type,date_begin,date_end,searches)\
							VALUES ' 
						
						queryPart2 = '(\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Name'] + '\',\r\n\
							' + counterData[i]['Type'] + ',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['Searches'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'DB1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["DB1"] + ' \
							(platform,publisher,item_name,data_type,date_begin,date_end,reg_searches,fed_searches,res_clicks,rec_views)\
							VALUES ' 
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',\r\n\
							' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['RegSearches'] + ',' + counterData[i]['FedSearches'] + ',' + counterData[i]['ResClicks'] + ',' + counterData[i]['RecViews'] + ')\r\n'
							
					elif counterData[i]["ReportName"] == 'DB2':
						
						queryPart1 = 'INSERT INTO ' + tableNames["DB2"] + ' \
							(platform,publisher,item_name,data_type,date_begin,date_end,turnaways)\
							VALUES '
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',\r\n\
							' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['Turnaways'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'DB3':
						
						queryPart1 = 'INSERT INTO ' + tableNames["DB3"] + ' \
							(proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,reg_sessions,fed_sessions,reg_searches,fed_searches)\
							VALUES ' 
						
						queryPart2 = '(\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',\r\n\
							' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['RegSessions'] + ',' + counterData[i]['FedSessions'] + ',' + counterData[i]['RegSearches'] + ',' + counterData[i]['FedSearches'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'PR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["PR1"] + ' \
							(platform,publisher,data_type,date_begin,date_end,reg_searches,fed_searches,res_clicks,rec_views)\
							VALUES '
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Type'] + '\',\'' + counterData[i]['DateBeginSQL'] + '\',\r\n\
							' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['RegSearches'] + ',' + counterData[i]['FedSearches'] + ',' + counterData[i]['ResClicks'] + ',' + counterData[i]['RecViews'] + ')\r\n'
					
					elif counterData[i]["ReportName"] == 'MR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["MR1"] + ' \
							(platform,publisher,item_name,data_type,date_begin,date_end,media_requests)\
							VALUES '
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',\r\n\
							' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['MediaRequests'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'MR2':
						
						queryPart1 = 'INSERT INTO ' + tableNames["MR2"] + ' \
							(platform,publisher,item_name,data_type,date_begin,date_end,audio_requests,video_requests)\
							VALUES '
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',\r\n\
							' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['AudioRequests'] + ',' + counterData[i]['VideoRequests'] + ')\r\n'

					elif counterData[i]["ReportName"] == 'BR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["BR1"] + ' \
							(print_issn,online_issn,print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,sec_html,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_epub,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['SEC_HTML'] + ',' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ',' + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_EPUB'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
					
					elif counterData[i]["ReportName"] == 'BR2':
						
						queryPart1 = 'INSERT INTO ' + tableNames["BR2"] + ' \
							(print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,sec_html,ft_total)\
							VALUES '
						
						queryPart2 = '(\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['SEC_HTML'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'BR3':
						
						queryPart1 = 'INSERT INTO ' + tableNames["BR3"] + ' \
							(print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,no_license,turnaways,other_reason)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\r\n\
							\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['NoLicense'] + ',' + counterData[i]['Turnaways'] + ',' + counterData[i]['Other'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'BR4':
						
						queryPart1 = 'INSERT INTO ' + tableNames["BR4"] + ' \
							(platform,publisher,item_name,data_type,date_begin,date_end,no_license,turnaways,other_reason)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\r\n\
							\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['NoLicense'] + ',' + counterData[i]['Turnaways'] + ',' + counterData[i]['Other'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'BR5':
						
						queryPart1 = 'INSERT INTO ' + tableNames["BR5"] + ' \
							(proprietary_identifier,platform,item_name,data_type,date_begin,date_end,searches)\
							VALUES ' 
						
						queryPart2 = '(\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Name'] + '\',\r\n\
							' + counterData[i]['Type'] + ',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',' + counterData[i]['Searches'] + ')\r\n'
					
					elif counterData[i]["ReportName"] == 'TR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["TR1"] + ' \
							(print_issn,online_issn,print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,sec_html,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['SEC_HTML'] + ',' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ',' + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'TR2':
						
						queryPart1 = 'INSERT INTO ' + tableNames["TR2"] + ' \
							(print_issn,online_issn,print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,no_license,turnaways,other_reason)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\'' + counterData[i]['Publisher'] + '\',\r\n\
							\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['NoLicense'] + ',' + counterData[i]['Turnaways'] + ',' + counterData[i]['Other']+ ')\r\n'
						
					elif counterData[i]["ReportName"] == 'TR3':
						
						queryPart1 = 'INSERT INTO ' + tableNames["TR3"] + ' \
							(print_issn,online_issn,print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,abstracts,toc,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_epub,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['Abstracts'] + ',' + counterData[i]['TOC'] + ',' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ',' + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_EPUB'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
						
					elif counterData[i]["ReportName"] == 'CR1':
						
						queryPart1 = 'INSERT INTO ' + tableNames["CR1"] + ' \
							(print_issn,online_issn,print_isbn,online_isbn,doi,proprietary_identifier,platform,publisher,item_name,data_type,date_begin,date_end,sec_html,ft_pdf,ft_pdf_mobile,ft_html,ft_html_mobile,ft_total)\
							VALUES \r\n'
						
						queryPart2 = '(\'' + counterData[i]['PrintISSN'] + '\',\'' + counterData[i]['OnlineISSN'] + '\',\'' + counterData[i]['PrintISBN'] + '\',\'' + counterData[i]['OnlineISBN'] + '\',\'' + counterData[i]['DOI'] + '\',\'' + counterData[i]['PropId'] + '\',\'' + counterData[i]['Platform'] + '\',\r\n\
							\'' + counterData[i]['Publisher'] + '\',\'' + counterData[i]['Name'] + '\',\'' + counterData[i]['Type'] + '\',' + counterData[i]['DateBeginSQL'] + ',' + counterData[i]['DateEndSQL'] + ',\r\n\
							' + counterData[i]['SEC_HTML'] + ',' + counterData[i]['FT_PDF'] + ',' + counterData[i]['FT_PDF_MOBILE'] + ',' + counterData[i]['FT_HTML'] + ',' + counterData[i]['FT_HTML_MOBILE'] + ',' + counterData[i]['FT_TOTAL'] + ')\r\n'
					
					#put together parts of the query. For all iterations of loop after the first, we will only add the values part of the insert statement
					if i == 0:
						insertQuery = queryPart1 + queryPart2
					else:
						insertQuery += ',' + queryPart2
					
				#make sure insertQuery is set and then execute
				if insertQuery != None:
					con = mdb.connect(hostname,username,password,database)
					cur = con.cursor()
					
					try:
						#Execute the SQL command
						cur.execute(insertQuery)
						
						# Commit your changes in the database
						con.commit()
						print "Data written successfully to database for " + counterData[0]["Platform"] + " " + counterData[0]["ReportName"] + "."
					except Exception,e:
						#Rollback in case there is any error
						con.rollback()
						print "There was an error inserting the data for " + counterData[0]["Platform"] + " " + counterData[0]["ReportName"] + "."
						print e
						
					#close connection
					if con:
						con.close()
						
			
			except Exception,e:
				print e
		
		except Exception,e:
			print "No data to write to SQL."
			print e
