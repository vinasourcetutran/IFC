// Type: IFC.Business.Handler.Subscribe
// Assembly: IFC.Business, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// Assembly location: E:\Projects\IFC\src\Bin\IFC.Business.dll

using IFC.Data;
using System;
using System.Data.Objects;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace IFC.Business.Handler
{
  public class Subscribe
  {
    public bool InsetEmailSubscribe(string email)
    {
      // ISSUE: object of a compiler-generated type is created
      // ISSUE: variable of a compiler-generated type
      Subscribe.\u003C\u003Ec__DisplayClass0 cDisplayClass0 = new Subscribe.\u003C\u003Ec__DisplayClass0();
      // ISSUE: reference to a compiler-generated field
      cDisplayClass0.email = email;
      IFConsultingDBEntities consultingDbEntities = new IFConsultingDBEntities();
      ObjectSet<EmailSubscribe> emailSubscribes = consultingDbEntities.EmailSubscribes;
      ParameterExpression parameterExpression = Expression.Parameter(typeof (EmailSubscribe), "x");
      // ISSUE: method reference
      // ISSUE: field reference
      // ISSUE: method reference
      Expression<Func<EmailSubscribe, bool>> predicate = Expression.Lambda<Func<EmailSubscribe, bool>>((Expression) Expression.Equal((Expression) Expression.Property((Expression) parameterExpression, (MethodInfo) MethodBase.GetMethodFromHandle(__methodref (EmailSubscribe.get_Email))), (Expression) Expression.Field((Expression) Expression.Constant((object) cDisplayClass0), FieldInfo.GetFieldFromHandle(__fieldref (Subscribe.\u003C\u003Ec__DisplayClass0.email))), false, (MethodInfo) MethodBase.GetMethodFromHandle(__methodref (string.op_Equality))), new ParameterExpression[1]
      {
        parameterExpression
      });
      if (Queryable.Any<EmailSubscribe>((IQueryable<EmailSubscribe>) emailSubscribes, predicate))
        return false;
      // ISSUE: reference to a compiler-generated field
      consultingDbEntities.EmailSubscribes.AddObject(new EmailSubscribe()
      {
        Email = cDisplayClass0.email
      });
      consultingDbEntities.SaveChanges();
      return true;
    }
  }
}
