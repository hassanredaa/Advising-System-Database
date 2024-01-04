using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Advising_System
{
    public partial class chooseinstructor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("student.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Advising_System"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            bool c = Int32.TryParse(cid.Text, out int cidd);
            bool i = Int32.TryParse(iid.Text, out int iidd);
            string semcode = (scode.Text);
            SqlCommand view = new SqlCommand("Procedures_Chooseinstructor", conn);
            view.CommandType = CommandType.StoredProcedure;
            view.Parameters.Add(new SqlParameter("@studentID", Session["user"]));
            view.Parameters.Add(new SqlParameter("@courseID", cidd));
            view.Parameters.Add(new SqlParameter("@instrucorID", iidd));
            view.Parameters.Add(new SqlParameter("@current_semester_code", semcode));

            SqlCommand checkid = new SqlCommand("select course_id from Course where course_id = @courseid", conn);
            checkid.Parameters.Add(new SqlParameter("@courseID", cidd));

            SqlCommand checkidd = new SqlCommand("select instructor_id from Instructor where instructor_id = @InstructorID", conn);
            checkidd.Parameters.Add(new SqlParameter("@InstructorID", iidd));


            conn.Open();
            object result = checkid.ExecuteScalar();
            object result1 = checkidd.ExecuteScalar();
            int affected = view.ExecuteNonQuery();
            conn.Close();

            if (c == false | i == false)
            {
                Literal1.Text = "Wrong Datatype Used";
            }
            else if (affected > 0)
            {
                Literal1.Text = "Instructor Choosen Successfully";
            }
            else
            {
                if (result == null)
                {
                    Literal1.Text = "Wrong Course ID";
                }
                else if (result1 == null)
                {
                    Literal1.Text = "Wrong Instructor ID";
                }
                else
                {
                    Literal1.Text = "Instructor not Choosen Successfully";
                }
            }
        }
    }
}