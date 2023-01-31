Dim applicationKeyword
'Set applicationKeyword = new ApplicationKeyword
Set applicationKeyword = new ApplicationKeywords
Class ApplicationKeywords

	
	Function sendValue(object,testdata,FieldName)
	applicationKeyword.clearException()
	  If testdata =null Then
	  	ObjEnvironment.ReportInfo "Entered value is null please check the testdata" 
	  	Exit Function
	  End If
           If  object.Exist(10) Then
             Call cmn_fn_EnterText_IfEnabled(object,testdata,FieldName,"")
          Else 
              ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
          End If
         applicationKeyword.getException()          
     	End Function
		
       Function sendValue_isEnabled(object,testdata,FieldName)
	applicationKeyword.clearException()
	  If testdata =null Then
	  	ObjEnvironment.ReportInfo "Entered value is null please check the testdata" 
	  	Exit Function
	  End If
           If  object.Exist(10) Then
             Call cmn_fn_EnterText(object,testdata,FieldName,"")
          Else 
              ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
          End If
         applicationKeyword.getException()          
     	End Function
	
Function clicksElement(object,fieldName)
        applicationKeyword.clearException()
         If  object.Exist(8) Then     
                enable = object.getroproperty("enabled")
                If enable Then
                ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is enable ","" ,""),False
                  object.click
                    ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is has been clicked ","" ,""),False
                     clicksElement=True
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                clicksElement=False
                End If 
         Else 
             ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
             clicksElement=False
       End If 
         applicationKeyword.getException()
    End Function
Function clickElement_IfExists(object,fieldName)
        applicationKeyword.clearException()
         If  object.Exist(2) Then     
                enable = object.getroproperty("enabled")
                If enable Then
                ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is enable ","" ,""),False
                  object.click
                    ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is has been clicked ","" ,""),False
                     clickElement_IfExists=True
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                clickElement_IfExists=False
                End If 
       End If 
         applicationKeyword.getException()
    End Function
Function clearTextField(object,fieldName)
  	 applicationKeyword.clearException()
         If  object.Exist(2) Then 
         	object.Enter ""
        End if
applicationKeyword.getException()        
  End Function  
Function clickElement_isEnabed(object,fieldName)
    	
    	applicationKeyword.clearException()
         If  object.Exist(5) Then     
                ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is enable ","" ,""),False
                  object.click
                    ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is has been clicked ","" ,""),False
                     clickElement_isEnabed=True
        Else 
             ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
             clickElement_isEnabed=False
       End If 
         applicationKeyword.getException()
    End Function	
Function selectRadioButton(Object,FieldName,Value)
applicationKeyword.clearException()
      If Object.Exist(10)  Then
            Call cmn_fn_RadioButtonIfEnabled(Object,"",Value,FieldName)
      	  Else
             ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
      End If
    applicationKeyword.getException()       
  End Function    
      
 Function  selectTableDropdown(Object,Value,FieldName,TableObject,index,list)
 	applicationKeyword.clearException()
      If Object.Exist(10)  Then
          Call cmn_fn_selectTableDropdown(Object,list,TableObject,index,Value,FieldName,"")
      	  Else
             ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
      End If
        applicationKeyword.getException()       
  End Function  
      
 	Function  selectDropdown(dropdownfield,retrievOptions,retrievValue,selectToElement,FieldName)
 	applicationKeyword.clearException()
      If dropdownfield.Exist(10)  Then
      Call cmn_fn_selectDropdown(dropdownfield,retrievOptions,retrievValue,selectToElement,FieldName,"")
      	  Else
             ObjEnvironment.ReportFail array("",FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
      End If
        applicationKeyword.getException()       
  End Function  
      
        Function  acceptPopup(PoupName)
        applicationKeyword.clearException()
        Select Case ucase(PoupName)
          Case ucase("FORM")
         SET POPUP =OracleNotification("OracleForm")
          Case ucase("Please Acknowledge")
          SET POPUP =OracleNotification("Please Acknowledge")
         Case ucase("Acknowledge")
          SET POPUP =OracleNotification("Acknowledge")
           Case ucase("Message")
          SET POPUP =OracleNotification("Application Message")
        End Select
       If  POPUP.Exist(2) Then
            Message =  TRIM(POPUP.GetROProperty("message"))
            If instr(1,ucase(Message),"SAVED SUCCESSFULLY")>0 Then
             ObjEnvironment.ReportPass array(strFuncName,Message&" Popup has been displayed as expected ","",""),True           	
             acceptPopup=True
             Else
                 ObjEnvironment.ReportFail array(strFuncName,"Popup should not be displayed ","Popup has  been displayed and message is "&Message ,""),True           	
                 acceptPopup=False
            End If
            POPUP.ChooseDefault
            End If 
 
  applicationKeyword.getException()       
End Function
	
	Function getValue(object,FieldName)
	applicationKeyword.clearException()
	 If  object.Exist(10) Then     
                value = object.getroproperty("value")
                 If value=null Then
	 	              ObjEnvironment.ReportFail array(strFuncName,FieldName&"  should not be null as expected",FieldName&" field is null" ,""),True
	       	Exit Function 	 	
	 End If
	 Else
	              ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
	 End If
	 getValue =value
	   applicationKeyword.getException()       
	End Function
	
	Function isEnabled(object,FieldName)
	applicationKeyword.clearException()
	 If  object.Exist(10) Then     
                value = object.getroproperty("enabled")
                 If value=null Then
	 	              ObjEnvironment.ReportFail array(strFuncName,FieldName&"  should not be null as expected",FieldName&" field is null" ,""),True
	       	Exit Function 	 	
	 End If
	 Else
	              ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
	 End If
	 isEnabled =value
	   applicationKeyword.getException()       
	End Function

	Function getAttributeValue(object,fieldName,AttributeName)
	applicationKeyword.clearException()
	 If  object.Exist(10) Then     
                value = object.getroproperty(AttributeName)
                 If value=null Then
	 	              ObjEnvironment.ReportFail array(strFuncName,fieldName&"  should not be null as expected",fieldName&" field is null" ,""),True
	       	Exit Function 	 	
	 End If
	 Else
	              ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",fieldName&" field has not been displayed" ,""),True
	 End If
	 getAttributeValue =value
	   applicationKeyword.getException()       
	End Function
	
	Function IselementDisplayed(object)
	applicationKeyword.clearException()
		 If  object.Exist(10) Then   
		  flag = true
		  Else
		    flag = false
		    End If
		    IselementDisplayed = flag
		      applicationKeyword.getException()       
	End Function
	
	Function Popup_Info(object)
	applicationKeyword.clearException()
	If object.Exist(2) Then
	    strMessage=object.GetROProperty("message")
	    object.ChooseDefault
	    ObjEnvironment.ReportInfo "Validation has been displayed and the message is "+  strMessage
	    Popup_Info=strMessage
	End If
	  applicationKeyword.getException()       
End Function
	
	Function TableDoubleClick(object)
	applicationKeyword.clearException()
		 Set mouse_Action = CreateObject ("Mercury.DeviceReplay")
		 object.Highlight
		totalRows=object.OracleTable("Table").GetAllROProperties("Total Rows")
		visible_rows=object.OracleTable("Table").GetROProperty("visible_rows")
		        y=object.OracleTable("Table").GetROProperty("abs_y")
                      x=object.OracleTable("Table").GetROProperty("abs_x")
                      height=object.OracleTable("Table").GetROProperty("y")
                      width=object.OracleTable("Table").GetROProperty("width")
                      rowsheight=object.OracleTable("Table").GetROProperty("height")
                     rowheight=rowsheight/totalRows
	If totalRows<>0 Then
		For row = 1 To totalRows Step 1
			object.OracleTable("Table").SetFocus row,1
			table_X=width/2
				X_axis=table_X+x
				imgAxis=y
				Y_axis=imgAxis+(rowheight*(row-1))
				'object.Highlight
		        mouse_Action.MouseDblClick X_axis,Y_axis,MIDDLE_MOUSE_BUTTON
		     strvalue=   object.OracleTable("Table").GetFieldValue(row,1)
		   If strvalve="" Then
		   	Exit for
		   	Else 
		   	ObjEnvironment.reportinfo "Advice amount "&row&" "&strvalue
		   End If
		    Next
	  End If
	    applicationKeyword.getException()       
	End Function
	 

	Function selectCheckbox(object,fieldName)
	applicationKeyword.clearException()
         If  object.Exist(10) Then     
                enable = object.getroproperty("enabled")
                If enable Then
                  object.select
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                End If 
         Else 
             ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
       End If 
           applicationKeyword.getException()    
    End Function

Function verifyStringUsingRegExp(Expression,strValue)
applicationKeyword.clearException()
	Set regEXP = CreateObject("vbscript.regexp")
     regEXP.Pattern =Expression
     regEXP.Global = True 
    If regEXP.Test(strValue) Then
        verifyStringUsingRegExp=True
         Else
verifyStringUsingRegExp=False         
	End if
	    applicationKeyword.getException()    
End Function	
	
Function SelectList(object,strvalue,fieldName)
applicationKeyword.clearException()
         If  object.Exist(10) Then     
                enable = object.getroproperty("enabled")
                If enable Then
                  object.Select strvalue
                selectedItem=object.getRoProperty("selected item")
                      If ucase(selectedItem)=ucase(strvalue) Then
                               ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is Selected with "&selectedItem,fieldName&" Field should be entered with "&strvalue,""),False
		            Else
			' Report a Fail.
			          ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is entered with "&str_eleText,fieldName&" Field should be entered with "&strvalue,""),True
                      End if 
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                End If 
         Else 
             ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
       End If 	
	
	    applicationKeyword.getException()    
End Function	
	
Function sendTableValue(Tableobj,TextToEnter,FieldName,row,column)
applicationKeyword.clearException()
	' Getting the Textbox GetROproperty of diabled value and store it in a variable.
'	str_enabled = Tableobj.GetROProperty("enabled")
'	
'	' If the Textbox is not disabled and if it is enabled then..
'	If str_enabled = "True" Then
		' Report a Pass
		ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is Enabled ",FieldName&" Field should be Enabled ",""),False
		
		' Highlight the Textbox 
	'	objElement.highlight
		
		' Set the desired text in the Textbox 
		Tableobj.EnterField row,column,TextToEnter
		
		' Refresh the Textbox.
		Tableobj.refreshobject
		
		' Get the value that is present in the Textbox through GetROproperty Value and store it in a variable named str_eleText.
		str_eleText1 = Tableobj.GetFieldValue(row,column)
		str_eleText=replace(str_eleText1,",","")
		' Checking if the Text to enter is present in the Textbox using instr method , then..
		If instr(1,Ucase(trim(str_eleText)),Ucase(trim(TextToEnter)))>0 Then
			' Report a Pass.
			ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is entered with "&str_eleText,FieldName&" Field should be entered with "&TextToEnter,""),False
		Else
			' Report a Fail.
			ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is entered with "&str_eleText,FieldName&" Field should be entered with "&TextToEnter,""),True
		End If
'	Else
'		' Report a fail that the Textbox is Disabled.
'		ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is disabled",FieldName&" Field should be Enabled ",""),True
'		Exit Function
'	End If
	    applicationKeyword.getException()    
End Function

Function sendChildObjectValue(object,TextToEnter,Fieldname,Index)
applicationKeyword.clearException()
	' Getting the Textbox GetROproperty of diabled value and store it in a variable.
	str_enabled = object(Index).GetROProperty("enabled")
	
	' If the Textbox is not disabled and if it is enabled then..
	If str_enabled = "True" Then
		' Report a Pass
		ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is Enabled ",FieldName&" Field should be Enabled ",""),False
		
		' Highlight the Textbox 
	'	objElement.highlight
		
		' Set the desired text in the Textbox 
		object(Index).Enter TextToEnter
		
		' Refresh the Textbox.
		
		' Get the value that is present in the Textbox through GetROproperty Value and store it in a variable named str_eleText.
		str_eleText1 = object(Index).GetROProperty("value")
'		str_eleText=replace(str_eleText1,",","")
		' Checking if the Text to enter is present in the Textbox using instr method , then..
		If instr(1,Ucase(trim(str_eleText1)),Ucase(trim(TextToEnter)))<>0 Then
			' Report a Pass.
			ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is entered with "&str_eleText1,FieldName&" Field should be entered with "&TextToEnter,""),False
		Else
			' Report a Fail.
			ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is entered with "&str_eleText1,FieldName&" Field should be entered with "&TextToEnter,""),True
		End If
	Else
		' Report a fail that the Textbox is Disabled.
		ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is disabled",FieldName&" Field should be Enabled ",""),True
		Exit Function
	End If
	    applicationKeyword.getException()    
End Function

Function selectPopuplist(object,fieldName,SelectElement)   
applicationKeyword.clearException()
                enable = object.getroproperty("enabled")
                  If enable Then
                      object.Select SelectElement
                      str_eleText1 = object.GetROProperty("selected item")
		       str_eleText=replace(str_eleText1,",","")
		' Checking if the Text to enter is present in the Textbox using instr method , then..
		If instr(1,Ucase(trim(str_eleText)),Ucase(trim(SelectElement)))>0 Then
			' Report a Pass.
			ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is selected with "&str_eleText,FieldName&" Field should be selected with "&SelectElement,""),False
		Else
			' Report a Fail.
			ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is selected with "&str_eleText,FieldName&" Field should be selected with "&SelectElement,""),True
		End If
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                End If 
          applicationKeyword.getException()    
    End Function
    
Function PopUp_Mismatch(object,button)
applicationKeyword.clearException()
  Select Case ucase(button)
         Case ucase("Continue")
                  SET POPUP =OracleNotification("Mismatch").OracleButton("Continue")
         Case ucase("Yes")
                   SET POPUP =OracleNotification("Mismatch").OracleButton("Yes")
         Case ucase("No")
                   SET POPUP =OracleNotification("Mismatch").OracleButton("No")
         Case ucase("Stop")
                    SET POPUP =OracleNotification("Mismatch").OracleButton("Stop")
          Case ucase("YesAll")
                    Set POPUP=OracleNotification("Mismatch").OracleButton("Yes For All")
        End Select
                    message=POPUP.GetROProperty("message")
                    ObjEnvironment.ReportInfo "Validation has been displayed and the message is "+ message
                    POPUP.Click
                        applicationKeyword.getException()    
   End  Function
Function clicksWebElement(object,fieldName)
applicationKeyword.clearException()
         If  object.Exist(10) Then     
                disable = object.getroproperty("disabled")
                If disable="0" Then
                ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is enable ","" ,""),False
                  object.click
                    ObjEnvironment.ReportPass array(strFuncName,fieldName&" field is has been clicked ","" ,""),False
                 Else 
                ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been enable mode as expected",FieldName&" field is disable mode" ,""),True
                End If 
         Else 
             ObjEnvironment.ReportFail array(strFuncName,fieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
       End If 
           applicationKeyword.getException()    
    End Function
Function VerifyMessageFromApplication(PoupName,ExpMessage)
'applicationKeyword.clearException()
	 Select Case ucase(PoupName)
          Case ucase("FORM")
         SET POPUP =OracleNotification("OracleForm")
          Case ucase("Please Acknowledge")
          SET POPUP =OracleNotification("Please Acknowledge")
         Case ucase("Acknowledge")
          SET POPUP =OracleNotification("Acknowledge")
          Case Ucase("Message")
           SET POPUP =OracleNotification("Application Message")
        End Select
       If  POPUP.Exist(2) Then
            Message =  TRIM(POPUP.GetROProperty("message"))
            Flag=applicationKeyword.verifyStringUsingRegExp(ExpMessage,Message)
            If Flag Then
             ObjEnvironment.ReportPass array(strFuncName,Message&"' popup has been displayed as expected ","",""),True           	
             VerifyMessageFromApplication=True
             Else
                 ObjEnvironment.ReportFail array(strFuncName,"Popup should not be displayed ",Message&" Popup has  been displayed" ,""),True           	
                 VerifyMessageFromApplication=False
            End If
            POPUP.ChooseDefault
            End If 
'    applicationKeyword.getException()                
	End Function
Function return_Current_date_time()
	applicationKeyword.clearException()
	str_date = DatePart("d",now())
	str_month = month(now)
	str_year = year(now)
	str_hour = DatePart("h",now())
	str_min = DatePart("n",now())
	str_sec = DatePart("s",now())
		date_Time = get_digits(str_month,2)&get_digits(str_date,2)&get_digits(str_year,4)&"_"&get_digits(str_hour,2)&get_digits(str_min,2)&get_digits(str_sec,2)
	return_Current_date_time =date_Time
	    applicationKeyword.getException()    
End Function
	
Function VerifyMessageFromApplicationAndReturnMessage(PoupName,ExpMessage)
applicationKeyword.clearException()
	 Select Case ucase(PoupName)
          Case ucase("FORM")
         SET POPUP =OracleNotification("OracleForm")
          Case ucase("Please Acknowledge")
          SET POPUP =OracleNotification("Please Acknowledge")
         Case ucase("Acknowledge")
          SET POPUP =OracleNotification("Acknowledge")
            Case Ucase("Message")
           SET POPUP =OracleNotification("Application Message")
        End Select
       If  POPUP.Exist(2) Then
            Message =  TRIM(POPUP.GetROProperty("message"))
            Flag=applicationKeyword.verifyStringUsingRegExp(ExpMessage,Message)
            If Flag="True" Then
             ObjEnvironment.ReportPass array(strFuncName,Message&"Popup has been displayed as expected ","",""),True           	
             VerifyMessageFromApplicationAndReturnMessage=Array(True,Message)
             Else
                 ObjEnvironment.ReportFail array(strFuncName,"Popup should not be displayed ",Message&" Popup has  been displayed" ,""),True           	
                 VerifyMessageFromApplicationAndReturnMessage=Array(False,Message)
            End If
            POPUP.ChooseDefault
            End If 	
	    applicationKeyword.getException()    
End Function	

Function selectcheckboxbytext(obj,text,regExp_text)
applicationKeyword.clearException()
If not obj.Exist Then
    selectcheckboxbytext="Given Object does not exist ,Please check object"
    Exit Function
End If
obj.Activate
Set WshShell = CreateObject("Wscript.Shell")
Set desc_textbox = Description.Create
desc_textbox("class description").value= "text box"
desc_textbox("value").value=regExp_text
Set desc_checkbox = Description.Create
desc_checkbox("class description").value = "check box"
Set textbox=obj.ChildObjects(desc_textbox)
Set checkbox=obj.ChildObjects(desc_checkbox)
If textbox.count=0 Then
       selectcheckboxbytext="Object does not contains any childobject"
    Exit function
End If
For i=textbox.count-1 To 0 Step -1
       return_value=textbox(i).getRoproperty("value")
    If ucase(return_value)= ucase(text) Then
        checkbox(i).select
'        flag =  checkbox(i).GetRoProperty("selected item")
selectcheckboxbytext=True
        exit for
    End If
    If return_value=return_value1 Then
          WshShell.SendKeys "{PGDN}"
          wait 3
       return_value=textbox(i).getRoproperty("value")
          If return_value=return_value1 Then
             selectcheckboxbytext="Given text does not exists"
             exit for
        End If
        End If 
    return_value1=textbox(i).getRoproperty("value")
    If i=0 Then
         textbox(i).click
           WshShell.SendKeys "{PGDN}"
           wait 2
          i=1
       End If
Next
Set WshShell=nothing
Set desc_textbox=nothing
Set desc_checkbox=nothing
    applicationKeyword.getException()    
End Function

Function logout(env)
'     applicationKeyword.clearException()
	If env="UAT" Then
        cmn_fn_LogoutApplication(strFuncName)
        else
        cmn_fn_LogoutApplicationN2P(strFuncName)
        end if
'            applicationKeyword.getException()    
End Function	

Function AddMonth(currentDate,increment)
applicationKeyword.clearException()
	AddMonth=DateAdd("m",increment,currentDate)
	    applicationKeyword.getException()    
End Function

Function AddDate(currentDate,increment)
applicationKeyword.clearException()
	AddDate=DateAdd("d",increment,currentDate)
	    applicationKeyword.getException()    
End Function

Function AddYear(currentDate,increment)
applicationKeyword.clearException()
	AddYear=DateAdd("yyyy",increment,currentDate)
	    applicationKeyword.getException()    
End Function

Function conversiondate(currentdate)
applicationKeyword.clearException()
	currentdate=Replace(currentdate,"#","")
	If instr(1,currentdate,"-")<>0 Then
		arr3 = Array("","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	 years = Right( Split(currentdate,"-")(2),2)
	 conversiondate = Split(currentdate,"-")(0)&"-"&arr3( Split(currentdate,"-")(1))&"-"&years
	 ElseIf instr(1,currentdate,"/")<>0 Then
	 arr3 = Array("","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	 years = Right( Split(currentdate,"/")(2),2)
	 conversiondate = Split(currentdate,"/")(0)&"-"&arr3( Split(currentdate,"/")(1))&"-"&years
	End If
	    applicationKeyword.getException()    
End Function

Function getException()
'	If Err.Number <> 0 Then
'            ObjEnvironment.ReportFail array(strFuncName,"Step should be passed without error",Err.description,""),False           	
'	     Err.Clear
'	End If
End Function

Function clearException()
	Err.clear
End Function


Function selectRadioButtonWithoutEnable(Object,FieldName,Value)
applicationKeyword.clearException()
      If Object.Exist(10)  Then
            Call cmn_fn_RadioButton(Object,"",Value,FieldName)
      	  Else
             ObjEnvironment.ReportFail array(strFuncName,FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
      End If
    applicationKeyword.getException()       
  End Function    
Function  selectFirstOptioDropdown(dropdownfield,retrievOptions,retrievValue,selectToElement,FieldName)
 	applicationKeyword.clearException()
      	If dropdownfield.Exist(10)  Then
		str_enabled = dropdownfield.GetROProperty("enabled")
		If str_enabled = "True" Then
			dropdownfield.Click
			If retrievOptions.Exist(2) Then
				retrievOptions.Click
			End If
			str_eleText = retrievValue.GetROProperty("value")
				If  str_eleText<>"" Then
					ObjEnvironment.ReportPass array( FuncName,FieldName&" Field is entered with "&str_eleText,FieldName&" Field should be entered with "&selectToElement,""),False
				Else
					ObjEnvironment.ReportFail array( FuncName,FieldName&" Field should be enter with some value",FieldName&" Field is Empty",""),True
				End If
		Else
			ObjEnvironment.ReportFail array( FuncName,FieldName&" Field is disabled",FieldName&" Field should be Enabled ",""),True
		End If
	Else
             ObjEnvironment.ReportFail array("",FieldName&" field has been displayed as expected",FieldName&" field has not been displayed" ,""),True
      	End If
        applicationKeyword.getException()       
  End Function  

Function SwtichTabByTitle(expTitle)
'count=applicationKeyword.GetNoOfTABOpened()
Set WshShell = CreateObject("wscript.shell")
		 Browser("index:=0").Highlight
	WshShell.SendKeys "^{TAB}"
	For i = 0 To count-1 Step 1
	title= Browser("index:="&i&"").GetROProperty("title")
		 Browser("index:="&i&"").Highlight
	If instr(1,title,expTitle) Then
		 Browser("index:="&i&"").Highlight
      Exit For
'	verifyLoginMessageExits()
	End If
	WshShell.SendKeys "^{TAB}"
Next
End Function

Function GetNoOfTABOpened()
	Set BrowserObj = Description.Create
BrowserObj("micclass").Value = "Browser"
Set Obj = Desktop.ChildObjects(BrowserObj)
TotalBrowserTab = Obj.Count
GetNoOfTABOpened=TotalBrowserTab
End Function

Function selectcheckboxbytextWithPGDN(obj,text,regExp_text)
applicationKeyword.clearException()
If not obj.Exist Then
    selectcheckboxbytextWithPGDN="Given Object does not exist ,Please check object"
    Exit Function
End If
obj.Activate
Set WshShell = CreateObject("Wscript.Shell")
Set desc_textbox = Description.Create
desc_textbox("class description").value= "text box"
desc_textbox("value").value=regExp_text
Set desc_checkbox = Description.Create
desc_checkbox("class description").value = "check box"
Set textbox=obj.ChildObjects(desc_textbox)
Set checkbox=obj.ChildObjects(desc_checkbox)
If textbox.count=0 Then
       selectcheckboxbytextWithPGDN="Object does not contains any childobject"
    Exit function
End If
For i=textbox.count-1 To 0 Step -1
 return_value=textbox(i).getRoproperty("value")
    If ucase(return_value)= ucase(text) Then
        checkbox(i).select
		selectcheckboxbytextWithPGDN=True
        exit for
    End If
    If i=0 Then
           obj.Activate
           WshShell.SendKeys "{PGDN}"
           wait 1
             return_value1=textbox(i).getRoproperty("value")
           If return_value=return_value1 Then
             selectcheckboxbytextWithPGDN="Given text does not exists"
             exit for
        End If
        i=textbox.count-1
    End If
Next
Set WshShell=nothing
Set desc_textbox=nothing
Set desc_checkbox=nothing
    applicationKeyword.getException()    
End Function




End Class


