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

    public partial class GetAllRooms_Result
    {
        public int ID { get; set; }
        [Display(Name ="Room Number")]
        public int RoomNumber { get; set; }
        [Display(Name = "Room Type")]
        public string RoomType { get; set; }
        [Display(Name = "Bed Type")]
        public string BedType { get; set; }
        [Display(Name = "AC Type")]
        public string ACType { get; set; }
        [Display(Name = "Price Per Night")]
        public decimal Price { get; set; }
        public bool Enabled { get; set; }
    }
}