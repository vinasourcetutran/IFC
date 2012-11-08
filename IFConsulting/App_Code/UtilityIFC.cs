using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Razor.Text;
using System.Xml.Linq;
using Newtonsoft.Json;
using umbraco.MacroEngines;
using umbraco.NodeFactory;

namespace Utility
{
    /// <summary>
    /// Summary description for UtilityIFC
    /// </summary>
    public static class UtilityIFC
    {
        public static string GetJsonPremiums(DynamicNode Model, Criteria Criteria, out decimal MinFree)
        {
            /*Criteria Criteria = null;
            if (HttpContext.Current.Request.QueryString["data"] != null && HttpContext.Current.Request.QueryString["data"].Length > 0)
                Criteria = JsonConvert.DeserializeObject<Criteria>(HttpContext.Current.Request.QueryString["data"]);
            else
                return "";*/
            MinFree = 0;
            if (Criteria == null)
                return "";
            string queryStringData = HttpContext.Current.Request.QueryString["data"];
            bool isContainOutPatient = Criteria.ListLevels.Contains("Out");
            bool isFilterOption = Criteria.ListOptions != null && Criteria.ListOptions.Count > 0;
            dynamic node = new DynamicNode(1384);
            List<Premium> lstPrem = new List<Premium>();
            Premium prem;

            List<string> options;
            dynamic plan, insurer;
            foreach (var child in node.Descendants("Premium"))
            {

                try
                {
                    if (child.HasValue("Options") && child.Options.BaseElement != null)
                        options = UtilityIFC.GetOptions(child.Options.BaseElement.ToString());
                    else
                        options = new List<string>();


                    if (isFilterOption && !options.Any(n => Criteria.ListOptions.Contains(n)))
                        continue;
                    string level = UtilityIFC.GetValue(child.coverLevel.InnerText);
                    if (!isContainOutPatient && level == "Out")
                        continue;
                    List<AgeRangePrice> ageRangePrices = UtilityIFC.GetAgeRangePrices(child);
                    if (!UtilityIFC.IsAgeRangeValid(ageRangePrices, Criteria.ListPatients))
                        continue;

                    plan = child.Parent;
                    insurer = plan.Parent;

                    #region Test

                    /*
                int id = node.Id;
                string name = child.Name;
                string description = child.Description;
                string logo = insurer.logo;
                string documentUrl = child.document;
                string detailsUrl = "ProductDetail?Node=" + child.Id;
                string level1 = level;
                decimal excess = child.excess;
                string area = UtilityIFC.GetValue(child.area.InnerText);
                List<string> options1 = options;
                string currency = "USD";
                decimal totalPrice = 1000;
                List<AgeRangePrice> ageRangePrices1 = ageRangePrices;
                int planId = plan.Id;
                string planName = plan.Name;
                int insurerId = insurer.Id;
                string insurerName = insurer.Name;
                decimal maxBenefit = child.maxBenefit;
*/

                    #endregion

                    prem = new Premium()
                               {
                                   id = node.Id,
                                   name = child.Name,
                                   description = child.Description,
                                   logo = insurer.logo,
                                   documentUrl = child.document,
                                   detailsUrl = "ProductDetail?Node=" + child.Id + "&data=" + queryStringData,
                                   level = level,
                                   excess = child.excess,
                                   area = UtilityIFC.GetValue(child.area.InnerText),
                                   options = options,
                                   currency = "USD",
                                   totalPrice = 1000,
                                   ageRangePrices = ageRangePrices,
                                   planId = plan.Id,
                                   planName = plan.Name,
                                   insurerId = insurer.Id,
                                   insurerName = insurer.Name,
                                   maxBenefit = child.maxBenefit
                               };
                }
                catch (Exception er)
                {

                    throw new Exception("Add " + child.Name, er);
                }
                lstPrem.Add(prem);
                //if (prem.ageRangePrices.Min(n => n.price) <)
            }
            try
            {
                MinFree = lstPrem.Select(n => n.ageRangePrices.Min(m => m.price)).Min(n => n);
            }
            catch (Exception)
            {
                MinFree = 0;
            }
            
            return JsonConvert.SerializeObject(lstPrem, Formatting.Indented);
        }

        public static List<string> GetOptions(string XmlStr)
        {
            var lstOpts = new List<string>();
            XElement root = XElement.Parse(XmlStr);
            Node node;
            foreach (var elem in root.Elements())
            {
                node = new Node(Convert.ToInt32(elem.Value));
                lstOpts.Add(node.Properties["Name"].Value);
            }

            return lstOpts;
        }

        public static List<Node> GetPayments(string XmlStr)
        {
            var lstPayments = new List<Node>();
            XElement root = XElement.Parse(XmlStr);
            Node node;
            foreach (var elem in root.Elements())
            {
                node = new Node(Convert.ToInt32(elem.Value));
                lstPayments.Add(node);
            }

            return lstPayments;
        }

        public static string GetDisplayName(string NodeId)
        {
            return new DynamicNode(NodeId).GetPropertyValue("displayName");
        }

        public static string GetValue(string NodeId)
        {
            //XElement root = XElement.Parse(XmlStr);
            //Node node = new Node(Convert.ToInt32(root.Elements().First().Value));
            return new DynamicNode(NodeId).Name;
        }

        public static List<AgeRangePrice> GetAgeRangePrices(dynamic Node)
        {
            List<AgeRangePrice> lst = new List<AgeRangePrice>();
            foreach (var node in Node.Fees)
            {
                lst.Add(new AgeRangePrice(node.from, node.to, node.fee));
            }
            return lst;
        }

        public static string GetRangeFee(dynamic Node)
        {
            decimal minFee = 0, maxFee = 0;
            bool isInitMinMax = false;
            foreach (var node in Node.Fees)
            {
                if (!isInitMinMax)
                {
                    minFee = maxFee = node.fee;
                    isInitMinMax = true;
                    continue;
                }
                if (minFee > node.fee)
                    minFee = node.fee;
                if (maxFee < node.fee)
                    maxFee = node.fee;
            }
            if (minFee == maxFee)
                return minFee.ToString();
            return minFee + "-" + maxFee;
        }

        public static bool IsAgeRangeValid(List<AgeRangePrice> AgeRange, List<Patient> ListPatients)
        {
            foreach (var patient in ListPatients)
            {
                if (AgeRange.Any(n => n.ageMin <= patient.Age && patient.Age <= n.ageMax))
                    return true;
            }
            return false;
        }

        public static string GetPreniumLogoUrl(Node node)
        {
            Node node1 = new Node(1452);
            //umbraco.content.
            return null;
        }

        public static List<string> GetListPreniumKeyPoints(dynamic Premium)
        {
            List<string> lstKeyPoint = new List<string>();

            if (Premium.HasValue("keyPoint"))
            {
                using (StringReader sr = new StringReader(Premium.keyPoint))
                {
                    string keyPointItem;
                    while ((keyPointItem = sr.ReadLine()) != null)
                    {
                        if (!string.IsNullOrWhiteSpace(keyPointItem))
                            lstKeyPoint.Add(keyPointItem);
                    }
                }
            }

            return lstKeyPoint;
        }

        public static string GetExess(string NodeId)
        {
            return "";
        }
    }

    public class Premium
    {
        public int id { get; set; }
        public string name { get; set; }
        public string description { get; set; }
        public string logo { get; set; }
        public string documentUrl { get; set; }
        public string detailsUrl { get; set; }
        public List<string> deductibles { get { return new List<string>(); } set {} }
        public string level { get; set; }
        public decimal excess { get; set; }
        public string area { get; set; }
        public List<string> options { get; set; }
        public string currency { get; set; }
        public decimal totalPrice { get; set; }
        public string priceInCurrency { get; set; }
        public List<AgeRangePrice> ageRangePrices { get; set; }
        public string insurerName { get; set; }
        public int insurerId { get; set; }
        public string planName { get; set; }
        public int planId { get; set; }
        public decimal maxBenefit { get; set; }
        //public 
    }

    public class AgeRangePrice
    {
        public int ageMin { get; set; }
        public int ageMax { get; set; }
        public decimal price { get; set; }

        public AgeRangePrice(int MinAge, int MaxAge, decimal Price)
        {
            ageMin = MinAge;
            ageMax = MaxAge;
            price = Price;
        }

        public static AgeRangePrice CreateFrom(string Str)
        {
            string[] tokens = Str.Split(':');
            if (tokens.Length != 2)
                return null;
            decimal price = 0;
            if (decimal.TryParse(tokens[1], out price))
                return null;
            tokens = tokens[0].Split('-');
            if (tokens.Length != 2)
                return null;
            int ageMin = 0, ageMax = 0;
            if (int.TryParse(tokens[0], out ageMin) && ageMin < 0 && ageMin > 100)
                return null;
            if (int.TryParse(tokens[1], out ageMax) && ageMax < 0 && ageMax > 100 && ageMax < ageMin)
                return null;
            AgeRangePrice pp = new AgeRangePrice(ageMin, ageMax, price);
            return pp;
        }
    }
}

/*
{
    name: '@Html.Raw(prem.Name.Replace("'", "\\'"))',
    description: '@Html.Raw(prem.Properties["Description"].Value.Replace("'", "\\'"))',
    logo:        '@(prem.Properties["logo"] != null && Model.MediaById(prem.Properties["logo"]) != null ? Model.MediaById(prem.Properties["logo"]).umbracoFile : "")',
    documentUrl: '@(prem.Properties["document"] != null && Model.MediaById(prem.Properties["document"]) != null ? Model.MediaById(prem.Properties["document"]).umbracoFile : "")',
    detailsUrl: 'ProductDetail',
    deductibles: [
        {
            name: '$5000',
            value: 5000
        },
        {
            name: '$3000',
            value: 4000
        },
        {
            name: '$1000',
            value: 1000
        }
    ],
    level: '@Html.Raw(Utility.UtilityIFC.GetValue(prem.Properties["coverLevel"].Value.Replace("'", "\\'")))',
    excess: '@Html.Raw(prem.Properties["excess"].Value)',
    area: '@Html.Raw(Utility.UtilityIFC.GetValue(prem.Properties["area"].Value.Replace("'", "\\'")))',
    options: [
        @Html.Raw(Utility.UtilityIFC.GetOptions(prem.Properties["Options"].Value.Replace("'", "\\'")))
    ],
    totalPrice: 1000,
    priceInCurrency: ko.observable('')
}
*/