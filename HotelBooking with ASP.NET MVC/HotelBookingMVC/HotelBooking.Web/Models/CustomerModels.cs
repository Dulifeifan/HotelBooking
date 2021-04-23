using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HotelBooking.Web.Models {
    public class CustomerModels {
        public IEnumerable<Room> FilteredRooms { get; set; }
        public IEnumerable<Booking> PastBookings { get; set; }
        public IEnumerable<Booking> CurrentBookings { get; set; }
        public IEnumerable<Booking> FutureBookings { get; set; }
    }
    public class FilterRoomModel {
        [Display(Name ="Room Type")]
        public string roomType { get; set; }
        [Display(Name = "Bed Type")]
        public string bedType { get; set; }
        [Display(Name = "AC Type")]
        public string acType { get; set; }
        [Required, Display(Name = "Start Date")]
        public DateTime StartDate { get; set; }
        [Required, Display(Name = "End Date")]
        public DateTime EndDate { get; set; }
    }
    public class FilterRoomModelForBooking {

        [Display(Name = "Room Type")]
        public string roomType { get; set; }
        [Display(Name = "Bed Type")]
        public string bedType { get; set; }
        [Display(Name = "AC Type")]
        public string acType { get; set; }
        [Display(Name = "Price Per Night")]
        public decimal price { get; set; }
        [Display(Name = "Start Date"), DisplayFormat(DataFormatString = "{0:MM/dd/yyyy}")]
        public DateTime StartDate { get; set; }
        [Display(Name = "End Date"), DisplayFormat(DataFormatString = "{0:MM/dd/yyyy}")]
        public DateTime EndDate { get; set; }
    }

}