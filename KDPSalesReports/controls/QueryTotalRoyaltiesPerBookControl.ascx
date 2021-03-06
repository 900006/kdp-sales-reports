﻿<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryTotalRoyaltiesPerBookControl.ascx.vb" Inherits="controls_QueryTotalRoyaltiesPerBookControl" %>
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Title</td>
                <td class="heading">Author Name</td>
                <td class="heading" align="right">Total Royalties (USD)</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("Title")%></td>
                <td><%# Eval("AuthorName")%></td>
                <td align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
            <tr>
                <td class="alternating"><%# Eval("Title")%></td>
                <td class="alternating"><%# Eval("AuthorName")%></td>
                <td class="alternating" align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>