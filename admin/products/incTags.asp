<div id="Tags" style="margin-top: 15px;">
	<!-- START TAGS -->
	<div id="Tags_Title">POPULAR TAGS</div>
	<div id="Tags_Links">
		<%
If NOT rsTags.EOF Then
	Do While NOT rsTags.EOF
		intTagID = rsTags("TagID")
		strTag = rsTags("Tag")
		intTagCount = rsTags("TagCount")
		%>
		<a href="/products/index.asp?TagID=<%=intTagID%>">
			<%=strTag%>
			(<%=intTagCount%>)</a>
		<%
	rsTags.MoveNext
	If NOT rsTags.EOF Then response.Write("*")
	Loop
End If
		%>
	</div>
	<!-- END TAGS -->
</div>
