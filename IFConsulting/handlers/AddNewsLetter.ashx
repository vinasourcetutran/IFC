<%@ WebHandler Language="C#" Class="IFC.handlers.NewsLetterHandle" %>

using System;
using System.Collections;
using System.Data;
using System.Data.EntityClient;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using IFC.Data;
using NVelocityTemplateEngine;
using NVelocityTemplateEngine.Interfaces;
using Newtonsoft.Json;
using umbraco.MacroEngines;
using IFC.Common;

namespace IFC.handlers
{
    /// <summary>
    /// Summary description for Email subscribe
    /// </summary>
    public class  NewsLetterHandle : IHttpHandler
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
                EmailSettingNode = GetSubscriptionSetting();
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
                string email = context.Request["email"].Trim();
                if (!string.IsNullOrWhiteSpace(email))
                {
                    bool success;
                    ajaxResponse.Error = false;
                    bool isExist = false;

                    #region Orginal code

                    try
                    {
                        IFConsultingDBEntities db = new IFConsultingDBEntities(BuildConnectionString());
                        isExist = db.EmailSubscribes.Where(n => n.Email == email).Count() > 0;
                        if (isExist)
                        {
                            success = true;
                        }
                        else
                        {
                            EmailSubscribe es = new EmailSubscribe();
                            es.Email = email;
                            db.EmailSubscribes.AddObject(es);
                            db.SaveChanges();
                            success = true;
                        }
                    }
                    catch (Exception er)
                    {
                        success = false;
                    }
                    #endregion
                    
                    if (success)
                    {
                        
                        string body = GetTemplate(email, EmailSettingNode);

                        MailService service = new MailService();
                        string from = ParentSetting.GetPropertyValue("emailFrom");
                        string title = EmailSettingNode.GetPropertyValue("emailSubject");
                        //List<string>
                        if (service.SendMail(title, body, true, from, new string[] { email }, lstCC.ToArray(), null, null))
                            ajaxResponse.Message = "Thanks for contacting us, we will be in touch shortly.";
                        else
                            ajaxResponse.Message = "Error, please try again later.";
                    }
                    
                    if (success)
                    {
                        ajaxResponse.Message = isExist ? "Your email is already in our subcription list." : "Thanks for contacting us, we will be in touch shortly.";
                    }
                    else
                    {
                        ajaxResponse.Message = "Add Newsletter email not success, please try again later.";
                    }
                     
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

        public DynamicNode GetSubscriptionSetting()
        {
            var listNodes = new DynamicNode("1371").XPath("//EmailSettingContainer[key='26236177-7FA1-4142-8FEF-2F295B6476CB']//*[key='D614C413-FC87-4D4C-B94F-69069C838099']");
            if (listNodes == null || listNodes.Items.Count != 1)
                throw new Exception();
            return listNodes.Items[0];
            //int[] tmp = new int[]{1,2,3,4,5};

        }
        
        private bool IsEmailExist(string email, SqlConnection cnn)
        {
            using(SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = cnn;
                cmd.CommandText = string.Format("SELECT COUNT(*) FROM EmailSubscribe WHERE Email = @Email");
                SqlParameter para = new SqlParameter("@Email", SqlDbType.NVarChar, 50);
                para.Value = email;
                cmd.Parameters.Add(para);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }
        
        private bool AddEmailSubcribe(string email, SqlConnection cnn)
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = cnn;
                cmd.CommandText = string.Format("INSERT INTO EmailSubscribe (Email) VALUES (@Email)");
                SqlParameter para = new SqlParameter("@Email", SqlDbType.NVarChar, 50);
                para.Value = email;
                cmd.Parameters.Add(para);
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public string GetTemplate(string Email, DynamicNode EmailNode)
        {
            string bodyTemplate = EmailNode.GetPropertyValue("emailBody");
            if (bodyTemplate == null || string.IsNullOrWhiteSpace(bodyTemplate))
                throw new Exception("The body template of subscription is not set.");
            INVelocityEngine fileEngine = NVelocityEngineFactory.CreateNVelocityMemoryEngine(false);
            IDictionary context = new Hashtable();
            context.Add("Email", Email);
            return fileEngine.Process(context, bodyTemplate);
        }
        
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private string BuildConnectionString()
        {
            // Specify the provider name, server and database.
            SqlConnectionStringBuilder sqlBuilder = new SqlConnectionStringBuilder(WebConfigurationManager.AppSettings["umbracoDbDSN"]);
            string providerName = "System.Data.SqlClient";

            // Build the SqlConnection connection string.
            string providerString = sqlBuilder.ToString();

            // Initialize the EntityConnectionStringBuilder.
            EntityConnectionStringBuilder entityBuilder = new EntityConnectionStringBuilder();

            //Set the provider name.
            entityBuilder.Provider = providerName;

            // Set the provider-specific connection string.
            entityBuilder.ProviderConnectionString = providerString;

            // Set the Metadata location.
            entityBuilder.Metadata = @"res://*/IFCModel.csdl|
res://*/IFCModel.ssdl|
res://*/IFCModel.msl";
            return entityBuilder.ToString();
        }
    }
}