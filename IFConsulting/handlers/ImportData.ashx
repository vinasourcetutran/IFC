<%@ WebHandler Language="C#" Class="IFC.handlers.ImportData" %>

using System;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using umbraco.BusinessLogic;
using umbraco.cms.businesslogic.web;

namespace IFC.handlers
{
    public class ImportData : IHttpHandler
    {
        

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json; charset=utf-8";
            if (context.Request["data"] == null || string.IsNullOrWhiteSpace("data"))
                return;
            /*if (context.Request.ContentType.Contains("json"))
            {
                ProccessForm(context);
                return;
            }*/

            /*DocumentType dt = DocumentType.GetByAlias("Currency");
            User author = User.GetUser(0);

            Document doc = Document.MakeNew("UER", dt, author, 1391);
            doc.getProperty("name").Value = "UER";

            doc.Publish(author);

            umbraco.library.UpdateDocumentCache(doc.Id);*/
            
            context.Response.Write(JsonConvert.SerializeObject(new
                                                                   {
                                                                       Error = false,
                                                                       message = "Success"
                                                                   }));
        }

        private void ProccessForm(HttpContext context)
        {
            StreamReader sr = new StreamReader(context.Request.InputStream);
            string jsonStr = "";
            jsonStr = sr.ReadToEnd();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }
}