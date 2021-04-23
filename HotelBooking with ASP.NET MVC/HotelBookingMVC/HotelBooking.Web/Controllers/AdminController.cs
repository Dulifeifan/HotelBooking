using HotelBooking.Data;
using HotelBooking.Web.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity.Owin;

namespace HotelBooking.Web.Controllers {
    [Authorize(Roles ="Admin")]
    public class AdminController : Controller {
        HotelBookingMVCContext db = new HotelBookingMVCContext();
        // GET: Admin
        [HttpGet]
        public ActionResult Index() {
            DateTime Date = DateTime.Now.Date;
            var model = new RoomStatus();
            if (Date == null || Date < DateTime.Parse("01/01/1900")) {
                ModelState.AddModelError(nameof(Date),
                   "Date is not valid.");
                model.Date = DateTime.Now.Date;
            }
            model.Date = Date;
            int all = db.GetAllRooms().ToList().Count;
            int disabled = db.GetFilteredRoomsByMode(0001, "", "", "", false).ToList().Count;
            int available = db.GetFilteredRoomsByModeAndDate(0001, "", "", "", true, Date, Date.AddDays(1)).ToList().Count();
            int booked = all - disabled - available;
            model.AvailableRoom = available;
            model.BookedRoom = booked;
            model.DisabledRoom = disabled;
            return View(model);
            
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index( DateTime? Date = null) {
            var model = new RoomStatus();
            if (Date==null||Date < DateTime.Parse("01/01/1900")) {
                ModelState.AddModelError(nameof(Date),
                   "Date is not valid. This is the result of today's date.");
                model.Date = DateTime.Now.Date;
            }
            DateTime d = Date ?? DateTime.Now.Date;
            model.Date = d;

            int all = db.GetAllRooms().ToList().Count;
            int disabled = db.GetFilteredRoomsByMode(0001, "", "", "", false).ToList().Count;
            int available = db.GetFilteredRoomsByModeAndDate(0001, "", "", "", true, d, d.AddDays(1)).ToList().Count();
            int booked = all - disabled - available;
            model.AvailableRoom = available;
            model.BookedRoom = booked;
            model.DisabledRoom = disabled;
            return View(model);
        }

        [HttpGet]
        public ActionResult Rooms() {
            var model = db.GetAllRooms().ToList();
            return View(model);
        }
        [HttpGet]
        public ActionResult EditOneRoom(int ID) {
            var model = db.GetRoomById(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditOneRoom(GetRoomById_Result room) {
            if (!RoomNumberIsValidWhenEditing(room.RoomNumber, room.ID)) {
                ModelState.AddModelError(nameof(room.RoomNumber),
                   "Room number is used.");
            }
            if (ModelState.IsValid) {
                db.UpdateARoom(room.ID, room.RoomNumber, room.RoomType, room.BedType, room.ACType, room.Price, room.Enabled);
                return RedirectToAction("Rooms");
            }
            return View(room);
        }

        [HttpGet]
        public ActionResult CreateOneRoom() {

            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateOneRoom(GetRoomById_Result room) {
            if (!RoomNumberIsValidWhenAdding(room.RoomNumber)) {
                ModelState.AddModelError(nameof(room.RoomNumber),
                   "Room number is used.");
            }
            if (ModelState.IsValid) {
                db.AddANewRoom(room.RoomNumber, room.RoomType, room.BedType, room.ACType, room.Price, room.Enabled);
                return RedirectToAction("Rooms");
            }
            return View();
        }

        [HttpGet]
        public ActionResult DeleteOneRoom(int ID) {
            var model = db.GetRoomById(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteOneRoom(int ID, FormCollection form) {
            var model = db.GetRoomById(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            db.GetAllBookings().ToList().ForEach(b => {
                if (b.BookedRoomID == ID) {
                    db.DeleteABooking(b.ID);
                }
            });
            db.DeleteARoom(ID);
            return RedirectToAction("Rooms");

        }

        public bool RoomNumberIsValidWhenEditing(int roomNumber, int ID) {
            var l = db.GetAllRooms().ToList();
            for (int i = 0; i < l.Count; i++) {
                if (l[i].RoomNumber == roomNumber) {
                    if (l[i].ID != ID) {
                        return false;
                    }
                }
            }
            return true;
        }
        public bool RoomNumberIsValidWhenAdding(int roomNumber) {
            var l = db.GetAllRooms().ToList();
            for (int i = 0; i < l.Count; i++) {
                if (l[i].RoomNumber == roomNumber) {

                    return false;

                }
            }
            return true;
        }



        [HttpGet]
        public ActionResult Orders() {

            return View();
        }
        [HttpGet]
        public ActionResult PastOrders() {
            var model = db.GetAllPastBookings().ToList();
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.ForEach(m => {
                    m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
                    m.BookedUserName = um.FindById(m.BookedUserID).UserName;
                });
            }
            return View(model);
        }
        [HttpGet]
        public ActionResult CurrentOrders() {
            var model = db.GetAllCurrentBookings().ToList();
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.ForEach(m => {
                    m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
                    m.BookedUserName = um.FindById(m.BookedUserID).UserName;
                });
            }
            return View(model);
        }
        [HttpGet]
        public ActionResult FutureOrders() {
            var model = db.GetAllFutureBookings().ToList();
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.ForEach(m => {
                    m.BookedRoomNumber = db.GetRoomById(m.BookedRoomID).FirstOrDefault().RoomNumber;
                    m.BookedUserName = um.FindById(m.BookedUserID).UserName;
                });
            }
            return View(model);
        }
        [HttpGet]
        public ActionResult EditCurrentOrder(int ID) {
            var model = db.GetBookingByID(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            model.BookedRoomNumber = db.GetRoomById(model.BookedRoomID).FirstOrDefault().RoomNumber;
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.BookedUserName = um.FindById(model.BookedUserID).UserName;
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditCurrentOrder(GetBookingByID_Result booking) {
            if (booking.EndDate < DateTime.Parse("01/01/1900") || booking.StartDate < DateTime.Parse("01/01/1900")) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "Date is not valid.");
                return View(booking);
            }
            if (booking.EndDate <= booking.StartDate) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "End date should be later than start date.");
            }
            var validateRoomNumber = db.GetRoomByRoomNumber(booking.BookedRoomNumber).FirstOrDefault();
            if (validateRoomNumber == null) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room number does not exist.");
                return View(booking);
            }

            if (!validateRoomNumber.Enabled) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not enabled.");
            }
            if (!RoomIsValidForDatesExceptForOneBooking(validateRoomNumber.ID, booking.StartDate, booking.EndDate, booking.ID)) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not available at that time.");
            }

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindByName(booking.BookedUserName);
                if (user == null) {
                    ModelState.AddModelError(nameof(booking.BookedUserName),
                      "User does not exist.");
                    return View(booking);
                }



                if (ModelState.IsValid) {
                    db.UpdateABooking(booking.ID, booking.StartDate, booking.EndDate, validateRoomNumber.ID, user.Id, booking.TotalPrice);
                    return RedirectToAction("CurrentOrders");
                }
            }
            return View(booking);
        }


        [HttpGet]
        public ActionResult EditFutureOrder(int ID) {
            var model = db.GetBookingByID(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            model.BookedRoomNumber = db.GetRoomById(model.BookedRoomID).FirstOrDefault().RoomNumber;
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.BookedUserName = um.FindById(model.BookedUserID).UserName;
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditFutureOrder(GetBookingByID_Result booking) {
            if (booking.EndDate < DateTime.Parse("01/01/1900") || booking.StartDate < DateTime.Parse("01/01/1900")) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "Date is not valid.");
                return View(booking);
            }
            if (booking.EndDate <= booking.StartDate) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "End date should be later than start date.");
            }
            var validateRoomNumber = db.GetRoomByRoomNumber(booking.BookedRoomNumber).FirstOrDefault();
            if (validateRoomNumber == null) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room number does not exist.");
                return View(booking);
            }

            if (!validateRoomNumber.Enabled) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not enabled.");
            }
            if (!RoomIsValidForDatesExceptForOneBooking(validateRoomNumber.ID, booking.StartDate, booking.EndDate, booking.ID)) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not available at that time.");
            }

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindByName(booking.BookedUserName);
                if (user == null) {
                    ModelState.AddModelError(nameof(booking.BookedUserName),
                      "User does not exist.");
                    return View(booking);
                }



                if (ModelState.IsValid) {
                    db.UpdateABooking(booking.ID, booking.StartDate, booking.EndDate, validateRoomNumber.ID, user.Id, booking.TotalPrice);
                    return RedirectToAction("FutureOrders");
                }
            }
            return View(booking);
        }

        [HttpGet]
        public ActionResult DeleteOneOrder(int ID) {
            var model = db.GetBookingByID(ID).FirstOrDefault();
            if (model == null) {
                return HttpNotFound();
            }
            model.BookedRoomNumber = db.GetRoomById(model.BookedRoomID).FirstOrDefault().RoomNumber;
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                model.BookedUserName = um.FindById(model.BookedUserID).UserName;
            }

            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteOneOrder(int ID, FormCollection form) {
            db.DeleteABooking(ID);
            return RedirectToAction("FutureOrders");
        }

        [HttpGet]
        public ActionResult CreateOneOrder() {
            return View();
        }
        [HttpPost]
        public ActionResult CreateOneOrder(GetBookingByID_Result booking) {
            if (booking.StartDate < DateTime.Now.Date) {
                ModelState.AddModelError(nameof(booking.StartDate),
                   "Start date should be no earlier than today.");
            }
            if (booking.EndDate < DateTime.Parse("01/01/1900")) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "Date is not valid.");
                return View(booking);
            }
            if (booking.EndDate <= booking.StartDate) {
                ModelState.AddModelError(nameof(booking.EndDate),
                   "End date should be later than start date.");
            }
            var validateRoomNumber = db.GetRoomByRoomNumber(booking.BookedRoomNumber).FirstOrDefault();
            if (validateRoomNumber == null) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room number does not exist.");
                return View(booking);
            }

            if (!validateRoomNumber.Enabled) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not enabled.");
            }
            if (!RoomIsValidForDates(validateRoomNumber.ID, booking.StartDate, booking.EndDate)) {
                ModelState.AddModelError(nameof(booking.BookedRoomNumber),
                  "Room is not available at that time.");
            }

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindByName(booking.BookedUserName);
                if (user == null) {
                    ModelState.AddModelError(nameof(booking.BookedUserName),
                      "User does not exist.");
                    return View(booking);
                }



                if (ModelState.IsValid) {
                    db.AddABooking(booking.StartDate, booking.EndDate, validateRoomNumber.ID, user.Id, booking.TotalPrice);

                    return RedirectToAction("Orders");
                }
            }
            return View(booking);

        }


        public bool RoomIsValidForDatesExceptForOneBooking(int roomId, DateTime startDate, DateTime endDate, int bookingId) {

            var allbookings = db.GetAllBookings().ToList();
            List<GetAllBookings_Result> bookingsOfOneRoom = new List<GetAllBookings_Result>();
            allbookings.ForEach(ab => {
                if (ab.BookedRoomID == roomId) {
                    bookingsOfOneRoom.Add(ab);
                }
            });

            //List<Booking> bookingsOfOneRoom = GetBookingsOfOneRoom(roomId);
            DateTime a = startDate;
            DateTime b = endDate.AddDays(-1);
            for (int i = 0; i < bookingsOfOneRoom.Count; i++) {
                if (bookingsOfOneRoom[i].ID == bookingId) {
                    continue;
                }
                DateTime A = bookingsOfOneRoom[i].StartDate;
                DateTime B = bookingsOfOneRoom[i].EndDate.AddDays(-1);
                if (a <= A && a <= B && b >= A && b <= B) {
                    return false;
                }
                if (a >= A && a <= B && b >= A && b <= B) {
                    return false;
                }
                if (a >= A && a <= B && b >= A && b >= B) {
                    return false;
                }
                if (a <= A && a <= B && b >= A && b >= B) {
                    return false;
                }
            }

            return true;
        }
        public bool RoomIsValidForDates(int roomId, DateTime startDate, DateTime endDate) {

            var allbookings = db.GetAllBookings().ToList();
            List<GetAllBookings_Result> bookingsOfOneRoom = new List<GetAllBookings_Result>();
            allbookings.ForEach(ab => {
                if (ab.BookedRoomID == roomId) {
                    bookingsOfOneRoom.Add(ab);
                }
            });
            //List<Booking> bookingsOfOneRoom = GetBookingsOfOneRoom(roomId);
            DateTime a = startDate;
            DateTime b = endDate.AddDays(-1);
            for (int i = 0; i < bookingsOfOneRoom.Count; i++) {
                DateTime A = bookingsOfOneRoom[i].StartDate;
                DateTime B = bookingsOfOneRoom[i].EndDate.AddDays(-1);
                if (a <= A && a <= B && b >= A && b <= B) {
                    return false;
                }
                if (a >= A && a <= B && b >= A && b <= B) {
                    return false;
                }
                if (a >= A && a <= B && b >= A && b >= B) {
                    return false;
                }
                if (a <= A && a <= B && b >= A && b >= B) {
                    return false;
                }
            }

            return true;
        }

        [HttpGet]
        public ActionResult Users() {
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var users = um.Users.ToList();
                var currentUserId = System.Web.HttpContext.Current.User.Identity.GetUserId();
                List<FormatedUser> model = new List<FormatedUser>();
                users.ForEach(u => {
                    
                      
                    var fu = new FormatedUser {
                        Id = u.Id,
                        UserName = u.UserName,
                        PasswordHash = u.PasswordHash,
                        Admin = um.IsInRole(u.Id, "Admin")

                    };
                    if (!currentUserId.Equals(u.Id)) {
                        model.Add(fu);
                    }
                });
                return View(model);
            }
        }
        [HttpGet]
        public ActionResult CreateOneUser() {

            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateOneUser(RegisterViewModel model) {
            if (ModelState.IsValid) {
                var user = new ApplicationUser { UserName = model.Email, Email = model.Email };
                var result = await HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>().CreateAsync(user, model.Password);
                if (result.Succeeded) {
                    return RedirectToAction("Users");
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        [HttpGet]
        public ActionResult EditOneUser(string Id) {

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindById(Id);


                var fu = new FormatedUser {
                    Id = user.Id,
                    UserName = user.UserName,
                    PasswordHash = user.PasswordHash,
                    Admin = um.IsInRole(user.Id, "Admin")

                };

                return View(fu);
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditOneUser(FormatedUser u) {
            if (u.UserName == null || u.UserName.Equals("")) {
                ModelState.AddModelError(nameof(u.UserName),
                  "User name cannot be null");
            }
            if (u.PasswordHash == null || u.PasswordHash.Equals("")) {
                ModelState.AddModelError(nameof(u.PasswordHash),
                  "Password cannot be null");
            }
            if (ModelState.IsValid) {
                using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                    var user = um.FindById(u.Id);
                    user.UserName = u.UserName;
                    user.Email = u.UserName;
                    um.Update(user);
                    if (!user.PasswordHash.Equals(u.PasswordHash)) {

                        um.RemovePassword(u.Id);

                        um.AddPassword(u.Id, u.PasswordHash);


                    }
                    if (u.Admin) {
                        if (!um.IsInRole(u.Id, "Admin")) {
                            um.AddToRole(u.Id, "Admin");
                        }
                    }
                    else {
                        if (um.IsInRole(u.Id, "Admin")) {
                            um.RemoveFromRole(u.Id, "Admin");
                        }
                    }

                    return RedirectToAction("Users");
                }
            }
            return View(u);

        }
        [HttpGet]
        public ActionResult DeleteOneUser(string Id) {

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindById(Id);


                var fu = new FormatedUser {
                    Id = user.Id,
                    UserName = user.UserName,
                    PasswordHash = user.PasswordHash,
                    Admin = um.IsInRole(user.Id, "Admin")

                };

                return View(fu);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteOneUser(string Id, FormCollection form) {
            var list = db.GetAllBookings().ToList();



            list.ForEach(b => {
                if (b.BookedUserID.Equals(Id)) {
                    db.DeleteABooking(b.ID);
                }

            });
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {

                um.Delete(um.FindById(Id));

            }
            return RedirectToAction("Users");
        }
    }
}