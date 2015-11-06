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
using System.IO;

public partial class sitemap : Page
{
  public myFunctions myFunctionsInstance = new myFunctions();
  public constants varConst = new constants();
  protected void Page_Load(object sender, EventArgs e)
  {
    StringBuilder strXML = new StringBuilder();
    strXML.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    strXML.Append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");
    strXML.Append("<url>");
    strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/</loc>");
    strXML.Append("<changefreq>weekly</changefreq>");
    strXML.Append("</url>");
    strXML.Append("<url>");
    strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/tag-list/</loc>");
    strXML.Append("<changefreq>weekly</changefreq>");
    strXML.Append("</url>");
    if (varConst.cSiteName == "damptshirts")
    {
      strXML.Append("<url>");
      strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/t-shirt-coupons/</loc>");
      strXML.Append("<changefreq>weekly</changefreq>");
      strXML.Append("</url>");
      strXML.Append("<url>");
      strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/what-is-damp-t-shirts/</loc>");
      strXML.Append("<changefreq>weekly</changefreq>");
      strXML.Append("</url>");
      strXML.Append("<url>");
      strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/contact/</loc>");
      strXML.Append("<changefreq>weekly</changefreq>");
      strXML.Append("</url>");
    }
    using (varConst.conn)
    {
      varConst.conn.Open();
      SqlCommand cmd = new SqlCommand();
      cmd.Connection = varConst.conn;
      cmd.CommandType = CommandType.StoredProcedure;
      cmd.CommandText = varConst.cSP_SiteMap_Links;
      cmd.Parameters.Add("@SiteName", SqlDbType.VarChar, 50);
      cmd.Parameters["@SiteName"].Value = varConst.cSiteName;

      SqlDataReader rdr = cmd.ExecuteReader();
      if (rdr.HasRows)
      {
        string Product;
        string Slug;
        int DiggID;
        while (rdr.Read())
        {
          Product = Server.UrlEncode(myFunctionsInstance.Stripper(rdr["Title"].ToString()));
          Slug = rdr["Slug"].ToString();
          DiggID = Convert.ToInt32(rdr["DiggID"]);
          if (Product == "") Product = varConst.cSiteName + "-shirt";

          if (varConst.cSiteName == "damptshirts")
          {
            strXML.Append("<url>");
            strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/t/" + varConst.cSEODirectory + "/" + DiggID + "/" + Slug + "/</loc>");
            strXML.Append("<changefreq>weekly</changefreq>");
            strXML.Append("</url>");
          }
          else {
            strXML.Append("<url>");
            strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/" + Slug + "/shirt/" + DiggID + "/</loc>");
            strXML.Append("<changefreq>weekly</changefreq>");
            strXML.Append("</url>");
          }
        }
      }
      rdr.Close();

      SqlCommand cmd2 = new SqlCommand();
      cmd2.Connection = varConst.conn;
      cmd2.CommandType = CommandType.StoredProcedure;
      cmd2.CommandText = varConst.cSP_SiteMap_Tags;
      cmd2.Parameters.Add("@SiteName", SqlDbType.VarChar, 50);
      cmd2.Parameters["@SiteName"].Value = varConst.cSiteName;
      SqlDataReader rdr2 = cmd2.ExecuteReader();
      if (rdr2.HasRows)
      {
        string Tag;
        string TagSlug;
        int TagID;
        while (rdr2.Read())
        {
          Tag = Server.UrlEncode(myFunctionsInstance.Stripper(rdr2["Tag"].ToString()));
          TagSlug = rdr2["Slug"].ToString();
          TagID = Convert.ToInt32(rdr2["TagID"]);

          if (varConst.cSiteName == "damptshirts")
          {
            strXML.Append("<url>");
            strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/" + varConst.cSEODirectory + "/tag/" + TagID + "/" + TagSlug + "/</loc>");
            strXML.Append("<changefreq>weekly</changefreq>");
            strXML.Append("</url>");
          }
          else {
            strXML.Append("<url>");
            strXML.Append("<loc>http://www." + varConst.cSiteName + ".com/" + TagSlug + "/tag/" + TagID + "/</loc>");
            strXML.Append("<changefreq>weekly</changefreq>");
            strXML.Append("</url>");
          }
        }
      }
      rdr2.Close();

      strXML.Append("</urlset>");

      StreamWriter swFromFile = new StreamWriter(varConst.cSiteDirectory + "sitemap.xml");
      swFromFile.Write(strXML);
      swFromFile.Flush();
      swFromFile.Close();		
    }
  }
}