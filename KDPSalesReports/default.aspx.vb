Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Math
Imports System.Web
Imports System.Web.HttpUtility
Imports System.Web.UI.WebControls
Imports System.Xml
Imports KDPSalesReports.Configuration
Imports KDPSalesReports.SqlDataAccess
Imports KDPSalesReports.StoredProcedures

Partial Class _default
    Inherits System.Web.UI.Page

    Private _newFileNameNoExt As String
    Private _txtPath As String
    Private _xmlPath As String
    Private _radQuerySelected As RadioButton
    Private WithEvents ctrlRad1 As controls_QueryTotalRoyaltiesPerBookControl
    Private WithEvents ctrlRad2 As controls_QueryTotalRoyaltiesOfAuthorControl
    Private WithEvents ctrlRad3 As controls_QueryTotalRoyaltiesByAuthorControl
    Private WithEvents ctrlRad4 As controls_QueryTop10HighestEarningAuthorsControl
    Private WithEvents ctrlRad5 As controls_QueryAuthorsRankedByTotalRoyaltiesControl
    Private WithEvents ctrlRad6 As controls_QueryTop20WorstPerformingTitlesControl
    Private WithEvents ctrlRad7 As controls_QueryRoyaltiesForMonthAndYearControl
    Private WithEvents ctrlRad8 As controls_QueryTotalRoyaltiesPerYearControl
    Private WithEvents ctrlRad9 As controls_QueryRoyaltyReportForMonthAndYearControl
    Private WithEvents ctrlRad10 As controls_QueryRoyaltiesPerMonthOfYearControl
    Private WithEvents ctrlRad11 As controls_QueryRoyaltiesFromNonUSMarketsControl
    Private WithEvents ctrlRad12 As controls_QueryRefundRatesControl

    Private Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Init
        ctrlRad1 = Page.LoadControl("controls/QueryTotalRoyaltiesPerBookControl.ascx")
        ctrlRad2 = Page.LoadControl("controls/QueryTotalRoyaltiesOfAuthorControl.ascx")
        ctrlRad3 = Page.LoadControl("controls/QueryTotalRoyaltiesByAuthorControl.ascx")
        ctrlRad4 = Page.LoadControl("controls/QueryTop10HighestEarningAuthorsControl.ascx")
        ctrlRad5 = Page.LoadControl("controls/QueryAuthorsRankedByTotalRoyaltiesControl.ascx")
        ctrlRad6 = Page.LoadControl("controls/QueryTop20WorstPerformingTitlesControl.ascx")
        ctrlRad7 = Page.LoadControl("controls/QueryRoyaltiesForMonthAndYearControl.ascx")
        ctrlRad8 = Page.LoadControl("controls/QueryTotalRoyaltiesPerYearControl.ascx")
        ctrlRad9 = Page.LoadControl("controls/QueryRoyaltyReportForMonthAndYearControl.ascx")
        ctrlRad10 = Page.LoadControl("controls/QueryRoyaltiesPerMonthOfYearControl.ascx")
        ctrlRad11 = Page.LoadControl("controls/QueryRoyaltiesFromNonUSMarketsControl.ascx")
        ctrlRad12 = Page.LoadControl("controls/QueryRefundRatesControl.ascx")
        phrOptions.Controls.Add(ctrlRad1)
        phrOptions.Controls.Add(ctrlRad2)
        phrOptions.Controls.Add(ctrlRad3)
        phrOptions.Controls.Add(ctrlRad4)
        phrOptions.Controls.Add(ctrlRad5)
        phrOptions.Controls.Add(ctrlRad6)
        phrOptions.Controls.Add(ctrlRad7)
        phrOptions.Controls.Add(ctrlRad8)
        phrOptions.Controls.Add(ctrlRad9)
        phrOptions.Controls.Add(ctrlRad10)
        phrOptions.Controls.Add(ctrlRad11)
        phrOptions.Controls.Add(ctrlRad12)
        AddHandler rad1.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad2.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad3.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad4.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad5.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad6.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad7.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad8.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad9.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad10.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad11.CheckedChanged, AddressOf radQuery_CheckedChanged
        AddHandler rad12.CheckedChanged, AddressOf radQuery_CheckedChanged
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            For Each c As Control In phrOptions.Controls
                If TypeOf (c) Is UserControl Then
                    c.Visible = False
                End If
            Next
        End If
    End Sub

    Private Sub btnUpload_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnUpload.Click

        ' Make sure that a file has been selected.
        If fupReport.HasFile Then

            ' Check for the correct file extension.
            Dim fileName As String = fupReport.FileName
            Dim ext As String = Path.GetExtension(fileName)

            If IsTxtFile(ext) = True Then

                ' Check the file size if you want to set a limit on files that are uploaded.
                ' In this case, the limit is 2 MB, which is 2097152 bytes.
                ' 1 MB = 1048576 bytes
                ' Here's a conversion calculator: http://www.t1shopper.com/tools/calculate/

                If fupReport.PostedFile.ContentLength > 2097152 Then
                    lblStatus.Text = "The file size must be 2 MB or less. Your file is " & Math.Round(Convert.ToDecimal(fupReport.PostedFile.ContentLength) / Convert.ToDecimal(1048576), 2).ToString() & " MB."
                    lblStatus.CssClass = "status_error"
                Else
                    
                    _newFileNameNoExt = GenerateFileName()
                    _txtPath = Server.MapPath("txt/" & _newFileNameNoExt & ".txt")
                    _xmlPath = Server.MapPath("xml/" & _newFileNameNoExt & ".xml")
                    If Not Directory.Exists(Server.MapPath("txt/")) Then
                        Directory.CreateDirectory(Server.MapPath("txt"))
                        fupReport.SaveAs(_txtPath)
                    Else
                        fupReport.SaveAs(_txtPath)
                    End If

                    ' Read the text file using File.ReadAllText, which results in a string.
                    ' Incidentally, File.ReadAllLines would result in a string array, and we would need
                    ' to write more elaborate code to get rid of the blank lines in that case.
                    ' When saving a spreadsheet in Excel as a tab or comma delimited file, there may
                    ' be unwanted blank lines at the end of it, which tends to be problematic whenever
                    ' such a file needs to be processed in some way.

                    Dim txtOld As String = String.Empty ' the original, multiline string
                    Dim txtNew As String() = Nothing ' a string array that will hold the lines of txtOld
                    Try
                        txtOld = File.ReadAllText(_txtPath, Encoding.Default).Trim() ' get rid of any leading or trailing whitespace; important to set the encoding b/c of non-English characters
                        ' Encoding.Unicode results in "IndexOutOfRangeException: Index was outside the bounds of the array." exception when filling the XDocument
                        txtNew = txtOld.Split(CChar(Environment.NewLine)) ' add each line of txtOld to a string array
                    Catch ex As Exception
                        lblStatus.Text = ex.Message
                        lblStatus.CssClass = "status_error"
                        Exit Sub
                    End Try

                    Dim xdoc As XDocument = <?xml version="1.0" encoding="utf-8"?>
                                            <RoyaltyReport>

                                            </RoyaltyReport>

                    ' Create an XElement called <Sales>, and use LINQ to populate each <Sale>.
                    ' Since we have a tab delimited text file, we need to split by the tab character.
                    ' If we had a comma delimited (.csv) file, we would split by comma, but that gets
                    ' a little dicey when you're dealing with fields that contain one or more commas.                    

                    Dim el As XElement = _
                    <Sales>
                        <%= From records In txtNew _
                            Let values = Split(records, ControlChars.Tab) _
                            Select _
                            <Sale>
                                <RoyaltyDate><%= values(0) %></RoyaltyDate>
                                <Title><%= HtmlEncode(values(1).Replace(Chr(34), String.Empty)) %></Title>
                                <AuthorName><%= HtmlEncode(values(2)) %></AuthorName>
                                <ASIN><%= values(3) %></ASIN>
                                <Marketplace><%= values(4) %></Marketplace>
                                <RoyaltyType><%= values(5) %></RoyaltyType>
                                <TransactionType><%= values(6) %></TransactionType>
                                <UnitsSold><%= values(7) %></UnitsSold>
                                <UnitsRefunded><%= values(8) %></UnitsRefunded>
                                <RefundRate><%= (Convert.ToDecimal(values(8)) / Convert.ToDecimal(values(7))).ToString() %></RefundRate>
                                <NetUnitsSold><%= values(9) %></NetUnitsSold>
                                <AvgListPriceWithoutTax><%= values(10) %></AvgListPriceWithoutTax>
                                <AvgFileSizeMB><%= values(11) %></AvgFileSizeMB>
                                <AvgOfferPriceWithoutTax><%= values(12) %></AvgOfferPriceWithoutTax>
                                <AvgDeliveryCost><%= values(13) %></AvgDeliveryCost>
                                <Royalty><%= values(14) %></Royalty>
                                <Currency><%= values(15) %></Currency>
                            </Sale> _
                        %>
                    </Sales>

                    ' Add <Sales> to the XDocument.
                    xdoc.Root.Add(el)

                    ' Saving the .xml file is optional, since we can do what we need to do while our
                    ' data are being stored in the XDocument object, but here's how to save it in case
                    ' you want a copy of your sales report in XML format to use at a later date.

                    If Not Directory.Exists(Server.MapPath("xml/")) Then
                        Directory.CreateDirectory(Server.MapPath("xml"))
                    Else
                        xdoc.Save(_xmlPath)
                    End If

                    ' Here's how to load the saved document. It's commented out because the code below
                    ' uses the XDocument that was created above (xdoc). If you save the file and then
                    ' load it, you should create a new XDocument with a different name. In that case,
                    ' you would need to replace "xdoc" in the code below with "xml" (or whatever the
                    ' name of your new XDocument is.
                    'Dim xml As XDocument = XDocument.Load(_xmlPath)

                    ' Create a DataTable, and fill it with the data from the XDocument.
                    Dim sales = xdoc.Root.<Sales>(0)
                    Dim dt As New DataTable
                    If sales.Elements.Count > 0 Then
                        dt.TableName = "BookSales" ' The name must match the name of the table in the database.
                        ' The System data types must be compatible with the SQL data types.
                        ' Here's a helpful guide for future reference:
                        ' http://kambiz-na.blogspot.com/2009/09/mapping-sql-data-type-to-system-type.html
                        dt.Columns.Add("RoyaltyDate", GetType(System.DateTime))
                        dt.Columns.Add("Title", GetType(System.String))
                        dt.Columns.Add("AuthorName", GetType(System.String))
                        dt.Columns.Add("ASIN", GetType(System.String))
                        dt.Columns.Add("Marketplace", GetType(System.String))
                        dt.Columns.Add("RoyaltyType", GetType(System.String))
                        dt.Columns.Add("TransactionType", GetType(System.String))
                        dt.Columns.Add("UnitsSold", GetType(System.Int32))
                        dt.Columns.Add("UnitsRefunded", GetType(System.Int32))
                        dt.Columns.Add("RefundRate", GetType(System.Decimal))
                        dt.Columns.Add("NetUnitsSold", GetType(System.Int32))
                        dt.Columns.Add("AvgListPriceWithoutTax", GetType(System.Decimal))
                        dt.Columns.Add("AvgFileSizeMB", GetType(System.Decimal))
                        dt.Columns.Add("AvgOfferPriceWithoutTax", GetType(System.Decimal))
                        dt.Columns.Add("AvgDeliveryCost", GetType(System.Decimal))
                        dt.Columns.Add("Royalty", GetType(System.Decimal))
                        dt.Columns.Add("Currency", GetType(System.String))

                        ' Get the data for each <Sale> in <Sales>
                        For i As Integer = 0 To sales.Elements.Count - 1
                            Dim rDate As DateTime = Convert.ToDateTime(sales.<Sale>.<RoyaltyDate>(i).Value)
                            Dim rDateStr As String = rDate.ToString("yyyy-MM-dd") ' This is the format in which the date will be stored in the database.
                            Dim title As String = HtmlDecode(sales.<Sale>.<Title>(i).Value) ' Don't forget to HtmlDecode anything that was encoded earlier.
                            Dim auth As String = HtmlDecode(sales.<Sale>.<AuthorName>(i).Value)
                            Dim asin As String = sales.<Sale>.<ASIN>(i).Value
                            Dim mark As String = sales.<Sale>.<Marketplace>(i).Value
                            Dim rType As String = sales.<Sale>.<RoyaltyType>(i).Value
                            Dim tType As String = sales.<Sale>.<TransactionType>(i).Value
                            Dim sold As String = Int32.Parse(sales.<Sale>.<UnitsSold>(i).Value)
                            Dim refd As String = Int32.Parse(sales.<Sale>.<UnitsRefunded>(i).Value)
                            Dim rate As String = Decimal.Parse(sales.<Sale>.<RefundRate>(i).Value)
                            Dim nus As String = Int32.Parse(sales.<Sale>.<NetUnitsSold>(i).Value)
                            Dim price As String = Convert.ToDecimal(sales.<Sale>.<AvgListPriceWithoutTax>(i).Value)
                            Dim size As String = Convert.ToDecimal(sales.<Sale>.<AvgFileSizeMB>(i).Value)
                            Dim offer As String = Convert.ToDecimal(sales.<Sale>.<AvgOfferPriceWithoutTax>(i).Value)
                            Dim dev As String = Convert.ToDecimal(sales.<Sale>.<AvgDeliveryCost>(i).Value)
                            Dim roy As String = Convert.ToDecimal(sales.<Sale>.<Royalty>(i).Value)
                            Dim cur As String = sales.<Sale>.<Currency>(i).Value

                            ' Create a new DataRow and populate it.
                            Dim row As DataRow = dt.NewRow()
                            row("RoyaltyDate") = rDateStr
                            row("Title") = title
                            row("AuthorName") = auth
                            row("ASIN") = asin
                            row("Marketplace") = mark
                            row("RoyaltyType") = rType
                            row("TransactionType") = tType
                            row("UnitsSold") = sold
                            row("UnitsRefunded") = refd
                            row("RefundRate") = rate
                            row("NetUnitsSold") = nus
                            row("AvgListPriceWithoutTax") = price
                            row("AvgFileSizeMB") = size
                            row("AvgOfferPriceWithoutTax") = offer
                            row("AvgDeliveryCost") = dev
                            row("Royalty") = roy
                            row("Currency") = cur

                            ' Add the DataRow to the DataTable
                            dt.Rows.Add(row)
                        Next

                    End If

                    ' Import the data into the database using SqlBulkCopy.
                    Try
                        Using cnn As New SqlConnection(DbConnectionString)
                            cnn.Open()
                            Using bulkCopy As New SqlBulkCopy(cnn)
                                ' Import the data
                                bulkCopy.DestinationTableName = dt.TableName
                                bulkCopy.ColumnMappings.Add("RoyaltyDate", "RoyaltyDate") ' (SourceColumn, DestinationColumn)
                                bulkCopy.ColumnMappings.Add("Title", "Title")
                                bulkCopy.ColumnMappings.Add("AuthorName", "AuthorName")
                                bulkCopy.ColumnMappings.Add("ASIN", "ASIN")
                                bulkCopy.ColumnMappings.Add("Marketplace", "Marketplace")
                                bulkCopy.ColumnMappings.Add("RoyaltyType", "RoyaltyType")
                                bulkCopy.ColumnMappings.Add("TransactionType", "TransactionType")
                                bulkCopy.ColumnMappings.Add("UnitsSold", "UnitsSold")
                                bulkCopy.ColumnMappings.Add("UnitsRefunded", "UnitsRefunded")
                                bulkCopy.ColumnMappings.Add("RefundRate", "RefundRate")
                                bulkCopy.ColumnMappings.Add("NetUnitsSold", "NetUnitsSold")
                                bulkCopy.ColumnMappings.Add("AvgListPriceWithoutTax", "AvgListPriceWithoutTax")
                                bulkCopy.ColumnMappings.Add("AvgFileSizeMB", "AvgFileSizeMB")
                                bulkCopy.ColumnMappings.Add("AvgOfferPriceWithoutTax", "AvgOfferPriceWithoutTax")
                                bulkCopy.ColumnMappings.Add("AvgDeliveryCost", "AvgDeliveryCost")
                                bulkCopy.ColumnMappings.Add("Royalty", "Royalty")
                                bulkCopy.ColumnMappings.Add("Currency", "Currency")
                                bulkCopy.WriteToServer(dt)
                            End Using
                            ' Remove duplicate records
                            Dim cmd As New SqlCommand
                            cmd.Connection = cnn
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.CommandText = CN_RemoveDuplicates
                            cmd.ExecuteNonQuery()
                        End Using
                        lblStatus.Text = "Your file was successfully uploaded and imported into the database."
                        lblStatus.CssClass = "status_ok"
                    Catch ex As Exception
                        lblStatus.Text = ex.Message
                        lblStatus.CssClass = "status_error"
                    End Try
                End If
            Else
                lblStatus.Text = "The file type is incorrect. Only text files (.txt) are allowed."
                lblStatus.CssClass = "status_error"
            End If
        Else
            lblStatus.Text = "Click the Browse button above to select a file to upload."
            lblStatus.CssClass = "status_error"
        End If
    End Sub

    Private Function IsTxtFile(ByVal extension As String) As Boolean
        Select Case extension.ToLower()
            Case ".txt"
                Return True
            Case Else
                Return False
        End Select
    End Function

    Private Function GenerateFileName() As String
        Dim result As String = Guid.NewGuid().ToString().Replace("-", String.Empty)
        Return result
    End Function

    Private Sub radQuery_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim rb As RadioButton = CType(sender, RadioButton)
        If rb IsNot Nothing Then
            If rb.Checked = True Then
                _radQuerySelected = rb
                If _radQuerySelected.UniqueID = "rad1" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = True
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad2" Then
                    lblInstructions.Text = "Select an author from the list:"
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = True
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad3" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = True
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad4" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = True
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad5" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = True
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad6" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = True
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad7" Then
                    lblInstructions.Text = "Select the year first, and then the month:"
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = True
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad8" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = True
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad9" Then
                    lblInstructions.Text = "Select the year first, and then the month:"
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = True
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad10" Then
                    lblInstructions.Text = "Select a year:"
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = True
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad11" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = True
                    ctrlRad12.Visible = False
                End If
                If _radQuerySelected.UniqueID = "rad12" Then
                    lblInstructions.Text = String.Empty
                    ctrlRad1.Visible = False
                    ctrlRad2.Visible = False
                    ctrlRad3.Visible = False
                    ctrlRad4.Visible = False
                    ctrlRad5.Visible = False
                    ctrlRad6.Visible = False
                    ctrlRad7.Visible = False
                    ctrlRad8.Visible = False
                    ctrlRad9.Visible = False
                    ctrlRad10.Visible = False
                    ctrlRad11.Visible = False
                    ctrlRad12.Visible = True
                End If
            End If
        End If
    End Sub
    
End Class
