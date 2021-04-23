//using HotelBooking.Data.Models;
//using System;
//using System.Collections.Generic;
//using System.Linq;

//namespace HotelBooking.Data.Services {
//    public class InMemoryRoomData : IRoomData {
//        List<Room> rooms;
//        public InMemoryRoomData() {
//            rooms = new List<Room>() {
//                    new Room {
//                        Id=1,
//                        RoomNumber=1001,
//                        Price=100,
//                        RoomType=RoomType.Double,
//                        BedType=BedType.King,
//                        ACType=ACType.ACRoom
//                    },
//                    new Room {
//                        Id=2,
//                        RoomNumber=1002,
//                        Price=100,
//                        RoomType=RoomType.Double,
//                        BedType=BedType.King,
//                        ACType=ACType.ACRoom
//                    },
//                    new Room {
//                        Id=3,
//                        RoomNumber=1003,
//                        Price=100,
//                        RoomType=RoomType.Double,
//                        BedType=BedType.King,
//                        ACType=ACType.ACRoom
//                    },
//                };
//        }
//        public void Add(Room room) {
//            rooms.Add(room);
//            room.Id = rooms.Max(r => r.Id + 1);
//        }
//        public void Update(Room room) {
//            var existing = Get(room.Id);
//            if (existing != null) {
//                existing.RoomNumber = room.RoomNumber;
//                existing.Price = room.Price;
//                existing.RoomType = room.RoomType;
//                existing.BedType = room.BedType;
//                existing.ACType = room.ACType;
//            }
//        }

//        public Room Get(int id) {
//            return rooms.FirstOrDefault(r => r.Id == id);
//        }

//        public IEnumerable<Room> GetAll() {
//            return rooms.OrderBy(r=>r.RoomNumber);
            
//        }

//        public void Delete(int id) {
//            var room = Get(id);
//            if (room != null) {
//                rooms.Remove(room);
//            }
//        }
//    }
//}
