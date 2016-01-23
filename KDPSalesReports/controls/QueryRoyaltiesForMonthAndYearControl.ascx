<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryRoyaltiesForMonthAndYearControl.ascx.vb" Inherits="controls_QueryRoyaltiesForMonthAndYearControl" %>
<asp:DropDownList ID="ddlYears" runat="server" CssClass="aspnet_dropdownlist" AutoPostBack="true"></asp:DropDownList>&nbsp;&nbsp;<asp:DropDownList ID="ddlMonths" runat="server" CssClass="aspnet_dropdownlist" AutoPostBack="true"></asp:DropDownList><br /><br />
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Month</td>
                <td class="heading">Year</td>
                <td class="heading" align="right">Total Royalties (USD)</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("Month")%></td>
                <td><%# Eval("Year")%></td>
                <td align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>