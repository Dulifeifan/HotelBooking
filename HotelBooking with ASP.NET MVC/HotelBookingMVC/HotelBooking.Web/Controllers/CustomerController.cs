using HotelBooking.Data;
using HotelBooking.Web.Models;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HotelBooking.Web.Controllers {
    [Authorize]
    public class CustomerController : Controller {
        HotelBookingMVCContext db = new HotelBookingMVCContext();

        [HttpGet]
        public ActionResult Index() {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(FilterRoomModel f) {
            if (f.StartDate < DateTime.Now.Date) {
                ModelState.AddModelError(nameof(f.StartDate),
                    "Start date must be no earlier than today.");
            }
            if (f.EndDate <= f.StartDate) {
                ModelState.AddModelError(nameof(f.EndDate),
                    "End date must be later than start date.");
            }
            if (ModelState.IsValid) {
                return RedirectToAction("RoomList", f);
            }
            return View(f);
        }
        [HttpGet]
        public ActionResult RoomList(FilterRoomModel f) {
            int mode = 0;
            if (f.roomType != null) {
                mode += 1000;
            }
            if (f.bedType != null) {
                mode += 100;
            }
            if (f.acType != null) {
                mode += 10;
            }
            // Enabled Room
            mode += 1;
            if (f.StartDate < DateTime.Parse("01/01/1990")) {
                f.StartDate = DateTime.Now.Date;
            }
            if (f.EndDate < DateTime.Parse("01/01/1990")) {
                f.EndDate = DateTime.Now.Date.AddDays(1);
            }
            TempData["StartDate"] = f.StartDate;
            TempData["EndDate"] = f.EndDate;
            var model = db.GetGroupedFilteredRoomsByModeAndDate(mode, f.roomType, f.bedType, f.acType, true, f.StartDate, f.EndDate);

            return View(model.ToList());
        }
        [HttpGet]
        public ActionResult MakeANewOrder(FilterRoomModelForBooking fb) {
            return View(fb);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult MakeANewOrder(FilterRoomModelForBooking fb, FormCollection form) {
            if (fb.roomType == null || fb.bedType == null || fb.acType == null || fb.price < 0) {
                ModelState.AddModelError(nameof(fb.roomType),
                   "Select one room to order");
            }
            if (ModelState.IsValid) {
                var roomList = db.GetRoomsByDetails(fb.roomType, fb.bedType, fb.acType, true, fb.StartDate, fb.EndDate, fb.price).ToList();
                if (roomList.Count() > 0) {
                    var roomId = roomList[0].ID;
                    var userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
                    var totalPrice = (decimal)((float)fb.price * (fb.EndDate - fb.StartDate).TotalDays);
                    db.AddABooking(fb.StartDate, fb.EndDate, roomId, userId, totalPrice);

                    return RedirectToAction("Orders");
                }
            }
            return RedirectToAction("RoomList", new FilterRoomModel {
                roomType = fb.roomType,
                bedType = fb.bedType,
                acType = fb.acType,
                StartDate = fb.StartDate,
                EndDate = fb.EndDate
            });

        }
        
        [HttpGet]
        public ActionResult Orders() {
            return View();
        }
        [HttpGet]
        public ActionResult PastOrders() {
            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            var model = db.GetPastBookingsOfOneUser(userId).ToList();
            model.ForEach(m => {
                m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
            });
            return View(model);
        }
        [HttpGet]
        public ActionResult CurrentOrders() {
            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            var model = db.GetCurrentBookingsOfOneUser(userId).ToList();
            model.ForEach(m => {
                m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
            });
            return View(model);
        }
        [HttpGet]
        public ActionResult FutureOrders() {
            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            var model = db.GetFutureBookingsOfOneUser(userId).ToList();
            model.ForEach(m => {
                m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
            });
            return View(model);
        }
        [HttpGet]
        public ActionResult DeleteOrder(int ID) {
            var model = db.GetBookingByID(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            model.BookedRoomNumber = db.GetRoomById(model.BookedRoomID).FirstOrDefault().RoomNumber;
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteOrder(int ID, FormCollection form) {
            db.DeleteABooking(ID);
            return RedirectToAction("FutureOrders");
        }

    }
}