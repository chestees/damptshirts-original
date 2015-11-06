<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
'_____________________________________________________________________________________________
'Get Variables
btnSubmit = Request("Submit")

'_____________________________________________________________________________________________
'ADD Record

If btnSubmit <> "" Then
	varString = Request("HTMLString")
	blnActive = CheckBoxValue(Request("Active"))
	dtDate = Date()
	
	Call OpenDB()
	
	intDiggStoreID = 6 
	strWrite = "<div class='clearfix'>"
	myArray = split(varString,"{}")

	For i = 0 to Ubound(myArray)
		intID = left(trim(myArray(i)),4)
		strImage = ""
		if instr(intID,"/") > 0 then
			intID = replace(intID, "/", "")
		end if
			
		mySQL = "SELECT Image FROM tblDigg WHERE ProductID = " & SQLNumEncode(intID)
			Set myRS = Conn.Execute(mySQL)
			'response.Write(mySQL & "<br />")
		If NOT myRS.EOF Then
			strImageTemp = myRS("Image")
		Else
			strWrite = strWrite & "<div class='mod_sql clearfix' style='background-color:#FFFBCC; border:1px solid #E6DB55;'><div style='float:left'><img src='http://www.threadless.com/imgs/products/" & intID & "/200x210design_01.jpg' /></div>"
			strWrite = strWrite & "<div style='margin-left:250px;'>" & intID & " is not in the DB</div></div>"
		End If

		imgHoody = "http://www.threadless.com/imgs/products/" & intID & "/636x460hoody_guys_01.jpg"
		SQL = "UPDATE tblDigg SET Hoody = 1, ImageHoody = " & SQLEncode(imgHoody) & " WHERE ProductID = " & intID
			If blnActive Then
				Conn.Execute(SQL)
			End If		
			
		strWrite = strWrite & "<div class='mod_sql clearfix'>"
		strWrite = strWrite & "<div style='float:left'><img src='"&strImageTemp&"' /></div>"
		strWrite = strWrite & "<div style='margin-left:230px;'>" & intID & "<br />" & SQL & "<br /><br />"
		strWrite = strWrite & "<img style='width:200px' src='http://www.threadless.com/imgs/products/" & intID & "/636x460hoody_guys_01.jpg' /></div></div>"			
		'strWrite = strWrite & "<div>" & intID & "<br />" & SQL & "</div></div>"
	Next
	
	strWrite = strWrite & "</div>"

	Call CloseDB()

End If
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
		<h1>PRODUCTS :: Threadless Hoodies</h1>
		<div id="products" class="clearfix">
			<form action="?Submit=True" method="post">
			<div style="padding: 10px; margin-top: 15px; float: left; width: 900px;">
				<div style="margin-bottom: 10px;">
					<textarea name="HTMLString" style="width: 850px; height: 250px;"></textarea></div>
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
</body>
</html>
