using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HotelBooking.Web.Models {
    public class AdminViewModels {
    }
    public class FormatedUser {
        public string Id { get; set; }
        [Display(Name= "User Name"),Required]
        [DataType(DataType.EmailAddress)]
        public string UserName { get; set; }
        [Display(Name = "Password"),Required]
        
        [RegularExpression(@"(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}")]
        public string PasswordHash { get; set; }
        public bool Admin { get; set; }
    }
    public class RoomStatus {
        [DataType(DataType.Date), Required]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime Date { get; set; }
        public int AvailableRoom { get; set; }
        public int BookedRoom { get; set; }
        public int DisabledRoom { get; set; }
    }
    
}