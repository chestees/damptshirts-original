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
	varString = trim(Request("HTMLString"))

	'Format String
	'varString = replace(varString, "<ul class=""cfx"">", "")
'	varString = replace(varString, "<!-- page product row -->", "")
'	varString = replace(varString, "child_n child_4", "")	
'	varString = replace(varString, " style=""width:182px;""", "")
'	varString = replace(varString, " style=""height:214px;""", "")
'	varString = replace(varString, " data-tile=""product""", "")
'	varString = replace(varString, " tile=""product""", "")
'	varString = replace(varString, " style=""margin-bottom:6px;""", "")
'	varString = replace(varString, " height=""180""", "")
'	varString = replace(varString, " width=""180""", "")
'	varString = replace(varString, "<div id=""product_title_b"">", "")
'	varString = replace(varString, "> <", "><")
'	varString = replace(varString, "</ul>", "")
'	varString = replace(varString, "<li style=""height:214px;"" id=""", "")
'	varString = replace(varString, "<li style=""height: 214px;"" id=""", "")
'	varString = replace(varString, """ class="""">", "")
'	varString = replace(varString, "<div class=""tiles"" id=""tile"">", "")
'	varString = replace(varString, "<a id=""tile_product"" class=""tile_product"" title=""", "[]")
'	varString = replace(varString, """ data-gaqtrackaction=""", "[]")
'	varString = replace(varString, """ href=""", "[]")
'	varString = replace(varString, """><span class=""product_price_overlay"">", "[]")
'	varString = replace(varString, "</span>", "")
'	varString = replace(varString, "<img src=""", "[]")
'	varString = replace(varString, """ alt=""", "[]")
'	varString = replace(varString, """</a>", "")
'	varString = replace(varString, "<a id=""product_title_b"" class=""product_title_b"" title=""", "")
'	varString = replace(varString, """ data-gaqtrackaction=""", "[]")
'	varString = replace(varString, """ href=""", "[]")
'	varString = replace(varString, "</a></div>", "[]")
'	varString = replace(varString, "</div>", "")
'	varString = replace(varString, """>", "[]")
'	varString = replace(varString, " []", "[]")
'	varString = replace(varString, " tile", "tile")

	varString = replace(varString, """", "")
	varString = replace(varString, "<li ", "")
	varString = replace(varString, "<img ", "")
	varString = replace(varString, "<a ", "")
	varString = replace(varString, "<div ", "")
	varString = replace(varString, "<span ", "")
	varString = replace(varString, "src=", "[]")
	varString = replace(varString, "href=", "[]")
	varString = replace(varString, "id=", "[]")
	varString = replace(varString, "class=", "[]")
	varString = replace(varString, "style=", "[]")
	varString = replace(varString, "width=", "[]")
	varString = replace(varString, "height=", "[]")
	varString = replace(varString, "title=", "[]")
	varString = replace(varString, "alt=", "[]")
	varString = replace(varString, "data-tile=", "[]")
	varString = replace(varString, "tile=", "[]")
	varString = replace(varString, "data-gaqtrackaction=", "[]")
	varString = replace(varString, "data-tile=", "[]")
	varString = replace(varString, "</li>", "")
	varString = replace(varString, "</a>", "")
	varString = replace(varString, "</div>", "")
	varString = replace(varString, "</span>", "")
	varString = replace(varString, ">", "")
	
	blnActive = CheckBoxValue(Request("Active"))
	strTagArray = Request("TagArray")
	dtDate = Date()
	
	Call OpenDB()
	
	intDiggStoreID = 2
	intTagID = 66 'Busted Tees
	
	If strTagArray <> "" Then
		TagArray = split(intTagID&","&strTagArray,",")
	End If
	
	strWrite = "<div class='clearfix'>"
	myArray = split(varString,"[]")
	j=0
	strWrite = strWrite & "<div class='mod_sql clearfix'>"&varString&"</div>"
	For i = 0 to Ubound(myArray)	
		If j = 7 Then
			strTitle = trim(myArray(i))
			strSlug = Stripper(trim(myArray(i)))
		End If

		If j = 6 Then
			strLink = "http://www.bustedtees.com" & trim(myArray(i))
		End If
		
		If j = 14 Then
			strImage = trim(myArray(i))
		End If
		
		j = j + 1
		
		If j = 23 Then
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
					
					If strTagArray <> "" Then
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
					Else
						SQL2 = "INSERT INTO relDiggTag (DiggID, TagID) VALUES (" & _
								SQLNumEncode(intDiggID) & ", " & _
								SQLNumEncode(intTagID) & ")"
								If blnActive Then
									Conn.Execute(SQL2)
								End If
							strWrite = strWrite & "<div class='mod_sql clearfix'>"
							strWrite = strWrite & "<p>" & SQL2 & "</p>"
					End If
					
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
		<h1>PRODUCTS :: Busted Tees</h1>
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
