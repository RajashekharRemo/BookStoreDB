

create table BookStoreUser
(
Id int identity(1,1) primary key,
FullName varchar(150) not null,
Email varchar(200) unique,
UserPassword varchar(200) not null,
Phone bigint
);
go

insert into BookStoreUser(FullName, Email, UserPassword, Phone) values ('Raja', 'raja1234@gmail.com', 'Raja@1234', 7799608035)

drop table BookStoreUser
go

alter proc cp_Add_BookStoreUser
@Name varchar(150),
@Email varchar(200),
@Password varchar(200),
@Phone bigint
as
	begin 
		insert into BookStoreUser(FullName, Email, UserPassword, Phone) values (@Name, @Email, @Password, @Phone)
	end
go


alter table BookStoreUser 
add MemberRole varchar(20) 
go

select * from BookStoreUser
go

update BookStoreUser
set MemberRole='admin'
where Id=4
go


create proc cp_Get_BookStoreUserByEmail
@Email varchar(200)
as
	begin
		select * from BookStoreUser where Email=@Email
	end
go

select * from BookStoreUser where Email='raja1234@gmail.com'
go

alter proc cp_Update_BookStoreUser
@Name varchar(150),
@Email varchar(200),
@Phone bigint,
@Id int
as
	begin 
		update BookStoreUser 
		set FullName=@Name, Email=@Email, Phone=@Phone 
		where Id=@Id
	end
go

select * from BookStoreUser








create table BookStore
(
Id int identity(1,1) primary key,
Title varchar(150) not null,
Price float not null,
Auther varchar(200) not null,
Book_Description varchar(max) not null,
Quantity int,
Book_Image varchar(max) not null
);
go

select * from BookStore

drop table BookStore

insert into BookStore(Title, Price, Auther, Book_Description, Quantity, Book_Image) values(
	'The Accidental Billionaire| Picture Books for Kids |Age 7-11 years', 272, 'Tom McLaughlin', 'A new, hilarious book from author Tom McLaughlin, creator of the highly-acclaimed The Accidental Prime Minister. Funny by Name. Funny by Nature.', 40, 'https://m.media-amazon.com/images/I/71dyKlIdVTL._SY466_.jpg'
)

select * from BookStore

update BookStore set ActualPrice=300 where id=1;
update BookStore set Title='The Accidental Billionaire' where id=1;

update BookStore set Book_Image='../../assets/Book6.png' where id=5;

ALTER TABLE BookStore
ADD ActualPrice float;

--============================================================================================================================================
create proc sp_AddBook
@Title varchar(550),
@Price float,
@Auther varchar(200),
@Description varchar(max),
@Quantity int,
@Image varchar(2000),
@Act_Price float
as 
	begin
		insert into BookStore(Title, Price, Auther, Book_Description, Quantity, Book_Image, ActualPrice) values(
			@Title, @Price, @Auther, @Description, @Quantity, @Image, @Act_Price
		)
	end
go


create proc sp_UpdateBook
@Id int,
@Title varchar(550),
@Price float,
@Auther varchar(200),
@Description varchar(max),
@Quantity int,
@Image varchar(2000),
@Act_Price float
as 
	begin
		update BookStore 
		set Title=@Title, Price=@Price, Auther=@Auther, Book_Description=@Description, Quantity=@Quantity, Book_Image=@Image, ActualPrice=@Act_Price
		where Id=@Id
	end
go



create table AddressOfUserForBook
(
Id int identity(1,1) primary key,
UName varchar(200) not null,
UPhone bigint,
City varchar(200) not null,
UState varchar(200) not null,
UAddress varchar(2000) not null,
AType varchar(100),
UserId int Foreign key references BookStoreUser(Id)
)
go

--PersonID int FOREIGN KEY REFERENCES Persons(PersonID)


create table UserBookCart
(
Id int identity(1,1) primary key,
BookId int Foreign key references BookStore(Id),
Quantity int not null,
UserId int Foreign key references BookStoreUser(Id)
)
go

create proc sp_AddCart
@BookId int,
@Quantity int,
@UserId int
as
	begin 
		insert into UserBookCart(BookId, Quantity, UserId) values(@BookId, @Quantity, @UserId)
	end
go

select * from UserBookCart

delete 
from UserBookCart
where id=6


create table UserBookOrders
(
Id int identity(1,1) primary key,
UName varchar(200) not null,
UPhone bigint,
City varchar(200) not null,
UState varchar(200) not null,
UAddress varchar(2000) not null,
BookId int Foreign key references BookStore(Id),
Quantity int not null,
UserId int Foreign key references BookStoreUser(Id)
)
go


alter proc sp_AddBookOrders
@Uname varchar(200),
@UPhone bigint,
@City varchar(200),
@State varchar(200),
@Address varchar(2000),
@BookId int,
@Quantity int,
@UserId int,
@DateofOder date
as
	begin 
		insert into UserBookOrders(UName,UPhone,City,UState, UAddress, BookId, Quantity, UserId, OrderDate ) 
		values(@Uname,@UPhone, @City, @State,@Address , @BookId, @Quantity, @UserId, @DateofOder)
	end
go

insert into UserBookOrders(UName,UPhone,City,UState, UAddress, BookId, Quantity, UserId, OrderDate) 
		values('Scott',7799608035, 'Anantapur', 'AP','0-00, agahfh' , 12, 2, 1, '2023-06-23')
go

alter table UserBookOrders
add OrderDate date

delete from UserBookOrders where Id=1

select * from UserBookOrders

update UserBookOrders set OrderDate='2024-03-24' where Id=3

create proc sp_GetCartBooksDetails
@UId int
as
	begin
		select b.Id, b.Title, b.Auther, b.Price, b.Book_Description, b.Book_Image , b.ActualPrice, c.Quantity
		from UserBookCart c inner join BookStore b 
		on c.BookId = b.Id
		where c.UserId=4;
	end
go


alter proc sp_GetOrderDetails
@UId int
as
begin
	select b.Id, o.UName,o.UPhone, o.UAddress, o.City, o.UState, o.Quantity, b.Title, b.Book_Description, b.Auther,b.Book_Image, b.Price, b.ActualPrice, o.OrderDate
	from BookStore b inner join UserBookOrders o
	on o.BookId = b.Id
	where o.UserId=4
end
go


select * from UserBookOrders




create table UserAddressForBookStore
(
Id int identity(1,1) primary key,
UName varchar(200) not null,
UPhone bigint,
City varchar(200) not null,
UState varchar(200) not null,
UAddress varchar(2000) not null,
AddressType varchar(20),
UserId int Foreign key references BookStoreUser(Id)
)
go


create proc sp_AddUserAddressForBookStore
@Uname varchar(200),
@UPhone bigint,
@City varchar(200),
@State varchar(200),
@Address varchar(2000),
@AddressType varchar(20),
@UserId int
as
	begin 
		insert into UserAddressForBookStore(UName,UPhone,City,UState, UAddress,AddressType, UserId) 
		values(@Uname,@UPhone, @City, @State,@Address , @AddressType, @UserId)
	end
go

select * from UserAddressForBookStore

insert into UserAddressForBookStore(UName,UPhone,City,UState, UAddress, AddressType, UserId) 
		values('Raja',7799608035, 'Anantapur', 'AP','0-00, agahfh' , 'Home', 4)
go


update UserAddressForBookStore set City='SomeCity', UState='SomeState', UAddress='0-00, SomeWhere' , AddressType='Other' where Id=4

create proc sp_UpdateUserAddress
@Name varchar(200),
@Phone bigint,
@City varchar(200),
@State varchar(200),
@Address varchar(2000),
@AddType varchar(20),
@UId int
as
begin	
	update UserAddressForBookStore
	set UName=@Name, UPhone=@Phone, City=@City, UState=@State, UAddress=@Address, AddressType=@AddType
	where UserId=@UId
end
go

select * from UserAddressForBookStore



create table NoteWishList
(
Id int identity(1,1) primary key,
BookId int Foreign key references BookStore(Id),
UserId int Foreign key references BookStoreUser(Id)
)
go
select * from NoteWishList
go

delete from NoteWishList where Id=8

alter proc sp_AddToWishList
@BookId int,
@UserId int
as
	begin 
		insert into NoteWishList(BookId, UserId) values(@BookId, @UserId)
	end
go


alter proc sp_GetWishList
@UId int
as
begin
	select b.Id, b.Title, b.Book_Description, b.Auther, b.Book_Image, b.Price, b.ActualPrice, b.Quantity
	from NoteWishList c inner join BookStore b
	on c.BookId=b.Id
	where c.UserId=4
end



create table ReviewForBook
(
Id int identity(1,1) primary key,
Review varchar(max) not null,
Stars int,
BookId int Foreign key references BookStore(Id),
UserId int Foreign key references BookStoreUser(Id)
)
go


create proc sp_AddToReview
@Review varchar(max),
@Stars int,
@BookId int,
@UserId int
as
	begin 
		insert into ReviewForBook(Review, Stars, BookId, UserId) values(@Review, @Stars, @BookId, @UserId)
	end
go

insert into ReviewForBook(Review, Stars, BookId, UserId) values('Good Book', 4, 6, 4)
go

create proc sp_GetReviewList
@BId int
as
begin
	select r.Review, r.Stars, u.FullName
	from ReviewForBook r inner join BookStoreUser u
	on r.UserId = u.Id
	where BookId=@BId
end
go

alter proc sp_GetReviewListAll
as
begin
	select r.Review, r.Stars, u.FullName, r.BookId
	from ReviewForBook r inner join BookStoreUser u
	on r.UserId = u.Id
end
go

select * from ReviewForBook
