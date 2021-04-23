using HotelBooking.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HotelBooking.Admin {
    public partial class AddNewRoom : System.Web.UI.Page {
        HotelBookingRepository h = new HotelBookingRepository();
        protected void Page_Load(object sender, EventArgs e) {

        }
        protected void Button2_Click(object sender, EventArgs e) {
            Page.Validate();
            if (Page.IsValid) {

                int roomNumber = Int32.Parse(TextBox1.Text);
                bool hasAC = DropDownList1.Text.Equals("true");
                
                string roomType = DropDownList2.SelectedValue;
                string bedType = DropDownList3.SelectedValue;
                int price = Int32.Parse(TextBox2.Text);
                bool enabled = DropDownList4.Text.Equals("true");
                
                int res = h.AddANewRoom(roomNumber, hasAC, roomType, bedType, price, enabled);
                if(res == 1) {
                    Notification.Text = "Something Went Wrong";
                }
                else {
                    Notification.Text = "Add Success";
                }
            }
        }
    }
}