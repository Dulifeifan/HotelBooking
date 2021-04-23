using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HotelBooking.Models {
    public class Booking {
        public int ID { get; set; }
        public Room BookedRoom { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int TotalPrice { get; set; }
        public ApplicationUser BookedUser { get; set; }
    }
    public class FormatedBooking {
        public int ID { get; set; }
        public Room BookedRoom { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string StartDateStr { get; set; }
        public string EndDateStr { get; set; }
        public int TotalPrice { get; set; }
        public ApplicationUser BookedUser { get; set; }
        public int RoomNumber { get; set; }
        public string BookedUserID { get; set; }
    }
}