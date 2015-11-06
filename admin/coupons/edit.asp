<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
'_____________________________________________________________________________________________
'Get Variables
intCouponID = cInt(Request("CouponID"))
intDiggStoreID = cInt(Request("DiggStoreID"))
btnSubmit = Request("Submit")
editFlag = cint(Request("EditFlag"))

'_____________________________________________________________________________________________
'ADD Record

If intCouponID = 0 AND btnSubmit <> "" Then
	
	Call OpenDB()
	
	strCoupon = Request("Coupon")
	dtEndDate = Request("EndDate")
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_CouponAdmin"
	
	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = 0	
	cmd.Parameters.Append cmd.CreateParameter("CouponID",adInteger,adParamInput)
	cmd.Parameters("CouponID") = intCouponID
	cmd.Parameters.Append cmd.CreateParameter("Coupon",adVarChar,adParamInput,500)
	cmd.Parameters("Coupon") = Server.HTMLEncode(strCoupon)
	cmd.Parameters.Append cmd.CreateParameter("EndDate", adDBTimeStamp, adParamInput)
	cmd.Parameters("EndDate") = dtEndDate
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = intDiggStoreID
	
	cmd.CommandType = adCmdStoredProc
	cmd.Execute

	Call CloseDB()

	Response.Redirect "index.asp"

'_____________________________________________________________________________________________
'EDIT Record

ElseIf intCouponID > 0 AND btnSubmit <> "" Then

	Call OpenDB()
	
	strCoupon = Request("Coupon")
	dtEndDate = Request("EndDate")

	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_CouponAdmin"
	
	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = 1
	cmd.Parameters.Append cmd.CreateParameter("CouponID",adInteger,adParamInput)
	cmd.Parameters("CouponID") = intCouponID
	cmd.Parameters.Append cmd.CreateParameter("Coupon",adVarChar,adParamInput,500)
	cmd.Parameters("Coupon") = strCoupon
	cmd.Parameters.Append cmd.CreateParameter("EndDate", adDBTimeStamp, adParamInput)
	cmd.Parameters("EndDate") = dtEndDate
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = intDiggStoreID
		
	cmd.CommandType = adCmdStoredProc
	cmd.Execute
		
	Call CloseDB()
	
	Response.Redirect "index.asp"

'_____________________________________________________________________________________________
'VIEW Record

ElseIf intCouponID > 0 AND btnSubmit = "" and editFlag = 0 Then

	Call OpenDB()
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_CouponAdmin"
	
	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = 2
	cmd.Parameters.Append cmd.CreateParameter("CouponID",adInteger,adParamInput)
	cmd.Parameters("CouponID") = intCouponID
	cmd.Parameters.Append cmd.CreateParameter("Coupon",adVarChar,adParamInput,500)
	cmd.Parameters("Coupon") = null
	cmd.Parameters.Append cmd.CreateParameter("EndDate", adDBTimeStamp, adParamInput)
	cmd.Parameters("EndDate") = null
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = null
	
	cmd.CommandType = adCmdStoredProc

	Set rsDigg = cmd.Execute
	
	intSelDiggStoreID = rsDigg("DiggStoreID")
	strCoupon = rsDigg("Coupon")
	dtEndDate = rsDigg("EndDate")

	Call CloseDB()

ElseIf intCouponID > 0 AND btnSubmit = "" and editFlag = 3 Then

	Call OpenDB()
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_CouponAdmin"
	
	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = editFlag
	cmd.Parameters.Append cmd.CreateParameter("CouponID",adInteger,adParamInput)
	cmd.Parameters("CouponID") = intCouponID
	cmd.Parameters.Append cmd.CreateParameter("Coupon",adVarChar,adParamInput,250)
	cmd.Parameters("Coupon") = null
	cmd.Parameters.Append cmd.CreateParameter("EndDate",adDBTimeStamp, adParamInput)
	cmd.Parameters("EndDate") = null
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = null
	
	cmd.CommandType = adCmdStoredProc
	cmd.Execute

	Call CloseDB()
End If
%>
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="/css/jquery-ui-1.8.21.custom.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
<script type="text/javascript">
	$(function() {
		$( "#endDate" ).datepicker();
	});
</script>
</head>

<body>
<div id="leftCol">
  <img class="logo" src="/images/t-shirt_Digg.png" alt="Damp T-Shirts: A t-shirt search engine that puts you in control." />
	<!--#include virtual="/incNav.asp" -->
</div>
<div id="rightCol">
	<div class="tags"><%getTags()%></div>
	<div class="content">
		<h1><%If intCouponID = 0 Then%>
    COUPONS :: ADD
    <%Else%>
    COUPONS :: EDIT
    <%End If%></h1>
		<form action="edit.asp?CouponID=<%=intCouponID%>&Submit=True" method="post">
      <div style="padding:10px;">Coupon<br>
        <textarea name="Coupon" style="width:700px; height:300px;"><%=strCoupon%></textarea>
      </div>
      <div style="padding:10px;">Store</span><br>
        <select style="width:500px;" size="1" name="DiggStoreID">
          <option value="0">_____________________</option>
          <%
OpenDB()
SQL = "SELECT DiggStoreID, DiggStore FROM tblDiggStore"
	Set	rsCat = Conn.Execute(SQL)
	
	Do While Not rsCat.EOF
	
		intDiggStoreID = rsCat("DiggStoreID")
		strDiggStore = rsCat("DiggStore")
%>
          <option value="<%=intDiggStoreID%>"<%If intDiggStoreID = cInt(intSelDiggStoreID) Then Response.Write(" SELECTED")%>><%=strDiggStore%></option>
          <%
	rsCat.MoveNext
	Loop
	
rsCat.Close
Set rsCat = Nothing

CloseDB()
%>
        </select>
      </div>
			<div style="padding:10px;">End Date</span><br>
      	<input type="text" value="<%=dtEndDate%>" name="endDate" id="endDate" />
      </div>
      <div style="padding:10px;margin-top:15px;float:left;width:900px;">
        <input type="submit" name="Submit" style="width:600px; height:100px; font-size:72px;" value="Submit">
      </div>
    </form>
	</div>
</div>
</body>
</html>