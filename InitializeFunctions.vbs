'Public Email_Read
Public Strpath
Public Strapp
Public StrTestenv
Public  strUsername
Public strPassword
Public strurl
Public StrReleaseNo
Public StrBrw

'=========================================================================================================================================================
'FunctionName	:		InitializeVariables
'Purpose		:		      To initialize all the  ConfigFile variables
'ReturnValue	:		@Returns the path of each file
'Parameters		: 		No
'Author         :		       Kishore
'Created Date	:		29th June 2011
'Modified By	:		-
'Modified Time  :		-
'Reason for Modification:		-
'=========================================================================================================================================================

Public Function InitializeVariables()
Dim qtp_App,qtUpdateRunOptions
	'@kill the excel 
	Call KillProcess ("'Excel.exe'")																																								  'send  in single quote

	strDirectoryname= Environment.Value("TestDir")
	strSplitDir=Split(strDirectoryname,"Scripts")(0)
	Environment.Value("ResultsPath")=strSplitDir &"TestReport"&Environment.Value("curApp")   																						'@ Retrives the file path of Results folder and assigns it to output parameter outResultsPath
 
	
	Environment.Value("ControlSheetPath")=strSplitDir &"TestData" & "\" & "suiteData_"&Environment.Value("curApp")&".xls"		'@ Retrives the file path of ControlSheet and assigns it to output parameter outControlSheetPath
	Environment.Value("TestDatapath")=strSplitDir &"TestData" & "\" & "Testcasedata_"&Environment.Value("curApp")&".xls"                         	 '@Retrives the maximum duration time for execution
	Environment.Value("Basepath")=strSplitDir                       	 '@Retrives the maximum duration time for execution
	'Environment.Value("URL_App") = Application_Url
End Function 

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Class Name:ReadIniFile
'Functions: GetKeyValue
'Purpose:To retrive values from .ini files
'Parameters	: @strSection----Section name in the ini file
'		@strKeyName----Keyname in the ini file
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Class ReadIniFile
	Private m_strFileName
	Private sub class_Initialize()
		m_FileName = ""
		Extern.Declare micInteger, "GetPrivateProfileString", "kernel32", "GetPrivateProfileStringA", _
		micString, micString, micString, _
		micString + micByRef, micLong, micString
	End Sub
	
	Public Property Let FileName(strData)
		m_strFileName = strData
	End Property
		
	Public Property Get FileName()
		FileName = m_strFileName
	End Property
		
	Public Function GetKeyValue(ByVal strSection, ByVal strKeyName)
		on error resume next
		Dim strData
		extern.GetPrivateProfileString strSection, strKeyName,"", strData, 3072, m_strFileName
		If strData = "" Then
			GetKeyValue = strData
		Else
			GetKeyValue = strData
		End If
	End Function 
	
End Class

Set   qtp_App=Nothing '@ Release the Application object
set qtUpdateRunOptions=Nothing '@ Release the Update Run Options object 

'=========================================================================================================================================================
'FunctionName	:		InitializeReporter
'Purpose		:		      To initialize all the  Report
'ReturnValue	:		@Returns the HTML file path
'Parameters		: 		IndexFilePath-
'Author         :		       Kishore
'Created Date	:		04th July 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
Dim objclsIndexHTML
Set objclsIndexHTML=New clsIndexHTML

Class clsIndexHTML
	Dim HTMLIndexFile,IndexFilePath

		Public Function InitializeReporter(IndexFilePath)
			Dim FSO
			Set FSO = CreateObject("Scripting.FileSystemObject")
			Set HTMLIndexFile = FSO.CreateTextFile( IndexFilePath , True)
			WriteIndexHeader
		End Function
'=========================================================================================================================================================
'FunctionName	:		WriteIndexHeader
'Purpose		:		      To write the index header
'ReturnValue	:		@Returns the HTML file path
'Parameters		: 		IndexFilePath-
'Author         :		       Kishore
'Created Date	:		04th July 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
		Public Function WriteIndexHeader()			
			strHTMLSnippet=""
			strHTMLSnippet = strHTMLSnippet &  "<html>" & vbNewLine					
			strHTMLSnippet = strHTMLSnippet &  vbTab & "<style>"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".Header {color: DarkRed;font-size: 13px;font-family: arial;border-collapse: collapse;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".Header.Col2 {background-color: #C0C0C0;font-weight: bold;border-color:#6C6C6C;border-width: 1px 1px 1px 1px;border-style:solid; padding: 2px;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".Header2Margin{margin-top:-85px;margin-bottom:0px;margin-right:0px;margin-left:950px;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".HeaderPadding{padding: 5}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl {background-color:#ffffff; margin-top:70px;margin-bottom:0px;margin-right:0px;margin-left:0px;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.RowHeader {background-color:#CC99CC; color: White ; font-size: 12px; font-family: verdana;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.Footer {background-color:#CC99CC; color: White ; font-size: 12px; font-family: verdana;text-align:Left }"  & vbNewLine
                              strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.subSection {background-color:#CCCCFF}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.subSection.Col {padding: 3; color: DarkBlue; font-size:12px; font-family: verdana;}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.Rows {background-color:#F0F0F8}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.Rows.Cols {padding: 2; color: DarkBlue; font-size: 11px; font-family: verdana;text-align:center}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".MainTbl.Rows.ColsNA {padding: 2; color: DarkBlue; font-size: 11px; font-family: verdana;text-align:Left}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".pass{padding: 2; color: green; font-size: 11px; font-family: verdana;text-align:center}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".fail{padding: 2; color: red; font-size: 11px; font-family: verdana;text-align:center}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & vbTab & ".warning{padding: 2; color:#FF8C00; font-size: 11px; font-family: verdana;text-align:center}"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet &  vbTab & "</style>"  & vbNewLine
			strHTMLSnippet = strHTMLSnippet  & vbNewLine
			strHTMLSnippet = strHTMLSnippet  & vbNewLine
           
'@For updating the Images in the report
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<table width='99%'>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab   &"<tr> <td width='100%' align='right'> <img src='.\Images\Logos\LogixGuru.png' height=100 width=100></td></tr>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"</table>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<br>" & vbNewLine
'============
			strHTMLSnippet = strHTMLSnippet & vbTab & "<body bgcolor='#dddddd'  link='#0000ff' vlink='#FF9900' alink='#993366'>" & vbNewLine   			
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<table Class=Header width='30%'>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab   &"<tr> <td width='30%'>&nbspApplication</td><td Class=Col2 width='70%'>&nbsp&nbsp" & Environment.Value("Application") & "</td></tr>" & vbNewLine
            strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<tr> <td width='30%'>&nbspEnvironment</td><td Class=Col2 width='70%'>&nbsp&nbsp" & Environment.Value("TestEnv") & "</td></tr>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<tr> <td width='30%'>&nbspBrowser</td><td Class=Col2 width='70%'>&nbsp&nbsp" & Environment.Value("SelBrowser") & "</td></tr>" & vbNewLine
			'strHTMLSnippet = strHTMLSnippet & vbTab & VbTab  &"<tr> <td width='30%'>&nbspExecution Start Time</td><td Class=Col2 width='70%'>&nbsp&nbsp" & Now & "</td></tr>" & vbNewLine
            strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "</table>" & vbNewLine

			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "<table Class=MainTbl cellspacing='1'  width='100%'> " & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=RowHeader>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='5%'>S No.</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='15%'>Test Case#</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='60%'>Test Case Description</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='10%'>Status</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<th Class=HeaderPadding Width='10%'>Duration<br/>in<br/>(Min:Sec)</th>" & vbNewLine
			strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "</tr>" & vbNewLine
						
			HTMLIndexFile.WriteLine strHTMLSnippet & vbNewLine
			
		End Function 
'=========================================================================================================================================================
'FunctionName	:		IndexStep
'Purpose		:		   Function for writing index step
'ReturnValue	:		Null
'Parameters		: 		intExeShtrow,TC_ID,ResultFilePath,strBookmark,strTCDesc,strTCFailFlag,intTCExeTime
'Author         :		       Kishore
'Created Date	:		17th Aug 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
		Public Function IndexStep(intExeShtrow,TC_ID,ResultFilePath,strBookmark,strTCDesc,strTCFailFlag,intTCExeTime)				
				strHTMLSnippet=""
                                        strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & "<tr Class=Rows>"   & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=Cols>" & intExeShtrow  & "</td>" & vbNewLine	                              
				strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=Cols><a href=" & chr(34) & ResultFilePath  & "#" & strBookmark & chr(34) & ">" & TC_ID & " </a></td>"   & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=ColsNA>" & strTCDesc  & "</td>"   & vbNewLine

                                        If instr(lcase(strTCFailFlag),"pass")>0 then 
					strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=pass Class=Cols>Pass</td>"   & vbNewLine
				ElseIf instr(lcase(strTCFailFlag),"fail")>0 then 
					strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=fail Class=Cols>Fail</td>"   & vbNewLine                       					
				Else
					strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=warning Class=Cols>Warning</td>"   & vbNewLine
				End If 
				strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & vbTab & "<td Class=Cols>" & intTCExeTime  & "</td>"   & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & vbTab & vbTab & "</tr>"   & vbNewLine
				HTMLIndexFile.WriteLine strHTMLSnippet & vbNewLine
		End Function

'=========================================================================================================================================================
'FunctionName	:		WriteIndexFooter
'Purpose		:		   Function for writing the index footer
'ReturnValue	:		Null
'Parameters		: 	intTtlTCs,intTtlPassed,intTtlFailed,strStTime,strEndTime
'Author         :		       Kishore
'Created Date	:		17th Aug 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
		Public Function  WriteIndexFooter(intTtlTCs,intTtlPassed,intTtlFailed,strStTime,strEndTime)
				inthrs=DateDiff("n",strStTime,strEndTime)
				strElapsedTime= Cint(inthrs\60) & ":" &   Int( inthrs mod 60)

				strHTMLSnippet=""
				strStTime=Cdate(strStTime)
				strEndTime=Cdate(strEndTime)
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "</table>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "<table Class=MainTbl cellspacing='1' width='30%'>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Footer> <th class=HeaderPadding colspan=2>Test Execution Details</th></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspTotal Test Cases</td><td width='40%' Class=Cols>&nbsp" & intTtlTCs & "</td></tr>" & vbNewLine
                                        strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspTotal Passed</td><td width='40%' Class=Cols>&nbsp" & intTtlPassed & "</td></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspTotal Failed</td><td width='40%' Class=Cols>&nbsp" & intTtlFailed & "</td></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspTotal Not Run</td><td width='40%' Class=Cols>&nbsp" & intTtlTCs-(intTtlPassed+intTtlFailed) & "</td></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=subSection> <td width='60%' Class=ColsNA>&nbsp%Passed Status</td><td width='40%' Class=Cols>&nbsp&nbsp&nbsp&nbsp" & Round(((intTtlPassed)/intTtlTCs)*100,2) &"%</td></tr>"  & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=subSection> <td width='60%' Class=ColsNA>&nbsp%Completed</td><td width='40%' Class=Cols>&nbsp&nbsp&nbsp&nbsp" & Round(((intTtlPassed+intTtlFailed)/intTtlTCs)*100,2) &"%</td></tr>"  & vbNewLine				
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr></tr><tr></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Footer> <th class=HeaderPadding colspan=2>Test Execution Duration</th></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspExecution Start Time</td><td width='40%' Class=Cols>&nbsp"& strStTime & "</td></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=Rows> <td width='60%' Class=ColsNA>&nbspExecution End Time</td><td width='40%' Class=Cols>&nbsp"& strEndTime & "</td></tr>" & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & VbTab & "<tr Class=subSection> <td width='60%' Class=ColsNA>&nbspElapsed Time(HH::MM)</td><td width='40%' Class=Cols>&nbsp&nbsp&nbsp&nbsp"& strElapsedTime & vbNewLine
				strHTMLSnippet = strHTMLSnippet & vbTab & VbTab & "</table>" & vbNewLine
                                        strHTMLSnippet = strHTMLSnippet &  "</body> </html>"   & vbNewLine
				HTMLIndexFile.WriteLine strHTMLSnippet & vbNewLine
				'Close & release the report file
				HTMLIndexFile.Close
				Set HTMLIndexFile = Nothing
		End Function

'=========================================================================================================================================================
'FunctionName	:		ShowHTMLReport
'Purpose		:		      For showing up the HTML report
'ReturnValue	:		Null
'Parameters		: 		Null
'Author         :		       Kishore
'Created Date	:		17th Aug 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
	Public Function ShowHTMLReport( )
   		systemutil.Run  IndexFilePath
	End Function

End Class

'=========================================================================================================================================================
'FunctionName	:		KillProcess
'Purpose		:		      To kill the excel process in task manager
'ReturnValue	:		Null
'Parameters		: 		strProcess
'Author         :		       Kishore
'Created Date	:		29th June 2011
'Modified By	:		-
'Modified Time  :		-
'=========================================================================================================================================================
Public Sub KillProcess (strProcess) 
	   On error resume next
	  strComputer = "." 
	  Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2") 
	  Set colProcesses = objWMIService.ExecQuery ("Select * from Win32_Process Where Name =" & strProcess) 
	  For Each objProcess in colProcesses 
		objProcess.Terminate() 
	  Next 
End Sub 



'=========================================================================================================================================================
'FunctionName	 :		Func_Setupfile_Read
'Purpose		 :      Used to read all the set up files
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		Kishore
'Created Date	 :		24th Aug 2011
'Modified By	 :		
'Modified Time   :		-
'Reason for Modification:		Added the Funtion Header
'=========================================================================================================================================================

Public Function Func_Setupfile_Read()

	Set suite_excel_details = getobject(Environment.Value("ControlSheetPath"))
	Set suite_ws_data = suite_excel_details.worksheets("Settings")

	Strapp=suite_ws_data.cells(2,1)
	StrTestenv =suite_ws_data.cells(2,2)	
	StrReleaseNo =suite_ws_data.cells(2,4)
	StrBrw=suite_ws_data.cells(2,3)

	strurl=suite_ws_data.cells(2,5)
	strUsername=suite_ws_data.cells(2,6)
	strPassword=suite_ws_data.cells(2,7)

End Function

'=========================================================================================================================================================
'FunctionName	 :		Func_Loginsetup
'Purpose		 :      Used to Load all the 
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		Kishore
'Created Date	 :		24th Aug 2011
'Modified By	 :		
'Modified Time   :		-
'Reason for Modification:		Added the Funtion Header
'=========================================================================================================================================================

Public Function Func_Loginsetup()

	Set suite_excel_details = getobject(Environment.Value("ControlSheetPath"))
	Set suite_ws_data = suite_excel_details.worksheets("Login_Details")

	If Environment.Value("TestEnv")="Test Environment" Then
			StrURL =suite_ws_data.cells(2,2)
			Else If Environment.Value("TestEnv")="Stage Environment" Then
					StrURL =suite_ws_data.cells(3,2)
				Else If Environment.Value("TestEnv")="Production Environment" Then
						StrURL =suite_ws_data.cells(4,2)
				End IF
		End IF
	End If


End Function

'=========================================================================================================================================================
'FunctionName	 :		Func_Updatesuitexcelresults
'Purpose		 :      	To update the excel with the results file
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		-
'Created Date	 :		24th Aug 2011
'Modified By	 :		Madhu
'Modified Time   :		-
'Reason for Modification:		Added the Funtion Header
'=========================================================================================================================================================

Public Function Func_Updatesuitexcelresults() ' To be explained to the client

       '@ No of rows in the given Datatable source sheet
    intSheetRow= Datatable.GetSheet("SuiteData").GetRowCount
    Set xlApp = CreateObject("Excel.Application")
    Set TDSheet=xlAPP.workbooks.open(Environment.Value("ControlSheetPath"))
    
    For i=1 to intSheetRow+1
		  Datatable.GetSheet("SuiteData").SetCurrentRow(i)	
		  TDSheet.Sheets("Suite Data").Cells(i+1,6).value=Datatable("Status","SuiteData")	

		  If Datatable("Status","SuiteData")="fail" Then
				TDSheet.Sheets("Suite Data").Cells(i+1,5).value="YES"
			Elseif Datatable("Status","SuiteData")="Pass" Then
				TDSheet.Sheets("Suite Data").Cells(i+1,5).value="NO"
		  End If

		  If Datatable("Status","SuiteData")="Pass" Then
				TDSheet.Sheets("Suite Data").Cells(i+1,6).Interior.Color=RGB(193, 255,193)
			ElseIf Datatable("Status","SuiteData")="No Run" Then
				TDSheet.Sheets("Suite Data").Cells(i+1,6).Interior.Color=RGB(185,211,238)
			ElseIf Datatable("Status","SuiteData")="fail" Then
				TDSheet.Sheets("Suite Data").Cells(i+1,6).Interior.Color=RGB(255, 106,106)
		  End If
    Next

	TDSheet.Application.ActiveWorkbook.save
    TDSheet.Application.ActiveWorkbook.Close

    xlApp.Quit
    Set TDSheet = Nothing 
    Set xlApp=Nothing
End Function

'=========================================================================================================================================================
'FunctionName	 :		Send_Mail_Outlook
'Purpose		 :      	To send an email using Outlook
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		-
'Created Date	 :		24th Aug 2011
'Modified By	 :		Madhu
'Modified Time   :		-
'Reason for Modification:		Added the Funtion Header
'=========================================================================================================================================================

Public Function Send_Mail_Outlook(Module)
  strSubject="Test mail - Sent from QTP"
  Set objOutlook=CreateObject("Outlook.Application")
  Set objMail=objOutlook.CreateItem(0)
  objMail.to= "aravindhan.a@indiumsoft.com"
  objMail.CC="kishore.s@indiumsoft.com"
 ' objMail.Bcc="mailbcc@xyz.com"
  objMail.Subject="Test Email" 
  objMail.Body= "This is a test email sent from QTP " & chr(13) & " " & "Regards," & chr(13) & "Kishore"
 '  objMail.Attachments.Add(attachFile) 'attachFile is a variable which helds the file name with its complete path
  wait(2)
  'objMail.Display     'Displays e-mail message window
  wait(2)
  objMail.Send
 Wait (10)
 ' objOutlook.Quit

  Set objMail = Nothing
  Set objOutlook = Nothing
End Function

'=========================================================================================================================================================
'FunctionName	 :		DeclareDLLS
'Purpose		 :      	To declare all the Dlls
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		-
'Created Date	 :		30h Jan 2013
'Modified By	 :		Ksihore
'Modified Time   :		-
'Reason for Modification:	
'=========================================================================================================================================================

Public Function DeclareDLLS()
	Extern.Declare micLong,"GetDCAPP","user32.dll","GetDC",micLong
	Extern.Declare micLong,"DELETEDCAPP","gdi32.dll","DeleteDC",micLong
	Extern.Declare micLong,"DrawTextAPP","user32.dll","DrawTextA",micLong,micString,micLong,micString,micLong
	Extern.Declare micLong,"SetTextColorAPP","gdi32.dll","SetTextColor",micLong,micString
	Extern.Declare micLong,"TextOut","gdi32.dll","TextOutA",micLong,micLong,micLong,micString,micLong
	Extern.Declare micLong,"SetBkColorAPP","gdi32.dll","SetBkColor",micLong,micLong
	Extern.Declare micLong,"SetBkModeAPP","gdi32.dll","SetBkMode", micLong,micLong
	Extern.Declare micLong,"CreateFontAPP","gdi32.dll","CreateFontA",micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micLong,micString
	Extern.Declare micLong,"SelectObjectAPP","gdi32.dll","SelectObject",micLong,micLong
    'Private Declare Function CreateFont Lib "gdi32" Alias "CreateFontA" (ByVal H As Long, ByVal W As Long, ByVal E As Long, ByVal O As Long, ByVal W As Long, ByVal I As Long, ByVal u As Long, ByVal S As Long, ByVal C As Long, ByVal OP As Long, ByVal CP As Long, ByVal Q As Long, ByVal PAF As Long, ByVal F As String) As Long
    'Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long

End Function

'=========================================================================================================================================================
'FunctionName	 :		writeTexttoDesktop
'Purpose		 :      	To write text on the desktop
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		-
'Created Date	 :		30h Jan 2013
'Modified By	 :		Ksihore
'Modified Time   :		-
'Reason for Modification:	
'=========================================================================================================================================================

Public Sub writeTexttoDesktop(strtext)
	Dim desktopHDC  
	Dim tR 
	Dim lCol 
	Dim BackColorvalue
	Dim textColorvalue
	'BackColorvalue = RGB(255, 248,220)
	textColorvalue = RGB(0, 255, 0)
	desktopHDC =Extern.GetDCAPP(0)	
    New_Font_Hnd = Extern.CreateFontAPP(25, 15, 0, 0, 0, TRUE, 0, 0, 0, 0, 0, 0, 0, "Times New Roman")
	Extern.SelectObjectAPP desktopHDC,New_Font_Hnd
	Extern.SetTextColorAPP desktopHDC, textColorvalue
	'Extern.SetBkColorAPP desktopHDC, BackColorvalue
	Extern.SetBkModeAPP desktopHDC, TRANSPARENT
	Extern.TextOut desktopHDC, 700,30, strtext, Len(strtext)
	Extern.DELETEDCAPP hdc
End Sub

'=========================================================================================================================================================
'FunctionName	 :		IE_DisplaytestCase
'Purpose		 :      	To display the test case that is getting executed
'ReturnValue	 :		Null
'Parameters		 : 		Null
'Author          :		-
'Created Date	 :		30h Jan 2013
'Modified By	 :		Ksihore
'Modified Time   :		-
'Reason for Modification:	
'=========================================================================================================================================================

Public Function IE_DisplaytestCase()

'On Error Resume Next

'strComputer = "."
'Set objWMIService = GetObject("Winmgmts:\\" & strComputer & "\root\cimv2")
'Set colItems = objWMIService.ExecQuery("Select * From Win32_DesktopMonitor")
'For Each objItem in colItems
'    intHorizontal = objItem.ScreenWidth
'    intVertical = objItem.ScreenHeight
'Next

Set objExplorer = CreateObject("InternetExplorer.Application")


objExplorer.Navigate "about:blank"   
objExplorer.ToolBar = 0
objExplorer.StatusBar = 0
objExplorer.Width = 400
objExplorer.Height = 200 
objExplorer.Visible = 1   

objExplorer.Document.Body.Style.Cursor = "wait"

For i=1 to 5
objExplorer.Document.Title = "Logon - " &i  &"script in progress"

sTitleMask = "Logon - .*"
hWnd=Browser("name:=" & sTitleMask).GetROProperty("hwnd")
Wait(2)
Window("hwnd:=" & hWnd).Minimize

Next


'objExplorer.Document.Body.InnerHTML = "Your logon script is being processed. " _   & "This might take several minutes to complete."

'objExplorer.Document.Body.InnerHTML = "<img src='file:///C:\Companyname_QTP_V1.0\Companyname_Images\Logos\Indium.jpg'> " & _
 '   "Your logon script is being processed. This might take several minutes to complete."
'Wait(10)

'objExplorer.Document.Body.InnerHTML = "Your logon script is now complete."

'objExplorer.Document.Body.Style.Cursor = "default"

'Wait(5)

objExplorer.Quit


End Function