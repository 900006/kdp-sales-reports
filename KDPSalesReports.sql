USE [KDPSalesReports]
GO
/****** Object:  Table [dbo].[BookSales]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BookSales](
	[SaleID] [int] IDENTITY(1,1) NOT NULL,
	[RoyaltyDate] [date] NOT NULL,
	[Title] [nvarchar](300) NOT NULL,
	[AuthorName] [nvarchar](50) NOT NULL,
	[ASIN] [char](10) NOT NULL,
	[Marketplace] [varchar](25) NOT NULL,
	[RoyaltyType] [varchar](10) NOT NULL,
	[TransactionType] [varchar](25) NOT NULL,
	[UnitsSold] [int] NOT NULL,
	[UnitsRefunded] [int] NOT NULL,
	[RefundRate] [decimal](3, 2) NOT NULL,
	[NetUnitsSold] [int] NOT NULL,
	[AvgListPriceWithoutTax] [smallmoney] NOT NULL,
	[AvgFileSizeMB] [decimal](5, 2) NOT NULL,
	[AvgOfferPriceWithoutTax] [smallmoney] NOT NULL,
	[AvgDeliveryCost] [smallmoney] NOT NULL,
	[Royalty] [smallmoney] NOT NULL,
	[Currency] [char](3) NOT NULL,
 CONSTRAINT [PK_BookSales] PRIMARY KEY CLUSTERED 
(
	[SaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[procAuthorsRankedByTotalRoyalties]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procAuthorsRankedByTotalRoyalties]
AS
SELECT IDENTITY(INT, 1, 1) AS [Rank], AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
INTO #tp
FROM BookSales
WHERE Currency = 'USD'
GROUP BY AuthorName
ORDER BY TotalRoyalties DESC;
SELECT * FROM #tp;
DROP TABLE #tp;
GO
/****** Object:  StoredProcedure [dbo].[procGetAuthors]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetAuthors]
AS
SELECT DISTINCT IDENTITY(INT, 0, 1) AS ValueField, AuthorName
INTO #tp
FROM BookSales
ORDER BY AuthorName;
SELECT * FROM #tp;
DROP TABLE #tp;
GO
/****** Object:  StoredProcedure [dbo].[procGetMonthsForYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetMonthsForYear]
(
@Year INT
)
AS
SELECT DISTINCT IDENTITY(INT, 0, 1) AS ValueField, MONTH(RoyaltyDate) AS [Month]
INTO #tp
FROM BookSales
WHERE YEAR(RoyaltyDate) = @Year
ORDER BY [Month];
SELECT * FROM #tp;
DROP TABLE #tp;
GO
/****** Object:  StoredProcedure [dbo].[procGetYears]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetYears] 
AS
SELECT DISTINCT IDENTITY(INT, 0, 1) AS [ValueField], YEAR(RoyaltyDate) AS [Year]
INTO #tp
FROM BookSales;
SELECT * FROM #tp;
DROP TABLE #tp;
GO
/****** Object:  StoredProcedure [dbo].[procRefundRates]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRefundRates]
AS
SELECT Title, AuthorName, UnitsSold, UnitsRefunded, RefundRate
FROM BookSales
WHERE RefundRate > 0
ORDER BY RefundRate DESC;
GO
/****** Object:  StoredProcedure [dbo].[procRemoveDuplicates]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRemoveDuplicates]
AS
WITH BookSales_CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY RoyaltyDate, Title, AuthorName ORDER BY RoyaltyDate) AS NumRecords
	FROM BookSales
)
DELETE FROM BookSales_CTE WHERE NumRecords > 1;

GO
/****** Object:  StoredProcedure [dbo].[procRoyaltiesForMonthAndYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRoyaltiesForMonthAndYear]
(
@MonthNumber INT,
@Year INT
)
AS
SELECT @MonthNumber As [Month], @Year AS [Year], SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE MONTH(RoyaltyDate) = @MonthNumber AND YEAR(RoyaltyDate) = @Year AND Currency = 'USD';
GO
/****** Object:  StoredProcedure [dbo].[procRoyaltiesFromNonUSMarkets]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRoyaltiesFromNonUSMarkets]
AS
SELECT DISTINCT YEAR(RoyaltyDate) AS [Year], Marketplace, Currency, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency <> 'USD'
GROUP BY YEAR(RoyaltyDate), Marketplace, Currency
ORDER BY [Year] DESC, Marketplace;
GO
/****** Object:  StoredProcedure [dbo].[procRoyaltiesPerMonthOfYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRoyaltiesPerMonthOfYear]
(
@Year INT
)
AS
SELECT MONTH(RoyaltyDate) AS [Month], @Year AS [Year], SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD' AND YEAR(RoyaltyDate) = @Year
GROUP BY MONTH(RoyaltyDate)
ORDER BY [Month];
GO
/****** Object:  StoredProcedure [dbo].[procRoyaltyReportForMonthAndYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procRoyaltyReportForMonthAndYear]
(
@MonthNumber INT,
@Year INT
)
AS
SELECT RoyaltyDate, Title, AuthorName, [ASIN], Marketplace, RoyaltyType, TransactionType, NetUnitsSold, Royalty, (NetUnitsSold * Royalty) AS TotalRoyalties, Currency
FROM BookSales
WHERE MONTH(RoyaltyDate) = @MonthNumber AND YEAR(RoyaltyDate) = @Year
ORDER BY RoyaltyDate;
GO
/****** Object:  StoredProcedure [dbo].[procTop10BestSellersByDate]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop10BestSellersByDate]
(
@RoyaltyDate DATE
)
AS
SELECT TOP 10 Title, NetUnitsSold, (NetUnitsSold * Royalty) AS Royalties
FROM BookSales
WHERE RoyaltyDate = @RoyaltyDate AND TransactionType = 'Standard'
ORDER BY NetUnitsSold DESC;
GO
/****** Object:  StoredProcedure [dbo].[procTop10BestSellersByMonthYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop10BestSellersByMonthYear] 
(
@DateTimeValue DATETIME
)
AS
SELECT TOP 10 RoyaltyDate AS 'Royalty Date', Title, AuthorName AS 'Author', NetUnitsSold AS 'Net Units Sold', (NetUnitsSold * Royalty) AS Royalties
FROM BookSales
WHERE YEAR(RoyaltyDate) = YEAR(@DateTimeValue) AND MONTH(RoyaltyDate) = MONTH(@DateTimeValue) AND TransactionType = 'Standard'
ORDER BY NetUnitsSold DESC;
GO
/****** Object:  StoredProcedure [dbo].[procTop10HighestEarningAuthors]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop10HighestEarningAuthors]
AS
SELECT TOP 10 AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD'
GROUP BY AuthorName
ORDER BY TotalRoyalties DESC;
GO
/****** Object:  StoredProcedure [dbo].[procTop10HighestEarningBooksByYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop10HighestEarningBooksByYear]
(
@DateTimeValue DATETIME
)
AS
SELECT TOP 10 Title, AuthorName, (NetUnitsSold * Royalty) AS Royalties, Currency
FROM BookSales
WHERE YEAR(RoyaltyDate) = YEAR(@DateTimeValue)
ORDER BY Royalties DESC;
GO
/****** Object:  StoredProcedure [dbo].[procTop20WorstPerformingTitles]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop20WorstPerformingTitles]
AS
SELECT DISTINCT TOP 20 IDENTITY(INT, 1, 1) AS [Rank], Title, AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
INTO #tp
FROM BookSales
WHERE Currency = 'USD'
GROUP BY Title, AuthorName
ORDER BY TotalRoyalties;
SELECT * FROM #tp;
DROP TABLE #tp;
GO
/****** Object:  StoredProcedure [dbo].[procTop50HighestRefundRate]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTop50HighestRefundRate] 
AS
SELECT TOP 50 Title, AuthorName, UnitsSold, UnitsRefunded, RefundRate
FROM BookSales
WHERE RefundRate > 0
ORDER BY RefundRate DESC;
GO
/****** Object:  StoredProcedure [dbo].[procTotalRoyaltiesByAuthor]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTotalRoyaltiesByAuthor]
AS
SELECT AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD'
GROUP BY AuthorName
ORDER BY AuthorName;
GO
/****** Object:  StoredProcedure [dbo].[procTotalRoyaltiesOfAuthor]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTotalRoyaltiesOfAuthor]
(
@AuthorName NVARCHAR(50)
)
AS
SELECT @AuthorName AS AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD' AND AuthorName = @AuthorName;
GO
/****** Object:  StoredProcedure [dbo].[procTotalRoyaltiesPerBook]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTotalRoyaltiesPerBook] 
AS
SELECT DISTINCT Title, AuthorName, SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD'
GROUP BY Title, AuthorName;
GO
/****** Object:  StoredProcedure [dbo].[procTotalRoyaltiesPerYear]    Script Date: 1/23/2016 4:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTotalRoyaltiesPerYear]
AS
SELECT DISTINCT YEAR(RoyaltyDate) AS [Year], SUM(NetUnitsSold * Royalty) AS TotalRoyalties
FROM BookSales
WHERE Currency = 'USD'
GROUP BY YEAR(RoyaltyDate)
ORDER BY [Year] DESC;
GO
