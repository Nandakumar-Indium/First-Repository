'==================================================================
' 	Class Name	:	OS_clsUtils
'	Develped by	:	Kishore Sura
'	Developed on	:	29-June-2011
'	Description	     :	This Deals with the General utilities used by QTP.'				
'==================================================================

Set objUtils=New OS_clsUtils

Class OS_clsUtils
	Dim strResultFilePath,ImageFolder,Reports,strAttachment 

	Dim strTestScenario,strSubTestScenario
	Dim strFileName,varConfigFilePath
	Dim strReleaseNo
	
	Dim strHTMLSnippet,GPS_ErrorImg,GPS_ErrorImgRelativePath
	Dim chrTab

	Dim strCurrentBookmark 'new 18
	
	 Private Sub class_Initialize()
		strHTMLSnippet = ""  '@ Assigns HTML Snippet to a null character
		chrTab="	" 
			strCurrentBookmark=""
	  End Sub  
	
	Sub WriteToTemp(OrPath)
		Set Fso=CreateObject("Scripting.filesystemObject")
		Set f=Fso.CreateTextFile(strTempFilePath)
		f.Writeline ("Set Refwindow="&OrPath)
		f.close
	End Sub
	
	Function fnLaunchingIE(Url)
	   On error Resume Next
		Set IE = CreateObject("InternetExplorer.Application")
		IE.Visible = True
		IE.Navigate2 Url
		set IE=Nothing
		'@ Use the below code if you have an issue with the create object code
		'SystemUtil.Run "C:\Program Files\Internet Explorer\IEXPLORE.EXE",url
	End Function
	
	Function fnBrowserCreationTime()
		Dim brwCnt
		brwCnt=0
		Do 
			blnBrowser=Browser("micclass:=Browser","Creationtime:="&brwCnt).Exist(2)
			If blnBrowser Then brwCnt=brwCnt+1
		Loop Until blnBrowser=False
		fnBrowserCreationTime=brwCnt-1
	End function

	Function fnUniqueTime()  
		fnUniqueTime="_"&Month(Now)&"" & Day(date)&"" &Year(date)&"_" & Hour(NOW)&"" & Minute(Now)&"" & Second(Now)
	End Function
		
 Function fnFileExist(strFileName)
		dim FileSysObj
		fnFileExist=True
		Set FileSysObj = CreateObject("Scripting.FileSystemObject")
		If NOT FileSysObj.FileExists(strFileName) then fnFileExist=False
	End function
	

	Function fnFolderExist(strFolderName)
		dim FileSysObj
		fnFolderExist=True
		Set FolderObj = CreateObject("Scripting.FileSystemObject")
		If NOT FolderObj.FolderExists(strFolderName) Then fnFolderExist=False
	End Function
	
	Function fnResultFileHeader(strHeading)
		'@ Adds table tab only if the strHTMLSnippet is blank (ie if it is re-execution)
		If intTtlFailedTCs =0 Then 
			strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & "<table bgcolor='#ffffff' border='0' cellspacing='1' cellpadding='5' width='100%'>"  & vbNewLine
		End If
		strCurrentBookmark="Bookmark"&Minute(Now)& Second(now) 
		strHTMLSnippet    = strHTMLSnippet  & chrTab & chrTab & chrTab & "<tr bgcolor='#F0F0F8'><a name="& strCurrentBookmark & "></a>" & vbNewLine   'aug 18
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor = '#CC99CC'><td  colspan =350><font color='DarkBlue' size = '2' face = 'verdana'><b>" & "Script Name: " & strSubTestScenario & "</b></font></td></tr>"   & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr width='100%' bgcolor = '#C0C0C0'>"   & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & chrTab & "<th width='5%'><font Color ='DarkBlue' size=1 face = 'verdana'><b>Step No.</b></font></th>"   & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & chrTab & "<th width='20%'><font Color ='DarkBlue' size=1 face = 'verdana'><b>Test Case Description/Major Event</b></font></th>"   & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & chrTab & "<th width='30%'><font Color ='DarkBlue' size=1 face = 'verdana'><b>Expected Result</b></font></th>"  & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & chrTab & "<th width='30%'><font Color ='DarkBlue' size=1 face = 'verdana'><b>Actual Result</b></font></th>"  & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & chrTab & "<th width='15%'><font Color ='DarkBlue' size=1 face = 'verdana'><b>Date/Time</b></font></th>"   & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "</tr>"   & vbNewLine
	End Function
	
	Function fnScreenShot(HWND)
	   'On error Resume  Next 
	
		If blnSkipValidation Then
			Exit Function
		End If
		Dim strFilename,LocWinID
		LocWinID = Trim(HWND)
		ImageFolder=Environment.Value("ImageFolders")
		strBrowserName = Window("HWND:="&LocWinID).GetROProperty("name")
		If (fnFolderExist(ImageFolder)) Then
			Randomize 
			
			'"..\Images\"&tmpFilename&".png"
			'strFilename = Environment.Value("ImageFolders")&"\Images"&"_"&round(rnd(100)*1000,0)&"_"&intcounter
'			tmpFilename = "Image"&"_"&round(rnd(100)*1000,0)&"_"&intcounter
'			strFilename = Environment.Value("ImageFolders")&"\"&tmpFilename
'			intcounter=intcounter+1
			
			
			strFilename = Environment.Value("ImageFolders")&"\Images"&"_"&round(rnd(100)*1000,0)&"_"&intcounterforimage
			tmpFilename = "Image"&"_"&round(rnd(100)*1000,0)&"_"&intcounter
			strFilename = Environment.Value("ImageFolders")&"\"&tmpFilename
      		intcounter=intcounter+1
      		intcounterforimage = intcounterforimage+1
			
			
			
			If (LocWinID <> "") Then
				GPS_ErrorImg = strFilename &".png"
				GPS_ErrorImgRelativePath="..\Images\"&tmpFilename&".png"
			'	Window("HWND:="&LocWinID).Activate
				Browser("HWND:="&LocWinID).CaptureBitmap GPS_ErrorImg
				fnReportEvent "info","","","Screenshot taken for browser title:- ["&strBrowserName&"]",Ucase("Screenshot:")&"-"&strFilename &".png","SCREENSHOT"
			Else
				fnReportEvent "warning","fnscreenShot()","","Screenshot not taken as requested WinID not found - "&ResultFolder,"Screenshot not taken for browser","<B> Picture cannot be saved!!! - WinID not found </B>"
			End If
		Else
			fnReportEvent "warning","fnscreenShot()","","Screenshot not taken as requested Result folder not found - "&ResultFolder,"Screenshot not taken for browser","<B> Picture cannot be saved!!! - Result folder not found </B>"
		End if
		fnscreenShot = LocWinID
	End function
		
	Function fnHTMLHeader(TCHeader)

		strHTMLSnippet    = strHTMLSnippet  & chrTab & chrTab & chrTab & "<tr bgcolor='#CCCCFF'><td  colspan =350><font color='#003399' size = '1' face = 'verdana'><b>"& TCHeader & "</b></font></td></tr>" & vbNewLine

	End Function
          		
			
	'###########################################################################################################################
	'	@	Function for adding a row in the Result with some information - Used in the start of the Test Case to track the Result
	'	@	and Iteration of the result.
	'###########################################################################################################################

	Function fnHTMLFileHeaderBreak(strText)
		strHTMLSnippet    = strHTMLSnippet    & "<tr bgcolor = '#CCCCFF'><td  colspan =5><font color='#003399' size = '1' face = 'verdana'><b>"&"# "& strText & "</b></font></td></tr>"
	End Function

	Function fnHtmlReport(strStatus,TCfunctionName,TCfunctionDescription,ExpectedResult,ActualResult)
		'# fnHtmlReport strStatus, TCfunctionName, TCfunctionDescription, ExpectedResult, ActualResult
		'@ For Text file Reporter
			
			If blnSkipValidation And Lcase(strStatus)="pass" Then
				strStatus="info"
				TCfunctionDescription=""
				ExpectedResult=""			
			End If
	
			If (strStatus <> "iReport") Then
				Select Case Lcase(strStatus)
					Case "pass"
						strStatus = "pass"
						strStatusW = "pass"
				 If lcase(strTCFailFlag)  <>  "fail"  Then   strTCFailFlag="Pass"   
					Case "fail"
						strStatus = "fail"
						strStatusW = "fail"
						strTCFailFlag="Fail"
					Case "warning"
						strStatus = "warning"
						strStatusW = "warning"
						strTCFailFlag="warning"   
					Case "done"
						strStatus = "done"
						strStatusW = "action"
					Case "info"
						strStatus = "info"
						strStatusW = "information"
					Case Else

				End Select				

				If strStatus="info" Then
								fnReportEvent strStatus,"","",TCfunctionDescription,ExpectedResult,"<B>"&Ucase(strStatusW)&" </B> "&ActualResult
				Else
								fnReportEvent strStatus,"Step:" & intStep_no,"",TCfunctionDescription,ExpectedResult,"<B>"&Ucase(strStatusW)&" </B> "&ActualResult
				End If
		
					
			
				intStep_no=intStep_no+1
			End If
	
			If (strStatus <> "") Then
					Select Case Lcase(strStatus)
						Case "pass"
							strStatus = "PASS"
						Case "fail"
							strStatus = "FAIL"
						Case "warning"
							strStatus = "WARNING"
						Case "done"
							strStatus = "Script Header"
						 Case "ireport"
							strStatus = "Iteration Report"
						Case "info"
							strStatus = "Information"
						Case Else
                			fnHtmlReport = -3000
							fnReportEvent "fail", "fnHtmlReport()","","Verification of argumnets passed for status in HTML/Text reporter."," Should match with the required","~:FAIL:~ Not Matched with the required status"
							Exit Function
						End Select
				Else

					fnHtmlReport = -3000
					fnReportEvent "fail", "fnHtmlReport()","","Verification of argumnets passed for status in HTML/Text reporter."," Should match with the required","~:FAIL:~ Not Matched with the required status"
					Exit Function
				End IF
	
				If((strStatus ="Script Header" ) or (strStatus = "Iteration Report")) Then
					extraMsg = "Test Case/Function : "&TCfunctionName&" ;description of script: "&TCfunctionDescription
				 ''''''''''''''''''   LogActivity extraMsg
				End If
	 End Function
	 
	'###########################################################################################################################
	' Purpose     : This is to create a new file for report in html format, and creates a template
	' scope & use : Before any QTP script run, this procedure is called only once
	' Inputs      : Module Name 
	' Returns     : None
	'###########################################################################################################################

	Public Function fnReportEvent(strStatus,objName,intActionIteration,functionality,strExpected,strActual)
		strStatus = Lcase(strStatus)	
		Select Case strStatus
			Case "pass"  intStatus = 0
		Case "fail"  intStatus = 1
			Case "warning"  intStatus = 3
			Case "done" intStatus = 2
			Case "info" intStatus = 2
		End Select
		objNameTest = objName
		If functionality <> "" or objName <> ""  Then
			if (trim(intActionIteration) = "") then
				objNameTest  =  objNameTest  & "<Br>"  & "" & intActionIteration
			Else
				objNameTest  =  objNameTest  & "<Br>"  & "Count: " & intActionIteration
			End IF
		End If
		Reporter.ReportEvent intStatus,objName,"expected vs actual:  " & strExpected & " VS " & strActual
		fnAddtoResultFile strStatus,objNameTest,intActionIteration,functionality,strExpected,strActual
		fnWriteToResultFile strTestScenario,strHTMLSnippet,strFileName
		If strStatus="fail" Then
			Call Func_TakeSnapshot("Please check fail condition")
			
		End If
	End Function

	'###########################################################################################################################
	' Purpose     : keeps apending all results within an action and if any fail is there then user will get the screenshot 
	'				attached available. Need to use the fnscreenShot function for this.
	' scope & use : within the action, where the file is executed
	' Inputs      : subModule   -  The sub module name
	'               testFeature -  The actual functionality, it can be related to object or strtestData
	'               result      -  pass / fail
	'               strActual   -  Actual result captured by QTP
	'               strExpected   -  Expected result driven by the user
	' Returns     : code        -  the appended sting
	' Modified by : 
	'###########################################################################################################################
	
	Function fnAddtoResultFile(strStatus,strScriptName,intIteration,strtestData,strExpected,strActual)
		If intResultCount=0 Then
            strHTMLSnippet    = strHTMLSnippet  & chrTab & chrTab & "<table>"			
            strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "<table Class=MainTbl cellspacing='1'  width='100%'> " & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=RowHeader>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='5%'>Step No.</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='40%'>Actual Result</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='35%'>Expected Result</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='10%'>Status</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='10%'>Duration</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "</tr>" & vbNewLine
            			
		End If
		
		strHTMLSnippet    = strHTMLSnippet  & chrTab & chrTab & chrTab  & "<tr bgcolor='#F0F0F8'>"
	
		If Trim(strScriptName) = "" Then
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>&nbsp</td>"
		Else
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>" & strScriptName & "</td>" 
		End If
	
		If Trim(strtestData) = "" Then
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>&nbsp</td>"
		Else
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>" & strtestData & "</td>"
		End If	 
	
		If strExpected = "" Then 
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>&nbsp</td>"
		Else			
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>" & strExpected & "</td>"
		End If	
	
		If strActual = "" Then 
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>&nbsp</td>"
		Else
			strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>" & strActual 
			Res = Instr (strActual, "SCREENSHOT")
          		If (Res <> 0) Then
				If ((GPS_ErrorImg <> "")) Then			
					'lakshmi
					'strResult_TSFolder =Environment.Value("CurrDir")    
					strHTMLSnippet    = strHTMLSnippet    & "</br><a href='"&GPS_ErrorImgRelativePath &"' TARGET='_new'><img src='"&GPS_ErrorImgRelativePath &"' border='no' height='60' width = '100' alt='Click to maximize'></a>"
					strImgName = GPS_ErrorImg
				End If
			End If
				strHTMLSnippet    = strHTMLSnippet    & "</td>"	 
		End If


		strHTMLSnippet    = strHTMLSnippet    & "<td class='"& strStatus &"'>" & date &" "& time & " </td></tr>"

		intResultCount=intResultCount+1

	End Function

	'###########################################################################################################################
	' Purpose     : Adds the appended string (code) to the header
	' scope & use : within the action, the scope of the appended variable loses its scope, this procedure appends to header
	' Inputs      : ModuleName  -  The module name
	'               strHTMLSnippet       -  the appended string
	' Returns     : -
	' Modified by : 
	'###########################################################################################################################
	
	Sub fnWriteToResultFile(strFunctionName, strHTMLSnippet, strFileName)
	  On error Resume  Next 
	'   Msgbox strFunctionName
	'   Msgbox strFileName
	'   Msgbox strResultFilepath
	   
		Set objFile = CreateObject("Scripting.FileSystemObject")
		'Checks whether file exist if not creates a new file  
		If Not (objFile.FileExists(strResultFilepath)) Then
			fnScriptInfo mu_TestScenario,strResultFilepath		
		End If
			'@ Get the entire strHTMLSnippet    from the file till "</table></body></html>"
			'@ This is to insert the new strHTMLSnippet    before  "</table></body></html>"
			Set htmlFile = objFile.OpenTextFile(strResultFilepath,1)
			strData = htmlFile.ReadAll
			'Print "Before " & strData
			strData =  left(strData, len(trim(strData))-26)
			'Print ""
			'Print ""
			'Print ""
			'Print "After " & strData
			htmlFile.close
			Set htmlFile = objFile.OpenTextFile(strResultFilepath,2)
			htmlFile.writeLine(strData)
			htmlFile.WriteLine(strHTMLSnippet)
			htmlFile.WriteLine("</table></body></html>")
			htmlFile.close
			strHTMLSnippet = ""	
	
	End Sub

	'###########################################################################################################################
	Sub  fnScriptInfo(mu_TestScenario, strFileName)
		'Msgbox strFunctionName
		'Msgbox strFileName
		Dim TestInputFile
		'TestInputFile=split(App.Test.Environment.Value("TestName"),"_")
		'TISubFolder=TestInputFile(1) & "_" & TestInputFile(2)
		'TIFileName=TestInputFile(0) & "_" & TestInputFile(1) & "_" & TestInputFile(2) & "_TestData_" & TestInputFile(3)
        set objFile = CreateObject("Scripting.FileSystemObject")
		set oFSO = objFile.CreateTextFile(strResultFilepath ,true)
		oFSO.WriteLine("<html>")
			oFSO.WriteLine (chrTab & "<head>")
				oFSO.WriteLine (chrTab & chrTab & "<title>QTP Result File " & Environment.Value("TestScinario") & "</title>")
				oFSO.WriteLine(chrTab & chrTab & "<style>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & ".pass {font-family:verdana;color:green;font-size:12px}")    	
					oFSO.WriteLine(chrTab & chrTab & chrTab & ".fail {font-family:verdana;color:red;font-size:12px}")
					oFSO.WriteLine(chrTab & chrTab & chrTab & ".warning {font-family:verdana;color:#FF8C00;font-size:12px}")
					oFSO.WriteLine(chrTab & chrTab & chrTab & ".done {font-family:verdana;color:#000000 ;font-size:12px}")
					oFSO.WriteLine(chrTab & chrTab & chrTab & ".info {font-family:verdana;color:Navy  ;font-size:12px}") 
				oFSO.WriteLine(chrTab & chrTab & "</style>")
				oFSO.WriteLine(chrTab & "</head>")
				oFSO.WriteLine(chrTab & "<body bgcolor='#dddddd'>")
				oFSO.WriteLine(chrTab & chrTab & "<table>")	
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C0'><td><font size = 4 face = 'arial' color='DarkRed'> <B>Release No&nbsp:&nbsp" & Environment.Value("Rel_No") & "&nbsp&nbsp</B></font></td></tr>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C0'><td><font size = 4 face = 'arial' color='DarkRed'> <B>Test Case&nbsp:&nbsp" & Environment.Value("TestScinario") & "&nbsp&nbsp</B></font></td></tr>")
					'oFSO.WriteLine(chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C0'><td><font size = 2 face = 'verdana' color='DarkRed'> <B><U>Machine Name:</B</U></font></td><td><font size = 2 color='DarkRed' face = 'verdana'><B>" & App.Test.Environment.Value("LocalHostName") & "</B></font></td></tr>")	
				oFSO.WriteLine(chrTab & chrTab & "</table>")
				
				oFSO.WriteLine(chrTab & chrTab & "<table>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<style type=text/css><!--#layer1{position:relative;left:2px;top:7px;width:40px;height:5px;background-color:green;z-index:0;}body{background-color: #dddddd;}--></style><div id=layer1></div>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<style type=text/css><!--#layer2{position:relative;left:2px;top:10px;width:40px;height:5px;background-color:red;z-index:0;}body{background-color: #dddddd;}--></style><div id=layer2></div>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<style type=text/css><!--#layer3{position:relative;left:2px;top:13px;width:40px;height:5px;background-color:Navy;z-index:0;}body{background-color: #dddddd;}--></style><div id=layer3></div>")
					'oFSO.WriteLine(chrTab & chrTab & chrTab & "<style type=text/css><!--#layer4{position:relative;left:2px;top:16px;width:40px;height:5px;background-color:#CC99CC;z-index:0;}body{background-color: #dddddd;}--></style><div id=layer4></div>")
					'oFSO.WriteLine(chrTab & chrTab & chrTab & "<style type=text/css><!--#layer5{position:relative;left:2px;top:19px;width:40px;height:5px;background-color:#CCCCFF;z-index:0;}body{background-color: #dddddd;}--></style><div id=layer5></div>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<span style=position:absolute;top:75px;left:60px;color:green;><b>Pass</b></span>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<span style=position:absolute;top:97px;left:60px;color:red><b>Fail</b></span>")
					oFSO.WriteLine(chrTab & chrTab & chrTab & "<span style=position:absolute;top:118px;left:60px;color:Navy;><b>Information</b></span>")

					'oFSO.Writeline("</table>")
				oFSO.WriteLine(chrTab & chrTab & "</table>")
				oFSO.WriteLine(chrTab & chrTab & "</br>")
				oFSO.WriteLine(chrTab & chrTab & "!<----------")
				oFSO.WriteLine(chrTab & chrTab & "!<--")
		oFSO.close
	End Sub

	Function fnResultFileFooter(intTtlTCs,intTtlPassed,intTtlFailed,strStTime,strEndTime,strTtlTime)
	   On error Resume  Next 
		'strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & "<table border='White' cellspacing='1' cellpadding='2' height='10' width='100%'>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Total Number Of Testcases&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp:&nbsp&nbsp" & intTtlTCs & "</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Total Number Of Passed Testcases&nbsp&nbsp:&nbsp&nbsp" & intTtlPassed & "</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Total Number Of Failed Testcases&nbsp&nbsp&nbsp&nbsp:&nbsp&nbsp" & intTtlFailed & "</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Execution Start Time&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp:&nbsp&nbsp" & strStTime & " (IST)</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Execution End Time&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp:&nbsp&nbsp" & strEndTime & " (IST)</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "<tr bgcolor='#C0C0C6'><td colspan=350><font size = 2 face ='verdana' color='DarkBlue'><p style=' text-indent:400px;'><B>Elapsed Time&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp:&nbsp&nbsp" & strTtlTime & "</B></p></td></tr>" & vbNewLine
		strHTMLSnippet = strHTMLSnippet & chrTab & chrTab & chrTab & "</br>" & vbNewLine
		Set objFile = CreateObject("Scripting.FileSystemObject")
		'@ Get the entire strHTMLSnippet    from the file till "</table></body></html>"
		'@ This is to insert the new strHTMLSnippet    before  "</table></body></html>"
		Set htmlFile = objFile.OpenTextFile(strResultFilepath,1)
		strData = htmlFile.ReadAll
		strData =  left(strData, len(trim(strData))-26)
		htmlFile.close
		Set htmlFile = objFile.OpenTextFile(strResultFilepath,2)
		htmlFile.writeLine(strData)
		htmlFile.WriteLine(strHTMLSnippet)
		htmlFile.WriteLine("</table></body></html>")
		htmlFile.close
	End Function
               

	Function fnCreateFolder(Path_Name,Folder_Name)
		'Folder_Name = strProjFolder &"Results"
		Set fso = CreateObject("Scripting.FileSystemObject")
		If (fso.FolderExists(Path_Name))then
			'Reporter.ReportEvent 2, "Result folder found", "Result Folder found"
		Else
			Set f = fso.CreateFolder(Path_Name)
		End IF
	
		'ResultFolder1 = strProjFolder &"Results\"& strFunctionName
		If (fso.FolderExists(Path_Name & Folder_Name))then
			'Reporter.ReportEvent 2, ModuleName&"folder found", ModuleName&"Result Folder found"
		Else
			Set f = fso.CreateFolder(Path_Name & Folder_Name)
		End IF
		set fso=Nothing
		set f=Nothing
		fnCreateFolder = Path_Name & Folder_Name
	End Function

	Function fnLaunchHTMLResult(strResultFilepath)
	   '	@	Function written for HTML Result opening for verification.
		Systemutil.Run strResultFilepath
	End Function
	
	Function DateFormat(MyDate)
	Dim TempDate
		TempDate=""
		TempDate=Right(Year(MyDate), 2)
		TempDate=TempDate & month(MyDate)
		TempDate=TempDate & day(MyDate)
		TempDate=TempDate & hour(MyDate)
		TempDate=TempDate & Minute(MyDate)
		TempDate=TempDate & Second(MyDate)
		DateFormat=TempDate
	End Function

	Public Function fnGenerateUniqueVal(strUNQIDFLAG)
		 Select Case strUNQIDFLAG
			Case "Unique_Val" 
				varRtnVal= " " & strReleaseNo & fnUniqueTime
			Case "Release_No"
                  varRtnVal= " " & strReleaseNo
			Case "None" 
				 varRtnVal=""
		End Select
		fnGenerateUniqueVal=varRtnVal
		
		fnUpdateEnvVariable varConfigFilePath,"TempUNQVAL",Trim(varRtnVal)
	End Function

	Public Function fnUpdateEnvVariable(strConfigFilePath,strEnvVariable,strVal2Set)
		'@ Load .ini file
		'Environment.LoadFromFile strConfigFilePath
		strFindWhat=Trim(strEnvVariable & "=" & Trim(Environment(strEnvVariable)))
		'@ Retrives current Environmental Variable
		Set fso=CreateObject("Scripting.Filesystemobject")
		Set objTxtFile = fso.OpenTextFile(strConfigFilePath,1)
		myString=objTxtFile.ReadAll '@myString will contain entire text in the .ini file
		objTxtFile.Close
		
		'@ Sets new unique value to Environmental Variable
		strVal2Set=Trim(strEnvVariable & "=" & strVal2Set)		

		'myString=ReplaceText(myString,strFindWhat, strVal2Set)		
		myString=Replace(myString,strFindWhat, strVal2Set)		
		Set objTxtFile = fso.OpenTextFile(strConfigFilePath,2)
		objTxtFile.Writeline myString
		objTxtFile.Close
		Set objTxtFile=Nothing
		Set fso=Nothing
	End Function

	'###########################################################################################################################
	Public Function ReplaceText(SearchInString,strFindWhat, strReplaceWith)
		Dim regEx               ' Create variables.
		Set regEx = New RegExp            ' Create regular expression.
		regEx.Pattern = strFindWhat            ' Set pattern.
		regEx.IgnoreCase = True            ' Make case insensitive
		ReplaceText = regEx.Replace(SearchInString, strReplaceWith)   ' Make replacement.
		'Set regEx = Nothing
	End Function
  	'###########################################################################################################################  
	Public Function fnGetEnvVariable(strEnvVariable)
		Environment.LoadFromFile varConfigFilePath		
		fnGetEnvVariable=Trim(Environment(strEnvVariable))
	End Function

	'###########################################################################################################################
	' Purpose     : To Attach attachments in HTML report
	'	
	' scope & use : Attach attachments of Excel sheets
	' Inputs      : subModule   -  The sub module name
	'               testFeature -  The actual functionality, it can be related to object or strtestData
	'               result      -  pass / fail
	'               strActual   -  Actual result captured by QTP
	'               strExpected   -  Expected result driven by the user
	' Returns     : code        -  the appended sting
	' Modified by : jyothi
	'###########################################################################################################################

	Public Function fnHTMLAttachment(strAttachment)
	If blnSkipValidation Then
			Exit Function
		End If
		If (fnFolderExist(Reports)) Then
                    strHTMLSnippet    = strHTMLSnippet  & chrTab & chrTab & chrTab  & "<tr bgcolor='#F0F0F8'>"
		strHTMLSnippet    = strHTMLSnippet    & "<td>&nbsp</td>"
		strHTMLSnippet    = strHTMLSnippet    & "<td>&nbsp</td>"
		strHTMLSnippet    = strHTMLSnippet    & "<td>&nbsp</td>"
		strHTMLSnippet    = strHTMLSnippet    & "   <td > <a href=' " &  strAttachment  &" '> Comparision Report Attachment  </a>   </td>  " 
		strHTMLSnippet    = strHTMLSnippet    & "<td>&nbsp</td> </tr>"                         
		End If
               End Function
	'###########################################################################################################################


	'###########################################################################################################################
	
End Class