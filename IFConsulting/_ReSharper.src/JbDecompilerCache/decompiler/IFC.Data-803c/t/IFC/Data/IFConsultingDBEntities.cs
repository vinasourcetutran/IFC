// Type: IFC.Data.IFConsultingDBEntities
// Assembly: IFC.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// Assembly location: E:\Projects\IFC\src\Bin\IFC.Data.dll

using System.Data.EntityClient;
using System.Data.Objects;

namespace IFC.Data
{
  public class IFConsultingDBEntities : ObjectContext
  {
    private ObjectSet<EmailSubscribe> _EmailSubscribes;

    public ObjectSet<EmailSubscribe> EmailSubscribes
    {
      get
      {
        if (this._EmailSubscribes == null)
          this._EmailSubscribes = this.CreateObjectSet<EmailSubscribe>("EmailSubscribes");
        return this._EmailSubscribes;
      }
    }

    public IFConsultingDBEntities()
      : base("name=IFConsultingDBEntities", "IFConsultingDBEntities")
    {
      this.ContextOptions.LazyLoadingEnabled = true;
    }

    public IFConsultingDBEntities(string connectionString)
      : base(connectionString, "IFConsultingDBEntities")
    {
      this.ContextOptions.LazyLoadingEnabled = true;
    }

    public IFConsultingDBEntities(EntityConnection connection)
      : base(connection, "IFConsultingDBEntities")
    {
      this.ContextOptions.LazyLoadingEnabled = true;
    }

    public void AddToEmailSubscribes(EmailSubscribe emailSubscribe)
    {
      this.AddObject("EmailSubscribes", (object) emailSubscribe);
    }
  }
}
