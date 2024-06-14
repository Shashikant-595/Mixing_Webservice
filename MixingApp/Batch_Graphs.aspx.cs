using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixingApp
{
    public partial class Batch_Graphs : System.Web.UI.Page
    {
        // public static string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
        private static string connectionString = "Data Source=192.168.20.70,1433;Initial Catalog=Mixing;User ID=admin;Password=Fores@123;";
      //  public static string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Mixing;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // on page loade pass the list of batch names 
            List<string> Batches = getbatchesfrom_master();

            System.Diagnostics.Trace.WriteLine($" batchess are  ; " + Batches);
            foreach (string batch in Batches)
            {
                System.Diagnostics.Debug.WriteLine(batch);
                ddlTable.Items.Add(new ListItem(batch));
            }
        }

    


        
        [WebMethod]
        public static string GetBatchData(List<string> selectedBatches, string sapcode)
        {
            List<BatchData> batchDataList = new List<BatchData>();


            foreach (string batchName in selectedBatches)
            {
                string query = "SELECT R_ml, R_mh, R_ts2, R_tc50, R_tc90 FROM " + sapcode + " WHERE Batch_No = @batchno";
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@batchno", batchName);
                            connection.Open();

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    BatchData batchData = new BatchData
                                    {
                                        BatchName = batchName,
                                        R_ml = reader.GetDouble(0),
                                        R_mh = reader.GetDouble(1),
                                        R_ts2 = reader.GetDouble(2),
                                        R_tc50 = reader.GetDouble(3),
                                        R_tc90 = reader.GetDouble(4)
                                    };
                                    batchDataList.Add(batchData);
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Exception fetching batch data: " + ex.Message);
                }
            }

            var json = new JavaScriptSerializer().Serialize(batchDataList);
            return json;
        }
        protected void btnSelect_Click(object sender, EventArgs e)
        {
            string sap = ddlTable.SelectedValue;
            DateTime startDate;
            DateTime endDate;

            if (!DateTime.TryParse(txtStartDate.Text, out startDate))
            {
                System.Diagnostics.Trace.WriteLine("Invalid start date.");
                return;
            }

            if (!DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                System.Diagnostics.Trace.WriteLine("Invalid end date.");
                return;
            }

            string startDateString = startDate.ToString("MM/dd/yyyy");
            string endDateString = endDate.ToString("MM/dd/yyyy");

            string query = "SELECT Batch_No FROM " + sap + " WHERE Reho_Date_Time >= @startdate AND Reho_Date_Time <= @enddate";
            List<string> batchNames = new List<string>();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@startdate", startDateString);
                        command.Parameters.AddWithValue("@enddate", endDateString);

                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string batchName = reader.GetString(0); // Assuming Batch_No is the first column
                                batchNames.Add(batchName);
                               
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine($"Exception: " + ex.Message);
                System.Diagnostics.Trace.WriteLine($"Stack Trace: " + ex.StackTrace);

                // Handle exception here
            }

            repeaterBatchNames.DataSource = batchNames;
            repeaterBatchNames.DataBind();
        }

        public class BatchData
        {
            public string BatchName { get; set; }
            public double R_ml { get; set; }
            public double R_mh { get; set; }
            public double R_ts2 { get; set; }
            public double R_tc50 { get; set; }
            public double R_tc90 { get; set; }
        }

        protected void ddlTable_SelectedIndexChanged(object sender, EventArgs e)
        {


        }
        private List<string> getbatchesfrom_master()
        {
            List<string> batches = new List<string>();
            string query = "SELECT sapcode FROM Master";
            
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {


                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        connection.Open();
                        System.Diagnostics.Trace.WriteLine($"Connection opened successfully.");

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {


                                // Assuming batch_name is a string field in the database

                                string batchName = reader.GetString(0); // Assuming batch_name is the first column
                               
                                batches.Add(batchName);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine($" exception is   ; " + ex.StackTrace);

                // Handle exception here
            }

            return batches;
        }

        protected void repeaterBatchNames_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }

        protected void newbtn_Click(object sender, EventArgs e)
        {
            List<string> selectedBatches = new List<string>();
            string sapcode = ddlTable.SelectedValue;

            // Collect selected batch names
            foreach (RepeaterItem item in repeaterBatchNames.Items)
            {
                CheckBox chkSelectBatch = item.FindControl("chkSelectBatch") as CheckBox;
                HiddenField hiddenBatchName = item.FindControl("hiddenBatchName") as HiddenField;

                if (chkSelectBatch != null && hiddenBatchName != null && chkSelectBatch.Checked)
                {
                    string batchNameValue = hiddenBatchName.Value;
                    selectedBatches.Add(batchNameValue);
                }
            }
            
            // Arrays to hold data for each batch
            List<List<double>> batchData = new List<List<double>>();
            for (int i = 0; i < selectedBatches.Count; i++)
            {
                batchData.Add(new List<double>());
            }

            // Fetch data for each selected batch
            for (int i = 0; i < selectedBatches.Count; i++)
            {
                string batch = selectedBatches[i];
                string queryforbatch_Data = $"SELECT R_ml, R_mh, R_ts2, R_tc50, R_tc90 FROM {sapcode} WHERE Batch_No = @Batch_No";

                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand command = new SqlCommand(queryforbatch_Data, connection))
                        {
                            command.Parameters.AddWithValue("@Batch_No", batch);
                            connection.Open();

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    System.Diagnostics.Trace.WriteLine("Connection opened successfully.");

                                    // Read the values from the database and add them to the corresponding list
                                    batchData[i].Add(reader.GetDouble(0)); // R_ml
                                    batchData[i].Add(reader.GetDouble(1)); // R_mh
                                    batchData[i].Add(reader.GetDouble(2)); // R_ts2
                                    batchData[i].Add(reader.GetDouble(3)); // R_tc50
                                    batchData[i].Add(reader.GetDouble(4)); // R_tc90
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Exception: " + ex.StackTrace);
                    // Handle exception here
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string selectedBatchesJson = serializer.Serialize(selectedBatches);

            // Set the JSON string to the hidden field value
            labelsHiddenField.Value = selectedBatchesJson;

            // Now batchData contains data for each batch
            // You can pass these arrays to JSChart or any other charting library as needed
            // Example of passing data to JSChart:



            string jsChartData = "[" + string.Join(", ", batchData.Select(d => "[" + string.Join(", ", d) + "]")) + "]";
            hiddenChartData.Value = jsChartData;    
            System.Diagnostics.Trace.WriteLine($"JSChart data: {jsChartData}");

        }


    }
}