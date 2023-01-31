
Dim ObjReports
Set ObjReports = New AppReports
Class AppReports
	Public str_Cur_AppName,str_Prev_AppName
	Public str_Cur_modulename,str_Prev_moduleName
	Public str_Cur_SubModuleName,str_Prev_SubModuleName
	Public str_Cur_TestCaseName,str_Prev_TestCaseName
	Public str_Cur_TestCaseDesc,str_Prev_TestCaseDesc
	Public str_Environ_Driver_path,str_Environ_Frame_Path,str_environ_Exec_setting_file_path
	Public str_Environ_Client_Name,str_Environ_Environment,str_Environ_Browser,str_Environ_Release_Number,str_Environ_Application_Url
	Public str_suite_data_file_name
	Public bln_App_Selection
	Public dict_test_data
	Public edict_test_data
	Public ResultScreenshotPath
	Public objXMLroot,objXMLCustomReport,objXMLTestSuite,objXMLStep,objXMLTestCase
	Public str_Report_Screenshot_Path,str_Report_Path,str_Extras_Path
	Public str_Report_Images_Path,str_Report_Extras_Path
	Public str_XSL_Path,str_XML_Path


function CreateXML_for_reporting(str_path)
	Set xmlDoc = CreateObject("Microsoft.XMLDOM") 
	xmlDoc.save str_path
End Function


	Function createXMLnodes(str_report_path)
			Dim XMLFileHeader,CurrentTestPath
			Set oFSO = CreateObject("Scripting.FileSystemObject")
			XMLFileHeader = "<?xml version='1.0' encoding='UTF-8'?><Report></Report>"
			Set objXMLCustomReport = XMLUtil.CreateXML() 
			objXMLCustomReport.Load XMLFileHeader
			'ObjEnvironment.objXMLCustomReport = objXMLCustomReport
			Set objXMLroot = objXMLCustomReport.GetRootElement()
			'ObjEnvironment.objXMLroot = objXMLroot
			objXMLCustomReport.SaveFile str_XML_Path
	End Function


	Public Function UpdateTestCaseNodeInReportFile(testCaseExeTime)
		objXMLTestCase.AddAttribute "TestCaseExeTime" , testCaseExeTime
		objXMLCustomReport.SaveFile str_XML_Path
	End Function

Public Function CreateAppNodeInReportFile(str_Cur_TestCaseName,Client_Name, Environment, Browser, Release_Number,App_URL,str_Cur_TestCaseDesc)
		objXMLroot.AddChildElementByName "AppName", ""
		Set objXMLTestSuite = objXMLroot.ChildElements().Item(objXMLroot.ChildElements().count())
		'objXMLTestSuite.AddAttribute "Client_Name" , Client_Name
		'newly added
		objXMLTestSuite.AddAttribute "Test_Case_No" , "1"
		objXMLTestSuite.AddAttribute "Test_Case_Name" , str_Cur_TestCaseName
		'
		objXMLTestSuite.AddAttribute "Browser" , Browser
		objXMLTestSuite.AddAttribute "Release_Number" , Release_Number
		objXMLTestSuite.AddAttribute "Test_Case_Description" , str_Cur_TestCaseDesc
		'objXMLTestSuite.AddAttribute "Environment" , Environment
		
		'objXMLTestSuite.AddAttribute "App_URL" , App_URL
		objXMLTestSuite.AddAttribute "AppExeTime" , Environment
		objXMLTestSuite.AddAttribute "AppStatus" , Environment
		objXMLCustomReport.SaveFile str_XML_Path
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
	
	Public Function ApplyXSL()
		Dim sXMLLib, xmlDoc, xslDoc, outputText, outFile
		sXMLLib = "MSXML.DOMDocument"
		Set xmlDoc = CreateObject(sXMLLib)
		Set xslDoc = CreateObject(sXMLLib)
		xmlDoc.async = False
		xslDoc.async = False
		xslDoc.load str_Report_Path &"\Images\"& "Report.xsl"
		xmlDoc.load str_XML_Path
'		outputText = xmlDoc.transformNode(xslDoc.documentElement)
		Set oFSO = CreateObject("Scripting.FileSystemObject")
		Set outFile = oFSO.CreateTextFile(str_Report_Path & "\ReportTest.html",True)
		outFile.Write outputText
		outFile.Close
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
		Call AddStepNode(arr, "Pass", bCaptureScreenshot)
		objXMLCustomReport.SaveFile str_XML_Path
	End Function
	Public Function ReportInfo(ByVal arr, ByVal bCaptureScreenshot)
		Call AddStepNode(arr, "Info", bCaptureScreenshot)
		objXMLCustomReport.SaveFile str_XML_Path
	End Function



	''' <summary>
    ''' Create a failed Step into XML document and report in QTP
    ''' </summary>
    ''' <param name="arr" type="array">a array with combination of the Step Description/expect result/actual result/link to file</param>
    ''' <param name="bCaptureScreenshot" type="Bool">whether capture screenshot or not</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
   	Public Function ReportFail(ByVal arr, ByVal bCaptureScreenshot)
		Call AddStepNode(arr, "Fail", bCaptureScreenshot)		
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
	Public Function AddStepNodeWithoutResult(ByVal strDesc, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		objXMLTestCase.AddChildElementByName "TestStep", strDesc
		Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_") & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , ".\Images\Screenshots\" & strScreenShotName
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
	Public Function AddStepNodeWithDetail(ByVal strDesc, ByVal strDetail, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		objXMLTestCase.AddChildElementByName "TestStep", strDesc
		Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		objXMLStep.AddAttribute "Detail" , strDetail
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , ".\Images\Screenshots\" & strScreenShotName
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
   	Public Function AddStepNodeWithResult(ByVal strDesc, ByVal strExpectedResult, ByVal strActualResult, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		objXMLTestCase.AddChildElementByName "TestStep", strDesc
		Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
		objXMLStep.AddAttribute "ActualResult" , strActualResult
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName =str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , ".\Images\Screenshots\" & strScreenShotName
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
	Public Function AddStepNodeWithResultAndLinkTOFile(ByVal strDesc, ByVal strExpectedResult, ByVal strActualResult, ByVal strFilepath, ByVal strStatus, ByVal bCaptureScreenshot)
		Dim strTimeStamp, strScreenShotName
		objXMLTestCase.AddChildElementByName "Step", strDesc
		'newly added 
		objXMLTestCase.AddChildElementByName "TestStep", strDesc
		Set objXMLStep = objXMLTestCase.ChildElements().Item(objXMLTestCase.ChildElements().count())
		objXMLStep.AddAttribute "Status" , strStatus
		objXMLStep.AddAttribute "ExpectedResult" , strExpectedResult
		objXMLStep.AddAttribute "ActualResult" , strActualResult
		objXMLStep.AddAttribute "Filepath" , strFilepath
		If bCaptureScreenshot Then
			strTimeStamp = Cstr(Now)
			strTimeStamp = Replace(strTimeStamp, "/", "_")
			strTimeStamp = Replace(strTimeStamp, ":", "_")
			strScreenShotName = str_Environ_Client_Name & " " & Replace(str_Environ_Environment, ".", "_")  & " " & strTimeStamp & ".png"
			Call CaptureScreenshot(strScreenShotName)
			objXMLStep.AddAttribute "ScreenShotPath" , ".\Images\Screenshots\" & strScreenShotName
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

End Class
