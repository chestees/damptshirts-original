<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include virtual="/includes/globalLib.asp" -->
<!--#include virtual="/includes/adovbs.inc" -->
<%
'_____________________________________________________________________________________________
'Get Variables
intDiggID = cInt(Request("DiggID"))
btnSubmit = Request("Submit")

'_____________________________________________________________________________________________
'ADD Record

If intDiggID = 0 AND btnSubmit <> "" Then
	
	Call OpenDB()
	
	strRedirect = Request("Redirect")
	If strRedirect = "" Then strRedirect = "/products/" End If
	blnActive = Request("Active")
	If blnActive <> 1 Then blnActive = 0
	strImage = Request("Image")
	strLgImage = Request("LgImage")
	strHoody = Request("Hoody")
	strLink = Request("Link")
	strTitle = trim(Request("Title"))
	intDiggStoreID = Request("DiggStoreID")
	dtDateAdded = now()	
	strSearchTerms = trim(Request("SearchTerms")) & " // " & trim(strTitle)
	strMoreTags = Request("MoreTags")
	strKeywords = Request("Keywords")
	strSlug = strTitle
	strSlug = Stripper(strSlug)
	
	'CHECK IF IT ALREADY EXISTS
	SQL = "SELECT DiggID FROM tblDigg WHERE Link = " & SQLEncode(strLink)
		Set	rsDup = Conn.Execute(SQL)
		
	If rsDup.EOF Then 'START CHECK IF IT ALREADY EXISTS
		
		Set cmd = Server.CreateObject("ADODB.Command")
		Conn.CursorLocation = 3
		Set cmd.ActiveConnection = Conn
		cmd.CommandText = "usp_Damp_ProductAdmin"
		
		cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
		cmd.Parameters("EditFlag") = 0
		cmd.Parameters.Append cmd.CreateParameter("Active",adInteger,adParamInput)
		cmd.Parameters("Active") = blnActive
		cmd.Parameters.Append cmd.CreateParameter("Image",adVarChar,adParamInput,500)
		cmd.Parameters("Image") = strImage
		cmd.Parameters.Append cmd.CreateParameter("LgImage",adVarChar,adParamInput,500)
		cmd.Parameters("LgImage") = strLgImage
		cmd.Parameters.Append cmd.CreateParameter("Hoody",adVarChar,adParamInput,500)
		cmd.Parameters("Hoody") = strHoody
		cmd.Parameters.Append cmd.CreateParameter("Link",adVarChar,adParamInput,200)
		cmd.Parameters("Link") = strLink
		cmd.Parameters.Append cmd.CreateParameter("Title",adVarChar,adParamInput,100)
		cmd.Parameters("Title") = strTitle
		cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
		cmd.Parameters("DiggStoreID") = intDiggStoreID
		cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
		cmd.Parameters("DiggID") = intDiggID
		cmd.Parameters.Append cmd.CreateParameter("SearchTerms",adVarChar,adParamInput, 500)
		cmd.Parameters("SearchTerms") = strSearchTerms
		cmd.Parameters.Append cmd.CreateParameter("Keywords",adVarChar,adParamInput, 500)
		cmd.Parameters("Keywords") = strKeywords
		cmd.Parameters.Append cmd.CreateParameter("DateAdded",adDBTimeStamp,adParamInput)
		cmd.Parameters("DateAdded") = dtDateAdded
		cmd.Parameters.Append cmd.CreateParameter("Slug",adVarChar,adParamInput, 150)
		cmd.Parameters("Slug") = strSlug
		cmd.Parameters.Append cmd.CreateParameter("MaxID",adInteger,adParamOutput)
		
		cmd.CommandType = adCmdStoredProc
		cmd.Execute
		
		intMaxID = cmd.Parameters("MaxID").Value
		
		'ADD NEW TAGS TO THE SEARCH FIELD
		strSearchTerms = trim(Request("SearchTerms")) & " // " & trim(strTitle)
		
		'MODIFY THE TAGS
		SQL = "SELECT TagID, Tag FROM tblDiggTag"
			Set	rsTag = Conn.Execute(SQL)
			
		If Not rsTag.EOF Then
			Do While Not rsTag.EOF
				
				intTagID = rsTag("TagID")
				Set intTagID_Form = Request("TagID_" & intTagID)
				strTag = rsTag("Tag")
	
				If intTagID_Form = 1 Then
					'response.Write("TAG")
					SQL = "INSERT INTO relDiggTag (" & _
						"DiggID, TagID " & _
						") VALUES (" & _
						SQLNumEncode(intMaxID) & ", " & _
						SQLNumEncode(intTagID) & ")"
						Conn.Execute(SQL)
					strSearchTerms = strSearchTerms & " " & strTag
				End If	
				
			rsTag.MoveNext
			Loop
			
		End If
		
		rsTag.Close
		Set rsTag = Nothing
		'END - MODIFY THE TAGS
		
		'INSERT ADDITIONAL TAGS
		myArray = Split(strMoreTags,",")
	
		For i = 0 to Ubound(myArray)
	
			strDiggTag = trim(myArray(i))
			strSlugTag = strDiggTag
			strSlugTag = Stripper(strSlugTag)
			strSearchTerms = strSearchTerms & " " & strDiggTag
			
			Set cmd = Server.CreateObject("ADODB.Command")
			Conn.CursorLocation = 3
			Set cmd.ActiveConnection = Conn
			cmd.CommandText = "usp_Digg_AddTags"
		
			cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
			cmd.Parameters("DiggID") = intMaxID
			cmd.Parameters.Append cmd.CreateParameter("DiggTag",adVarChar,adParamInput,50)
			cmd.Parameters("DiggTag") = strDiggTag
			cmd.Parameters.Append cmd.CreateParameter("Slug",adVarChar,adParamInput,150)
			cmd.Parameters("Slug") = strSlugTag
			cmd.Parameters.Append cmd.CreateParameter("MaxID",adInteger,adParamOutput)
			
			cmd.CommandType = adCmdStoredProc
			cmd.Execute
			
		Next
		'END - INSERT ADDITIONAL TAGS
	
		'Adds the tags to the search terms field.
		SQL = "UPDATE tblDigg SET SearchTerms = " & SQLEncode(trim(strSearchTerms)) & " WHERE DiggID = " & intMaxID
			Conn.Execute(SQL)
			
		Call CloseDB()
	
		Response.Redirect strRedirect
	Else
		Call CloseDB()
		blnDup = true
	End If 'END DUPLICATION CHECK

'_____________________________________________________________________________________________
'EDIT Record

ElseIf intDiggID > 0 AND btnSubmit <> "" Then

	Call OpenDB()
	
	blnDelete = CheckBoxValue(Request("DeleteMe"))
	strRedirect = Request("Redirect")
	
	If blnDelete = 1 Then
		SQL = "Delete FROM relDiggTag WHERE DiggID = " & intDiggID
		Conn.Execute(SQL)
		SQL = "Delete FROM tblDigg WHERE DiggID = " & intDiggID
		Conn.Execute(SQL)
		Response.Redirect strRedirect
	End If
	If strRedirect = "" Then strRedirect = "/products/" End If
	blnActive = Request("Active")
	If blnActive <> 1 Then blnActive = 0
	strImage = Request("Image")
	strLgImage = Request("LgImage")
	strHoody = Request("Hoody")
	strLink = Request("Link")
	strTitle = trim(Request("Title"))
	intDiggStoreID = Request("DiggStoreID")
	strSearchTerms = trim(Request("SearchTerms")) & " // " & trim(strTitle)
	strMoreTags = Request("MoreTags")
	strKeywords = Request("Keywords")
	strSlug = Request("Slug")
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_ProductAdmin"

	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = 1
	cmd.Parameters.Append cmd.CreateParameter("Active",adInteger,adParamInput)
	cmd.Parameters("Active") = blnActive
	cmd.Parameters.Append cmd.CreateParameter("Image",adVarChar,adParamInput,500)
	cmd.Parameters("Image") = strImage
	cmd.Parameters.Append cmd.CreateParameter("LgImage",adVarChar,adParamInput,500)
	cmd.Parameters("LgImage") = strLgImage
	cmd.Parameters.Append cmd.CreateParameter("Hoody",adVarChar,adParamInput,500)
	cmd.Parameters("Hoody") = strHoody
	cmd.Parameters.Append cmd.CreateParameter("Link",adVarChar,adParamInput,200)
	cmd.Parameters("Link") = strLink
	cmd.Parameters.Append cmd.CreateParameter("Title",adVarChar,adParamInput,100)
	cmd.Parameters("Title") = strTitle
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = intDiggStoreID
	cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
	cmd.Parameters("DiggID") = intDiggID
	cmd.Parameters.Append cmd.CreateParameter("SearchTerms",adVarChar,adParamInput, 500)
	cmd.Parameters("SearchTerms") = strSearchTerms
	cmd.Parameters.Append cmd.CreateParameter("Keywords",adVarChar,adParamInput, 500)
	cmd.Parameters("Keywords") = strKeywords
	cmd.Parameters.Append cmd.CreateParameter("DateAdded",adDBTimeStamp,adParamInput)
	cmd.Parameters("DateAdded") = null
	cmd.Parameters.Append cmd.CreateParameter("Slug",adVarChar,adParamInput, 150)
	cmd.Parameters("Slug") = strSlug
	cmd.Parameters.Append cmd.CreateParameter("MaxID",adInteger,adParamOutput)
	
	cmd.CommandType = adCmdStoredProc

	cmd.Execute
	
	'INSERT ADDITIONAL TAGS
	myArray = Split(strMoreTags,",")

	For i = 0 to Ubound(myArray)

		strDiggTag = trim(myArray(i))
		strSlugTag = strDiggTag
		strSlugTag = Stripper(strSlugTag)
		strSearchTerms = strSearchTerms & " // " & strDiggTag
		
		Set cmd = Server.CreateObject("ADODB.Command")
		Conn.CursorLocation = 3
		Set cmd.ActiveConnection = Conn
		cmd.CommandText = "usp_Digg_AddTags"
	
		cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
		cmd.Parameters("DiggID") = intDiggID
		cmd.Parameters.Append cmd.CreateParameter("DiggTag",adVarChar,adParamInput,50)
		cmd.Parameters("DiggTag") = strDiggTag
		cmd.Parameters.Append cmd.CreateParameter("Slug",adVarChar,adParamInput,150)
		cmd.Parameters("Slug") = strSlugTag
		cmd.Parameters.Append cmd.CreateParameter("MaxID",adInteger,adParamOutput)
		
		cmd.CommandType = adCmdStoredProc
		cmd.Execute

	Next
	'END - INSERT ADDITIONAL TAGS
	
	'MODIFY THE TAGS
	SQL = "SELECT Tag, TagID FROM tblDiggTag"
		Set	rsTag = Conn.Execute(SQL)
		
	If Not rsTag.EOF Then
		Do While Not rsTag.EOF
			
			intTagID = rsTag("TagID")
			Set intTagID_Form = Request("TagID_" & intTagID)
			strTag = rsTag("Tag")
			
			If intTagID_Form = 1 Then
				'response.Write("TAG")
				
				SQL = "INSERT INTO relDiggTag (" & _
					"DiggID, TagID " & _
					") VALUES (" & _
					SQLNumEncode(intDiggID) & ", " & _
					SQLNumEncode(intTagID) & ")"
					Conn.Execute(SQL)
					
				strSearchTerms = strSearchTerms & " " & strTag
							
			End If	
			
		rsTag.MoveNext
		Loop
		
		'Adds the tags to the search terms field.
		SQL = "UPDATE tblDigg SET SearchTerms = " & SQLEncode(trim(strSearchTerms)) & " WHERE DiggID = " & intDiggID
			Conn.Execute(SQL)
			
	End If
	
	rsTag.Close
	Set rsTag = Nothing
	'END - MODIFY THE TAGS
	
	Call CloseDB()
	
	Response.Redirect strRedirect

'_____________________________________________________________________________________________
'VIEW Record

ElseIf intDiggID > 0 AND btnSubmit = "" Then

	Call OpenDB()
	
	Set cmd = Server.CreateObject("ADODB.Command")
	Conn.CursorLocation = 3
	Set cmd.ActiveConnection = Conn
	cmd.CommandText = "usp_Damp_ProductAdmin"
	
	cmd.Parameters.Append cmd.CreateParameter("EditFlag",adInteger,adParamInput)
	cmd.Parameters("EditFlag") = -1
	cmd.Parameters.Append cmd.CreateParameter("Active",adInteger,adParamInput)
	cmd.Parameters("Active") = null
	cmd.Parameters.Append cmd.CreateParameter("Image",adVarChar,adParamInput,500)
	cmd.Parameters("Image") = null
	cmd.Parameters.Append cmd.CreateParameter("LgImage",adVarChar,adParamInput,500)
	cmd.Parameters("LgImage") = null
	cmd.Parameters.Append cmd.CreateParameter("Hoody",adVarChar,adParamInput,500)
	cmd.Parameters("Hoody") = null
	cmd.Parameters.Append cmd.CreateParameter("Link",adVarChar,adParamInput,200)
	cmd.Parameters("Link") = null
	cmd.Parameters.Append cmd.CreateParameter("Title",adVarChar,adParamInput,100)
	cmd.Parameters("Title") = null
	cmd.Parameters.Append cmd.CreateParameter("DiggStoreID",adInteger,adParamInput)
	cmd.Parameters("DiggStoreID") = null
	cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
	cmd.Parameters("DiggID") = intDiggID
	cmd.Parameters.Append cmd.CreateParameter("SearchTerms",adVarChar,adParamInput, 500)
	cmd.Parameters("SearchTerms") = null
	cmd.Parameters.Append cmd.CreateParameter("Keywords",adVarChar,adParamInput, 500)
	cmd.Parameters("Keywords") = null
	cmd.Parameters.Append cmd.CreateParameter("DateAdded",adDBTimeStamp,adParamInput)
	cmd.Parameters("DateAdded") = null
	cmd.Parameters.Append cmd.CreateParameter("Slug",adVarChar,adParamInput, 150)
	cmd.Parameters("Slug") = null
	cmd.Parameters.Append cmd.CreateParameter("MaxID",adInteger,adParamOutput)
	
	cmd.CommandType = adCmdStoredProc

	Set rsDigg = cmd.Execute

	intSelDiggStoreID = rsDigg("DiggStoreID")
	strImage = rsDigg("Image")
	strLgImage = rsDigg("ImageLg")
	strHoody = rsDigg("Hoody")
	strLink = rsDigg("Link")
	strTitle = rsDigg("Title")
	intThumbs = rsDigg("Thumbs")
	blnActive = rsDigg("Active")
	strSearchTerms = rsDigg("SearchTerms")
	strKeywords = rsDigg("Keywords")
	strSlug = rsDigg("Slug")

	Call CloseDB()
	
End If
%>
<html>
<head>
<title><%=cFriendlySiteName%> | Administration</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
<script type="text/javascript">
$(function () {
	$('.txtImage').change(function() {
		varImage = $('.txtImage').val();
		$('#fixed_img').attr('src', varImage);
	});
});
</script>
</head>

<body leftmargin="0" topmargin="0" marginWidth="0" marginHeight="0">
<img src="<%=strImage%>" id="fixed_img" />
<div id="leftCol">
  <img class="logo" src="/images/t-shirt_Digg.png" alt="Damp T-Shirts: A t-shirt search engine that puts you in control." />
	<!--#include virtual="/incNav.asp" -->
</div>
<div id="rightCol">
	<div class="tags"><%getTags()%></div>
	<div class="content">
		<%If blnDup Then%><h2 class="PageTitle" style="text-align:center;">That record is a duplicate.</h2><%End If%>
		<h1>
			<%If intDiggID = 0 Then%>
			PRODUCTS :: ADD
			<%Else%>
			PRODUCTS :: EDIT
			<%End If%>
		</h1>
		<form action="edit.asp?DiggID=<%=intDiggID%>&Submit=True" method="post">
			<div class="clearfix">
				<input type="hidden" name="Redirect" value="<%=request.servervariables("http_referer")%>">
				<div style="padding:10px;">Active?
					<input name="Active" type="checkbox" value="1"<%If blnActive OR intDiggID = 0 Then Response.Write(" checked")%>>
					<%If intDiggID > 0 Then%>
        		<input name="DeleteMe" type="checkbox" style="float:right;">       	
					<%End If%>
				</div>
				<div style="padding:10px;">Title<br />
					<input name="Title" type="text" style="width:500px;" value="<%=strTitle%>">
				</div>
				<div style="padding:10px;">Slug<br />
					<input name="Slug" type="text" style="width:500px;" value="<%=strSlug%>">
				</div>
				<div style="padding:10px;">Store</span><br />
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
				<div style="padding:10px;">Main Image<br />
					<input name="Image" type="text" style="width:500px;" value="<%=strImage%>" class="txtImage">
				</div>

				<div style="padding:10px;">Large Image<br />
					<input name="LgImage" type="text" style="width:500px;" value="<%=strLgImage%>" class="txtImage">
				</div>

				<div style="padding:10px;">Hoody Image<br />
					<input name="Hoody" type="text" style="width:500px;" value="<%=strHoody%>" class="txtImage">
				</div>

				<div style="padding:10px;">Link<br />
					<input name="Link" type="text" style="width:500px;" value="<%=strLink%>">
				</div>
				<div style="padding:10px;">
      		Search Terms<br />
      		<textarea name="SearchTerms" style="width:500px; height:100px;"></textarea><br />
					<span style="font-size:11px;"><b>Existing:</b> <%=strSearchTerms%></span>
				</div>
				<div style="padding:10px;">
      		Meta Keywords<br />
      		<textarea name="Keywords" style="width:500px; height:100px;"><%=strKeywords%></textarea>
				</div>
				<div style="padding:10px;">
      		Additional Tags (comma separated)<br />
      		<input name="MoreTags" type="text" style="width:500px;" value="<%=strMoreTags%>">
				</div>
				<div style="padding:10px;margin-top:15px;float:left;width:900px;">
					<input type="submit" name="Submit" style="width:600px; height:100px; font-size:72px;" value="Submit">
				</div>
			</div>
      <div style="padding:10px;" class="clearfix">
				Tags<br />
<%
OpenDB()

Set cmd = Server.CreateObject("ADODB.Command")
Conn.CursorLocation = 3
Set cmd.ActiveConnection = Conn
cmd.CommandText = "usp_Digg_GetTags_CMS"

cmd.Parameters.Append cmd.CreateParameter("DiggID",adInteger,adParamInput)
cmd.Parameters("DiggID") = intDiggID
	
cmd.CommandType = adCmdStoredProc

Set rsTag = cmd.Execute
	
If Not rsTag.EOF Then
	i=0
	Do While Not rsTag.EOF
		i = i + 1
		intTagID = rsTag("TagID")
		strTag = rsTag("Tag")
		blnMatch = rsTag("TagCheck")
		'response.Write("H: " & rsTag("TagCheck"))
		If i = 1 Then response.Write("<div class=""tag_col"">")
%>
          <input name="TagID_<%=intTagID%>" type="checkbox" value="1" <%If blnMatch > 0 Then Response.Write("checked")%>> <%=strTag%><br />
<%
		If i = 45 Then
			response.Write("</div>")
			i = 0
		End If
	rsTag.MoveNext
	Loop
	
	If i < 45 AND rsTag.EOF Then
		response.Write("</div>")
	End If
	rsTag.Close
	Set rsTag = nothing
	
End If

CloseDB()
%>
			
			</div>
			<div style="padding:10px;margin-top:15px;float:left;width:900px;">
				<input type="submit" name="Submit" class="submit_lg" value="Submit">
			</div>
		</form>
	</div>
</div>