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
	intTagID = 556 'Threadless Tag
	
	Call OpenDB()
		
	strWrite = "<div style='align:center; padding:15px; text-align:left;'>"
	myArray = split(varString,"[]")
	j=0
	For i = 0 to Ubound(myArray)
		j = j + 1
		If j = 2 Then
			strLink = trim(myArray(i))
			strLink = Replace(strLink,"_DTG","")
		End If
		If j = 4 Then
			strImage = trim(myArray(i))
		End If
		If j = 4 Then
			
			SQL = "SELECT DiggID, Link, Title FROM tblDigg WHERE Link = " & SQLEncode(strLink)
				Set RS = Conn.Execute(SQL)
				
				If RS.EOF Then
					strTitlePos = InStrRev(strLink,"/")
					strTitle = Replace(strLink,Left(strLink, strTitlePos),"")
					strTitle = Replace(strTitle,"_"," ")
					strTitle = Replace(strTitle,".html","")
					strSlug = strTitle
					strSlug = Stripper(strSlug)

					SQL = "INSERT INTO tblDigg (" & _
						"Active, Image, Link, Title, Slug, DateAdded, SearchTerms, DiggStoreID" & _
						") VALUES (1, " & _
						SQLEncode(strImage) & ", " & _
						SQLEncode(strLink) & ", " & _
						SQLEncode(strTitle) & ", " & _
						SQLEncode(strSlug) & ", " & _
						SQLDateEncode(dtDate) & ", " & _
						SQLEncode("// " & strTitle) & ", " & _
						SQLNumEncode(16) & ")"
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

<body leftmargin="0" topmargin="0" marginWidth="0" marginHeight="0">	
<div id="Header">
  <div id="Header_Left" style="width:942px;">
    <div id="Logo" style="margin:0;"><a href="index.asp"><img src="<%=cPath%>images/t-shirt_Digg.png" alt="T-Shirt Digg" width="216" height="128" title="T-Shirt Digg"></a></div>
  </div>
</div>
<div id="Main">
  <div id="Main_Products">
    <H1 class="PageTitle">
    PRODUCTS :: Look at Me Shirts
    </H1>
    <%=strWrite%>
    <form action="?Submit=True" method="post">
      <div style="padding:10px;margin-top:15px;float:left;width:900px;">
      	<div style="margin-bottom:10px;"><textarea name="HTMLString" style="width:850px; height:250px;"></textarea></div>
        <div style="margin-bottom:10px;">For real: <input type="checkbox" name="Active" value="ON" /></div>
        <input type="submit" name="Submit" class="Submit" value="Submit">
      </div>
    </form>
  </div>
</div>
</body>
</html>
