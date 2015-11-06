using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Text.RegularExpressions;

public partial class products_download : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        WebClient wc = new WebClient();
        wc.DownloadFile(@"http://mantascode.com/wp-content/uploads/2013/06/cropped-IMG_1738.jpg", @"\\fs1-n02\stor2wc1dfw1\407499\407510\www.damptshirts.com\web\content\Test.png");
        
        //WebClient wchtml = new WebClient();
        //string htmlString = wchtml.DownloadString("http://imgur.com/a/GPlx4");
        //int mastercount = 0;
        //Regex regPattern = new Regex(@"http://i.imgur.com/(.*?)alt=""", RegexOptions.Singleline);
        //MatchCollection matchImageLinks = regPattern.Matches(htmlString);

        //foreach (Match img_match in matchImageLinks)
        //{
        //    string imgurl = img_match.Groups[1].Value.ToString();
        //    Regex regx = new Regex("http://([\\w+?\\.\\w+])+([a-zA-Z0-9\\~\\!\\@\\#\\$\\%\\^\\&amp;\\*\\(\\)_\\-\\=\\+\\\\\\/\\?\\.\\:\\;\\'\\,]*)?",
        //        RegexOptions.IgnoreCase);
        //    MatchCollection ms = regx.Matches(imgurl);
        //    foreach (Match m in ms)
        //    {
        //        Console.WriteLine("Downloading..  " + m.Value);
        //        mastercount++;
        //        try
        //        {
        //            WebClient wc = new WebClient();
        //            //wc.DownloadFile(m.Value, @"\\fs1-n02\stor2wc1dfw1\407499\407510\www.damptshirts.com\web\content\images\thumbnails\threadless\bg_" + mastercount + ".gif");
        //            wc.DownloadFile(m.Value, @"C:\Users\jdiehl\Desktop\myStuff\bg_" + mastercount + ".gif");
        //            //Thread.Sleep(1000);
        //        }
        //        catch (Exception x)
        //        {
        //            Console.WriteLine("Failed to download image.");
        //        }
        //        break;
        //    }
        //}
    }
}
