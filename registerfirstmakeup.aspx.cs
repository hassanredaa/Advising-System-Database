using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Advising_System
{
    public partial class registerfirstmakeup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Advising_System"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            bool c = Int32.TryParse(TextBox1.Text, out int cidd);
            string semcode = TextBox2.Text;
            SqlCommand register = new SqlCommand("Procedures_StudentRegisterFirstMakeup", conn);
            register.CommandType = CommandType.StoredProcedure;
            register.Parameters.Add(new SqlParameter("@studentID", Session["user"]));
            register.Parameters.Add(new SqlParameter("@courseID", cidd));
            register.Parameters.Add(new SqlParameter("@studentCurr_sem", semcode));

            conn.Open();
            int affected = register.ExecuteNonQuery();
            conn.Close();



            if (c == false)
            {
                Literal1.Text = "Wrong Datatype Used";
            }
            else if (affected > 0)
            {
                Literal1.Text = "Registered succesfully";
            }
            else
            {
                SqlCommand checkid = new SqlCommand("select course_id from Course where course_id = @courseid", conn);
                checkid.Parameters.Add(new SqlParameter("@courseID", cidd));
                conn.Open();
                object result = checkid.ExecuteScalar();
                conn.Close();
                if (result == null)
                {
                    Literal1.Text = "Wrong course ID, Didn't register";
                }
                else
                {

                    Literal1.Text = "Didn't register";
                }
                    
            }



        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("Student.aspx");

        }
    }
}