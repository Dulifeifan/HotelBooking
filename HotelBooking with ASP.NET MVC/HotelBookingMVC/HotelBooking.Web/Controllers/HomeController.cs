using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HotelBooking.Web.Controllers {
    public class HomeController : Controller {
        HotelBookingMVCContext db = new HotelBookingMVCContext();
        //IRoomData db;
        //public HomeController(IRoomData db) {
        //    //db = new InMemoryRoomData();
        //    this.db = db;
        //}

        public ActionResult Index() {
            var model = db.GetAllRooms();
            return View(model);
        }

        public ActionResult About() {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact() {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}