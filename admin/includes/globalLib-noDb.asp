<%
Dim Conn

cServerName = Request.ServerVariables("Server_Name")
cSiteName = "damptshirts"
cFriendlySiteName = "CMS - Damp T-Shirts"
cColor = "#E2E6EF"

Server.ScriptTimeout = 50000000

cAdminUserID = cInt(Request.Cookies(cSiteName)("AdminAuthorized"))

strConn = "Driver={SQL Server};Server={{server}};Database={{databse}};Uid={{uid}};Pwd={{password}};"

cPath = "/"
cAdminPath = "/cms/"

'_____________________________________________________________________________________________
'Cookie Check
'_____________________________________________________________________________________________
If InStr(Request.ServerVariables("script_name"),"/cms/index.asp") < 1 AND InStr(Request.ServerVariables("script_name"),"/cms/") = 1 Then
	If Not IsNumeric(cAdminUserID) or cAdminUserID < 1 Then
		Response.Redirect ("/cms/index.asp")
	End If	
End If

'_________________________________________________________________________________________________
'Place this subroutine to open db connection
Private Sub OpenDB()	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.ConnectionString = strConn
	Conn.Open
End Sub
'_________________________________________________________________________________________________
'place this subroutine to close db connection
Private Sub CloseDB()
	Conn.Close
	Set Conn = Nothing
End Sub

'*******************************************************
'BEGIN TAGS
function getTags()
	OpenDB()
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Digg_TagList"
	cmd.CommandType = adCmdStoredProc
	Set rsTags = cmd.Execute
	
	strTags = ""

	If Not rsTags.EOF Then
		Do While Not rsTags.EOF
		
			intTagID = rsTags("TagID")
			strTag = rsTags("Tag")
			intTagCount = rsTags("TagCount")
	
			strTags = strTags & "<a href='index.asp?TagID=" & intTagID & "&Tag="& strTag &"'>" & strTag & " (" & intTagCount & ")</a>"
	
		rsTags.MoveNext
		If Not rsTags.EOF Then strTags = strTags & "<br />"
		Loop
	End If
	CloseDB()
	strTags = strTags & ""
	Response.Write(strTags)
End Function
'END TAGS
'*******************************************************

Function Stripper(myString)
	myString = Trim(Replace(myString,"  "," "))
	myString = Replace(myString," ","-")
	SpecialChars = ",[]%[]...[]!!![]#[]+[]([])[]&[]$[]@[]![]*[]<[]>[]?[]/[]|[]\[][][][]'[]:[]ó[].[]%20[]%25[]%23[]%2B[]%28[]%29[]%26[]%24[]%40[]%21[]%2A[]%3C[]%3E[]%3F[]%2F[]%7C[]%5C[]%2C[]%27[]%3A[]%D3[]%E8[]%E9[]%2E"
	SCArray = Split(SpecialChars,"[]")
	for each item in SCArray
		myString = Replace(myString,item,"")
		myString = Replace(myString,"-s-","s-")
		myString = Replace(myString,"---","-")
		myString = Replace(myString,"--","-")
		myString = lCase(myString)
	Next
	Stripper = myString
End Function

Function Ceiling(x)

	dim temp
	temp = Round(x)

	If temp < x Then
		temp = temp + 1
	End If

	Ceiling = temp
	
End Function
'_____________________________________________________________________________________________
'Functions
'_____________________________________________________________________________________________
Function SQLEncode(strValue)
	strValue = Replace(strValue,"'","''")
	
	If strValue = "" then
		SQLEncode = "NULL"
	Else 
		SQLEncode = "'" & strValue & "'"
	End If	
End Function

Function SQLDateEncode(strValue)
	strValue = Replace(strValue,"'","''")
	
	If strValue = "" then
		SQLDateEncode = "NULL"
	Else 
		SQLDateEncode = "'" & strValue & "'"
	End If
End Function

Function SQLNumEncode(strValue)
	If strValue = "" OR Not IsNumeric(strValue) then
		SQLNumEncode = "NULL"
	Else 
		SQLNumEncode = strValue
	End If
End Function

Function CheckBoxValue(i_value)
	If Lcase(i_value) = "on" then
		CheckBoxValue = 1
	Else
		CheckBoxValue = 0
	End If
End Function
%>