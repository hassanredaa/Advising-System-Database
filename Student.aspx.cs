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
    public partial class Student : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Advising_System"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand viewins = new SqlCommand("select f_name from Student where (@student_ID) = student_id", conn);
            viewins.Parameters.Add(new SqlParameter("@student_ID", Session["user"]));
            conn.Open();
            object result = viewins.ExecuteScalar();
            conn.Close();

            Literal1.Text = ("Student ID: " +Session["user"] + " Student Name: " + result.ToString());

        }

        protected void GradPlan_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewStuGradPlan.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        protected void viewinstall(object sender, EventArgs e)
        {
            Response.Redirect("studentviewinstallment.aspx");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("viewallcourses.aspx");
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            Response.Redirect("registerfirstmakeup.aspx");
        }

        protected void Button4_Click(object sender, EventArgs e)
        {
            Response.Redirect("registerstudentsecond.aspx");
        }

        protected void Button5_Click(object sender, EventArgs e)
        {
            Response.Redirect("viewcourseslotins.aspx");
        }

        protected void Button6_Click(object sender, EventArgs e)
        {
            Response.Redirect("certaincourse.aspx");
        }

        protected void Button7_Click(object sender, EventArgs e)
        {
            Response.Redirect("chooseinstructor.aspx");
        }

        protected void Button8_Click(object sender, EventArgs e)
        {
            Response.Redirect("courseswithpreq.aspx");
        }

        protected void Button9_Click(object sender, EventArgs e)
        {
            Response.Redirect("..\\HomePage.aspx");

        }
    }
}