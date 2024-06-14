<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Batch_Graphs.aspx.cs" Inherits="MixingApp.Batch_Graphs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="Content/css/select2.min.css" rel="stylesheet" />
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.css" />
    <!-- Bootstrap Datepicker CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css" rel="stylesheet">

    <link rel="stylesheet"
        href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        @keyframes fade {
            0% {
                opacity: 0;
            }

            100% {
                opacity: 1;
            }
        }

        .fading-element {
            animation: fade 2s ease-in-out infinite alternate;
        }

        @keyframes colorChange {
            0% {
                color: orange;
            }

            25% {
                color: white;
            }

            50% {
                color: green;
            }

            75% {
                color: black;
            }

            100% {
                color: red;
            }
        }

        .moving-heading {
            animation: colorChange 20s ease-in-out infinite alternate;
        }

        .bgcolor {
            color: $green-400;
        }

        .Rectangle {
            margin: 5px;
            width: 90%; /* Set width as a percentage */
            max-width: 1230px; /* Set maximum width if needed */
            height: 40vh; /* Set a height using viewport height */
            border: 3px solid red; /* Set border with red color */
        }

        @media (max-width: 768px) {
            .Rectangle {
                width: 95%; /* Adjust width for smaller screens */
                height: 30vh; /* Adjust height for smaller screens */
            }
        }

        .footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            height: 30%; /* Adjust the height as needed */
            background-color: #333; /* Example color for the footer */
            color: white;
            /
        }

        img {
            height: 500px;
        }

        body {
            background-color: ghostwhite;
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* Ensure the body takes at least the full viewport height */
        }

        .social-icons {
            font-size: 50px; /* Adjust the size as needed */
            color: white; /* Example color for the icons */
        }

        @keyframes moveImage {
            0%, 100% {
                transform: translate(0, 0);
            }

            25% {
                transform: translate(20px, 20px); /* Move top right */
            }

            50% {
                transform: translate(20px, -20px); /* Move bottom right */
            }

            75% {
                transform: translate(-20px, -20px); /* Move bottom left */
            }
        }

        .moving-effect {
            animation: moveImage 5s ease-in-out infinite;
        }

        }

        .moving-effect {
            animation: moveImage 5s ease-in-out infinite; /* Adjust duration and timing */
        }

        .pad {
            margin-top: 40px;
        }

        .rectangle {
            margin: 5px;
            width: 90%; /* Set width as a percentage */
            max-width: 1230px; /* Set maximum width if needed */
            height: 40vh; /* Set a height using viewport height */
            border: 3px dashed blue;
        }

        .tbl {
            color: white;
        }

        .checkbox-large {
            width: 20px;
            height: 20px;
            transform: scale(1.5); /* Adjust the scale as needed */
            -webkit-transform: scale(1.5);
            -moz-transform: scale(1.5);
            -ms-transform: scale(1.5);
            -o-transform: scale(1.5);
            margin: 10px; /* Adjust the margin to fit the design */
        }

        .batch-name {
            font-size: 20px;
            color: green;
        }
    </style>


    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.3/font/bootstrap-icons.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
</head>
<body>
    <form id="myForm" runat="server">
        <div class="container">
            <h1 style="text-align: center">MIXING WEB GRAPHS</h1>
            <div class="rectangle">
                <div class="container mt-4">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:DropDownList runat="server" ID="ddlTable" CssClass="form-control" required OnSelectedIndexChanged="ddlTable_SelectedIndexChanged" Font-Bold="True">
                            </asp:DropDownList>
                            <i class="fas fa-caret-down"></i>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group date">
                                <asp:TextBox runat="server" ID="txtStartDate" CssClass="form-control" placeholder="START DATE" required></asp:TextBox>
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group date">
                                <asp:TextBox runat="server" ID="txtEndDate" CssClass="form-control" placeholder="END DATE" required></asp:TextBox>
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div>

                        </div>
                        <div class="col-md-3">
                             <a class="nav-link navbar-brand" href="Report.aspx">MIXING REPORT <span class="sr-only"></span></a>

                        </div>
                        <div class="row ml-12">
                            <div class="col-md-3">
                                <asp:Button runat="server" ID="btnSelect" Text="SELECT" CssClass="btn btn-primary" OnClick="btnSelect_Click" />
                            </div>
                            <div class="col-md-4">
                                <asp:Button runat="server" ID="newbtn" Text="GENERATE " CssClass="btn btn-warning" OnClick="newbtn_Click" />

                            </div>
                            <div class="col-md-3">
                                <asp:Button runat="server" ID="downloadExcelButton" Text="Download" CssClass="btn btn-success" OnClientClick="return downloadExcel();" />

                            </div>


                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2" style="align-items: flex-start">
                        <asp:Repeater ID="repeaterBatchNames" runat="server">
                            <HeaderTemplate>
                                <table>


                                    <tr>
                                    </tr>
                            </HeaderTemplate>

                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkSelectBatch" runat="server" CssClass="checkbox-large" /></td>
                                    <td class="batch-name">
                                        <asp:HiddenField ID="hiddenBatchName" runat="server" Value='<%# Container.DataItem %>' />
                                        <asp:Label ID="batchNameLabel" runat="server" Text='<%# Container.DataItem %>' />
                                    </td>
                                </tr>
                            </ItemTemplate>

                            <FooterTemplate>
                                </table>
      
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="col-md-9" style="margin-top: 50px">
                        <canvas id="myChart" width="500" height="450"></canvas>
                    </div>
                </div>

                 <asp:HiddenField ID="hiddenChartData" runat="server" />
 <asp:HiddenField ID="labelsHiddenField" runat="server" />

            </div>
        </div>

    </form>
</body>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="Scripts/jquery-1.7.min.js"></script>
<script src="Scripts/select2.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- jQuery (required for Bootstrap) -->
<!-- Bootstrap Datepicker JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript">

    //-------------------date time picker----------------------
    $(document).ready(function () {
        $('#<%= ddlTable.ClientID %>').select2({
            placeholder: 'Search...',

        });
    });

    $(document).ready(function () {
        $('#txtStartDate').datepicker({
            autoclose: true,
            todayHighlight: true,
            format: 'yyyy-mm-dd'  // Use 'yyyy-mm-dd' instead of 'yyyy-MM-dd'
        });
        $('#txtEndDate').datepicker({
            autoclose: true,
            todayHighlight: true,
            format: 'yyyy-mm-dd' // Use 'yyyy-mm-dd' instead of 'yyyy-MM-dd'
        });
    });

    $(document).ready(function () {
        // Function to adjust rectangle border height
        function adjustRectangleHeight() {
            var tableHeight = $('.tbl tbody').height(); // Get the height of the table body
            $('.rectangle').css('height', tableHeight + 80); // Set the rectangle height based on table height (add extra for padding)
        }

        // Call the function initially and on window resize (if needed)
        adjustRectangleHeight();
        $(window).resize(adjustRectangleHeight);
    });


    // pass selected batches to the controller end point 
    function generateGraph() {
        var selectedBatches = [];
        $('input[name="selectedBatches"]:checked').each(function () {
            selectedBatches.push($(this).val());
        });

        // Send selected batch names to the server using AJAX
        $.ajax({
            type: 'GET',
            url: 'generateGraph', // Your endpoint in the controller
            data: { selectedBatches: selectedBatches },
            traditional: true,
            success: function (response) {
                //window.location.href = '/lineGraphs.jsp';
            },
            error: function (xhr, status, error) {
                // Handle error if needed
            }
        });
    }


    //////////////////////////////////


    const hiddenChartData = document.getElementById('<%= hiddenChartData.ClientID %>');
    const labelsHiddenField = document.getElementById('<%= labelsHiddenField.ClientID %>');

    console.log("actual data " + hiddenChartData);
    // Function to update chart
    function updateChart() {
        if (hiddenChartData.value && labelsHiddenField.value) {
            // Retrieve the JSON data from the hidden field
            const chartData = JSON.parse(hiddenChartData.value);
            const labels = JSON.parse(labelsHiddenField.value);
            console.log("actual data " + chartData);
            const datasets = chartData.map((data, index) => {
                return {
                    label: labels[index], // Use the label corresponding to the current batch
                    data: Object.values(data),
                    borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 1)`,
                    borderWidth: 5
                };
            });

            const ctx = document.getElementById('myChart').getContext('2d');
             // Get the selected graph type from the dropdown
            new Chart(ctx, {
                type:'line',
                data: {
                    labels: ['ML', 'MH', 'TS2', 'Tc50', 'Tc90'], // Sample X axis labels
                    datasets: datasets
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                font: {
                                    size: 25// Increase font size for y-axis labels
                                }
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    size: 25 // Increase font size for x-axis labels
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            labels: {
                                font: {
                                    size: 20 // Increase font size for legend labels
                                }
                            }
                        },
                        title: {
                            display: true,
                            text: 'MIXING BATCH GRAPHS',
                            font: {
                                size: 15 // Increase font size for chart title
                            }
                        }
                    }
                }
            });
        }
    }
    

    // Add event listener to hidden field to detect changes
    hiddenChartData.addEventListener('input', updateChart);

    // Optional: Initial chart rendering if the hidden field already has data
    if (hiddenChartData.value) {
        updateChart();
    }


    // downloade the chart in to excel
    downloadExcel = function () {
        alert("funcrd ccs  c c ");
        console.log("Function called");
        if (hiddenChartData.value) {
            const chartData = JSON.parse(hiddenChartData.value);

            // Prepare data for Excel
            const worksheetData = [];
            const headers = ['Batch', 'ML', 'MH', 'TS2', 'Tc50', 'Tc90'];
            worksheetData.push(headers);

            chartData.forEach((data, index) => {
                const row = [`Batch ${index + 1}`, ...Object.values(data)];
                worksheetData.push(row);
            });

            const ws = XLSX.utils.aoa_to_sheet(worksheetData);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'Chart Data');

            // Generate Excel file and trigger download
            XLSX.writeFile(wb, 'ChartData.xlsx');
        }
    };


   
</script>

</html>
