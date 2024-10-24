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
    sUserName NVARCHAR(100),
    sEmail NVARCHAR(100),
    dCreateTime DATETIME
)
GO
ALTER TABLE tbl_Users ADD CONSTRAINT FK_iRoleID FOREIGN KEY (FK_iRoleID) REFERENCES tbl_Roles
ALTER TABLE tbl_Users ADD sPassword NVARCHAR(100)
ALTER TABLE tbl_Users DROP COLUMN sImageProfile -- Xoá tên cột 
ALTER TABLE tbl_Users DROP COLUMN iGender -- Xoá tên cột

------------------------- TẠO BẢNG THÔNG TIN NGƯỜI DÙNG --------------------------
CREATE TABLE tbl_Users_Info (
    PK_iUserInfoID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iUserID INT,
    sFullName NVARCHAR(100),
    dDateBirth DATETIME,
    dUpdateTime DATETIME,
    iGender INT,
    sImageProfile NVARCHAR(100)
)
GO
ALTER TABLE tbl_Users_Info ADD CONSTRAINT FK_UsersInfo_Users FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users(PK_iUserID)
ALTER TABLE tbl_Users_Info ADD iIsLock INT

------------------------- TẠO BẢNG ĐỊA CHỈ NGƯỜI DÙNG --------------------------
CREATE TABLE tbl_Addresses (
    PK_iAddressID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iUserID INT,
    sPhone NVARCHAR(20),
    sAddress NVARCHAR(100)
    CONSTRAINT FK_Addresses_Users FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users(PK_iUserID)
)
GO
ALTER TABLE tbl_Addresses ADD iDefault INT

-- Địa chỉ chọn --
CREATE TABLE tbl_Cities (
    PK_iCityID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sCityName NVARCHAR(100)
)
GO

CREATE TABLE tbl_Districts (
    PK_iDistrictID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iCityID INT,
    sDistrictName NVARCHAR(100)
    CONSTRAINT FK_Districts_Cities FOREIGN KEY (FK_iCityID) REFERENCES tbl_Cities(PK_iCityID)
)
GO

CREATE TABLE tbl_Streets (
    PK_iStreetID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iDistrictID INT,
    sStreetName NVARCHAR(100)
    CONSTRAINT FK_Streets_Districts FOREIGN KEY (FK_iDistrictID) REFERENCES tbl_Districts(PK_iDistrictID)
)
GO

-- Xoá cột: https://freetuts.net/xoa-column-trong-sql-server-1589.html
exec sp_rename 'tbl_Users.bGender', 'iGender', 'COLUMN';
ALTER TABLE tbl_Users ADD sUserName NVARCHAR(100)
ALTER TABLE tbl_Users ADD sImageProfile NVARCHAR(100)
ALTER TABLE tbl_Users
ALTER COLUMN bGender INT
GO

------------------------- TẠO BẢNG TÀI KHOẢN NGƯỜI BÁN --------------------------
CREATE TABLE tbl_Sellers (
    PK_iSellerID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sSellerPhone NVARCHAR(20),
    sSellerUsername NVARCHAR(100),
    sSellerPassword NVARCHAR(100)
)
GO

------------------------- TẠO BẢNG THÔNG TIN NGƯỜI BÁN --------------------------
CREATE TABLE tbl_Portals (
    PK_iPortalID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iSellerID INT,
    sCCCD NVARCHAR(20),
    sSellerAddress NVARCHAR(100)
    CONSTRAINT FK_Portals_Sellers FOREIGN KEY (FK_iSellerID) REFERENCES tbl_Sellers (PK_iSellerID)
)
GO

------------------------- TẠO BẢNG CỬA HÀNG --------------------------
CREATE TABLE tbl_Stores (
    PK_iStoreID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sStoreName NVARCHAR(100)
)
GO

ALTER TABLE tbl_Stores ADD sImageAvatar NVARCHAR(100)
ALTER TABLE tbl_Stores ADD sImageLogo NVARCHAR(100)
ALTER TABLE tbl_Stores ADD sImageBackground NVARCHAR(100)
ALTER TABLE tbl_Stores ADD sDesc NVARCHAR(MAX)
ALTER TABLE tbl_Stores ADD sImageMall NVARCHAR(100)
ALTER TABLE tbl_Stores ADD sStoreUsername NVARCHAR(100)
ALTER TABLE tbl_Stores ADD FK_iSellerID INT
ALTER TABLE tbl_Stores ADD CONSTRAINT FK_Stores_Sellers FOREIGN KEY (FK_iSellerID) REFERENCES tbl_Sellers(PK_iSellerID)

------------------------- TẠO BẢNG BANNER CỬA HÀNG --------------------------
CREATE TABLE tbl_BannerShops (
    PK_iBannerShopID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iShopID INT,
    sImageBanner NVARCHAR(100)
)
GO
ALTER TABLE tbl_BannerShops ADD CONSTRAINT FK_iShopID FOREIGN KEY (FK_iShopID) REFERENCES tbl_Stores
EXEC sp_rename 'tbl_Banners_Shops', 'tbl_Sliders_Shop' -- Đổi tên bảng tbl_BannerShops thành tbl_Sliders_Shop (Tương tự với đổi tên thủ tục lưu)
EXEC sp_rename 'tbl_Sliders_Shop.sImageBanner', 'sImageSlider', 'COLUMN'; -- Đổi tên cột trong 1 bảng

------------------------- TẠO BẢNG DANH MỤC CHA --------------------------
CREATE TABLE tbl_Parent_Categories (
    PK_iParentCategoryID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sParentCategoryName NVARCHAR(100),
    sParentCategoryImage NVARCHAR(100)
)
GO

------------------------- TẠO BẢNG DANH MỤC --------------------------
CREATE TABLE tbl_Categories (
    PK_iCategoryID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sName NVARCHAR(100),
    sDescription NVARCHAR(250),
    iIsVisible BIT
)
GO
EXEC sp_rename 'tbl_Categories.sName', 'sCategoryName', 'COLUMN'; -- Đổi tên cột trong 1 bảng
ALTER TABLE tbl_Categories
ALTER COLUMN iIsVisible INT
ALTER TABLE tbl_Categories ADD sCategoryImage NVARCHAR(100)
ALTER TABLE tbl_Categories ADD FK_iStoreID INT
ALTER TABLE tbl_Categories ADD CONSTRAINT FK_iStore FOREIGN KEY (FK_iStoreID) REFERENCES tbl_Stores
-- Xoá cột khoá ngoại FK_iStore
ALTER TABLE tbl_Categories DROP CONSTRAINT FK_iStore -- Xoá tên khoá ngoại
ALTER TABLE tbl_Categories DROP COLUMN FK_iStoreID -- Xoá tên cột 
-- Thêm cột khoá ngoại FK_iParentCategoryID
ALTER TABLE tbl_Categories ADD FK_iParentCategoryID INT
ALTER TABLE tbl_Categories ADD CONSTRAINT FK_Categories_ParentCategory FOREIGN KEY (FK_iParentCategoryID) REFERENCES tbl_Parent_Categories (PK_iParentCategoryID)

-- Đổi tên bảng: https://freetuts.net/doi-ten-table-trong-sql-server-1590.html

------------------------- TẠO BẢNG GIẢM GIÁ SẢN PHẨM --------------------------
CREATE TABLE tbl_Discounts (
    PK_iDiscountID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    dPerDiscount FLOAT
)
GO

------------------------- TẠO BẢNG PHƯƠNG THỨC VẬN CHUYỂN --------------------------
CREATE TABLE tbl_Transports (
    PK_iTransportID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sTransportName NVARCHAR(100),
    dTransportPrice FLOAT,
    sTransportPriceSub NVARCHAR(100)
)
GO
ALTER TABLE tbl_Transports add dTransportPrice FLOAT

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
-- Thêm khoá ngoại giảm giá
ALTER TABLE tbl_Products ADD FK_iDiscountID INT
ALTER TABLE tbl_Products ADD CONSTRAINT FK_iDiscountID FOREIGN KEY (FK_iDiscountID) REFERENCES tbl_Discounts
--Thay đổi giá trị cột trong một bảng
ALTER TABLE tbl_Products
ALTER COLUMN iIsVisible INT
-- Thêm khoá ngoại FK_iTransportID
ALTER TABLE tbl_Products ADD FK_iTransportID INT
ALTER TABLE tbl_Products ADD CONSTRAINT FK_Products_Transports FOREIGN KEY (FK_iTransportID) REFERENCES tbl_Transports (PK_iTransportID)

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

------------------------- TẠO BẢNG CHI TIẾT GIỎ HÀNG --------------------------
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
ALTER TABLE tbl_CartDetails DROP COLUMN dDiscount -- Xoá tên cột  dDiscout
ALTER TABLE tbl_CartDetails add dDiscount FLOAT
SELECT * from tbl_CartDetails

------------------------- TẠO BẢNG TRẠNG THÁI ĐẶT HÀNG --------------------------
CREATE TABLE tbl_Order_Status (
    PK_iOrderStatusID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    iOrderStatusCode INT,
    sOrderStatusName NVARCHAR(100)
)
GO

------------------------- TẠO BẢNG PHƯƠNG THỨC THANH TOÁN --------------------------
CREATE TABLE tbl_Payments (
    PK_iPaymentID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sPaymentName NVARCHAR(100)
)
GO
-- Thêm cột ảnh phương thức
ALTER TABLE tbl_Payments ADD sPaymentImage NVARCHAR(100)

------------------------- TẠO BẢNG LOẠI PHƯƠNG THỨC THANH TOÁN --------------------------
CREATE TABLE tbl_PaymentsType (
    PK_iPaymentTypeID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iPaymentID INT,
    iUserID INT
)
GO
ALTER TABLE tbl_PaymentsType ADD CONSTRAINT FK_PaymentsType_Payments FOREIGN KEY (FK_iPaymentID) REFERENCES tbl_Payments (PK_iPaymentID)
-- Xoá khoá ngoại FK_iPaymentID
ALTER TABLE tbl_PaymentsType DROP CONSTRAINT FK_PaymentsType_Payments -- Xoá tên khoá ngoại
ALTER TABLE tbl_PaymentsType DROP COLUMN PK_iPaymentID -- Xoá tên cột 
EXEC sp_rename 'tbl_PaymentsType.PK_iPaymentID', 'PK_iPaymentTypeID', 'COLUMN'; -- Đổi tên cột trong 1 bảng
--Thay đổi giá trị cột trong một bảng
ALTER TABLE tbl_PaymentsType
ALTER COLUMN PK_iPaymentID INT
-- Xoá khoá chính PK_iPaymentTypeID
ALTER TABLE tbl_PaymentsType DROP CONSTRAINT PK_iPaymentTypeID

------------------------- TẠO BẢNG ĐẶT HÀNG --------------------------
CREATE TABLE tbl_Orders (
    PK_iOrderID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FK_iUserID INT,
    dDate DATETIME,
    fTotalPrice FLOAT
)
GO
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_User_Order FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users (PK_iUserID)
-- Thêm cột khoá ngoại FK_iOrderStatusID
ALTER TABLE tbl_Orders ADD FK_iOrderStatusID INT
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_Orders_OrderStatus FOREIGN KEY (FK_iOrderStatusID) REFERENCES tbl_Order_Status(PK_iOrderStatusID)
-- Thêm cột khoá ngoại FK_iPaymentID
ALTER TABLE tbl_Orders ADD FK_iPaymentID INT
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_Orders_Payments FOREIGN KEY (FK_iPaymentID) REFERENCES tbl_Payments(PK_iPaymentID)
-- Xoá khoá ngoại FK_iPaymentID
ALTER TABLE tbl_Orders DROP CONSTRAINT FK_Orders_PaymentsType -- Xoá tên khoá ngoại
ALTER TABLE tbl_Orders DROP COLUMN FK_iPaymentTypeID -- Xoá tên cột 
-- Thêm cột khoá ngoại FK_PaymentTypeID
ALTER TABLE tbl_Orders ADD FK_iPaymentTypeID INT
EXEC sp_rename 'tbl_Orders.FK_iPaymentType', 'FK_iPaymentTypeID', 'COLUMN'; -- Đổi tên cột trong 1 bảng
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_Orders_PaymentsType FOREIGN KEY (FK_iPaymentTypeID) REFERENCES tbl_PaymentsType (PK_iPaymentTypeID)
-- Thêm cột khoá ngoại FK_iShopID --
ALTER TABLE tbl_Orders ADD FK_iShopID INT
ALTER TABLE tbl_Orders ADD CONSTRAINT FK_Orders_Stores FOREIGN KEY (FK_iShopID) REFERENCES tbl_Stores (PK_iStoreID)

------------------------- TẠO BẢNG CHI TIẾT HÀNG --------------------------
CREATE TABLE tbl_OrderDetails(
    PK_iOrderID INT,
    PK_iProductID INT,
    iQuantity INT,
    iUnitPrice INT
)
GO
ALTER TABLE tbl_OrderDetails ADD CONSTRAINT FK_iOrder FOREIGN KEY (PK_iOrderID) REFERENCES tbl_Orders
ALTER TABLE tbl_OrderDetails ADD CONSTRAINT FK_Product_OrderDetail FOREIGN KEY (PK_iProductID) REFERENCES tbl_Products
-- Thêm cột tiền
ALTER TABLE tbl_OrderDetails ADD dMoney FLOAT
-- Thay đổi giá trị cột
ALTER TABLE tbl_OrderDetails ALTER COLUMN dUnitPrice FLOAT
EXEC sp_rename 'tbl_OrderDetails.iUnitPrice', 'dUnitPrice', 'COLUMN'; -- Đổi tên cột trong 1 bảng

------------------------- TẠO BẢNG ĐƠN VỊ VẬN CHUYỂN --------------------------
CREATE TABLE tbl_ShippingUnits (
    PK_iShippingUnitID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    sShippingUnitName NVARCHAR(100),
    sShippingUnitLogo NVARCHAR(100)
)
GO

------------------------- TẠO BẢNG ĐƠN ĐƠN HÀNG GIAO --------------------------
CREATE TABLE tbl_ShippingOrders (
    PK_iShippingOrderID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FK_iShippingUnitID INT,
    FK_iOrderID INT,
    dShippingTime DATETIME
    CONSTRAINT FK_ShippingOrders_ShippingUnits FOREIGN KEY (FK_iShippingUnitID) REFERENCES tbl_ShippingUnits (PK_iShippingUnitID),
    CONSTRAINT FK_ShippingOrders_Orders FOREIGN KEY (FK_iOrderID) REFERENCES tbl_Orders (PK_iOrderID)
)
GO
-- Thêm cột trạng thái đơn hàng --
ALTER TABLE tbl_ShippingOrders ADD FK_iOrderStatusID INT
ALTER TABLE tbl_ShippingOrders ADD CONSTRAINT FK_ShippingOrders_OrderStatus FOREIGN KEY (FK_iOrderStatusID) REFERENCES tbl_Order_Status

------------------------- TẠO BẢNG LẤY ĐƠN HÀNG --------------------------
CREATE TABLE tbl_ShippingPickers (
    PK_iShippingPickerID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iShippingOrderID INT,
    dShippingPickerTime DATETIME
    CONSTRAINT FK_ShippingPickers_ShippingOrders FOREIGN KEY (FK_iShippingOrderID) REFERENCES tbl_ShippingOrders (PK_iShippingOrderID)
)
GO
-- Thêm cột ảnh lấy hàng -- 
ALTER TABLE tbl_ShippingPickers ADD sPickerImage NVARCHAR(100)
ALTER TABLE tbl_ShippingPickers ADD sPickerName NVARCHAR(100)
ALTER TABLE tbl_ShippingPickers ADD CONSTRAINT FK_ShippingPickers_Users FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users (PK_iUserID)
-- Thêm cột trạng thái đơn hàng -- 
ALTER TABLE tbl_ShippingPickers ADD FK_iOrderStatusID INT
ALTER TABLE tbl_ShippingPickers ADD CONSTRAINT FK_ShippingPickers_OrderStatus FOREIGN KEY (FK_iOrderStatusID) REFERENCES tbl_Order_Status (PK_iOrderStatusID)
-- Xoá khoá ngoại FK_iUserID
ALTER TABLE tbl_ShippingPickers DROP CONSTRAINT FK_ShippingPickers_Users -- Xoá tên khoá ngoại
ALTER TABLE tbl_ShippingPickers DROP COLUMN FK_iUserID -- Xoá tên cột

------------------------- TẠO BẢNG GIAO ĐƠN HÀNG --------------------------
CREATE TABLE tbl_ShippingDeliveries (
    PK_iShippingDeliveryID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    FK_iShippingOrderID INT,
    FK_iUserID INT,
    sDeliveryImage NVARCHAR(100),
    dDeliveryTime DATETIME
    CONSTRAINT FK_ShippingDeliveries_ShippingOrders FOREIGN KEY (FK_iShippingOrderID) REFERENCES tbl_ShippingOrders (PK_iShippingOrderID),
    CONSTRAINT FK_ShippingDeliveries_Users FOREIGN KEY (FK_iUserID) REFERENCES tbl_Users(PK_iUserID)
)
GO
ALTER TABLE tbl_ShippingDeliveries ADD sDeliverName NVARCHAR(100)
-- Thêm cột trạng thái đơn hàng -- 
ALTER TABLE tbl_ShippingDeliveries ADD FK_iOrderStatusID INT
ALTER TABLE tbl_ShippingDeliveries ADD CONSTRAINT FK_ShippingDeliveries_OrderStatus FOREIGN KEY (FK_iOrderStatusID) REFERENCES tbl_Order_Status (PK_iOrderStatusID)