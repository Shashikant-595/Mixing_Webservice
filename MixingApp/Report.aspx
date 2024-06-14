<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="MixingApp.Report" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mixing Graph</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/bootstrap.rtl.min.css" rel="stylesheet" />
    <style type="text/css">
        .fixed-header {
            position: sticky;
            top: 56px;
            z-index: 1;
            background-color: #fff;
        }
        .fixednav {
            position: sticky;
            top: 0px;
            z-index: 1;
            background-color: #fff;
        }
        .caption-top {
            border-collapse: collapse;
            width: 100%;
        }
        .caption-top th, .caption-top td {
            border: 1px solid #dddddd;
            padding: 8px;
            text-align: left;
        }
        .caption-top tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .caption-top tr:hover {
            background-color: #dddddd;
        }
        body {
            margin-top: 56px;
        }
        .navbar {
            z-index: 1000;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixednav">
       <%-- <a class="navbar-brand" href="#">MIXING REPORTS</a>--%>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a class="nav-link navbar-brand" href="Batch_Graphs.aspx" style="color:cornflowerblue;">MIXING GRAPHS <span class="sr-only"> </span></a>
                </li>
            </ul>
            <div class="form-inline my-2 my-lg-0">
                <input id="batchid" class="form-control mr-sm-2" runat="server" type="search" placeholder="SEARCH BATCH_NO" aria-label="Search" data-batch="Batch_No">
            </div>
            <div class="form-inline my-2 my-lg-0">
                <input id="searchInput" class="form-control mr-sm-2" runat="server" type="search" placeholder="SEARCH SAPCODE" aria-label="Search" data-sapcode="sapcode">
            </div>
            <button id="exportExcelBtn" class="btn btn-outline-success ml-3" type="button">EXPORT TO EXCEL</button>
        </div>
    </nav>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="mixing_data" runat="server" BackColor="White" BorderStyle="Solid" BorderWidth="10px" CellSpacing="1" Width="728px" CssClass="caption-top">
                <HeaderStyle CssClass="fixed-header" BorderColor="#00CC00" BorderStyle="Double" />
                <RowStyle BorderStyle="Solid" BorderWidth="2px" />
                <SelectedRowStyle BorderColor="#00CC66" BorderStyle="Double" Font-Bold="True" />
            </asp:GridView>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var sapcodeindex = 0;

            var debounceTimer;
            $("#searchInput").on("keyup", function () {
                clearTimeout(debounceTimer);
                var value = $(this).val().toLowerCase();
                debounceTimer = setTimeout(function () {
                    $("#mixing_data tr:gt(0)").each(function () {
                        var cellText = $(this).find("td:eq(" + sapcodeindex + ")").text().toLowerCase();
                        $(this).toggle(cellText.indexOf(value) > -1);
                    });
                }, 200); // Adjust debounce delay as needed
            });

            var batchindex = 4;
            $("#batchid").on("keyup", function () {
                clearTimeout(debounceTimer);
                var value = $(this).val().toLowerCase();
                debounceTimer = setTimeout(function () {
                    $("#mixing_data tr:gt(0)").each(function () {
                        var cellText = $(this).find("td:eq(" + batchindex + ")").text().toLowerCase();
                        $(this).toggle(cellText.indexOf(value) > -1);
                    });
                }, 200); // Adjust debounce delay as needed
            });

            $("#exportExcelBtn").on("click", function (e) {
                e.preventDefault();
                exportTableToCSV('MixingData.csv');
            });

            function exportTableToCSV(filename) {
                var csv = [];
                var rows = $("#mixing_data tr:visible").get();

                for (var i = 0; i < rows.length; i++) {
                    var row = [], cols = rows[i].querySelectorAll("td, th");

                    for (var j = 0; j < cols.length; j++) {
                        var cellText = cols[j].innerText.replace(/"/g, '""');
                        row.push('"' + (cellText ? cellText : '') + '"');
                    }

                    csv.push(row.join(","));
                }

                // Create a link element
                var link = document.createElement("a");
                link.setAttribute("href", 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv.join("\n")));
                link.setAttribute("download", filename);

                // Append the link to the document body
                document.body.appendChild(link);

                // Trigger a click event on the link
                link.click();

                // Remove the link from the document
                document.body.removeChild(link);
            }
        });
    </script>
</body>
</html>
