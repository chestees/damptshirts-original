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

public partial class detail : Page
{
	public myFunctions myFunctionsInstance = new myFunctions();
	public constants varConst = new constants();
	public string myDescription;
	protected string myLink = "";
	protected string LinkPrefix = "";
	protected string Link_Full = "";
	protected string LinkSuffix = "";
	public string Product;
	public int DiggID;
	public int Thumbs;
	public string strH1;
	public string strImage;
	public string strImageLg;
	public string strImageFB;
	public string DiggStore;
	public string CouponText;
	public int DiggStoreID;
	protected bool blnVoted;
	public string strKeyword;
	public string linkText;
	string myCookie;

	StringBuilder txtProductThumbs = new StringBuilder();
	public StringBuilder txtKeywords = new StringBuilder();
	public StringBuilder txtTitleKeywords = new StringBuilder();

	public void Page_Load(object sender, EventArgs e)
	{
		if (Request.Cookies[varConst.cSiteName] != null)
		{
			myCookie = Server.HtmlEncode(Request.Cookies[varConst.cSiteName].Value);
		}
		string TempDiggID = Request.QueryString["i"];
		DiggID = Convert.ToInt32(TempDiggID);

		using (varConst.conn)
		{
			//GET THE SHIRT'S TAG LIST
			varConst.conn.Open();
			SqlCommand cmd = new SqlCommand();
			cmd.Connection = varConst.conn;
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.CommandText = varConst.cSP_GetTags;
			cmd.Parameters.Add("@SelectNum", SqlDbType.Int);
			cmd.Parameters["@SelectNum"].Value = 0;
			cmd.Parameters.Add("@DiggID", System.Data.SqlDbType.Int);
			cmd.Parameters["@DiggID"].Value = DiggID;
			cmd.Parameters.Add("@SiteName", SqlDbType.VarChar);
			cmd.Parameters["@SiteName"].Value = varConst.cSiteName;
			using (SqlDataReader ShirtTags = cmd.ExecuteReader())
			{
				ShirtTagCloud.DataSource = ShirtTags;
				ShirtTagCloud.DataBind();
			}

			SqlDataReader myKeywords = cmd.ExecuteReader();
			if (myKeywords.HasRows)
			{
				while (myKeywords.Read())
				{
					strKeyword = myKeywords["Tag"].ToString();
					txtKeywords.Append(strKeyword + ",");
					txtTitleKeywords.Append(strKeyword + " ");
				}
			}
			Trace.Write("KEYWORDS: " + txtKeywords);
			myKeywords.Close();

			//GET THE SHIRT DETAILS
			SqlCommand cmd_get_detail = new SqlCommand();
			cmd_get_detail.Connection = varConst.conn;
			cmd_get_detail.CommandType = CommandType.StoredProcedure;
			cmd_get_detail.CommandText = "usp_Digg_AffiliateLink";
			cmd_get_detail.Parameters.Add("@DiggID", SqlDbType.Int);
			cmd_get_detail.Parameters["@DiggID"].Value = DiggID;
			SqlDataReader rdrDetail = cmd_get_detail.ExecuteReader();

			if (rdrDetail.HasRows)
			{
				Trace.Write("ROWS found.");
				while (rdrDetail.Read())
				{
					Product = rdrDetail["title"].ToString();
					Thumbs = Convert.ToInt32(rdrDetail["thumbs"]);
					strImage = rdrDetail["image"].ToString();
					strImageLg = rdrDetail["imageLg"].ToString();
					//((DampTShirts)this.Master).strImage = strImage;
					DiggStoreID = Convert.ToInt32(rdrDetail["vendorId"]);
					DiggStore = rdrDetail["vendor"].ToString();
					strH1 = Product + " Shirt";
					CouponText = rdrDetail["CouponTextDigg"].ToString();

					this.Page.Title = Product + " Shirt - " + txtTitleKeywords;

					if (strImageLg != "")
					{
						ProductImage.ImageUrl = strImageLg;
						strImageFB = strImageLg;
					}
					else
					{
						ProductImage.ImageUrl = strImage;
						strImageFB = strImage;
					}

					Link_Full = (rdrDetail["link"].ToString()) ?? null;
					LinkPrefix = (rdrDetail["linkPrefix"].ToString()) ?? null;
					LinkSuffix = (rdrDetail["linkSuffix"].ToString()) ?? null;
					myLink = myFunctionsInstance.formLink(Link_Full, LinkPrefix, LinkSuffix, DiggID);
					ProductLink.Text = "Visit " + DiggStore + " to see " + Product;
					ProductLink.NavigateUrl = myLink;
				}
			}
			else
			{
				Trace.Write("No rows found.");
			}
			//Trace.Write("Link: " + myLink);
			rdrDetail.Close();

			//GET THE COUPON FOR THE DIGGSTORE
			SqlCommand cmdCoupons = new SqlCommand();
			cmdCoupons.Connection = varConst.conn;
			cmdCoupons.CommandType = CommandType.StoredProcedure;
			cmdCoupons.CommandText = "usp_Digg_CouponList";
			cmdCoupons.Parameters.Add("@DiggStoreID", System.Data.SqlDbType.Int);
			cmdCoupons.Parameters["@DiggStoreID"].Value = DiggStoreID;
			using (SqlDataReader drCoupons = cmdCoupons.ExecuteReader())
			{
				if (drCoupons.HasRows)
				{
					rptCoupons.DataSource = drCoupons;
					rptCoupons.DataBind();
				}
			}
			varConst.conn.Close();
		}

		//BUILD THUMBS MODULE
		string cssThumbs = myFunctionsInstance.isPositive_Class(Thumbs);
		if (myCookie != null && myFunctionsInstance.DidTheyVote(DiggID, myCookie))
		{
			Trace.Write("I VOTED: " + DiggID);
			txtProductThumbs.Append("<div id='ThumbID_" + DiggID + "' class='ThumbMod detail'>");
			txtProductThumbs.Append("<div class='PlusMinus " + cssThumbs + "'>" + myFunctionsInstance.isPositive_Number(Thumbs) + "</div>");
			txtProductThumbs.Append("</div>");
		}
		else
		{
			txtProductThumbs.Append("<div id='ThumbID_" + DiggID + "' class='ThumbMod detail'>");
			txtProductThumbs.Append("<div id='ThumbsDown' class='btn btn_thumb btn_down' name='" + DiggID + "'><span class='txt'>Meh</span><div class='clear'></div></div>");
			txtProductThumbs.Append("<div id='ThumbsUp' class='btn btn_thumb btn_up l_margin_5' name='" + DiggID + "'><span class='txt'>Like</span><div class='clear'></div></div>");
			txtProductThumbs.Append("</div>");
		}
		ProductThumbs.Text = txtProductThumbs.ToString();
	}

	//BUILD THE COUPON LIST
	public void Coupons_ItemDataBound(object sender, RepeaterItemEventArgs e)
	{
		if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
		{
			DbDataRecord dbrdCoupon = (DbDataRecord)e.Item.DataItem;
			var ltrlCoupon = e.Item.FindControl("CouponItem") as Literal;

			string strCoupon = dbrdCoupon["Coupon"].ToString();

			ltrlCoupon.Text = "<div class=\"coupon_text\">" + strCoupon + "</div>";
		}
	}

	//BUILD THE SHIRT'S TAG LIST
	public void ShirtTags_ItemDataBound(object sender, RepeaterItemEventArgs e)
	{
		if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
		{
			DbDataRecord dbrd = (DbDataRecord)e.Item.DataItem;
			var ShirtTagCloud = e.Item.FindControl("ShirtTags") as Literal;

			string Tag = myFunctionsInstance.Stripper(dbrd["Tag"].ToString());
			int TagID = Convert.ToInt32(dbrd["TagID"]);
			if (varConst.cSiteName == "damptshirts")
			{
				ShirtTagCloud.Text = "<li><a class=\"btn\" href='/" + varConst.cSEODirectory + "/tag/" + TagID + "/" + Tag + "/'>" + dbrd["Tag"] + "</a></li>";
			}
			else
			{
				ShirtTagCloud.Text = "<li><a class=\"btn\" href='/" + Tag + "/tag/" + TagID + "/'>" + dbrd["Tag"] + "</a></li>";
			}
		}
	}
}