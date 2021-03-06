//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HotelBooking.Data
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public partial class GetBookingByID_Result
    {
        public int ID { get; set; }
        [Display(Name = "Start Date")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)] 
        [Required]
        public System.DateTime StartDate { get; set; }
        [Display(Name = "End Date")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)] 
        [Required]
        public System.DateTime EndDate { get; set; }
        public int BookedRoomID { get; set; }
        public string BookedUserID { get; set; }
        [Display(Name = "User Name"),Required]
        public string BookedUserName { get; set; }
        [Display(Name = "Total Price"), Required,Range(1, 999999999)]
        public decimal TotalPrice { get; set; }
        [Display(Name = "Room Number"),Required, Range(1000, 9999)]
        public int BookedRoomNumber { get; set; }
    }
}
