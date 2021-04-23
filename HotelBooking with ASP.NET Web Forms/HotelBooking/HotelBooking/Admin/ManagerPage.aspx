<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManagerPage.aspx.cs" Inherits="HotelBooking.Admin.ManagerPage" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <h1>Manager Page</h1>
    <div style="margin-bottom: 20px;"></div>
    <div style="font-size: 20px; margin-bottom: 10px;">
        Users:
    </div>
    <div>
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataSourceID="ObjectDataSource1" ForeColor="Black" GridLines="Horizontal" Width="823px" Style="margin: auto;" AutoGenerateColumns="False" DataKeyNames="Id">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowSelectButton="True" />
                <asp:BoundField DataField="Id" HeaderText="Id" SortExpression="Id" Visible="False" />
                <asp:TemplateField HeaderText="User Name" SortExpression="UserName">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox2" CssClass="form-control" runat="server" Text='<%# Bind("UserName") %>' TextMode="Email" ForeColor="Black"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter a username">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter an email address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("UserName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Password" SortExpression="PasswordHash">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" type="Password" Text='<%# Bind("PasswordHash") %>'  CssClass="form-control"  ForeColor="Black" ></asp:TextBox>
                        
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TextBox1" ErrorMessage="Input a password">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Input a valid password" ValidationExpression="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}">*</asp:RegularExpressionValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <%--<asp:Label ID="Label1" runat="server" Text='<%# Eval("PasswordHash","****") %>'>****</asp:Label>--%>
                        <asp:Label ID="Label1" runat="server" Text="******"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CheckBoxField DataField="Admin" HeaderText="Admin" SortExpression="Admin" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />
        </asp:GridView>
        <br />
        <a href="AddNewUser.aspx">Add A New User ></a>
        <%--<div style="margin: auto; width: auto; font-size: 14px; margin-bottom: 10px; text-align: center;">
            <asp:Label ID="Notification" runat="server"></asp:Label>
        </div>
        <div style="margin: auto; width: auto; text-align: center;">
            <asp:Button class="btn btn-default" Style="margin: auto;" ID="Button1" runat="server" OnClick="Button1_Click" Text="Toggle Admin Role" />
        </div>--%>

        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetAllFormatedUsers" TypeName="HotelBooking.Models.HotelBookingRepository" DeleteMethod="RemoveUserById" UpdateMethod="UpdateUserById">
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Id" Type="String" />
                <asp:Parameter Name="UserName" Type="String" />
                <asp:Parameter Name="PasswordHash" Type="String" />
                <asp:Parameter Name="Admin" Type="Boolean" />
            </UpdateParameters>
        </asp:ObjectDataSource>

        <br />
        <br />
    </div>
    <div style="font-size: 20px; margin-bottom: 10px;">
        Bookings Of The Selected User:
    </div>
    <div>
        <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataSourceID="ObjectDataSource2" DataKeyNames="ID" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" Width="823px" Style="margin: auto;">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:TemplateField HeaderText="Booking ID" SortExpression="ID">
                    <EditItemTemplate>
                        <asp:Label ID="TextBox2" runat="server" ReadOnly="True" Text='<%# Bind("ID") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Start Date" SortExpression="StartDateStr">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1"  runat="server" Text='<%# Bind("StartDateStr") %>' cssclass="datepicker-field form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBox1" ErrorMessage="Enter a date">*</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("StartDateStr") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="End Date" SortExpression="EndDateStr">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox3"  runat="server" Text='<%# Bind("EndDateStr") %>' cssclass="datepicker-field form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="TextBox3" ErrorMessage="Enter a date">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="TextBox1" ControlToValidate="TextBox3" ErrorMessage="End date must be later than start date" Type="Date" Operator="GreaterThan">*</asp:CompareValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("EndDateStr") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total Price" SortExpression="TotalPrice">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox4" CssClass="form-control" runat="server" Text='<%# Bind("TotalPrice") %>' TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="TextBox4" ErrorMessage="Enter a number">*</asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator3" runat="server" ControlToValidate="TextBox4" ErrorMessage="Enter a number greater than 1" MaximumValue="9999999" MinimumValue="1" Type="Integer">*</asp:RangeValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("TotalPrice") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Room Number" SortExpression="RoomNumber">
                    <EditItemTemplate>
                        
                        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList3" runat="server" Text='<%# Bind("RoomNumber") %>' DataSourceID="SqlDataSource1" DataTextField="RoomNumber" DataValueField="RoomNumber">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [RoomNumber] FROM [Rooms]"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("RoomNumber") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />
        </asp:GridView>
        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" DeleteMethod="RemoveOneBookingById" SelectMethod="GetAllBookingsByUserName" TypeName="HotelBooking.Models.HotelBookingRepository" UpdateMethod="UpdateOneBookingById" >
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="Id" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ID" Type="Int32" />
                <asp:Parameter Name="StartDateStr" Type="String" />
                <asp:Parameter Name="EndDateStr" Type="String" />
                <asp:Parameter Name="TotalPrice" Type="Int32" />
                <asp:Parameter Name="RoomNumber" Type="Int32" />
            </UpdateParameters>
        </asp:ObjectDataSource>
        <br />
        <br />
        <br />
        <br />
    </div>
    <div style="font-size: 20px; margin-bottom: 10px;">
        Rooms:
    </div>
    <div>

        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSourceID="ObjectDataSource3" AllowPaging="True" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" Width="823px" Style="margin: auto;" DataKeyNames="ID" >
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:TemplateField HeaderText="Room Number" SortExpression="RoomNumber">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server" Text='<%# Bind("RoomNumber") %>' TextMode="Number"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Enter a 4 digit number" MaximumValue="9999" MinimumValue="1000" Type="Integer">*</asp:RangeValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Enter a number">*</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("RoomNumber") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CheckBoxField HeaderText="Has AC"  DataField="HasAC" SortExpression="HasAC"/>
                <asp:TemplateField HeaderText="Room Type" SortExpression="RoomType">
                    <EditItemTemplate>
                        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" Text='<%# Bind("RoomType") %>' DataTextField="RoomType" DataValueField="RoomType">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [RoomType] FROM [Rooms]"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("RoomType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Bed Type" SortExpression="BedType">
                    <EditItemTemplate>
                        <asp:DropDownList class="btn btn-secondary dropdown-toggle" ID="DropDownList2" Text='<%# Bind("BedType") %>' runat="server" DataSourceID="SqlDataSource2" DataTextField="BedType" DataValueField="BedType">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT DISTINCT [BedType] FROM [Rooms]"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("BedType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Price Per Night" SortExpression="Price">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox2" CssClass="form-control" runat="server" Text='<%# Bind("Price") %>' TextMode="Number"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter a number between 1 and 9999" MaximumValue="9999" MinimumValue="1" Type="Integer">*</asp:RangeValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter a number">*</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Price") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" SortExpression="Enabled" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />
        </asp:GridView>
        <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" DeleteMethod="RemoveOneRoomById" SelectMethod="GetAllRooms" TypeName="HotelBooking.Models.HotelBookingRepository" UpdateMethod="UpdateOneRoomById">
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="ID" Type="Int32" />
                <asp:Parameter Name="RoomNumber" Type="Int32" />
                <asp:Parameter Name="HasAC" Type="Boolean" />
                <asp:Parameter Name="RoomType" Type="String" />
                <asp:Parameter Name="BedType" Type="String" />
                <asp:Parameter Name="Price" Type="Int32" />
                <asp:Parameter Name="Enabled" Type="Boolean" />
            </UpdateParameters>
        </asp:ObjectDataSource>

        <br />
        <a href="AddNewRoom.aspx">Add A New Room ></a>
        <br />
        <br />
    </div>
    
    <div style="font-size: 20px; margin-bottom: 10px;">
        Room Status:
    </div>
    <div style="margin:auto; text-align:center;">
        <asp:TextBox ID="date"  runat="server" cssclass="datepicker-field form-control" Width="30%" style="margin:auto;"></asp:TextBox>
        
        <asp:Button class="btn btn-default" ID="Button3" runat="server" Text="Search" OnClick="Button3_Click"  />
        <br />
        <br />
        <div style="margin:auto;width:auto;font-size: 20px;margin-bottom:10px;text-align:center;">
            <asp:Label ID="Label1" runat="server"></asp:Label>
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" SelectMethod="GetAllBookings" TypeName="HotelBooking.Models.HotelBookingRepository"></asp:ObjectDataSource>
            <br />

            

            <br />
            
        </div>
        </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('.datepicker-field').datepicker();
        });
    </script>
</asp:Content>
