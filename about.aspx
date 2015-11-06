<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DampTShirts.master" CodeFile="about.aspx.cs" Inherits="about" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
  <div class="main clearfix">
    <div class="main_left">
      <div class="module_1 b_margin_10">
        <div class="module_inner"><%= varConst.cRightColBanner_1 %></div>
      </div>
      <div class="module_1">
        <div class="module_inner">          
          <a target="_blank" href="http://www.shareasale.com/r.cfm?b=202882&amp;u=323844&amp;m=5108&amp;urllink=www.bustedtees.com&amp;afftrack=DampBanner"><img src="http://www.shareasale.com/image/5108/160natasha.jpg" alt="BustedTees - But 2, Get 1 Free" border="0" /></a>
        </div>
      </div>
    </div>
		<div class="main_right">
      <h1>What is Damp T-Shirt?</h1>
      <p>
        Damp T-Shirts is t-shirt search engine that allows you as the user to determine
        the search results order. See a t-shirt design you like, vote "<span class="txt_blue">thumbs
          up</span>". See one you don't, vote "<span class="txt_red">thumbs down</span>".
        Then when users search for t-shirts, the results are ordered based on the number
        of votes the t-shirt has. Of course this only works if you vote, so vote as much
        as you like and let's keep it honest.</p>
      <p>
        The Damp T-Shirts database has only the best t-shirts on the internet. We do our
        best to archive the best designed tees, designs printed on quality t-shirts and
        designs with original concepts. Because there are so many t-shirt shops online,
        we took it upon ourselves to archive the "best of" for all to enjoy.</p>
      <div class="aligncenter"><%= varConst.cFooterBanner %></div>
    </div>
  </div>
</asp:Content>
