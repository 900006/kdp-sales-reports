<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryRefundRatesControl.ascx.vb" Inherits="controls_QueryRefundRatesControl" %>
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Title</td>
                <td class="heading">Author Name</td>
                <td class="heading" align="center">Units Sold (A)</td>
                <td class="heading" align="center">Units Refunded (B)</td>
                <td class="heading" align="center">Refund Rate (B/A)</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("Title")%></td>
                <td><%# Eval("AuthorName")%></td>
                <td align="center"><%# Eval("UnitsSold")%></td>
                <td align="center"><%# Eval("UnitsRefunded")%></td>
                <td align="center"><%# Eval("RefundRate")%></td>
            </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
            <tr>
                <td class="alternating"><%# Eval("Title")%></td>
                <td class="alternating"><%# Eval("AuthorName")%></td>
                <td class="alternating" align="center"><%# Eval("UnitsSold")%></td>
                <td class="alternating" align="center"><%# Eval("UnitsRefunded")%></td>
                <td class="alternating" align="center"><%# Eval("RefundRate")%></td>
            </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>