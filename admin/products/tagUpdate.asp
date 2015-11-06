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
	
	Call OpenDB()
	
	intDiggStoreID = 6 ' Threadless
	intTagID = 88 'Threadless Tag
	
	strWrite = "<div style='align:center; padding:15px; text-align:left;'>"
			
	SQL = "SELECT DiggID, Image FROM tblDigg WHERE DiggStoreID = " & intDiggStoreID & " AND Active = 1 ORDER BY DiggID desc"
		Set RS = Conn.Execute(SQL)
		
	If Not RS.EOF Then
		Do While Not RS.EOF
			intDiggID = RS("DiggID")
			strImage = RS("Image")
			
			SQL = "SELECT RelationID FROM relDiggTag WHERE DiggID = " & intDiggID & " AND TagID = " & intTagID
				Set RS_REL = Conn.Execute(SQL)
			
			If RS_REL.EOF Then
				SQL = "INSERT INTO relDiggTag (" & _
					"DiggID, TagID" & _
					") VALUES (" & _
					SQLNumEncode(intDiggID) & ", " & _
					SQLNumEncode(intTagID) & ")"
					'Conn.Execute(SQL)
				strWrite = strWrite & "<div id='Product_Image' class='clearfix' style='border:1px solid #455560; margin-bottom:10px; padding:5px;'><img src='" & strImage & "' align='left'>" & SQL & "</div>"
			End If
		RS.MoveNext
		Loop
	End If
	
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
    PRODUCTS :: Tag Update
    </H1>
    <%=strWrite%>
    <form action="?Submit=True" method="post">
      <div style="padding:10px;margin-top:15px;float:left;width:900px;">
        <input type="submit" name="Submit" class="Submit" value="Submit">
      </div>
    </form>
  </div>
</div>
</body>
</html>
