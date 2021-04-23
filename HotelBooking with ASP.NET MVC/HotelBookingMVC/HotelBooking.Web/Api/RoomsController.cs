using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HotelBooking.Web.Api
{
    public class RoomsController : ApiController
    {
        HotelBookingMVCContext db = new HotelBookingMVCContext();
        //private readonly IRoomData db;
        //public RoomsController(IRoomData db) {
        //    this.db = db;
        //}
        public IEnumerable<object> Get() {
            var model = db.GetAllRooms();
            return model;
        }
    }
}
