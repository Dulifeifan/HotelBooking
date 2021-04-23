using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HotelBooking.Models {
    public class Room {
        public int ID { get; set; }
        public int RoomNumber { get; set; }
        public bool HasAC { get; set; } 
        public string RoomType { get; set; }
        public string BedType { get; set; }
        public int Price { get; set; }
        public bool Enabled { get; set; } 
    }
}