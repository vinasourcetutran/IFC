/*
CSS Browser Selector v0.4.0 (Nov 02, 2010)
Rafael Lima (http://rafael.adm.br)
http://rafael.adm.br/css_browser_selector
License: http://creativecommons.org/licenses/by/2.5/
Contributors: http://rafael.adm.br/css_browser_selector#contributors
*/
function css_browser_selector(u) { var ua = u.toLowerCase(), is = function (t) { return ua.indexOf(t) > -1 }, g = 'gecko', w = 'webkit', s = 'safari', o = 'opera', m = 'mobile', h = document.documentElement, b = [(!(/opera|webtv/i.test(ua)) && /msie\s(\d)/.test(ua)) ? ('ie ie' + RegExp.$1) : is('firefox/2') ? g + ' ff2' : is('firefox/3.5') ? g + ' ff3 ff3_5' : is('firefox/3.6') ? g + ' ff3 ff3_6' : is('firefox/3') ? g + ' ff3' : is('gecko/') ? g : is('opera') ? o + (/version\/(\d+)/.test(ua) ? ' ' + o + RegExp.$1 : (/opera(\s|\/)(\d+)/.test(ua) ? ' ' + o + RegExp.$2 : '')) : is('konqueror') ? 'konqueror' : is('blackberry') ? m + ' blackberry' : is('android') ? m + ' android' : is('chrome') ? w + ' chrome' : is('iron') ? w + ' iron' : is('applewebkit/') ? w + ' ' + s + (/version\/(\d+)/.test(ua) ? ' ' + s + RegExp.$1 : '') : is('mozilla/') ? g : '', is('j2me') ? m + ' j2me' : is('iphone') ? m + ' iphone' : is('ipod') ? m + ' ipod' : is('ipad') ? m + ' ipad' : is('mac') ? 'mac' : is('darwin') ? 'mac' : is('webtv') ? 'webtv' : is('win') ? 'win' + (is('windows nt 6.0') ? ' vista' : '') : is('freebsd') ? 'freebsd' : (is('x11') || is('linux')) ? 'linux' : '', 'js']; c = b.join(' '); h.className += ' ' + c; return c; }; css_browser_selector(navigator.userAgent);
function goToByScrollY(y) {
    $('html,body').animate({ scrollTop: y }, 'slow', function () {
        updateIPADScroll();
    });
}
function goToByScroll(id) {
    goToByScrollObj($('#' + id));
}
function goToByScrollObj(el) {
    $('html,body').animate({ scrollTop: el.offset().top }, 'slow', function () {
        updateIPADScroll();
    });
}
function isValidEmail(email) {
    var regex = /([\w\d\-_]+)(\.[\w\d\-_]+)*@([\w\d\-_]+\.)([\w\d\-_]+\.)*([\w]{2,3})/;
    if (regex.test(email))
        return true;
    else
        return false;
}

$(document).ready(function(){
	
	// faqs
    $('.linkQuestion').click(function() {
        if (!$(this).parent().hasClass('open')) {
            resetFAQ();
            $(this).parent().find('div.answer').slideDown(300);
            $(this).parent().removeClass('closed').addClass('open');
        } else {
            resetFAQ();
        }
        return false;
    });

    function resetFAQ() {
        $('.question').removeClass('open').addClass('closed');
        $('.answer').slideUp(300);
    }
	

    // LIGHTBOX
	$('.btnOpenLightBox').click(function() {
		$('.lightBoxContainer, .lightBox').fadeIn();	
	});
		
	$('.btnClose, .lightBoxContainer').click(function() {
		$('.lightBoxContainer, .lightBox').fadeOut();
    });

    //ourPeople page
    $(function(){
        $('.ourPeople').masonry({
            // options
            itemSelector : '.peopleTile'
        });
    });			

});





