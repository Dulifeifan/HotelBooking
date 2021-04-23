//using HotelBooking.Data.Models;
//using System;
//using System.Collections.Generic;
//using System.Data.Entity;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace HotelBooking.Data.Services {
//    public class SqlRoomData : IRoomData {
//        private readonly HotelBookingDbContext db;

//        public SqlRoomData(HotelBookingDbContext db) {
//            this.db = db;
//        }
//        public void Add(Room room) {
//            db.Rooms.Add(room);
//            db.SaveChanges();
//        }

//        public void Delete(int id) {
//            var room = db.Rooms.Find(id);
//            db.Rooms.Remove(room);
//            db.SaveChanges();
//        }

//        public Room Get(int id) {
//            return db.Rooms.FirstOrDefault(r => r.Id == id);
//        }

//        public IEnumerable<Room> GetAll() {
//            return db.Rooms.OrderBy(r=>r.RoomNumber);
//        }

//        public void Update(Room room) {
//            var entry = db.Entry(room);
//            entry.State = EntityState.Modified;
//            db.SaveChanges();
//        }
//    }
//}
