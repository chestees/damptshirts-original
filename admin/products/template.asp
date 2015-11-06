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
		<h1>Template</h1>
		<div id="products" class="clearfix">
		</div>
	</div>
</div>
</body>
</html>