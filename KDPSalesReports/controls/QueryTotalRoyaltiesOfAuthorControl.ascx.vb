Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.UI.WebControls
Imports KDPSalesReports.Configuration
Imports KDPSalesReports.SqlDataAccess
Imports KDPSalesReports.StoredProcedures

Partial Public Class controls_QueryTotalRoyaltiesOfAuthorControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim dt As DataTable = GetAuthors()
            ddlAuthors.DataSource = dt
            ddlAuthors.DataTextField = "AuthorName"
            ddlAuthors.DataValueField = "ValueField"
            ddlAuthors.DataBind()
        End If
    End Sub

    Private Sub btnRunQuery_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRunQuery.Click
        pnlData.Visible = True
        Try
            Using cnn As New SqlConnection(DbConnectionString)
                cnn.Open()
                Dim cmd As New SqlCommand
                cmd.Connection = cnn
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandText = CN_TotalRoyaltiesOfAuthor
                cmd.Parameters.Add(New SqlParameter("@AuthorName", SqlDbType.NVarChar)).Value = ddlAuthors.SelectedItem.ToString()
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim dt As DataTable = New DataTable()
                da.Fill(dt)
                rptData.DataSource = dt
                rptData.DataBind()
            End Using
        Catch ex As Exception
            lblQueryStatus.Text = ex.Message
            lblQueryStatus.CssClass = "status_error"
        End Try
    End Sub

    Private Function GetAuthors() As DataTable
        Dim cmd As New SqlCommand
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = CN_GetAuthors
        Dim dt As DataTable = ExecuteSelectCommand(cmd)
        Return dt
    End Function

End Class
