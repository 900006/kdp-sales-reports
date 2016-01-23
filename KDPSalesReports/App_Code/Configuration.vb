Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.Common

Namespace KDPSalesReports

    Public NotInheritable Class Configuration

        'Returns the database connection string
        Public Shared ReadOnly Property DbConnectionString() As String

            ' Development environment
            Get
                Dim bldr As New SqlConnectionStringBuilder()
                bldr.DataSource = "********\SQLServer2008"
                bldr.InitialCatalog = "KDPSalesReports"
                bldr.PersistSecurityInfo = False
                bldr.UserID = "********"
                bldr.Password = "********"
                bldr.Pooling = False
                Return bldr.ConnectionString
            End Get

            ' Production environment
            'Get
            '    Dim bldr As New SqlConnectionStringBuilder()
            '    bldr.DataSource = "********.database.windows.net"
            '    bldr.InitialCatalog = "********"
            '    bldr.PersistSecurityInfo = False
            '    bldr.UserID = "********"
            '    bldr.Password = "********"
            '    bldr.Pooling = False
            '    Return bldr.ConnectionString
            'End Get
        End Property

    End Class

End Namespace


