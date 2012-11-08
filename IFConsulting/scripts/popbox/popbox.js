(function () {

    $.fn.popbox = function (options) {
        var settings = $.extend({
            selector: this.selector,
            open: '.open',
            box: '.box',
            arrow: '.arrow',
            arrow_border: '.arrow-border',
            close: '.close'
        }, options);

        var methods = {
            open: function (event) {
                event.preventDefault();

                var pop = $(this);
                //var box = $(this).parent().find(settings['box']);
                var box = $(settings['selector']).next();

                var arrow = box.find(settings['arrow']); //.css({ 'left': box.width() });
                var arrowBorder = box.find(settings['arrow_border']); //.css({ 'left': box.width() });
                box.find(settings['close']).css({ 'left': box.width() - 15});
                //box.css('display', 'block');
                //var pos = $(this).position();
                var pos = $(settings['open']).position();

                if (box.css('display') == 'block') {
                    //methods.close();
                } else {
                    box.css({ 'display': 'block', 'top': -195, 'left': ((pop.parent().width() / 2) - box.width() / 2) });
                }
                box.css({ top: pos.top - arrow.outerHeight() * 2, left: pos.left - box.innerWidth() - arrow.outerWidth()});
                var boxPos = box.position();
                var itemPos = $(this).position();
                arrow.css({ top: itemPos.top - boxPos.top - arrow.outerHeight() + $(this).height() / 2 - 2, left: box.innerWidth() - 20 });
                arrowBorder.css({ top: itemPos.top - boxPos.top - arrow.outerHeight() + $(this).height() / 2, left: box.innerWidth() });
                //box.show();
            },

            close: function () {
                $(settings['box']).fadeOut("fast");
            }
        };

        $(document).bind('keyup', function (event) {
            if (event.keyCode == 27) {
                methods.close();
            }
        });

        $(document).bind('click', function (event) {
            if (!$(event.target).closest(settings['selector']).length) {
                //methods.close();
            }
        });

        return this.each(function () {
            $(this).css({ 'width': $(settings['box']).width() }); // Width needs to be set otherwise popbox will not move when window resized.
            $(settings['open'], this).bind('click', methods.open);
            $(settings['box']).find(settings['close']).bind('click', function (event) {
                event.preventDefault();
                methods.close();
            });
        });
    }

}).call(this);
