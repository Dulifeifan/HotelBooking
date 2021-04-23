create table [Room]
( 
	[ID] int not null primary key Identity(1,1),
	[RoomNumber] int not null,
	[RoomType] varchar(50) not null,
	[BedType] varchar(50) not null,
	[ACType] varchar(50) not null,
	[Price] money not null,
	[Enabled] bit not null,
) 

create table [Booking]
(
	[ID] int not null primary key Identity(1,1),
	[StartDate] date not null,
	[EndDate] date not null,
	[BookedRoomID] int not null foreign key REFERENCES [Room]([ID]),
	[BookedUserID] varchar(50) not null,
	[TotalPrice] money not null,
)

