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
using System.Web.Script.Serialization;
using System.Collections;

public partial class index : Page
{
  public myFunctions myFunctionsInstance = new myFunctions();
  public constants varConst = new constants();
  public database varDbConn = new database();

  protected string myCookie;
  int intSeperator = 0;
  protected string strH1;
  protected string metaKeywords;
  protected string metaDescription;
  protected string jsonShirts;
  public string strImage;
  public string strURL;
  public string MetaKeywords;

  public void Page_Load(object sender, EventArgs e)
  {
    ((DampTShirts)this.Master).strImage = varConst.cDefaultShareIMG;
    strImage = varConst.cDefaultShareIMG;
    strURL = "http://www." + varConst.cSiteName + ".com/";
    if (Request.Cookies[varConst.cSiteName] != null)
    {
      myCookie = Server.HtmlEncode(Request.Cookies[varConst.cSiteName].Value);
      Trace.Write("MY NEW COOKIE: " + myCookie);
    }
    string Search = myFunctionsInstance.unStrip(Request.QueryString["Search"] ?? "0");
    string TempTagID = Request.QueryString["TagID"] ?? "0";
    int TagID = Convert.ToInt32(TempTagID);
    string Tag = Request.QueryString["Tag"] ?? "";

    // START VARIABLES //

    if (Search != "0") // SEARCH
    {
      strH1 = varConst.cH1Search + Search;
      this.Page.Title = varConst.cTitle;
      metaKeywords = Search + ", " + metaKeywords;
      metaDescription = "The best " + Search + " shirts from all over the internet. Vote for the best t-shirts on " + varConst.cSiteName + ".com";
    }
    else if (TagID > 0) // TAG
    {
      string myTag = "";
      varDbConn.conn.Open();
      SqlCommand cmd = new SqlCommand();
      cmd.Connection = varDbConn.conn;
      cmd.CommandType = CommandType.StoredProcedure;
      cmd.CommandText = "usp_Digg_GetTagDetail";
      cmd.Parameters.Add("@TagID", SqlDbType.Int);
      cmd.Parameters["@TagID"].Value = TagID;
      SqlDataReader rdrTag = cmd.ExecuteReader();

      if (rdrTag.HasRows)
      {
        while (rdrTag.Read())
        {
          myTag = rdrTag["Tag"].ToString();
          metaKeywords = rdrTag["MetaKeywords"].ToString();
          strImage = rdrTag["Image"].ToString();
          if (varConst.cSiteName == "damptshirts")
          {
            strURL = "http://www." + varConst.cSiteName + ".com/shirt/tag/" + TagID + "/" + myFunctionsInstance.Stripper(myTag).ToString() + "/";
          }
          else
          {
            strURL = "http://www." + varConst.cSiteName + ".com/shirt/tag/" + TagID + "/" + myFunctionsInstance.Stripper(myTag).ToString() + "/";
          }
        }
      }
      rdrTag.Close();
      varDbConn.conn.Close();

      strH1 = myTag;
      
      if (TagID != 474) {
          strH1 = strH1 + varConst.cH1Tag;
      }
      this.Page.Title = myTag + varConst.cH1Tag;
      metaKeywords = myTag + " shirts, " + metaKeywords;
      metaDescription = "The best " + myTag + " shirts from all over the internet. Vote for the best t-shirts on " + varConst.cSiteName + ".com";
    }
    else // DEFAULT
    {
      strH1 = varConst.cH1Default;
      this.Page.Title = varConst.cTitle;
      metaKeywords = varConst.keywords();
      metaDescription = varConst.cDescription;
    }

    Trace.Write("Page is: " + Page);
    Trace.Write("TagID is: " + TagID);
    Trace.Write("Tag is: " + Tag);
    Trace.Write("Search is: " + Search);

    using (varDbConn.conn)
    {                                                                    
      varDbConn.conn.Open();
      SqlCommand cmd = new SqlCommand();
      cmd.Connection = varDbConn.conn;
      cmd.CommandType = CommandType.StoredProcedure;
      cmd.CommandText = "usp_Digg_GetShirts";
      cmd.Parameters.Add("@TagID", SqlDbType.Int);
      cmd.Parameters["@TagID"].Value = TagID;
      cmd.Parameters.Add("@Search", SqlDbType.VarChar, 50);
      cmd.Parameters["@Search"].Value = Search;
      cmd.Parameters.Add("@SiteName", SqlDbType.VarChar, 50);
      cmd.Parameters["@SiteName"].Value = varConst.cSiteName;
      SqlDataReader drShirts = cmd.ExecuteReader();

      JavaScriptSerializer serializer = new JavaScriptSerializer();
      ArrayList arrShirts = new ArrayList();

      while (drShirts.Read())
      {
        object[] values = new object[drShirts.FieldCount];
        drShirts.GetValues(values);
        arrShirts.Add(values);
      }
      jsonShirts = serializer.Serialize(arrShirts);
      //Trace.Write("JSON: " + jsonShirts);
    }
  }
}