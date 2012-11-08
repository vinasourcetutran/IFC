using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Error : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {

            Exception x = Server.GetLastError();
            if (x != null)
            {
                BKA.ErrorManagement.ErrorReport er = new BKA.ErrorManagement.ErrorReport(x);
                er.BrowserVersion = Request.UserAgent;
                er.JavaScriptEnabled = Request.Browser.JavaScript.ToString();
                er.RawUrl = Request.RawUrl;
                er.SendReport();

                
            }
            else
                Trace.Warn("no Error");

        }
        catch
        {

        }
    }
}