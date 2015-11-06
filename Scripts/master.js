$(document).ready(function () {
  $("#ThumbsDown").live('click', function () {
    var intDiggID = $(this).attr('name');
    var intThumb = -1;
    Thumbs(intDiggID, intThumb);
  });

  $('#ThumbsUp').live('click', function () {
    var intDiggID = $(this).attr('name');
    var intThumb = 1;
    Thumbs(intDiggID, intThumb);
  });

  function Thumbs(intDiggID, intThumb) {
    $.ajax({
      url: "/thumbs.aspx",
      data: "DiggID=" + intDiggID + "&Thumb=" + intThumb,
      success: function (Response) {
        var mySplitResponse = Response.split(",");
        intDiggID = mySplitResponse[0];
        intThumbs_New = mySplitResponse[1];
        $('#ThumbID_' + intDiggID).fadeOut('fast', function () {
          $('#ThumbID_' + intDiggID).addClass('PlusMinus');
          if (parseFloat(intThumbs_New) > 0) {
            $('#ThumbID_' + intDiggID).html('+' + intThumbs_New);
            $('#ThumbID_' + intDiggID).addClass('Positive');
          } else if (parseFloat(intThumbs_New) < 0) {
            $('#ThumbID_' + intDiggID).html('-' + intThumbs_New);
            $('#ThumbID_' + intDiggID).addClass('Negative');
          } else {
            $('#ThumbID_' + intDiggID).html(intThumbs_New);
          }
          $('#ThumbID_' + intDiggID).delay(500).fadeIn('fast');
        });
      }
    });
  }

  //SEARCH
  function mySearch() {
    if ($('#inpSearch').val() != "") {
      strSearch = $('#inpSearch').val();
    } else {
      strSearch = "Null";
    }
    if ('<%= varConst.cSiteName %>' == 'damptshirts') {
      window.location.replace('/<%= varConst.cSEODirectory%>/' + strSearch + '/search/1/0/');
    } else {
      window.location.replace('/' + strSearch + '/search/0/');          
    }
  }
  $("#inpSearch").keyup(function (event) {
    if (event.keyCode == 13) {
      mySearch();
    }
  });
  $('#btnSearch').click(function () {
    mySearch();
  });

  //GLOBAL TAG LIST
  $('.btnMoreTags').click(function() {
    $('.allTags').toggle();
  });
  var perCol;
  var strTags = "<ul>";
  var cols = 3;
  var index = 0;
  var currentLoaded = 0;
  var jsonTagsFull =  $(<%= jsonTagsFull %>);
  jsonLength = jsonTagsFull.length;
  perCol = Math.ceil(jsonLength/3);

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
    strTags = strTags + "<li><a href=\"/" + item[1] + "/tag/" + item[0] + "/\">" + item[1] + "</a> (" + item[2] + ")</li>";
  }
  strTags = strTags + "</ul>";
  $(".allTags .allTags_inner").append(strTags);
  <% if (path == "/tagList.aspx") { %>
    $(".tag_list_full").append(strTags);
  <% } %>
});