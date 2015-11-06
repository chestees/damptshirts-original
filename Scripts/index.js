function mostRecent(a,b) {
      return a[6] > b[6] ? -1 : 1;
    };
    function thumbsDESC(a,b) { // DEFAULT
      return a[3] > b[3] ? -1 : 1;
    };
    function thumbsASC(a,b) {
      return a[3] > b[3] ? 1 : -1;
    };

    $(function () {
      var perPage = 60;
      var index = 0;
      var currentLoaded = 0;
      var jsonShirts =  $(<%= jsonShirts %>).sort(thumbsDESC);
      var loadingImgHTML = '';
      var SEODirectory = '<%= varConst.cSEODirectory%>';
      var myCookie = '<%= myCookie%>';
      jsonLength = jsonShirts.length;
      <%if (varConst.cSiteName == "damptshirts") { %>
        strFB = "<div class=\"list_callout\">";
        strFB = strFB + "<div class=\"fb_like_title\"></div>";
        strFB = strFB + "<div class=\"fb_like\">";
    	  strFB = strFB + "<fb:like href=\"http://www.facebook.com/pages/Damp-T-Shirts/210228212353094\" send=\"false\" width=\"376\" show_faces=\"false\" data-layout=\"button_count\"></fb:like>";
        strFB = strFB + "</div>";
        strFB = strFB + "</div>";
      <% } else if (varConst.cSiteName == "threadlessthreadless" || varConst.cSiteName == "best-threadless-shirts") { %>
        strFB = "<div class=\"threadless_title\"></div>";
        $(".threadless_title").live("click", function() {
         window.open("http://www.threadless.com/?streetteam=Chestees","_blank");
        });
      <% } %>
      $("#shirts").html(strFB);
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
          //return (Convert.ToString(Thumbs));
          return (Thumbs);
        }
      }

      function MoreShirts() {
        for (var counter = index; counter < index + perPage; counter++) {
          if(counter >= jsonLength) {
            break;
          }
          if(index == 0) {
            perPage = 58;
          } else {
            perPage = 60;
          }
          if(counter == index + perPage - <%=varConst.cCount1 %>) {
            $("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd1 %></div>");
          }
          if(counter == index + perPage - <%=varConst.cCount2 %>) {
            $("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd2 %></div>");
          }
          if(counter == index + perPage - <%=varConst.cCount3 %>) {
            $("#shirts").append("<div class=\"ad_content\"><%= varConst.cDividerAd3 %></div>");
          }
          BuildShirt(jsonShirts[counter]);
        }
	      index = index + perPage;
      }

      function BuildShirt(item) {
        showThumbs = '<%= varConst.showThumbs %>';
        intThumbs = item[3];
        strProduct = "";
        strProduct = strProduct + "<div class=\"Product " + item[0] +"\">";
        strProduct = strProduct + " <div class=\"Product_Image\">";
        strProduct = strProduct + "   <a href=\"/" + item[7] + "/shirt/" + item[0] + "/\">";
        strProduct = strProduct + "     <img alt=\"" + item[4] + "\" title=\""+ item[4] +"\" src=\"" + item[1] + "\">";
        //strProduct = strProduct + "/images/temp.jpg\">";
        strProduct = strProduct + "</a>";
        strProduct = strProduct + " </div>";
        if (myCookie != null && DidTheyVote(item[0], myCookie) || showThumbs == 'True') {
          strProduct = strProduct + "<div id=\"ThumbID_" + item[0] + "\" class=\"ThumbMod\">";
          strProduct = strProduct + "<div class=\"PlusMinus" + isPositive_Class(item[3]) +"\">" + isPositive_Number(item[3]) + "</div>";
          strProduct = strProduct + "</div>";
        } else {
          strProduct = strProduct + " <div class=\"ThumbMod\" id=\"ThumbID_"+ item[0] +"\">";
          strProduct = strProduct + "   <div name=\""+ item[0] +"\" class=\"btn btn_thumb btn_down\" id=\"ThumbsDown\"><span class=\"down\"></span><span class=\"txt\">Meh</span></div>";
          strProduct = strProduct + "   <div name=\""+ item[0] +"\" class=\"btn btn_thumb btn_up l_margin_5\" id=\"ThumbsUp\"><span class=\"up\"></span><span class=\"txt\">Like</span></div>";
          strProduct = strProduct + "   <div class=\"clear\"></div>";
          strProduct = strProduct + " </div>";
        }
        strProduct = strProduct + "</div>";
        $("#shirts").append(strProduct);
      }

      $(window).scroll(function() {
        //alert("scrolltop: " + $(window).scrollTop());
        //$(window).height();   // returns height of browser viewport
        //$(document).height(); // returns height of HTML document
		    if ($(window).scrollTop() >= $(document).height() - $(window).height()) {
          MoreShirts();
		    }
	    });

      //SORT OPTIONS
      $('#btnMostRecent').click(function() {
        //$("#shirts").html(strFB);
        $(".Product").remove();
        $(".ad_content").remove();
        index = 0;
        jsonShirts = (<%= jsonShirts %>).sort(mostRecent);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
      $('#btnMost').click(function() {
        $(".Product").remove();
        $(".ad_content").remove();
        index = 0;
        jsonShirts = (<%= jsonShirts %>).sort(thumbsDESC);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
      $('#btnLeast').click(function() {
        $(".Product").remove();
        $(".ad_content").remove();
        index = 0;
        jsonShirts = (<%= jsonShirts %>).sort(thumbsASC);
        MoreShirts();
        $('#sortOptions').children().removeClass('sortON');
        $(this).addClass("sortON");
      });
    });