<%@ Page Language="C#" MasterPageFile="~/DampTShirts.master" AutoEventWireup="true" CodeFile="tagList.aspx.cs" Inherits="tagList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
  <meta name="keywords" content="<%= varConst.keywords()%>" />
  <meta name="description" content="<%= varConst.cDescription %>" />
  <link rel="image_src" href="<%= strImage %>" />
  <meta property="og:title" content="<%= varConst.cFriendlySiteName %> Shirt Tags" />
  <meta property="og:description" content="<%= varConst.cDescription %>" />
  <meta property="og:type" content="product" />
  <meta property="og:site_name" content="<%= varConst.cFriendlySiteName %>" />
  <meta property="fb:app_id" content="<%= varConst.cFBAppID %>"/>
  <meta property="og:url" content="<%= "http://www." + varConst.cSiteName + ".com/"%>" />
  <meta property="og:image" content="<%= strImage %>" />
	<script type="text/javascript">
		$(function () {
			var perCol;
			var strTags = "<ul>";
			//var cols = 3;
			var modWidth = $(".tag_list_full").outerWidth();
				var cols = Math.floor(modWidth / 256);
				//var perPage = (16*perRow)-1;

			var index = 0;
			var currentLoaded = 0;
			var jsonTagsFull =  $(<%= jsonTagsFull %>);
			jsonLength = jsonTagsFull.length;
			perCol = Math.ceil(jsonLength/cols);

			for (var counter = index; counter < jsonLength; counter++) {
				if(counter >= jsonLength) {
					break;
				}
				BuildTagList(jsonTagsFull[counter]);
				index++;
				if(index == perCol) {
					strTags = strTags + "</ul><ul>";
					index = 0; 
				}
			}
			function BuildTagList(item) {
				if ('<%= varConst.cSiteName %>' == 'damptshirts') {
					strTags = strTags + "<li><a href=\"/<%= varConst.cSEODirectory %>/tag/" + item[0] + "/" + item[2] + "/\">" + item[1] + "</a> <span class=\"count\">(" + item[3] + ")</span></li>";
				} else {
					strTags = strTags + "<li><a href=\"/" + item[2] + "/tag/" + item[0] + "/\">" + item[1] + "</a> <span class=\"count\">(" + item[3] + ")</span></li>";
				}
			}
			strTags = strTags + "</ul>";
			$(".allTags .allTags_inner").append(strTags);
			<% if (path == "/tagList.aspx") { %>
				$(".tag_list_full").append(strTags);
			<% } %>
		});
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
  <div class="main clearfix">
    <div class="main_left">
      <%if(varConst.cRightColBanner_1 != "") { %>
      <div class="module_1 b_margin_10">
        <%= varConst.cRightColBanner_1 %>
      </div>
      <%} %>
      <div class="module_1 ad"> 
        <a target="_blank" href="http://www.shareasale.com/r.cfm?b=202882&amp;u=323844&amp;m=5108&amp;urllink=www.bustedtees.com&amp;afftrack=DampBanner"><img src="http://www.shareasale.com/image/5108/160natasha.jpg" alt="BustedTees - But 2, Get 1 Free" border="0" /></a>
      </div>
    </div>
		<div class="main_right">
			<h1><%= varConst.cFriendlySiteName%> Tag List</h1>
			<div class="tag_list_full"></div>
    </div>
	</div>
</asp:Content>

