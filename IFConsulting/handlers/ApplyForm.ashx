<%@ WebHandler Language="C#" Class="IFC.handlers.ApplyForm" %>

using System;
using System.Collections.Generic;
using System.Collections;
using System.Web;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using umbraco.MacroEngines;
using IFC.Common;
using NVelocityTemplateEngine;
using NVelocityTemplateEngine.Interfaces;


namespace IFC.handlers
{
    public class ApplyForm : IHttpHandler
    {

        public class AjaxResponse
        {
            public string Message;
            public bool Error;
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json; charset=utf-8";
            AjaxResponse ajaxResponse = new AjaxResponse()
            {
                Message = "",
                Error = true
            };

            DynamicNode EmailSettingNode;
            DynamicNode ParentSetting;
            List<string> lstCC;
            try
            {
                EmailSettingNode = GetApplyFormSetting();
                ParentSetting = EmailSettingNode.Parent;
                lstCC = IFCCommon.IFCMailService.GetListEmailCC(ParentSetting);
            }
            catch (Exception ex)
            {
                ajaxResponse.Error = true;
                ajaxResponse.Message = "Error while retrive email settings, please reconfig your mail settings" + ex;
                context.Response.Write(JsonConvert.SerializeObject(ajaxResponse));
                context.Response.End();
                return;
            }

            try
            {
                string name = context.Request["name"];
                string email = context.Request["email"];
                string subject = EmailSettingNode.GetPropertyValue("emailSubject");//context.Request["subject"];
                string from = ParentSetting.GetPropertyValue("emailFrom");
                string premium = context.Request["premiumID"];
                
                int premiumID;
                if (!string.IsNullOrEmpty(name) &&
                    !string.IsNullOrEmpty(email) &&                   
                    int.TryParse(premium, out premiumID))                
                {
                    ajaxResponse.Error = false;
                    string to = email;
                    string baseUrl = "http://" + context.Request.Url.Authority;
                    string url = "<a href=\"" + baseUrl + "/handlers/Download.ashx?premiumID=" + premiumID + "\">Download</a>";

                    string body = GetTemplate(EmailSettingNode, name, url);//getTemplate(name, url);

                    MailService service = new MailService();
                    if (service.SendMail(subject, body, true, from, new string[] { to }, lstCC.ToArray(), null, null))
                        ajaxResponse.Message = "Thanks for contacting us, we will be in touch shortly.";
                    else
                        ajaxResponse.Message = "Error, please try again later.";

                    ajaxResponse.Message = "Thanks for contacting us, we will be in touch shortly.";
                }
                else
                {
                    ajaxResponse.Message = "Please check the required fields and try again";
                }
            }
            catch (Exception ex)
            {
                ajaxResponse.Error = true;
                ajaxResponse.Message = "Error, please try again later." + ex;
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            context.Response.Write(js.Serialize(ajaxResponse));
            context.Response.End();

        }
        
        public DynamicNode GetApplyFormSetting()
        {
            var listNodes = new DynamicNode("1371").XPath("//EmailSettingContainer[key='26236177-7FA1-4142-8FEF-2F295B6476CB']//*[key='3849DCF1-93A6-422A-B1E6-CF76869E08BA']");
            if (listNodes == null || listNodes.Items.Count != 1)
                throw new Exception();
            return listNodes.Items[0];
        }
        
        public string GetTemplate(DynamicNode EmailNode, string Name, string Url)
        {
            string bodyTemplate = EmailNode.GetPropertyValue("emailBody");
            INVelocityEngine fileEngine = NVelocityEngineFactory.CreateNVelocityMemoryEngine(false);
            IDictionary context = new Hashtable();
            context.Add("Name", Name);
            context.Add("DownloadUrl", Url);
            return fileEngine.Process(context, bodyTemplate);
        }
        
        public void SendMail()
        {
            
        }

        public string getTemplate(string name , string url)
        {
            string templateDir = HttpContext.Current.Server.MapPath("/resources/templates");
            string templateName = "EmailTemplate.vm";
            INVelocityEngine fileEngine =
                NVelocityEngineFactory.CreateNVelocityFileEngine(templateDir, true);

            IDictionary context = new Hashtable();

            context.Add("name", name);
            context.Add("downloadUrl", url);

            return fileEngine.Process(context, templateName);
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
