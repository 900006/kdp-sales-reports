<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryTotalRoyaltiesPerYearControl.ascx.vb" Inherits="controls_QueryTotalRoyaltiesPerYearControl" %>
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Year</td>
                <td class="heading" align="right">Total Royalties (USD)</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("Year")%></td>
                <td align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
            <tr>
                <td class="alternating"><%# Eval("Year")%></td>
                <td class="alternating" align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>