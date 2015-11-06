using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Globalization;

public class myFunctions
{
  public string Stripper(string myString)
  {
    myString = myString.Trim().ToLower().Replace("  ", " ").Replace(" ", "-");
    string[] SpecialChars = new string[] { ",", "%", "...", "!!!", "#", "+", "(", ")", "&", "$", "@", "!", "*", "<", ">", "?", "/", "|", "\",", ",", "'", ":", "ó", ".", "%20", "%25", "%23", "%2B", "%28", "%29", "%26", "%24", "%40", "%21", "%2A", "%3C", "%3E", "%3F", "%2F", "%7C", "%5C", "%2C", "%27", "%3A", "%D3", "%E8", "%E9", "%2E" };
    foreach (string i in SpecialChars)
    { myString = myString.Replace(i, ""); }
    return myString.Replace("-s-", "s-").Replace("---", "-").Replace("--", "-").ToString();
  }

  public string unStrip(string myString)
  {
    // Check for empty string.
    if (string.IsNullOrEmpty(myString))
    {
      return string.Empty;
    }
    // Return char and concat substring.
    myString = myString.Replace("-", " ").ToString();
    myString = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(myString);
    //myString = char.ToUpper(myString[0]) + myString.Substring(1);
    return myString;
  }

  public string isPositive_Class(int Thumbs)
  {
    if (Thumbs > 0)
    {
      return ("Positive");
    }
    else if (Thumbs < 0)
    {
      return ("Negative");
    }
    else
    {
      return ("");
    }
  }

  public string isPositive_Number(int Thumbs)
  {
    if (Thumbs > 0)
    {
      return ("+" + Thumbs);
    }
    else
    {
      return (Convert.ToString(Thumbs));
    }
  }

  public bool DidTheyVote(int DiggID, string myCookie)
  {
    int Voted = 0;
    if (myCookie != null)
    {
      Voted = myCookie.IndexOf("X" + Convert.ToString(DiggID) + "X", 0);
    }
    if (Voted >= 0)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  public string formLink(string Link_Full, string LinkPrefix, string LinkSuffix, int DiggID)
  {
    string myLink;
    if (String.IsNullOrEmpty(LinkPrefix))
    {
      myLink = Link_Full + LinkSuffix;
    }
    else
    {
      if (LinkPrefix.IndexOf("shareasale", 0) > 0)
      {
        LinkPrefix = LinkPrefix.Replace("afftrack=", "afftrack=" + DiggID);
        myLink = LinkPrefix + Link_Full.Replace("http://", "");

      }
      else
      {
        myLink = LinkPrefix + Link_Full;
      }
    }
    return myLink;
  }
}