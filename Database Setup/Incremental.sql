IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurchaseHeader]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[PurchaseHeader](
	[Id] [BigInt] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL CONSTRAINT FK_PurchaseHeader_PharmacyId FOREIGN KEY REFERENCES Pharmacy(Id),
	[GrnNo] NVARCHAR(50) NULL,
	[GrnDate] SMALLDATETIME NOT NULL,
	[POrderNo] [BigInt] NULL,
	[SupplierId] [BigInt] NULL,
	[SupplierInvNo] NVARCHAR(50),
	[SupplierInvDate] [smalldatetime] NULL,
	[CreditPeriod] INT NULL,
	[CreditDate] SMALLDATETIME NULL,
	DiscountPercent decimal(18,3) null,
	DiscountAmount decimal(18,3) null,
	TotalAmount decimal(18,3) null,
	TotalVAT decimal(18,3) null,
	NetAmount decimal(18,3) null,
	RoundOff decimal(18,3) null,
	PaidStatus BIT NULL,
	PaidAmount decimal(18,3) null,
	[Status] VARCHAR(20) NULL,
	[Comment] NVARCHAR(250) NULL,
	[AddedBy] [bigint] NOT NULL,	
	[AddedDateTime] [smalldatetime] NOT NULL,
	AddedUserName NVARCHAR(100) NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	CONSTRAINT [PK_PurchaseHeader_Id] PRIMARY KEY CLUSTERED	([ID] ASC)
	)
END

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurchaseDetail]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[PurchaseDetail](
	[Id] [BigInt] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL CONSTRAINT FK_PurchaseDetail_PharmacyId FOREIGN KEY REFERENCES Pharmacy(Id),
	[PHeaderId] BIGINT NOT NULL CONSTRAINT FK_PurchaseDetail_Id FOREIGN KEY REFERENCES PurchaseHeader(Id),	
	[ProductId] BIGINT NOT NULL CONSTRAINT FK_PurchaseDetail_ProductId FOREIGN KEY REFERENCES Product(ProductId),
	[BatchNo] NVARCHAR(50) NULL, 
	[Qty] INT NULL,
	[FreeQty] INT NULL,
	[MfgId] [int] NOT NULL CONSTRAINT FK_PurchaseDetail_MfgId FOREIGN KEY REFERENCES Manufacturer(Id),
	[UnitId] [int] NOT NULL ,	
	[ExpiryDate] [smalldatetime] NULL,
	[Packing] INT NULL,
	[AssortedQty] INT NULL,	
	CostPrice decimal(18,3) null,
	MRP decimal(18,3) null,
	VAT decimal(18,3) null,
	MRPVATAmount decimal(18,3) null,
	COSTVATAmount decimal(18,3) null,
	AbatedMRP decimal(18,3) null,
	TaxMode VARCHAR(20) NULL,
	TaxType VARCHAR(20) NULL,
	DiscApplicable BIT NULL,
	VATOnDiscount BIT NULL,
	VATOnFreeQty BIT NULL,
	DiscOnFreeQty BIT NULL,
	FreeQtyVATAmount decimal(18,3) null,
	DiscountPercentage decimal(18,3) null,
	DiscountAmount decimal(18,3) null,
	AssortedCostPrice decimal(18,3) null,
	AssortedMRPPrice decimal(18,3) null,
	AbatedCost decimal(18,3) null,
	RackId INT NULL,
	Barcode VARCHAR(100) NULL,
	[AddedBy] [bigint] NOT NULL,	
	[AddedDateTime] [smalldatetime] NOT NULL,
	AddedUserName NVARCHAR(100) NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	CONSTRAINT [PK_PurchaseDetail_Id] PRIMARY KEY CLUSTERED	([ID] ASC)
	)
END

GO


--ADD A NEW COLUMN IN EXISTING TABLE WITH DEFAULT VALUE--

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE NAME = N'GRNIDValue' AND OBJECT_ID = OBJECT_ID(N'Pharmacy'))
BEGIN
   ALTER TABLE Pharmacy 
   ADD GRNIDValue BIGINT NULL   
END

go

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE NAME = N'GRNPrefix' AND OBJECT_ID = OBJECT_ID(N'Pharmacy'))
BEGIN
   ALTER TABLE Pharmacy 
   ADD GRNPrefix VARCHAR(10) NOT NULL  
   CONSTRAINT DF_Pharmacy_GRNPrefix DEFAULT 'GRN'
END


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetNextGRNForPharmacy]

   @pharmacyId INT,    

   @NextID VARCHAR(50) OUTPUT

AS
BEGIN
   SET NOCOUNT ON;



   DECLARE @Out TABLE (NextVal INT, Prefix varchar(20))



   UPDATE dbo.Pharmacy

   SET GRNIDValue = ISNULL(GRNIDValue,0) + 1

   OUTPUT INSERTED.GRNIDValue, INSERTED.GRNPrefix INTO @Out(NextVal, prefix)

   WHERE Id=@pharmacyId   

   SELECT TOP 1 @nextID = Prefix + CAST(NextVal AS VARCHAR(10)) FROM @Out

   END

GO



CREATE PROCEDURE [dbo].[AddPurchaseHeader]      
(    
@pharmacyId INT,    
@grnDate smalldatetime, 
@orderNo BigInt, 
@supplierId INT,
@supInvNo VARCHAR(50),
@supInvDate smalldatetime, 
@creditPeriod INT,    
@creditDate smalldatetime, 
@discountPercent decimal(18,3), 
@discountAmount decimal(18,3), 
@totalAmount decimal(18,3), 
@totalVAT decimal(18,3), 
@netAmount decimal(18,3), 
@roundOff decimal(18,3), 
@isPaid bit, 
@paidAmount decimal(18,3), 
@status VARCHAR(20),
@comment NVARCHAR(250),
@AddedBy BIGINT,
@AddedDateTime smalldatetime,
@addedUser VARCHAR(100)
    
)    
    
AS     
    
    
BEGIN     
     SET NOCOUNT ON       
IF ((@pharmacyId IS NULL) )  
      RAISERROR('The value for @pharmacyId should not be null', 15, 1) 
     
ELSE    
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SET NOCOUNT ON



	BEGIN TRY
  

	DECLARE @_grnNo NVARCHAR(50)      
           
     EXEC dbo.GetNextGRNForPharmacy @pharmacyId, @_grnNo OUTPUT 

		INSERT INTO dbo.PurchaseHeader      
          (     
				PharmacyId
				,GrnNo
				,GrnDate
				,POrderNo
				,SupplierId
				,SupplierInvNo
				,SupplierInvDate
				,CreditPeriod
				,CreditDate
				,DiscountPercent
				,DiscountAmount
				,TotalAmount
				,TotalVAT
				,NetAmount
				,RoundOff
				,PaidStatus
				,PaidAmount
				,[Status]
				,Comment
				,AddedBy
				,AddedDateTime
				,AddedUserName
                                      
          )       
     VALUES       
          (       
           		@pharmacyId
				,@_grnNo
				,@grnDate
				,@orderNo
				,@supplierId
				,@supInvNo
				,@supInvDate
				,@creditPeriod
				,@creditDate
				,@discountPercent
				,@discountAmount
				,@totalAmount
				,@totalVAT
				,@netAmount
				,@roundOff
				,@isPaid
				,@paidAmount
				,@status
				,@comment
				,@AddedBy
				,@AddedDateTime
				,@addedUser
                 
          )       
		 SELECT SCOPE_IDENTITY()
   END TRY

	BEGIN CATCH
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

		SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

		RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
		
		WITH SETERROR;
		
	END CATCH   
END       
END

GO


CREATE PROCEDURE [dbo].[AddPurchaseItem]      
(    
@pharmacyId INT,    
@pHeaderId BIGINT,
@productId BIGINT,
@batchNo VARCHAR(100), 
@qty INT,
@freeQty INT,
@mfgId INT,
@unitId INT,
@expiryDate SMALLDATETIME, 
@packing INT,  
@assortedQty INT,  

@CostPrice decimal(18,3), 
@MRP decimal(18,3), 
@VAT decimal(18,3), 
@MRPVATAmount decimal(18,3), 
@COSTVATAmount decimal(18,3), 
@abatedMRP decimal(18,3), 

@TaxMode VARCHAR(20), 
@TaxType VARCHAR(20), 

@DiscApplicable bit, 
@VATOnDiscount bit, 
@VATOnFreeQty bit, 
@DiscOnFreeQty bit, 


@FreeQtyVATAmount decimal(18,3), 
@DiscountPercentage decimal(18,3), 
@DiscountAmount decimal(18,3), 
@AssortedCostPrice decimal(18,3), 
@AssortedMRPPrice decimal(18,3), 
@AbatedCost decimal(18,3), 

@rackId INT, 
@barCode VARCHAR(50),

@AddedBy BIGINT,
@AddedDateTime smalldatetime,
@addedUser VARCHAR(100)
    
)    
    
AS     
    
    
BEGIN     
     SET NOCOUNT ON       
IF ((@pharmacyId IS NULL) )  
      RAISERROR('The value for @pharmacyId should not be null', 15, 1) 
     
ELSE    
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SET NOCOUNT ON



	BEGIN TRY
 
		INSERT INTO dbo.PurchaseDetail      
          (     
				PharmacyId
				,PHeaderId
				,ProductId
				,BatchNo
				,Qty
				,FreeQty
				,MfgId
				,UnitId
				,ExpiryDate
				,Packing
				,AssortedQty
				,CostPrice
				,MRP
				,VAT
				,MRPVATAmount
				,COSTVATAmount
				,AbatedMRP
				,TaxMode
				,TaxType
				,DiscApplicable
				,VATOnDiscount
				,VATOnFreeQty
				,DiscOnFreeQty
				,FreeQtyVATAmount
				,DiscountPercentage
				,DiscountAmount
				,AssortedCostPrice
				,AssortedMRPPrice
				,AbatedCost
				,RackId
				,Barcode
				,AddedBy
				,AddedDateTime
                                      
          )       
     VALUES       
          (       
           		@pharmacyId
				,@pHeaderId
				,@productId
				,@batchNo
				,@qty
				,@freeQty
				,@mfgId
				,@unitId
				,@expiryDate
				,@packing
				,@assortedQty
				,@CostPrice
				,@MRP
				,@VAT
				,@MRPVATAmount
				,@COSTVATAmount
				,@abatedMRP
				,@TaxMode
				,@TaxType
				,@DiscApplicable
				,@VATOnDiscount
				,@VATOnFreeQty
				,@DiscOnFreeQty
				,@FreeQtyVATAmount
				,@DiscountPercentage
				,@DiscountAmount
				,@AssortedCostPrice
				,@AssortedMRPPrice
				,@AbatedCost
				,@rackId
				,@barCode
				,@AddedBy
				,@AddedDateTime
          )       
		 SELECT SCOPE_IDENTITY()
   END TRY

	BEGIN CATCH
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

		SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

		RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
		
		WITH SETERROR;
		
	END CATCH   
END       
END




/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 08/23/2015 21:58:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPurchaseItem]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 08/23/2015 21:58:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPurchaseHeader]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 08/23/2015 21:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseHeader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    

    

    

CREATE PROCEDURE [dbo].[AddPurchaseHeader]          

(        

@pharmacyId INT,        

@grnDate smalldatetime,     

@orderNo BigInt,     

@supplierId INT,    

@supInvNo VARCHAR(50),    

@supInvDate smalldatetime,     

@creditPeriod INT,        

@creditDate smalldatetime,     

@discountPercent decimal(18,3),     

@discountAmount decimal(18,3),     

@totalAmount decimal(18,3),     

@totalVAT decimal(18,3),     

@netAmount decimal(18,3),     

@roundOff decimal(18,3),     

@isPaid bit,     

@paidAmount decimal(18,3),     

@status VARCHAR(20),    

@comment NVARCHAR(250),    

@AddedBy BIGINT,    

@AddedDateTime smalldatetime,    

@addedUser VARCHAR(100)    

        

)        

        

AS         

        

        

BEGIN         

     SET NOCOUNT ON           

IF ((@pharmacyId IS NULL) )      

      RAISERROR(''The value for @pharmacyId should not be null'', 15, 1)     

         

ELSE        

BEGIN    

    

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

    

 SET NOCOUNT ON    

    

    

    

 BEGIN TRY    

      

    

 DECLARE @_grnNo NVARCHAR(50)          

               

     EXEC dbo.GetNextGRNForPharmacy @pharmacyId, @_grnNo OUTPUT     

    

  INSERT INTO dbo.PurchaseHeader          

          (         

    PharmacyId    

    ,GrnNo    

    ,GrnDate    

    ,POrderNo    

    ,SupplierId    

    ,SupplierInvNo    

    ,SupplierInvDate    

    ,CreditPeriod    

    ,CreditDate    

    ,DiscountPercent    

    ,DiscountAmount    

    ,TotalAmount    

    ,TotalVAT    

    ,NetAmount    

    ,RoundOff    

    ,PaidStatus    

    ,PaidAmount    

    ,[Status]    

    ,Comment    

    ,AddedBy    

    ,AddedDateTime    

    ,AddedUserName    

                                          

          )           

     VALUES           

          (           

             @pharmacyId    

    ,@_grnNo    

    ,@grnDate    

    ,@orderNo    

    ,@supplierId    

    ,@supInvNo    

    ,@supInvDate    

    ,@creditPeriod    

    ,@creditDate    

    ,@discountPercent    

    ,@discountAmount    

    ,@totalAmount    

    ,@totalVAT    

    ,@netAmount    

    ,@roundOff    

    ,@isPaid    

    ,@paidAmount    

    ,@status    

    ,@comment    

    ,@AddedBy    

    ,@AddedDateTime    

    ,@addedUser    

                     

          )           

   SELECT SCOPE_IDENTITY() As [Key], @_grnNo  As Value

   

   END TRY    

    

 BEGIN CATCH    

      

  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    

    

  SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    

    

  RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    

      

  WITH SETERROR;    

      

 END CATCH       

END           

END ' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 08/23/2015 21:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[AddPurchaseItem]      
(    
@pharmacyId INT,    
@pHeaderId BIGINT,
@productId BIGINT,
@batchNo VARCHAR(100), 
@qty INT,
@freeQty INT,
@mfgId INT,
@unitId INT,
@expiryDate SMALLDATETIME, 
@packing INT,  
@assortedQty INT,  

@CostPrice decimal(18,3), 
@MRP decimal(18,3), 
@VAT decimal(18,3), 
@MRPVATAmount decimal(18,3), 
@COSTVATAmount decimal(18,3), 
@abatedMRP decimal(18,3), 

@TaxMode VARCHAR(20), 
@TaxType VARCHAR(20), 

@DiscApplicable bit, 
@VATOnDiscount bit, 
@VATOnFreeQty bit, 
@DiscOnFreeQty bit, 


@FreeQtyVATAmount decimal(18,3), 
@DiscountPercentage decimal(18,3), 
@DiscountAmount decimal(18,3), 
@AssortedCostPrice decimal(18,3), 
@AssortedMRPPrice decimal(18,3), 
@AbatedCost decimal(18,3), 

@rackId INT, 
@barCode VARCHAR(50),

@AddedBy BIGINT,
@AddedDateTime smalldatetime,
@addedUser VARCHAR(100)
    
)    
    
AS     
    
    
BEGIN     
     SET NOCOUNT ON       
IF ((@pharmacyId IS NULL) )  
      RAISERROR(''The value for @pharmacyId should not be null'', 15, 1) 
     
ELSE    
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SET NOCOUNT ON



	BEGIN TRY
 
		INSERT INTO dbo.PurchaseDetail      
          (     
				PharmacyId
				,PHeaderId
				,ProductId
				,BatchNo
				,Qty
				,FreeQty
				,MfgId
				,UnitId
				,ExpiryDate
				,Packing
				,AssortedQty
				,CostPrice
				,MRP
				,VAT
				,MRPVATAmount
				,COSTVATAmount
				,AbatedMRP
				,TaxMode
				,TaxType
				,DiscApplicable
				,VATOnDiscount
				,VATOnFreeQty
				,DiscOnFreeQty
				,FreeQtyVATAmount
				,DiscountPercentage
				,DiscountAmount
				,AssortedCostPrice
				,AssortedMRPPrice
				,AbatedCost
				,RackId
				,Barcode
				,AddedBy
				,AddedDateTime
                                      
          )       
     VALUES       
          (       
           		@pharmacyId
				,@pHeaderId
				,@productId
				,@batchNo
				,@qty
				,@freeQty
				,@mfgId
				,@unitId
				,@expiryDate
				,@packing
				,@assortedQty
				,@CostPrice
				,@MRP
				,@VAT
				,@MRPVATAmount
				,@COSTVATAmount
				,@abatedMRP
				,@TaxMode
				,@TaxType
				,@DiscApplicable
				,@VATOnDiscount
				,@VATOnFreeQty
				,@DiscOnFreeQty
				,@FreeQtyVATAmount
				,@DiscountPercentage
				,@DiscountAmount
				,@AssortedCostPrice
				,@AssortedMRPPrice
				,@AbatedCost
				,@rackId
				,@barCode
				,@AddedBy
				,@AddedDateTime
          )       
		 SELECT SCOPE_IDENTITY()
   END TRY

	BEGIN CATCH
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

		SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

		RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
		
		WITH SETERROR;
		
	END CATCH   
END       
END




' 
END
GO




GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseDetails]    Script Date: 08/27/2015 23:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPurchaseDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPurchaseDetails]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 08/27/2015 23:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPurchaseItem]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 08/27/2015 23:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPurchaseHeader]
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseList]    Script Date: 08/27/2015 23:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPurchaseList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPurchaseList]
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseList]    Script Date: 08/27/2015 23:10:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPurchaseList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPurchaseList]      
  @pharmacyId INT
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
  
  
BEGIN TRY  
  
SELECT
	 PH.Id
	,GrnNo
	,GrnDate
	,POrderNo
	,S.Name As SupplierName
	,SupplierInvNo
	,SupplierInvDate
	,CreditPeriod
	,CreditDate
	,DiscountPercent
	,DiscountAmount
	,TotalAmount
	,TotalVAT
	,NetAmount
	,RoundOff
	,PaidStatus
	,PaidAmount
	,Status
	,Comment
	,P.FirstName as AddedFirstName
	,P.LastName as AddedLastName
	,ph.AddedDateTime	
	,U.Username 

FROM PurchaseHeader PH
INNER JOIN Supplier S ON S.Id=PH.SupplierId
INNER JOIN ApplicationUser U ON U.UserId=PH.SavedUserId
INNER JOIN Person P ON P.PersonId=PH.AddedBy

WHERE PH.PharmacyId=@pharmacyId
      
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 08/27/2015 23:10:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseHeader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    

    

    

CREATE PROCEDURE [dbo].[AddPurchaseHeader]          

(        

@pharmacyId INT,        

@grnDate smalldatetime,     

@orderNo BigInt,     

@supplierId INT,    

@supInvNo VARCHAR(50),    

@supInvDate smalldatetime,     

@creditPeriod INT,        

@creditDate smalldatetime,     

@discountPercent decimal(18,3),     

@discountAmount decimal(18,3),     

@totalAmount decimal(18,3),     

@totalVAT decimal(18,3),     

@netAmount decimal(18,3),     

@roundOff decimal(18,3),     

@isPaid bit,     

@paidAmount decimal(18,3),     

@status VARCHAR(20),    

@comment NVARCHAR(250),    

@AddedBy BIGINT,    

@AddedDateTime smalldatetime,    

@savedUserId INT    

        

)        

        

AS         

        

        

BEGIN         

     SET NOCOUNT ON           

IF ((@pharmacyId IS NULL) )      

      RAISERROR(''The value for @pharmacyId should not be null'', 15, 1)     

         

ELSE        

BEGIN    

    

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

    

 SET NOCOUNT ON    

    

    

    

 BEGIN TRY    

      

    

 DECLARE @_grnNo NVARCHAR(50)          

               

     EXEC dbo.GetNextGRNForPharmacy @pharmacyId, @_grnNo OUTPUT     

    

  INSERT INTO dbo.PurchaseHeader          

          (         

    PharmacyId    

    ,GrnNo    

    ,GrnDate    

    ,POrderNo    

    ,SupplierId    

    ,SupplierInvNo    

    ,SupplierInvDate    

    ,CreditPeriod    

    ,CreditDate    

    ,DiscountPercent    

    ,DiscountAmount    

    ,TotalAmount    

    ,TotalVAT    

    ,NetAmount    

    ,RoundOff    

    ,PaidStatus    

    ,PaidAmount    

    ,[Status]    

    ,Comment    

    ,AddedBy    

    ,AddedDateTime    

    ,AddedUserName    

                                          

          )           

     VALUES           

          (           

             @pharmacyId    

    ,@_grnNo    

    ,@grnDate    

    ,@orderNo    

    ,@supplierId    

    ,@supInvNo    

    ,@supInvDate    

    ,@creditPeriod    

    ,@creditDate    

    ,@discountPercent    

    ,@discountAmount    

    ,@totalAmount    

    ,@totalVAT    

    ,@netAmount    

    ,@roundOff    

    ,@isPaid    

    ,@paidAmount    

    ,@status    

    ,@comment    

    ,@AddedBy    

    ,@AddedDateTime    

    ,@savedUserId    

                     

          )           

   SELECT SCOPE_IDENTITY() As [Key], @_grnNo  As Value

   

   END TRY    

    

 BEGIN CATCH    

      

  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    

    

  SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    

    

  RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    

      

  WITH SETERROR;    

      

 END CATCH       

END           

END ' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 08/27/2015 23:10:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPurchaseItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
CREATE PROCEDURE [dbo].[AddPurchaseItem]        
(      
@pharmacyId INT,      
@pHeaderId BIGINT,  
@productId BIGINT,  
@batchNo VARCHAR(100),   
@qty INT,  
@freeQty INT,  
@mfgId INT,  
@unitId INT,  
@expiryDate varchar(10),   
@packing INT,    
@assortedQty INT,    
  
@CostPrice decimal(18,3),   
@MRP decimal(18,3),   
@VAT decimal(18,3),   
@MRPVATAmount decimal(18,3),   
@COSTVATAmount decimal(18,3),   
@abatedMRP decimal(18,3),   
  
@TaxMode VARCHAR(20),   
@TaxType VARCHAR(20),   
  
@DiscApplicable bit,   
@VATOnDiscount bit,   
@VATOnFreeQty bit,   
@DiscOnFreeQty bit,   
  
  
@FreeQtyVATAmount decimal(18,3),   
@DiscountPercentage decimal(18,3),   
@DiscountAmount decimal(18,3),   
@AssortedCostPrice decimal(18,3),   
@AssortedMRPPrice decimal(18,3),   
@AbatedCost decimal(18,3),   
  
@rackId INT,   
@barCode VARCHAR(50),  
  
@AddedBy BIGINT,  
@AddedDateTime smalldatetime
      
)      
      
AS       
      
      
BEGIN       
     SET NOCOUNT ON         
IF ((@pharmacyId IS NULL) )    
      RAISERROR(''The value for @pharmacyId should not be null'', 15, 1)   
       
ELSE      
BEGIN  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 SET NOCOUNT ON  
  
  
  
 BEGIN TRY  
   
  INSERT INTO dbo.PurchaseDetail        
          (       
    PharmacyId  
    ,PHeaderId  
    ,ProductId  
    ,BatchNo  
    ,Qty  
    ,FreeQty  
    ,MfgId  
    ,UnitId  
    ,ExpiryDate  
    ,Packing  
    ,AssortedQty  
    ,CostPrice  
    ,MRP  
    ,VAT  
    ,MRPVATAmount  
    ,COSTVATAmount  
    ,AbatedMRP  
    ,TaxMode  
    ,TaxType  
    ,DiscApplicable  
    ,VATOnDiscount  
    ,VATOnFreeQty  
    ,DiscOnFreeQty  
    ,FreeQtyVATAmount  
    ,DiscountPercentage  
    ,DiscountAmount  
    ,AssortedCostPrice  
    ,AssortedMRPPrice  
    ,AbatedCost  
    ,RackId  
    ,Barcode  
    ,AddedBy  
    ,AddedDateTime  
                                        
          )         
     VALUES         
          (         
             @pharmacyId  
    ,@pHeaderId  
    ,@productId  
    ,@batchNo  
    ,@qty  
    ,@freeQty  
    ,@mfgId  
    ,@unitId  
    ,@expiryDate  
    ,@packing  
    ,@assortedQty  
    ,@CostPrice  
    ,@MRP  
    ,@VAT  
    ,@MRPVATAmount  
    ,@COSTVATAmount  
    ,@abatedMRP  
    ,@TaxMode  
    ,@TaxType  
    ,@DiscApplicable  
    ,@VATOnDiscount  
    ,@VATOnFreeQty  
    ,@DiscOnFreeQty  
    ,@FreeQtyVATAmount  
    ,@DiscountPercentage  
    ,@DiscountAmount  
    ,@AssortedCostPrice  
    ,@AssortedMRPPrice  
    ,@AbatedCost  
    ,@rackId  
    ,@barCode  
    ,@AddedBy  
    ,@AddedDateTime  
          )         
   SELECT SCOPE_IDENTITY()  
   END TRY  
  
 BEGIN CATCH  
    
  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
  SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
  RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
    
  WITH SETERROR;  
    
 END CATCH     
END         
END  
  
  
  
  ' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseDetails]    Script Date: 08/27/2015 23:10:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPurchaseDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[GetPurchaseDetails]      
(    
@pharmacyId INT,    
@pId BIGINT
    
)    
    
AS     
    
    
BEGIN     
     SET NOCOUNT ON       
IF ((@pharmacyId IS NULL) )  
      RAISERROR(''The value for @pharmacyId should not be null'', 15, 1) 
     
ELSE    
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SET NOCOUNT ON



	BEGIN TRY
  
        SELECT 
        GrnNo
		,GrnDate
		,POrderNo
		,SupplierId
		,SupplierInvNo
		,SupplierInvDate
		,CreditPeriod
		,CreditDate
		,DiscountPercent
		,DiscountAmount
		,TotalAmount
		,TotalVAT
		,NetAmount
		,RoundOff
		,PaidStatus
		,PaidAmount
		,Status
		,Comment
		,AddedUserName

         FROM PurchaseHeader
		 WHERE Id=@pId AND PharmacyId=@pharmacyId
		 
		 
		 SELECT 
			 PD.Id
			,PharmacyId
			,PHeaderId
			,ProductId
			,P.Name AS ProductName
			,BatchNo
			,Qty
			,FreeQty
			,MfgId AS ManufacturerId			
			,PD.UnitId
			,ExpiryDate
			,Packing
			,AssortedQty
			,CostPrice
			,MRP
			,VAT
			,MRPVATAmount
			,COSTVATAmount
			,AbatedMRP
			,TaxMode
			,TaxType
			,DiscApplicable
			,VATOnDiscount
			,VATOnFreeQty
			,DiscOnFreeQty
			,FreeQtyVATAmount
			,DiscountPercentage
			,DiscountAmount
			,AssortedCostPrice
			,AssortedMRPPrice
			,AbatedCost
			,RackId
			,Barcode
			,AddedUserName
		 FROM
		 PurchaseDetail PD
		 INNER JOIN Product P ON P.Id=PD.ProductId		
		 WHERE PHeaderId=@pId AND PharmacyId=@pharmacyId
		 
     
		
     END TRY

	BEGIN CATCH
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

		SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

		RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
		
		WITH SETERROR;
		
	END CATCH   
END       
END




' 
END
GO
