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
	intDiggStoreID = 13 'Wear Your Beer
	intTagID = 461 'Wear Your Beer Tag
	strTagArray = Request("TagArray")
	strTagText = Request("TagText")
	
	If strTagArray <> "" Then
		TagArray = split(intTagID&","&strTagArray,",")
	Else
		TagArray = split(intTagID&",")
	End If	
	
	Call OpenDB()
		
	strWrite = "<div style='align:center; padding:15px; text-align:left;'>"
	myArray = split(varString,"[]")
	j=0
	For i = 0 to Ubound(myArray)
		
		If j = 0 Then
			strLink = trim(myArray(i))
		End If
		
		If j = 4 Then
			strImage = "http://www.wearyourbeer.com/" & trim(myArray(i))
		End If
		
		If j = 5 Then
			strTitle = trim(myArray(i))
		End If
		
		j = j+1
		If j = 22 Then
							
			SQL = "SELECT DiggID, Link, Title FROM tblDigg WHERE Link = " & SQLEncode(strLink)
				Set RS = Conn.Execute(SQL)
				
				If RS.EOF Then

					SQL = "INSERT INTO tblDigg (" & _
						"Active, Image, Link, Title, DateAdded, SearchTerms, DiggStoreID" & _
						") VALUES (0, " & _
						SQLEncode(strImage) & ", " & _
						SQLEncode(strLink) & ", " & _
						SQLEncode(strTitle) & ", " & _
						SQLDateEncode(dtDate) & ", " & _
						SQLEncode("// " & strTitle & " " & strTagText) & ", " & _
						SQLNumEncode(intDiggStoreID) & ")"
						If blnActive Then
							Conn.Execute(SQL)
						End If
						
					SQL_MAX = "SELECT Max(DiggID) AS MaxID FROM tblDigg"
						If blnActive Then
							Set rsMaxID = Conn.Execute(SQL_MAX)
							intDiggID = rsMaxID("MaxID")
						End If
					
					For k = 0 to Ubound(TagArray)
						SQL2 = "INSERT INTO relDiggTag (DiggID, TagID) VALUES (" & _
							SQLNumEncode(intDiggID) & ", " & _
							SQLNumEncode(TagArray(k)) & ")"
							If blnActive Then
								Conn.Execute(SQL2)
							End If
						strWrite = strWrite & SQL2 & "<br />"
					Next						
				
					strWrite = strWrite & "<div id='Product_Image' class='clearfix' style='border:1px solid #455560; margin-bottom:10px; padding:5px;'><img src='" & strImage & "' align='left'>" & strTitle & "<br />" & SQL & "<br /><br />" & strTagSQL & "</div><div class='clear'></div>"

				ElseIf isNull(RS("Title")) Then
					strTitlePos = InStrRev(strLink,"/")
					strTitle = Replace(strLink,Left(strLink, strTitlePos),"")
					strTitle = Replace(strTitle,"_"," ")
					
					SQL = "UPDATE tblDigg SET Title = " & SQLEncode(strTitle) & ", Active = 1 WHERE DiggID = " & RS("DiggID")
						If blnActive Then
							Conn.Execute(SQL)
						End If
					strWrite = strWrite & "<div style='border:1px solid #455560; margin-bottom:10px; padding:5px;'>Title Updated<br />" & SQL & "</div>"

				Else
					strWrite = strWrite & "<div style='border:1px solid #455560; margin-bottom:10px; padding:5px;'>Duplicate<br />" & strLink & "</div>"

				End If
			j = 0
		End If
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
		<h1>PRODUCTS :: Wear Your Beer</h1>
		<div id="products" class="clearfix">
			<form action="?Submit=True" method="post">
			<div style="padding: 10px; margin-top: 15px; float: left; width: 900px;">
				<div style="margin-bottom:10px;">Tag Array <input type="text" name="TagArray" /> 1,2,3</div>
        <div style="margin-bottom:10px;">Tag Text <input type="text" name="TagText" /></div>
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
