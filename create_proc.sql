-------------------------------------------------------- TÀI KHOẢN NGƯỜI BÁN -------------------------------------------------------------------------
-- Thủ tục đăng nhập tài khoản người bán --
CREATE PROC sp_LoginAccountSeller
    @sSellerPhone NVARCHAR(20),
    @sSellerPassword NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Sellers WHERE sSellerPhone = @sSellerPhone AND sSellerPassword = @sSellerPassword
END
EXEC sp_LoginAccountSeller '0347797502', 'jNf5bbOGFps='
GO

-- Thủ tục lấy tài khoản người bán bằng mã -- 
CREATE PROC sp_GetSellerAccountByID
    @PK_iSellerID INT
AS
BEGIN
    SELECT * FROM tbl_Sellers WHERE PK_iSellerID = @PK_iSellerID
END
EXEC sp_GetSellerAccountByID 1
GO

-- Thủ tục lấy lại mật khẩu tài khoản người bán bằng sđt --
CREATE PROC sp_GetPasswordSellerAccountByPhone
    @sSellerPhone NVARCHAR(20)
AS
BEGIN
    SELECT * FROM tbl_Sellers WHERE sSellerPhone = @sSellerPhone
END
EXEC sp_GetPasswordSellerAccountByPhone '0347797502'
GO

-- Kiểm tra tài khoản người bán với mã và mật khẩu --
CREATE PROC sp_CheckSellerAccountByIDAndPass
    @PK_iSellerID INT,
    @sSellerPassword NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Sellers WHERE PK_iSellerID = @PK_iSellerID AND sSellerPassword = @sSellerPassword
END
EXEC sp_CheckSellerAccountByIDAndPass 1, 'jNf5bbOGFps='
GO

-- Đổi mật khẩu tài khoản người bán --
CREATE PROC sp_ChangePasswordSellerAccount
    @PK_iSellerID INT,
    @sSellerPassword NVARCHAR(100)
AS
BEGIN 
    UPDATE tbl_Sellers SET sSellerPassword = @sSellerPassword WHERE PK_iSellerID = @PK_iSellerID
END
GO

-------------------------------------------------------- CỬA HÀNG -------------------------------------------------------------------------
-- Thủ tục lấy cửa hàng --
CREATE PROC sp_GetStores
AS
BEGIN
    SELECT * FROM tbl_Stores
END
EXEC sp_GetStores
-- Đổi tên
EXEC sp_rename 'sp_SelelteStores', 'sp_GetStores'
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

-- Thủ tục lấy cửa hàng theo tên đăng nhập --
CREATE PROC sp_GetShopByUsername
    @sShopUsername NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Stores WHERE sStoreUsername = @sShopUsername
END
EXEC sp_GetShopByUsername 'f4shop.vn'
GO

-- Thủ tục lấy cửa hàng theo mã sản phẩm --
ALTER PROC sp_GetShopByProductID
    @PK_iProductID INT
AS
BEGIN
    SELECT PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sImageMall, sStoreUsername, sDesc
    FROM tbl_Stores
    INNER JOIN tbl_Categories ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    WHERE PK_iProductID = @PK_iProductID
END
EXEC sp_GetShopByProductID 3
GO

-- Thủ tục lấy cửa hàng theo mã danh mục cha --
ALTER PROC sp_GetShopByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sImageMall, sStoreUsername, sDesc, COUNT(tbl_Categories.PK_iCategoryID) as 'iCategoryCount'
    FROM tbl_Parent_Categories
    INNER JOIN tbl_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    WHERE tbl_Parent_Categories.PK_iParentCategoryID = @FK_iParentCategoryID
    GROUP BY PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
END
EXEC sp_GetShopByParentCategoryID 3
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

-- Thủ tục lấy cửa hàng theo mã tài khoản người bán --
CREATE PROC sp_GetShopBySellerID
    @FK_iSellerID INT
AS
BEGIN
    SELECT PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername FROM tbl_Stores 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Stores.FK_iSellerID
    WHERE FK_iSellerID = @FK_iSellerID
END
EXEC sp_GetShopBySellerID 3
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

-------------------------------------------------------- THỂ LOẠI CHA -------------------------------------------------------------------------
-- Thủ tục lấy danh mục--
CREATE PROC sp_SelectParentCategories
AS
BEGIN
    SELECT PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage, COUNT(tbl_Categories.PK_iCategoryID) as 'iCategoryCount'
    FROM tbl_Parent_Categories INNER JOIN tbl_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    GROUP BY PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage
END
EXEC sp_SelectParentCategories
SELECT * FROM tbl_Categories
GO

-------------------------------------------------------- THỂ LOẠI -------------------------------------------------------------------------
-- Tham khảo: https://timoday.edu.vn/bai-3-cau-lenh-truy-van-du-lieu/
-- Thủ tục lấy danh mục--
ALTER PROC sp_SelectCategories
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories 
    INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    GROUP BY PK_iCategoryID, sCategoryName, sCategoryImage, sCategoryDescription
END
EXEC sp_SelectCategories
SELECT * FROM tbl_Categories
GO

-- Thủ tục lấy danh mục theo mã danh mục cha --
ALTER PROC sp_SelectCategoriesByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Categories.FK_iParentCategoryID = tbl_Parent_Categories.PK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE FK_iParentCategoryID = @FK_iParentCategoryID
    GROUP BY PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription 
END
EXEC sp_SelectCategoriesByParentCategoryID 3
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

-- Thủ tục lấy sản phẩm theo mã danh mục cha (nếu là quyền là user thì một số sản phẩm sẽ không hiển thị --
CREATE PROC sp_SelectProductsByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    WHERE FK_iParentCategoryID = @FK_iParentCategoryID AND tbl_Products.iIsVisible = 1
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByParentCategoryID 3
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
EXEC sp_rename 'sp_SelectProductsByCategoryIDIfRoleAdmin', 'sp_SelectProductsByParentCategoryIDIfRoleAdmin'
EXEC sp_SelectProductsByCategoryIDIfRoleAdmin 1
GO

-- Thủ tục lấy sản phẩm theo mã danh mục cha (nếu là admin thì sẽ hiện thị tất cả sản phẩm) --
CREATE PROC sp_SelectProductsByParentCategoryIDIfRoleAdmin
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Categories.FK_iStoreID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    WHERE FK_iCategoryID = @FK_iParentCategoryID
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByParentCategoryIDIfRoleAdmin 1
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
EXECUTE sp_SelectProductsByCategoryIDAndSortReduce 1
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
-- Thủ tục kiểm tra xem email tài khoản đã đăng ký hay chưa
CREATE PROC sp_CheckEmailUserIsRegis
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Users WHERE sEmail = @sEmail
END
EXEC sp_CheckEmailUserIsRegis "cong@gmail.com"
GO

-- Thủ tục tạo tài khoản--
ALTER PROC sp_InsertUser
    @FK_iRoleID INT,
    @sUserName NVARCHAR(100),
    @sEmail NVARCHAR(100),
    @dCreateTime DATETIME,
    @sPassword NVARCHAR(100)
AS
BEGIN
    INSERT INTO tbl_Users (FK_iRoleID, sUserName, sEmail, dCreateTime, sPassword) VALUES (@FK_iRoleID, @sUserName, @sEmail, @dCreateTime, @sPassword)
END
EXEC sp_InsertUser 1, N'Mạnh Cường', 'Kiều Mạnh Cường', '23/01/2024', '1'
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
------------------------------------------------------

--- Thủ tục cập nhật thông tin hồ sơ ---
ALTER PROC sp_UpdateProfile
    @FK_iUserID INT,
    @sFullName NVARCHAR(100),
	@dDateBirth DATETIME,
	@dUpdateTime DATETIME,
    @iGender INT,
    @sImageProfile NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users_Info SET sFullName = @sFullName, iGender = @iGender, dDateBirth = @dDateBirth, sImageProfile = @sImageProfile WHERE FK_iUserID = @FK_iUserID
END
GO

-- Thủ tục lấy lại mật khẩu tài khoản với email --
CREATE PROC sp_GetPasswordAccountByEmail
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Users WHERE sEmail = @sEmail
END
EXEC sp_GetPasswordAccountByEmail 'cuong@gmail.com'
GO

-- Thủ tục đổi mật khẩu tài khoản với mã --
CREATE PROC sp_ChangePasswordByUserID
    @PK_iUserID INT,
    @sPassword NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users SET sPassword = @sPassword WHERE PK_iUserID = @PK_iUserID
END
EXEC sp_ChangePasswordByUserID 1, '123'
GO

-- Thủ tục lấy mã tài khoản với email --
CREATE PROC sp_GetUserIDAccountByEmail
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT * FROM tbl_Users WHERE sEmail = @sEmail
END
EXEC sp_GetUserIDAccountByEmail 'vinh@gmail.com'
GO
------------------------------------------------------
-------------------------------------------------------- THÔNG TIN TÀI KHOẢN -------------------------------------------------------------------------
--- Thủ tục kiểm tra thông tin tài khoản người dùng có hay chưa ---
CREATE PROC sp_CheckUserInfoByUserID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile FROM tbl_Users_Info 
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID 
    WHERE tbl_Users_Info.FK_iUserID = @FK_iUserID
END
EXEC sp_CheckUserInfoByUserID 3
GO
--- Thủ tục thêm thông tin tài khoản ---
ALTER PROC sp_InsertUserInfo
    @FK_iUserID INT,
    @sFullName NVARCHAR(100),
    @iGender INT,
    @dDateBirth DATETIME,
    @dUpdateTime DATETIME,
    @sImageProfile NVARCHAR(100)
AS
BEGIN 
    SET DATEFORMAT dmy INSERT INTO tbl_Users_Info (FK_iUserID, sFullName, iGender, dDateBirth, dUpdateTime, sImageProfile) VALUES (@FK_iUserID, @sFullName, @iGender, @dDateBirth, @dUpdateTime, @sImageProfile)
END
SET DATEFORMAT dmy EXEC sp_InsertUserInfo 16, N'Nguyễn Thị Vinh', 0, '20/2/2002', '9/9/2024', 'no_user.jpg'
GO
--- Thủ tục lấy thông tin tài khoản bằng mã ---
ALTER PROC sp_GetUserInfoByID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile FROM tbl_Users_Info
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    WHERE PK_iUserID = @FK_iUserID
END
EXEC sp_GetUserInfoByID 8
GO

-------------------------------------------------------- ĐỊA CHỈ NGƯỜI DÙNG ---------------------------------------------------------------
-- Thủ tục kiểm tra xem tài khoản người dùng đã thiết lập địa chỉ hay chưa --
ALTER PROC sp_CheckAddressAccount
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iAddressID, tbl_Addresses.FK_iUserID, tbl_Users_Info.sFullName, sPhone, sAddress, iDefault FROM tbl_Addresses 
    INNER JOIN tbl_Users ON tbl_Addresses.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users.PK_iUserID = tbl_Users_Info.FK_iUserID
    WHERE tbl_Addresses.FK_iUserID = @FK_iUserID
END
EXEC sp_CheckAddressAccount 1
GO

-- Thủ tục thêm địa chỉ người dùng --
ALTER PROC sp_InsertAddressAccount
    @FK_iUserID INT,
    @sPhone NVARCHAR(20),
    @sAddress NVARCHAR(100),
    @iDefault INT
AS
BEGIN
    INSERT INTO tbl_Addresses (FK_iUserID, sPhone, sAddress, iDefault) VALUES (@FK_iUserID, @sPhone, @sAddress, @iDefault)
END
EXEC sp_InsertAddressAccount 10, '123', N'Số 20', 1
SELECT * FROM tbl_Addresses
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
EXEC sp_DeleteAddressAccountByID 7
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
    SELECT tbl_Products.PK_iProductID, tbl_Stores.PK_iStoreID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice FROM tbl_CartDetails 
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
    SELECT tbl_Products.PK_iProductID, tbl_Stores.PK_iStoreID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice FROM tbl_CartDetails 
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
ALTER PROC sp_InsertProductIntoCartDetail
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
    SELECT tbl_Products.PK_iProductID, tbl_Stores.PK_iStoreID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice
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
-------------------------------------------------------- PHƯƠNG THỨC THANH TOÁN ------------------------------------------------------------
-- Thủ tục kiểm tra xem người dùng đã chọn phương thức thanh toán hay chưa? -- 
ALTER PROC sp_CheckPaymentsTypeByUserID
    @iUserID INT
AS
BEGIN
    SELECT PK_iPaymentTypeID, PK_iPaymentID,  sPaymentName, sPaymentImage FROM tbl_PaymentsType
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE iUserID = @iUserID
END
EXEC sp_CheckPaymentsTypeByUserID 1
SELECT * FROM tbl_PaymentsType
GO

-- Thủ tục thêm/đặt phương thức cho tài khoản người dùng --
ALTER PROC sp_InsertPaymentsType
    @FK_iPaymentID INT,
    @UserID INT
AS
BEGIN
    INSERT INTO tbl_PaymentsType(FK_iPaymentID, iUserID) VALUES (@FK_iPaymentID, @UserID)
END
EXEC sp_InsertPaymentsType 1, 2
GO

-- Thủ tục cập nhật phương thức thanh toán 
ALTER PROC sp_UpdatePaymentsType
    @FK_iPaymentID INT,
    @UserID INT
AS
BEGIN
    UPDATE tbl_PaymentsType SET FK_iPaymentID = @FK_iPaymentID WHERE iUserID = @UserID
END
EXEC sp_UpdatePaymentsType 1, 10
GO

-- Thủ tục lấy phương thức thanh toán của tài khoản
ALTER PROC sp_GetPaymentsTypeByUserID
    @iUserID INT
AS
BEGIN
    SELECT PK_iPaymentID,  sPaymentName, sPaymentImage FROM tbl_PaymentsType 
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID 
    WHERE tbl_PaymentsType.iUserID = @iUserID
END
EXEC sp_GetPaymentsTypeByUserID 10
GO
-------------------------------------------------------- ĐẶT HÀNG ------------------------------------------------------------
-----Thủ tục thêm đơn hàng-----
ALTER PROC sp_InsertOrder
    @FK_iUserID INT,
    @FK_iShopID INT,
    @dDate DATETIME,
    @dTotalPrice FLOAT,
    @FK_iOrderStatusID INT,
    @FK_iPaymentTypeID INT
AS
BEGIN
    SET DATEFORMAT dmy INSERT INTO tbl_Orders (FK_iUserID, FK_iShopID, dDate, fTotalPrice, FK_iOrderStatusID, FK_iPaymentTypeID) VALUES (@FK_iUserID, @FK_iShopID, @dDate, @dTotalPrice, @FK_iOrderStatusID, @FK_iPaymentTypeID)
END
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy đơn hàng theo mã đơn hàng, mã cửa hàng, ngày đặt hàng -----
ALTER PROC sp_GetOrderByID
    @FK_iUserID INT,
    @FK_iShopID INT,
    @dDate DATETIME
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND FK_iShopID = @FK_iShopID AND dDate = @dDate
END
SET DATEFORMAT dmy EXEC sp_GetOrderByID 2, 3, '29/7/2024'
GO

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái chờ thanh toán -----
ALTER PROC sp_GetOrderByUserIDWaitSettlement
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = 0
END
EXEC sp_GetOrderByUserIDWaitSettlement 2
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ xác nhận -- 
ALTER PROC sp_GetOrderWaitSettlement
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 0
END
EXEC sp_GetOrderWaitSettlement
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ xác nhận theo mã cửa hàng -- 
CREATE PROC sp_GetOrderWaitSettlementByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 0 AND FK_iShopID = @FK_iShopID
END
EXEC sp_GetOrderWaitSettlement
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ lấy hàng theo mã cửa hàng -- 
CREATE PROC sp_GetOrderWaitPickupByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 6 AND FK_iShopID = @FK_iShopID
END
EXEC sp_GetOrderWaitSettlement
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ lấy hàng -- 
ALTER PROC sp_GetOrderWaitPickup
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 4
END
EXEC sp_GetOrderWaitPickup
GO

-- Thủ tục lấy đơn hàng ở trạng thái chờ xác nhận với mã đơn hàng -- 
CREATE PROC sp_GetOrderWaitSettlementByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Users.PK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE PK_iOrderID = @PK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 0
END
EXEC sp_GetOrderWaitSettlementByOrderID 2
GO

-- Thủ tục xác nhận đơn hàng về chờ lấy hàng --
CREATE PROC sp_ConfirmOrderAboutPickup
    @PK_iOrderID INT,
    @PK_iUserID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 6 WHERE PK_iOrderID = @PK_iOrderID AND FK_iUserID = @PK_iUserID
END
GO

-------------------------------------------------------- CHI TIẾT ĐẶT HÀNG ------------------------------------------------------------
-----Thủ tục thêm sản phẩm vào chi tiết đơn hàng -----
ALTER PROC sp_InserProductIntoOrderDetail
    @PK_iOrderID INT,
    @PK_iProductID INT,
    @iQuantity INT,
    @iUnitPrice FLOAT,
    @dMoney FLOAT
AS  
BEGIN
    INSERT INTO tbl_OrderDetails (PK_iOrderID, PK_iProductID, iQuantity, dUnitPrice, dMoney) VALUES (@PK_iOrderID, @PK_iProductID, @iQuantity, @iUnitPrice, @dMoney)
END
SELECT * FROM tbl_OrderDetails
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản -----
ALTER PROC sp_GetProductsOrderByUserID
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, tbl_Orders.dDate FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID
END
EXEC sp_GetProductsOrderByUserID 10
SELECT * FROM tbl_OrderDetails
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản, mã đơn hàng -----
CREATE PROC sp_GetProductsOrderByOrderID
    @PK_iOrderID INT,
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, tbl_Orders.dDate FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Orders.PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetProductsOrderByOrderID 5, 10
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản theo trạng thái chờ thành toán -----
ALTER PROC sp_GetProductsOrderByUserIDWaitSettlement
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, tbl_Orders.dDate FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Order_Status.iOrderStatusCode = 0
END
EXEC sp_GetProductsOrderByUserIDWaitSettlement 10
SELECT * FROM tbl_Order_Status
SELECT * FROM tbl_Orders
GO

-- Thủ tục lấy chi tiết đơn hàng theo mã ở trạng thái chờ xác nhận --
CREATE PROC sp_GetOrderDetailWaitSettlementByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, tbl_Orders.dDate FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Categories.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 0
END
-- Đổi tên
EXEC sp_rename 'sp_GetOrderWaitSettlementByOrderID', 'sp_GetOrderDetailWaitSettlementByOrderID'
EXEC sp_GetOrderWaitSettlementByOrderID 2
GO




