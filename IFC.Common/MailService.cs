using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Net;

namespace IFC.Common
{
    public class MailService
    {
        string _host;
        int _port;
        string _username;
        string _password;
        bool _useSSL;       

        public MailService()
        {
            SettingService settingService = new SettingService();

            _host = settingService.GetSetting(Const.SmtpHostSettingName);
            _port = settingService.GetSettingInteger(Const.SmtpPortSettingName);
            _username = settingService.GetSetting(Const.SmtpUserNameSettingName);
            _password = settingService.GetSetting(Const.SmtpPasswordSettingName);
            _useSSL = settingService.GetSettingBoolean(Const.SmtpUseSSLSettingName);
            _host = settingService.GetSetting(Const.SmtpHostSettingName);            
        }

        public MailService(string host, int port, string username, string password, bool useSSL)
        {
            this._host = host;
            this._port = port;
            this._username = username;
            this._password = password;
            this._useSSL = useSSL;
        }

        /// <summary>
        /// Send mail function
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="from"></param>
        /// <param name="to"></param>
        /// <param name="cc"></param>
        /// <param name="bcc"></param>
        /// <param name="attachments"></param>
        /// <returns></returns>
        public bool SendMail(string subject, string body, bool isBodyHtml, string from, string[] to, string[] cc, string[] bcc, params System.Net.Mail.Attachment[] attachments)
        {
            using (var mailMessage = new MailMessage())
            {
                if (!string.IsNullOrWhiteSpace(from))
                {
                    mailMessage.From = new MailAddress(from);
                }
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = isBodyHtml;
                if (attachments != null)
                {
                    foreach (Attachment item in attachments)
                    {
                        mailMessage.Attachments.Add(item);
                    }
                }

                if (to != null)
                {
                    foreach (string item in to)
                    {
                        mailMessage.To.Add(item);
                    }
                }

                if (cc != null)
                {
                    foreach (string item in cc)
                    {
                        mailMessage.CC.Add(item);
                    }
                }

                if (bcc != null)
                {
                    foreach (string item in bcc)
                    {
                        mailMessage.Bcc.Add(item);
                    }
                }

                return Send(mailMessage);
            }
        }

        /// <summary>
        /// Send mail message
        /// </summary>
        /// <param name="mailMessage">message to send</param>
        /// <returns>Sent status</returns>
        public bool Send(MailMessage mailMessage)
        {
            SmtpClient smtpClient = new SmtpClient();
            smtpClient.Host = _host;
            smtpClient.Port = _port;
            smtpClient.Credentials = new NetworkCredential(_username, _password);
            smtpClient.EnableSsl = _useSSL;

            if (mailMessage.Sender == null)
                mailMessage.Sender = new MailAddress(_username);

            if (mailMessage.ReplyToList.Count == 0)
                mailMessage.ReplyToList.Add(mailMessage.From);

            try
            {
                smtpClient.Send(mailMessage);
                return true;
            }
            catch (SmtpException ex)
            {
               // log4net.LogManager.GetLogger(typeof(MailService)).Error("Send mail error", ex);
            }
            return false;
        }
    }
}