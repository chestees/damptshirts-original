<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
OpenDB()

btnSubmit = Request("Submit")
strUsername = Request(trim("Username"))
strPassword = Request(trim("Userpass"))

If btnSubmit <> "" Then
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_AdminLogin"
	cmd.CommandType = adCmdStoredProc
	
	cmd.Parameters.Append cmd.CreateParameter("Username",adVarChar,adParamInput,50)
	cmd.Parameters("Username") = strUsername
	cmd.Parameters.Append cmd.CreateParameter("Userpass",adVarChar,adParamInput,50)
	cmd.Parameters("Userpass") = strPassword
	cmd.Parameters.Append cmd.CreateParameter("AdminUserID",adInteger,adParamOutput)
	cmd.Parameters("AdminUserID") = cAdminUserID
	
	cmd.Execute
	
	cAdminUserID = cmd.Parameters("AdminUserID")
	
	If cAdminUserID > 0 Then
	
		Response.Cookies(cSiteName)("AdminAuthorized") = cAdminUserID
		
		Set cmd = nothing
		
		CloseDB()
		
		Response.Redirect "/products/"
	Else 
		' Displayed when a failed login occurs.
		strNotice="<strong><font color=""#FF0000"" size=""3"">You are not authorized</font></strong>"
		
	End If	
	
	Set cmd = nothing
	
	CloseDB()
	
End If
%>
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
</head>
<body onLoad="Form_Login.Username.focus();">
<div id="leftCol">
  <img class="logo" src="/images/t-shirt_Digg.png" alt="Damp T-Shirts: A t-shirt search engine that puts you in control." />
</div>
<div id="rightCol">
	<div class="tags"></div>
	<div class="content" style="padding-top:50px;">
<form action="/" method="post" name="Form_Login">
		<%If strNotice <> "" Then%><div><strong><%=strNotice%></strong></div><%End If%>
        <div><strong>Please login...</strong></div>
        <div style="padding:10px;">Username<br>
        <input name="Username" type="text" class="Text_150"></div>
        <div style="padding:10px;">Password<br>
        <input name="Userpass" type="password" class="Text_150"></div>
        <div style="padding:10px;"><input name="Submit" type="submit" class="Submit" value="Submit"></div>
</form>
    </div>
</div>
</body>
</html>