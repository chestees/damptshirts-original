$(document).ready(function() {
	$("#mySubmit").click(function() {
		var Email = $("input#Email").val();
		var Comment = $("textarea#Comment").val();
		var myData = "Email="+Email+"&Comment="+Comment;
		$.ajax({
			beforeSend: function(){
				$("#myForm").fadeOut(function() {
					$("#Response").html("<div style='text-align:center'>Processing<br /><img align='center' src='/images/clock-loader.gif'></div>");
					$("#Response").fadeIn();								  
				});
			},
			url: "/submit_Contact.asp",
			data: myData,
			dataType: "html",
			async: false,
			success: function(msg) {
				$("#Response").delay(1000).fadeOut(function() {
					if (msg == 'Error') {
						$("#Response").html("<div class='ErrorBar'>Something went wrong</div>");
						$("#Response").delay(500).fadeIn();
						$("#myForm").delay(500).fadeIn();
					} else {
						$("#Response").html(msg);
						$("#Response").delay(500).fadeIn();
					}
				})
			}}); //END ajax
	});
}); //END Document