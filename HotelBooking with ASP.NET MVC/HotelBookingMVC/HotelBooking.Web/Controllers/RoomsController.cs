using HotelBooking.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HotelBooking.Web.Controllers
{
    public class RoomsController : Controller {
        HotelBookingMVCContext db = new HotelBookingMVCContext();
        //private readonly IRoomData db;
        //public RoomsController(IRoomData db) {
        //    this.db = db;
        //}
        // GET: Rooms
        [HttpGet]
        public ActionResult Index() {
            var model = db.GetAllRooms();
            return View(model);
        }
        //[HttpGet]
        //public ActionResult Details(int id) {
        //    var model = db.GetRoomById(id);
        //    if (model == null) {
        //        //return RedirectToAction("Index");
        //        return View("NotFound");
        //    }
        //    return View(model);
        //}
        //[HttpGet]
        //public ActionResult Create() {
        //    return View();
        //}
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Create(Room room) {
        //    //if(room.RoomNumber<1000 || room.RoomNumber > 9999) {
        //    //    ModelState.AddModelError(nameof(room.RoomNumber), 
        //    //        "The room number needs a 4 digit number");
        //    //}
        //    if (room.Price < 1) {
        //        ModelState.AddModelError(nameof(room.Price),
        //            "The price needs a positive number");
        //    }
        //    if (ModelState.IsValid) {
        //        db.Add(room);
        //        return RedirectToAction("Details", new { id = room.Id });
        //    }
        //    return View();

        //}
        //[HttpGet]
        //public ActionResult Edit(int id) {
        //    var model = db.Get(id);
        //    if (model == null) {
        //        return HttpNotFound();
        //    }
        //    return View(model);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Edit(Room room) {
        //    //if(room.RoomNumber<1000 || room.RoomNumber > 9999) {
        //    //    ModelState.AddModelError(nameof(room.RoomNumber), 
        //    //        "The room number needs a 4 digit number");
        //    //}
        //    if (room.Price < 1) {
        //        ModelState.AddModelError(nameof(room.Price),
        //            "The price needs a positive number");
        //    }
        //    if (ModelState.IsValid) {
        //        db.Update(room);
        //        TempData["Message"] = "You have saved the room!";
        //        return RedirectToAction("Details", new { id = room.Id });
        //    }
        //    return View(room);
        //}

        //[HttpGet]
        //public ActionResult Delete(int id) {
        //    var model = db.Get(id);
        //    if (model == null) {
        //        return HttpNotFound();
        //    }
        //    return View(model);
        //}
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Delete(int id, FormCollection form) {
        //    db.Delete(id);
        //    return RedirectToAction("Index");
        //}
    }
}