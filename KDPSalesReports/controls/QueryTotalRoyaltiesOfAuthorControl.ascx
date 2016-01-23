<%@ Control Language="VB" AutoEventWireup="false" CodeFile="QueryTotalRoyaltiesOfAuthorControl.ascx.vb" Inherits="controls_QueryTotalRoyaltiesOfAuthorControl" %>
<asp:DropDownList ID="ddlAuthors" runat="server" CssClass="aspnet_dropdownlist"></asp:DropDownList><br /><br />
<asp:Button ID="btnRunQuery" runat="server" Text="Run Query" /> <asp:Label ID="lblQueryStatus" runat="server"></asp:Label><br /><br />
<asp:Panel ID="pnlData" runat="server" CssClass="data">
<asp:Repeater ID="rptData" runat="server">
    <HeaderTemplate>
        <table width="100%" cellspacing="0">
            <tr>
                <td class="heading">Author Name</td>
                <td class="heading" align="right">Total Royalties (USD)</td>
            </tr>  
    </HeaderTemplate>
    <ItemTemplate>
            <tr>
                <td><%# Eval("AuthorName")%></td>
                <td align="right"><%# Eval("TotalRoyalties", "{0:c}")%></td>
            </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
</asp:Panel>