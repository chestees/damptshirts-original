<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
<script type="text/javascript" src="/includes/jquery.js"></script>
<script type="text/javascript" src="/includes/jquery.ui.js"></script>
<!--[if IE]><script src="/includes/excanvas.js" type="text/javascript" charset="utf-8"></script><![endif]-->
<script type="text/javascript" src="/includes/jquery.bt.min.js"></script>
<script type="text/javascript">
$(function () {
	$('.pop').bt({ contentSelector: "$(this).children('.popOut').html()",
	fill: '#F7F7F7', 
	strokeStyle: '#B7B7B7', 
	spikeLength: 10, 
	spikeGirth: 10, 
	padding: 8, 
	cornerRadius: 0, 
	cssStyles: {
	fontFamily: '"lucida grande",tahoma,verdana,arial,sans-serif', 
	fontSize: '11px'
	},
	positions: ['top', 'right', 'left', 'bottom']
	});
}); 
</script>
<%
cNumberPerPage = 200

'TAG VARIABLES
intMyTagID = cInt(Request("TagID"))
strMyTag = Request("Tag")
If isNull(intMyTagID) Then
	intMyTagID = 0
End If
intHoody = cInt(Request("hoody"))

intPage = cInt(Request("Page"))
If intPage = 0 Then intPage = 1

intCurrentPage = intPage

If intPage > 1 Then intPage = (intPage*cNumberPerPage)-(cNumberPerPage-1)

'SEARCH VARIABLES
strSearch = request("Search")
If strSearch = "" Then strSearch = "0" End If

'OPEN DATABASE CONNECTION
Call OpenDB()

'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'BEGIN T-SHIRT RS
Set cmd = Server.CreateObject("ADODB.Command")
Conn.CursorLocation = 3
Set cmd.ActiveConnection = Conn
	If intMyTagID > 0 Then

		cmd.CommandText = "usp_Digg_Paging_Tag_CMS"
		
		cmd.Parameters.Append cmd.CreateParameter("PageSize",adInteger,adParamInput)
		cmd.Parameters("PageSize") = cNumberPerPage
		cmd.Parameters.Append cmd.CreateParameter("StartRow",adInteger,adParamInput)
		cmd.Parameters("StartRow") = intPage
		
		cmd.Parameters.Append cmd.CreateParameter("TagID",adInteger,adParamInput)
		cmd.Parameters("TagID") = intMyTagID
	
	ElseIf intHoody = 1 Then
	
		cmd.CommandText = "usp_Digg_Paging_Hoody_CMS"
		
		cmd.Parameters.Append cmd.CreateParameter("PageSize",adInteger,adParamInput)
		cmd.Parameters("PageSize") = cNumberPerPage
		cmd.Parameters.Append cmd.CreateParameter("StartRow",adInteger,adParamInput)
		cmd.Parameters("StartRow") = intPage

	Else
	
		cmd.CommandText = "usp_Digg_Paging_CMS"
		
		cmd.Parameters.Append cmd.CreateParameter("PageSize",adInteger,adParamInput)
		cmd.Parameters("PageSize") = cNumberPerPage
		cmd.Parameters.Append cmd.CreateParameter("StartRow",adInteger,adParamInput)
		cmd.Parameters("StartRow") = intPage
	
	End If
cmd.CommandType = adCmdStoredProc
Set rsTees = cmd.Execute

'END T-SHIRT RS
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'BEGIN TAGS
Set cmd = Server.CreateObject("ADODB.Command")
Conn.CursorLocation = 3
Set cmd.ActiveConnection = Conn
cmd.CommandText = "usp_Digg_GetTags2"
cmd.CommandType = adCmdStoredProc
cmd.Parameters.Append cmd.CreateParameter("SelectNum",adInteger,adParamInput)
cmd.Parameters("SelectNum") = 0
cmd.Parameters.Append cmd.CreateParameter("SiteName",adVarChar,adParamInput,50)
cmd.Parameters("SiteName") = "damptshirts"
cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
cmd.Parameters("DiggID") = 0

Set rsTags = cmd.Execute
'END TAGS
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
<%
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'BEGIN PAGE SYSTEM
OpenDB()
Set cmd = Server.CreateObject("ADODB.Command")
Conn.CursorLocation = 3
Set cmd.ActiveConnection = Conn

cmd.CommandText = "usp_Digg_Pages"

cmd.Parameters.Append cmd.CreateParameter("TagID",adInteger,adParamInput)
cmd.Parameters("TagID") = intMyTagID
cmd.Parameters.Append cmd.CreateParameter("Hoody",adInteger,adParamInput)
cmd.Parameters("Hoody") = intHoody
cmd.Parameters.Append cmd.CreateParameter("Search",adVarChar,adParamInput,50)
cmd.Parameters("Search") = strSearch

cmd.CommandType = adCmdStoredProc

Set rsPaging = cmd.Execute

intStartValue = 1
intPerPage = cInt(cNumberPerPage)
intDiggCount = cInt(rsPaging("DiggCount"))
intCeiling = Ceiling(intDiggCount/intPerPage)

If intCurrentPage > 5 Then
	intStartValue = intCurrentPage - 5
	intEndValue = intCurrentPage + 4
	If intEndValue > intCeiling Then
		intStartValue = intCeiling - 9
		intEndValue = intCeiling
	End If
ElseIf intCurrentPage <= 5 Then
	intStartValue = 1
	intEndValue = 10
	If intEndValue > intCeiling Then
		intEndValue = intCeiling
	End If
End If

set cmd = nothing
%>
		<%If intMyTagID > 0 Then%>
		<h1><%=strMyTag%></h1>
		<%ElseIf intHoody = 1 Then%>
		<h1>Hoodies (<%=intDiggCount%>)</h1>
		<%Else%>
		<h1>Active (<%=intDiggCount%>)</h1>
		<%End If%>
		<div id="paging">
			<%If intCurrentPage > 1 Then%>
				<a href="/products/index.asp?Page=1&TagID=<%=intMyTagID%>"><u>&lt;&lt;</u></a> <a href="/products/index.asp?Page=<%=intCurrentPage-1%>&TagID=<%=intMyTagID%>">&lt; Previous</a>
			<%End If%>
<%
for i = intStartValue to intEndValue
%>
      <a href="/products/index.asp?Page=<%=i%>&TagID=<%=intMyTagID%>" class="numbers <%If intCurrentPage = i Then%> active<%End If%>"><%=i%></a>
<%
next
'END PAGE SYSTEM
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%>
      <%If intCurrentPage < intCeiling Then%>
      <a href="/products/index.asp?Page=<%=intCurrentPage+1%>&TagID=<%=intMyTagID%>">Next &gt;</a> <a href="/products/index.asp?Page=<%=intCeiling%>&TagID=<%=intMyTagID%>"><u>&gt;&gt;</u></a>
      <%End If
			CloseDB()
			%>
		</div>
		<div id="products" class="clearfix">			
<%
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
'START TEES RECORDSET
'Response.Cookies(cSiteName).Expires = now
OpenDB
If Not rsTees.EOF Then
	Do While Not rsTees.EOF
		intDiggID = rsTees("DiggID")
		strImage = rsTees("Image")
		strTitle = rsTees("Title")
		intThumbs = rsTees("Thumbs")
		strLink = rsTees("Link")
		strSlug = rsTees("Slug")
		
		Set cmd = Server.CreateObject("ADODB.Command")
		Conn.CursorLocation = 3
		Set cmd.ActiveConnection = Conn
		cmd.CommandText = "usp_Digg_ShirtTagList"
		cmd.CommandType = adCmdStoredProc
		cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
		cmd.Parameters("DiggID") = intDiggID	
		
		cmd.CommandType = adCmdStoredProc
		Set rsShirtTags = cmd.Execute	
%>
    <div class="product" style="width:108px; height:140px;">
      <div class="product_img" style="background:none;"><a href="edit.asp?DiggID=<%=intDiggID%>"><img style="width:100px;" src="<%=strImage%>" alt=" <%=strTitle%> " title=" <%=strTitle%> "></a>
        <div class="product_lnks"><a target="_blank" href="<%=strLink%>">URL</a> - 
        	<a target="_blank" href="http://www.damptshirts.com/t-shirts/detail/<%=intDiggID%>/<%=strSlug%>/">DAMP</a>
          <div class="pop"> - TAGS
            <div class="popOut" style="display:none; cursor:pointer;">
			  <%
If Not rsShirtTags.EOF Then 
	Do While Not rsShirtTags.EOF
%>
              <a href="index.asp?TagID=<%=rsShirtTags("TagID")%>"><%=rsShirtTags("Tag")%></a>
              <%
	rsShirtTags.MoveNext
	Loop
End If
%>
          		</div>
						</div>
					</div>
				</div>
			</div>
    <%
	rsTees.MoveNext
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