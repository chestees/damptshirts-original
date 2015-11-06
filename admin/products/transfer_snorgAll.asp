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

	'Format String
'	varString = replace(varString, "<ul id=""productListings"">", "")
'  varString = replace(varString, " height=""178""", "")
'  varString = replace(varString, " width=""188""", "")
'	varString = replace(varString, "</ul>", "")
'	varString = replace(varString, "<li id=""", "")
'	varString = replace(varString, """><a title=""", "[]")
'	varString = replace(varString, """ href=""", "[]")
'	varString = replace(varString, """><img alt=""", "[]")
'	varString = replace(varString, """ src=""", "[]")
'	varString = replace(varString, """></a></li>", "[]")
'	varString = replace(varString, "<li id=""", "")
'  varString = replace(varString, "[] ", "[]")

	
	varString = replace(varString, "<li ", "")
	varString = replace(varString, "id=", "[]")
	varString = replace(varString, "<a ", "")
	varString = replace(varString, "href=", "[]")
	varString = replace(varString, "title=", "[]")
	varString = replace(varString, "<img ", "")
	varString = replace(varString, "data-src=", "[]")	
	varString = replace(varString, "src=", "[]")
	varString = replace(varString, "class=", "[]")
	varString = replace(varString, "width=", "[]")
	varString = replace(varString, "height=", "[]")
	varString = replace(varString, "alt=", "[]")
	varString = replace(varString, "</li>", "")
	varString = replace(varString, "</a>", "")
	varString = replace(varString, ">", "")
	varString = replace(varString, "[]", "[]")
	varString = replace(varString, """[", "[")
	varString = replace(varString, "]""", "]")
	varString = replace(varString, """", "")
  
	
	blnActive = CheckBoxValue(Request("Active"))
	dtDate = Date()
	intDiggStoreID = 1
	intTagID = 1 'Snorg Tag
	
	Call OpenDB()
		
	strWrite = "<div class='clearfix'>"
	myArray = split(varString,"[]")
	j=0
	strWrite = strWrite & "<div class='mod_sql clearfix'>"&varString&"</div>"
	For i = 0 to Ubound(myArray)
		If j = 1 Then 
			strSlug = myArray(i)
      		strSlug = trim(strSlug)
		End If
		
		If j = 2 Then
			strLink = trim(myArray(i))
		End If
		
		If j = 3 Then
			strTitle = trim(myArray(i))
		End If
		
		If j = 5 Then
			strImage = trim(myArray(i))
		End If
		
		j = j + 1
		
		If j = 8 Then
			
			SQL = "SELECT DiggID, Link, Title FROM tblDigg WHERE Link = " & SQLEncode(strLink)
				Set RS = Conn.Execute(SQL)
				
				If RS.EOF Then

					SQL = "INSERT INTO tblDigg (" & _
						"Active, Image, Link, Title, Slug, DateAdded, SearchTerms, DiggStoreID" & _
						") VALUES (1, " & _
						SQLEncode(strImage) & ", " & _
						SQLEncode(strLink) & ", " & _
						SQLEncode(strTitle) & ", " & _
						SQLEncode(trim(strSlug)) & ", " & _
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
					
					SQL2 = "INSERT INTO relDiggTag (DiggID, TagID) VALUES (" & _
						SQLNumEncode(intDiggID) & ", " & _
						SQLNumEncode(intTagID) & ")"
						If blnActive Then
							Conn.Execute(SQL2)
						End If
					strTagSQL = SQL2
					
					strWrite = strWrite & "<div class='mod_sql clearfix'>"
					strWrite = strWrite & "<div style='float:left'><img src='" & strImage & "'></div>"
					strWrite = strWrite & "<div style='margin-left:220px;'>" & strTitle & "<br />" & SQL & "<br /><br />" & strTagSQL & "</div></div>"
				
				ElseIf isNull(RS("Title")) Then
					strTitlePos = InStrRev(strLink,"/")
					strTitle = Replace(strLink,Left(strLink, strTitlePos),"")
					strTitle = Replace(strTitle,"_"," ")
					
					SQL = "UPDATE tblDigg SET Title = " & SQLEncode(strTitle) & ", Active = 1 WHERE DiggID = " & RS("DiggID")
						If blnActive Then
							Conn.Execute(SQL)
						End If
					strWrite = strWrite & "<div class='mod_sql clearfix'>TITLE UPDATED: " & SQL & "</div>"
				
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
		<h1>PRODUCTS :: Snorg Tees</h1>
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
