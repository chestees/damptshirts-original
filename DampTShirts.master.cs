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
using System.Web.Script.Serialization;
using System.Collections;

public partial class DampTShirts : MasterPage
{
  public myFunctions myFunctionsInstance = new myFunctions();
  public constants varConst = new constants();
  public database varDbConn = new database();
  
  public int DiggID;
  public string path = HttpContext.Current.Request.Url.AbsolutePath;
  public string strImage;
  public string url = HttpContext.Current.Request.Url.PathAndQuery;
  public int isDetailPage;

	protected void Page_Load(object sender, EventArgs e)
	{
		string TempDiggID = Request.QueryString["i"];
		DiggID = Convert.ToInt32(TempDiggID);

		isDetailPage = url.IndexOf("detail.aspx");
		using (varDbConn.conn)
		{
			varDbConn.conn.Open();
			SqlCommand cmd = new SqlCommand();
			cmd.Connection = varDbConn.conn;
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.CommandText = varConst.cSP_GetTags;
			cmd.Parameters.Add("@SelectNum", SqlDbType.Int);
			cmd.Parameters["@SelectNum"].Value = 10;
			cmd.Parameters.Add("@DiggID", SqlDbType.Int);
			cmd.Parameters["@DiggID"].Value = 0;
			cmd.Parameters.Add("@SiteName", SqlDbType.VarChar, 50);
			cmd.Parameters["@SiteName"].Value = varConst.cSiteName;
			using (SqlDataReader Tags = cmd.ExecuteReader())
			{
				TagList.DataSource = Tags;
				TagList.DataBind();
			}
		}
	}
  public void Tag_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
      if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
      {
        DbDataRecord rd = (DbDataRecord)e.Item.DataItem;
        var TagCloud = e.Item.FindControl("TagCloud") as Literal;
        myFunctions myFunctionsInstance = new myFunctions();
        string Tag = myFunctionsInstance.Stripper(rd["Tag"].ToString());
        string Slug = rd["Slug"].ToString();
        int TagID = Convert.ToInt32(rd["TagID"]);
        if (varConst.cSiteName == "damptshirts")
        {
          TagCloud.Text = "<li><a class=\"btn\" href=\"/" + varConst.cSEODirectory + "/tag/" + TagID + "/" + Slug + "/\">" + rd["Tag"] + " Shirts</a></li>";
        }
        else
        {
          TagCloud.Text = "<li><a class=\"btn\" href=\"/" + Slug + "/tag/" + TagID + "/\">" + rd["Tag"] + " Shirts</a></li>";
        }
      }
    }
}
