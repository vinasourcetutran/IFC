<%@ WebHandler Language="C#" Class="FileList" %>

using System;
using System.Web;
using System.IO;
using System.Configuration;

public class FileList : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (context.Request.QueryString["EntryId"] != null && context.Request.QueryString["EntryId"] != "")
        {
            Guid entryId = new Guid(context.Request.QueryString["EntryId"]);
            context.Response.Write("[");
            string folderPath = ConfigurationManager.AppSettings["EntryFilePath"] + entryId.ToString() + "\\";
            if (Directory.Exists(folderPath))
            {
                string[] files = Directory.GetFiles(folderPath);
                if (files.Length > 0)
                {
                    FileInfo fi = new FileInfo(files[0]);
                    context.Response.Write("{\"filename\":\"" + fi.Name + "\",\"fileUrl\":\"" +
                        ConfigurationManager.AppSettings["EntryFileUrl"] + fi.Directory.Name + "/" + fi.Name + "\"}");
                }
            }
            context.Response.Write("]");

        }
        else
            context.Response.Write("[]");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}