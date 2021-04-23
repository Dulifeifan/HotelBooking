<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddNewBooking.aspx.cs" Inherits="HotelBooking.Admin.AddNewBooking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <h1>Booking Page</h1>
    <div style="margin-bottom: 20px;"></div>
    <div style="font-size: 20px; margin-bottom: 10px;">
        Select The Booking Dates:
    </div>
    <div style="margin: auto; text-align: center;">
        Start Date: 
        <asp:TextBox ID="startDate" runat="server" CssClass="datepicker-field"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="startDate" ErrorMessage="Please Pick A Start Date" ForeColor="Black">*</asp:RequiredFieldValidator>
        <asp:CustomValidator runat="server" ID="RangeValidator1" ControlToValidate="startDate" OnServerValidate="valDateRange_ServerValidate" ErrorMessage="Start Date Must Be No Earlier Than Today">*</asp:CustomValidator>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; End Date: 
        <asp:TextBox ID="endDate" runat="server" CssClass="datepicker-field "></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="endDate" ErrorMessage="Please Pick A End Date">*</asp:RequiredFieldValidator>
        &nbsp;<asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="startDate" ControlToValidate="endDate" ErrorMessage="End Date Must Be Later Than Start Date" Operator="GreaterThan" Type="Date">*</asp:CompareValidator>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        

        

    </div>

    <div>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" Style="margin: auto; margin-top: 20px; text-align: center;" />
        <div style="font-size: 20px; margin-bottom: 10px;">
            <br />
            Filter Room Type:
        </div>

        <div style="margin: auto; text-align: center;">
            Has AC:&nbsp; 
        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="HasAC" runat="server" DataSourceID="SqlDataSource2" DataTextField="HasAC" DataValueField="HasAC"></asp:DropDownList>



            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Room Type:
            <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="RoomType" runat="server" DataSourceID="SqlDataSource3" DataTextField="RoomType" DataValueField="RoomType">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bed Type:
            <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="BedType" runat="server" DataSourceID="SqlDataSource4" DataTextField="BedType" DataValueField="BedType">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [BedType] FROM [Rooms]"></asp:SqlDataSource>
            &nbsp;<asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [RoomType] FROM [Rooms]"></asp:SqlDataSource>
            &nbsp;<asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [HasAC] FROM [Rooms]"></asp:SqlDataSource>
            <asp:Button class="btn btn-default" ID="Button1" runat="server" Text="Search" OnClick="Button1_Click" />


        </div>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataSourceID="ObjectDataSource1" Style="margin: auto;" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" Width="823px" DataKeyNames="ID" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Visible="False">
            <Columns>
                <asp:CommandField ShowSelectButton="True" />
                <asp:BoundField DataField="HasAC" HeaderText="HasAC" SortExpression="HasAC" />
                <asp:BoundField DataField="RoomType" HeaderText="RoomType" SortExpression="RoomType" />
                <asp:BoundField DataField="BedType" HeaderText="BedType" SortExpression="BedType" />
                <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />
        </asp:GridView>
        <br />
        <br />
        <div  style="font-size: 20px;margin-bottom:10px;" >
            <br />
        To Whom:</div>
        <div style="margin: auto; text-align:center;">
            <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList1" runat="server" DataSourceID="SqlDataSource5" DataTextField="UserName" DataValueField="UserName"></asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [UserName] FROM [AspNetUsers]"></asp:SqlDataSource>
        </div>
        

        <div style="margin:auto; text-align:center;">
        <br />
        <div style="margin: auto; width: auto; font-size: 14px; margin-bottom: 10px; text-align: center;">
            <asp:Label ID="Notification" runat="server" Visible="False"></asp:Label>
        </div>
        <div style="margin: auto; width: auto; text-align: center;">
            <asp:Button class="btn btn-default" ID="OrderButton" runat="server" OnClick="OrderButton_Click" Text="Order" Visible="False" />
        </div>


        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT * FROM [Rooms] WHERE ([ID] = @ID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="ID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <br />



        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetAllValidRoomByDatesAndTypes" TypeName="HotelBooking.Models.HotelBookingRepository">
            <SelectParameters>
                <asp:ControlParameter ControlID="startDate" DefaultValue="" Name="startDate" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="endDate" DefaultValue="" Name="endDate" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="HasAC" Name="hasAc" PropertyName="SelectedValue" Type="Boolean" />
                <asp:ControlParameter ControlID="RoomType" Name="roomType" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="BedType" Name="bedType" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('.datepicker-field').datepicker();
        });
    </script>
    </div>
</asp:Content>
