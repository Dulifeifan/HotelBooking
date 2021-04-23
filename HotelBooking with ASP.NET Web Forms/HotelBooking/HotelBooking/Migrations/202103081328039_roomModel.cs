namespace HotelBooking.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class roomModel : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Rooms", "HasAC", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Rooms", "Enabled", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Rooms", "Enabled", c => c.Int(nullable: false));
            AlterColumn("dbo.Rooms", "HasAC", c => c.Int(nullable: false));
        }
    }
}
