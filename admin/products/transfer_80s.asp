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
	strTagArray = Request("TagArray")
	dtDate = Date()
	
	Call OpenDB()
	
	intDiggStoreID = 5
	intTagID = 301 '80s Tees
	
	If strTagArray <> "" Then
		TagArray = split(intTagID&","&strTagArray,",")
	End If
	
	strWrite = "<div class='clearfix'>"
	myArray = split(varString,"[]")
	j=0
	For i = 0 to Ubound(myArray)
		j = j + 1
		If j = 1 Then
			strLink = "http://www.80stees.com" & trim(myArray(i))
		End If
		If j = 3 Then
			strTitle = trim(myArray(i))
			strSlug = Stripper(trim(myArray(i)))
		End If
		If j = 4 Then
			strImage = "http://www.80stees.com" & trim(myArray(i))
		End If
		
		If j = 6 Then
			SQL = "SELECT DiggID, Link, Title FROM tblDigg WHERE Link = " & SQLEncode(strLink)
				Set RS = Conn.Execute(SQL)
				
				If RS.EOF Then
				
					SQL = "INSERT INTO tblDigg (" & _
						"Active, Image, Link, Title, Slug, DateAdded, SearchTerms, DiggStoreID" & _
						") VALUES (1, " & _
						SQLEncode(strImage) & ", " & _
						SQLEncode(strLink) & ", " & _
						SQLEncode(strTitle) & ", " & _
						SQLEncode(strSlug) & ", " & _
						SQLDateEncode(dtDate) & ", " & _
						SQLEncode("// " & strTitle) & ", " & _
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
							strWrite = strWrite & "<div class='mod_sql clearfix'>"
							strWrite = strWrite & "<p>" & SQL2 & "</p>"
					Next						
					strWrite = strWrite & "<div style='float:left'><img src='" & strImage & "'></div>"
					strWrite = strWrite & "<div style='margin-left:200px;'>" & strTitle & "<br />" & SQL & "<br /><br />" & strTagSQL & "</div></div>"
					strWrite = strWrite & "<div class='clear'></div>"
				Else
					strWrite = strWrite & "<div class='mod_sql clearfix'>DUPLICATE: " &  strLink & "</div>"
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
		<h1>PRODUCTS :: 80s Tees</h1>
		<div id="products" class="clearfix">
			<form action="?Submit=True" method="post">
			<div style="padding: 10px; margin-top: 15px; float: left; width: 900px;">
				<div style="margin-bottom:10px;">Tag Array <input type="text" name="TagArray" /> 1,2,3</div>
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
