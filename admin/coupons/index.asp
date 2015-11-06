<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="/css/jquery-ui-1.8.21.custom.css">
<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.8.17.custom.min.js"></script>
<script>
$(function() {
	$("#dialog-confirm").dialog({ autoOpen: false })
	
	$('.delete').click(function() {
		intCouponID = $(this).parent().attr("ID");
		$("#dialog-confirm").dialog('open')
	});
	
	$("#dialog-confirm").dialog({
		resizable: false,
		height:140,
		modal: true,
		buttons: {
			"Delete all items": function() {
				deleteRecord();
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	function deleteRecord() {
		$.ajax({
		  type: "POST",
		  url: "edit.asp",
		  data: "CouponID="+intCouponID+"&EditFlag=3",
		  cache: false,
  		  success: function(html){
		  	$("#dialog-confirm").dialog( "close" );
			$("#"+intCouponID).remove();
		  }
		});
	}
});
</script>
<div id="dialog-confirm" title="Delete Coupon?">
	<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These items will be permanently deleted and cannot be recovered. Are you sure?</p>
</div>
<%
'OPEN DATABASE CONNECTION
Call OpenDB()

'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'BEGIN RS
Set cmd = Server.CreateObject("ADODB.Command")
Conn.CursorLocation = 3
Set cmd.ActiveConnection = Conn
cmd.CommandText = "usp_Digg_StoresList"

cmd.CommandType = adCmdStoredProc
Set rsStore = cmd.Execute

'END RS
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%>
</head>
<body>
<div id="leftCol">
  <img class="logo" src="/images/t-shirt_Digg.png" alt="Damp T-Shirts: A t-shirt search engine that puts you in control." />
	<!--#include virtual="/incNav.asp" -->
</div>
<div id="rightCol">
	<div class="tags"><%getTags()%></div>
	<div class="content">
		<h1>Coupons</h1>
		
		<div class="coupons">
			<div style="float:right;"><a class="btn btn_blue" href="edit.asp?DiggStoreID=<%=rsStore("DiggStoreID")%>">Add Coupon</a></div>
<%
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'START TEES RECORDSET
'Response.Cookies(cSiteName).Expires = now
OpenDB
If Not rsStore.EOF Then
	Do While Not rsStore.EOF
	
		intStoreID = rsStore("DiggStoreID")
		strStore = rsStore("DiggStore")
%>
            
	<div class="mod_coupon">
    <div>
      <a href="edit.asp?StoreID=<%=intStoreID%>"><%=strStore%></a>
<%
	Set cmdCoupon = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmdCoupon.ActiveConnection = Conn
	cmdCoupon.CommandText = "usp_Digg_CouponList_CMS"
	cmdCoupon.Parameters.Append cmdCoupon.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmdCoupon.Parameters("DiggStoreID") = intStoreID
		
	cmdCoupon.CommandType = adCmdStoredProc
	Set rsCoupon = cmdCoupon.Execute
		
	If Not rsCoupon.EOF Then
		Do While Not rsCoupon.EOF
%>
			<div id="<%=rsCoupon("CouponID")%>" class="coupon_bar<%If rsCoupon("EndDate") < Date() Then response.Write(" on")%>"><div class="delete btn btn_red">DELETE</div>&nbsp;<a class="btn btn_blue" href="edit.asp?CouponID=<%=rsCoupon("CouponID")%>">EDIT</a> - <%=rsCoupon("Coupon")%></div>
<%
		rsCoupon.MoveNext
		Loop
	Else
%>
			<div style="margin-left:30px; font-size:12px;">No Coupons</div>
<%
	End If
%>
			</div>
    </div>
<%
	rsStore.MoveNext
	Loop
	
End If
'END TEES RECORDSET
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

CloseDB()
%>
		</div>
	</div>
</div>
</body>
</html>