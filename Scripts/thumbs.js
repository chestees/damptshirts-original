$(function () {
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
        intThumbs_New = parseInt(mySplitResponse[1]);
        $('#ThumbID_' + intDiggID).fadeOut('fast', function () {
          $('#ThumbID_' + intDiggID).addClass('PlusMinus');
          if (intThumbs_New > 0) {
            $('#ThumbID_' + intDiggID).html('+' + intThumbs_New);
            $('#ThumbID_' + intDiggID).addClass('Positive');
          } else if (intThumbs_New < 0) {
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
});