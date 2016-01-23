Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.UI.WebControls
Imports KDPSalesReports.Configuration
Imports KDPSalesReports.SqlDataAccess
Imports KDPSalesReports.StoredProcedures

Partial Class controls_QueryTotalRoyaltiesByAuthorControl
    Inherits System.Web.UI.UserControl

    Private Sub btnRunQuery_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRunQuery.Click
        pnlData.Visible = True
        Try
            Using cnn As New SqlConnection(DbConnectionString)
                cnn.Open()
                Dim cmd As New SqlCommand
                cmd.Connection = cnn
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandText = CN_TotalRoyaltiesByAuthor
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

End Class
