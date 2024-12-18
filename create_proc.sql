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

-- Thủ tục lấy tất cả tài khoản người -- 
CREATE PROC sp_GetSellers
AS
BEGIN
    SELECT PK_iSellerID, sSellerPhone, sSellerUsername, sSellerPassword FROM tbl_Sellers
END
EXEC sp_GetSellers 
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

-- Thủ tục đăng ký tài khoản người bán --
CREATE PROC sp_RegisterAccountSeller
    @sSellerPhone NVARCHAR(20),
    @sSellerUsername NVARCHAR(100),
    @sSellerPassword NVARCHAR(100)
AS
BEGIN
    INSERT INTO tbl_Sellers (sSellerPhone, sSellerUsername, sSellerPassword) VALUES (@sSellerPhone, @sSellerUsername, @sSellerPassword)
END
GO

-------------------------------------------------------- THÔNG TIN TÀI KHOẢN NGƯỜI BÁN ----------------------------------------------------
-- Lấy thông tin người bán với mã
ALTER PROC sp_GetSellerInfoBySellerID
    @PK_iSellerID INT
AS
BEGIN
    SELECT PK_iSellerID, PK_iStoreID, sSellerUsername, sSellerPhone, sStoreName, sSellerAddress FROM tbl_Portals 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Portals.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE PK_iSellerID = @PK_iSellerID
END
EXEC sp_rename 'sp_getSellerInfoBySellerID', 'sp_GetSellerInfoBySellerID'
EXEC sp_GetSellerInfoBySellerID 6
GO

-- Lấy thông tin người bán với số điện thoại
CREATE PROC sp_GetSellerInfoByPhone
    @sSellerPhone INT
AS
BEGIN
    SELECT PK_iSellerID, PK_iStoreID, sSellerUsername, sSellerPhone, sStoreName, sSellerAddress FROM tbl_Portals 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Portals.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE sSellerPhone = @sSellerPhone
END
EXEC sp_rename 'sp_getSellerInfoBySellerID', 'sp_GetSellerInfoBySellerID'
EXEC sp_GetSellerInfoByPhone '23012002'
GO

-- Lấy thông tin người bán với mã đơn hàng
CREATE PROC sp_GetSellerInfoByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iSellerID, PK_iStoreID, sSellerUsername, sSellerPhone, sStoreName, sSellerAddress FROM tbl_Portals 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Portals.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    INNER JOIN tbl_Orders ON tbl_Orders.FK_iShopID = tbl_Stores.PK_iStoreID
    WHERE PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetSellerInfoByOrderID 3
GO

-- Lấy thông tin người bán với mã đơn vận
CREATE PROC sp_GetSellerInfoByShippingOrderID
    @PK_iShippingOrderID INT
AS
BEGIN
    SELECT PK_iSellerID, PK_iStoreID, sSellerUsername, sSellerPhone, sStoreName, sSellerAddress FROM tbl_Portals 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Portals.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    INNER JOIN tbl_Orders ON tbl_Orders.FK_iShopID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    WHERE PK_iOrderID = @PK_iShippingOrderID
END
EXEC sp_GetSellerInfoByShippingOrderID 1
GO

-- Lấy thông tin người bán với số điện thoại và mật khẩu --
CREATE PROC sp_GetSellerInfoByPhoneAndPassword
    @sSellerPhone INT,
    @sSellerPassword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iSellerID, PK_iStoreID, sSellerUsername, sSellerPhone, sStoreName, sSellerAddress FROM tbl_Portals 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Portals.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE sSellerPhone = @sSellerPhone AND sSellerPassword = @sSellerPassword
END
EXEC sp_GetSellerInfoByPhoneAndPassword '0347797502', 'jNf5bbOGFps='
GO

-------------------------------------------------------- CỬA HÀNG -------------------------------------------------------------------------
-- Thủ tục lấy cửa hàng --
ALTER PROC sp_GetStores
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
    FROM tbl_Stores
END
EXEC sp_GetStores
-- Đổi tên
EXEC sp_rename 'sp_SelelteStores', 'sp_GetStores'
GO

-- Thủ tục lấy cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetShopByID
    @PK_iShopID INT
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
    FROM tbl_Stores
    WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetShopByID 1
GO

-- Thủ tục lấy cửa hàng theo tên đăng nhập --
ALTER PROC sp_GetShopByUsername
    @sShopUsername NVARCHAR(100)
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
    FROM tbl_Stores
    WHERE sStoreUsername = @sShopUsername
END
EXEC sp_GetShopByUsername 'f4shop.vn'
GO

-- Thủ tục lấy cửa hàng theo mã sản phẩm --
ALTER PROC sp_GetShopByProductID
    @PK_iProductID INT
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
    FROM tbl_Stores
    INNER JOIN tbl_Products ON tbl_Products.FK_iStoreID = tbl_Stores.PK_iStoreID
    WHERE PK_iProductID = @PK_iProductID
END
EXEC sp_GetShopByProductID 3
GO

-- Thủ tục lấy cửa hàng theo mã danh mục cha --
ALTER PROC sp_GetShopByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sImageMall, sStoreUsername, sDesc
    FROM tbl_Stores
    INNER JOIN tbl_StoreIndustries ON tbl_StoreIndustries.FK_iStoreID = tbl_Stores.PK_iStoreID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_StoreIndustries.FK_iParentCategoryID
    WHERE tbl_Parent_Categories.PK_iParentCategoryID = @FK_iParentCategoryID
    GROUP BY PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername
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
        FK_iStoreID,
        tbl_Categories.FK_iParentCategoryID,
        FK_iCategoryID, 
        FK_iDiscountID,
        FK_iTransportID,
        sStoreName,
        sParentCategoryName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible',
        tbl_Products.dCreateTime,
        tbl_Products.dUpdateTime,
        dPerDiscount,
        sTransportName, 
        dTransportPrice
    FROM tbl_Products
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop3SellingProductsShop 5
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
        FK_iStoreID,
        tbl_Categories.FK_iParentCategoryID,
        FK_iCategoryID, 
        FK_iDiscountID,
        FK_iTransportID,
        sStoreName,
        sParentCategoryName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible' ,
        tbl_Products.dCreateTime,
        tbl_Products.dUpdateTime,
        dPerDiscount,
        sTransportName,
        dTransportPrice
    FROM tbl_Products
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop10SellingProductsShop 5
GO

-- Thủ tục lấy top 10 sản phẩm giá tốt (tiền tăng dần) của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop10GoodPriceProductsShop
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(10) 
        PK_iProductID, 
        FK_iStoreID,
        tbl_Categories.FK_iParentCategoryID,
        FK_iCategoryID, 
		FK_iDiscountID,
		FK_iTransportID,
        sStoreName,
        sParentCategoryName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible',
        tbl_Products.dCreateTime,
        tbl_Products.dUpdateTime,
        dPerDiscount,
        sTransportName,
        dTransportPrice
    FROM tbl_Products
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE tbl_Stores.PK_iStoreID = @PK_iShopID ORDER BY (dPrice) ASC
END
EXEC sp_GetTop10GoodPriceProductsShop 5
GO

-- Thủ tục lấy các sản phẩm của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetProductsByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iCategoryID, FK_iStoreID, tbl_Categories.FK_iParentCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sStoreName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', tbl_Products.dCreateTime, tbl_Products.dUpdateTime, dPerDiscount, sTransportName, dTransportPrice
    FROM tbl_Products
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetProductsByShopID 5
GO

-- Thủ tục lấy 10 sản phẩm gợi ý của cửa hàng theo mã cửa hàng --
ALTER PROC sp_GetTop10SuggestProductsByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT TOP(10) 
        PK_iProductID, 
        FK_iStoreID,
        tbl_Categories.FK_iParentCategoryID,
        FK_iCategoryID, 
        FK_iDiscountID,
        FK_iTransportID,
        sStoreName, 
        sParentCategoryName,
        sCategoryName, 
        sProductName, 
        sImageUrl, 
        sProductDescription, 
        dPrice, 
        iQuantity, 
        tbl_Products.iIsVisible as 'iIsVisible', 
        tbl_Products.dCreateTime,
        tbl_Products.dUpdateTime,
        dPerDiscount,
        sTransportName,
        dTransportPrice
    FROM tbl_Products
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE PK_iStoreID = @PK_iShopID
END
EXEC sp_GetTop10SuggestProductsByShopID 5
-- Đổi tên
EXEC sp_rename 'sp_Get10SuccessProductsByShopID', 'sp_GetTop10SuggestProductsByShopID'
GO

-- Thủ tục lấy cửa hàng theo mã tài khoản người bán --
ALTER PROC sp_GetShopBySellerID
    @FK_iSellerID INT
AS
BEGIN
    SELECT PK_iStoreID, FK_iSellerID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername 
    FROM tbl_Stores 
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_Stores.FK_iSellerID
    WHERE FK_iSellerID = @FK_iSellerID
END
EXEC sp_GetShopBySellerID 3
GO

-- Thủ tục lấy cửa hàng theo mã đơn hàng --
CREATE PROC sp_GetShopByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iStoreID, sStoreName, sImageAvatar, sImageLogo, sImageBackground, sDesc, sImageMall, sStoreUsername FROM tbl_Stores 
    INNER JOIN tbl_Orders ON tbl_Orders.FK_iShopID = tbl_Stores.PK_iStoreID
    WHERE PK_iOrderID = @FK_iOrderID
END
EXEC sp_GetShopBySellerID 3
GO

-------------------------------------------------------- KẾT BẠN --------------------------------------------------------
-- Thủ tục tạo kết bạn
ALTER PROC sp_InsertMakeFriend
    @FK_iUserID INT,
    @FK_iSellerID INT,
    @FK_iMakeStatusID INT,
    @dTime DATETIME
AS
BEGIN
    INSERT INTO tbl_MakeFriends (FK_iUserID, FK_iSellerID, FK_iMakeStatusID, dTime) VALUES (@FK_iUserID, @FK_iSellerID, @FK_iMakeStatusID, @dTime)
END
-- Đổi tên
EXEC sp_rename 'sp_InsertMakeNoice', 'sp_InsertMakeFriend'
GO

-- Thủ tục lấy thông báo kết bạn với mã tài khoản, mã mã cửa hàng --
ALTER PROC sp_GetMakeFriendByUserIDAndShopID
    @FK_iUserID INT,
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, FK_iMakeStatusID, sUserName, sImageProfile, iMakeStatusCode, sMakeStatusName,  dTime 
    FROM tbl_MakeFriends
    INNER JOIN tbl_MakeStatus ON tbl_MakeStatus.PK_iMakeStatusID = tbl_MakeFriends.FK_iMakeStatusID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_MakeFriends.FK_iUserID = @FK_iUserID AND tbl_Stores.PK_iStoreID = @FK_iShopID
END
-- Đổi tên
EXEC sp_rename 'sp_GetMakeNoticeByUserIDAndShopID', 'sp_GetMakeFriendByUserIDAndShopID'
EXEC sp_GetMakeFriendByUserIDAndShopID 1, 5
GO

-- Thủ tục lấy kết bạn với mã tài khoản người bán trạng thái gửi kết bạn --
ALTER PROC sp_GetMakeFriendBySellerID
    @FK_iSellerID INT
AS
BEGIN
    SELECT PK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, FK_iMakeStatusID, sUserName, sImageProfile, iMakeStatusCode, sMakeStatusName,  dTime 
    FROM tbl_MakeFriends
    INNER JOIN tbl_MakeStatus ON tbl_MakeStatus.PK_iMakeStatusID = tbl_MakeFriends.FK_iMakeStatusID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_MakeFriends.FK_iSellerID = @FK_iSellerID AND iMakeStatusCode = 0
END
EXEC sp_rename 'sp_GetMakeNoticeBySellerID', 'sp_GetMakeFriendBySellerID'
EXEC sp_GetMakeFriendBySellerID 6
GO

-- Thủ tục lấy kết bạn với mã tài khoản người mua --
CREATE PROC sp_GetMakeFriendByUserID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, FK_iMakeStatusID, sUserName, sImageProfile, iMakeStatusCode, sMakeStatusName,  dTime 
    FROM tbl_MakeFriends
    INNER JOIN tbl_MakeStatus ON tbl_MakeStatus.PK_iMakeStatusID = tbl_MakeFriends.FK_iMakeStatusID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_MakeFriends.FK_iUserID = @FK_iUserID AND iMakeStatusCode = 1
END
EXEC sp_GetMakeFriendByUserID 1
GO

-- Thủ tục cập nhật kết bạn về trạng thái chấp nhận kết bạn --
CREATE PROC sp_UpdateMakeFriendAboutAcept
    @PK_iMakeFriendID INT
AS
BEGIN
    UPDATE tbl_MakeFriends SET FK_iMakeStatusID = 3 WHERE PK_iMakeFriendID = @PK_iMakeFriendID
END
GO

-------------------------------------------------------- TRÒ CHUYỆN --------------------------------------------------------
ALTER PROC sp_InsertChat
    @FK_iMakeFriendID INT,
    @sLastChat NVARCHAR(MAX),
    @iIsRead INT,
    @dTime DATETIME
AS
BEGIN
    INSERT INTO tbl_Chats (FK_iMakeFriendID, sLastChat, iIsRead, dTime) VALUES (@FK_iMakeFriendID, @sLastChat, @iIsRead, @dTime)
END
GO

-- Thủ tục lấy cuộc trò chuyện với mã tài khoản --
ALTER PROC sp_GetChatByUserID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iChatID, tbl_Chats.FK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, sLastChat, tbl_Chats.dTime, sStoreName, sImageAvatar, sUserName, sImageProfile
    FROM tbl_Chats
    INNER JOIN tbl_MakeFriends ON tbl_MakeFriends.PK_iMakeFriendID = tbl_Chats.FK_iMakeFriendID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID 
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE tbl_MakeFriends.FK_iUserID = @FK_iUserID
END
EXEC sp_GetChatByUserID 1
GO

-- Thủ tục lấy cuộc trò chuyện với mã tài khoản người bán --
ALTER PROC sp_GetChatBySellerID
    @FK_iSellerID INT
AS
BEGIN
    SELECT PK_iChatID, tbl_Chats.FK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, sLastChat, tbl_Chats.dTime, sStoreName, sImageAvatar, sUserName, sImageProfile
    FROM tbl_Chats
    INNER JOIN tbl_MakeFriends ON tbl_MakeFriends.PK_iMakeFriendID = tbl_Chats.FK_iMakeFriendID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID 
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE tbl_MakeFriends.FK_iSellerID = @FK_iSellerID
END
EXEC sp_GetChatBySellerID 6
GO

-- Thủ tục lấy cuộc trò chuyện với mã kết ban --
ALTER PROC sp_GetChatByMakeFriendID
    @FK_iMakeFriendID INT
AS
BEGIN
    SELECT PK_iChatID, tbl_Chats.FK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, sLastChat, tbl_Chats.dTime, sStoreName, sImageAvatar, sUserName, sImageProfile
    FROM tbl_Chats
    INNER JOIN tbl_MakeFriends ON tbl_MakeFriends.PK_iMakeFriendID = tbl_Chats.FK_iMakeFriendID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID 
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE tbl_Chats.FK_iMakeFriendID = @FK_iMakeFriendID
END
EXEC sp_GetChatByMakeFriendID 1
GO

-- Thủ tục lấy cuộc trò chuyện với mã kết ban --
CREATE PROC sp_GetChatByID
    @PK_iChatID INT
AS
BEGIN
    SELECT PK_iChatID, tbl_Chats.FK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, sLastChat, tbl_Chats.dTime, sStoreName, sImageAvatar, sUserName, sImageProfile
    FROM tbl_Chats
    INNER JOIN tbl_MakeFriends ON tbl_MakeFriends.PK_iMakeFriendID = tbl_Chats.FK_iMakeFriendID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID 
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE PK_iChatID = @PK_iChatID
END
EXEC sp_GetChatByID 1
GO

-------------------------------------------------------- CHI TIẾT TRÒ CHUYỆN --------------------------------------------------------
CREATE PROC sp_InsertChatDetail
    @PK_iChatID INT,
    @iChatPersonID INT,
    @sChat NVARCHAR(MAX),
    @dTime DATETIME
AS
BEGIN
    INSERT INTO tbl_ChatDetails (PK_iChatID, iChatPersonID, sChat, dTime) VALUES (@PK_iChatID, @iChatPersonID, @sChat, @dTime)
END
GO

-- Thủ tục lấy chi tiết cuộc trò chuyển bằng mã --
ALTER PROC sp_GetChatDetailByID
    @PK_iChatID INT
AS
BEGIN
    SELECT tbl_ChatDetails.PK_iChatID, tbl_Chats.FK_iMakeFriendID, tbl_MakeFriends.FK_iUserID, tbl_MakeFriends.FK_iSellerID, iChatPersonID, sChat, tbl_ChatDetails.dTime, sStoreName, sImageAvatar, sUserName, sImageProfile
    FROM tbl_ChatDetails
    INNER JOIN tbl_Chats ON tbl_Chats.PK_iChatID = tbl_ChatDetails.PK_iChatID
    INNER JOIN tbl_MakeFriends ON tbl_MakeFriends.PK_iMakeFriendID = tbl_Chats.FK_iMakeFriendID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_MakeFriends.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Sellers ON tbl_Sellers.PK_iSellerID = tbl_MakeFriends.FK_iSellerID 
    INNER JOIN tbl_Stores ON tbl_Stores.FK_iSellerID = tbl_Sellers.PK_iSellerID
    WHERE tbl_ChatDetails.PK_iChatID = @PK_iChatID
    ORDER BY (dTime)
END
EXEC sp_GetChatDetailByID 1
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

-------------------------------------------------------- THỂ LOẠI CHA (NGÀNH HÀNG) -------------------------------------------------------------------------
-- Thủ tục lấy ngành hàng (chỉ những ngành hàng đã có danh mục + sản phâm) --
ALTER PROC sp_SelectParentCategories
AS
BEGIN
    SELECT PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage, COUNT(tbl_Categories.PK_iCategoryID) as 'iCategoryCount', COUNT(tbl_Products.PK_iProductID) as 'iProductCount'
    FROM tbl_Parent_Categories 
    INNER JOIN tbl_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    GROUP BY PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage
END
EXEC sp_SelectParentCategories
GO

-- Thủ tục lấy tất cả ngành hàng --
CREATE PROC sp_GetIndustries
AS
BEGIN
    SELECT PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage, dCreateTime, dUpdateTime 
    FROM tbl_Parent_Categories
END
EXEC sp_GetIndustries
GO

-- Thủ tục lấy ngành hàng theo mã --
CREATE PROC sp_GetIndustryByID
    @PK_iIndustryID INT
AS
BEGIN
    SELECT PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage, dCreateTime, dUpdateTime 
    FROM tbl_Parent_Categories
    WHERE PK_iParentCategoryID = @PK_iIndustryID
END
EXEC sp_GetIndustryByID 1
GO

-- Thủ tục tìm kiếm ngành hàng (chỉ những ngành hàng đã có danh mục + sản phâm) --
CREATE PROC sp_SearchParentCategoriesByKeyword
    @sKeyword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage, COUNT(tbl_Categories.PK_iCategoryID) as 'iCategoryCount', COUNT(tbl_Products.PK_iProductID) as 'iProductCount'
    FROM tbl_Parent_Categories 
    INNER JOIN tbl_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    WHERE sParentCategoryName LIKE N'%' + @sKeyword + '%'
    GROUP BY PK_iParentCategoryID, sParentCategoryName, sParentCategoryImage
END
EXEC sp_SearchParentCategoriesByKeyword N'S'
GO

-- Thủ tục thêm ngành hàng --
ALTER PROC sp_InsertIndustry
    @sIndustryName NVARCHAR(100),
    @sIndustryImage NVARCHAR(100),
    @dCreateTime DATETIME,
    @dUpdateTime DATETIME
AS
BEGIN
    INSERT INTO tbl_Parent_Categories (sParentCategoryName, sParentCategoryImage, dCreateTime, dUpdateTime) VALUES (@sIndustryName, @sIndustryImage, @dCreateTime, @dUpdateTime)
END
GO

-- Thủ tục cập nhật ngành hàng --
CREATE PROC sp_UpdateIndustry
    @PK_iIndustryID INT,
    @sIndustryName NVARCHAR(100),
    @sIndustryImage NVARCHAR(100),
    @dUpdateTime DATETIME
AS
BEGIN
    UPDATE tbl_Parent_Categories SET sParentCategoryName = @sIndustryName, sParentCategoryImage = @sIndustryImage, dUpdateTime = @dUpdateTime 
    WHERE PK_iParentCategoryID = @PK_iIndustryID
END
GO

-- Thủ tục xoá ngành hàng với mã --
CREATE PROC sp_DeleteIndustryByID
    @PK_iIndustryID INT
AS
BEGIN 
    DELETE tbl_Parent_Categories WHERE PK_iParentCategoryID = @PK_iIndustryID
END
GO

-------------------------------------------------------- CỬA HÀNG - NGÀNH HÀNG -------------------------------------------------------------------------


-------------------------------------------------------- THỂ LOẠI -------------------------------------------------------------------------
-- Tham khảo: https://timoday.edu.vn/bai-3-cau-lenh-truy-van-du-lieu/
-- Thủ tục lấy danh mục (các danh mục đã có sản phẩm)--
ALTER PROC sp_SelectCategories
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    GROUP BY PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription
END
EXEC sp_SelectCategories
SELECT * FROM tbl_Categories
GO

-- Thủ tục lấy tất cả các thể loại (cả thể loại chưa có sản phẩm)
ALTER PROC sp_GetAllCategories
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sParentCategoryName, sCategoryName, sCategoryImage, sCategoryDescription, tbl_Categories.dCreateTime, tbl_Categories.dUpdateTime
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
END
EXEC sp_GetAllCategories
GO

-- Thủ tục lấy thể loại theo mã --
ALTER PROC sp_GetCategoryByID
    @PK_iCategoryID INT
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sParentCategoryName, sCategoryName, sCategoryImage, sCategoryDescription, tbl_Categories.dCreateTime, tbl_Categories.dUpdateTime
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    WHERE PK_iCategoryID = @PK_iCategoryID
END
EXEC sp_GetCategoryByID 1
GO

-- Thủ tục lấy tất cả các thể loại theo mã cửa hàng
ALTER PROC sp_GetAllCategoriesByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iCategoryID, tbl_StoreIndustries.FK_iParentCategoryID, sParentCategoryName, sCategoryName, sCategoryImage, sCategoryDescription, tbl_Categories.dCreateTime, tbl_Categories.dUpdateTime
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_StoreIndustries ON tbl_StoreIndustries.FK_iParentCategoryID = tbl_Parent_Categories.PK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_StoreIndustries.FK_iStoreID
    WHERE tbl_Stores.PK_iStoreID = @FK_iShopID
END
EXEC sp_GetAllCategoriesByShopID 5
GO

-- Thủ tục lấy danh mục theo mã danh mục cha --
ALTER PROC sp_SelectCategoriesByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Categories.FK_iParentCategoryID = tbl_Parent_Categories.PK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE FK_iParentCategoryID = @FK_iParentCategoryID
    GROUP BY PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription 
END
EXEC sp_SelectCategoriesByParentCategoryID 4
SELECT * FROM tbl_Categories
GO

-- Thủ tục lấy các danh mục của cửa hàng (đã có sản phẩm) theo mã cửa hàng --
ALTER PROC sp_GetCategoriesByShopID
    @PK_iShopID INT
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, COUNT(tbl_Products.PK_iProductID) as 'iProductCount', sCategoryDescription
    FROM tbl_Categories
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    WHERE PK_iStoreID = @PK_iShopID
    GROUP BY PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription 
END
EXEC sp_GetCategoriesByShopID 5
GO

-- Thủ tục lấy danh mục theo mã ngành hàng --
ALTER PROC sp_GetCategoriesByIndustryID
    @FK_iIndustryID INT
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sParentCategoryName, sCategoryName, sCategoryImage, sCategoryDescription, tbl_Categories.dCreateTime, tbl_Categories.dUpdateTime
    FROM tbl_Categories
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    WHERE FK_iParentCategoryID = @FK_iIndustryID
END
EXEC sp_GetCategoriesByIndustryID 4
GO

-- Thủ tục thêm danh mục --
ALTER PROC sp_InsertCategory
    @FK_iParentCategoryID INT,
    @sCategoryName NVARCHAR(100),
    @sCategoryImage NVARCHAR(100),
    @sCategoryDescription NVARCHAR(MAX),
    @iIsVisible INT,
    @dCreateTime DATETIME,
    @dUpdateTime DATETIME
AS
BEGIN
    INSERT INTO tbl_Categories (FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription, iIsVisible, dCreateTime, dUpdateTime) 
    VALUES (@FK_iParentCategoryID, @sCategoryName, @sCategoryImage, @sCategoryDescription, @iIsVisible, @dCreateTime, @dUpdateTime)
END
GO

-- Thủ tục xoá danh mục theo mã --
CREATE PROC sp_DelelteCategoryByID
    @PK_iCategoryID INT
AS
BEGIN
    DELETE tbl_Categories where PK_iCategoryID = @PK_iCategoryID
END
GO

-- Thủ tục lấy danh mục theo mã --
CREATE PROC sp_SelectCategoryByID
    @PK_iCategoryID INT
AS
BEGIN
    SELECT * FROM tbl_Categories where PK_iCategoryID = @PK_iCategoryID
END
go

-- Thủ tục cập nhật danh mục--
ALTER PROC sp_UpdateCategoryByID
    @PK_iCategoryID INT,
    @FK_iParentCategoryID INT,
    @sCategoryName NVARCHAR(100),
    @sCategoryImage NVARCHAR(100),
    @sCategoryDescription NVARCHAR(MAX),
    @dUpdateTime DATETIME
AS 
BEGIN
    UPDATE tbl_Categories SET 
    FK_iParentCategoryID = @FK_iParentCategoryID, 
    sCategoryName = @sCategoryName, 
    sCategoryImage = @sCategoryImage, 
    sCategoryDescription = @sCategoryDescription,
    dUpdateTime = @dUpdateTime
    WHERE PK_iCategoryID = @PK_iCategoryID
END
GO

-------------------------------------------------------- GIẢM GIÁ ------------------------------------------------------------
-- Thủ tục lấy tất cả mức giảm giá --
CREATE PROC sp_GetDiscounts
AS
BEGIN
    SELECT PK_iDiscountID, dPerDiscount FROM tbl_Discounts
END
GO

-------------------------------------------------------- VẬN CHUYỂN ------------------------------------------------------------
CREATE PROC sp_GetTransportPrice
AS
BEGIN
    SELECT PK_iTransportID, sTransportName, sTransportPriceSub, dTransportPrice FROM tbl_Transports
END
GO
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
    SELECT PK_iProductID, FK_iStoreID, tbl_Categories.FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    ORDER BY tbl_Products.dCreateTime DESC
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
ALTER PROC sp_SearchCategoryByKeyword
    @sKeyword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription , COUNT(tbl_Products.PK_iProductID) as 'iProductCount' 
    FROM tbl_Categories 
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Products ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
    WHERE sCategoryName LIKE N'%' + @sKeyword + '%'
    GROUP BY PK_iCategoryID, FK_iParentCategoryID, sCategoryName, sCategoryImage, sCategoryDescription
END
EXEC sp_SearchCategoryByKeyword N'T'
GO

-- Thủ tục lấy sản phẩm theo mã danh mục (nếu là quyền là user thì một số sản phẩm sẽ không hiển thị --
ALTER PROC sp_SelectProductsByCategoryID
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, tbl_Categories.FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iCategoryID = @FK_iCategoryID AND tbl_Products.iIsVisible = 1
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByCategoryID 1
GO

-- Thủ tục lấy sản phẩm theo mã danh mục cha (nếu là quyền là user thì một số sản phẩm sẽ không hiển thị --
ALTER PROC sp_SelectProductsByParentCategoryID
    @FK_iParentCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, tbl_Categories.FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE tbl_Categories.FK_iParentCategoryID = @FK_iParentCategoryID AND tbl_Products.iIsVisible = 1
END
SELECT * FROM tbl_Categories
EXEC sp_SelectProductsByParentCategoryID 4
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
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iCategoryID = @FK_iCategoryID ORDER BY (dPrice) ASC
END
EXEC sp_SelectProductsByCategoryIDAndSortIncre 2
GO

-- Thủ tục lấy sản phẩm theo mã ngành hàng và sắp xếp theo giá tăng dần --
ALTER PROC sp_GetProductsByIndustryIDAndSortIncre
    @FK_iIndustryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iParentCategoryID = @FK_iIndustryID ORDER BY (dPrice) ASC
END
EXEC sp_GetProductsByIndustryIDAndSortIncre 4
GO

-- Thủ tục lấy sản phẩm theo mã cửa hàng và sắp xếp theo giá tăng dần --
CREATE PROC sp_GetProductsByShopIDAndSortIncre
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iStoreID = @FK_iShopID ORDER BY (dPrice) ASC
END
EXEC sp_GetProductsByShopIDAndSortIncre 5
GO

-- Thủ tục lấy 12 sản phẩm và sắp xếp theo giá tăng dần --
ALTER PROC sp_Get12ProductsAndSortIncre
AS
BEGIN
    SELECT TOP(12) 
    PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    ORDER BY (dPrice) ASC
END
EXEC sp_Get12ProductsAndSortIncre
GO

-- Thủ tục lấy sản phẩm theo mã danh mục và sắp xếp theo giá giảm dần--
ALTER PROC sp_SelectProductsByCategoryIDAndSortReduce
    @FK_iCategoryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iCategoryID = @FK_iCategoryID ORDER BY (dPrice) DESC
END
EXEC sp_SelectProductsByCategoryIDAndSortReduce 1
GO

-- Thủ tục lấy sản phẩm theo mã ngành hàng và sắp xếp theo giá giảm dần--
CREATE PROC sp_GetProductsByIndutryIDAndSortReduce
    @FK_iIndustryID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iParentCategoryID = @FK_iIndustryID ORDER BY (dPrice) DESC
END
EXEC sp_GetProductsByIndutryIDAndSortReduce 4
GO

-- Thủ tục lấy sản phẩm theo mã cửa hàng và sắp xếp theo giá giảm dần--
CREATE PROC sp_GetProductsByShopIDAndSortReduce
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE FK_iStoreID = @FK_iShopID ORDER BY (dPrice) DESC
END
EXEC sp_GetProductsByShopIDAndSortReduce 5
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
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE sCategoryName LIKE N'%' + @sKeyword +  '%' OR sProductName LIKE N'%' + @sKeyword  + '%'
END
EXEC sp_SearchProductsByKeyword 'Tai nghe Xiaomi Mi Basic'
GO

-- Thủ tục tìm kiếm sản phẩm theo mã danh mục hoặc tên sản phẩm theo mã cửa hàng --
ALTER PROC sp_SearchProductsByKeywordAndShopID
    @FK_iStoreID INT,
    @sKeyword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sStoreName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, tbl_Products.dCreateTime, tbl_Products.dUpdateTime, sTransportName, dTransportPrice 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE sCategoryName LIKE N'%' + @sKeyword +  '%' OR sProductName LIKE N'%' + @sKeyword  + '%' AND FK_iStoreID = @FK_iStoreID
END
EXEC sp_SearchProductsByKeywordAndShopID 5, 'c'
GO

-- Thủ tục lấy sản phẩm theo mã (ID)--
ALTER PROC sp_SelectProductByID
    @PK_iProductID INT
AS
BEGIN
    SELECT PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, iQuantity, sStoreName, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, sTransportName, dTransportPrice, tbl_Products.dCreateTime, tbl_Products.dUpdateTime 
    FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    WHERE PK_iProductID = @PK_iProductID
END
EXEC sp_SelectProductByID 1
GO

-----Thủ tục thêm sản phẩm sản phẩm -----
ALTER PROC sp_InsertProduct
    @FK_iStoreID INT,
    @FK_iCategoryID INT,
    @FK_iDiscountID INT,
    @FK_iTransportID INT,
    @sProductName NVARCHAR(100),
    @iQuantity INT,
    @sProductDescription NVARCHAR(MAX),
    @sImageUrl NVARCHAR(100),
    @dPrice FLOAT,
    @iIsVisible INT,
    @dCreateTime DATETIME,
    @dUpdateTime DATETIME
AS
BEGIN
    INSERT INTO tbl_Products (FK_iStoreID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sProductName, iQuantity, sProductDescription, sImageUrl, dPrice, iIsVisible, dCreateTime, dUpdateTime) 
    VALUES (
        @FK_iStoreID,
        @FK_iCategoryID, 
        @FK_iDiscountID,
        @FK_iTransportID,
        @sProductName,
        @iQuantity,
        @sProductDescription,
        @sImageUrl,
        @dPrice,
        @iIsVisible,
        @dCreateTime,
        @dUpdateTime
    )
END
GO

-----Thủ tục cập nhật lại thông tin sản phẩm -----
ALTER PROC sp_UpdateProduct
    @PK_iProductID INT,
    @FK_iStoreID INT,
    @FK_iCategoryID INT,
    @FK_iDiscountID INT,
    @FK_iTransportID INT,
    @sProductName NVARCHAR(100),
    @iQuantity INT,
    @sProductDescription NVARCHAR(MAX),
    @sImageUrl NVARCHAR(100),
    @dPrice FLOAT,
    @iIsVisible INT,
    @dUpdateTime DATETIME
AS
BEGIN
    UPDATE tbl_Products 
    SET 
        FK_iStoreID = @FK_iStoreID,
        FK_iCategoryID = @FK_iCategoryID, 
        FK_iDiscountID = @FK_iDiscountID, 
        FK_iTransportID = @FK_iTransportID,
        sProductName = @sProductName,
        iQuantity = @iQuantity,
        sProductDescription = @sProductDescription,
        sImageUrl = @sImageUrl,
        dPrice = @dPrice,
        iIsVisible = @iIsVisible,
        dUpdateTime = @dUpdateTime
    WHERE PK_iProductID = @PK_iProductID
END
SELECT * FROM tbl_Products
GO

-- Thủ tục kiểm tra xem sản phẩm có trong giỏ hàng không -- 
ALTER PROC sp_CheckProductInCart 
    @PK_iProductID INT
AS  
BEGIN
    SELECT tbl_Products.PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, tbl_Products.iQuantity, sStoreName, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, sTransportName, dTransportPrice, tbl_Products.dCreateTime, tbl_Products.dUpdateTime FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    INNER JOIN tbl_CartDetails ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    WHERE tbl_CartDetails.PK_iProductID = @PK_iProductID
END
EXEC sp_CheckProductInCart 50
GO

-- Thủ tục kiểm tra xem sản phẩm có trong đơn hàng không -- 
ALTER PROC sp_CheckProductInOrder 
    @PK_iProductID INT
AS  
BEGIN
    SELECT tbl_Products.PK_iProductID, FK_iStoreID, FK_iParentCategoryID, FK_iCategoryID, FK_iDiscountID, FK_iTransportID, sParentCategoryName, sCategoryName, sProductName, sImageUrl, sProductDescription, dPrice, tbl_Products.iQuantity, sStoreName, tbl_Products.iIsVisible as 'iIsVisible', dPerDiscount, sTransportName, dTransportPrice, tbl_Products.dCreateTime, tbl_Products.dUpdateTime FROM tbl_Products 
    INNER JOIN tbl_Categories ON tbl_Products.FK_iCategoryID = tbl_Categories.PK_iCategoryID
	INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Discounts ON tbl_Products.FK_iDiscountID = tbl_Discounts.PK_iDiscountID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID
    INNER JOIN tbl_OrderDetails ON tbl_OrderDetails.PK_iProductID = tbl_Products.PK_iProductID
    WHERE tbl_OrderDetails.PK_iProductID = @PK_iProductID
END
EXEC sp_CheckProductInOrder 50
GO

-- Thủ tục xoá sản phẩm bằng mã --
CREATE PROC sp_DeleteProductByID
    @PK_iProductID INT
AS
BEGIN
    DELETE tbl_Products WHERE PK_iProductID = @PK_iProductID
END
GO

-------------------------------------------------------- YÊU THÍCH SẢN PHẨM -------------------------------------------------------------------------
-- Thủ tục thêm sản phẩm yêu thích --
CREATE PROC sp_InsertFavorite
    @FK_iUserID INT,
    @FK_iProductID INT
AS
BEGIN
    INSERT INTO tbl_Favorites (FK_iUserID, FK_iProductID, bFavorite) VALUES (@FK_iUserID, @FK_iProductID, 1)
END
GO

-- Thủ tục xoá sản phẩm yêu thích --
CREATE PROC sp_DeleteFavorite
    @FK_iUserID INT,
    @FK_iProductID INT
AS
BEGIN
    DELETE tbl_Favorites WHERE FK_iUserID = @FK_iUserID AND FK_iProductID = @FK_iProductID
END
GO

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

-- Thủ tục lấy yêu thích sản phẩm với mã sản phẩm --
ALTER PROC sp_GetFavoritesByProductID
    @FK_iProductID INT
AS
BEGIN
    SELECT PK_iFavoriteID, FK_iProductID, FK_iUserID, bFavorite
    FROM tbl_Favorites
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_Favorites.FK_iProductID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Favorites.FK_iUserID
    WHERE FK_iProductID = @FK_iProductID
END
EXEC sp_GetFavoritesByProductID 2
GO

-- Thủ tục lấy yêu thích sản phẩm với mã sản phẩm, mã tài khoản --
CREATE PROC sp_GetFavoritesByProductIDAndUserID
    @FK_iProductID INT,
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iFavoriteID, FK_iProductID, FK_iUserID, bFavorite
    FROM tbl_Favorites
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_Favorites.FK_iProductID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Favorites.FK_iUserID
    WHERE FK_iProductID = @FK_iProductID AND FK_iUserID = @FK_iUserID
END
EXEC sp_GetFavoritesByProductIDAndUserID 2, 10
GO

-------------------------------------------------------- BÌNH LUÂN, ĐÁNH GIÁ SẢN PHẨM ------------------------------------------------------
-- Thêm bình luận đánh giá sản phẩm --
ALTER PROC sp_InsertProductReviewer
    @FK_iUserID INT,
    @FK_iProductID INT,
    @iStar INT,
    @sComment NVARCHAR(MAX),
    @sReviewerImage NVARCHAR(100),
    @dCreateTime DATETIME,
    @dUpdateTime DATETIME
AS
BEGIN
    INSERT INTO tbl_Reviewers (FK_iUserID, FK_iProductID, iStars, sComment, sReviewerImage, dCreateTime, dUpdateTime) VALUES 
    (@FK_iUserID, @FK_iProductID, @iStar, @sComment, @sReviewerImage, @dCreateTime, @dUpdateTime)
END
GO

-- Thủ tục lấy đánh giá bình luận theo mã sản phẩm -- 
ALTER PROC sp_GetReviewerByProductID
    @FK_iProductID INT
AS
BEGIN
    SELECT PK_iReviewID, tbl_Reviewers.FK_iUserID, FK_iProductID, sUserName, sImageProfile,  sCategoryName, iStars, sComment, tbl_Reviewers.dCreateTime, tbl_Reviewers.dUpdateTime, sReviewerImage FROM tbl_Reviewers 
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Reviewers.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_Reviewers.FK_iProductID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE FK_iProductID = @FK_iProductID
END
EXEC sp_GetReviewerByProductID 46
GO

-- Thủ tục lấy đánh giá bình luận theo mã đánh giá -- 
CREATE PROC sp_GetReviewerByID
    @PK_iReviewerID INT
AS
BEGIN
    SELECT PK_iReviewID, tbl_Reviewers.FK_iUserID, FK_iProductID, sUserName, sImageProfile,  sCategoryName, iStars, sComment, tbl_Reviewers.dCreateTime, tbl_Reviewers.dUpdateTime, sReviewerImage FROM tbl_Reviewers 
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Reviewers.FK_iUserID 
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_Reviewers.FK_iProductID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    WHERE PK_iReviewID = @PK_iReviewerID
END
EXEC sp_GetReviewerByID 4
GO

-- Thủ tục cập nhật đánh giá bình luận -- 
CREATE PROC sp_UpdateReviewer
    @PK_iReviewerID INT,
    @FK_iUserID INT,
    @FK_iProductID INT,
    @iStar INT,
    @sComment NVARCHAR(MAX),
    @dUpdateTime DATETIME,
    @sReviewerImage NVARCHAR(100)
AS  
BEGIN
    UPDATE tbl_Reviewers SET FK_iUserID = @FK_iUserID, FK_iProductID = @FK_iProductID, iStars = @iStar, sComment = @sComment, dUpdateTime = @dUpdateTime, sReviewerImage = @sReviewerImage WHERE PK_iReviewID = @PK_iReviewerID
END
GO

-- Thủ tục xoá đánh giá bình luận -- 
CREATE PROC sp_DeleteReviewer
    @PK_iReviewerID INT
AS
BEGIN
    DELETE tbl_Reviewers WHERE PK_iReviewID = @PK_iReviewerID
END
GO

-------------------------------------------------------- TÀI KHOẢN -------------------------------------------------------------------------
-- Thủ tục lấy tất cả tài khoản -- 
CREATE PROC sp_GetUsers 
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
END
EXEC sp_GetUsers
GO
-- Thủ tục kiểm tra xem email tài khoản đã đăng ký hay chưa
ALTER PROC sp_CheckEmailUserIsRegis
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE sEmail = @sEmail
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
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE PK_iUserID = @PK_iUserID
END
EXEC sp_CheckUserLogin 1
SELECT * FROM tbl_Users
GO
------------------------------------------------------

--- Thủ tục đăng nhập tài khoản---
ALTER PROC sp_LoginEmailAndPassword
    @sEmail NVARCHAR(100),
    @sPassword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE sEmail = @sEmail and sPassword = @sPassword
END
EXEC sp_LoginEmailAndPassword 'dangvancong2301@gmail.com', '2KUztBcegH4='
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
ALTER PROC sp_GetPasswordAccountByEmail
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE sEmail = @sEmail
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
ALTER PROC sp_GetUserIDAccountByEmail
    @sEmail NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE sEmail = @sEmail
END
EXEC sp_GetUserIDAccountByEmail 'vinh@gmail.com'
GO

-- Thủ tục lấy mã tài khoản với mã và mật khẩu --
CREATE PROC sp_GetUserByIDAndPassword
    @PK_iUserID INT,
    @sPassword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserID, FK_iRoleID, sEmail, dCreateTime, sPassword, sUserName, sName as 'sRoleName', sDescription as 'sRoleDescription' FROM tbl_Users
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID 
    WHERE PK_iUserID = @PK_iUserID AND sPassword = @sPassword
END
EXEC sp_GetUserByIDAndPassword 1, 'jNf5bbOGFps='
GO
------------------------------------------------------
-------------------------------------------------------- THÔNG TIN TÀI KHOẢN -------------------------------------------------------------------------
--- Thủ tục lấy ra tất cả tài khoản người dùng ---
ALTER PROC sp_GetUsersInfo
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sDescription, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile, iIsLock FROM tbl_Users_Info 
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID 
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID
END
EXEC sp_GetUsersInfo
GO
--- Thủ tục kiểm tra thông tin tài khoản người dùng có hay chưa ---
ALTER PROC sp_CheckUserInfoByUserID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sDescription, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile, iIsLock FROM tbl_Users_Info 
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID 
    INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID
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
    @sImageProfile NVARCHAR(100),
	@iIsLock INT
AS
BEGIN 
    SET DATEFORMAT dmy INSERT INTO tbl_Users_Info (FK_iUserID, sFullName, iGender, dDateBirth, dUpdateTime, sImageProfile, iIsLock) VALUES (@FK_iUserID, @sFullName, @iGender, @dDateBirth, @dUpdateTime, @sImageProfile, @iIsLock)
END
SET DATEFORMAT dmy EXEC sp_InsertUserInfo 7, N'Nguyễn Thị Vinh', 0, '20/2/2002', '9/9/2024', 'no_user.jpg', 0
DELETE tbl_Users_Info WHERE PK_iUserInfoID = 15
GO
--- Thủ tục lấy thông tin tài khoản bằng mã ---
ALTER PROC sp_GetUserInfoByID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sDescription, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile, iIsLock FROM tbl_Users_Info
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
	INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID
    WHERE PK_iUserID = @FK_iUserID
END
EXEC sp_GetUserInfoByID 7
GO

--- Thủ tục lấy thông tin tài với email ---
ALTER PROC sp_GetUserInfoByEmailAndPassword
    @sEmail NVARCHAR(100),
    @sPassword NVARCHAR(100)
AS
BEGIN
    SELECT PK_iUserInfoID, FK_iUserID, sDescription, sUserName, sFullName, sEmail, dDateBirth, dUpdateTime, iGender, sImageProfile, iIsLock 
    FROM tbl_Users_Info
    INNER JOIN tbl_Users ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
	INNER JOIN tbl_Roles ON tbl_Roles.PK_iRoleID = tbl_Users.FK_iRoleID
    WHERE sEmail = @sEmail AND sPassword = @sPassword
END
-- Đổi tên
EXEC sp_rename 'sp_GetUserInfoByEmail', 'sp_GetUserInfoByEmailAndPassword'
EXEC sp_GetUserInfoByEmailAndPassword 'cong@gmail.com', 'blTZtVelANJlvELixLaWGw=='
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
ALTER PROC sp_UpdateAddressAccountUserByID
    @FK_iUserID INT,
    @sFullName NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_Users_Info SET sFullName = @sFullName WHERE FK_iUserID = @FK_iUserID
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
ALTER PROC sp_GetAddressAccountByID
    @PK_iAddressID INT,
    @FK_iUserID INT
AS 
BEGIN
    SELECT PK_iAddressID, tbl_Addresses.FK_iUserID, tbl_Users_Info.sFullName, sPhone, sAddress, iDefault 
    FROM tbl_Addresses 
    INNER JOIN tbl_Users ON tbl_Addresses.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    WHERE tbl_Addresses.PK_iAddressID = @PK_iAddressID AND tbl_Addresses.FK_iUserID = @FK_iUserID
END
EXEC sp_GetAddressAccountByID 1014, 25
GO

--Thủ tục lấy địa chỉ người dùng với mã đơn hàng --
CREATE PROC sp_GetAddressAccountByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iAddressID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, sPhone, sAddress, iDefault FROM tbl_Addresses
    INNER JOIN tbl_Orders ON tbl_Orders.FK_iUserID = tbl_Addresses.FK_iUserID
	INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Orders.FK_iUserID
    WHERE PK_iOrderID = @PK_iOrderID AND iDefault = 1
END
EXEC sp_GetAddressAccountByOrderID 1
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
    INNER JOIN tbl_Parent_Categories ON tbl_Parent_Categories.PK_iParentCategoryID = tbl_Categories.FK_iParentCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Carts ON tbl_CartDetails.PK_iCartID = tbl_Carts.PK_iCartID
    INNER JOIN tbl_Transports ON tbl_Products.FK_iTransportID = tbl_Transports.PK_iTransportID
    WHERE tbl_Users.PK_iUserID = @PK_iUserID    
END
EXEC sp_GetInfoCart 1
GO   

-----Thủ tục lấy thông tin sản phẩm giỏ hàng theo mã tài khoản, mã sản phẩm-----
ALTER PROC sp_GetInfoCartByProductID
    @PK_iUserID INT,
    @PK_iProductID INT
AS
BEGIN
    SELECT tbl_Products.PK_iProductID, tbl_Stores.PK_iStoreID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_CartDetails.iQuantity, tbl_CartDetails.dUnitPrice, tbl_CartDetails.dDiscount, tbl_CartDetails.dMoney, tbl_Transports.dTransportPrice 
    FROM tbl_CartDetails 
    INNER JOIN tbl_Users ON tbl_CartDetails.PK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_Products ON tbl_CartDetails.PK_iProductID = tbl_Products.PK_iProductID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
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
EXEC sp_DeleteProductInCart 1, 2 
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
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
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
EXEC sp_InsertPaymentsType 1, 24
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
    SELECT PK_iPaymentTypeID, PK_iPaymentID,  sPaymentName, sPaymentImage FROM tbl_PaymentsType 
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID 
    WHERE tbl_PaymentsType.iUserID = @iUserID
END
EXEC sp_GetPaymentsTypeByUserID 10
GO

-- Thủ tục lấy phương thức thanh toán của tài khoản theo mã đơn hàng
ALTER PROC sp_GetPaymentsTypeByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iPaymentTypeID, PK_iPaymentID,  sPaymentName, sPaymentImage FROM tbl_PaymentsType 
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID 
    INNER JOIN tbl_Orders ON tbl_Orders.FK_iPaymentTypeID = tbl_PaymentsType.PK_iPaymentTypeID
    WHERE PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetPaymentsTypeByOrderID 1004
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
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
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

-----Thủ tục lấy đơn hàng theo mã đơn hàng -----
ALTER PROC sp_GetOrderByOrderID
   @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetOrderByOrderID 2
GO

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái chờ thanh toán -----
ALTER PROC sp_GetOrderByUserIDWaitSettlement
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
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

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái đang vận chuyển theo mã tài khoản -----
ALTER PROC sp_GetOrderByUserIDTransiting
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = 15
END
EXEC sp_GetOrderByUserIDTransiting 2
GO

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái chờ giao hàng mã tài khoản -----
ALTER PROC sp_GetOrderByUserIDWaitDelivery
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = 6
END
EXEC sp_GetOrderByUserIDWaitDelivery 1
GO

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái đã giao hàng -----
ALTER PROC sp_GetOrderByUserIDDelivered
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND (tbl_Order_Status.iOrderStatusCode = 3 OR tbl_Order_Status.iOrderStatusCode = 14)
END
EXEC sp_rename 'sp_GetOrderByUserIDDeliverd', 'sp_GetOrderByUserIDDelivered'
EXEC sp_GetOrderByUserIDDelivered 27
GO

-----Thủ tục lấy đơn hàng theo mã người dùng ở trạng thái huỷ -----
CREATE PROC sp_GetOrderByUserIDDestroy
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Orders.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = -1
END
EXEC sp_GetOrderByUserIDDestroy 27
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ xác nhận -- 
ALTER PROC sp_GetOrderWaitSettlement
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
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

-- Thủ tục lấy tất cả đơn hàng ở trạng thái lấy hàng -- 
ALTER PROC sp_GetOrderWaitPickup
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
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

-- Thủ tục lấy tất cả đơn hàng ở trạng thái đang lấy hàng -- 
ALTER PROC sp_GetOrderPickingUp
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 5
END
EXEC sp_GetOrderPickingUp
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái đang giao hàng -- 
ALTER PROC sp_GetOrderDelivering
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 6
END
EXEC sp_GetOrderDelivering
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái đã hoàn thành -- 
ALTER PROC sp_GetOrderCompleted
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 3 OR tbl_Order_Status.iOrderStatusCode = 14
END
EXEC sp_GetOrderCompleted
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ xác nhận theo mã cửa hàng -- 
ALTER PROC sp_GetOrderWaitSettlementByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 0 AND FK_iShopID = @FK_iShopID
END
EXEC sp_GetOrderWaitSettlementByShopID 1
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ lấy hàng theo mã cửa hàng -- 
ALTER PROC sp_GetOrderWaitPickupByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE tbl_Order_Status.iOrderStatusCode = 4 AND FK_iShopID = @FK_iShopID
END
	
GO

-- Thủ tục lấy đơn hàng ở trạng thái chờ lấy hàng theo mã đơn giao-- 
ALTER PROC sp_GetOrderWaitPickupByShippingOrderID
    @PK_iShippingOrderID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName FROM tbl_Orders
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingOrders.FK_iOrderStatusID
    WHERE tbl_Order_Status.iOrderStatusCode = 4 AND PK_iShippingOrderID = @PK_iShippingOrderID
END
EXEC sp_GetOrderWaitPickupByShippingOrderID 8
GO

-- Thủ tục lấy đơn hàng ở trạng thái chờ xác nhận với mã đơn hàng -- 
ALTER PROC sp_GetOrderWaitSettlementByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
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

-- Thủ tục lấy đơn hàng ở trạng thái chờ lấy hàng với mã đơn hàng -- 
ALTER PROC sp_GetOrderWaitDeliveryByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetOrderWaitDeliveryByOrderID 1005
GO

-- Thủ tục lấy đơn hàng ở trạng thái đã xử lý/chờ giao hàng với mã cửa hàng -- 
ALTER PROC sp_GetOrderProcessedByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iOrderID, tbl_Orders.FK_iUserID, FK_iOrderStatusID, FK_iPaymentTypeID, FK_iShopID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName
    FROM tbl_Orders 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    WHERE PK_iStoreID = @FK_iShopID AND tbl_Order_Status.iOrderStatusCode = 2
END
-- Đổi tên
EXEC sp_rename 'sp_GetOrderProcessedByShippingOrderID', 'sp_GetOrderProcessedByShopID'
EXEC sp_GetOrderProcessedByShopID 3
GO

-- Thủ tục xác nhận đơn hàng về chờ lấy hàng  --
CREATE PROC sp_ConfirmOrderAboutWaitPickup
    @PK_iOrderID INT,
    @PK_iUserID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 6 WHERE PK_iOrderID = @PK_iOrderID AND FK_iUserID = @PK_iUserID
END
EXEC sp_rename 'sp_ConfirmOrderAboutPickup', 'sp_ConfirmOrderAboutTransiting'
GO

-- Thủ tục xác nhận đơn hàng về đang vận chuyển --
ALTER PROC sp_ConfirmOrderAboutTransiting
    @PK_iOrderID INT,
    @PK_iUserID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 17 WHERE PK_iOrderID = @PK_iOrderID AND FK_iUserID = @PK_iUserID
END
EXEC sp_rename 'sp_ConfirmOrderAboutPickup', 'sp_ConfirmOrderAboutTransiting'
GO

-- Thủ tục xác nhận đơn hàng về đang lấy hàng --
CREATE PROC sp_ConfirmOrderAboutPickingUp
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 7 WHERE PK_iOrderID = @PK_iOrderID
END
GO

-- Thủ tục xác nhận đơn hàng về đã lấy hàng --
CREATE PROC sp_ConfirmOrderAboutTakenGoods
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 9 WHERE PK_iOrderID = @PK_iOrderID
END
GO

-- Thủ tục xác nhận đơn hàng về chờ giao hàng --
CREATE PROC sp_ConfirmOrderAboutWaitDelivery
    @PK_iOrderID INT,
    @PK_iUserID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 4 WHERE PK_iOrderID = @PK_iOrderID AND FK_iUserID = @PK_iUserID
END
GO

-- Thủ tục xác nhận đơn hàng về đang giao hàng --
CREATE PROC sp_ConfirmOrderAboutWaitDelivering
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 8 WHERE PK_iOrderID = @PK_iOrderID
END
GO

-- Thủ tục xác nhận đơn hàng về đã giao hàng --
ALTER PROC sp_ConfirmOrderAboutDelivered
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 5 WHERE PK_iOrderID = @PK_iOrderID
END
GO

-- Thủ tục xác nhận đơn hàng về đã nhận hàng --
CREATE PROC sp_ConfirmOrderAboutReceived
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 16 WHERE PK_iOrderID = @PK_iOrderID
END
GO

-- Thủ tục xác nhận đơn hàng về trạng thái huỷ --
CREATE PROC sp_ConfirmOrderAboutDestroy
    @PK_iOrderID INT
AS
BEGIN
    UPDATE tbl_Orders SET FK_iOrderStatusID = 1 WHERE PK_iOrderID = @PK_iOrderID
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
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID
    ORDER BY tbl_Orders.dDate DESC
END
EXEC sp_GetProductsOrderByUserID 1
SELECT * FROM tbl_OrderDetails
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản, mã đơn hàng -----
ALTER PROC sp_GetProductsOrderByOrderID
    @PK_iOrderID INT,
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
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
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Order_Status.iOrderStatusCode = 0
END
EXEC sp_GetProductsOrderByUserIDWaitSettlement 1
SELECT * FROM tbl_Order_Status
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản theo trạng đang giao -----
ALTER PROC sp_GetProductsOrderByUserIDTransiting
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Order_Status.iOrderStatusCode = 15
END
EXEC sp_GetProductsOrderByUserIDTransiting 1
SELECT * FROM tbl_Order_Status
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản theo trạng thái đang giao hàng -----
ALTER PROC sp_GetProductsOrderByUserIDDelivering
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Order_Status.iOrderStatusCode = 6
END
EXEC sp_GetProductsOrderByUserIDDelivering 1
SELECT * FROM tbl_Order_Status
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản theo trạng đã giao hàng -----
ALTER PROC sp_GetProductsOrderByUserIDDelivered
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND (tbl_Order_Status.iOrderStatusCode = 3 OR tbl_Order_Status.iOrderStatusCode = 14)
END
EXEC sp_GetProductsOrderByUserIDDelivered 27
SELECT * FROM tbl_Order_Status
SELECT * FROM tbl_Orders
GO

-----Thủ tục lấy sản phẩm chi tiết đơn hàng theo mã tài khoản theo trạng đã huỷ -----
CREATE PROC sp_GetProductsOrderByUserIDDestroy
    @PK_iUserID INT
AS  
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.FK_iUserID = @PK_iUserID AND tbl_Order_Status.iOrderStatusCode = -1 
END
EXEC sp_GetProductsOrderByUserIDDestroy 27
GO

-- Thủ tục lấy chi tiết đơn hàng theo mã ở trạng thái chờ xác nhận --
ALTER PROC sp_GetOrderDetailByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID
END
-- Đổi tên
EXEC sp_rename 'sp_GetOrderDetailWaitSettlementByOrderID', 'sp_GetOrderDetailByOrderID'
EXEC sp_GetOrderDetailByOrderID 2
GO

-- Thủ tục lấy chi tiết đơn hàng theo mã ở trạng thái chờ lấy hàng --
ALTER PROC sp_GetOrderDetailWaitPickupByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID
END
EXEC sp_GetOrderDetailWaitPickupByOrderID 1005
GO

-- Thủ tục lấy chi tiết đơn hàng theo mã ở trạng thái đang lấy hàng --
ALTER PROC sp_GetOrderDetailPickingUpByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 5
END
EXEC sp_GetOrderDetailPickingUpByOrderID 1005
GO

-- Thủ tục lấy chi tiết đơn vận giao theo mã --
ALTER PROC sp_GetOrderDetailShippingDeliveryByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_ShippingPickers ON tbl_ShippingPickers.FK_iShippingOrderID = tbl_ShippingOrders.PK_iShippingOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID
END
-- Đổi tên
EXEC sp_rename 'sp_GetOrderDetailWaitDeliveryByOrderID', 'sp_GetOrderDetailShippingDeliveryByOrderID'
EXEC sp_GetOrderDetailShippingDeliveryByOrderID 1005
GO 

-- Thủ tục lấy chi tiết đơn vận theo mã --
ALTER PROC sp_GetOrderDetailShippingOrderByOrderID
    @PK_iOrderID INT
AS
BEGIN
    SELECT tbl_Orders.PK_iOrderID, tbl_Products.PK_iProductID, tbl_Products.sImageUrl, tbl_Products.sProductName, tbl_Stores.sStoreName, tbl_OrderDetails.iQuantity, tbl_OrderDetails.dUnitPrice, tbl_Discounts.dPerDiscount, tbl_OrderDetails.dMoney, tbl_Transports.dTransportPrice, tbl_Order_Status.iOrderStatusCode, sOrderStatusName, tbl_Orders.dDate 
    FROM tbl_OrderDetails
    INNER JOIN tbl_Products ON tbl_Products.PK_iProductID = tbl_OrderDetails.PK_iProductID
    INNER JOIN tbl_Transports ON tbl_Transports.PK_iTransportID = tbl_Products.FK_iTransportID 
    INNER JOIN tbl_Discounts ON tbl_Discounts.PK_iDiscountID = tbl_Products.FK_iDiscountID
    INNER JOIN tbl_Categories ON tbl_Categories.PK_iCategoryID = tbl_Products.FK_iCategoryID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Products.FK_iStoreID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_OrderDetails.PK_iOrderID 
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingOrders.FK_iOrderStatusID
    WHERE tbl_Orders.PK_iOrderID = @PK_iOrderID
END
-- Đổi tên
EXEC sp_GetOrderDetailShippingOrderByOrderID 1005
GO

-------------------------------------------------------- ĐƠN VẬN ------------------------------------------------------------
-- Thủ tục tạo đơn hàng giao --
ALTER PROC sp_InsertShippingOrder
    @FK_iShippingUnitID INT,
    @FK_iOrderID INT,
    @FK_iOrderStatusID INT,
    @ShippingTime DATETIME
AS
BEGIN
    INSERT INTO tbl_ShippingOrders (FK_iShippingUnitID, FK_iOrderID, FK_iOrderStatusID, dShippingTime) VALUES (@FK_iShippingUnitID, @FK_iOrderID, @FK_iOrderStatusID, @ShippingTime)
END
SET DATEFORMAT dmy EXEC sp_InsertShippingOrder 1, 1002, '26/9/2024'
GO

-- Thủ tục lấy tất cả đơn vận -- 
ALTER PROC sp_GetShippingOrders
AS
BEGIN
    SELECT PK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingOrders.dShippingTime, sShippingUnitName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
END
EXEC sp_GetShippingOrders
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái chờ lấy hàng -- 
ALTER PROC sp_GetShippingOrderWaitPickup
AS
BEGIN
    SELECT PK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingOrders.dShippingTime, sShippingUnitName FROM tbl_ShippingOrders
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingOrders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_Order_Status.iOrderStatusCode = 4
END
EXEC sp_rename 'sp_GetOrderWaitPickup', 'sp_GetShippingOrderWaitPickup'
EXEC sp_GetShippingOrderWaitPickup
GO

-- Thủ tục lấy đơn vận giao theo mã đơn hàng trạng thái chờ lấy -- 
ALTER PROC sp_GetShippingOrderByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingOrders.dShippingTime, sShippingUnitName FROM tbl_ShippingOrders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingOrders.FK_iOrderStatusID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE FK_iOrderID = @FK_iOrderID
END
EXEC sp_GetShippingOrderByOrderID 1005
GO

-- Thủ tục lấy đơn hàng giao theo mã  -- 
ALTER PROC sp_GetShippingOrderByID
    @PK_iShippingOrderID INT
AS
BEGIN
    SELECT PK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingOrders.dShippingTime, sShippingUnitName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE PK_iShippingOrderID = @PK_iShippingOrderID
END
EXEC sp_GetShippingOrderByID 1
GO

-- Thủ tục lấy tất cả đơn hàng giao theo mã cửa hang --
ALTER PROC sp_GetShippingOrderByShopID
    @FK_iShopID INT
AS
BEGIN
    SELECT PK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_ShippingOrders.FK_iOrderStatusID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingOrders.dShippingTime, sShippingUnitName FROM tbl_Orders
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_Orders.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.FK_iOrderID = tbl_Orders.PK_iOrderID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE FK_iShopID = @FK_iShopID
END
EXEC sp_GetShippingOrderByShopID 5
GO

-- Thủ tục xác nhận đơn hàng giao về chờ người giao đên lấy hàng --
CREATE PROC sp_ConfirmShippingOrderAboutWaitPickerTake
    @PK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingOrders SET FK_iOrderStatusID = 13 WHERE PK_iShippingOrderID = @PK_iShippingOrderID
END
GO

-- Thủ tục xác nhận đơn hàng giao về đã giao cho đơn vị vận chuyển --
CREATE PROC sp_ConfirmShippingOrderAboutDelivered
    @PK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingOrders SET FK_iOrderStatusID = 12 WHERE PK_iShippingOrderID = @PK_iShippingOrderID
END
GO

-- Thủ tục xác nhận đơn hàng giao về đã giao hàng tới người mua --
CREATE PROC sp_ConfirmShippingOrderAboutDeliveredBuyer
    @PK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingOrders SET FK_iOrderStatusID = 15 WHERE PK_iShippingOrderID = @PK_iShippingOrderID
END
GO

-------------------------------------------------------- ĐƠN VẬN LẤY ------------------------------------------------------------
ALTER PROC sp_InsertShippingPicker
    @FK_iShippingOrderID INT,
    @FK_iOrderStatusID INT,
    @sPickerName NVARCHAR(100),
    @sPickerImage NVARCHAR(100),
    @dShippingPickerTime DATETIME
AS
BEGIN
    INSERT INTO tbl_ShippingPickers (FK_iShippingOrderID, FK_iOrderStatusID, sPickerName, sPickerImage, dShippingPickerTime) VALUES (@FK_iShippingOrderID, @FK_iOrderStatusID, @sPickerName, @sPickerImage, @dShippingPickerTime)
END
SET DATEFORMAT dmy EXEC sp_InsertShippingPicker 1, 1, '12/12/2024'
GO

-- Thủ tục lấy tất cả đơn hàng ở trạng thái đang lấy hàng -- 
ALTER PROC sp_GetShippingPickerPickingUp
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_Order_Status.iOrderStatusCode = 5 OR tbl_Order_Status.iOrderStatusCode = 7 OR tbl_Order_Status.iOrderStatusCode = 8
END
EXEC sp_rename 'sp_GetOrderWaitPickingUp', 'sp_GetShippingPickerPickingUp'
EXEC sp_GetShippingPickerPickingUp
GO

-- Thủ tục lấy đơn vận ở trạng thái đã về tổng kho -- 
CREATE PROC sp_GetShippingPickerAboutedWarehouse
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_Order_Status.iOrderStatusCode = 9
END
EXEC sp_GetShippingPickerAboutedWarehouse
GO

-- Thủ tục lấy tất cả đơn vận lấy --
ALTER PROC sp_GetShippingPickers
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
END
EXEC sp_GetShippingPickers
GO

-- Thủ tục lấy đơn vận lấy theo mã --
CREATE PROC sp_GetShippingPickersByID
    @PK_iShippingPicker INT
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE PK_iShippingPickerID = @PK_iShippingPicker
END
EXEC sp_GetShippingPickersByID 1
GO

-- Thủ tục lấy đơn vận lấy theo mã đơn hàng --
CREATE PROC sp_GetShippingPickersByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE FK_iOrderID = @FK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 9
END
EXEC sp_GetShippingPickersByOrderID 1
GO

-- Thủ tục lấy đơn vận lấy theo mã đơn hàng trong trạng thái đã về tổng kho --
CREATE PROC sp_GetShippingPickersAboutWarehouseByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iShippingPickerID, tbl_ShippingPickers.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName, tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingPickers.dShippingPickerTime, sShippingUnitName, tbl_ShippingPickers.sPickerName FROM tbl_ShippingPickers
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingPickers.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingPickers.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE FK_iOrderID = @FK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 9
END
EXEC sp_GetShippingPickersAboutWarehouseByOrderID 1005
GO

-- Thủ tục xác nhận đơn vận lấy về đã lấy hàng --
CREATE PROC sp_ConfirmShippingPickerAboutTaken
    @PK_iShippingPickerID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 9 WHERE PK_iShippingPickerID = @PK_iShippingPickerID
END
GO

-- Thủ tục xác nhận đơn vận lấy về đang về tổng kho --
CREATE PROC sp_ConfirmShippingPickerAboutingWarehouse
    @PK_iShippingPickerID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 10 WHERE PK_iShippingPickerID = @PK_iShippingPickerID
END
GO

-- Thủ tục xác nhận đơn vận lấy về đã về tổng kho --
CREATE PROC sp_ConfirmShippingPickerAboutedWarehouse
    @PK_iShippingPickerID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 11 WHERE PK_iShippingPickerID = @PK_iShippingPickerID
END
GO

-- Cập nhật ảnh giao hàng cho đơn vận lấy --
CREATE PROC sp_UpdatePickerImage
    @PK_iShippingPickerID INT,
    @sPickerImage NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_ShippingPickers SET sPickerImage = @sPickerImage WHERE PK_iShippingPickerID = @PK_iShippingPickerID
END
GO

-- Thủ tục xác nhận đơn vận lấy về chờ người giao đến lấy hàng --
CREATE PROC sp_ConfirmShippingPickerAboutedWaitDeliveryTake
    @FK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 13 WHERE FK_iShippingOrderID = @FK_iShippingOrderID
END
GO

-- Thủ tục xác nhận đơn vận lấy trạng thái người giao đã lấy hàng --
CREATE PROC sp_ConfirmShippingPickerAboutedDeliveryTaken
    @FK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 14 WHERE FK_iShippingOrderID = @FK_iShippingOrderID
END
GO

-- Thủ tục xác nhận đơn vận lấy trạng thái đang giao hàng --
CREATE PROC sp_ConfirmShippingPickerAboutDelivering
    @FK_iShippingOrderID INT
AS
BEGIN
    UPDATE tbl_ShippingPickers SET FK_iOrderStatusID = 8 WHERE FK_iShippingOrderID = @FK_iShippingOrderID
END
EXEC sp_rename 'sp_ConfirmShippingPickerAboutedDelivering', 'sp_ConfirmShippingPickerAboutDelivering'
GO

-------------------------------------------------------- ĐƠN VẬN GIAO ------------------------------------------------------------
-- Thủ tục thêm đơn vận giao --
ALTER PROC sp_InsertShippingDelivery
    @FK_iShippingOrderID INT,
    @FK_iUserID INT,
    @FK_iOrderStatusID INT,
    @sDeliveryImage NVARCHAR(100),
    @sDeliverName NVARCHAR(100),
    @dDeliveryTime DATETIME
AS
BEGIN
    INSERT INTO tbl_ShippingDeliveries (FK_iShippingOrderID, FK_iUserID, FK_iOrderStatusID, sDeliveryImage, sDeliverName, dDeliveryTime) 
    VALUES (@FK_iShippingOrderID, @FK_iUserID, @FK_iOrderStatusID, @sDeliveryImage, @sDeliverName, @dDeliveryTime)
END
GO

-- Thủ tục lấy đơn vận giao theo mã người giao hàng --
ALTER PROC sp_GetShippingDeliveryByDeliverID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iShippingDeliveryID, tbl_ShippingDeliveries.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName as 'sBuyerName', tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingDeliveries.dDeliveryTime, sShippingUnitName, tbl_ShippingDeliveries.sDeliverName FROM tbl_ShippingDeliveries
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingDeliveries.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingDeliveries.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_ShippingDeliveries.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_ShippingDeliveries.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = 16
END
EXEC sp_GetShippingDeliveryByDeliverID 8
GO

-- Thủ tục lấy đơn vận giao theo mã đơn hàng --
ALTER PROC sp_GetShippingDeliveryByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iShippingDeliveryID, tbl_ShippingDeliveries.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName as 'sBuyerName', tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingDeliveries.dDeliveryTime, sShippingUnitName, tbl_ShippingDeliveries.sDeliverName FROM tbl_ShippingDeliveries
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingDeliveries.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingDeliveries.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_ShippingOrders.FK_iOrderID = @FK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 16 OR tbl_Order_Status.iOrderStatusCode = 6
END
EXEC sp_GetShippingDeliveryByOrderID 1005
GO

-- Thủ tục lấy đơn vận giao đã hoàn thành theo mã đơn hàng --
CREATE PROC sp_GetShippingDeliveredByOrderID
    @FK_iOrderID INT
AS
BEGIN
    SELECT PK_iShippingDeliveryID, tbl_ShippingDeliveries.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName as 'sBuyerName', tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingDeliveries.dDeliveryTime, sShippingUnitName, tbl_ShippingDeliveries.sDeliverName FROM tbl_ShippingDeliveries
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingDeliveries.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingDeliveries.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_ShippingOrders.FK_iOrderID = @FK_iOrderID AND tbl_Order_Status.iOrderStatusCode = 13
END
EXEC sp_GetShippingDeliveredByOrderID 1005
GO

-- Thủ tục lấy đơn vận giao đã hoàn thành theo mã người giao hàng --
CREATE PROC sp_GetShippingDeliveryCompleteByDeliverID
    @FK_iUserID INT
AS
BEGIN
    SELECT PK_iShippingDeliveryID, tbl_ShippingDeliveries.FK_iOrderStatusID, FK_iShippingOrderID, FK_iShippingUnitID, FK_iOrderID, tbl_Orders.FK_iUserID, tbl_Users_Info.sFullName as 'sBuyerName', tbl_Stores.sStoreName, dDate, fTotalPrice, tbl_Order_Status.sOrderStatusName, tbl_Payments.sPaymentName,
	tbl_ShippingDeliveries.dDeliveryTime, sShippingUnitName, tbl_ShippingDeliveries.sDeliverName FROM tbl_ShippingDeliveries
    INNER JOIN tbl_ShippingOrders ON tbl_ShippingOrders.PK_iShippingOrderID = tbl_ShippingDeliveries.FK_iShippingOrderID
    INNER JOIN tbl_Orders ON tbl_Orders.PK_iOrderID = tbl_ShippingOrders.FK_iOrderID
    INNER JOIN tbl_Order_Status ON tbl_Order_Status.PK_iOrderStatusID = tbl_ShippingDeliveries.FK_iOrderStatusID
    INNER JOIN tbl_Stores ON tbl_Stores.PK_iStoreID = tbl_Orders.FK_iShopID
    INNER JOIN tbl_Users ON tbl_Users.PK_iUserID = tbl_Orders.FK_iUserID
    INNER JOIN tbl_Users_Info ON tbl_Users_Info.FK_iUserID = tbl_Users.PK_iUserID
    INNER JOIN tbl_PaymentsType ON tbl_PaymentsType.PK_iPaymentTypeID = tbl_Orders.FK_iPaymentTypeID
    INNER JOIN tbl_Payments ON tbl_Payments.PK_iPaymentID = tbl_PaymentsType.FK_iPaymentID
    INNER JOIN tbl_ShippingUnits ON tbl_ShippingUnits.PK_iShippingUnitID = tbl_ShippingOrders.FK_iShippingUnitID
    WHERE tbl_ShippingDeliveries.FK_iUserID = @FK_iUserID AND tbl_Order_Status.iOrderStatusCode = 13
END
EXEC sp_GetShippingDeliveryCompleteByDeliverID 8
GO

-- Thủ tục xác nhận đơn vận giao về trạng thái đang giao hàng --
CREATE PROC sp_ConfirmShippingDeliveryAboutedDelivering
    @PK_iShippingDeliveryID INT
AS
BEGIN
    UPDATE tbl_ShippingDeliveries SET FK_iOrderStatusID = 8 WHERE PK_iShippingDeliveryID = @PK_iShippingDeliveryID
END
GO

-- Thủ tục xác nhận đơn vận giao về trạng thái đã giao hàng tới người mua --
CREATE PROC sp_ConfirmShippingDeliveryAboutedDeliveredToBuyer
    @PK_iShippingDeliveryID INT
AS
BEGIN
    UPDATE tbl_ShippingDeliveries SET FK_iOrderStatusID = 15 WHERE PK_iShippingDeliveryID = @PK_iShippingDeliveryID
END
GO

-- Cập nhật ảnh cho đơn vận giao --
CREATE PROC sp_UpdateDeliveryImage
    @PK_iShippingDeliveryID INT,
    @sDeliveryImage NVARCHAR(100)
AS
BEGIN
    UPDATE tbl_ShippingDeliveries SET sDeliveryImage = @sDeliveryImage WHERE PK_iShippingDeliveryID = @PK_iShippingDeliveryID
END
GO


