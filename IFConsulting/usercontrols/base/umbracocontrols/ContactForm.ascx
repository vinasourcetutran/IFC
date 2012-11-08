<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ContactForm.ascx.cs" Inherits="usercontrols_base_umbracocontrols_ContactForm" %>
<script type="text/javascript">
    $(document).ready(function () {
        var cl = new CanvasLoader('spanContactLoader');
        cl.setColor('#000000'); // default is '#000000'
        cl.setShape('roundRect'); // default is 'oval'
        cl.setDiameter(34); // default is 40
        cl.setDensity(12); // default is 40
        cl.setSpeed(1); // default is 2
        cl.setFPS(8); // default is 24
        cl.show(); // Hidden by default

        $('.getInTouch').click(function (e) {
            e.preventDefault();
            $('#divContact').slideDown(300);
            goToByScrollObj($('#divContact'));
        });
        $('#divContact .jsSubmit').click(function (e) {
            e.preventDefault();
            //validation
            $('#divContact input, #divContact textarea').removeClass('error');
            $('#divContact .jsError').hide();
            $('#divContact .jsError').html('');
            if ($('#tbName').val() == '') {
                $('#divContact .jsError').append('Please enter your name<br />');
                $('#tbName').addClass('error');
            }
            if ($('#tbEmail').val() == '') {
                $('#divContact .jsError').append('Please enter your email address<br />');
                $('#tbEmail').addClass('error');
            }
            else if (!isValidEmail($('#tbEmail').val())) {
                $('#divContact .jsError').append('Please enter your valid email address<br />');
                $('#tbEmail').addClass('error');
            }
            if ($('#tbSubject').val() == '') {
                $('#divContact .jsError').append('Please enter your subject<br />');
                $('#tbSubject').addClass('error');
            }
            if ($('#tbMessage').val() == '') {
                $('#divContact .jsError').append('Please enter your message<br />');
                $('#tbMessage').addClass('error');
            }

            if ($('#divContact .jsError').html() == '') {
                $('#divContact .jsSubmit').fadeOut(100, function () {
                    $('#divContact .jsAjaxLoader').fadeIn(300, function () {
                        var sendapplicationpack = 'false';
                        if ($('#cbSendApplicationPack').is(':checked'))
                            sendapplicationpack = 'true';
                        var contacted = 'false';
                        if ($('#cbContacted').is(':checked'))
                            contacted = 'true';

                        $.post("/handlers/Contact.ashx", { name: $('#tbName').val(), email: $('#tbEmail').val(), subject: $('#tbSubject').val(), message: $('#tbMessage').val() }, function (data) {
                            if (!data.Error) {
                                //success!                                
                                $('#divContact .jsSuccess').fadeIn(300);
                                $('#divContact .jsSuccess').html(data.Message);
                                $('#divContact .jsAjaxLoader').hide();
                                $('#divContact .jsSubmit').fadeIn(300);                                
                            }
                            else {
                                $('#divContact .jsAjaxLoader').fadeOut(100, function () {
                                    $('#divContact .jsSubmit').fadeIn(300);
                                });
                                $('#divContact .jsError').fadeIn(300);
                                $('#divContact .jsError').html(data.Message);
                            }
                        })
                        .error(function () {
                            $('#divContact .jsAjaxLoader').fadeOut(100, function () {
                                $('#divContact .jsSubmit').fadeIn(300);
                            });
                            $('#divContact .jsError').fadeIn(300);
                            $('#divContact .jsError').html('An error had occurred. Please try again later.');
                        });

                    });
                });
            }
            else {
                $('#divContact .jsError').fadeIn(300);
            }
        });
    });
</script>
<fieldset id="divContact" class="contactForm clearfix">
    <label>
        Name</label><input type="text" id="tbName" />
    <div class="clear"></div>
    <label>
        Email</label><input type="text" id="tbEmail" />
    <div class="clear"></div>
    <label>
        Subject</label><input type="text" id="tbSubject" />
    <div class="clear"></div>
    <label>
        Message</label><textarea id="tbMessage"></textarea>
    <div class="clear"></div>
    <%--<p class="error">
        Please enter your email address</p>
    <p class="success">
        Thank you for contacting us, we will be in touch soon.</p>--%>
    
   <p class="error jsError">
   </p>
   <p class="success jsSuccess">
   </p>    
    <a class="jsSubmit" href="#">Submit</a>
    <span class="ajaxLoader jsAjaxLoader" style="margin-top:5px;"><span class="loaderImg" id="spanContactLoader"></span><span class="loaderText">Sending...</span></span>
</fieldset>
