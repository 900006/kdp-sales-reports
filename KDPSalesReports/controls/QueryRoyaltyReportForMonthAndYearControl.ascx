<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryRoyaltyReportForMonthAndYearControl.ascx.vb" Inherits="controls_QueryRoyaltyReportForMonthAndYearControl" %>
<asp:DropDownList ID="ddlYears" runat="server" CssClass="aspnet_dropdownlist" AutoPostBack="true"></asp:DropDownList>&nbsp;&nbsp;<asp:DropDownList ID="ddlMonths" runat="server" CssClass="aspnet_dropdownlist" AutoPostBack="true"></asp:DropDownList><br /><br />
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Date</td>
                <td class="heading">Title</td>
                <td class="heading">Author</td>
                <td class="heading">ASIN</td>
                <td class="heading">Amazon</td>
                <td class="heading">Type</td>
                <td class="heading">Net</td>
                <td class="heading">Royalty</td>
                <td class="heading">Total</td>
                <td class="heading" align="right">Currency</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("RoyaltyDate", "{0:M-dd-yyyy}")%></td>
                <td><%# Eval("Title")%></td>
                <td><%# Eval("AuthorName")%></td>
                <td><%# Eval("ASIN")%></td>
                <td><%# Eval("Marketplace").ToString().Replace("Amazon", String.Empty)%></td>
                <td><%# Eval("TransactionType")%></td>
                <td><%# Eval("NetUnitsSold")%></td>
                <td><%# Eval("Royalty", "{0:f2}")%></td>
                <td><%# Eval("TotalRoyalties", "{0:f2}")%></td>
                <td align="right"><%# Eval("Currency")%></td>                
            </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
            <tr>
                <td class="alternating"><%# Eval("RoyaltyDate", "{0:M-dd-yyyy}")%></td>
                <td class="alternating"><%# Eval("Title")%></td>
                <td class="alternating"><%# Eval("AuthorName")%></td>
                <td class="alternating"><%# Eval("ASIN")%></td>
                <td class="alternating"><%# Eval("Marketplace").ToString().Replace("Amazon", String.Empty)%></td>
                <td class="alternating"><%# Eval("TransactionType")%></td>
                <td class="alternating"><%# Eval("NetUnitsSold")%></td>
                <td class="alternating"><%# Eval("Royalty", "{0:f2}")%></td>
                <td class="alternating"><%# Eval("TotalRoyalties", "{0:f2}")%></td>
                <td class="alternating" align="right"><%# Eval("Currency")%></td>                
            </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>