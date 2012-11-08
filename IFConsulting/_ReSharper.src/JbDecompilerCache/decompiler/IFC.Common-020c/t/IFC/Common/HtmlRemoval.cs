// Type: IFC.Common.HtmlRemoval
// Assembly: IFC.Common, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// Assembly location: E:\Projects\IFC\src\Bin\IFC.Common.dll

using System.Text.RegularExpressions;

namespace IFC.Common
{
  public static class HtmlRemoval
  {
    private static Regex _htmlRegex = new Regex("<.*?>", RegexOptions.Compiled);

    static HtmlRemoval()
    {
    }

    public static string StripTagsRegex(string source)
    {
      return Regex.Replace(source, "<.*?>", string.Empty);
    }

    public static string StripTagsRegexCompiled(string source)
    {
      return HtmlRemoval._htmlRegex.Replace(source, string.Empty);
    }

    public static string StripTagsCharArray(string source)
    {
      char[] chArray = new char[source.Length];
      int length = 0;
      bool flag = false;
      for (int index = 0; index < source.Length; ++index)
      {
        char ch = source[index];
        switch (ch)
        {
          case '<':
            flag = true;
            break;
          case '>':
            flag = false;
            break;
          default:
            if (!flag)
            {
              chArray[length] = ch;
              ++length;
            }
            break;
        }
      }
      return new string(chArray, 0, length);
    }
  }
}
