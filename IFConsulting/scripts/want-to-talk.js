jQuery(document).ready(function($){
	$('a#lnk-callme').hover(
		function(){
			$(this).css('background', 'url(images/call-me.png) left bottom');
			
			if('none' != $('#want-to-talk-email').css('display')) {
				$('a#lnk-or').css('background', 'url(images/or.png)');
				$('#want-to-talk-email').hide();		
			}
		},
		function(){
			$(this).css('background', 'url(images/call-me.png) left top');
		}
	);

	$('a#lnk-callus').hover(
		function(){
			$(this).css('background', 'url(images/call-us.png) left bottom');
			
			if('none' != $('#want-to-talk-email').css('display')) {
				$('a#lnk-or').css('background', 'url(images/or.png) left top');
				$('#want-to-talk-email').hide();		
			}
		},
		function(){
			$(this).css('background', 'url(images/call-us.png) left top');
		}
	);
	
	$('a#lnk-or').hover(
		function(){
			if('none' == $('#want-to-talk-email').css('display'))
				$(this).css('background', 'url(images/or.png) left center');
		},
		function(){
			if('none' == $('#want-to-talk-email').css('display'))
				$(this).css('background', 'url(images/or.png) left top');
		}
	);

	$('a#lnk-or').click(function(){
		if('none' == $('#want-to-talk-email').css('display')) {
			$('a#lnk-or').css('background', 'url(images/or.png) left bottom');
			$('#want-to-talk-email').show();
		} else {
			$('a#lnk-or').css('background', 'url(images/or.png) left top');
			$('#want-to-talk-email').hide();
		}
		
		return false;
	});
	
	$(document).click(function(){
		if('none' != $('#want-to-talk-email').css('display')) {
			$('a#lnk-or').css('background', 'url(images/or.png) left top');
			$('#want-to-talk-email').hide();		
		}
	});


	$('a.popup').click(function(){
		var url = $(this).attr('href');
		var dim = $(this).attr('alt');
	
		window.open(url, 'popupWindow', 'toolbar=0, menubar=0, status=0, scrollbars=0, ' + dim);
		
		return false;
	});
		
});