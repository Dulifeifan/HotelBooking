using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HotelBooking.Web.Models {
    public class GreetingViewModel {
        public IEnumerable<Room> Rooms { get; set; }
        public string Message { get; set; }
        public string Name { get; set; }
    }
}