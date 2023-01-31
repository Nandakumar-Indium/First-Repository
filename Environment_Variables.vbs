
Dim ObjEnvironment
Set ObjEnvironment = New EnvironmentVariables
Class EnvironmentVariables
	Public str_Cur_AppName,str_Prev_AppName
	Public str_Cur_modulename,str_Prev_moduleName
	Public str_Cur_SubModuleName,str_Prev_SubModuleName
	Public str_Cur_TestCaseName,str_Prev_TestCaseName
	Public str_Cur_TestCaseDesc,str_Prev_TestCaseDesc
	Public str_Environ_Driver_path,str_Environ_Frame_Path,str_environ_Exec_setting_file_path
	Public str_Environ_Client_Name,str_Environ_Environment,str_Environ_Browser,str_Environ_Browser_Version, str_Environ_Application_Url
	Public str_suite_data_file_name
	Public bln_App_Selection
	Public dict_test_data
	Public edict_test_data
	Public ResultScreenshotPath
	Public objXMLroot,objXMLCustomReport,objXMLTestSuite,objXMLStep,objXMLTestCase,objXMLDataSet
	Public str_Report_Screenshot_Path,str_Report_Path,str_Extras_Path
	Public str_Report_Images_Path,str_Report_Extras_Path
	Public str_XSL_Path,str_XML_Path
	'newly added
	Public appStatus
	Public testCaseList
	Public dataSetList
	Public IterationStatus
	Public IterationTestStepFailureCount
	Public IterationTestStepPassCount

function CreateXML_for_reporting(str_path)
	Set xmlDoc = CreateObject("Microsoft.XMLDOM") 
	xmlDoc.save str_path
End Function


	Function createXMLnodes(str_report_path)
			Dim XMLFileHeader,CurrentTestPath
			Set oFSO = CreateObject("Scripting.FileSystemObject")
			'Newly modified (Removed XSL call from header)
			XMLFileHeader = "<?xml version='1.0' encoding='UTF-8'?><Report></Report>"
			Set objXMLCustomReport = XMLUtil.CreateXML() 
			objXMLCustomReport.Load XMLFileHeader
			'ObjEnvironment.objXMLCustomReport = objXMLCustomReport
			Set objXMLroot = objXMLCustomReport.GetRootElement()
			'newly added
			objXMLroot.AddChildElementByName "Result", ""
			'ObjEnvironment.objXMLroot = objXMLroot
			objXMLCustomReport.SaveFile str_XML_Path
			'newly added for TC iteartion
			Set testCaseList = CreateObject("System.Collections.ArrayList")
			'newly added
			Set dataSetList = CreateObject("System.Collections.ArrayList")
	End Function

'newly added
Public Function UpdateReportNodeInReportFile(Client_Name, Environment, Browser, Browser_Version)
		objXMLroot.AddAttribute "Date", Date() & " " & Time()
		objXMLroot.AddAttribute "Client_Name", Client_Name
		objXMLroot.AddAttribute "Environment", Environment
		objXMLroot.AddAttribute "Browser_and_Version", Browser & "/" & Browser_Version
End Function

'newly modified
Public Function CreateAppNodeInReportFile(str_Cur_TestCaseName,Client_Name, Environment, Browser, Release_Number,str_Cur_TestCaseDesc,App_URL)
		objXMLroot.AddChildElementByName "AppName", ""
		Set objXMLTestSuite = objXMLroot.ChildElements().Item(objXMLroot.ChildElements().count())
		'objXMLTestSuite.AddAttribute "Client_Name" , Client_Name
		'newly added
		objXMLTestSuite.AddAttribute "Test_Case_No" , "1"
		objXMLTestSuite.AddAttribute "Test_Case_Name" , str_Cur_TestCaseName
		'
		' objXMLTestSuite.AddAttribute "Browser" , Browser
		' objXMLTestSuite.AddAttribute "Release_Number" , Release_Number
		objXMLTestSuite.AddAttribute "Test_Case_Description" , str_Cur_TestCaseDesc
		'objXMLTestSuite.AddAttribute "Environment" , Environment
		
		'objXMLTestSuite.AddAttribute "App_URL" , App_URL
		' objXMLTestSuite.AddAttribute "AppExeTime" , Environment
		' objXMLTestSuite.AddAttribute "AppStatus" , Environment
		objXMLCustomReport.SaveFile str_XML_Path
		'newly added for TC iteartion
		testCaseList.Add str_Cur_TestCaseName
	End Function

	'newly added
	Public Function UpdateAppStatus()
		objXMLTestSuite.AddAttribute "AppStatus" , appStatus
	End Function
	
	Public Function UpdateAppNodeInReportFile(appExecutionTime)
		objXMLTestSuite.AddAttribute "AppExeTime" , appExecutionTime
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	
	Public Function CreateTestCaseNodeInReportFile(str_Cur_TestCaseName,str_Cur_TestCaseDesc)
		objXMLTestSuite.AddChildElementByName "TestCase", ""
		Set objXMLTestCase = objXMLTestSuite.ChildElements().Item(objXMLTestSuite.ChildElements().count())
		objXMLTestCase.AddAttribute "TestCaseName" , str_Cur_TestCaseName
		objXMLTestCase.AddAttribute "TestCaseDesc" , str_Cur_TestCaseDesc
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	
	Public Function UpdateTestCaseNodeInReportFile(testCaseExeTime)
		objXMLTestCase.AddAttribute "TestCaseExeTime" , testCaseExeTime
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	'newly added /To create  dataset node inside Testcase
	Public Function CreateDataSetNodeInReportFile(str_Cur_DataSetNo,str_Cur_TestCaseName,str_Cur_TestDataDesc)
		objXMLTestCase.AddChildElementByName "Dataset", ""
		Set objXMLDataSet = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		objXMLDataSet.AddAttribute "id" , "Dataset_" & str_Cur_DataSetNo
			'newly added		
		objXMLDataSet.AddAttribute "Test_Case_Name" , str_Cur_TestCaseName
		objXMLDataSet.AddAttribute "TC_Data_Desc" , str_Cur_TestDataDesc
		''''''''''''''''''''''''''
		dataSetList.Add "Dataset_" & str_Cur_DataSetNo
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	'newly added for dataset
	Public Function UpdateDataSetNodeInReportFile(passSteps,failSteps,ExeTime,Status)
		
		objXMLDataSet.AddAttribute "PassedSteps" , passSteps
		objXMLDataSet.AddAttribute "FailedSteps" ,failSteps
		objXMLDataSet.AddAttribute "Duration" , ExeTime
		objXMLDataSet.AddAttribute "Status" , Status
		objXMLCustomReport.SaveFile str_XML_Path
	End Function

	'newly added
	Public Function UpdateDurationNodeInReportFile(TotalDuration)
		objXMLroot.AddAttribute "TotalDuration", TotalDuration
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	
	'newly modified
	Public Function ApplyXSL()
		Dim sXMLLib, xmlDoc, xslDoc, outputText, outFile 'resultNode, xmlDocCurrentTC, outFileTC, outputTextTC, xslDocTC, xmlDocCurrentTC
		Dim xsl, template, processor
		sXMLLib = "MSXML.DOMDocument"
		Set xmlDoc = CreateObject(sXMLLib)
		Set xslDoc = CreateObject(sXMLLib)
		xmlDoc.async = False
		xslDoc.async = False
		xslDoc.load str_Report_Path &"\Images\"& "Report_Summary.xsl"
		xmlDoc.load str_XML_Path
		outputText = xmlDoc.transformNode(xslDoc.documentElement)
		Set oFSO = CreateObject("Scripting.FileSystemObject")
		Set outFile = oFSO.CreateTextFile(str_Report_Path & "\ReportTest.html",True)
		outFile.Write outputText
		outFile.Close

		'newly added
		For each testCase in testCaseList	

			xmlDoc.selectsinglenode("Report/Result").text = testCase
			xmlDoc.save(str_XML_Path)

			
			Set xmlDocCurrentTC = CreateObject("MSXML.DOMDocument")
			xmlDocCurrentTC.async = False
			xmlDocCurrentTC.load str_XML_Path


			sXMLLibTC = "MSXML.DOMDocument"
			Set xslDocTC = CreateObject(sXMLLibTC)
			xslDocTC.async = False
			xslDocTC.load str_Report_Path &"\Images\"& "Report_Results.xsl"
			outputTextTC = xmlDocCurrentTC.transformNode(xslDocTC.documentElement)
			Set oFSOTC = CreateObject("Scripting.FileSystemObject")
			Set outFileTC = oFSO.CreateTextFile(str_Report_Path & "\Results\" & testCase & ".html",True)
			outFileTC.Write outputTextTC
			outFileTC.Close
			
			'newly added below for loop for dataset
				For each dataset in datasetList	
		

		
					
					
					Set xmlDocCurrentDS = CreateObject("MSXML2.FreeThreadedDOMDocument")
					xmlDocCurrentDS.async = False
					xmlDocCurrentDS.load str_XML_Path
		
		
					sXMLLibDS = "MSXML.DOMDocument"
					
					Set xslDocDS = CreateObject("MSXML2.FreeThreadedDOMDocument")
					xslDocDS.async = False
					xslDocDS.load str_Report_Path &"\Images\"& "DataSetPage.xslt"
					'''''''''''''''''''''''''''''''''
					
					 set xslt = CreateObject("MSXML2.XSLTemplate") 'The XSL stylesheet document must be free threaded in order to be used with the XSLTemplate object.
			           
			               set xslt.stylesheet = xslDocDS
			               Set xslProc = xslt.createProcessor()
			               xslProc.input = xmlDocCurrentDS
			               xslProc.addParameter "dataSetID", dataset
			               xslProc.transform
			               outputTextDS = xslProc.output
			               
			               set xslProc = nothing
			               set xslt = nothing
			
					Set oFSODS = CreateObject("Scripting.FileSystemObject")
					Set outFileDS = oFSO.CreateTextFile(str_Report_Path & "\Results\" & testCase &"_" & dataset & ".html",True)
					outFileDS.Write outputTextDS
					outFileDS.Close
				Next
			' xslDocTC = Nothing
			' outFileTC = Nothing
			' xmlDocCurrentTC = Nothing

		Next

		Set resultNode = xmlDoc.selectsinglenode("Report/Result")
  		resultNode.parentNode.removeChild(resultNode)
		xmlDoc.save(str_XML_Path)

		Set outFile = Nothing
		Set xmlDoc = Nothing
		Set xslDoc = Nothing
	End Function
	
	
	
	
		''' <summary>
    ''' Create a passed Step into XML document and report in QTP
    ''' </summary>
    ''' <param name="arr" type="array">a array with combination of the Step Description/expect result/actual result/link to file</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	Public Function ReportPass(ByVal arr, ByVal bCaptureScreenshot)
	IterationTestStepPassCount=IterationTestStepPassCount+1
		Call AddStepNode(arr, "Pass", bCaptureScreenshot)
		objXMLCustomReport.SaveFile str_XML_Path
		'newly commented
		' ObjReports.ReportPass arr,bCaptureScreenshot
		Select Case UBound(arr) 
			Case 0 
				'report in QTP
				Reporter.ReportEvent micPass,arr(0),""
			Case 1
				'report in QTP
				Reporter.ReportEvent micPass,arr(0),arr(1)
			Case Else
				'report in QTP
				Reporter.ReportEvent micPass,arr(0),arr(2)	
		End select
	End Function


	''' <summary>
    ''' Create a failed Step into XML document and report in QTP
    ''' </summary>
    ''' <param name="arr" type="array">a array with combination of the Step Description/expect result/actual result/link to file</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
   	Public Function ReportFail(ByVal arr, ByVal bCaptureScreenshot)
	   appStatus = "Fail"
	   IterationStatus="Fail"
	   IterationTestStepFailureCount=IterationTestStepFailureCount+1
		Call AddStepNode(arr, "Fail", bCaptureScreenshot)		
		objXMLCustomReport.SaveFile str_XML_Path
		'newly commented
		' ObjReports.ReportFail arr,bCaptureScreenshot
		Select Case UBound(arr)
			Case 0 
				'report in QTP
				Reporter.ReportEvent micFail,arr(0),""
			Case 1
				'report in QTP
				Reporter.ReportEvent micFail,arr(0),arr(1)
			Case Else
				'report in QTP
				Reporter.ReportEvent micFail,arr(0),arr(1) & " but " & arr(2)	
		End select
	End Function

	Public Function ReportInfo(ByVal msg)
		Call AddStepNodeWithDetail(msg, msg, "Info", false)		
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	
	''' <summary>
    ''' Create Step Node into XML document
    ''' </summary>
    ''' <param name="arr" type="array">a array with combination of the Step Description/expect result/actual result/link to file</param>
    ''' <param name="strStatus" type="string">"1" represents Pass, "2" represents Fail</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	Public Function AddStepNode(ByVal arr, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim v1, v2, v3, v4, strExtensionName
		Select Case UBound(arr)
			Case 0
				v1 = arr(0)
				Call AddStepNodeWithoutResult(v1, strStatus, bCaptureScreenshot)
			Case 1
				v1 = arr(0)
				v2 = arr(1)
				Call AddStepNodeWithDetail(v1, v2, strStatus, bCaptureScreenshot)
			Case 2
				v1 = arr(0)
				v2 = arr(1)
				v3 = arr(2)
				Call AddStepNodeWithResult(v1, v2, v3, strStatus, bCaptureScreenshot)
			Case 3
				v1 = arr(0)
				v2 = arr(1)
				v3 = arr(2)
				v4 = arr(3)
				Call AddStepNodeWithResultAndLinkTOFile(v1, v2, v3, v4, strStatus, bCaptureScreenshot)
			Case Else
				Exit Function
		End Select
	End Function
	
	''' <summary>
    ''' Create Step Node without expect/actual result
    ''' </summary>
    ''' <param name="strDesc" type="string">Step Description</param>
    ''' <param name="strStatus" type="string">"1" represents Pass, "2" represents Fail</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	'newly modified
	Public Function AddStepNodeWithoutResult(ByVal strDesc, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		' objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added  
		'objXMLTestCase.AddChildElementByName "TestStep", strDesc 'testcase modified to dataset
		objXMLDataSet.AddChildElementByName "TestStep", strDesc 
		'Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		Set objXMLStep = objXMLDataSet.ChildElements().Item(objXMLDataSet.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_") & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , "..\Images\Screenshots\" & strScreenShotName
		End if
	End Function
	
	''' <summary>
    ''' Create Step Node with detail
    ''' </summary>
    ''' <param name="strDesc" type="string">Step Name Description</param>
    ''' <param name="strDetail" type="string">Detail Description</param>
    ''' <param name="strStatus" type="string">"1" represents Pass, "2" represents Fail</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	'newly modified
	Public Function AddStepNodeWithDetail(ByVal strDesc, ByVal strDetail, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		' objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		'objXMLTestCase.AddChildElementByName "TestStep", strDesc
		objXMLDataSet.AddChildElementByName "TestStep", strDesc 'testcase modified to dataset
		'Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		Set objXMLStep = objXMLDataSet.ChildElements().Item(objXMLDataSet.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		' objXMLStep.AddAttribute "Detail" , strDetail
		' newly added
		objXMLStep.AddAttribute "Message" , strDetail
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , "..\Images\Screenshots\" & strScreenShotName
		End if
	End Function

	''' <summary>
    ''' Create Step Node with expect/actual result
    ''' </summary>
    ''' <param name="strDesc" type="string">Step Description</param>
    ''' <param name="strExpectedResult" type="string">Expected Result</param>
    ''' <param name="strActualResult" type="string">Actual Result</param>
    ''' <param name="strStatus" type="string">"1" represents Pass, "2" represents Fail</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	'newly modified
   	Public Function AddStepNodeWithResult(ByVal strDesc, ByVal strExpectedResult, ByVal strActualResult, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName, message
		' objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		'objXMLTestCase.AddChildElementByName "TestStep", strDesc 'tescase modified to datset
		objXMLDataSet.AddChildElementByName "TestStep", strDesc
		'Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		Set objXMLStep = objXMLDataSet.ChildElements().Item(objXMLDataSet.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		' objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
		' objXMLStep.AddAttribute "ActualResult" , strActualResult
		' newly added
		If Len(strActualResult) > 0 AND UCase(strStatus) = "FAIL" Then
			message = "Expected: " & strExpectedResult & ",   Actual: " & strActualResult
			objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
			objXMLStep.AddAttribute "ActualResult" , strActualResult
		Else
			message = strExpectedResult
		End if
		objXMLStep.AddAttribute "Message" , message
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName =str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , "..\Images\Screenshots\" & strScreenShotName
		End if
	End Function
	
	''' <summary>
    ''' Create Step Node with Link to file
    ''' </summary>
    ''' <param name="strDesc" type="string">Step Description</param>
    ''' <param name="strExpectedResult" type="string">Expected Result</param>
    ''' <param name="strActualResult" type="string">Actual Result</param>
    ''' <param name="strFilepath" type="string">Link to file</param>
    ''' <param name="strStatus" type="string">"1" represents Pass, "2" represents Fail</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
	'newly modified
	Public Function AddStepNodeWithResultAndLinkTOFile(ByVal strDesc, ByVal strExpectedResult, ByVal strActualResult, ByVal strFilepath, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		' objXMLTestCase.AddChildElementByName "Step", strDesc

		'newly added 
		'objXMLTestCase.AddChildElementByName "TestStep", strDesc 
		objXMLDataSet.AddChildElementByName "TestStep", strDesc 'testcase modified to dataset
		'newly commented gg
		' Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		' objXMLStep.AddAttribute "Status" , strStatus
		' objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
		' objXMLStep.AddAttribute "ActualResult" , strActualResult
		' objXMLStep.AddAttribute "Filepath" , strFilepath
		' If bCaptureScreenshot Then
		' 	strTimeStamp = Cstr(Now)
		' 	strTimeStamp = Replace(strTimeStamp, "/", "_")
		' 	strTimeStamp = Replace(strTimeStamp, ":", "_")
		' 	strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
		' 	Call CaptureScreenshot(strScreenShotName)
		' 	objXMLStep.AddAttribute "ScreenShotPath" , "..\Images\Screenshots\" & strScreenShotName
		' End if
		
		'newly added gg
		'Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		Set objXMLStep = objXMLDataSet.ChildElements().Item(objXMLDataSet.ChildElements().count())
		'above testcase modifed to dataset
		If Len(strActualResult) > 0 AND UCase(strStatus) = "FAIL" Then
			message = "Expected: " & strExpectedResult & ",   Actual: " & strActualResult
			objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
			objXMLStep.AddAttribute "ActualResult" , strActualResult
		Else
			message = strExpectedResult
		End if
		objXMLStep.AddAttribute "Message" , message
		objXMLStep.AddAttribute "Status" , strStatus
		' objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
		' objXMLStep.AddAttribute "ActualResult" , strActualResult
		' objXMLStep.AddAttribute "Filepath" , strFilepath
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , "..\Images\Screenshots\" & strScreenShotName
		End if

	End Function
	
	Public Function CaptureScreenshot(ByVal strScreenShotName)
		Dim strScreenShot
		CreateNestedDirs ResultScreenshotPath
		strScreenShot = ResultScreenshotPath & strScreenShotName
		' just capture
		Desktop.CaptureBitmap strScreenShot,True
	End Function

	Public Function CreateNestedDirs(ByVal MyDirName)
	    Dim arrDirs, i, idxFirst, strDir, strDirBuild
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	    ' Convert relative to absolute path
	    strDir = oFSO.GetAbsolutePathName( MyDirName )
	    ' Split a multi level path in its "components"
	    arrDirs = Split( strDir, "\" )
	    ' Check if the absolute path is UNC or not
	    If Left( strDir, 2 ) = "\\" Then
	        strDirBuild = "\\" & arrDirs(2) & "\" & arrDirs(3) & "\"
	        idxFirst    = 4
	    Else
	        strDirBuild = arrDirs(0) & "\"
	        idxFirst    = 1 
	    End If
	
	    ' Check each (sub)folder and create it if it doesn't exist
	    For i = idxFirst to Ubound( arrDirs )
	        strDirBuild = oFSO.BuildPath( strDirBuild, arrDirs(i) )
	        If Not oFSO.FolderExists( strDirBuild ) Then 
	            oFSO.CreateFolder(strDirBuild)
	        End if
	    Next

	End Function

	' Public Function retrieveData(ByVal col)
		
	' 	Dim rv
	' 	dim curColNum
	'     ' datatable.GetSheet("TestData").SetCurrentRow(intscenariorownumber)
	' 	DataTable.GetSheet("TestData").SetCurrentRow(3)

	' 	For intshtcnt=1 to 100
	' 		If Trim(DataTable.Value(intshtcnt,"TestData"))=Trim(searchData) Then
	' 			curColNum=intshtcnt
	' 			Exit for
	' 		End If
	' 	Next

	' 	' ' datatable.GetSheet("TestData").SetCurrentRow(datatable.GetSheet("TestData").GetCurrentRow+1)

	' 	DataTable.GetSheet("TestData").SetCurrentRow(4)
	' 	rv = DataTable.Value(curColNum,"TestData")

	' 	' rv = "Solutions"

	' 	ReportPass array( strFuncName, edict_test_data("Valid_User_Name") , "",""),False

	' End Function

End Class

