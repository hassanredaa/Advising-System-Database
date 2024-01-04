using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Advising_System
{
    public partial class studentviewinstallment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Advising_System"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand viewins = new SqlCommand("select dbo.FN_StudentUpcoming_installment(@student_ID)", conn);
            viewins.Parameters.Add(new SqlParameter("@student_ID", Session["user"]));
            
            conn.Open();    
            object result = viewins.ExecuteScalar();
            conn.Close();
            if (result == DBNull.Value)
            {
                Literal1.Text = "No Upcoming Installment";
            }
            else
            {
                Literal1.Text = result.ToString();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Student.aspx");
        }
    }
}