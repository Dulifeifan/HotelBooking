<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddNewRoom.aspx.cs" Inherits="HotelBooking.Admin.AddNewRoom" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Add A New Room:</h1>
    <div style="margin-bottom: 20px;"></div>
    <div style="margin:auto; text-align:center;">

        RoomNumber:&nbsp;
        <asp:TextBox ID="TextBox1"  runat="server" TextMode="Number"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Please Input One RoomNumber">*</asp:RequiredFieldValidator>
&nbsp;<asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Enter a 4 digit number" MaximumValue="9999" MinimumValue="1000" Type="Integer">*</asp:RangeValidator>
        &nbsp; HasAC:&nbsp;
        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" DataTextField="HasAC" DataValueField="HasAC">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [HasAC] FROM [Rooms]"></asp:SqlDataSource>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="DropDownList1" ErrorMessage="Please Select HasAC">*</asp:RequiredFieldValidator>
&nbsp;&nbsp;&nbsp; RoomType:&nbsp;
        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList2" runat="server" DataSourceID="SqlDataSource2" DataTextField="RoomType" DataValueField="RoomType">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [RoomType] FROM [Rooms]"></asp:SqlDataSource>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DropDownList2" ErrorMessage="Please Select RoomType">*</asp:RequiredFieldValidator>
&nbsp;<br />
        <br />
        <br />
        BedType:&nbsp;
        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList3" runat="server" DataSourceID="SqlDataSource3" DataTextField="BedType" DataValueField="BedType">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [BedType] FROM [Rooms]"></asp:SqlDataSource>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="DropDownList3" ErrorMessage="Please Select BedType">*</asp:RequiredFieldValidator>
&nbsp;&nbsp;&nbsp; Price:&nbsp;
        <asp:TextBox ID="TextBox2" runat="server" TextMode="Number"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="TextBox2" ErrorMessage="Please Input A Price">*</asp:RequiredFieldValidator>
        <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter a number between 1 and 9999" MaximumValue="9999" MinimumValue="1" Type="Integer">*</asp:RangeValidator>
&nbsp;&nbsp; Enabled:
        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList4" runat="server" DataSourceID="SqlDataSource4" DataTextField="Enabled" DataValueField="Enabled">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [Enabled] FROM [Rooms]"></asp:SqlDataSource>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="DropDownList4" ErrorMessage="Please Select Enabled">*</asp:RequiredFieldValidator>
        <br />
        <br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <div style="margin: auto; width: auto; font-size: 14px; margin-bottom: 10px; text-align: center;">
            <asp:Label ID="Notification" runat="server"></asp:Label>
        </div>
        <br />
        <asp:Button class="btn btn-default" ID="Button2" runat="server" OnClick="Button2_Click" Text="Add" />
        <br />

    </div>
</asp:Content>
