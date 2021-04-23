using HotelBooking.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HotelBooking.Admin {
    public partial class ManagerPage : System.Web.UI.Page {
        HotelBookingRepository h = new HotelBookingRepository();

        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void Button3_Click(object sender, EventArgs e) {
            DateTime searchDay;
            if (date.Text == null || date.Text.Equals("")) {
                searchDay = DateTime.Now.Date;
                date.Text = DateTime.Now.Date.ToShortDateString();
            }
            else {
                searchDay = DateTime.Parse(date.Text);
            }
            var res = h.GetNumbersOfBookedRoom(searchDay);
            Label1.Text = $"Available: {res[3]}, Booked: {res[2]}, Disabled: {res[1]}";
        }
    }
}