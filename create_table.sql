------------------------- TẠO BẢNG PHÂN QUYỀN --------------------------
CREATE TABLE tbl_Roles (
    PK_iRoleID int IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sName NVARCHAR(20),
    sDescription NVARCHAR(100)
)
go

------------------------- TẠO BẢNG NGƯỜI DÙNG --------------------------
CREATE TABLE tbl_Users (
    PK_iUserID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FK_iRoleID INT,
    sName NVARCHAR(100),
    sAddress NVARCHAR(100),
    sEmail NVARCHAR(100),
    dDateBirth DATETIME,
    sPhone NVARCHAR(20),
    dCreateTime DATETIME,
    dUpdateTime DATETIME,
    dDeleteTime DATETIME
)
GO
ALTER TABLE tbl_Users ADD CONSTRAINT FK_iRoleID FOREIGN KEY (FK_iRoleID) REFERENCES tbl_Roles
ALTER TABLE tbl_Users ADD sPassword NVARCHAR(100)

-- Xoá cột: https://freetuts.net/xoa-column-trong-sql-server-1589.html
exec sp_rename 'tbl_Users.bGender', 'iGender', 'COLUMN';
ALTER TABLE tbl_Users ADD sUserName NVARCHAR(100)
ALTER TABLE tbl_Users ADD sImageProfile NVARCHAR(100)
ALTER TABLE tbl_Users
ALTER COLUMN bGender INT
GO

------------------------- TẠO BẢNG CỬA HÀNG --------------------------
CREATE TABLE tbl_Stores (
    PK_iStoreID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sStoreName NVARCHAR(100)
)
GO

ALTER TABLE tbl_Stores ADD sImageAvatar NVARCHAR(100)
ALTER TABLE tbl_Stores ADD sImageLogo NVARCHAR(100)

------------------------- TẠO BẢNG DANH MỤC --------------------------
CREATE TABLE tbl_Categories (
    PK_iCategoryID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sName NVARCHAR(100),
    sDescription NVARCHAR(250),
    iIsVisible BIT
)
GO
exec sp_rename 'tbl_Categories.sName', 'sCategoryName', 'COLUMN';
ALTER TABLE tbl_Categories
ALTER COLUMN iIsVisible INT
ALTER TABLE tbl_Categories ADD sCategoryImage NVARCHAR(100)
ALTER TABLE tbl_Categories ADD FK_iStoreID INT
ALTER TABLE tbl_Categories ADD CONSTRAINT FK_iStore FOREIGN KEY (FK_iStoreID) REFERENCES tbl_Stores

------------------------- TẠO BẢNG SẢN PHẨM --------------------------
CREATE TABLE tbl_Products (
    PK_iProductID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iCategoryID INT,
    sName NVARCHAR(100),
    iQuantity INT,
    sDescription NVARCHAR(MAX),
    sImageUrl NVARCHAR(MAX),
    iPrice FLOAT,
    iIsVisible BIT,
    dCreateTime DATETIME,
    dUpdateTime DATETIME,
    dDeleteTime DATETIME
)
GO
ALTER TABLE tbl_Products ADD CONSTRAINT FK_iCategoryID FOREIGN KEY (FK_iCategoryID) REFERENCES tbl_Categories
--Thay đổi giá trị cột trong một bảng
ALTER TABLE tbl_Products
ALTER COLUMN iIsVisible INT

------------------------- TẠO BẢNG YÊU THÍCH SẢN PHẨM --------------------------
CREATE TABLE tbl_Favorites (
    PK_iFavoriteID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iProductID INT,
    FK_iUserID INT,
    bFavorite BIT
)
GO
ALTER TABLE tbl_Favorites ADD CONSTRAINT FK_Product_Favorite FOREIGN KEY (FK_iProductID) REFERENCES tbl_Products
ALTER TABLE tbl_Favorites ADD CONSTRAINT FK_User_Favorite FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users
--Thay đổi giá trị cột trong một bảng
ALTER TABLE tbl_Favorites
ALTER COLUMN bFavorite INT

------------------------- TẠO BẢNG BÌNH LUẬN --------------------------
CREATE TABLE tbl_Reviews (
    PK_iReviewID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FK_iUserID INT,
    FK_iProductID INT,
    iStars INT,
    sComment NVARCHAR(MAX),
    dCreateTime DATETIME,
    dUpdateTime DATETIME,
    dDeleteTime DATETIME
)
GO
ALTER TABLE tbl_Reviews ADD CONSTRAINT FK_iProductID FOREIGN KEY (FK_iProductID) REFERENCES tbl_Products,
CONSTRAINT FK_iUserID FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users

------------------------- TẠO BẢNG GIỎ HÀNG --------------------------
CREATE TABLE tbl_Carts (
    PK_iCartID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    dUpdateTime DATETIME
)
GO

CREATE TABLE tbl_CartDetails (
    PK_iUserID INT,
    PK_iProductID INT,
    PK_iCartID INT,
    iQuantity INT
)
GO
ALTER TABLE tbl_CartDetails ADD CONSTRAINT FK_User_CartDetail FOREIGN KEY (PK_iUserID) REFERENCES tbl_Users
ALTER TABLE tbl_CartDetails ADD CONSTRAINT FK_Product_CartDatail FOREIGN KEY (PK_iProductID) REFERENCES tbl_Products
ALTER TABLE tbl_CartDetails ADD CONSTRAINT FK_iCartID FOREIGN KEY (PK_iCartID) REFERENCES tbl_Carts
ALTER TABLE tbl_CartDetails add dUnitPrice FLOAT, dDiscount FLOAT, dMoney FLOAT

CREATE TABLE tbl_Orders (
    PK_iOrderID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FK_iUserID INT,
    dDate DATETIME,
    fTotalPrice FLOAT
)
GO
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_User_Order FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users (PK_iUserID)

CREATE TABLE tbl_OrderDetails(
    PK_iOrderID INT,
    PK_iProductID INT,
    iQuantity INT,
    iUnitPrice INT
)
GO
ALTER TABLE tbl_OrderDetails ADD CONSTRAINT FK_iOrder FOREIGN KEY (PK_iOrderID) REFERENCES tbl_Orders
ALTER TABLE tbl_OrderDetails ADD CONSTRAINT FK_Product_OrderDetail FOREIGN KEY (PK_iProductID) REFERENCES tbl_Products