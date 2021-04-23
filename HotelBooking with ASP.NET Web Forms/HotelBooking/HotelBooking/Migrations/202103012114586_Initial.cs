namespace HotelBooking.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Bookings",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        StartDate = c.DateTime(nullable: false),
                        EndDate = c.DateTime(nullable: false),
                        TotalPrice = c.Int(nullable: false),
                        BookedRoom_ID = c.Int(),
                        BookedUser_Id = c.String(maxLength: 128),
                    })
                .PrimaryKey(t => t.ID)
                .ForeignKey("dbo.Rooms", t => t.BookedRoom_ID)
                .ForeignKey("dbo.AspNetUsers", t => t.BookedUser_Id)
                .Index(t => t.BookedRoom_ID)
                .Index(t => t.BookedUser_Id);
            
            CreateTable(
                "dbo.Rooms",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        RoomNumber = c.Int(nullable: false),
                        HasAC = c.Int(nullable: false),
                        RoomType = c.String(),
                        BedType = c.String(),
                        Price = c.Int(nullable: false),
                        Enabled = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Bookings", "BookedUser_Id", "dbo.AspNetUsers");
            DropForeignKey("dbo.Bookings", "BookedRoom_ID", "dbo.Rooms");
            DropIndex("dbo.Bookings", new[] { "BookedUser_Id" });
            DropIndex("dbo.Bookings", new[] { "BookedRoom_ID" });
            DropTable("dbo.Rooms");
            DropTable("dbo.Bookings");
        }
    }
}
