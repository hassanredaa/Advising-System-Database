using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Advising_System
{
    public partial class ViewStuGradPlan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Advising_System"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand viewgrad = new SqlCommand("select * from dbo.FN_StudentViewGP(@student_ID)", conn);
            viewgrad.Parameters.Add(new SqlParameter("@student_ID", Session["user"]));
            conn.Open();
            using (SqlDataReader reader = viewgrad.ExecuteReader())
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
            conn.Close();



        }

        protected void back_Click(object sender, EventArgs e)
        {
            Response.Redirect("Student.aspx");
        }

    }
}