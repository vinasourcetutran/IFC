namespace Utility
{
    public class Patient
    {
        public EnumSex Sex { get; set; }
        public int Age { get; set; }
    }

    public enum EnumSex
    {
        Female = 0,
        Male = 1,
        NotChoose = -1
    }
}