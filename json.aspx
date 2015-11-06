<%@ Page Title="Site Map" Language="C#" MasterPageFile="~/DampTShirts.master" AutoEventWireup="true" CodeFile="json.aspx.cs" Inherits="json" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
  <div class="main clearfix">
    <div class="main_left">
      <div class="module_1 b_margin_10">
        <div class="module_inner"><%= varConst.cRightColBanner_1 %></div>
      </div>
      <div class="module_1">
        <div class="module_inner">
        </div>
      </div>
    </div>
		<div class="main_right">
      <h1>Json</h1>
      <asp:literal runat="server" ID="JSON" />
    </div>
  </div>
</asp:Content>

