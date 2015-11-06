using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class about : Page
{
    public constants varConst = new constants();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Page.Title = "What is " + varConst.cFriendlySiteName;
    }
}