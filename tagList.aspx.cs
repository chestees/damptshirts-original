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

public partial class tagList : Page
{
  public myFunctions myFunctionsInstance = new myFunctions();
  public constants varConst = new constants();
  public string strImage;
	public string path = HttpContext.Current.Request.Url.AbsolutePath;
	public string jsonTagsFull;

  protected void Page_Load(object sender, EventArgs e)
  {
    ((DampTShirts)this.Master).strImage = varConst.cDefaultShareIMG;
    strImage = varConst.cDefaultShareIMG;

    this.Page.Title = "Damp T-Shirts Tag List";

		using (varConst.conn)
		{
			varConst.conn.Open();
			// FULL TAG LIST WITHIN THE DROPDOWN
			SqlCommand cmdFull = new SqlCommand();
			cmdFull.Connection = varConst.conn;
			cmdFull.CommandType = CommandType.StoredProcedure;
			cmdFull.CommandText = varConst.cSP_GetTags;
			cmdFull.Parameters.Add("@SelectNum", SqlDbType.Int);
			cmdFull.Parameters["@SelectNum"].Value = 0;
			cmdFull.Parameters.Add("@DiggID", SqlDbType.Int);
			cmdFull.Parameters["@DiggID"].Value = 0;
			cmdFull.Parameters.Add("@SiteName", SqlDbType.VarChar, 50);
			cmdFull.Parameters["@SiteName"].Value = varConst.cSiteName;
			SqlDataReader TagsFull = cmdFull.ExecuteReader();

			JavaScriptSerializer serializer = new JavaScriptSerializer();
			ArrayList arrTagsFull = new ArrayList();

			while (TagsFull.Read())
			{
				object[] values = new object[TagsFull.FieldCount];
				TagsFull.GetValues(values);
				arrTagsFull.Add(values);
			}

			jsonTagsFull = serializer.Serialize(arrTagsFull);
			Trace.Write("JSON Tags is: " + jsonTagsFull);
		}
  }
}