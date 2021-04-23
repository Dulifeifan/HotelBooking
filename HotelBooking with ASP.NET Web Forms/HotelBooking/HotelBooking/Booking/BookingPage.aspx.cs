using HotelBooking.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Web;
using System.Web.UI.WebControls;

namespace HotelBooking {
    public partial class BookingPage : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {
           
        }
        protected void valDateRange_ServerValidate(object source, ServerValidateEventArgs args) {
            DateTime minDate = DateTime.Now.Date;
            DateTime maxDate = DateTime.Parse("9999/12/28");
            DateTime dt;

            args.IsValid = (DateTime.TryParse(args.Value, out dt)
                            && dt <= maxDate
                            && dt >= minDate);
        }

        protected void OrderButton_Click(object sender, EventArgs e) {
            Page.Validate();
            if (!Page.IsValid) {
                return;
            }
            HotelBookingRepository r = new HotelBookingRepository();
            if (GridView1.SelectedDataKey == null) {
                Notification.Text = "Please Select Your Room To Book";
                return;
            }
            DateTime st = DateTime.Parse(startDate.Text);
            DateTime en = DateTime.Parse(endDate.Text);
            //ApplicationUser us = System.Web.HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>().FindById(System.Web.HttpContext.Current.User.Identity.GetUserId());
            string usId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            Room ro = r.GetRoomById(Int32.Parse(GridView1.SelectedDataKey.Value.ToString()));
            int roId = Int32.Parse(GridView1.SelectedDataKey.Value.ToString());
            int price = ro.Price * (en - st).Days;

            int res = r.MakeANewBooking(usId, roId, st, en, price);
            if(res == 1) {
                Notification.Text = "Order Failed. Please Check The Info Above.";
            }
            else {
                Notification.Text = "Order Success";
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e) {
            HotelBookingRepository r = new HotelBookingRepository();
            DateTime st = DateTime.Parse(startDate.Text);
            DateTime en = DateTime.Parse(endDate.Text);
            Room ro = r.GetRoomById(Int32.Parse(GridView1.SelectedDataKey.Value.ToString()));
            int price = ro.Price * (en - st).Days;
            Notification.Text = "Total Price is $" + price;
        }

        protected void Button1_Click(object sender, EventArgs e) {
            Page.Validate();
            if (Page.IsValid) {
                GridView1.Visible = true;
                OrderButton.Visible = true;
                Notification.Visible = true;
            }  
        }
    }
}