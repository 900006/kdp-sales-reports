<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryRoyaltiesFromNonUSMarketsControl.ascx.vb" Inherits="controls_QueryRoyaltiesFromNonUSMarketsControl" %>
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Year</td>
                <td class="heading">Marketplace</td>
                <td class="heading">Total Royalties</td>
                <td class="heading" align="right">Currency</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("Year")%></td>
                <td><%# Eval("Marketplace")%></td>
                <td><%# Eval("TotalRoyalties", "{0:f2}")%></td>
                <td align="right"><%# Eval("Currency")%></td>                
            </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
            <tr>
                <td class="alternating"><%# Eval("Year")%></td>
                <td class="alternating"><%# Eval("Marketplace")%></td>
                <td class="alternating"><%# Eval("TotalRoyalties", "{0:f2}")%></td>
                <td class="alternating" align="right"><%# Eval("Currency")%></td>                
            </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>