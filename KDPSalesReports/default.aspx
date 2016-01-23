<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="_default" MaintainScrollPositionOnPostback="true" %>
<%@ Register src="controls/QueryTotalRoyaltiesOfAuthorControl.ascx" tagname="QueryTotalRoyaltiesOfAuthorControl" tagprefix="uc1" %>
<%@ Register src="controls/QueryTotalRoyaltiesPerBookControl.ascx" tagname="QueryTotalRoyaltiesPerBookControl" tagprefix="uc2" %>
<%@ Register src="controls/QueryTotalRoyaltiesByAuthorControl.ascx" tagname="QueryTotalRoyaltiesByAuthorControl" tagprefix="uc3" %>
<%@ Register src="controls/QueryTop10HighestEarningAuthorsControl.ascx" tagname="QueryTop10HighestEarningAuthorsControl" tagprefix="uc4" %>
<%@ Register src="controls/QueryAuthorsRankedByTotalRoyaltiesControl.ascx" tagname="QueryAuthorsRankedByTotalRoyaltiesControl" tagprefix="uc5" %>
<%@ Register src="controls/QueryTop20WorstPerformingTitlesControl.ascx" tagname="QueryTop20WorstPerformingTitlesControl" tagprefix="uc6" %>
<%@ Register src="controls/QueryRoyaltiesForMonthAndYearControl.ascx" tagname="QueryRoyaltiesForMonthAndYearControl" tagprefix="uc7" %>
<%@ Register src="controls/QueryTotalRoyaltiesPerYearControl.ascx" tagname="QueryTotalRoyaltiesPerYearControl" tagprefix="uc8" %>
<%@ Register src="controls/QueryRoyaltyReportForMonthAndYearControl.ascx" tagname="QueryRoyaltyReportForMonthAndYearControl" tagprefix="uc9" %>
<%@ Register src="controls/QueryRoyaltiesPerMonthOfYearControl.ascx" tagname="QueryRoyaltiesPerMonthOfYearControl" tagprefix="uc10" %>
<%@ Register src="controls/QueryRoyaltiesFromNonUSMarketsControl.ascx" tagname="QueryRoyaltiesFromNonUSMarketsControl" tagprefix="uc11" %>
<%@ Register src="controls/QueryRefundRatesControl.ascx" tagname="QueryRefundRatesControl" tagprefix="uc12" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KDP Sales Reports</title>
    <meta name="robots" content="noindex,nofollow,noarchive" />
    <link rel="stylesheet" type="text/css" href="styles.css" />
    <link href="http://fonts.googleapis.com/css?family=Droid+Sans:400,700" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="header">
        <div id="header_left"><img src="images/logo.png" alt="KDP Sales Reports" /></div>
        <div id="header_right">analyze your kindle book sales</div> 
        <div class="clear"></div>
    </div> <!-- #header -->
    <div id="wrapper">        
        <div id="container">
            <div id="content">
                <h2>Step 1: Upload a KDP Sales Report</h2>
                <p>In your <a href="https://kdp.amazon.com/self-publishing/signin" target="_blank">KDP Dashboard</a>, generate a report for either the <strong>Last 30 Days</strong> or the 
                    <strong>Last 90 Days</strong>. Amazon will give you a <strong>.xls</strong> 
                    file, which you should save to your computer. Open the file in Microsoft Excel, 
                    delete the first row (i.e., the column headers, such as &quot;Royalty Date&quot; and 
                    &quot;ASIN&quot;), and then save the file as a tab delimited text file.</p>
                <p>To save as a <strong>tab delimited text file</strong>, click on the <strong>Office Button</strong> in Excel, and 
                    navigate to <strong>Save As &gt; Other Formats</strong>. Select &quot;Text (Tab 
                    delimited) (*.txt).&quot; Upload your .txt file by clicking on the <strong>Browse</strong> button below and 
                    selecting the file. Then click the <strong>Upload Sales Report</strong> button.</p>
                <br /><br />
                <asp:FileUpload ID="fupReport" runat="server" /><br /><br />
                <asp:Button ID="btnUpload" runat="server" Text="Upload Sales Report" /> <asp:Label ID="lblStatus" runat="server"></asp:Label><br /><br />
                <h2>Step 2: Query and Analyze Your Sales Data</h2>
                <p><strong>Select a query:</strong></p>
                <div id="radio_container">                    
                    <div id="radio_left">
                        <asp:RadioButton ID="rad1" runat="server" Text="Total royalties per book (all-time)" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad2" runat="server" Text="Total royalties of a certain author" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad3" runat="server" Text="Total royalties of each author" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad4" runat="server" Text="Top 10 highest-earning authors" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad5" runat="server" Text="Authors ranked by total royalties" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad6" runat="server" Text="Top 20 worst-performing titles" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                    </div> <!-- #radio_left -->
                    <div id="radio_right">
                        <asp:RadioButton ID="rad7" runat="server" Text="Total royalties for a certain month and year" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad8" runat="server" Text="Total royalties per year" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad9" runat="server" Text="Royalty report for a certain month and year" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad10" runat="server" Text="Royalties per month of a certain year" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad11" runat="server" Text="Royalties from non-US markets" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                        <asp:RadioButton ID="rad12" runat="server" Text="Titles with Refund Rates > 0" GroupName="queries" CssClass="radio" AutoPostBack="true" />
                    </div> <!-- #radio_right -->
                    <div class="clear"></div>                    
                </div> <!-- #radio_container -->
                <asp:Label ID="lblInstructions" runat="server" CssClass="aspnet_label"></asp:Label><br />
                <asp:PlaceHolder ID="phrOptions" runat="server"></asp:PlaceHolder><br /><br />
            </div> <!-- #content -->           
        </div> <!-- #container -->    
    </div> <!-- #wrapper -->
    </form>
</body>
</html>
