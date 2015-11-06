<%@ Page Language="C#" MasterPageFile="~/DampTShirts.master" AutoEventWireup="true" CodeFile="detail.aspx.cs" Inherits="detail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
  <meta name="keywords" content="<%= strH1 %>,<%= txtKeywords %>" />
  <meta name="description" content="<%= varConst.cDescription %>" />
  <link rel="image_src" href="<%= strImage %>" />
  <meta property="og:title" content="<%= strH1 %>" />
  <meta property="og:description" content="<%= varConst.cDescription %>" />
  <meta property="og:type" content="product" />
  <meta property="og:site_name" content="<%= varConst.cFriendlySiteName %>" />
  <meta property="fb:app_id" content="<%= varConst.cFBAppID %>"/>
  <meta property="og:url" content="<%= "http://www." + varConst.cSiteName + ".com" + Request.ServerVariables["HTTP_X_ORIGINAL_URL"] %>" />
  <meta property="og:image" content="<%= strImageFB %>" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">    
  <div class="header_detail clearfix">
    <div class="shirt_detail">
      <h1><%= strH1 %></h1>
    </div>
    <asp:Literal ID="ProductThumbs" runat="server" />
  </div>
  <asp:Repeater ID="rptCoupons" runat="server" OnItemDataBound="Coupons_ItemDataBound">
    <HeaderTemplate><div class="coupon_bar clearfix"><div class="coupon_title">Did somebody say discount?</div></HeaderTemplate>
    <FooterTemplate></div></FooterTemplate>
    <ItemTemplate>
      <asp:Literal runat="server" ID="CouponItem" />
    </ItemTemplate>
  </asp:Repeater>
  <!-- START MAIN AREA -->
  <div class="main detail clearfix">
    <div class="main_left">
      <div class="share clearfix">
        <div class="b_margin_10">Share Some Love</div>
        <div class="share_widgets facebook">
          <div class="fb-like" data-send="false" data-layout="box_count" data-show-faces="false"></div>
        </div>
        <div class="share_widgets google">
          <g:plusone size="tall"></g:plusone>
        </div>
        <div class="clear"></div>
        <div class="share_widgets twitter">
          <a href="https://twitter.com/share" class="twitter-share-button" data-text="Check out Damp T-Shirts" data-via="damptshirts" data-hashtags="funnyshirts" data-count="vertical">Tweet</a>
          <script>      !function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0]; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = "//platform.twitter.com/widgets.js"; fjs.parentNode.insertBefore(js, fjs); } } (document, "script", "twitter-wjs");</script>  
        </div>
        <div class="share_widgets pinterest">
          <a href="http://pinterest.com/pin/create/button/?url=<%= "http://www." + varConst.cSiteName + ".com" + Request.ServerVariables["HTTP_X_ORIGINAL_URL"] %>&media=<%= strImage %>" class="pin-it-button" count-layout="vertical">Pin It</a>
          <script type="text/javascript" src="http://assets.pinterest.com/js/pinit.js"></script>
        </div>
        <div class="clear"></div>
        <div class="share_widgets reddit">
          <script type="text/javascript" src="http://www.reddit.com/static/button/button3.js"></script>
        </div>
        <div class="share_widgets stumble">
          <su:badge layout="5"></su:badge>
        </div>
      </div>
    </div>
		<div class="main_right">
      <asp:HyperLink ID="ProductLink" CssClass="detail_link" runat="server" />
      <a class="detail_img" href="<%= myLink %>" target="_blank"><asp:Image ID="ProductImage" runat="server" /></a>
      <asp:Repeater ID="ShirtTagCloud" runat="server" OnItemDataBound="ShirtTags_ItemDataBound">
        <HeaderTemplate><ul class="tags_shirt clearfix"><li>Tags:</li></HeaderTemplate>
        <FooterTemplate></ul></FooterTemplate>
        <SeparatorTemplate></SeparatorTemplate>
        <ItemTemplate>
          <asp:Literal runat="server" ID="ShirtTags" />
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </div>
</asp:Content>