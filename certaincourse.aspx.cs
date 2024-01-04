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
    public partial class certaincourse : System.Web.UI.Page
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
            bool ii = Int32.TryParse(iid.Text, out int iidd);

            SqlCommand view = new SqlCommand("select * from dbo.FN_StudentViewSlot(@CourseID, @InstructorID)", conn);
            view.Parameters.Add(new SqlParameter("@CourseID", cidd));
            view.Parameters.Add(new SqlParameter("@InstructorID", iidd));

            SqlCommand checkid = new SqlCommand("select course_id from Course where course_id = @courseid", conn);
            checkid.Parameters.Add(new SqlParameter("@courseID", cidd));

            SqlCommand checkidd = new SqlCommand("select instructor_id from Instructor where instructor_id = @InstructorID", conn);
            checkidd.Parameters.Add(new SqlParameter("@InstructorID", iidd));




            conn.Open();
            object result = checkid.ExecuteScalar();
            object result1 = checkidd.ExecuteScalar();

            if (c == false | ii == false)
            {
                Literal1.Text = "Wrong Datatype Used";
            }
            else if (result == null)
            {
                Literal1.Text = "Wrong Course ID";
            }
            else if (result1 == null)
            {

                Literal1.Text = "Wrong Instructor ID";
            }
            else
            {

                using (SqlDataReader reader = view.ExecuteReader())
                {
                    string html = "<table border='1'><tr>";

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        html += "<th>" + reader.GetName(i) + "</th>";
                    }

                    html += "</tr>";

                    while (reader.Read())
                    {
                        html += "<tr>";

                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            html += "<td>" + reader[i] + "</td>";
                        }

                        html += "</tr>";
                    }

                    html += "</table>";

                    Literal1.Text = html;
                }
            }
            conn.Close();
        }
    }
}