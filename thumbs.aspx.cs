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

public partial class thumbs : Page
{
  public myFunctions myFunctionsInstance = new myFunctions();
  public constants varConst = new constants();
  protected void Page_Load(object sender, EventArgs e)
  {
    string TempDiggID = Request.QueryString["DiggID"];
    int DiggID = Convert.ToInt32(TempDiggID);
    string TempThumb = Request.QueryString["Thumb"];
    int Thumb = Convert.ToInt32(TempThumb);

    Thumbs(Thumb, DiggID);
  }

  public void Thumbs(int Thumb, int DiggID)
  {
    using (varConst.conn)
    {
      varConst.conn.Open();
      SqlCommand cmd = new SqlCommand();
      cmd.Connection = varConst.conn;
      cmd.CommandType = CommandType.StoredProcedure;
      cmd.CommandText = "usp_Digg_Thumbs2";
      cmd.Parameters.Add("@DiggID", SqlDbType.Int);
      cmd.Parameters["@DiggID"].Value = DiggID;
      cmd.Parameters.Add("@Thumb", SqlDbType.Int);
      cmd.Parameters["@Thumb"].Value = Thumb;
      
      SqlParameter Thumbs_Output = cmd.Parameters.Add("@Thumbs", SqlDbType.Int);
      Thumbs_Output.Direction = ParameterDirection.Output;
      cmd.ExecuteNonQuery();

      myFunctions myFunctionsInstance = new myFunctions();
      
      string myCookie = null;
      if (Request.Cookies[varConst.cSiteName] != null)
      {
        myCookie = Server.HtmlEncode(Request.Cookies[varConst.cSiteName].Value);
        myCookie = myCookie + Convert.ToString(DiggID) + "X";
        Response.Cookies[varConst.cSiteName].Value = myCookie;
      } else {
        Response.Cookies[varConst.cSiteName].Value = "X" + Convert.ToString(DiggID) + "X";
      }
      Response.Cookies[varConst.cSiteName].Expires = DateTime.Now.AddDays(10);
      Response.Write(DiggID + "," + Convert.ToInt32(Thumbs_Output.Value));
      varConst.conn.Close();
    }
  }
}