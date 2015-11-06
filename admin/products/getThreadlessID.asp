<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
'_____________________________________________________________________________________________
'Get Variables
btnSubmit = Request("Submit")

'_____________________________________________________________________________________________
'ADD Record


	intDiggStoreID = 6 'Threadless Tag
	
	Call OpenDB()
		
	strWrite = "<div style='align:center; padding:15px; text-align:left;'>"

	SQL = "SELECT DiggID, Image FROM tblDigg where diggstoreid = 6"
		Set RS = Conn.Execute(SQL)
		
		If NOT RS.EOF Then
			intDiggID = RS("DiggID")
			strImage = RS("Image")
			strImage = Replace(strImage,"http://www.threadless.com/product/","")
			strImage = Replace(strImage,"/minizoom.jpg","")

			strWrite = strWrite & "<div>" & intDiggID & ": " & strImage & "</div>"
		
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

<body leftmargin="0" topmargin="0" marginWidth="0" marginHeight="0">	
<div id="Header">
  <div id="Header_Left" style="width:942px;">
    <div id="Logo" style="margin:0;"><a href="index.asp"><img src="<%=cPath%>images/t-shirt_Digg.png" alt="T-Shirt Digg" width="216" height="128" title="T-Shirt Digg"></a></div>
  </div>
</div>
<div id="Main">
  <div id="Main_Products">
    <H1 class="PageTitle">
    PRODUCTS :: Threadless ID Grab
    </H1>
    <%=strWrite%>
  </div>
</div>
</body>
</html>
