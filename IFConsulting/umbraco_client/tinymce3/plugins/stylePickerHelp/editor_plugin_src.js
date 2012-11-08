(function () {

    tinymce.create('tinymce.plugins.stylePickerHelp', {

        init: function (ed, url) {


            var t = this;

            t.editor = ed;

            ed.addCommand('stylePickerHelpButton', function (ui, v) {

                window.open('/resources/images/ui/styleGuide.png', 'styleHelp');

            });

            // Register buttons

            ed.addButton(

         'stylePickerHelp', {

             title: 'Display Style Guide',

             image: url + '/images/icon.gif',

             cmd: 'stylePickerHelpButton'

         });

        },



        createControl: function (n, cm) { return null; },



        getInfo: function () {

            return {

                longname: 'stylePickerHelp',

                author: 'stylePickerHelp',

                authorurl: 'stylePickerHelp',

                infourl: 'stylePickerHelp',

                version: tinymce.majorVersion + "." + tinymce.minorVersion

            };

        }

    });


    // Register plugin

    tinymce.PluginManager.add('stylePickerHelp', tinymce.plugins.stylePickerHelp);

})();