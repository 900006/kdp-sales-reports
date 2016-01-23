Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports KDPSalesReports.Configuration

Namespace KDPSalesReports

    Public Class SqlDataAccess

        ''' <summary>
        ''' Executes a SELECT command and returns the results as a DataTable
        ''' </summary>
        ''' <param name="cmd"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Shared Function ExecuteSelectCommand(ByVal cmd As SqlCommand) As DataTable
            Dim dt As DataTable
            Using cnn As New SqlConnection(DbConnectionString)
                cnn.Open()
                cmd.Connection = cnn
                Dim rdr As SqlDataReader = cmd.ExecuteReader()
                dt = New DataTable
                dt.Load(rdr)
                rdr.Close()
            End Using
            Return dt
        End Function

    End Class

End Namespace


