using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;

namespace HotelBooking.Models {
    public class HotelBookingRepository {
        ApplicationDbContext _Context = new ApplicationDbContext();
        public List<ApplicationUser> GetAllUsers() {
            return (from u in _Context.Users
                    select u).ToList();

        }

        public List<Room> GetAllRooms() {
            return (from r in _Context.Rooms
                    select r).ToList();
        }
        public List<Booking> GetAllBookings() {
            return _Context.Bookings.Include("BookedRoom").Include("BookedUser").ToList();
        }
        public List<FormatedBooking> GetAllFormatedBookings() {
            List<FormatedBooking> l = new List<FormatedBooking>();
            var bs = GetAllBookings();
            bs.ForEach(b => {
                var fb = new FormatedBooking {
                    ID = b.ID,
                    BookedRoom = b.BookedRoom,
                    StartDate = b.StartDate,
                    EndDate = b.EndDate,
                    StartDateStr = b.StartDate.ToShortDateString(),
                    EndDateStr = b.EndDate.ToShortDateString(),
                    TotalPrice = b.TotalPrice,
                    BookedUser = b.BookedUser,
                    RoomNumber = b.BookedRoom.RoomNumber,
                    BookedUserID = b.BookedUser.Id
                };
                l.Add(fb);
            });
            return l;
        }
        public List<Booking> GetBookingsOfOneRoom(int roomId) {
            return _Context.Bookings.Where(b => b.BookedRoom.ID == roomId).ToList();
        }
        public bool RoomIsValidForDates(int roomId, DateTime startDate, DateTime endDate) {

            List<Booking> bookingsOfOneRoom = GetBookingsOfOneRoom(roomId);
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
        public bool RoomIsValidForDatesExceptForOneBooking(int roomId, DateTime startDate, DateTime endDate, int bookingId) {

            List<Booking> bookingsOfOneRoom = GetBookingsOfOneRoom(roomId);
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


        public List<Room> GetRoomsWithParams(bool hasAC, string roomType, string bedType) {

            return GetAllRooms().Where(r => r.HasAC == hasAC && r.RoomType.Equals(roomType) && r.BedType.Equals(bedType)).ToList();
        }

        public bool RoomIsEnabled(Room room) {
            return room.Enabled == true;
        }

        public bool BookingIsValid(Room room, DateTime startDate, DateTime endDate) {
            return RoomIsEnabled(room) && RoomIsValidForDates(room.ID, startDate, endDate);
        }
        public bool BookingIsValidForEditing(Room room, DateTime startDate, DateTime endDate, int bookingId) {
            return RoomIsEnabled(room) && RoomIsValidForDatesExceptForOneBooking(room.ID, startDate, endDate, bookingId);
        }

        public List<Room> GetAllValidRoomByDates(DateTime startDate, DateTime endDate) {
            //if (startDate == DateTime.Parse("1/1/0001 12:00:00 AM")  || endDate == DateTime.Parse("1/1/0001 12:00:00 AM")) {
            //    return null;
            //}
            return GetAllRooms().Where(r =>
                    BookingIsValid(r, startDate, endDate)
                ).ToList();
        }

        public List<Room> GetAllValidRoomByDatesAndTypes(DateTime startDate, DateTime endDate, bool hasAc, string roomType, string bedType) {
            return GetAllValidRoomByDates(startDate, endDate).Where(r => r.HasAC == hasAc && r.RoomType.Equals(roomType) && r.BedType.Equals(bedType)).ToList();
        }

        public Room GetRoomById(int id) {
            return _Context.Rooms.FirstOrDefault(r => r.ID == id);
        }

        public Booking GetBookingById(int id) {
            return _Context.Bookings.FirstOrDefault(b => b.ID == id);
        }
        public ApplicationUser GetUserById(string id) {
            return _Context.Users.FirstOrDefault(u => u.Id.Equals(id));
        }
        public ApplicationUser GetUserByName(string name) {
            return _Context.Users.FirstOrDefault(u => u.UserName.Equals(name));
        }
        public int MakeANewBooking(string userId, int roomId, DateTime startDate, DateTime endDate, int price) {
            Room room = GetRoomById(roomId);
            var user = GetUserById(userId);
            if (!BookingIsValid(room, startDate, endDate)) {
                return 1;
            }

            var b = new Booking {
                BookedRoom = room,
                StartDate = startDate,
                EndDate = endDate,
                TotalPrice = price,
                BookedUser = user
            };

            _Context.Bookings.Add(b);
            _Context.SaveChanges();
            return 0;
        }

        public List<FormatedBooking> GetPastAndCurrentBookingsByUserId(string userId) {
            if (userId == null) {
                userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            }
            if (DateTime.Now.Hour >= 15) {
                return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(userId) && b.StartDate <= DateTime.Now.Date).ToList();
            }
            else {
                return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(userId) && b.StartDate < DateTime.Now.Date).ToList();

            }
        }
        public List<FormatedBooking> GetFutureBookingsByUserId(string userId) {
            if (userId == null) {
                userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            }
            if (DateTime.Now.Hour >= 15) {
                return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(userId) && b.StartDate > DateTime.Now.Date).ToList();
            }
            else {
                return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(userId) && b.StartDate >= DateTime.Now.Date).ToList();

            }

        }
        public List<FormatedBooking> GetAllBookingsByUserId(string userId) {
            if (userId == null) {
                //userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
                return null;
            }
            return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(userId)).ToList();

        }
        public List<FormatedBooking> GetAllBookingsByUserName(string Id) {
            if (Id == null) {
                return null;
                //Id = System.Web.HttpContext.Current.User.Identity.GetUserId();
            }

            return GetAllFormatedBookings().Where(b => b.BookedUser.Id.Equals(Id)).ToList();

        }

        public int UpdateOneBookingById(int ID, string StartDateStr, string EndDateStr, int TotalPrice, int RoomNumber) {
            Booking b = GetBookingById(ID);
            if (!RoomNumberExists(RoomNumber)) {
                return 1;
            }
            Room r = GetRoomByRoomNumber(RoomNumber);
            //var u = GetUserById(BookedUserId);
            DateTime startDate = DateTime.Parse(StartDateStr);
            DateTime endDate = DateTime.Parse(EndDateStr);
            if (!BookingIsValidForEditing(r, startDate, endDate, ID)) {
                return 1;
            }
            b.BookedRoom = r;
            b.StartDate = startDate;
            b.EndDate = endDate;
            b.TotalPrice = TotalPrice;
            //b.BookedUser = u;
            _Context.Bookings.Attach(b);
            _Context.Entry(b).State = System.Data.Entity.EntityState.Modified;
            _Context.SaveChanges();
            return 0;
        }
        public int RemoveOneBookingById(int ID) {

            Booking b = GetBookingById(ID);
            if (b != null) {

                _Context.Bookings.Remove(b);
                _Context.SaveChanges();
                return 0;
            }
            return 1;
        }



        public Room GetRoomByRoomNumber(int roomNumber) {
            return GetAllRooms().FirstOrDefault(r => r.RoomNumber == roomNumber);
        }

        public List<object> GetAllUsersWithRole() {
            List<object> list = new List<object>();
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                GetAllUsers().ForEach(u => {
                    var ur = new {
                        UserName = u.UserName,
                        //Role = u.Roles == null ? "" : "Admin"
                        Role = um.IsInRole(u.Id, "Admin") ? "Admin" : null
                    };
                    list.Add(ur);
                });
            }


            return list;
        }

        public static void ToggleAdminRole(string userName) {
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindByName(userName);
                if (um.IsInRole(user.Id, "Admin")) {
                    um.RemoveFromRole(user.Id, "Admin");
                }
                else {
                    um.AddToRole(user.Id, "Admin");
                }
            }
        }

        public int RemoveOneRoomById(int ID) {
            Room r = GetRoomById(ID);
            if (r != null) {

                _Context.Rooms.Remove(r);
                _Context.SaveChanges();
                return 0;
            }
            return 1;
        }
        public bool RoomNumberIsValidWhenEditing(int roomNumber, int ID) {
            var l = GetAllRooms();
            for (int i = 0; i < l.Count; i++) {
                if (l[i].RoomNumber == roomNumber) {
                    if (l[i].ID != ID) {
                        return false;
                    }
                }
            }
            return true;
        }
        public bool RoomNumberExists(int roomNumber) {
            var l = (from r in _Context.Rooms
                     select r.RoomNumber).ToList();
            return l.IndexOf(roomNumber) != -1;
        }
        public bool RoomNumberIsValidWhenAdding(int roomNumber) {
            var l = GetAllRooms();
            for (int i = 0; i < l.Count; i++) {
                if (l[i].RoomNumber == roomNumber) {

                    return false;

                }
            }
            return true;
        }
        public int AddANewRoom(int RoomNumber, bool HasAC, string RoomType, string BedType, int Price, bool Enabled) {
            if (!RoomNumberIsValidWhenAdding(RoomNumber)) {
                return 1;
            }
            Room r = new Room {
                //ID=ID,
                RoomNumber = RoomNumber,
                HasAC = HasAC,
                RoomType = RoomType,
                BedType = BedType,
                Price = Price,
                Enabled = Enabled
            };
            _Context.Rooms.Add(r);
            _Context.SaveChanges();
            return 0;
        }

        public int UpdateOneRoomById(int ID, int RoomNumber, bool HasAC, string RoomType, string BedType, int Price, bool Enabled) {
            if (!RoomNumberIsValidWhenEditing(RoomNumber, ID)) {
                return 1;
            }
            Room r = GetRoomById(ID);


            r.RoomNumber = RoomNumber;
            r.HasAC = HasAC;
            r.RoomType = RoomType;
            r.BedType = BedType;
            r.Price = Price;
            r.Enabled = Enabled;

            _Context.Rooms.Attach(r);
            _Context.Entry(r).State = System.Data.Entity.EntityState.Modified;
            _Context.SaveChanges();
            return 0;
        }
        public List<int> GetNumbersOfBookedRoom(DateTime dt) {
            List<int> i = new List<int>();
            int all = GetAllRooms().Count;
            int disabled = GetAllRooms().Where(r => r.Enabled == false).Count();
            int available = GetAllValidRoomByDates(dt, dt.AddDays(1)).Count;
            int booked = all - disabled - available;
            i.Add(all);
            i.Add(disabled);
            i.Add(booked);
            i.Add(available);
            return i;
        }

        public List<FormatedUser> GetAllFormatedUsers() {
            
            List<FormatedUser> l = new List<FormatedUser>();
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                GetAllUsers().ForEach(u => {
                    var fu = new FormatedUser {
                        Id = u.Id,
                        UserName = u.UserName,
                        PasswordHash = u.PasswordHash,
                        Admin = um.IsInRole(u.Id, "Admin")
                    };
                    l.Add(fu);
                });
            }

            return l;
        }
        public void UpdateUserById(string Id, string UserName, string PasswordHash, bool Admin) {

            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                var user = um.FindById(Id);
                user.UserName = UserName;
                user.Email = UserName;
                um.Update(user);
                if (!user.PasswordHash.Equals(PasswordHash)) {

                    um.RemovePassword(Id);

                    um.AddPassword(Id, PasswordHash);


                }
                if (Admin) {
                    if (!um.IsInRole(Id, "Admin")) {
                        um.AddToRole(Id, "Admin");
                    }
                }
                else {
                    if (um.IsInRole(Id, "Admin")) {
                        um.RemoveFromRole(Id, "Admin");
                    }
                }
            }
        }
        public void RemoveUserById(string Id) {
            var list = GetAllBookingsByUserId(Id);
            list.ForEach(b => {
                RemoveOneBookingById(b.ID);
            });
            using (var um = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()))) {
                
                um.Delete(um.FindById(Id));

            }

        }
    }
}