<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
'_____________________________________________________________________________________________
'Get Variables
btnSubmit = Request("Submit")

	Call OpenDB()
	
	blnActive = CheckBoxValue(Request("Active"))
	strWrite = "<div class='clearfix'>"
	intDiggStoreID = 13 'Wear Your Beer
	intTagID = 461 'Wear Your Beer Tag
	
	strWrite = "<div class='clearfix'>"
			
	SQL = "SELECT DiggID, Image FROM tblDigg WHERE DiggStoreID = " & intDiggStoreID & " AND Active = 1 ORDER BY DiggID desc"
		Set RS = Conn.Execute(SQL)
		
	If Not RS.EOF Then
		Do While Not RS.EOF
			intDiggID = RS("DiggID")
			strImage = RS("Image")
			
			if instr(strImage,"wearyourbeer") > 0 then
				strImage = replace(strImage, "wearyourbeer", "tvmoviedepot")
			end if
			if instr(strImage,"175_175") > 0 then
				strImage = replace(strImage, "175_175", "192_192")
			end if

			SQL = "SELECT RelationID FROM relDiggTag WHERE DiggID = " & intDiggID & " AND TagID = " & intTagID
				Set RS_REL = Conn.Execute(SQL)
			
			If RS_REL.EOF Then
				SQL = "INSERT INTO relDiggTag (" & _
					"DiggID, TagID" & _
					") VALUES (" & _
					SQLNumEncode(intDiggID) & ", " & _
					SQLNumEncode(intTagID) & ")"
					If btnSubmit <> "" Then
						If blnActive Then
							Conn.Execute(SQL)
						End If
					End If				
			End If

			strWrite = strWrite & "<div class='mod_sql clearfix'>"
			strWrite = strWrite & "<div style='float:left'><img src='"&strImage&"' /></div>"
			strWrite = strWrite & "<div style='margin-left:230px;'>" & intDiggID & "<br />" & SQL & "</div></div>"
		RS.MoveNext
		Loop

	End If

	strWrite = strWrite & "</div>"

	Call CloseDB()
%>
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="<%=cPath%>css/style.css">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
</head>

<body>	
<div id="leftCol">
  <img class="logo" src="/images/t-shirt_Digg.png" alt="Damp T-Shirts: A t-shirt search engine that puts you in control." />
	<!--#include virtual="/incNav.asp" -->
</div>
<div id="rightCol">
	<div class="tags"><%getTags()%></div>
	<div class="content">
		<h1>PRODUCTS :: Wear Your Beer Update</h1>
		<div id="products" class="clearfix">
			<form action="?Submit=True" method="post">
			<div style="padding: 10px; margin-top: 15px; float: left; width: 900px;">
				<div style="margin-bottom: 10px;">
					For real:
					<input type="checkbox" name="Active" value="ON" /></div>
				<input type="submit" name="Submit" class="submit_lg" value="Submit">
			</div>
			</form>
			<%=strWrite%>
		</div>
	</div>
</div>