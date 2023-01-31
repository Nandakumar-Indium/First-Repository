On Error Resume Next
 
'globalreturn value and rc 
Public gbReturnValue,rc, strActualResultsFile
Public glbExpectedResultsPath,glbAppDataPath

Public gbRptLevelNum

Set objGlobal=New OS_clsGlobal

Class OS_clsGlobal

'-------------------------------------------------------------------------------------------------------------------------------------------------------   
'FunctionName	:fnWaitForReadyState
'Purpose	: Wait for the object  till the syn time out
'Parameters	:@SyncObject----  object variable which need to check
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWaitForReadyState(ByRef SyncObject)
 
	Dim Counter , SyncDone, ObjectName
	'Any error is handled by the calling function
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'On Error Resume Next
	ObjectName = "<Unknown>"
	'wait for the object in a loop, until the counter reaches the max value
	Counter = 1

	SyncDone = SyncObject.WaitProperty("attribute/readyState", "complete", QTP_TimeOut)	
	Do While Not SyncDone	
		'wait(9)
		SyncDone = SyncObject.WaitProperty("attribute/readyState", "complete", QTP_TimeOut)	
		If Counter >= 5 or 	 SyncDone   Then Exit Do
		Counter = Counter+1
	Loop	
	'Error handling
	If SyncDone Then    
		fnWaitForReadyState = micPass
		rc=fnWaitForReadyState
	Else
		fnWaitForReadyState = micFail
		rc=fnWaitForReadyState	
		myTxt=SyncObject.GetROProperty("Class Name")	
	End If
	'Clear any Sync errors by QTP
	''Err.Clear
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Public Function fnWaitForObject(byref appObject,byval intIterations,byval intWaitTime)
Dim i 
	i=1
	'@Loop till specific time till the object exists
	While i <=cint(intIterations)
		'Wait(intWaitTime)		
		If (appObject.Exist(intWaitTime)) Then
			fnWaitForObject=True
			'''''''''Set appObject=Nothing
			Exit Function
		End If
		i=i+1
	Wend
	fnWaitForObject=False
	''''''''Set appObject=Nothing
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWebEdit(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object

	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebEdit = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebEdit = rc 
	End If
              

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	'perform the action 	
	Select Case Action
		Case "Set"
			'check for the  disabled property
			If Refwindow.GetRoProperty("disabled")=1 Then 
				If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","","  " , " " , ObjDescription &  " Text box is disabled, hence value '" & ActionData & "' could not be set " &" [Error Description: " &  Err.Number & " - " & Err.Description & "] "
				rc=0
				Exit Function					
			End If

			Refwindow.Set ActionData
			strReportMsg=  "Entered value '" &  ActionData &  "' in the " &  ObjDescription & "  Text box"  
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the  existence of ["  &  ObjDescription & "]  Text Box"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)			
			 'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] WebEdit Box, and the property value is '"  & gbReturnValue & "'"
		Case "Click"
			Refwindow.Click
			strReportMsg=   "Clicked on the " &  ObjDescription & " Text box"
		End Select  
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Error","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebEdit=gbReturnValue
		End If 

End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebList
'Purpose	:To Select,Check and retreiving the WebList Properties
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----Variable which consists of the Description.
'		 @ActionData----Value to Select in the WebEdit
'		 @ActionData----ActionData of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Function fnWebList(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
'On error resume next
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebList = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebList = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	'@ loop till all items load in the weblist box
	For i=1 to 24
		strListItems=Refwindow.GetRoProperty("all items")
		Wait(5)
		If strListItems<>"" Then 
			gbReturnValue=True
			Exit For
		Else
			gbReturnValue=False						
		End If
	Next	

	If Not gbReturnValue Then objUtils.fnHtmlReport "Fail","Step:1","","'","Items in the "& ObjDescription & " Weblist did not load"
	

	'perform the action 
	Select Case Action
		Case "Select"  'new 
			'check for the  disabled property
			If Refwindow.GetRoProperty("disabled")=1 Then 
				If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","","" , "" ,ObjDescription &  " Drop down box is disabled, hence value '" & ActionData & "' could not be selected " &" [Error Description: " &  Err.Number & " - " & Err.Description & "] "					
				rc=0
				Exit Function					
			End If
			'check for the data in the list box 
			If Instr(Refwindow.getRoproperty("all items"),ActionData)=0 Then  
				If gbRptLevelNum >1 Then
					objUtils.fnHtmlReport "Fail","Test Data Error","" , "" ,"'" & ActionData &  "' does not exist in the " & ObjDescription & " Drop down box, hence this value could not be selected " &   " [Error Description: " &  Err.Number & " - " & Err.Description & "] "
					 rc=0
					 Exit Function
				End If
			End If
			'select the list box value
			Refwindow.Select ActionData
			strReportMsg=  "Selected a value  '" &  ActionData &  "' from the " &  ObjDescription & " Drop down box"  
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)

			'strReportMsg=  "Verified the  existence of ["  &  ObjDescription & "]  Weblist Box"
		Case "Get"
			gbReturnValue=Trim(Refwindow.GetRoProperty(ActionData))
			' to send the none value to the Result sheet
			gbValue=""
			If instr(gbReturnValue,">") >0    and  instr(gbReturnValue,"<") >0   Then			
				 gbValue=Replace(Replace (gbReturnValue,">",""),"<","")     				
			End If
			If len(gbValue) =0  Then
				'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Weblist Box, and the property value is '"  & gbReturnValue & "'"
			Else
				'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Weblist Box, and the property value is '"  & gbValue & "'"
			End If			
	End Select
	
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebList=gbReturnValue
		End If 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------



'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebButton
'Purpose	:To Click,Check and retreiving the WebButton Properties
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.
'		 @ActionData-----ActionData of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Function fnWebButton(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebButton = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebButton = rc 
	End If	

	    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT

	 strReportMsg= vbNullString

	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the  existence of ["  &  ObjDescription & "]  Web Button"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Web Button, and the property value is '"  & gbReturnValue & "'"
		Case "Click"
			'check for the  disabled property
			If Refwindow.GetRoProperty("disabled")=1 Then 
				If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail"," ","  " , " " , ObjDescription & " Button is disabled, hence click operation could not be performed " & " [Error Description: " &  Err.Number & " - " & Err.Description & "] "
				rc=0
				Exit Function					
			End If
			Refwindow.Click
			strReportMsg=  "Clicked on the " &  ObjDescription & " Button"  
	End Select  
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebButton=gbReturnValue
		End If 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWeblink
'Purpose	:To Set,Check and retreiving the Weblink Properties
'Parameters	:@Action----Keyword related to the Property 
'		 @Objname----- Variable which consists of the Description.
'		 @ActionData-----ActionData of Weblink to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Function fnWeblink(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWeblink = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWeblink = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString  


	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription &"]  Weblink "  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "]  Weblink and the value is "  & gbReturnValue
		Case "Click"
			Refwindow.Click
			strReportMsg=  "Clicked on the " &  ObjDescription & " Web link"  
	End Select
	'check the error 
	If Err.Number <> 0 Then 
			rc=micFail
			Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
			If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWeblink=gbReturnValue
		End If 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebRadio
'Purpose	:To Set,Check and retreiving the WebRadio Properties
'Parameters	:@Action----Keyword related to the Property 
'		 @Objname----- Variable which consists of the Description.
'                @ActionData------Value to Select in the WebRadio
'		 @ActionData-----ActionData of WebRadio to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Function fnWebRadio(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)

	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebRadio = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebRadio = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Select"
			Refwindow.Select ActionData
			If ActionData="ON" Then strReportMsg=  "Clicked on the " &  ObjDescription & " Radio button" 					
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WebRadioGroup "  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WebRadioGroup  and the value is "  & gbReturnValue
	End Select
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebRadio=gbReturnValue
		End If 

	
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebElement
'Purpose	:To Set,Check and retreiving the WebElement Properties
'Parameters	:@Action----Keyword related to the Property 
'                @WebelementText---- Text to find out in the application
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Function fnWebElement(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)

	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function

	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		Set Refwindow =   Eval(dicObject(ObjectVar))
		'Set Refwindow =   dicObject(ObjectVar)
		'msgbox Eval(dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebElement = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebElement = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	
	Select Case Action
		Case "Set"
			Refwindow.Set ActionData
			strReportMsg=  "Entered a value '" &  ActionData &  "' in the " &  ObjDescription & " Web element"  
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the existence of ["  &  ObjDescription & "]  Web Element "
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] WebElement  and the property value is '"  & gbReturnValue & "'"
		Case "Click"
			Refwindow.Click
			strReportMsg=  "Clicked on " & ObjDescription & " Web element"  
		Case "ObjClick"
			Refwindow.Click
			strReportMsg=  "Clicked on " & ObjDescription & " Web element"  
		'spl actions 
		  Case "Check"
				For Each oWebelement in Refwindow.Object.All
					If oWebelement.innerhtml=WebelementText or oWebelement.innertext=WebelementText Then
						blnElement=True
						fnWebElement=blnElement
						Exit for
					End If
				Next
				'strReportMsg=   Action & "  the    [ " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WebElement  and the value is "  & gbReturnValue
			 'spl actions 
		Case "Count"
			ElementCount=0
			For Each oWebelement in Refwindow.Object.All
				If oWebelement.innerhtml=ActionData Then
					ElementCount=ElementCount+1				    		      	 
					fnWebElement=ElementCount
				End If			
			Next
		Case "ReadValue"
			gbReturnValue = Refwindow.GetROProperty ("innertext")
			'strReportMsg=   "Retrived innertext  value '" &  ActionData &  "'  value from [" &  ObjDescription & "] WebElement  "
	End Select	

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebElement=gbReturnValue
		End If 
	 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebTable
'Purpose	:To get and Check the Webtable Properties
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.
'		 @Row------Row in the WebTable
'		 @col ---- Column in the WebTable
'		 @ActionData-----ActionData of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Public Function fnWebTable(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription,Byval RowNum,Byval ColumnNum)   'strProp,Objname,Row,Col,PropertyName)

	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
	 Set Refwindow= ObjectVar
	End If


	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebTable = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebTable = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 'Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	'perform the action 
	Select Case Action
			Case "Exist"
				gbReturnValue=Refwindow.Exist(10)
				'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WebTable "  &  Action			
			Case "CellData"
				gbReturnValue=Refwindow.GetCellData(RowNum,ColumnNum)
				'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WebTable"  &  Action
			Case "Get"
				gbReturnValue=Refwindow.GetRoProperty(ActionData)
				'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WebTable and the value is "  & gbReturnValue

	
	 End Select 
	 
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebTable=gbReturnValue
		End If 
	
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------


'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebCheckBox
'Purpose	:To Set,Check and retreiving the Webcehckbox Properties
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.
'		 @ActionData------Value to Enter in the WebEdit
'		 @ActionData-----ActionData of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Function fnWebCheckBox(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebCheckBox = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebCheckBox = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Set"
			'check for the  disabled property
			If Refwindow.GetRoProperty("disabled")=1 Then 
				If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","","  " , " " , ObjDescription &  " Checkbox is disabled, hence could not be checked " &" [Error Description: " &  Err.Number & " - " & Err.Description & "] "
				rc=0
				Exit Function					
			End If
			Refwindow.Set ActionData
			if ActionData="ON" Then
				strReportMsg=  "Checked the " &  ObjDescription & "  Checkbox"  
			Else
				strReportMsg=  "Unchecked the " &  ObjDescription & " Checkbox"  
			End If
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WebCheck Box "  &  Action
		Case "Get"  
			gbReturnValue=Refwindow.GetRoProperty(ActionData)  'disabled
			 'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "]  WebCheckBox and the value is "  & gbReturnValue			 
			'strReportMsg=  Action & "    the [" &  ObjDescription & "]  WebCheckBox"  
	End Select	

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebCheckBox=gbReturnValue
		End If 

End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnImage
'Purpose	:To Set,Check and retreiving the Webcehckbox Properties
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.		
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Function fnImage(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnImage = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnImage = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			strReportMsg=  "Verify the  ["  &  ObjDescription & "] Image "  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "]  Image  and the value is "  & gbReturnValue
		Case "Click"
			Refwindow.Click
			strReportMsg=  Action & "    the [" &  ObjDescription & "]  Image "  
	End Select	

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg

		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnImage=gbReturnValue
		End If 

End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWebPage
'Purpose	:To verify the existance of the specified page
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWebPage(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	
	 Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval(dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
	rc = fnWaitForReadyState(Refwindow)
	If rc <> micPass Then fnWebPage = rc       

	'check for the object Exist
	If NOT Refwindow.Exist(QTP_TimeOut)  Then rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Webpage " & ObjDescription & " [" & Refwindow.Tostring & "] does not exist. " : Exit Function
	strReportMsg= vbNullString
	 Refwindow.HighLight
	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the existence of  ["  &  ObjDescription & "] Page"
		Case "Sync"
			Refwindow.Sync
			'strReportMsg=  "Waited till the ["  & ObjDescription & "] Page is Synchronized"

		Case "ReadValue"                    '7/3/11   kiran 
				gbReturnValue = ""
				Set weDesc = Description.Create()
				weDesc("html tag").Value = "BODY"
				weDesc("index").Value = "0"
				frameText = Refwindow.WebElement(weDesc).GetROProperty("innertext")    
				gbReturnValue=frameText
				Set weDesc = Nothing
	End Select  
	
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebPage=gbReturnValue
		End If 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinTree_wthWriteToTemp
'Purpose	:To Set,Check and retreiving the webEdit Properties
'Parameters	:@Action----Keyword related to the Property 
'		 @Objname----Variable which consists of the Description.
'                @ActionData----Value to Enter in the WebEdit
'		 @ActionData----ActionData of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWinTreeView (ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
	rc = fnWaitForReadyState(Refwindow)
	If rc <> micPass Then fnWinTreeView = rc       

	'check for the object Exist
	If NOT Refwindow.Exist(QTP_TimeOut)  Then rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Win Tree " & ObjDescription & " [" & Refwindow.Tostring & "] does not exist. " : Exit Function
	strReportMsg= vbNullString
	
	Select Case Action
		Case "Select"
			Refwindow.Select ActionData
			 strReportMsg=   "Selected '" &  ActionData  & "' from the "& ObjDescription & " tree"   
			Wait(1)
		Case "Exist"
			gbReturnValue=Refwindow.Exist(QTP_TimeOut)
			'strReportMsg=  "Verify the existence of ["  &  ObjDescription & "]  Win Tree "
		Case "Get"
			 gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Win Tree and the property value is '"  & gbReturnValue & "'"
		Case "Expand"
			Wait(1)
			Refwindow.Expand ActionData
			strReportMsg=   "Expanded  '" &  ActionData  & "'from the "& ObjDescription & " tree"   
			Wait(1)
		Case "Activate"
			Wait(1)
			Refwindow.Activate ActionData
			'strReportMsg=   "Activated  '" &  ActionData  & "'  node in the ["& ObjDescription & "]  Win Tree"   
			Wait(1)
		Case "Collapse"
			Wait(2)
			Refwindow.Collapse ActionData
			strReportMsg=   "Collapsed '" &  ActionData  & "' node in the "& ObjDescription & " tree"   
			Wait(5)
	End Select  

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg

		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinTreeView=gbReturnValue
		End If 
		

End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnAxtivexGrid
'Purpose	:To get and Check the Webtable Properties
'Parameters	:@strProp----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.
'		 @Row------Row in the WebTable
'		 @col ---- Column in the WebTable
'		 @PropertyName-----Propertyname of Webedit to retrieve the value using the getromethod
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnAxtivexGrid(ObjectVar, ByVal Action,ByVal ActionData,Byval RowNum,Byval ColumnNum,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If


	'Wait for the screen to appear
	rc = fnWaitForReadyState(Refwindow)
	If rc <> micPass Then fnAxtivexGrid = rc       

	'check for the object Exist
	If NOT Refwindow.Exist(QTP_TimeOut)  Then rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"ActiveX Grid " & ObjDescription & " [" & ObjectVar & "] does not exist. " : Exit Function
	strReportMsg= vbNullString             	


	'Perform the action
	Select Case Action
		Case "Select"
			'to access the internal properties/methods of the Activex Object
			Set Refwindow=Refwindow.Object
			Refwindow.Select RowNum,ColumnNum
			gbReturnValue=Refwindow.Text  '3/3/11 Kiran

			''''strReportMsg = "Selected row '" &  RowNum &  "' and Column '" & ColumnNum  & "' in the " & ObjDescription & " Grid" : wait(2)
		Case "Exist"
			gbReturnValue=Refwindow.Exist(120)
			'strReportMsg=  "Verify the existence of ["  &  ObjDescription & "]  ActiveX Grid"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] WebElement  and the property value is '"  & gbReturnValue & "'"
		Case "Set"
			'to access the internal properties/methods of the Activex Object
			Set Refwindow=Refwindow.Object
			Refwindow.Select RowNum,ColumnNum : wait(3)
			Refwindow.Text = ActionData
			strReportMsg = "Entered value '"& ActionData &"' in row '" &  RowNum &  "' and Column '" & ColumnNum  & "' in the " & ObjDescription & " Grid"   
		Case "Get Row Count"
			'to access the internal properties/methods of the Activex Object
			Set Refwindow=Refwindow.Object
			gbReturnValue=Refwindow.Rows			
			'strReportMsg = "Retrived number of rows from the [" & ObjDescription & "] ActiveX Grid"   
		Case "Get Visible Text"
			gbReturnValue=Refwindow.GetVisibleText			
			'strReportMsg = "Retrived visible text from the [" & ObjDescription & "]  ActiveX Grid"   
	End Select
		
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
   		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnAxtivexGrid=gbReturnValue
		End If 
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------------
'_____________________________________________________________________________________



'_______________________________________________________________________________________
'_______________________________________________________________________________________
'--------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinEdit
'Purpose	:To Set,Check and retreiving the webEdit Properties
'Parameters	:
 '		   @ObjectVar----Object  variable
 '		 @Action  ----  type of method/action  to perform the object
'         @ActionData----  input to the object
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWinEdit(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	 Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If
	
	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWinEdit = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWinEdit = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Set"
			Refwindow.Set ActionData
			strReportMsg=  "Entered value '" &  ActionData &  "' in the " &  ObjDescription & "  Text box"  
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WinEdit Box "  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "]  WinEdit Box  and the value is "  & gbReturnValue
		Case "Click"
			Refwindow.Click
			strReportMsg=   "Clicked on the " &  ObjDescription & " Text box"
	End Select  
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
        If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinEdit=gbReturnValue
		End If 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinList
'Purpose	:To Select,Check and retreiving the WebList Properties
'Parameters	:
 '		   @ObjectVar----Object  variable
 '		 @Action  ----  type of method/action  to perform the object
'         @ActionData----  input to the object
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWinList(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
      
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If
	
	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWinList = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWinList = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	


	Select Case Action
		Case "Select"
			Refwindow.Select ActionData
			strReportMsg=  "Selected a value  '" &  ActionData &  "' from the " &  ObjDescription & " Drop down box"  
    		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WinList "  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WinList  and the value is "  & gbReturnValue
	End Select
	
	'check the error 
	If Err.Number <> 0 Then 
			rc=micFail
			'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
			If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
        If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinList=gbReturnValue
		End If 
   
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------




'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinButton
'Purpose	:To Click,Check and retreiving the WebButton Properties
'Parameters	:
 '		   @ObjectVar----Object  variable
 '		 @Action  ----  type of method/action  to perform the object
'         @ActionData----  input to the object
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWinButton(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
    Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	
	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWinButton = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWinButton = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	


	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the  existence of ["  &  ObjDescription & "]  Win Button"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Win Button, and the property value is '"  & gbReturnValue & "'"
		Case "Click"
			Refwindow.Click
			strReportMsg=  "Clicked on " &  ObjDescription & " Button"  
	End Select  
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinButton=gbReturnValue
		End If 
End Function
'_____________________________________________________________________________________


'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnStatic
'Purpose	:To Click,Check and retreiving the WebButton Properties
'Parameters	:
 '		   @ObjectVar----Object  variable
 '		 @Action  ----  type of method/action  to perform the object
'         @ActionData----  input to the object
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnStatic(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)

		Dim strReportMsg,Refwindow
		'@ Check the previous object status
		If   rc=micFail   Then Exit Function
		'Check for the Object
		If NOT IsObject(ObjectVar)  Then
			 Set  Refwindow =   Eval( dicObject(ObjectVar))
		Else
			Set Refwindow= ObjectVar
		End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnStatic = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnStatic = rc 
	End If			

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	


	gbReturnValue=""

		'perform the action
		Select Case  Action
			Case "ReadValue"
				gbReturnValue=Refwindow.Static("nativeclass:=Static","window id:=65535").GetROProperty("text")
				 'strReportMsg=   Action & "  the    [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] Dialog  and the value is "  & gbReturnValue
			 Case "Get"
				gbReturnValue=Refwindow.GetRoProperty(ActionData)
				'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] Dialog  and the value is "  & gbReturnValue
		End Select
	
		'check the error 
		If Err.Number <> 0 Then 
			rc=micFail
			Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
			If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		Else 
			rc=micPass
			'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
		
        If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnStatic=gbReturnValue
		End If 
	
End Function
'_____________________________________________________________________________________


'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinRadioButton
'Purpose	:To Click,Check and retreiving the WebButton Properties
'Parameters	:
 '		   @ObjectVar----Object  variable
 '		 @Action  ----  type of method/action  to perform the object
'         @ActionData----  input to the object
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWinRadioButton(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
	Set  Refwindow =   Eval( dicObject(ObjectVar))
	Else
	Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWinRadioButton = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWinRadioButton = rc 
	End If		

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Set"
			Refwindow.Set 
			If ucase(ActionData)="ON" Then strReportMsg=  "Clicked on the " &  ObjDescription & " Radio button" 					
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the  ["  &  ObjDescription & "]  WinRadio"  &  Action
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   Action & "  the property   [   " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WinRadio and the value is "  & gbReturnValue
   	End Select   			 

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    		If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinRadioButton=gbReturnValue
		End If 
	
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinDialog
'Purpose	:To verify the existance of the specified page
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.		
'		 @Time_Out---- Duration of Time that QTP need to Wait for existance of a given page 
'-------------------------------------------------------------------------------------------------------------------------------------------------------
Function fnWinDialog(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	 Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval(dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If
	
	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWinDialog = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWinDialog = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	

	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the existence of  ["  &  ObjDescription & "] Dialog"
		Case "Activate"
			Refwindow.Activate
			'strReportMsg=  "Activated [" & ObjDescription & "] Dialog"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Win Dialog  and the property value is '"  & gbReturnValue & "'"
	End Select  
	
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinDialog=gbReturnValue
		End If 
End Function
'_____________________________________________________________________________________


'-------------------------------------------------------------------------------------------------------------------------------------------------------
'FunctionName	:fnWinTab
'Purpose	:To verify the existance of the specified page
'Parameters	:@Action----Keyword related to the Property 
'                @Objname----- Variable which consists of the Description.		
'		 @Time_Out---- Duration of Time that QTP need to Wait for existance of a given page 
'-------------------------------------------------------------------------------------------------------------------------------------------------------

Function fnWinTab(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)
	 Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function
	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		 Set  Refwindow =   Eval(dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If
	
	
	'Wait for the screen to appear
	rc = fnWaitForReadyState(Refwindow)
	If rc <> micPass Then fnWinTab = rc       

	'check for the object Exist
	If NOT Refwindow.Exist(QTP_TimeOut)  Then rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Win Tab" & ObjDescription & " [" & Refwindow.Tostring & "] does not exist. " : Exit Function
	strReportMsg= vbNullString
	Refwindow.HighLight
	Select Case Action
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verified the existence of  ["  &  ObjDescription & "] Win Tab"
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] Win Tab and the property value is '"  & gbReturnValue & "'"
		Case "Select"
			If Instr(Refwindow.getRoproperty("all items"),ActionData)=0 Then  
				If gbRptLevelNum >1 Then
					objUtils.fnHtmlReport "Fail","Test Data Error","" , "" ,"'" & ActionData &  "' does not exist in the " & ObjDescription & " wintab , hence this value could not be selected " &   " [Error Description: " &  Err.Number & " - " & Err.Description & "] "
					 rc=micFail
					 Exit Function
				End If
			End If
			Refwindow.Select ActionData
			strReportMsg=   "Selected  '" &  ActionData  & "' Tab in the "& ObjDescription & " Win Tab"   
	End Select  
	
	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWinTab=gbReturnValue
		End If 
End Function
'_____________________________________________________________________________________



Public Function fnWebObject(ObjectVar, ByVal Action,ByVal ActionData,ByVal ObjDescription)

	Dim strReportMsg,Refwindow
	'@ Check the previous object status
	If   rc=micFail   Then Exit Function

	'Check for the Object
	If NOT IsObject(ObjectVar)  Then
		Set Refwindow =   Eval(dicObject(ObjectVar))
	Else
		Set Refwindow= ObjectVar
	End If

	'Wait for the screen to appear
'	rc = fnWaitForReadyState(Refwindow)
'	If rc <> micPass Then fnWebObject = rc       
	rc=fnWaitForObject(Refwindow,15,5)
	If  rc  Then
		rc=micPass
	Else
		rc=micFail
		fnWebObject = rc 
	End If	

    'Check for the object Exist
	'If NOT Refwindow.Exist(QTP_TimeOut)  Then  rc=micFail : objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Text box " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	If rc=micFail Then  objUtils.fnHtmlReport "Fail","Automation Failure"," ",  "  " ,"Web Object " & ObjDescription & " [" & Refwindow.ToString & "] does not exist. " : Exit Function
	 Refwindow.HighLight '@ Highlights the object in the AUT
	strReportMsg= vbNullString	


	Select Case Action
		Case "Set"
			Refwindow.Set ActionData
			strReportMsg=  "Entered a value '" &  ActionData &  "' in the " &  ObjDescription & " Web element"  
		Case "Exist"
			gbReturnValue=Refwindow.Exist(10)
			'strReportMsg=  "Verify the existence of ["  &  ObjDescription & "]  Web Element "
		Case "Get"
			gbReturnValue=Refwindow.GetRoProperty(ActionData)
			 'strReportMsg=   "Retrived the property  '" &  ActionData &  "' from [" &  ObjDescription & "] WebElement  and the property value is '"  & gbReturnValue & "'"
		Case "Click"
			Refwindow.Click
			strReportMsg=  "Clicked on " & ObjDescription & " Web element"  
		Case "ObjClick"
			Refwindow.Click
			strReportMsg=  "Clicked on " & ObjDescription & " Web element"  
		'spl actions 
		  Case "Check"
				For Each oWebelement in Refwindow.Object.All
					If oWebelement.innerhtml=WebelementText or oWebelement.innertext=WebelementText Then
						blnElement=True
						fnWebObject=blnElement
						Exit for
					End If
				Next
				'strReportMsg=   Action & "  the    [ " &  ActionData &  "     ]  value from [" &  ObjDescription & "] WebElement  and the value is "  & gbReturnValue
			 'spl actions 
		Case "Count"
			ElementCount=0
			For Each oWebelement in Refwindow.Object.All
				If oWebelement.innerhtml=ActionData Then
					ElementCount=ElementCount+1				    		      	 
					fnWebObject=ElementCount
				End If			
			Next
		Case "ReadValue"
			gbReturnValue = Refwindow.GetROProperty ("innertext")
			'strReportMsg=   "Retrived innertext  value '" &  ActionData &  "'  value from [" &  ObjDescription & "] WebElement  "
	End Select	

	'check the error 
	If Err.Number <> 0 Then 
		rc=micFail
		'Reporter.ReportEvent  micFail , "  " , Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
		If gbRptLevelNum >1 Then  objUtils.fnHtmlReport "Fail","Automation Failure","  " , " " ,Action &  "  failed on the " & ObjDescription& "  Error   : " & Err.Number & " - " & Err.Description 
	Else 
		rc=micPass
		'Reporter.ReportEvent  micPass,  "  " ,strReportMsg
    	If (strReportMsg<>"") Then  objUtils.fnHtmlReport "Pass"," ",strReportMsg&" ",ObjDescription&" ", " "
				fnWebObject=gbReturnValue
		End If 
	 
End Function
'-------------------------------------------------------------------------------------------------------------------------------------------------------














End Class



'========================================================================================================================'========================================================================================================================
