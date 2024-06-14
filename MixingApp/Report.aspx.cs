using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixingApp
{
    public partial class Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Ensure data binding occurs only on initial load
            {
                datagrideview bll = new datagrideview();
                DataTable tableData = bll.GetTableDataForAdvancedGridView();

                // Bind the DataTable to your advanced data grid view
                mixing_data.DataSource = tableData;
                mixing_data.DataBind();
            }
        }
        [System.Web.Services.WebMethod]
        public static void ExportToExcel()
        {
            // Create a new Excel package
            using (var package = new ExcelPackage())
            {
                // Create a new worksheet
                var worksheet = package.Workbook.Worksheets.Add("MixingData");

                // Populate the worksheet with data from the GridView
                GridView gv = new GridView();
                gv.DataSource = ((Report)HttpContext.Current.Handler).GetData();
                gv.DataBind();

                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    for (int j = 0; j < gv.Columns.Count; j++)
                    {
                        worksheet.Cells[i + 1, j + 1].Value = gv.Rows[i].Cells[j].Text;
                    }
                }

                // Save the Excel package to a memory stream
                var stream = new MemoryStream(package.GetAsByteArray());

                // Send the Excel file to the client for download
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=exported_data.xlsx");
                HttpContext.Current.Response.BinaryWrite(stream.ToArray());
                HttpContext.Current.Response.End();
            }
        }

        // Method to get data for GridView
        public DataTable GetData()
        {
            // Retrieve data from the original data source and return it
            datagrideview bll = new datagrideview();
            return bll.GetTableDataForAdvancedGridView();
        }

    }
}