<%@ WebHandler Language="C#" Class="IFC.handlers.ContactHandle" %>

using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using NVelocityTemplateEngine;
using NVelocityTemplateEngine.Interfaces;
using Newtonsoft.Json;
using umbraco.MacroEngines;
using IFC.Common;

namespace IFC.handlers
{
    /// <summary>
    /// Summary description for ContactSpecialist
    /// </summary>
    public class ContactHandle : IHttpHandler
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
            
            List<string> lstCC;
            DynamicNode EmailSettingNode;
            try
            {
                EmailSettingNode = GetContactEmailNodeSetting();
                lstCC = IFCCommon.IFCMailService.GetListEmailCC(EmailSettingNode.Parent);
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
                string firstName = context.Request["firstName"];
                string lastName = context.Request["lastName"];
                string email = context.Request["email"];
                string subject = context.Request["subject"];
                string message = context.Request["message"];
                string country = context.Request["country"];
                string residence = context.Request["residence"];
                if (!string.IsNullOrEmpty(firstName) &&
                    !string.IsNullOrEmpty(lastName) &&
                    !string.IsNullOrEmpty(email) &&
                    !string.IsNullOrEmpty(subject) &&
                    !string.IsNullOrEmpty(message))
                {
                    ajaxResponse.Error = false;

                    //Node emailTemplate = new Node(1308);

                    //send email to admin
                    string to = EmailSettingNode.Parent.GetProperty("emailTo").Value;

                    //string emailSubject = emailTemplate.GetProperty("emailSubject").Value
                    //    .Replace("%Subject%", context.Request["subject"]);

                    /*string body = emailTemplate.GetProperty("emailBody").Value
                        .Replace("%FirstName%", firstName)
                        .Replace("%LastName%", lastName)
                        .Replace("%Subject%", lastName)
                        .Replace("%Message%", message)
                        .Replace("%Email%", firstName);*/
                    string emailSubject = this.GetSubjectTemplate(EmailSettingNode.GetPropertyValue("emailSubject"), subject);
                    string body = GetBodyTemplate(EmailSettingNode.GetPropertyValue("emailBody"), firstName, lastName,
                                                  country, residence, email, message);

                    MailService service = new MailService();
                    if (service.SendMail(emailSubject, body, true, email, new string[] { to }, lstCC.ToArray(), null, null))
                        ajaxResponse.Message = "Thanks for contacting us, we will be in touch shortly.";
                    else
                        ajaxResponse.Message = "Error, please try again later.";
                                                

                    //log
                    //SpringContextFactory.GetObject<IContactLog>(SpringObject.ContactLogController).AddContactLog(context.Request["name"], context.Request["email"], context.Request["subject"], context.Request["message"]);

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
        
        public DynamicNode GetContactEmailNodeSetting()
        {
            var listNodes = new DynamicNode("1371").XPath("//EmailSettingContainer[key='26236177-7FA1-4142-8FEF-2F295B6476CB']//*[key='0A73FE14-E8D9-4FA0-AFEB-4BAF4F1F6C4A']");
            if (listNodes == null || listNodes.Items.Count != 1)
                throw new Exception();
            return listNodes.Items[0];
        }

        public string GetBodyTemplate(string BodyTemplate, string FirstName, string LastName, string Country, string Residence, string Email, string Message)
        {
            INVelocityEngine fileEngine = NVelocityEngineFactory.CreateNVelocityMemoryEngine(false);
            IDictionary context = new Hashtable();
            context.Add("FirstName", FirstName);
            context.Add("LastName", LastName);
            context.Add("Country", Country);
            context.Add("Residence", Residence);
            context.Add("Email", Email);
            context.Add("Message", Message);
            return fileEngine.Process(context, BodyTemplate);
        }

        public string GetSubjectTemplate(string SubjectTemplate, string Subject)
        {
            INVelocityEngine fileEngine = NVelocityEngineFactory.CreateNVelocityMemoryEngine(false);
            IDictionary context = new Hashtable();
            context.Add("Subject", Subject);
            return fileEngine.Process(context, SubjectTemplate);
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