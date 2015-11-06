using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class coupons : System.Web.UI.Page
{
    public constants varConst = new constants();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Page.Title = "T-Shirt Coupons - " + varConst.cTitle;
    }
}