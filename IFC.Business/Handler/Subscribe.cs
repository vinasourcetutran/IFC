using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Data.Entity;
using System.Text;
using IFC.Data;

namespace IFC.Business.Handler
{
    public class Subscribe
    {
        
        public bool InsetEmailSubscribe(string email)
        {
            IFConsultingDBEntities context = new IFConsultingDBEntities();           
            if (context.EmailSubscribes.Any(x => x.Email == email))
            {
                return false;
            }
            else
            {
                EmailSubscribe eSub = new EmailSubscribe();
                eSub.Email = email;                
                context.EmailSubscribes.AddObject(eSub);
                context.SaveChanges();
                return true;
            }
            
        }
    }
}
