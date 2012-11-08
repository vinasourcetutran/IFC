using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using IFC.Common;
using umbraco.MacroEngines;

namespace IFCCommon
{



    /// <summary>
    /// Summary description for IFCMailService
    /// </summary>
    public class IFCMailService
    {
        private string _host;
        private int _port;
        private string _username;
        private string _password;
        private bool _useSSL;

        public IFCMailService()
        {
            SettingService settingService = new SettingService();
            this._host = settingService.GetSetting("Smtp.Host");
            this._port = settingService.GetSettingInteger("Smtp.Port");
            this._username = settingService.GetSetting("Smtp.UserName");
            this._password = settingService.GetSetting("Smtp.Password");
            this._useSSL = settingService.GetSettingBoolean("Smtp.UseSSL");
            this._host = settingService.GetSetting("Smtp.Host");
        }

        public IFCMailService(string host, int port, string username, string password, bool useSSL)
        {
            this._host = host;
            this._port = port;
            this._username = username;
            this._password = password;
            this._useSSL = useSSL;
        }

        public bool SendMail(string subject, string body, bool isBodyHtml, string from, string[] to, string[] cc,
                             string[] bcc, params Attachment[] attachments)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                if (!string.IsNullOrWhiteSpace(from))
                    mailMessage.From = new MailAddress(from);
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = isBodyHtml;
                //mailMessage.Sender = string.IsNullOrWhiteSpace(from) ? new MailAddress(_username, "IF Consulting") : new MailAddress(from, "IF Consulting");
                if (attachments != null)
                {
                    foreach (Attachment attachment in attachments)
                        mailMessage.Attachments.Add(attachment);
                }
                if (to != null)
                {
                    foreach (string addresses in to)
                        mailMessage.To.Add(addresses);
                }
                if (cc != null)
                {
                    foreach (string addresses in cc)
                        mailMessage.CC.Add(addresses);
                }
                if (bcc != null)
                {
                    foreach (string addresses in bcc)
                        mailMessage.Bcc.Add(addresses);
                }
                return this.Send(mailMessage);
            }
        }

        public bool Send(MailMessage mailMessage)
        {
            SmtpClient smtpClient = new SmtpClient();
            smtpClient.Host = this._host;
            smtpClient.Port = this._port;
            smtpClient.Credentials = (ICredentialsByHost) new NetworkCredential(this._username, this._password);
            smtpClient.EnableSsl = this._useSSL;
            if (mailMessage.Sender == null)
                mailMessage.Sender = new MailAddress(this._username);
            if (mailMessage.ReplyToList.Count == 0)
                ((Collection<MailAddress>) mailMessage.ReplyToList).Add(mailMessage.From);
            try
            {
                smtpClient.Send(mailMessage);
                return true;
            }
            catch (SmtpException ex)
            {
            }
            return false;
        }

        public static List<string> GetListEmailCC(DynamicNode SettingNode)
        {
            List<string> lst = new List<string>();

            string tmp;
            using (StringReader sr = new StringReader(SettingNode.GetPropertyValue("emailCC")))
            {
                while ((tmp = sr.ReadLine()) != null)
                {
                    if (!string.IsNullOrWhiteSpace(tmp))
                        lst.Add(tmp);
                }
            }

            return lst;
        }

        public static void WriteLog(Exception er)
        {
            string sSource = "IFC";
            string sLog = "Web";
            string sEvent = er.ToString();

            if (!EventLog.SourceExists(sSource))
                EventLog.CreateEventSource(sSource, sLog);

            EventLog.WriteEntry(sSource, sEvent);
            EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 234);
        }
    }

}