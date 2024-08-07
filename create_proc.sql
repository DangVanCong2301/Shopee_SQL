-------------------------------------------------------- CỬA HÀNG -------------------------------------------------------------------------
-- Thủ tục lấy cửa hàng --
CREATE PROC sp_SelelteStores
AS
BEGIN
    SELECT * FROM tbl_Stores
END
EXEC sp_SelelteStores
GO

-- Thủ tục lấy cửa hàng theo mã cửa hàng --
CREATE PROC sp_GetShopByID
    @PK_iShopID INT
AS
BEGIN
    SELECT * FROM tbl_Stores WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetShopByID 1
GO

-- Thủ tục lấy cửa hàng theo mã sản phẩm --
CREATE PROC sp_GetShopByProductID
    @PK_iProductID INT
AS
BEGIN
    SELECT PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc
    FROM tbl_Stores
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    WHERE PK_iProductID = @PK_iProductID
END
EXEC sp_GetShopByProductID 3
GO

-- Thủ tục lấy banner cửa hàng theo mã cửa hàng --
SELECT * FROM tbl_Stores INNER JOIN tbl_BannerShops ON tbl_Stores.PK_iStoreID = tbl_BannerShops.FK_iShopID
GO

-- Thủ tục lấy top 3 sản phẩm bán chạy của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop3SellingProductsShop
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(3) 
        PK_iProductID, 
        FK_iCategoryID, 
        sStoreName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible',
        dPerDiscount
    FROM tbl_Stores 
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID 
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop3SellingProductsShop 2
-- Đổi tên
EXEC sp_rename 'sp_GetTopSellingProductsShop', 'sp_GetTop3SellingProductsShop'
GO

-- Thủ tục lấy top 10 sản phẩm bán chạy của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop10SellingProductsShop
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(10) 
        PK_iProductID, 
        FK_iCategoryID, 
        sStoreName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible' ,
        dPerDiscount
    FROM tbl_Stores 
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID 
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop10SellingProductsShop 2
GO

-- Thủ tục lấy top 10 sản phẩm giá tốt (tiền tăng dần) của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop10GoodPriceProductsShop
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(10) 
        PK_iProductID, 
        FK_iCategoryID, 
        sStoreName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible',
        dPerDiscount
    FROM tbl_Stores 
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID 
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID ORDER BY (dPrice) ASC
END
EXEC sp_GetTop10GoodPriceProductsShop 2
GO

-- Thủ tục lấy các danh mục của cửa hàng theo mã cửa hàng --
CREATE PROC sp_GetCategoriesByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Stores 
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE PK_iStoreID = @PK_iShopID
    GROUP BY PK_iCategoryID, sCategoryName, sCategoryImage, sCategoryDescription 
END
EXEC sp_GetCategoriesByShopID 1
GO

-- Thủ tục lấy các sản phẩm của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetProductsByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sStoreName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount 
    FROM tbl_Stores
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetProductsByShopID 3
GO

-- Thủ tục lấy 10 sản phẩm gợi ý của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop10SuggestProductsByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(10) PK_iProductID, FK_iCategoryID, sStoreName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount
    FROM tbl_Stores
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop10SuggestProductsByShopID 2 
-- Đổi tên
EXEC sp_rename 'sp_Get10SuccessProductsByShopID', 'sp_GetTop10SuggestProductsByShopID'
GO

-------------------------------------------------------- BANNER - SLIDER CỬA HÀNG -------------------------------------------------------------------------
-- Lấy Slider theo mã cửa hàng --
ALTER PROC sp_GetBannersShopByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT * from tbl_Sliders_Shop WHERE FK_iShopID = @FK_iShopID 
END
EXEC sp_GetBannersShopByShopID 1
GO

-------------------------------------------------------- THỂ LOẠI -------------------------------------------------------------------------
-- Tham khảo: https://timoday.edu.vn/bai-3-cau-lenh-truy-van-du-lieu/
-- Thủ tục lấy danh mục--
ALTER PROC sp_SelectCategories
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    GROUP BY PK_iCategoryID, sCategoryName, sCategoryImage, sCategoryDescription
END
EXEC sp_SelectCategories
SELECT * FROM tbl_Categories
GO

-- Thủ tục thêm danh mục --
ALTER PROC sp_InsertCategory
    @sCategoryName NVARCHAR(100),
    @sCategoryImage NVARCHAR(100),
    @sCategoryDescription NVARCHAR(MAX)
    --@iIsVisible BIT 
AS
BEGIN
    INSERT INTO tbl_Categories (sCategoryName, sCategoryImage, sCategoryDescription) VALUES (@sCategoryName, @sCategoryImage, @sCategoryDescription)
END
EXEC sp_InsertCategory N'Ô tô', '', N'abc'
GO

-- Thủ tục xoá danh mục --
CREATE PROC sp_DelelteCategoryByID
    @PK_iCategoryID INT
AS
BEGIN
    DELETE tbl_Categories where PK_iCategoryID = @PK_iCategoryID
END
GO

-- Thủ tục xoá danh mục--
CREATE PROC sp_SelectCategoryByID
    @PK_iCategoryID INT
AS
BEGIN
    SELECT * FROM tbl_Categories where PK_iCategoryID = @PK_iCategoryID
END
go

-- Thủ tục xoá danh mục--
CREATE PROC sp_UpdateCategoryByID
    @PK_iCategoryID INT,
     @sCategoryName NVARCHAR(100),
    @sCategoryImage NVARCHAR(100),
    @sCategoryDescription NVARCHAR(MAX)
AS
BEGIN
    UPDATE tbl_Categories SET sCategoryName = @sCategoryName, sCategoryImage = @sCategoryImage, sCategoryDescription = @sCategoryDescription where PK_iCategoryID = @PK_iCategoryID
END
-------------------------------------------------------- SẢN PHẨM -------------------------------------------------------------------------
DECLARE 
    @PageSize INT = 5,
    @PageNumber INT = 2;
SELECT COUNT(1) OVER() as TotalRecord, PK_iProductID, sProductName 
FROM tbl_Products 
order By PK_iProductID 
    OFFSET (@PageNumber - 1) * @PageSize rows 
    FETCH NEXT @PageSize rows ONLY
GO

-- Thủ tục phân trang--
ALTER PROC sp_PaginationProducts
    @PageSize INT,
    @PageNumber INT
AS
BEGIN
SELECT COUNT(1) OVER() as TotalRecord, PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity 
FROM tbl_Products INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
order By PK_iProductID 
    OFFSET (@PageNumber - 1) * @PageSize rows 
    FETCH NEXT @PageSize rows ONLY
END
EXEC sp_PaginationProducts 5, 2
GO

-- Thủ tục lấy sản phẩm--
ALTER PROC sp_SelectProducts
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
END
EXEC sp_SelectProducts
SELECT * FROM tbl_Products ORDER BY(dPrice) DESC
SELECT * FROM tbl_Products ORDER BY(dCreateTime) DESC
GO

-- Tham khảo: https://timoday.edu.vn/bai-3-cau-lenh-truy-van-du-lieu/
-- Thủ tục lấy danh mục--
ALTER PROC sp_SelectCategories
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount' 
    FROM tbl_Categories INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    GROUP BY PK_iCategoryID, sCategoryName, sCategoryImage
END
EXEC sp_SelectCategories
GO

-- Thủ tục tìm sản phẩm bằng từ khoá
CREATE PROC sp_SearchCategoryByKeyword
    @sKeyword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount' 
    FROM tbl_Categories INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE sCategoryName LIKE N'%' + @sKeyword + '%'
    GROUP BY PK_iCategoryID, sCategoryName, sCategoryImage
END
EXEC sp_SearchCategoryByKeyword N'T'
GO

-- Thủ tục lấy sản phẩm theo mã danh mục (nếu là quyền là user thì một số sản phẩm sẽ không hiển thị --
ALTER PROC sp_SelectProductsByCategoryID
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    WHERE FK_iCategoryID = @FK_iCategoryID AND tbl_Products.iIsVisible = 1
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByCategoryID 1
GO

-- Thủ tục lấy sản phẩm theo mã danh mục (nếu là admin thì sẽ hiện thị tất cả sản phẩm --
ALTER PROC sp_SelectProductsByCategoryIDIfRoleAdmin
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE FK_iCategoryID = @FK_iCategoryID 
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByCategoryIDIfRoleAdmin 1
GO

-- Thủ tục lấy sản phẩm theo mã danh mục và sắp xếp theo giá tăng dần --
ALTER PROC sp_SelectProductsByCategoryIDAndSortIncre
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE FK_iCategoryID = @FK_iCategoryID ORDER BY (dPrice) ASC
END
EXEC sp_SelectProductsByCategoryIDAndSortIncre 2
GO

-- Thủ tục lấy 12 sản phẩm và sắp xếp theo giá tăng dần --
ALTER PROC sp_Get12ProductsAndSortIncre
AS
BEGIN
    SELECT TOP(12) PK_iProductID, FK_iCategoryID, sStoreName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    ORDER BY (dPrice) ASC
END
EXEC sp_Get12ProductsAndSortIncre
GO

-- Thủ tục lấy sản phẩm theo mã danh mục và sắp xếp theo giá giảm dần--
ALTER PROC sp_SelectProductsByCategoryIDAndSortReduce
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE FK_iCategoryID = @FK_iCategoryID ORDER BY (dPrice) DESC
END
EXEC sp_SelectProductsByCategoryIDAndSortReduce 1
GO

-- Thủ tục lấy sản phẩm theo mã danh mục và sắp xếp theo tháng mới nhất--
ALTER PROC sp_SelectProductsByCategoryIDAndSortLastestMonth
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE FK_iCategoryID = 1 ORDER BY Month(dCreateTime) DESC
END
EXEC sp_SelectProductsByCategoryIDAndSortReduce 1
GO

-- Thủ tục tìm kiếm sản phẩm theo mã danh mục hoặc tên sản phẩm --
ALTER PROC sp_SearchProductsByKeyword
    @sKeyword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE sCategoryName LIKE N'%' + @sKeyword +  '%' OR sProductName LIKE N'%' + @sKeyword  + '%'
END
EXEC sp_SearchProductsByKeyword 'Tai'
GO

-- Thủ tục lấy sản phẩm theo mã (ID)--
ALTER PROC sp_SelectProductByID
    @PK_iProductID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, sStoreName, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE PK_iProductID = @PK_iProductID
END
EXEC sp_SelectProductByID 2
GO
GO

-----Thủ tục cập nhật lại thông tin sản phẩm -----
CREATE PROC sp_UpdateProduct
    @PK_iProductID INT,
    @iIsVisible BIT
AS
BEGIN
    UPDATE tbl_Products SET iIsVisible = @iIsVisible WHERE PK_iProductID = @PK_iProductID
END
SELECT * FROM tbl_Products
EXEC sp_UpdateProduct 4, 0
GO

-------------------------------------------------------- YÊU THÍCH SẢN PHẨM -------------------------------------------------------------------------
-- Thủ tục tạo danh sách sản phẩm yêu thích --
CREATE PROC sp_SelectProductFavorites
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iFavoriteID, FK_iProductID, FK_iUserID, bFavorite
    FROM tbl_Favorites
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_Favorites.FK_iProductID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = @FK_iUserID
END
EXEC sp_SelectProductFavorites 10
GO

-------------------------------------------------------- TÀI KHOẢN -------------------------------------------------------------------------
-- Thủ tục tạo tài khoản--
ALTER PROC sp_InsertUser
    @FK_iRoleID INT,
    @sName NVARCHAR(100),
    @sEmail NVARCHAR(100),
    @sAddress NVARCHAR(100),
    @dCreateTime DATETIME,
    @sPassword NVARCHAR(100)
AS
BEGIN
    INSERT INTO tbl_Users (FK_iRoleID, sName, sEmail, sAddress, dCreateTime, sPassword) VALUES (@FK_iRoleID, @sName, @sEmail, @sAddress, @dCreateTime, @sPassword)
END
EXEC sp_InsertUser 1, N'Mạnh Cường', 'cuong@gmail.com', N'Hà Nội', '23/01/2024', '12345678'
GO
select * from tbl_Users
update tbl_Users set sName = N'Admin' WHERE PK_iUserID = 10
update tbl_Users set sEmail = N'admin@gmail.com' WHERE PK_iUserID = 10
GO
-------------------------

-- Thủ tục kiểm tra người dùng đã đăng nhập hay chưa--
ALTER PROC sp_CheckUserLogin
    @PK_iUserID INT
AS
BEGIN
    SELECT * FROM tbl_Users WHERE PK_iUserID = @PK_iUserID
END
EXEC sp_CheckUserLogin 10
SELECT * FROM tbl_Users
GO
------------------------------------------------------

--- Thủ tục đăng nhập tài khoản---
ALTER PROC sp_LoginEmailAndPassword
    @sEmail NVARCHAR(100),
    @sPassword NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Users where sEmail = @sEmail and sPassword = @sPassword
END
EXEC sp_LoginEmailAndPassword 'cong@gmail.com', '12345678'
GO

SELECT * FROM tbl_Users
SELECT * FROM tbl_Roles
GO

-- Thủ tục cập nhật tài khoản---
CREATE PROC sp_UpdateUser 
    @PK_iUserID INT,
    @FK_iRoleID INT
    -- @sName NVARCHAR(100),
    -- @sAddress NVARCHAR(100),
    -- @sEmail NVARCHAR(100),
    -- @sPassword NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users set FK_iRoleID = @FK_iRoleID WHERE PK_iUserID = @PK_iUserID
END
EXEC sp_UpdateUser 10, 2
GO

--- Thủ tục lấy thông tin tài khoản bằng mã ---
CREATE PROC sp_GetUserInfoByID
    @PK_iUserID INT
AS
BEGIN
    SELECT * FROM tbl_Users WHERE PK_iUserID = @PK_iUserID
END
EXEC sp_GetUserInfoByID 10
GO
------------------------------------------------------

--- Thủ tục cập nhật thông tin hồ sơ ---
CREATE PROC sp_UpdateProfile
    @PK_iUserID INT,
    @sUserName NVARCHAR(100),
    @sFullName NVARCHAR(100),
    @sEmail NVARCHAR(100),
    @iGender INT,
    @DateBirth DATETIME,
    @sImageProfile NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users SET sUserName = @sUserName, sFullName = @sFullName, sEmail = @sEmail, iGender = @iGender, dDateBirth = @DateBirth, sImageProfile = @sImageProfile WHERE PK_iUserID = @PK_iUserID
END

GO
------------------------------------------------------

-------------------------------------------------------- ĐỊA CHỈ NGƯỜI DÙNG ---------------------------------------------------------------
-- Thủ tục kiểm tra xem tài khoản người dùng đã thiết lập địa chỉ hay chưa --
ALTER PROC sp_CheckAddressAccount
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iAddressID, FK_iUserID, tbl_Users.sFullName, sPhone, sAddress, iDefault FROM tbl_Addresses 
    INNER JOIN tbl_Users ON tbl_Addresses.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_Addresses.FK_iUserID = @FK_iUserID
END
EXEC sp_CheckAddressAccount 2
GO

-- Thủ tục thêm địa chỉ người dùng --
CREATE PROC sp_InsertAddressAccount
    @FK_iUserID INT,
    @sPhone NVARCHAR(20),
    @sAddress NVARCHAR(100)
AS
BEGIN
    INSERT INTO tbl_Addresses (FK_iUserID, sPhone, sAddress) VALUES (@FK_iUserID, @sPhone, @sAddress)
END
EXEC sp_InsertAddressAccount 2, '123', N'Số 20'
GO

-- Thủ tục cập nhật địa chỉ người dùng --
CREATE PROC sp_UpdateAddressAccountUserByID
    @PK_iUserID INT,
    @sFullName NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users SET sFullName = @sFullName WHERE PK_iUserID = @PK_iUserID
END
GO

ALTER PROC sp_UpdateAddressAccountByID
    @PK_iAddressID INT,
    @FK_iUserID INT,
    @sPhone NVARCHAR(20),
    @sAddress NVARCHAR(100)
    --@iDefault INT
AS
BEGIN
    UPDATE tbl_Addresses SET sPhone = @sPhone, sAddress = @sAddress WHERE PK_iAddressID = @PK_iAddressID AND FK_iUserID = @FK_iUserID
END
-- Đổi tên
EXEC sp_rename 'sp_UpdateAddressAccount', 'sp_UpdateAddressAccountByID'
EXEC sp_UpdateAddressAccountByID 2, 2, '2030400404', 'Số 20, Ngõ 259, Phố Định Công, Quận Hoàng Mai, Hà Nội'
SELECT * FROM tbl_Addresses
GO

-- Thủ tục xoá địa chỉ người dùng --
CREATE PROC sp_DeleteAddressAccount
    @PK_iAddressID INT
AS
BEGIN
    DELETE tbl_Addresses WHERE PK_iAddressID = @PK_iAddressID
END
-- Đổi tên
EXEC sp_rename 'sp_DeleteAddressAccount', 'sp_DeleteAddressAccountByID'
EXEC sp_DeleteAddressAccountByID 1
GO

-- Thủ tục lấy địa chỉ người dùng với mã địa chỉ và mã tài khoản --
CREATE PROC sp_GetAddressAccountByID
    @PK_iAddressID INT,
    @FK_iUserID INT
AS 
BEGIN
    SELECT PK_iAddressID, FK_iUserID, tbl_Users.sFullName, sPhone, sAddress, iDefault FROM tbl_Addresses 
    INNER JOIN tbl_Users ON tbl_Addresses.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_Addresses.PK_iAddressID = @PK_iAddressID AND tbl_Addresses.FK_iUserID = @FK_iUserID
END
EXEC sp_GetAddressAccountByID 2, 2
GO

----- ĐỊA CHỈ CHỌN ----
-- Lấy danh sách thành phố --
CREATE PROC sp_GetCities
AS
BEGIN
    SELECT 
        PK_iCityID, 
        sCityName,
        COUNT(tbl_Districts.PK_iDistrictID) as 'iDistrictCount'
    FROM tbl_Cities 
        INNER JOIN tbl_Districts ON tbl_Cities.PK_iCityID = tbl_Districts.FK_iCityID
        GROUP BY PK_iCityID, sCityName
END
EXEC sp_GetCities
GO

-- Lấy danh sách Quận/Huyện - 
ALTER PROC sp_GetDistricts
AS
BEGIN
    SELECT 
        PK_iDistrictID, 
        FK_iCityID,
        sDistrictName,
        sCityName
    FROM tbl_Districts
        INNER JOIN tbl_Cities ON tbl_Districts.FK_iCityID = tbl_Cities.PK_iCityID
END
EXEC sp_GetDistricts
GO

CREATE PROC sp_GetAddressChoose
AS
BEGIN
    SELECT 
        tbl_Cities.PK_iCityID, 
        tbl_Districts.PK_iDistrictID, 
        tbl_Streets.PK_iStreetID,
        tbl_Cities.sCityName, 
        tbl_Districts.sDistrictName ,
        tbl_Streets.sStreetName
    FROM tbl_Cities 
        INNER JOIN tbl_Districts ON tbl_Cities.PK_iCityID = tbl_Districts.FK_iCityID
        INNER JOIN tbl_Streets ON tbl_Districts.PK_iDistrictID = tbl_Streets.FK_iDistrictID
END
EXEC sp_GetAddressChoose
GO
-------------------------------------------------------- GIỎ HÀNG -------------------------------------------------------------------------
-----Thủ tục lấy số lượng sản phẩm trong giỏ hàng-----
select * FROM tbl_CartDetails
GO

ALTER PROC sp_GetCartsCount
    @PK_iUserID INT
AS
BEGIN
    select COUNT(*) as 'iCartCount' FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    where tbl_Users.PK_iUserID = @PK_iUserID    
END
EXEC sp_GetCartsCount 1
GO             
------------------------------------------------------

-----Thủ tục lấy thông tin sản phẩm giỏ hàng-----
ALTER PROC sp_GetInfoCart
    @PK_iUserID INT
AS
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    INNER JOIN tbl_Transports ON tbl_Products.FK_iTransportID = tbl_Transports.PK_iTransportID
    WHERE tbl_Users.PK_iUserID = @PK_iUserID    
END
EXEC sp_GetInfoCart 10
GO   

-----Thủ tục lấy thông tin sản phẩm giỏ hàng theo mã tài khoản, mã sản phẩm-----
ALTER PROC sp_GetInfoCartByProductID
    @PK_iUserID INT,
    @PK_iProductID INT
AS
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    INNER JOIN tbl_Transports ON tbl_Products.FK_iTransportID = tbl_Transports.PK_iTransportID
    WHERE tbl_Users.PK_iUserID = @PK_iUserID AND tbl_Products.PK_iProductID = @PK_iProductID
END
EXEC sp_GetInfoCartByProductID 1, 2
GO

------------------------------------------------------

-----Thủ tục cập nhật số lượng sản phẩm trong giỏ hàng-----
ALTER PROC sp_UpdateProductQuantity
    @PK_iUserID INT,
    @PK_iProductID INT,
    @iQuantity INT,
    @dMoney FLOAT
AS
BEGIN
    UPDATE tbl_CartDetails SET iQuantity = @iQuantity, dMoney = @dMoney where PK_iUserID = @PK_iUserID AND PK_iProductID = @PK_iProductID
END
EXEC sp_UpdateProductQuantity 1, 2, 3, 360000
GO
------------------------------------------------------

-----Thủ tục xoá sản phẩm trong giỏ hàng-----
ALTER PROC sp_DeleteProductInCart
    @PK_iUserID INT,
    @PK_iProductID INT
AS
BEGIN
    DELETE tbl_CartDetails where PK_iUserID = @PK_iUserID AND PK_iProductID = @PK_iProductID
END
EXEC sp_DeleteProductInCart 1, 13
GO
---------------------------------------------

-----Thủ tục tính tổng tiền sản phẩm trong giỏ hàng-----
ALTER PROC sp_TotalMoneyProductInCart
    @PK_iUserID INT
AS
BEGIN
select SUM(tbl_CartDetails.iQuantity * tbl_CartDetails.dUnitPrice) as 'dTotalMoney' FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    where tbl_Users.PK_iUserID = @PK_iUserID   
END
EXEC sp_TotalMoneyProductInCart 10
GO
---------------------------------------------

-----Thủ tục thêm số lượng sản phẩm giỏ hàng-----
CREATE PROC sp_InsertCart
    @dUpdateTime DATETIME
AS
BEGIN
    SET DATEFORMAT dmy INSERT into tbl_Carts (dUpdateTime) VALUES (@dUpdateTime)
END
GO
--------------------------------------------------

-----Thủ tục lấy mã giỏ hàng theo ngày-----
ALTER PROC sp_GetCartIDByTime
    @dUpdateTime DATETIME
AS
BEGIN
    SET DATEFORMAT dmy SELECT * from tbl_Carts where dUpdateTime = @dUpdateTime
END
SET DATEFORMAT dmy EXEC sp_GetCartIDByTime '20/3/2024'
select * FROM tbl_Carts
DELETE tbl_Carts where PK_iCartID = 11
GO
--------------------------------------------------

-----Thủ tục thêm sản phẩm vào chi tiết giỏ hàng-----
create PROC sp_InsertProductIntoCartDetail
    @PK_iUserID INT,
    @PK_iProductID INT,
    @PK_iCartID INT,
    @iQuantity INT,
    @dUnitPrice FLOAT,
    @dDiscount FLOAT,
    @dMonney FLOAT
AS
BEGIN
    INSERT into tbl_CartDetails (PK_iUserID, PK_iProductID, PK_iCartID, iQuantity, dUnitPrice, dDiscount, dMoney) 
    VALUES (@PK_iUserID, @PK_iProductID, @PK_iCartID, @iQuantity, @dUnitPrice, @dDiscount, @dMonney)
END
EXEC sp_InsertProductIntoCartDetail 1, 5, 3, 3, 100000, 1, 300000
select * FROM tbl_CartDetails
GO
--------------------------------------------------
-----Thủ tục kiểm tra sản phẩm trong chi tiết giỏ hàng xem có bị trùng không-----
ALTER PROC sp_CheckProductInCartDetail
    @PK_iUserID INT, 
    @PK_iProductID INT
AS
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice
    FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Products.FK_iTransportID = tbl_Transports.PK_iTransportID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    WHERE tbl_Users.PK_iUserID = @PK_iUserID AND tbl_CartDetails.PK_iProductID = @PK_iProductID
END
select * FROM tbl_CartDetails
EXEC sp_CheckProductInCartDetail 1, 3
GO
--------------------------------------------------
-------------------------------------------------------- ĐẶT HÀNG ------------------------------------------------------------
-----Thủ tục thêm đơn hàng-----
ALTER PROC sp_InsertOrder
    @FK_iUserID INT,
    @dDate DATETIME,
    @dTotalPrice FLOAT,
    @FK_iOrderStatusID INT,
    @FK_iPaymentID INT
AS
BEGIN
    SET DATEFORMAT dmy INSERT INTO tbl_Orders (FK_iUserID, dDate, fTotalPrice, FK_iOrderStatusID, FK_iPaymentID) VALUES (@FK_iUserID, @dDate, @dTotalPrice, @FK_iOrderStatusID, @FK_iPaymentID)
END
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy đơn hàng theo mã -----
ALTER PROC sp_GetOrderByID
    @FK_iUserID INT,
    @dDate DATETIME
AS
BEGIN
    SELECT * FROM tbl_Orders WHERE FK_iUserID = @FK_iUserID AND dDate = @dDate
END
GO

-----Thủ tục thêm sản phẩm vào chi tiết đơn hàng -----
ALTER PROC sp_InserProductIntoOrderDetail
    @PK_iOrderID INT,
    @PK_iProductID INT,
    @iQuantity INT,
    @iUnitPrice FLOAT
AS  
BEGIN
    INSERT INTO tbl_OrderDetails (PK_iOrderID, PK_iProductID, iQuantity, dUnitPrice) VALUES (@PK_iOrderID, @PK_iProductID, @iQuantity, @iUnitPrice)
END
SELECT * FROM tbl_OrderDetails
GO




