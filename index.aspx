<%@ Page Language="C#" MasterPageFile="~/DampTShirts.master" CodeFile="index.aspx.cs" Inherits="index" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
  <meta name="keywords" content="<%= metaKeywords %>" />
  <meta name="description" content="<%= metaDescription %>" />
  <link rel="image_src" href="<%= strImage %>" />
  <meta property="og:title" content="<%= strH1 %>" />
  <meta property="og:description" content="<%= metaDescription %>" />
  <meta property="og:type" content="product" />
  <meta property="og:site_name" content="<%= varConst.cFriendlySiteName %>" />
  <meta property="fb:app_id" content="<%= varConst.cFBAppID %>"/>
  <meta property="og:url" content="<%= strURL %>" />
  <meta property="og:image" content="<%= strImage %>" />
  <script type="text/javascript">
    function mostRecent(a,b) { // DEFAULT
      return a[0] > b[0] ? -1 : 1;
    };
    function thumbsDESC(a,b) { 
      return a[3] > b[3] ? -1 : 1;
    };
    function thumbsASC(a,b) {
      return a[3] > b[3] ? 1 : -1;
    };

    $(function () {
      var index = 0;
			var rows = 0;
			var mycounter = 0;
      var currentLoaded = 0;
			var json = <%= jsonShirts %>;
      var jsonShirts =  $(<%= jsonShirts %>).sort(mostRecent);
      var loadingImgHTML = '';
      var SEODirectory = '<%= varConst.cSEODirectory%>';
      var myCookie = '<%= myCookie%>';
      jsonLength = jsonShirts.length;
			var modWidth = $("#shirts").outerWidth();
				var perRow = Math.floor(modWidth / 192);
				var perPage = 16*perRow;
      MoreShirts();

      function DidTheyVote(DiggID, myCookie) {
        var Voted = 0;
        if (myCookie != null) {
          Voted = myCookie.indexOf("X" + DiggID + "X", 0);
        }
        if(Voted >= 0) {
          return true;
        } else {
          return false;
        }
      }

      function isPositive_Class(Thumbs) {
        if (Thumbs > 0) {
          return (" Positive");
        }
        else if (Thumbs < 0) {
          return (" Negative");
        }
        else {
          return ("");
        }
      }

      function isPositive_Number(Thumbs) {
        if (Thumbs > 0) {
          return ("+" + Thumbs);
        }
        else {
          return (Thumbs);
        }
      }

			function MoreShirts() {
				for (var counter = perPage*index; counter <= perPage*index + perPage; counter++) {
					
					if(counter == perPage*index) counter++;
					mycounter = counter;
					if(rows == 4*perRow) {
						$("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd1 %></div>");
					}
					if(rows == 8*perRow) {
						$("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd2 %></div>");
					}
					if(rows == 12*perRow) {
						$("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd3 %></div>");
						rows = 0;
					}
					rows++
					BuildShirt(jsonShirts[counter-1]);
					if(counter == perPage*index + perPage) {
						$("#shirts").append("<span class=\"btn btn_blue more\">Load More</span>");
          }
					if(counter >= jsonLength) {
            break;
          }
        }
	      index++;
      }

      function BuildShirt(item) {
        showThumbs = '<%= varConst.showThumbs %>';
        intThumbs = item[3];
        strProduct = "";
        strProduct = strProduct + "<div class=\"Product " + item[0] +"\">";
        strProduct = strProduct + " <div class=\"Product_Image\">";
        <%if (varConst.cSiteName == "damptshirts") { %>
          strProduct = strProduct + "<a href=\"/t/<%= varConst.cSEODirectory%>/" + item[0] + "/" + item[7] + "/\">";
        <% } else { %>
          strProduct = strProduct + "<a href=\"" + item[2] + "\">";
        <% } %>
        strProduct = strProduct + "<img alt=\"" + item[4] + "\" title=\""+ item[4] +"\" src=\"" + item[1] + "\">";
        //strProduct = strProduct + "<img alt=\"" + item[4] + "\" title=\""+ item[4] +"\" src=\"/images/temp.jpg\">";
        strProduct = strProduct + "</a></div>";
				if (myCookie != null && DidTheyVote(item[0], myCookie) || showThumbs == 'True') {
          strProduct = strProduct + "<div id=\"ThumbID_" + item[0] + "\" class=\"ThumbMod\">";
          strProduct = strProduct + "	<div class=\"PlusMinus" + isPositive_Class(item[3]) +"\"><span>" + isPositive_Number(item[3]) + "</span></div>";
          strProduct = strProduct + "</div>";
        } else {
          strProduct = strProduct + "<div class=\"ThumbMod\" id=\"ThumbID_"+ item[0] +"\">";
          strProduct = strProduct + " <div name=\""+ item[0] +"\" class=\"btn btn_thumb btn_down\" id=\"ThumbsDown\"><span class=\"txt\">Meh</span></div>";
          strProduct = strProduct + " <div name=\""+ item[0] +"\" class=\"btn btn_thumb btn_up l_margin_5\" id=\"ThumbsUp\"><span class=\"txt\">Like</span></div>";
          strProduct = strProduct + " <div class=\"clear\"></div>";
          strProduct = strProduct + "</div>";
        }
        
//				strProduct = strProduct + "<div style='display:block'>Counter: " + mycounter + "</div>";
//				strProduct = strProduct + "<div style='display:block'>Index: " + index + "</div>";
//				strProduct = strProduct + "<div style='display:block'>PerPage: " + perPage + "</div>";
//				strProduct = strProduct + "<div style='display:block'>JSON Length: " + jsonLength + "</div>";
				
				strProduct = strProduct + "</div>";
				$("#shirts").append(strProduct);
      }

			$('.btn.more').live("click", function () {
				$(this).remove();
				MoreShirts();
			});

			$('.Product').live("mouseover", function () {
				if (!$(this).data('init')) {
					$(this).data('init', true);
					$(this).hoverIntent(function () {
						$('.ThumbMod', $(this)).fadeIn();
					}, function () {
						$('.ThumbMod', $(this)).fadeOut();
					});
					$(this).trigger('mouseover');
				}
			});

//      $(window).scroll(function() {
//        $(window).height();   // returns height of browser viewport
//        $(document).height(); // returns height of HTML document
//		    if ($(window).scrollTop() >= $(document).height() - $(window).height() - ($(window).height()/4)) {
//          MoreShirts();
//					alert("Doc Height: " + $(document).height() + "\n 75% window height: " + ($(window).height()*.75) + "\n window height: " + ($(window).height()));
//		    }
//	    });

      //SORT OPTIONS
      $('#btnMostRecent').click(function() {
        $(".Product").remove();
        $(".ad_content").remove();
				$('.btn.more').remove();
        index = 0; rows = 0;
        jsonShirts = (<%= jsonShirts %>).sort(mostRecent);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
      $('#btnMost').click(function() {
        $(".Product").remove();
        $(".ad_content").remove();
				$('.btn.more').remove();
        index = 0; rows = 0;
        jsonShirts = (<%= jsonShirts %>).sort(thumbsDESC);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
      $('#btnLeast').click(function() {
        $(".Product").remove();
        $(".ad_content").remove();
				$('.btn.more').remove();
        index = 0; rows = 0;
        jsonShirts = (<%= jsonShirts %>).sort(thumbsASC);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
    });
	</script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
  <!-- START MAIN AREA -->
	<div class="main clearix">
		<div class="main_left">
			<!-- SHARE -->
			<div class="share clearfix">
				<div class="b_margin_10">Share Us!</div>
				<div class="share_widgets facebook">
					<script type="text/javascript">      _ga.trackFacebook();</script>
					<fb:like href="http://www.facebook.com/damptshirts" send="false" width="234" show_faces="false" data-layout="box_count"></fb:like>
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
			<!-- END SHARE -->
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
			<div style="float:left; width:100%;" class="clearfix">	
				<h1><%= strH1 %></h1>  
				<div class="sort module_1 b_margin_10 clearfix" id="sortOptions">
					<a class="btn btn_blue floatleft" href="/tag-list/">Browse by Tag</a>
					<span class="btn btn_blue floatright l_margin_5 sortON" id="btnMostRecent">Most Recent</span>
					<span class="btn btn_blue floatright l_margin_5" id="btnLeast">Least Liked</span>
					<span class="btn btn_blue floatright l_margin_5" id="btnMost">Most Liked</span>
					<div class="clear"></div>
				</div> 
				<div id="shirts"></div>
			</div>
		</div>
	</div>

</asp:Content>
