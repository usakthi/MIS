
/****** Object:  StoredProcedure [dbo].[AddBank]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBank]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Bank 
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddBillHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBillHeader]          
(        
@pharmacyId INT,             
@Customer VARCHAR(100)   ,
@ConsultantName VARCHAR(100)   ,
@IPNo VARCHAR(20),
@totalAmount decimal(18,3), 
@discountPercent decimal(18,3),     
@discount decimal(18,3),     
@netAmount decimal(18,3),     
@PaidAmount  decimal(18,3), 
@Balance  decimal(18,3), 
@totalVAT decimal(18,3),     
@roundOff decimal(18,3),     
@billstatus VARCHAR(20), 
@SalesMode VARCHAR(10),
@PayMode VARCHAR(10),
@IndentId BIGINT,   
@AddedBy BIGINT,    
@AddedDateTime smalldatetime,    
@savedUserId INT
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

 DECLARE @_billNo NVARCHAR(50)                       

 EXEC dbo.GetNextBillForPharmacy @pharmacyId, @_billNo OUTPUT     
  
  INSERT INTO dbo.Sales          
(         
    PharmacyId    
    ,BillNo    
    ,BillDate    
  ,Customer
  ,ConsultantName
  ,IPNo
  ,TotalAmount   
    ,DiscountPercent    
    ,Discount
      ,NetAmount    
      ,PaidAmount 
      ,Balance   
    ,TotalVAT    
    ,RoundOff    
    ,BillStatus
    ,SalesMode  
    ,PayMode
    ,IndentId
    ,AddedBy    
    ,AddedDateTime    
    ,SavedUserID
)           
VALUES           
(           
@pharmacyId,
@_billNo,
getdate(),
@Customer,
@ConsultantName,
@IPNo,
@totalAmount,
@discountPercent,
@discount ,
@netAmount,
@PaidAmount,
@Balance ,
@totalVAT,    
@roundOff,   
@billstatus ,
@SalesMode,
@PayMode,
@IndentId,
@AddedBy ,
@AddedDateTime,
@savedUserId
)           
   SELECT SCOPE_IDENTITY() As [Key], @_billNo  As Value

	UPDATE Indent SET Status = 'R' WHERE IndentId = @IndentId AND IPNo = @IPNo
	
		
	INSERT INTO [HBS].dbo.IP_POINT_OF_SERVICES ( 
IPOS_IAD_IP_ADMISSION_NO, 
IPOS_SERVICE_DATE, 
IPOS_SM_CODE, 
IPOS_D_CODE, 
IPOS_SERVICE_AMOUNT, 
IPOS_SERVICE_QTY, 
IPOS_SERVICE_TOTAL_AMOUNT, 
IPOS_WSC_CODE, 
IPOS_RM_CODE, 
IPOS_BM_CODE, 
IPOS_CREATED_BY, 
IPOS_CREATED_ON, 
IPOS_REFFERENCE_ID, 
IPOS_INUSE_NOTINUSE, 
IPOS_INSU_CORP_APPLICABLE)
VALUES (@IPNo,getdate(), 1058, 41, @netAmount, 1, @netAmount, 5, 5, 15, 'Admin', getdate(), 0, 1, 0)
 
 
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
/****** Object:  StoredProcedure [dbo].[AddBillItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBillItem]        
(      
@pharmacyId INT,      
@billCode BIGINT,  
@productId BIGINT,  
@batchNo VARCHAR(100),   
@qty INT,   
@MfgId INT,
@ExpiryDate VARCHAR(20)  ,
@GRNNo VARCHAR(20),
@CostPrice NUMERIC(18,3),
@TotalCostPrice NUMERIC(18,3),
@MRP NUMERIC(18,3),
@TotalMRP NUMERIC(18,3),
@TaxPercent NUMERIC(18,2),
@TaxAmount NUMERIC(18,3),
@DiscPercent NUMERIC(18,2),
@Discount NUMERIC(18,3),
@CancelFlag BIT,
@EditProduct BIT,
@OldQty INT,
@PurDetId BIGINT,
@AddedBy BIGINT,
@AddedDateTime smalldatetime    
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
   
  INSERT INTO dbo.SalesDetails        
          (       
    PharmacyId  
    ,BillCode
    ,ProductId  
    ,BatchNo  
    ,Qty  
    ,MfgId
    ,ExpiryDate
    ,GRNNo
    ,CostPrice
    ,TotalCostPrice
    ,MRP
    ,TotalMRP
    ,TaxPercent
    ,TaxAmount
    ,DiscPercent
    ,Discount
    ,CancelFlag
    ,EditProduct
    ,OldQty
    ,PurDetId
    ,AddedBy  
    ,AddedDateTime                                
          )         
     VALUES         
          (         
             @pharmacyId,
@billCode,
@productId,
@batchNo,
@qty,
@MfgId,
@ExpiryDate,
@GRNNo,
@CostPrice ,
@TotalCostPrice ,
@MRP,
@TotalMRP ,
@TaxPercent ,
@TaxAmount,
@DiscPercent ,
@Discount ,
0,
0 ,
@OldQty ,
@PurDetId,
@AddedBy ,
@AddedDateTime
          )         
   SELECT SCOPE_IDENTITY()  
   
   UPDATE RunningStock SET Qty = Qty - @qty, SaleQty = SaleQty + @qty, SaleDt = getdate()
   WHERE PurDetId = @PurDetId AND ProductId = @productId
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
/****** Object:  StoredProcedure [dbo].[AddBillReturnHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBillReturnHeader]          
(        
@pharmacyId INT,   
@billReturnNo VARCHAR(50)     ,
--@billReturnDate smalldatetime,     
--@BillDate smalldatetime,     
@Customer VARCHAR(100)   ,
@ConsultantName VARCHAR(100)   ,
@totalAmount decimal(18,3), 
@discountPercent decimal(18,3),     
@discount decimal(18,3),     
@netAmount decimal(18,3),     
@PaidAmount  decimal(18,3), 
@Balance  decimal(18,3), 
@totalVAT decimal(18,3),     
@roundOff decimal(18,3),     
@billstatus VARCHAR(20),    
@AddedBy BIGINT,    
@AddedDateTime smalldatetime,    
@savedUserId INT
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

 DECLARE @_billNo NVARCHAR(50)                       

 EXEC dbo.GetNextBillForPharmacy @pharmacyId, @_billNo OUTPUT     
  
  INSERT INTO dbo.SalesReturn          
(         
    PharmacyId  
    ,BillReturnNo
    ,BillReturnDate  
    ,BillNo    
    ,BillDate    
  ,Customer
  ,ConsultantName
  ,TotalAmount   
    ,DiscountPercent    
    ,Discount
      ,NetAmount    
      ,PaidAmount 
      ,Balance   
    ,TotalVAT    
    ,RoundOff    
    ,BillStatus    
    ,AddedBy    
    ,AddedDateTime    
    ,SavedUserID
)           
VALUES           
(           
@pharmacyId,
@_billNo,
getdate(),
@_billNo,
getdate(),
@Customer,
@ConsultantName,
@totalAmount,
@discountPercent,
@discount ,
@netAmount,
@PaidAmount,
@Balance ,
@totalVAT,    
@roundOff,   
@billstatus ,
@AddedBy ,
@AddedDateTime,
@savedUserId
)           
   SELECT SCOPE_IDENTITY() As [Key], @_billNo  As Value

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
/****** Object:  StoredProcedure [dbo].[AddBillReturnItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBillReturnItem]        
(      
@pharmacyId INT,      
@brCode BIGINT,  
@productId BIGINT,  
@batchNo VARCHAR(100),   
@qty INT,   
@MfgId INT,
@ExpiryDate VARCHAR(20)  ,
-- @GRNNo VARCHAR(20),
@CostPrice NUMERIC(18,3),
@TotalCostPrice NUMERIC(18,3),
@MRP NUMERIC(18,3),
@TotalMRP NUMERIC(18,3),
@TaxPercent NUMERIC(18,2),
@TaxAmount NUMERIC(18,3),
@DiscPercent NUMERIC(18,2),
@Discount NUMERIC(18,3),
@CancelFlag BIT,
@EditProduct BIT,
@OldQty INT,
@AddedBy BIGINT,
@AddedDateTime smalldatetime    
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
   
  INSERT INTO dbo.SalesReturnDetails        
          (       
    PharmacyId  
    ,BRCode
    ,ProductId  
    ,BatchNo  
    ,Qty  
    ,MfgId
    ,ExpiryDate
    --,GRNNo
    ,CostPrice
    ,TotalCostPrice
    ,MRP
    ,TotalMRP
    ,TaxPercent
    ,TaxAmount
    ,DiscPercent
    ,Discount
    ,CancelFlag
    ,EditProduct
    ,OldQty
    ,AddedBy  
    ,AddedDateTime                                
          )         
     VALUES         
          (         
             @pharmacyId,
@brCode,
@productId,
@batchNo,
@qty,
@MfgId,
@ExpiryDate,
-- @GRNNo,
@CostPrice ,
@TotalCostPrice ,
@MRP,
@TotalMRP ,
@TaxPercent ,
@TaxAmount,
@DiscPercent ,
@Discount ,
@CancelFlag,
@EditProduct ,
@OldQty ,
@AddedBy ,
@AddedDateTime
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
/****** Object:  StoredProcedure [dbo].[AddCreditAuth]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCreditAuth]

 @AuthName NVARCHAR(20),
 @DepName NVARCHAR(500),
 @DesigName NVARCHAR(500),
 @FindBy NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO CreditAuth 
( AuthName,
  DepName,DesigName,FindBy,IsActive
)
VALUES
(@AuthName,
 @DepName,@DesigName,@FindBy,@IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDepartment]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Department
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDrugCategory]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO DrugCategory
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDrugContent]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO DrugContent
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddDrugGeneric]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDrugGeneric]    

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO DrugGeneric
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDrugType]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO DrugType
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDrugUnit]    

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO DrugUnit
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddIndentHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddIndentHeader]          
(        
@pharmacyId INT,        
@patientName VARCHAR(100)   ,
@consultant VARCHAR(100),
@IPNo VARCHAR(20),
@PayMode VARCHAR(10),  
@AddedBy BIGINT,    
@AddedDateTime smalldatetime,    
@savedUserId INT
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

 DECLARE @_indentNo NVARCHAR(50)                       

 EXEC dbo.GetNextIndentForPharmacy @pharmacyId, @_indentNo OUTPUT     
  
  INSERT INTO dbo.Indent          
(         
    PharmacyId    
    ,IndentNo    
    ,IndentDate    
    ,Customer
    ,ConsultantName
    ,IPNo
    ,PayMode
    ,Status    
    ,AddedBy    
    ,AddedDateTime    
    ,SavedUserID
)           
VALUES           
(           
@pharmacyId,
@_indentNo,
getdate(),
@patientName,
@consultant,
@IPNo,
@PayMode,
'S',
@AddedBy ,
@AddedDateTime,
@savedUserId
)           
   SELECT SCOPE_IDENTITY() As [Key], @_indentNo  As Value

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
/****** Object:  StoredProcedure [dbo].[AddIndentItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddIndentItem]        
(      
@pharmacyId INT,      
@IndentId BIGINT,  
@productId BIGINT,  
@batchNo VARCHAR(100),   
@qty INT,   
@MfgId INT,
@ExpDate VARCHAR(20),
--@GRNNo VARCHAR(20),
@OldQty INT,
@PurDetId BIGINT,
@AddedBy BIGINT,
@AddedDateTime smalldatetime    
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
   
  INSERT INTO dbo.IndentDetails        
          (       
    PharmacyId  
    ,IndentId
    ,ProductId  
    ,BatchNo  
    ,Qty  
    ,MfgId
    ,ExpDate
    --,GRNNo
    ,OldQty
    ,PurDetId
    ,AddedBy  
    ,AddedDateTime                                
          )         
     VALUES         
          (         
@pharmacyId,
@IndentId,
@productId,
@batchNo,
@qty,
@MfgId,
@ExpDate,
--@GRNNo,
@OldQty ,
@PurDetId,
@AddedBy ,
@AddedDateTime
          )         
   SELECT SCOPE_IDENTITY()  
   
   UPDATE RunningStock SET IndentQty = @qty+isnull(IndentQty,0),IndentDt = getdate() WHERE PurDetId = @PurDetId
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
/****** Object:  StoredProcedure [dbo].[AddInternalTransferHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddInternalTransferHeader]          
(        
@pharmacyId INT,        
--@BillDate smalldatetime,     
@Customer VARCHAR(100)   ,
@ConsultantName VARCHAR(100)   ,
@totalAmount decimal(18,3), 
@discountPercent decimal(18,3),     
@discount decimal(18,3),     
@netAmount decimal(18,3),     
@PaidAmount  decimal(18,3), 
@Balance  decimal(18,3), 
@totalVAT decimal(18,3),     
@roundOff decimal(18,3),     
@billstatus VARCHAR(20),    
@AddedBy BIGINT,    
@AddedDateTime smalldatetime,    
@savedUserId INT
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

 DECLARE @_billNo NVARCHAR(50)                       

 EXEC dbo.GetNextBillForPharmacy @pharmacyId, @_billNo OUTPUT     
  
  INSERT INTO dbo.InternalTransfer          
(         
    PharmacyId    
    ,BillNo    
    ,BillDate    
  ,Customer
  ,ConsultantName
  ,TotalAmount   
    ,DiscountPercent    
    ,Discount
      ,NetAmount    
      ,PaidAmount 
      ,Balance   
    ,TotalVAT    
    ,RoundOff    
    ,BillStatus    
    ,AddedBy    
    ,AddedDateTime    
    ,SavedUserID
)           
VALUES           
(           
@pharmacyId,
@_billNo,
getdate(),
@Customer,
@ConsultantName,
@totalAmount,
@discountPercent,
@discount ,
@netAmount,
@PaidAmount,
@Balance ,
@totalVAT,    
@roundOff,   
@billstatus ,
@AddedBy ,
@AddedDateTime,
@savedUserId
)           
   SELECT SCOPE_IDENTITY() As [Key], @_billNo  As Value

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
/****** Object:  StoredProcedure [dbo].[AddInternalTransferItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddInternalTransferItem]        
(      
@pharmacyId INT,      
@IntTransCode BIGINT,  
@productId BIGINT,  
@batchNo VARCHAR(100),   
@qty INT,   
@MfgId INT,
@ExpiryDate VARCHAR(20)  ,
-- @GRNNo VARCHAR(20),
@CostPrice NUMERIC(18,3),
@TotalCostPrice NUMERIC(18,3),
@MRP NUMERIC(18,3),
@TotalMRP NUMERIC(18,3),
@TaxPercent NUMERIC(18,2),
@TaxAmount NUMERIC(18,3),
@DiscPercent NUMERIC(18,2),
@Discount NUMERIC(18,3),
@CancelFlag BIT,
@EditProduct BIT,
@OldQty INT,
@AddedBy BIGINT,
@AddedDateTime smalldatetime    
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
   
  INSERT INTO dbo.InternalTransferDetails        
          (       
    PharmacyId  
    ,IntTransCode
    ,ProductId  
    ,BatchNo  
    ,Qty  
    ,MfgId
    ,ExpiryDate
    --,GRNNo
    ,CostPrice
    ,TotalCostPrice
    ,MRP
    ,TotalMRP
    ,TaxPercent
    ,TaxAmount
    ,DiscPercent
    ,Discount
    ,CancelFlag
    ,EditProduct
    ,OldQty
    ,AddedBy  
    ,AddedDateTime                                
          )         
     VALUES         
          (         
             @pharmacyId,
@IntTransCode,
@productId,
@batchNo,
@qty,
@MfgId,
@ExpiryDate,
-- @GRNNo,
@CostPrice ,
@TotalCostPrice ,
@MRP,
@TotalMRP ,
@TaxPercent ,
@TaxAmount,
@DiscPercent ,
@Discount ,
@CancelFlag,
@EditProduct ,
@OldQty ,
@AddedBy ,
@AddedDateTime
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
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddManufacturer]

 @Name NVARCHAR(100),
 @Desc NVARCHAR(10),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Manufacturer
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProduct]
	@Classification CHAR(1),
	@Name           NVARCHAR (500),
	@TypeId           INT,
   	@CategoryId       INT,	
	@MainCategoryId   INT,
	@GenericId        INT,
	@ManfId           INT,
	@UnitId           INT,
	@MinStock       INT,
	@MaxStock       INT,
	@ExpiryNotifyinDays   		INT,
	@ExpiryDays           		INT,
	@SuppTakenBeforExpiryDays   INT,
	@TakenBeforeDays     		INT,
	@SuppTakenAfterExpiryDays   INT,
	@TakenAfterDays       		INT,
    @IsActive        			BIT = 1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

BEGIN TRY

INSERT INTO Product (
	Classification ,
	Name           ,
	TypeId           ,
   	CategoryId       ,	
	MainCategoryId   ,
	GenericId        ,
	ManfId           ,
	UnitId           ,
	MinStock       ,
	MaxStock       ,
	ExpiryNotifyinDays      	,
	ExpiryDays           		,
	SuppTakenBeforExpiryDays    ,
	TakenBeforeDays     		,
	SuppTakenAfterExpiryDays    ,
	TakenAfterDays       		,
    IsActive 
)
VALUES (
	@Classification ,
	@Name           ,
	@TypeId           ,
   	@CategoryId       ,	
	@MainCategoryId   ,
	@GenericId        ,
	@ManfId           ,
	@UnitId           ,
	@MinStock       ,
	@MaxStock       ,
	@ExpiryNotifyinDays       ,
	@ExpiryDays   			  ,
	@SuppTakenBeforExpiryDays ,
	@TakenBeforeDays    	  ,
	@SuppTakenAfterExpiryDays ,
	@TakenAfterDays  	      ,
    @IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

@savedUserId INT    

        

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

    ,@savedUserId    

                     

          )           

   SELECT SCOPE_IDENTITY() As [Key], @_grnNo  As Value

   

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
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
@expiryDate varchar(10),   
@packing INT,    
@assortedQty INT,    
  
@CostPrice decimal(18,3),   
@MRP decimal(18,3),   
@VAT decimal(18,3),    
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

@VATAmount decimal(18,3),   
@TotalCostPrice decimal(18,3),   
@NetCostPrice decimal(18,3),   
@TotalMRP decimal(18,3),   
@NetMRP decimal(18,3),   
@VatOnDiscountAmount decimal(18,3),   
@DiscOnFreeQtyAmount decimal(18,3),   
@TotalDiscountAmount decimal(18,3),   
@TotalVatAmount decimal(18,3),   
@NetVATAmount decimal(18,3),    
  
@rackId INT,   
@barCode VARCHAR(50),  
  
@AddedBy BIGINT,  
@AddedDateTime smalldatetime
      
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
    
    ,VATAmount
	,TotalCostPrice
	,NetCostPrice
	,TotalMRP
	,NetMRP
	,VatOnDiscountAmount
	,DiscOnFreeQtyAmount
	,TotalDiscountAmount
	,TotalVatAmount
	,NetVATAmount
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
    ,@VATAmount
	,@TotalCostPrice
	,@NetCostPrice
	,@TotalMRP
	,@NetMRP
	,@VatOnDiscountAmount
	,@DiscOnFreeQtyAmount
	,@TotalDiscountAmount
	,@TotalVatAmount
	,@NetVATAmount
    ,@rackId  
    ,@barCode  
    ,@AddedBy  
    ,@AddedDateTime  
          )         
   SELECT SCOPE_IDENTITY() 
   
   DECLARE @PurDetId BIGINT SET @PurDetId = (SELECT SCOPE_IDENTITY())
   DECLARE @TotalQty INT SET @TotalQty = (SELECT @qty + @freeQty)
   DECLARE @GrnNo VARCHAR(20) SET @GrnNo = (SELECT GrnNo FROM PurchaseHeader WHERE Id = @pHeaderId)
   EXEC AddRunningStock @pharmacyId,@productId,@batchNo,@TotalQty,
                        @expiryDate,@PurDetId,@mfgId,@CostPrice,@MRP,@VAT,@GrnNo

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
/****** Object:  StoredProcedure [dbo].[AddPurchaseReturnHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPurchaseReturnHeader]          
(        
@pharmacyId INT,        
@returnNo VARCHAR(50),
@returnDate smalldatetime,     
@grnNo VARCHAR(50),
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

      RAISERROR('The value for @pharmacyId should not be null', 15, 1)           

ELSE        

BEGIN    
    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
   
 SET NOCOUNT ON    

 BEGIN TRY    
 

 DECLARE @_grnNo NVARCHAR(50)                        

 EXEC dbo.GetNextGRNForPharmacy @pharmacyId, @_grnNo OUTPUT     

  INSERT INTO dbo.PurchaseReturnHeader          
(         
    PharmacyId
    ,ReturnNo
    ,ReturnDate    
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
    ,getdate() --@returnDate
    ,@_grnNo   --@grnNo    
    ,getdate() --@grnDate    
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

  RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    

  WITH SETERROR;    

  END CATCH       

END           

END
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseReturnItem]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPurchaseReturnItem]        
(      
@pharmacyId INT,      
@prHeaderId BIGINT,  
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

@VATAmount decimal(18,3),   
@TotalCostPrice decimal(18,3),   
@NetCostPrice decimal(18,3),   
@TotalMRP decimal(18,3),   
@NetMRP decimal(18,3),   
@VatOnDiscountAmount decimal(18,3),   
@DiscOnFreeQtyAmount decimal(18,3),   
@TotalDiscountAmount decimal(18,3),   
@TotalVatAmount decimal(18,3),   
@NetVATAmount decimal(18,3),    
  
@rackId INT,   
@barCode VARCHAR(50),  
  
@AddedBy BIGINT,  
@AddedDateTime smalldatetime
      
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
   
  INSERT INTO dbo.PurchaseReturnDetail        
          (       
    PharmacyId  
    ,PRHeaderId  
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
    
    ,VATAmount
	,TotalCostPrice
	,NetCostPrice
	,TotalMRP
	,NetMRP
	,VatOnDiscountAmount
	,DiscOnFreeQtyAmount
	,TotalDiscountAmount
	,TotalVatAmount
	,NetVATAmount
    ,RackId  
    ,Barcode  
    ,AddedBy  
    ,AddedDateTime  
                                        
          )         
     VALUES         
          (         
             @pharmacyId  
    ,@prHeaderId  
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
    ,@VATAmount
	,@TotalCostPrice
	,@NetCostPrice
	,@TotalMRP
	,@NetMRP
	,@VatOnDiscountAmount
	,@DiscOnFreeQtyAmount
	,@TotalDiscountAmount
	,@TotalVatAmount
	,@NetVATAmount
    ,@rackId  
    ,@barCode  
    ,@AddedBy  
    ,@AddedDateTime  
          )         
   SELECT SCOPE_IDENTITY() 
   
   DECLARE @PurDetId BIGINT SET @PurDetId = (SELECT SCOPE_IDENTITY())
   EXEC AddRunningStock @pharmacyId,@productId,@batchNo,@qty,
                        @expiryDate,@PurDetId,@mfgId,@CostPrice,@MRP

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
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRack]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Rack
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[AddReceivables]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddReceivables]        
(      
@pharmacyId INT,       
@BillCode BIGINT,  
@BillNo VARCHAR(20),
@TotalAmount NUMERIC(18,2),
@PaidAmount NUMERIC(18,2),
@Balacne NUMERIC(18,2),
@RoundOff NUMERIC(18,2),
@UserName VARCHAR(20),
@SalesMode VARCHAR(10),
@PayMode VARCHAR(10),
@AddedBy BIGINT,
@AddedDateTime SMALLDATETIME,    
@SavedUserID Bigint 
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
   
  INSERT INTO dbo.Receivables        
          (       
    PharmacyId 
    ,RecDate 
    ,BillCode
    ,BillNo
    ,TotalAmount
    ,PaidAmount
    ,Balance
    ,RoundOff
    ,UserName
    ,SalesMode
    ,PayMode
    ,AddedBy  
    ,AddedDateTime  
    ,SavedUserID                              
          )         
     VALUES         
          (         
             @pharmacyId,
             getdate(),
@BillCode,
@BillNo,
@TotalAmount,
@PaidAmount,
@Balacne,
@RoundOff,
@UserName,
@SalesMode,
@PayMode,
@AddedBy,
@AddedDateTime,
@SavedUserID
          )         
   SELECT SCOPE_IDENTITY()  
   
   UPDATE Sales SET PaidAmount = @PaidAmount, Balance = @Balacne
   WHERE BillCode = @BillCode AND PharmacyId = 1
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
/****** Object:  StoredProcedure [dbo].[AddRunningStock]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRunningStock]        
(
@PharmacyId INT,
@ProductId BIGINT,
@BatchNo NVARCHAR(50),
@Qty INT,
@ExpiryDate VARCHAR(20),
@PurDetId BIGINT,
@MfgId INT,
@CostPrice DECIMAL(18,3),
@MRP DECIMAL(18,3),
@VAT DECIMAL(18,2),
@GrnNo VARCHAR(20)
)
AS
BEGIN

INSERT INTO [dbo].RunningStock
(
PharmacyId,
ProductId,
BatchNo,
Qty,
ExpiryDate,
PurDetId,
MfgId,
CostPrice,
MRP,
PurQty,
PurDt,
VAT,
GRNNo
)
VALUES
(
@PharmacyId,
@ProductId,
@BatchNo,
@Qty,
@ExpiryDate,
@PurDetId,
@MfgId,
@CostPrice,
@MRP,
@Qty,
getdate(),
@VAT,
@GrnNo
)

END
GO
/****** Object:  StoredProcedure [dbo].[AddSupplier]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSupplier]

	@Name        NVARCHAR (100),
	@TypeId      Int,
	@Address     NVARCHAR (500),
	@TinNo       NVARCHAR (100),
	@City        VARCHAR (100),
	@State       VARCHAR (100),
	@Country     VARCHAR (50),
	@ContactPerson NVARCHAR (100),
	@Email    NVARCHAR (100),
	@Phone       NVARCHAR(50),
	@Fax        NVARCHAR (100),
	@Pincode   NVARCHAR(10),
	@MobileNo NVARCHAR(12),
    @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Supplier 
( Name,TypeId,Address ,TinNo,City,State,Country,ContactPerson,Email,Phone,Fax,Pincode, 
MobileNo,IsActive
)
VALUES
(@Name,@TypeId,@Address ,@TinNo,@City,@State,@Country,@ContactPerson,@Email,@Phone,@Fax,@Pincode,   
@MobileNo,@IsActive
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

GO
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTax]

 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit=1

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO Tax
( Name,
  [Description],
  IsActive
)
VALUES
(@Name,
 @Desc,
 @IsActive
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


GO
/****** Object:  StoredProcedure [dbo].[DailyCollectionSales]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DailyCollectionSales]
@PharmacyId INT,
@Category INT,
@FromDate DATETIME,
@ToDate DATETIME,
@UserName INT
AS
BEGIN 

IF @Category = 1 -- With Date
BEGIN 

SELECT BillNo, BillDate, Customer, isnull(IPNo,'') AS IPNo, 
ConsultantName, NetAmount, PaidAmount, Balance, TotalVat, 
isnull(UserName,'Admin') AS UserName
FROM Sales 

END 

ELSE IF @Category = 2 -- All User
BEGIN 

SELECT BillNo, BillDate, Customer, isnull(IPNo,'') AS IPNo, 
ConsultantName, NetAmount, PaidAmount, Balance, TotalVat, 
isnull(UserName,'Admin') AS UserName
FROM Sales 

END 

ELSE IF @Category = 3 -- With UserWise
BEGIN 

SELECT BillNo, BillDate, Customer, isnull(IPNo,'') AS IPNo, 
ConsultantName, NetAmount, PaidAmount, Balance, TotalVat, 
isnull(UserName,'Admin') AS UserName
FROM Sales 

END 

END
GO
/****** Object:  StoredProcedure [dbo].[DeleteBank]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteBank]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Bank  SET IsActive = 0 
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteCreditAuth]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteCreditAuth]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.CreditAuth  SET IsActive = 0 
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDepartment]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Department SET IsActive = 0  
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugCategory]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE dbo.DrugCategory SET IsActive = 0   
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugContent]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE dbo.DrugContent SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugGeneric]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugGeneric]    
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.DrugGeneric  SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugType]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.DrugType SET IsActive = 0
 	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugUnit]    
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.DrugUnit   SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteManufacturer]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Manufacturer   SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteProduct]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteProduct]
 @Id BIGINT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON


BEGIN TRY

UPDATE dbo.Product SET IsActive = 0   
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeletePurchase]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePurchase]
 @Id BIGINT,  
 @pharmacyId INT,
 @RowsAffected INT OUTPUT    
  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
  
BEGIN TRY  

 BEGIN TRANSACTION PURCHASEDELETE

declare @ChildRowsAffected INT  
EXEC DeletePurchaseItems @Id,@pharmacyId,@ChildRowsAffected
  
DELETE FROM dbo.PurchaseHeader 
   
WHERE Id = @Id  AND PharmacyId=@pharmacyId
  
SET @RowsAffected = @@ROWCOUNT  
COMMIT TRANSACTION PURCHASEDELETE
  
END TRY  
  
BEGIN CATCH  
 IF (@@TRANCOUNT > 0)
   BEGIN
      ROLLBACK TRANSACTION PURCHASEDELETE      
   END 
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END

GO
/****** Object:  StoredProcedure [dbo].[DeletePurchaseItems]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePurchaseItems]  
 @pHeaderId BIGINT,  
 @pharmacyId INT,
 @RowsAffected INT OUTPUT    
  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
  
BEGIN TRY  
  
DELETE FROM dbo.PurchaseDetail 
   
WHERE PHeaderId = @pHeaderId  AND PharmacyId=@pharmacyId
  
SET @RowsAffected = @@ROWCOUNT  
  
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRack]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Rack   SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteSupplier]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSupplier]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Supplier   SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTax]
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE  dbo.Tax   SET IsActive = 0
	
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetAdmissions]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAdmissions]  
  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
BEGIN TRY  
  
SELECT row_number() OVER (ORDER BY Adm.IAD_CODE) AS Slno,  
Adm.IAD_CODE AS IPCode,Adm.IAD_IP_ADMISSION_NO AS IPNo FROM [HBS].[dbo].[Patient_Mstr] pat
INNER JOIN [HBS].[dbo].[IP_Admission] Adm ON pat.[P_IP_MRN_NO] = Adm.[IAD_P_IP_MRN_NO]
WHERE Adm.[IAD_PATIENT_STATUS] = 'Admitted'

END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllActiveMenuItems]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetAllActiveMenuItems]



AS

BEGIN



SELECT [Id]

      ,[Key]

      ,[Name] As DisplayText

      ,[DisplayImageClass]

      ,[URL]

      ,[ParentId]

      ,[Order]

     

      

  FROM [dbo].[ApplicationMenu] WHERE [IsDeleted]=0



END








GO
/****** Object:  StoredProcedure [dbo].[GetBank]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBank]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM Bank        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetBanks]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBanks]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,
Id,Name,[Description] As [Desc], IsActive FROM Bank  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetBillDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBillDetails]            
(          
@pharmacyId INT,          
@pId BIGINT       
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
        
  SELECT       
   BillNo AS GrnNo      
  ,BillDate AS GrnDate      
  ,0 AS POrderNo      
  ,1 AS SupplierId      
  ,'' AS SupplierInvNo      
  ,'' AS SupplierInvDate      
  ,0 AS CreditPeriod      
  ,'' CreditDate      
  ,0 AS DiscountPercent      
  ,0 AS DiscountAmount      
  ,TotalAmount      
  ,TotalVAT      
  ,NetAmount      
  ,RoundOff      
  ,BillStatus AS PaidStatus      
  ,PaidAmount      
  ,'' AS Status      
  ,'' AS Comment      
  ,SavedUserID
      
   FROM Sales      
   WHERE BillCode=@pId AND PharmacyId=@pharmacyId      
         
         
   SELECT       
    SD.bdcode      
   ,PharmacyId      
   ,BillCode      
   ,ProductId      
   ,P.Name AS ProductName      
   ,BatchNo      
   ,Qty      
   ,OldQty      
   ,MfgId AS ManufacturerId      
   ,M.Name As   ManufacturerName 
   --,1 AS UnitId      
   ,ExpiryDate      
   --,Packing      
   --,AssortedQty      
   ,CostPrice    
   ,MRP      
   ,TaxPercent AS VAT      
      
   --,AbatedMRP      
   --,TaxMode      
   --,TaxType      
   --,DiscApplicable      
   --,VATOnDiscount      
   --,VATOnFreeQty      
   --,DiscOnFreeQty      
   --,FreeQtyVATAmount      
   ,DiscPercent AS DiscountPercentage      
   ,Discount AS DiscountAmount      
   --,AssortedCostPrice      
   --,AssortedMRPPrice      
    ,TaxAmount AS VATAmount  
 ,TotalCostPrice  
 --,NetCostPrice  
 ,TotalMRP  
 --,NetMRP  
 --,VatOnDiscountAmount  
 --,DiscOnFreeQtyAmount  
 --,TotalDiscountAmount  
 --,TotalVatAmount  
 --,NetVATAmount  
   --,RackId      
   --,Barcode      
         
   FROM      
   SalesDetails SD      
   INNER JOIN Product P ON P.Id=SD.ProductId   
   LEFT  JOIN Manufacturer M ON M.Id =SD.MfgId    
   WHERE SD.BillCode=@pId AND PharmacyId=@pharmacyId      
               
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
/****** Object:  StoredProcedure [dbo].[GetCreditAuth]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCreditAuth]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  AuthName,
  DepName,
  DesigName,
  FindBy,
  IsActive   
FROM CreditAuth        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetCreditAuths]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCreditAuths]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,
Id,AuthName,DepName,DesigName,FindBy,IsActive FROM CreditAuth  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDepartment]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM Department        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDepartments] 

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,
Id,Name,[Description] As [Desc], IsActive FROM Department  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugCategories]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM DrugCategory  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugCategory]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM DrugCategory        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugContent]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM DrugContent
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugContents]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM DrugContent
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugGeneric]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugGeneric]    
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM DrugGeneric        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugGenerics]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugGenerics]    

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM DrugGeneric  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugType]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM DrugType
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugTypes]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM DrugType
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugUnit]    
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM DrugUnit        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDrugUnits]    

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM DrugUnit  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetDueDetailsforReceivable]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDueDetailsforReceivable]            
(          
@pharmacyId INT,          
@pId BIGINT 
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
  
  DECLARE @IPNo VARCHAR(20) SET @IPNo = (SELECT IPNo FROM Sales WHERE BillCode = @pId)
  
  SELECT DISTINCT Customer, IPNo FROM Sales 
  WHERE PharmacyId = @pharmacyId AND IPNo = @IPNo AND Balance > 0     
  
  SELECT BillCode, BillNo, convert(DATE,BillDate,106) AS BillDate, Customer, IPNo, NetAmount, PaidAmount, Balance FROM Sales 
  WHERE PharmacyId = @pharmacyId AND IPNo = @IPNo AND Balance > 0     
               
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
/****** Object:  StoredProcedure [dbo].[GetDuePatientList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetDuePatientList]

AS 
BEGIN 

SELECT * FROM Sales WHERE BillStatus = 'Balance' AND IPNo IS NOT NULL 

END
GO
/****** Object:  StoredProcedure [dbo].[GetIndentDetailsForBilling]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIndentDetailsForBilling]            
(          
@pharmacyId INT,          
@pId BIGINT       
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
        
  SELECT  
   IndentId     
  ,IndentNo
  ,IndentDate      
  ,Customer
  ,isnull(CustomerID,'') AS RegNo
  ,IPNo
  ,ConsultantName
  ,isnull(ConsultantCode,1) AS ConsultantCode
  ,isnull(DeptName,'') AS DeptName
  ,isnull(Ward,'') AS Ward
  ,isnull(UserName,'') AS IndentedBy
  ,isnull(PayMode,'Cash') AS PayMode
  ,'Male' AS Gender
  ,'29' AS Age
  ,'' AS TPAName
  ,0 AS Balance
  ,0 AS Advance
  ,0 AS BilledAmount
  ,SavedUserID
      
   FROM Indent       
   WHERE IndentId=@pId AND PharmacyId=@pharmacyId      
         
         
   SELECT       
    ID.IndentDetId
   ,I.PharmacyId      
   ,I.IndentId
   ,ID.ProductId      
   ,P.Name AS ProductName      
   ,ID.BatchNo      
   ,ID.Qty      
   ,rs.Qty AS Stock      
   ,ID.MfgId AS ManufacturerId      
   ,M.Name AS ManufacturerName 
   ,ID.ExpDate AS ExpiryDate
   ,rs.CostPrice
   ,rs.MRP
   ,rs.VAT  
   ,(rs.CostPrice * ID.Qty)  AS TotalCostPrice  
   ,(rs.MRP * ID.Qty) AS TotalMRP
   ,(rs.MRP * ID.Qty) * (rs.VAT/100) AS VATAmount
   ,isnull(rs.GRNNo,'GRN') AS GRNNo 
   ,id.PurDetId 
   ,0 AS Discount
         
   FROM      
   IndentDetails ID      
   INNER JOIN Indent I ON I.IndentId = ID.IndentId 
   INNER JOIN Product P ON P.Id=ID.ProductId
   LEFT  JOIN Manufacturer M ON M.Id =ID.MfgId
   LEFT JOIN RunningStock rs ON ID.PurDetId = rs.PurDetId 
   WHERE ID.IndentId=@pId AND I.PharmacyId=@pharmacyId      
               
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
/****** Object:  StoredProcedure [dbo].[GetIndentDueList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIndentDueList]        
  @pharmacyId INT  
AS       
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SET NOCOUNT ON    
    
    
    
BEGIN TRY    
    
SELECT  
  PH.BillCode
 ,PH.BillNo
 ,PH.BillDate
 ,PH.Customer
 ,PH.TotalAmount  
 ,PH.TotalVat  
 ,PH.NetAmount  
 ,PH.PaidAmount
 ,PH.Balance
 ,P.FirstName as AddedFirstName  
 ,P.LastName as AddedLastName  
 ,ph.AddedDateTime   
 ,U.Username   
  
FROM Sales PH  
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId  
INNER JOIN Person P ON P.PersonId=PH.AddedBy  
  
WHERE PH.PharmacyId=@pharmacyId  AND PH.Balance > 0
        ORDER BY PH.BillCode DESC
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    
    
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    
    
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    
     
 WITH SETERROR;    
     
END CATCH    
                        
END
GO
/****** Object:  StoredProcedure [dbo].[GetIndents]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIndents]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON


BEGIN TRY

SELECT row_number() OVER (ORDER BY IndentId) AS Slno,IndentId AS Id,IndentNo + ' / ' + IPNo AS IndentNo ,IPNo As [Desc],Status 
FROM Indent WHERE Status = 'S'  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetIndentsList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIndentsList]        
  @pharmacyId INT  
AS       
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SET NOCOUNT ON    
    
    
    
BEGIN TRY    
    
SELECT  
  PH.IndentId AS IndentId
 ,PH.IndentNo AS IndentNo
 ,PH.IndentDate AS IndentDate
 ,PH.Customer
 ,PH.IPNo  
 ,PH.ConsultantName
 ,PH.DeptName  
 ,PH.Ward
 ,PH.PayMode
 ,PH.Status
 ,PH.IndentUser
 ,P.FirstName as AddedFirstName  
 ,P.LastName as AddedLastName  
 ,ph.AddedDateTime   
 ,U.Username   
  
FROM Indent PH  
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId  
INNER JOIN Person P ON P.PersonId=PH.AddedBy  
  
WHERE PH.PharmacyId=@pharmacyId  --AND PH.IndentDate BETWEEN convert(DATE,getdate()) AND convert(DATE,getdate() + 1)
       ORDER BY PH.IndentId DESC
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    
    
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    
    
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    
     
 WITH SETERROR;    
     
END CATCH    
                        
END
GO
/****** Object:  StoredProcedure [dbo].[GetInternalTransferDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInternalTransferDetails]            
(          
@pharmacyId INT,          
@pId BIGINT       
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
        
  SELECT       
   BillNo AS GrnNo      
  ,BillDate AS GrnDate      
  ,0 AS POrderNo      
  ,1 AS SupplierId      
  ,'' AS SupplierInvNo      
  ,'' AS SupplierInvDate      
  ,0 AS CreditPeriod      
  ,'' CreditDate      
  ,0 AS DiscountPercent      
  ,0 AS DiscountAmount      
  ,TotalAmount      
  ,TotalVAT      
  ,NetAmount      
  ,RoundOff      
  ,BillStatus AS PaidStatus      
  ,PaidAmount      
  ,'' AS Status      
  ,'' AS Comment      
  ,SavedUserID
      
   FROM InternalTransfer      
   WHERE IntTransCode=@pId AND PharmacyId=@pharmacyId      
         
         
   SELECT       
    SD.ITcode AS  bdcode      
   ,PharmacyId      
   ,ITcode AS BillCode      
   ,ProductId      
   ,P.Name AS ProductName      
   ,BatchNo      
   ,Qty      
   ,OldQty      
   ,MfgId AS ManufacturerId      
   ,M.Name As   ManufacturerName 
   --,1 AS UnitId      
   ,ExpiryDate      
   --,Packing      
   --,AssortedQty      
   ,CostPrice    
   ,MRP      
   ,TaxPercent AS VAT      
      
   --,AbatedMRP      
   --,TaxMode      
   --,TaxType      
   --,DiscApplicable      
   --,VATOnDiscount      
   --,VATOnFreeQty      
   --,DiscOnFreeQty      
   --,FreeQtyVATAmount      
   ,DiscPercent AS DiscountPercentage      
   ,Discount AS DiscountAmount      
   --,AssortedCostPrice      
   --,AssortedMRPPrice      
    ,TaxAmount AS VATAmount  
 ,TotalCostPrice  
 --,NetCostPrice  
 ,TotalMRP  
 --,NetMRP  
 --,VatOnDiscountAmount  
 --,DiscOnFreeQtyAmount  
 --,TotalDiscountAmount  
 --,TotalVatAmount  
 --,NetVATAmount  
   --,RackId      
   --,Barcode      
         
   FROM      
   InternalTransferDetails SD      
   INNER JOIN Product P ON P.Id=SD.ProductId   
   LEFT  JOIN Manufacturer M ON M.Id =SD.MfgId    
   WHERE SD.IntTransCode=@pId AND PharmacyId=@pharmacyId      
               
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
/****** Object:  StoredProcedure [dbo].[GetInternalTransferList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInternalTransferList]        
  @pharmacyId INT  
AS       
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SET NOCOUNT ON    
    
    
    
BEGIN TRY    
    
SELECT  
  PH.IntTransCode AS BillCode
 ,PH.BillNo
 ,PH.BillDate
 ,PH.Customer
 ,PH.TotalAmount  
 ,PH.TotalVat  
 ,PH.NetAmount  
 ,PH.PaidAmount
 ,PH.BillStatus
 ,P.FirstName as AddedFirstName  
 ,P.LastName as AddedLastName  
 ,ph.AddedDateTime   
 ,U.Username   
  
FROM InternalTransfer PH  
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId  
INNER JOIN Person P ON P.PersonId=PH.AddedBy  
  
WHERE PH.PharmacyId=@pharmacyId  
        
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    
    
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    
    
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    
     
 WITH SETERROR;    
     
END CATCH    
                        
END
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetManufacturer]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM Manufacturer        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetManufacturers]    

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM Manufacturer  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetNextBillForPharmacy]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNextBillForPharmacy]

   @pharmacyId INT,    

   @NextID VARCHAR(50) OUTPUT

AS
BEGIN
   SET NOCOUNT ON;



   DECLARE @Out TABLE (NextVal INT, Prefix varchar(20))



   UPDATE dbo.Pharmacy

   SET BillIDValue = ISNULL(BillIDValue,0) + 1

   OUTPUT INSERTED.BillIDValue, INSERTED.BillPrefix INTO @Out(NextVal, prefix)

   WHERE Id=@pharmacyId   

   SELECT TOP 1 @nextID = Prefix + CAST(NextVal AS VARCHAR(10)) FROM @Out

   END
GO
/****** Object:  StoredProcedure [dbo].[GetNextGRNForPharmacy]    Script Date: 1/17/2016 12:33:18 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetNextIndentForPharmacy]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNextIndentForPharmacy]

   @pharmacyId INT,    

   @NextID VARCHAR(50) OUTPUT

AS
BEGIN
   SET NOCOUNT ON;



   DECLARE @Out TABLE (NextVal INT, Prefix varchar(20))



   UPDATE dbo.Pharmacy

   SET IndentIDValue = ISNULL(IndentIDValue,0) + 1

   OUTPUT INSERTED.IndentIDValue, INSERTED.IndentPrefix INTO @Out(NextVal, prefix)

   WHERE Id=@pharmacyId   

   SELECT TOP 1 @nextID = Prefix + CAST(NextVal AS VARCHAR(10)) FROM @Out

   END
GO
/****** Object:  StoredProcedure [dbo].[GetProduct]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProduct]
 @Id BIGINT 
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

BEGIN TRY

SELECT   Id,
    	 Classification,
	  	 Name,
		 TypeId,
   		 CategoryId,
		 MainCategoryId,
		 GenericId,
		 ManfId,
		 UnitId,
		 MinStock,
		 MaxStock,
		 ExpiryNotifyinDays,
		 ExpiryDays,
		 SuppTakenBeforExpiryDays,
		 TakenBeforeDays,
		 SuppTakenAfterExpiryDays,
		 TakenAfterDays,
    	 IsActive     
FROM Product        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetProductMaster]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductMaster]  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
BEGIN TRY  
  
SELECT  
    prd.Name,  
    prd.Id
FROM Product prd  


  
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END

GO
/****** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProducts]  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
BEGIN TRY  
/*
SELECT  DISTINCT 
    row_number() OVER (ORDER BY prd.Name) AS Slno,  
    prd.Id,  
    isnull(prd.Classification,'S') AS Classification,  
    prd.Name AS DrugName,  
    type.Name AS Type,  
    --'<table><tr><td width=150>' + prd.Name +' </td><td width=40>' + convert(VARCHAR,stock.Qty) + ' </td><td width=100>' + stock.BatchNo + '</td><td width=50>' + stock.ExpiryDate + '</td></tr></table>'
    cat.Name AS Category,  
    '0' AS Stock,
    '' AS BatchNo,
    '' AS ExpiryDate,
    '0' AS PurDetId,
    '' AS GRNNo, 
    '' AS GrnDate,
    cont.Name AS MainCategory,  
    gen.Name AS Generic,  
    mfg.Name AS Manufacture,  
    mfg.Id AS ManufactureId,
    unit.Name AS Unit,  
    prd.UnitId AS UnitId,
 prd.MinStock,  
 prd.MaxStock,  
 prd.ExpiryNotifyinDays,  
 prd.ExpiryDays,  
 prd.SuppTakenBeforExpiryDays,  
 prd.TakenBeforeDays,  
 prd.SuppTakenAfterExpiryDays,  
 prd.TakenAfterDays,  
    prd.IsActive,
    0 AS CostPrice,
    0 AS MRP,
    0 AS VAT   
FROM Product prd  
INNER JOIN Drugtype type ON prd.typeId=type.Id  
INNER JOIN DrugCategory cat ON cat.Id =prd.CategoryId   
INNER JOIN Drugcontent cont ON cont.Id =prd.MainCategoryId  
INNER JOIN DrugGeneric gen ON gen.Id =prd.GenericId  
INNER JOIN manufacturer mfg ON mfg.Id=prd.ManfId  
INNER JOIN DrugUnit unit ON unit.Id=prd.UnitId  
--INNER JOIN RunningStock stock ON stock.ProductId = prd.Id 
--WHERE stock.Qty > 0 
*/

SELECT  DISTINCT 
    row_number() OVER (ORDER BY prd.Name) AS Slno,  
    prd.Id,  
    isnull(prd.Classification,'S') AS Classification,  
    prd.Name AS DrugName,  
    type.Name AS Type,  
    '<table><tr><td width=150>' + prd.Name +' </td><td width=40>' + convert(VARCHAR,stock.Qty) + ' </td><td width=100>' + stock.BatchNo + '</td><td width=50>' + stock.ExpiryDate + '</td></tr></table>'
    AS Category,  
    convert(VARCHAR,stock.Qty) AS Stock,
    stock.BatchNo,
    stock.ExpiryDate,
    convert(VARCHAR,stock.PurDetId) AS PurDetId,
    stock.GrnNo AS GRNNo, 
    '' AS GrnDate,
    cont.Name AS MainCategory,  
    gen.Name AS Generic,  
    mfg.Name AS Manufacture,  
    mfg.Id AS ManufactureId,
    unit.Name AS Unit,  
    prd.UnitId AS UnitId,
 prd.MinStock,  
 prd.MaxStock,  
 prd.ExpiryNotifyinDays,  
 prd.ExpiryDays,  
 prd.SuppTakenBeforExpiryDays,  
 prd.TakenBeforeDays,  
 prd.SuppTakenAfterExpiryDays,  
 prd.TakenAfterDays,  
    prd.IsActive,
    stock.CostPrice,
    stock.MRP,
    stock.VAT   
FROM Product prd  
INNER JOIN Drugtype type ON prd.typeId=type.Id  
INNER JOIN DrugCategory cat ON cat.Id =prd.CategoryId   
INNER JOIN Drugcontent cont ON cont.Id =prd.MainCategoryId  
INNER JOIN DrugGeneric gen ON gen.Id =prd.GenericId  
INNER JOIN manufacturer mfg ON mfg.Id=prd.ManfId  
INNER JOIN DrugUnit unit ON unit.Id=prd.UnitId  
INNER JOIN RunningStock stock ON stock.ProductId = prd.Id 
WHERE stock.Qty >0 

END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END

GO
/****** Object:  StoredProcedure [dbo].[GetProductsforBill]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductsforBill]  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
BEGIN TRY  

SELECT  DISTINCT 
    row_number() OVER (ORDER BY prd.Name) AS Slno,  
    prd.Id,  
    isnull(prd.Classification,'S') AS Classification,  
    prd.Name AS DrugName,  
    type.Name AS Type,  
    '<table><tr><td width=150>' + prd.Name +' </td><td width=40>' + convert(VARCHAR,stock.Qty) + ' </td><td width=100>' + stock.BatchNo + '</td><td width=50>' + stock.ExpiryDate + '</td></tr></table>'
    AS Category,  
    convert(VARCHAR,stock.Qty) AS Stock,
    stock.BatchNo,
    stock.ExpiryDate,
    convert(VARCHAR,stock.PurDetId) AS PurDetId,
    stock.GrnNo AS GRNNo, 
    '' AS GrnDate,
    cont.Name AS MainCategory,  
    gen.Name AS Generic,  
    mfg.Name AS Manufacture,  
    mfg.Id AS ManufactureId,
    unit.Name AS Unit,  
    prd.UnitId AS UnitId,
 prd.MinStock,  
 prd.MaxStock,  
 prd.ExpiryNotifyinDays,  
 prd.ExpiryDays,  
 prd.SuppTakenBeforExpiryDays,  
 prd.TakenBeforeDays,  
 prd.SuppTakenAfterExpiryDays,  
 prd.TakenAfterDays,  
    prd.IsActive,
    stock.CostPrice,
    stock.MRP,
    stock.VAT   
FROM Product prd  
INNER JOIN Drugtype type ON prd.typeId=type.Id  
INNER JOIN DrugCategory cat ON cat.Id =prd.CategoryId   
INNER JOIN Drugcontent cont ON cont.Id =prd.MainCategoryId  
INNER JOIN DrugGeneric gen ON gen.Id =prd.GenericId  
INNER JOIN manufacturer mfg ON mfg.Id=prd.ManfId  
INNER JOIN DrugUnit unit ON unit.Id=prd.UnitId  
INNER JOIN RunningStock stock ON stock.ProductId = prd.Id 
WHERE stock.Qty >0 
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
CREATE PROCEDURE [dbo].[GetPurchaseDetails]            
(          
@pharmacyId INT,          
@pId BIGINT      
          
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
   ,M.Name As   ManufacturerName 
   ,PD.UnitId      
   ,ExpiryDate      
   ,Packing      
   ,AssortedQty      
   ,CostPrice    
   ,MRP      
   ,VAT      
      
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
    ,VATAmount  
 ,TotalCostPrice  
 ,NetCostPrice  
 ,TotalMRP  
 ,NetMRP  
 ,VatOnDiscountAmount  
 ,DiscOnFreeQtyAmount  
 ,TotalDiscountAmount  
 ,TotalVatAmount  
 ,NetVATAmount  
   ,RackId      
   ,Barcode      
         
   FROM      
   PurchaseDetail PD      
   INNER JOIN Product P ON P.Id=PD.ProductId   
   INNER JOIN Manufacturer M ON M.Id =PD.MfgId    
   WHERE PHeaderId=@pId AND PharmacyId=@pharmacyId      
         
           
        
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
/****** Object:  StoredProcedure [dbo].[GetPurchaseList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPurchaseList]        
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
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId  
INNER JOIN Person P ON P.PersonId=PH.AddedBy  
  
WHERE PH.PharmacyId=@pharmacyId  --AND PH.GrnDate BETWEEN convert(DATE,getdate()) AND convert(DATE,getdate() + 1)
        ORDER BY PH.Id DESC 
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    
    
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    
    
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    
     
 WITH SETERROR;    
     
END CATCH    
                        
END
GO
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRack]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM Rack        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRacks]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Adm.IAD_CODE) AS Slno,  
-- Adm.IAD_CODE 
row_number() OVER (ORDER BY Adm.IAD_CODE) AS Id,Adm.IAD_IP_ADMISSION_NO AS Name,'' As [Desc],1 AS IsActive,
Pat.P_Patient_Fname AS PatientName,
convert(VARCHAR,Pat.P_AGE) + ' / ' + 'Male' AS Age,
Pat.P_REG_NO AS RegNo,
Adm.IAD_PAYMENT_TYPE AS PayMode,
'Gen' AS Ward,'Dr. Varalakshmi' AS Consultant
FROM [HBS].[dbo].[Patient_Mstr] pat
INNER JOIN [HBS].[dbo].[IP_Admission] Adm ON pat.[P_IP_MRN_NO] = Adm.[IAD_P_IP_MRN_NO]
WHERE Adm.[IAD_PATIENT_STATUS] = 'Admitted'

 --SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM Rack  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetSaleList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSaleList]
  @pharmacyId INT  

AS 

BEGIN 
SELECT 1 AS Id,'Bill1' AS BillNo,convert(DATE,'22-Sep-2015') AS BillDate,
'Daria' AS CustomerName,1500 AS BillAmount,0 AS Discount,150 AS VatAmount,
0 AS Balance,'Cash' AS PayMode,
convert(DATE,'22-Sep-2015') AS AddedDateTime ,'bala' AS Username 
END
GO
/****** Object:  StoredProcedure [dbo].[GetSalesList]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSalesList]        
  @pharmacyId INT  
AS       
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SET NOCOUNT ON    
    
    
    
BEGIN TRY    
    
SELECT  
  PH.BillCode
 ,PH.BillNo
 ,PH.BillDate
 ,PH.Customer
 ,PH.TotalAmount  
 ,PH.TotalVat  
 ,PH.NetAmount  
 ,PH.PaidAmount
 ,PH.BillStatus
 ,P.FirstName as AddedFirstName  
 ,P.LastName as AddedLastName  
 ,ph.AddedDateTime   
 ,U.Username   
  
FROM Sales PH  
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId  
INNER JOIN Person P ON P.PersonId=PH.AddedBy  
  
WHERE PH.PharmacyId=@pharmacyId  AND PH.BillDate BETWEEN '26/Dec/2015' AND '27/Dec/2015' --convert(DATE,getdate())  AND convert(DATE,getdate() + 1)
        ORDER BY PH.BillCode DESC
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;    
    
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();    
    
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )    
     
 WITH SETERROR;    
     
END CATCH    
                        
END
GO
/****** Object:  StoredProcedure [dbo].[GetSupplier]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSupplier]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT Id,   
  Name,
  TypeId,
  Address ,
  TinNo,
  City,
  State,
  Country,
  ContactPerson,
  Email,
  Phone,
  Fax,
  Pincode, 
  MobileNo,
  IsActive  
FROM Supplier        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetSuppliers]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSuppliers]  
  
AS     
  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
BEGIN TRY  
  
SELECT   
row_number() OVER (ORDER BY sup.Id) AS Slno,  
sup.Id,  
sup.Name,  
sup.TypeId,  
type.Name AS Type,  
sup.Address ,  
sup.TinNo,  
sup.City,  
sup.State,  
sup.Country,  
sup.ContactPerson,  
sup.DueDays,  
sup.Email,  
sup.Phone,  
sup.Fax,  
sup.Pincode,   
sup.MobileNo,  
sup.IsActive FROM Supplier sup INNER JOIN DrugType type ON type.Id = sup.TypeId  
      
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;  
  
 SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();  
  
 RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )  
   
 WITH SETERROR;  
   
END CATCH  
                      
END

GO
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTax]
 @Id INT
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT    
  Id,
  Name,        
  [Description] As [Desc],     
  IsActive     
FROM Tax        
WHERE Id = @Id

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTaxs]

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM Tax  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserLogonDetails]          

(          

@UserName NVarchar(100)           

)          

AS          

BEGIN          

          

SELECT        

U.UserId,          

U.PharmacyId,        

U.UserName,          

U.Password,          

U.EmailId,          

P.PersonId,        

P.FirstName,        

P.LastName,        

U.IsAccountLocked,          

U.FailedLoginAttempt,          

U.NeedPasswordReset,        

U.LastLoginDate,          

U.RoleId, 

R.RoleName,

R.LandingPage, 

U.UserType       

          

FROM          

          

ApplicationUser U          

INNER JOIN Person P ON P.PersonId=U.PersonId      

INNER JOIN ApplicationRole R ON R.RoleId=U.RoleId

WHERE U.UserName=@UserName        

    

    

 SELECT    

	 AM.Id AS ModuleId,    

	 AM.[Key] As ModuleKey,    

	 AM.Name As ModuleName,    

	 AM.[Description] As ModuleDesc,    

	 AM.LandingPage AS ModuleLandingPage,    

	 AM.IsActive AS IsModuleActive,    

	 AF.Id AS FeatureId,    

		AF.[Key] AS FeatureKey,    

		AF.Name AS FeatureName,    

		AF.[Description] As FeatureDesc,  

		AF.MenuId ,     

	 AF.IsActive AS IsFeatureActive,    

	 AF.ParentId AS ParentFeatureId    



     

  FROM ApplicationUser U      

  

  INNER JOIN  RoleXFeature RF ON RF.RoleIid=U.RoleId    

  INNER JOIN  ApplicationFeature AF ON AF.Id=RF.FeatureId      

  INNER JOIN  ApplicationModule AM ON AM.Id=AF.ModuleId    

    

  INNER JOIN PharmacyXModule PM ON PM.ModuleId=AM.Id      

    

  WHERE U.UserName=@UserName          

          

END


GO
/****** Object:  StoredProcedure [dbo].[RetriveDrugtype]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RetriveDrugtype]
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT Name AS [DrugTypeName] FROM DrugType  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[RetriveManufact]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RetriveManufact]
@Name NVARCHAR(30)
AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY
--DECLARE @Name VARCHAR(30) SET @Name='daria'
SELECT Name  FROM Manufacturer  
WHERE Name LIKE +@Name+'%'
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[SavePurchaseHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SavePurchaseHeader]    
	@PharmacyId int,
	@GrnNo nvarchar(50),
	@GrnDate smalldatetime,
	@POrderNo bigint,
	@SupplierId bigint,
	@SupplierInvNo nvarchar(50),
	@SupplierInvDate smalldatetime,
	@CreditPeriod int,
	@CreditDate smalldatetime,
	@DiscountPercent decimal(18,3),
	@DiscountAmount decimal(18,3),
	@TotalAmount decimal(18,3),
	@TotalVAT decimal(18,3),
	@NetAmount decimal(18,3),
	@RoundOff decimal(18,3),
	@PaidStatus bit,
	@PaidAmount decimal(18,3),
	@Status varchar(10),
	@Comment nvarchar(250),
	@AddedBy bigint,
	@AddedDateTime smalldatetime,
	@AddedUserName nvarchar(100)

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

INSERT INTO PurchaseHeader
( 	
	PharmacyId,
	GrnNo,
	GrnDate,
	POrderNo,
	SupplierId,
	SupplierInvNo,
	SupplierInvDate,
	CreditPeriod,
	CreditDate,
	DiscountPercent,
	DiscountAmount,
	TotalAmount,
	TotalVAT,
	NetAmount,
	RoundOff,
	PaidStatus,
	PaidAmount,
	Status,
	Comment,
	AddedBy,
	AddedDateTime,
	AddedUserName
)
VALUES
(
	@PharmacyId,
	@GrnNo,
	@GrnDate,
	@POrderNo,
	@SupplierId,
	@SupplierInvNo,
	@SupplierInvDate,
	@CreditPeriod,
	@CreditDate,
	@DiscountPercent,
	@DiscountAmount,
	@TotalAmount,
	@TotalVAT,
	@NetAmount,
	@RoundOff,
	@PaidStatus,
	@PaidAmount,
	@Status,
	@Comment,
	@AddedBy,
	@AddedDateTime,
	@AddedUserName
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

GO
/****** Object:  StoredProcedure [dbo].[SearchPurchase]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

               
  
CREATE PROCEDURE [dbo].[SearchPurchase]          
  
(          
  
  @PharmacyId INT          
  
 ,@pageSize INT = 10          
  
 ,@page INT          
  
 ,@OrderBy VARCHAR(50)='Id_Desc'        
  
 ,@GrnNo NVARCHAR(50) =''        
  
 ,@GrnDate SMALLDATETIME=NULL  
  
 ,@InvoiceNo NVARCHAR(50) =''       
  
 ,@AddedById BIGINT =0          
  
 ,@SupplierId INT=0          
  
 ,@AddedFromDate SMALLDATETIME=''          
  
 ,@AddedToDate SMALLDATETIME =''     
  
 ,@totalRows INT OUTPUT          
  
 ,@totalPages INT OUTPUT          
  
)          
  
AS          
  
BEGIN          
  
 SET XACT_ABORT ON          
  
 SET NOCOUNT ON          
  
 IF(@PharmacyId IS NULL)          
  
      RAISERROR('The value for @PharmacyId should not be null', 15, 1) -- with log          
  
                  
  
 DECLARE @sql NVARCHAR(MAX)          
  
   ,@sqlSelect NVARCHAR(MAX) = ''          
  
   ,@sqlTableVariable NVARCHAR(MAX) = ''          
  
   ,@sqlInto NVARCHAR(MAX) = ''          
  
   ,@sqlFrom NVARCHAR(MAX) = ''          
  
   ,@sqlClause NVARCHAR(MAX) = ''          
  
   ,@sqlGroup NVARCHAR(MAX) = ''          
  
   ,@params NVARCHAR(MAX)          
  
  
  
   ,@gpsSearch bit = 0          
  
   ,@sortOrderString NVARCHAR(MAX) = 'ORDER BY PH.Id DESC'        
  
   ,@sortOrderString2 NVARCHAR(MAX) = ''          
  
                
  
 IF (@OrderBy = 'Id_Desc')        
  
  SET @sortOrderString = 'ORDER BY PH.Id DESC'        
  
 ELSE IF (@OrderBy = 'Id_asc')        
  
  SET @sortOrderString = 'ORDER BY PH.Id ASC'        
  
 ELSE IF (@OrderBy = 'GRN_asc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnNo ASC'          
  
 ELSE IF (@OrderBy = 'GRN_Desc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnNo DESC'          
  
 ELSE IF (@OrderBy = 'GrnDate_asc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnDate ASC'          
  
 ELSE IF (@OrderBy = 'GrnDate_desc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnDate DESC'   
  
 ELSE IF (@OrderBy = 'Supplier.Name_asc')          
  
  SET @sortOrderString = 'ORDER BY S.Name ASC'          
  
 ELSE IF (@OrderBy = 'Supplier.Name_desc')          
  
  SET @sortOrderString = 'ORDER BY S.Name DESC'   
         
  
 IF (@pageSize = 0)          
  
  SET @pageSize = 10          
  
            
  
 IF (@page <= 0)          
  
  SET @page = 1          
  
            
  
 SET @sqlTableVariable='DECLARE @PurchaseSearch TABLE(          
  
[Id] [bigint] NOT NULL,          
  
[GrnNo] [nvarchar](50) NULL,          
  
[GrnDate] smalldatetime NOT NULL,          
  
[SupplierInvNo] [nvarchar](50) NULL,          
  
[SupplierName] [nvarchar](100) NOT NULL,   
  
[AddedFirstName] [nvarchar](100) NULL,          
  
[AddedLastName] [nvarchar](100) NULL,          
  
[RowNumber] [bigint] NULL          
  
)'          
  
            
  
 SET @sqlSelect =          
  
  'SELECT   
  
  PH.Id          
  
 ,PH.GrnNo          
  
 ,PH.GrnDate          
  
 ,PH.SupplierInvNo          
  
 ,S.Name      
  
 ,P.FirstName AS AddedFirstName          
  
 ,P.LastName AS AddedLastName                 
  
 ,ROW_NUMBER() OVER (' + @sortOrderString + ') AS RowNumber'          
  
             
  
 SET @sqlGroup =' GROUP BY PH.Id          
  
 ,PH.GrnNo          
  
 ,PH.GrnDate          
  
 ,PH.SupplierInvNo          
  
 ,S.Name      
  
 ,P.FirstName          
  
 ,P.LastName  '          
  
            
  
 SET @sqlFrom =          
  
  ' FROM PurchaseHeader PH         
  
INNER JOIN Supplier S ON S.Id=PH.SupplierId         
  
LEFT JOIN ApplicationUser U ON U.UserId=PH.SavedUserId    
  
INNER JOIN Person P ON P.PersonId=PH.AddedBy          
  
'          
  
             
  
            
  
  SET @sqlClause =' WHERE PH.PharmacyId = @PharmacyId'          
  
            
  
   IF (@GrnNo <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((PH.GrnNo LIKE ''%' + @GrnNo + '%''))'           
  
    
  
              
  
  IF (@InvoiceNo <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((PH.SupplierInvNo LIKE ''%' + @InvoiceNo + '%''))'          
  
                
  
     
  
   IF (@GrnDate <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((CONVERT(VARCHAR(10), PH.GrnDate, 120)  = '''+ convert(varchar(10), @GrnDate, 120) +''' ))'      
  
            
  
  IF (@AddedFromDate <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((CONVERT(VARCHAR(10), PH.AddedDateTime, 120) >= '''+ convert(varchar(10), @AddedFromDate, 120) +''' ))'          
  
            
  
  IF (@AddedToDate <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((CONVERT(VARCHAR(10), PH.AddedDateTime, 120) <= '''+ convert(varchar(10), @AddedToDate, 120) +''' ))'          
  
                
  
  IF (@AddedById > 0)          
  
     SET @sqlClause = @sqlClause +          
  
      ' AND PH.AddedBy = @AddedById'          
  
    
  
  IF (@SupplierId > 0)          
  
  BEGIN          
  
    
  
   SET @sqlClause = @sqlClause +          
  
    ' AND PH.SupplierId = @SupplierId '          
  
             
  
  END          
  
            
  
  SET @sqlInto = ' INSERT INTO @PurchaseSearch ';          
  
              
  
  SET @sql = @sqlTableVariable +          
  
     @sqlInto +          
  
     @sqlSelect+          
  
     @sqlFrom +          
  
     @sqlClause +          
  
     @sqlGroup          
  
            
  
  SET @sql = @sql + ';          
  
SELECT @totalRows = @@ROWCOUNT          
  
,@totalPages = (@totalRows / @pageSize) + 1;          
  
SELECT *          
  
FROM @PurchaseSearch AS IT          
  
WHERE RowNumber BETWEEN (@page - 1) * @pageSize + 1 AND @pageSize * @page          
  
' + @sortOrderString2 + ';'          
  
               
  
               
  
            
  
  SELECT @params =          
  
   N'@PharmacyId INT, ' +          
  
   N'@pageSize int,' +          
  
   N'@page int,' +          
  
   N'@GrnNo NVARCHAR(50), ' +          
  
   N'@GrnDate SMALLDATETIME, ' +          
  
   N'@InvoiceNo NVARCHAR(50), ' +             
  
   N'@AddedById BIGINT,' +          
  
   N'@SupplierId INT,' +            
  
   N'@totalRows int OUTPUT,' +          
  
   N'@totalPages int OUTPUT'          
  
                
--PRINT @sql  
     
  
                
  
 EXEC sp_executesql @sql          
  
   ,@params          
  
   ,@PharmacyId          
  
   ,@pageSize          
  
   ,@page          
  
   ,@GrnNo        
  
   ,@GrnDate         
  
   ,@InvoiceNo           
  
   ,@AddedById          
  
   ,@SupplierId    
  
   ,@totalRows OUTPUT          
  
   ,@totalPages OUTPUT          
  
END          


GO
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROC [dbo].[spUDSRGenerateRPSRistaData]
@Date DATETIME,
@flgRPS INT,
@flgRishta INT

AS


DECLARE @Month INT
DECLARE @Month1 INT
DECLARE @Month2 INT
DECLARE @Month3 INT
DECLARE @Qtr INT
DECLARE @Year INT

EXEC spUDSRL4VstMain @Date


SET @Year = DATEPART(yyyy,@Date)
SET @Month = DATEPART(mm,@Date)

IF(@Month = 1 OR @Month = 2 OR @Month = 3)
	Begin
		SET @Qtr = 3
		SET @Month1 = 1
		SET @Month2 = 2
		SET @Month3 = 3
	End
ELSE IF(@Month = 4 OR @Month = 5 OR @Month = 6)
	Begin
		SET @Qtr = 4
		SET @Month1 = 4
		SET @Month2 = 5
		SET @Month3 = 6
	End
ELSE IF(@Month = 7 OR @Month = 8 OR @Month = 9)
	Begin
		SET @Qtr = 1
		SET @Month1 = 7
		SET @Month2 = 8
		SET @Month3 = 9
	End
ELSE
	Begin
		SET @Qtr = 2
		SET @Month1 = 10
		SET @Month2 = 11
		SET @Month3 = 12
	End

DECLARE @RPSDate DATETIME
SET @RPSDate=CAST(CAST(DATEPART(yyyy, @Date) as varChar(4)) + '/' + CAST(DATEPART(mm, @Date) as varChar(2)) + '/01' AS DATETIME)
SET @RPSDate=DATEADD(d, -1, DATEADD(m, 1, @RPSDate))

IF @flgRPS=1
	BEGIN
		EXEC spRPSNormsCalculation @Qtr, @Year , @RPSDate
	END
IF @flgRishta=1
	BEGIN
		EXEC spRishtaCalculation @Month1, @Month2, @Month3, @Year
	END

EXEC spUDSRGetJacks @Month1, @Month2, @Month3, @Year

--Generate Sales & SRN Temp Tables..

DECLARE @TgtDate DATETIME

SET @TgtDate=DATEADD(d, -1, @Date)

TRUNCATE TABLE tblUDSRSalesReturnProduct
TRUNCATE TABLE tblUDSRSalesInvoiceProduct
TRUNCATE TABLE tblUDSRSalesReturn
TRUNCATE TABLE tblUDSRSalesInvoice

INSERT INTO tblUDSRSalesInvoice
SELECT * FROM SalesInvoice WHERE DATEPART(d,SalInvDte) = DATEPART(d,@TgtDate) AND DATEPART(mm,SalInvDte) = DATEPART(mm,@TgtDate) AND
DATEPART(yyyy,SalInvDte) = DATEPART(yyyy,@TgtDate)

INSERT INTO tblUDSRSalesInvoiceProduct
SELECT     SalesInvoiceProduct.*
FROM         SalesInvoice INNER JOIN
                      SalesInvoiceProduct ON SalesInvoice.SalInvNo = SalesInvoiceProduct.SalInvNo
WHERE DATEPART(d,SalInvDte) = DATEPART(d,@TgtDate) AND DATEPART(mm,SalInvDte) = DATEPART(mm,@TgtDate) AND
DATEPART(yyyy,SalInvDte) = DATEPART(yyyy,@TgtDate)

INSERT INTO tblUDSRSalesReturn
SELECT * FROM SalesReturn WHERE DATEPART(d,SrDate) = DATEPART(d,@TgtDate) AND DATEPART(mm,SrDate) = DATEPART(mm,@TgtDate) AND
DATEPART(yyyy,SrDate) = DATEPART(yyyy,@TgtDate)

INSERT INTO tblUDSRSalesReturnProduct
SELECT     SalesReturnProduct.*
FROM         SalesReturn INNER JOIN
                      SalesReturnProduct ON SalesReturn.SrKeyNo = SalesReturnProduct.SrKeyNo
WHERE DATEPART(d,SrDate) = DATEPART(d,@TgtDate) AND DATEPART(mm,SrDate) = DATEPART(mm,@TgtDate) AND
DATEPART(yyyy,SrDate) = DATEPART(yyyy,@TgtDate)


GO
/****** Object:  StoredProcedure [dbo].[UpdateBank]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBank]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Bank
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateCreditAuth]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCreditAuth]
 @Id INT,
 @AuthName NVARCHAR(20),
 @DepName NVARCHAR(500),
 @DesigName NVARCHAR(500),
 @FindBy NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE CreditAuth
SET         
  AuthName = @AuthName,        
  DepName=@DepName, 
  DesigName=@DesigName,
  FindBy= @FindBy,   
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDepartment]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Department
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugCategory]    
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE DrugCategory        
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugContent]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE DrugContent
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugGeneric]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugGeneric]    
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE DrugGeneric        
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugType]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE DrugType
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugUnit]    
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE DrugUnit        
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateManufacturer]    
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Manufacturer        
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateProduct]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProduct]
    @Id             BIGINT,
    @Classification CHAR(1),
	@Name           NVARCHAR (500),
	@TypeId           INT,
   	@CategoryId       INT,	
	@MainCategoryId   INT,
	@GenericId        INT,
	@ManfId           INT,
	@UnitId           INT,
	@MinStock       INT,
	@MaxStock       INT,
	@ExpiryNotifyinDays  INT,
	@ExpiryDays          INT,
	@SuppTakenBeforExpiryDays  INT,
	@TakenBeforeDays     INT,
	@SuppTakenAfterExpiryDays  INT,
	@TakenAfterDays      INT,
    @IsActive        BIT,
    @RowsAffected    INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

BEGIN TRY

UPDATE Product
SET         
    Classification 		=@Classification,
	Name     			=@Name,
	TypeId   			=@TypeId,
   	CategoryId 			=@CategoryId,
	MainCategoryId 		=@MainCategoryId,
	GenericId   		=@GenericId,
	ManfId 				=@ManfId,
	UnitId 				=@UnitId,
	MinStock  			=@MinStock,
	MaxStock 			=@MaxStock,
	ExpiryNotifyinDays  =@ExpiryNotifyinDays,
	ExpiryDays  		=@ExpiryDays,
	SuppTakenBeforExpiryDays 	=@SuppTakenBeforExpiryDays,
	TakenBeforeDays				=@TakenBeforeDays,
	SuppTakenAfterExpiryDays 	=@SuppTakenAfterExpiryDays,
	TakenAfterDays 				=@TakenAfterDays,
    IsActive   					=@IsActive
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdatePurchaseHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
    
CREATE PROCEDURE [dbo].[UpdatePurchaseHeader]   
(            
@Id bigint,    
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
    
@UpdatedBy BIGINT,        
    
@UpdatedDateTime smalldatetime,        
    
@savedUserId INT,  
@RowsAffected    INT OUTPUT            
    
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
    
  UPDATE PurchaseHeader   
	 SET   
	 GrnDate=@grnDate,           
	 POrderNo= @orderNo,         
	 SupplierId=@supplierId,  
	 SupplierInvNo=@supInvNo,  
	 SupplierInvDate=@supInvDate,  
	 CreditPeriod=@creditPeriod,  
	 CreditDate=@creditDate,  
	 DiscountPercent=@discountPercent,  
	 DiscountAmount=@discountAmount,  
	 TotalAmount=@totalAmount,  
	 TotalVAT=@totalVAT,     
	 NetAmount=@netAmount,   
	 RoundOff=@roundOff ,  
	 PaidStatus=@isPaid,    
	 PaidAmount=@paidAmount,    
	 Status=@status,        
	 Comment=@comment,   
	 UpdatedBy=@UpdatedBy,     
	 UpdatedDateTime=@UpdatedDateTime,  
	 SavedUserId=@savedUserId       
    
WHERE Id = @Id    

    
SELECT @RowsAffected = @@ROWCOUNT    
    
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
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRack]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Rack
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateSupplier]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSupplier]
    @Id INT,
 	@Name        NVARCHAR (100),
	@TypeId      int,
	@Address     NVARCHAR (500),
	@TinNo       NVARCHAR (100),
	@City        VARCHAR (100),
	@State       VARCHAR (100),
	@Country     VARCHAR (50),
	@ContactPerson NVARCHAR (100),
	@Email    NVARCHAR (100),
	@Phone       NVARCHAR(50),
	@Fax        NVARCHAR (100),
	@Pincode    NVARCHAR(10),
	@MobileNo NVARCHAR(12),
    @IsActive BIT,
    @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Supplier
SET         
  Name = @Name,
  TypeId = @TypeId,
  Address = @Address,
  TinNo = @TinNo,
  City = @City,
  State =@State ,
  Country =@Country ,
  ContactPerson = @ContactPerson,
  Email = @Email,
  Phone = @Phone,
  Fax = @Fax,
  Pincode =@Pincode , 
 MobileNo =@MobileNo ,
 IsActive = @IsActive   
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTax]
 @Id INT,
 @Name NVARCHAR(20),
 @Desc NVARCHAR(500),
 @IsActive bit,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

UPDATE Tax
SET         
  Name = @Name,        
  [Description]=@Desc,     
  IsActive= @IsActive     
        
WHERE Id = @Id

SET @RowsAffected = @@ROWCOUNT

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END


GO
/****** Object:  StoredProcedure [dbo].[VerifyUserCredentials]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VerifyUserCredentials]            
  
(            
  
@UserName NVarchar(100)             ,
@pharmacyId BIGINT

)            
  
AS            
  
BEGIN            
  
            
  
SELECT          
  
U.UserId,            
  
U.PharmacyId,          
  
U.UserName,            
  
U.Password   
  
FROM              
  
ApplicationUser U      
  
INNER JOIN Person P ON P.PersonId=U.PersonId   
WHERE U.UserName=@UserName  AND  U.PharmacyId=@pharmacyId
  
      
            
  
END  

GO
/****** Object:  Table [dbo].[ApplicationFeature]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationFeature](
	[Id] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[IsActive] [bit] NULL,
	[AddedBy] [int] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[IsDeleted] [bit] NULL,
	[ParentId] [int] NULL,
	[MenuId] [int] NULL,
 CONSTRAINT [PK_ApplicationFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationMenu]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationMenu](
	[Id] [int] NOT NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[DisplayImageClass] [nvarchar](255) NULL,
	[URL] [nvarchar](500) NOT NULL,
	[ParentId] [int] NULL,
	[Order] [int] NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationModule]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationModule](
	[Id] [int] NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[LandingPage] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[IsActive] [bit] NULL,
	[AddedBy] [int] NOT NULL,
	[AddedDateTime] [smalldatetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_ApplicationModule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApplicationRole](
	[RoleId] [int] NOT NULL,
	[PharmacyId] [int] NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[RoleDescription] [nvarchar](150) NULL,
	[IsDeleted] [bit] NULL,
	[AddedBy] [int] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[LandingPage] [varchar](200) NULL,
 CONSTRAINT [PK_ApplicationRole] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApplicationUser]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[PersonId] [int] NULL,
	[Username] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[EmailId] [nvarchar](100) NULL,
	[RoleId] [int] NOT NULL,
	[LastLoginDate] [smalldatetime] NULL,
	[FailedLoginDate] [smalldatetime] NULL,
	[IsActive] [bit] NULL,
	[IsAccountLocked] [bit] NULL,
	[FailedLoginAttempt] [int] NULL,
	[IsDeleted] [bit] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[UserType] [tinyint] NOT NULL,
	[NeedPasswordReset] [bit] NOT NULL,
 CONSTRAINT [PK__ApplicationUser__UserId] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Bank__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Consultant]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Consultant](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Consultant__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CreditAuth]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditAuth](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuthName] [nvarchar](100) NOT NULL,
	[DepName] [nvarchar](100) NULL,
	[DesigName] [nvarchar](100) NULL,
	[FindBy] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__CreditAuth__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Department]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Department__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugCategory]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__DrugCategory__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugContent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugContent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__DrugContent__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugGeneric]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugGeneric](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__DrugGeneric__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__DrugType__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugUnit]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugUnit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__DrugUnit__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Indent]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Indent](
	[IndentId] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[IndentNo] [varchar](20) NULL,
	[IndentDate] [smalldatetime] NULL,
	[Customer] [varchar](100) NULL,
	[CustomerID] [varchar](20) NULL,
	[IPNo] [varchar](20) NULL,
	[ConsultantName] [varchar](20) NULL,
	[ConsultantCode] [bigint] NULL,
	[DeptName] [varchar](50) NULL,
	[Ward] [varchar](20) NULL,
	[UserName] [varchar](20) NULL,
	[PayMode] [varchar](10) NULL,
	[Status] [nchar](10) NULL,
	[Cancel] [nchar](10) NULL,
	[CancelDate] [datetime] NULL,
	[CancelUser] [varchar](20) NULL,
	[Edit] [nchar](10) NULL,
	[EditDate] [datetime] NULL,
	[EditUser] [varchar](20) NULL,
	[IndentFor] [varchar](20) NULL,
	[IndentUser] [varchar](20) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[SavedUserID] [bigint] NULL,
 CONSTRAINT [PK_Indent] PRIMARY KEY CLUSTERED 
(
	[IndentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IndentDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IndentDetails](
	[IndentDetId] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[IndentId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[MfgId] [int] NULL,
	[ExpDate] [varchar](10) NULL,
	[GRNNo] [varchar](20) NULL,
	[PurDetId] [bigint] NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[TaxPercent] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 3) NULL,
	[CancelFlag] [bit] NULL,
	[EditProduct] [bit] NULL,
	[OldQty] [int] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_IndentDetails] PRIMARY KEY CLUSTERED 
(
	[IndentDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InternalTransfer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InternalTransfer](
	[IntTransCode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[BillNo] [varchar](20) NULL,
	[BillDate] [smalldatetime] NULL,
	[BillTime] [datetime] NULL,
	[BillDateTime] [datetimeoffset](7) NULL,
	[Customer] [varchar](100) NULL,
	[CustomerID] [varchar](20) NULL,
	[IPNo] [varchar](20) NULL,
	[ConsultantName] [varchar](20) NULL,
	[ConsultantCode] [bigint] NULL,
	[Department] [varchar](50) NULL,
	[DepartmentCode] [bigint] NULL,
	[Ward] [varchar](20) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[DiscountPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[NetAmount] [decimal](18, 3) NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Balance] [decimal](18, 3) NULL,
	[TotalVat] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 2) NULL,
	[UserName] [varchar](20) NULL,
	[SalesMode] [varchar](10) NULL,
	[PayMode] [varchar](10) NULL,
	[CreditAuthorization] [varchar](20) NULL,
	[BillStatus] [nchar](10) NULL,
	[BillCancel] [nchar](10) NULL,
	[BillCancelDate] [datetime] NULL,
	[BillCancelUser] [varchar](20) NULL,
	[BillEdit] [nchar](10) NULL,
	[BillEditDate] [datetime] NULL,
	[BillEditUser] [varchar](20) NULL,
	[RefDrName] [varchar](50) NULL,
	[BillFor] [varchar](20) NULL,
	[BilledUser] [varchar](20) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[SavedUserID] [bigint] NULL,
 CONSTRAINT [PK_InternalTransfer] PRIMARY KEY CLUSTERED 
(
	[IntTransCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InternalTransferDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InternalTransferDetails](
	[ITcode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[IntTransCode] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[MfgId] [int] NULL,
	[ExpiryDate] [varchar](10) NULL,
	[GRNNo] [varchar](20) NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[TaxPercent] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 3) NULL,
	[DiscPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[CancelFlag] [bit] NULL,
	[EditProduct] [bit] NULL,
	[OldQty] [int] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_InternalTransferDetails] PRIMARY KEY CLUSTERED 
(
	[ITcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Manufacturer__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonId] [int] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Gender] [nvarchar](15) NULL,
	[DOB] [smalldatetime] NULL,
	[MobileNumber] [nvarchar](20) NULL,
	[EmailId] [nvarchar](100) NULL,
	[AddressLine] [nvarchar](500) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[ZipCode] [nvarchar](20) NULL,
	[Country] [nvarchar](50) NULL,
	[IsDeleted] [bit] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[PersonImageUrl] [nvarchar](255) NULL,
 CONSTRAINT [PK__Person__PersonId] PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Pharmacy]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pharmacy](
	[Id] [int] NOT NULL,
	[ParentId] [int] NULL,
	[Name] [nvarchar](200) NOT NULL,
	[CompanyName] [nvarchar](200) NOT NULL,
	[ContactPerson] [nvarchar](100) NOT NULL,
	[TINRegNo] [nvarchar](100) NULL,
	[DrugLicenceNo] [nvarchar](100) NULL,
	[EmailId] [nvarchar](100) NULL,
	[Mobile] [nvarchar](20) NULL,
	[Telephone1] [nvarchar](20) NULL,
	[Telephone2] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Website] [nvarchar](200) NULL,
	[AddressLine1] [nvarchar](500) NULL,
	[AddressLine2] [nvarchar](500) NULL,
	[Zipcode] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[LogoImage] [image] NULL,
	[IsDeleted] [bit] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[GRNIDValue] [bigint] NULL,
	[GRNPrefix] [varchar](10) NOT NULL,
	[BillIDValue] [bigint] NULL,
	[BillPrefix] [varchar](10) NULL,
	[IndentIDValue] [bigint] NULL,
	[IndentPrefix] [varchar](10) NULL,
 CONSTRAINT [PK__Pharmacy__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PharmacyXModule]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PharmacyXModule](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PharmacyId] ASC,
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Classification] [char](1) NULL,
	[Name] [nvarchar](256) NOT NULL,
	[TypeId] [int] NULL,
	[CategoryId] [int] NULL,
	[MainCategoryId] [int] NULL,
	[GenericId] [int] NULL,
	[ManfId] [int] NULL,
	[UnitId] [int] NULL,
	[MinStock] [int] NULL,
	[MaxStock] [int] NULL,
	[ExpiryNotifyinDays] [int] NULL,
	[ExpiryDays] [int] NULL,
	[SuppTakenBeforExpiryDays] [int] NULL,
	[TakenBeforeDays] [int] NULL,
	[SuppTakenAfterExpiryDays] [int] NULL,
	[TakenAfterDays] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Product__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductType](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__ProductType__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseDetail]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[PHeaderId] [bigint] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[FreeQty] [int] NULL,
	[MfgId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[ExpiryDate] [varchar](20) NULL,
	[Packing] [int] NULL,
	[AssortedQty] [int] NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[VAT] [decimal](18, 3) NULL,
	[MRPVATAmount] [decimal](18, 3) NULL,
	[COSTVATAmount] [decimal](18, 3) NULL,
	[AbatedMRP] [decimal](18, 3) NULL,
	[TaxMode] [varchar](20) NULL,
	[TaxType] [varchar](20) NULL,
	[DiscApplicable] [bit] NULL,
	[VATOnDiscount] [bit] NULL,
	[VATOnFreeQty] [bit] NULL,
	[DiscOnFreeQty] [bit] NULL,
	[FreeQtyVATAmount] [decimal](18, 3) NULL,
	[DiscountPercentage] [decimal](18, 3) NULL,
	[DiscountAmount] [decimal](18, 3) NULL,
	[AssortedCostPrice] [decimal](18, 3) NULL,
	[AssortedMRPPrice] [decimal](18, 3) NULL,
	[AbatedCost] [decimal](18, 3) NULL,
	[RackId] [int] NULL,
	[Barcode] [varchar](100) NULL,
	[AddedBy] [bigint] NOT NULL,
	[AddedDateTime] [smalldatetime] NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[VATAmount] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[NetCostPrice] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[NetMRP] [decimal](18, 3) NULL,
	[VatOnDiscountAmount] [decimal](18, 3) NULL,
	[DiscOnFreeQtyAmount] [decimal](18, 3) NULL,
	[TotalDiscountAmount] [decimal](18, 3) NULL,
	[TotalVatAmount] [decimal](18, 3) NULL,
	[NetVATAmount] [decimal](18, 3) NULL,
 CONSTRAINT [PK_PurchaseDetail_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseHeader](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[GrnNo] [nvarchar](50) NULL,
	[GrnDate] [smalldatetime] NOT NULL,
	[POrderNo] [bigint] NULL,
	[SupplierId] [bigint] NULL,
	[SupplierInvNo] [nvarchar](50) NULL,
	[SupplierInvDate] [smalldatetime] NULL,
	[CreditPeriod] [int] NULL,
	[CreditDate] [smalldatetime] NULL,
	[DiscountPercent] [decimal](18, 3) NULL,
	[DiscountAmount] [decimal](18, 3) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[TotalVAT] [decimal](18, 3) NULL,
	[NetAmount] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 3) NULL,
	[PaidStatus] [bit] NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Status] [varchar](20) NULL,
	[Comment] [nvarchar](250) NULL,
	[AddedBy] [bigint] NOT NULL,
	[AddedDateTime] [smalldatetime] NOT NULL,
	[AddedUserName] [nvarchar](100) NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[SavedUserId] [int] NULL,
 CONSTRAINT [PK_PurchaseHeader_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseRequest]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseRequest](
	[RequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestNo] [nvarchar](50) NOT NULL,
	[RequestDate] [smalldatetime] NOT NULL,
	[Reason] [nvarchar](200) NULL,
	[IsActive] [bit] NULL,
	[AddedBy] [int] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_PurchaseRequest] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseRequestDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseRequestDetails](
	[ReqDetId] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [bigint] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[Qty] [int] NOT NULL,
	[CurrentStock] [int] NULL,
	[ManfId] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_PurchaseRequestDetails] PRIMARY KEY CLUSTERED 
(
	[ReqDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseReturnDetail]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseReturnDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[PRHeaderId] [bigint] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[FreeQty] [int] NULL,
	[MfgId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[ExpiryDate] [varchar](20) NULL,
	[Packing] [int] NULL,
	[AssortedQty] [int] NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[VAT] [decimal](18, 3) NULL,
	[MRPVATAmount] [decimal](18, 3) NULL,
	[COSTVATAmount] [decimal](18, 3) NULL,
	[AbatedMRP] [decimal](18, 3) NULL,
	[TaxMode] [varchar](20) NULL,
	[TaxType] [varchar](20) NULL,
	[DiscApplicable] [bit] NULL,
	[VATOnDiscount] [bit] NULL,
	[VATOnFreeQty] [bit] NULL,
	[DiscOnFreeQty] [bit] NULL,
	[FreeQtyVATAmount] [decimal](18, 3) NULL,
	[DiscountPercentage] [decimal](18, 3) NULL,
	[DiscountAmount] [decimal](18, 3) NULL,
	[AssortedCostPrice] [decimal](18, 3) NULL,
	[AssortedMRPPrice] [decimal](18, 3) NULL,
	[AbatedCost] [decimal](18, 3) NULL,
	[RackId] [int] NULL,
	[Barcode] [varchar](100) NULL,
	[AddedBy] [bigint] NOT NULL,
	[AddedDateTime] [smalldatetime] NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[VATAmount] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[NetCostPrice] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[NetMRP] [decimal](18, 3) NULL,
	[VatOnDiscountAmount] [decimal](18, 3) NULL,
	[DiscOnFreeQtyAmount] [decimal](18, 3) NULL,
	[TotalDiscountAmount] [decimal](18, 3) NULL,
	[TotalVatAmount] [decimal](18, 3) NULL,
	[NetVATAmount] [decimal](18, 3) NULL,
 CONSTRAINT [PK_PurchaseReturnDetail_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseReturnHeader]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseReturnHeader](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[ReturnNo] [nvarchar](50) NULL,
	[ReturnDate] [smalldatetime] NOT NULL,
	[GrnNo] [nvarchar](50) NULL,
	[GrnDate] [smalldatetime] NULL,
	[POrderNo] [bigint] NULL,
	[SupplierId] [bigint] NULL,
	[SupplierInvNo] [nvarchar](50) NULL,
	[SupplierInvDate] [smalldatetime] NULL,
	[CreditPeriod] [int] NULL,
	[CreditDate] [smalldatetime] NULL,
	[DiscountPercent] [decimal](18, 3) NULL,
	[DiscountAmount] [decimal](18, 3) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[TotalVAT] [decimal](18, 3) NULL,
	[NetAmount] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 3) NULL,
	[PaidStatus] [bit] NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Status] [varchar](20) NULL,
	[Comment] [nvarchar](250) NULL,
	[AddedBy] [bigint] NOT NULL,
	[AddedDateTime] [smalldatetime] NOT NULL,
	[AddedUserName] [nvarchar](100) NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
	[SavedUserId] [int] NULL,
 CONSTRAINT [PK_PurchaseReturnHeader_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rack]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rack](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Rack__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Receivables]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Receivables](
	[RecCode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[RecNo] [varchar](20) NULL,
	[RecDate] [smalldatetime] NULL,
	[Billcode] [bigint] NULL,
	[BillNo] [varchar](20) NULL,
	[BillDate] [smalldatetime] NULL,
	[Customer] [varchar](100) NULL,
	[CustomerID] [varchar](20) NULL,
	[IPNo] [varchar](20) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Balance] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 2) NULL,
	[UserName] [varchar](20) NULL,
	[SalesMode] [varchar](10) NULL,
	[PayMode] [varchar](10) NULL,
	[CreditAuthorization] [varchar](20) NULL,
	[RecCancel] [nchar](10) NULL,
	[RecCancelDate] [datetime] NULL,
	[RecCancelUser] [varchar](20) NULL,
	[RecEdit] [nchar](10) NULL,
	[RecEditDate] [datetime] NULL,
	[RecEditUser] [varchar](20) NULL,
	[ReceiptUser] [varchar](20) NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[SavedUserID] [bigint] NULL,
 CONSTRAINT [PK_Receivables] PRIMARY KEY CLUSTERED 
(
	[RecCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleXFeature]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleXFeature](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleIid] [int] NOT NULL,
	[FeatureId] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleIid] ASC,
	[FeatureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RunningStock]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RunningStock](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[ExpiryDate] [varchar](20) NULL,
	[PurDetId] [bigint] NULL,
	[MfgId] [int] NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[PurQty] [int] NULL,
	[PurRetQty] [int] NULL,
	[SaleQty] [int] NULL,
	[SaleRetQty] [int] NULL,
	[OpenStockQty] [int] NULL,
	[StockAdjQty] [int] NULL,
	[IndentQty] [int] NULL,
	[PurDt] [datetime] NULL,
	[PurRetDt] [datetime] NULL,
	[SaleDt] [datetime] NULL,
	[SaleRetDt] [datetime] NULL,
	[OpenStockDt] [datetime] NULL,
	[StockAdjDt] [datetime] NULL,
	[IndentDt] [datetime] NULL,
	[VAT] [decimal](18, 2) NULL,
	[GRNNo] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sales]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sales](
	[BillCode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[BillNo] [varchar](20) NULL,
	[BillDate] [smalldatetime] NULL,
	[BillTime] [datetime] NULL,
	[BillDateTime] [datetimeoffset](7) NULL,
	[Customer] [varchar](100) NULL,
	[CustomerID] [varchar](20) NULL,
	[IPNo] [varchar](20) NULL,
	[ConsultantName] [varchar](20) NULL,
	[ConsultantCode] [bigint] NULL,
	[Department] [varchar](50) NULL,
	[DepartmentCode] [bigint] NULL,
	[Ward] [varchar](20) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[DiscountPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[NetAmount] [decimal](18, 3) NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Balance] [decimal](18, 3) NULL,
	[TotalVat] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 2) NULL,
	[UserName] [varchar](20) NULL,
	[SalesMode] [varchar](10) NULL,
	[PayMode] [varchar](10) NULL,
	[CreditAuthorization] [varchar](20) NULL,
	[BillStatus] [nchar](10) NULL,
	[BillCancel] [nchar](10) NULL,
	[BillCancelDate] [datetime] NULL,
	[BillCancelUser] [varchar](20) NULL,
	[BillEdit] [nchar](10) NULL,
	[BillEditDate] [datetime] NULL,
	[BillEditUser] [varchar](20) NULL,
	[RefDrName] [varchar](50) NULL,
	[BillFor] [varchar](20) NULL,
	[BilledUser] [varchar](20) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[SavedUserID] [bigint] NULL,
	[IndentId] [bigint] NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[BillCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SalesDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SalesDetails](
	[bdcode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[BillCode] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[MfgId] [int] NULL,
	[ExpiryDate] [varchar](10) NULL,
	[GRNNo] [varchar](20) NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[TaxPercent] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 3) NULL,
	[DiscPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[CancelFlag] [bit] NULL,
	[EditProduct] [bit] NULL,
	[OldQty] [int] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[EditedBy] [bigint] NULL,
	[EditedDate] [datetime] NULL,
	[CanceledBy] [bigint] NULL,
	[CanceledDate] [datetime] NULL,
	[PurDetId] [bigint] NULL,
 CONSTRAINT [PK_SalesDetails] PRIMARY KEY CLUSTERED 
(
	[bdcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SalesReturn]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SalesReturn](
	[BRCode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[BillReturnNo] [varchar](20) NULL,
	[BillReturnDate] [smalldatetime] NULL,
	[BillNo] [varchar](20) NULL,
	[BillDate] [smalldatetime] NULL,
	[BillTime] [datetime] NULL,
	[BillDateTime] [datetimeoffset](7) NULL,
	[Customer] [varchar](100) NULL,
	[CustomerID] [varchar](20) NULL,
	[IPNo] [varchar](20) NULL,
	[ConsultantName] [varchar](20) NULL,
	[ConsultantCode] [bigint] NULL,
	[Department] [varchar](50) NULL,
	[DepartmentCode] [bigint] NULL,
	[Ward] [varchar](20) NULL,
	[TotalAmount] [decimal](18, 3) NULL,
	[DiscountPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[NetAmount] [decimal](18, 3) NULL,
	[PaidAmount] [decimal](18, 3) NULL,
	[Balance] [decimal](18, 3) NULL,
	[TotalVat] [decimal](18, 3) NULL,
	[RoundOff] [decimal](18, 2) NULL,
	[UserName] [varchar](20) NULL,
	[SalesMode] [varchar](10) NULL,
	[PayMode] [varchar](10) NULL,
	[CreditAuthorization] [varchar](20) NULL,
	[BillStatus] [nchar](10) NULL,
	[BillCancel] [nchar](10) NULL,
	[BillCancelDate] [datetime] NULL,
	[BillCancelUser] [varchar](20) NULL,
	[BillEdit] [nchar](10) NULL,
	[BillEditDate] [datetime] NULL,
	[BillEditUser] [varchar](20) NULL,
	[RefDrName] [varchar](50) NULL,
	[BillFor] [varchar](20) NULL,
	[BilledUser] [varchar](20) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[SavedUserID] [bigint] NULL,
 CONSTRAINT [PK_SalesReturn] PRIMARY KEY CLUSTERED 
(
	[BRCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SalesReturnDetails]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SalesReturnDetails](
	[brdcode] [bigint] IDENTITY(1,1) NOT NULL,
	[PharmacyId] [int] NULL,
	[BRCode] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[BatchNo] [nvarchar](50) NULL,
	[Qty] [int] NULL,
	[MfgId] [int] NULL,
	[ExpiryDate] [varchar](10) NULL,
	[GRNNo] [varchar](20) NULL,
	[CostPrice] [decimal](18, 3) NULL,
	[TotalCostPrice] [decimal](18, 3) NULL,
	[MRP] [decimal](18, 3) NULL,
	[TotalMRP] [decimal](18, 3) NULL,
	[TaxPercent] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 3) NULL,
	[DiscPercent] [decimal](18, 2) NULL,
	[Discount] [decimal](18, 3) NULL,
	[CancelFlag] [bit] NULL,
	[EditProduct] [bit] NULL,
	[OldQty] [int] NULL,
	[AddedBy] [bigint] NULL,
	[AddedDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_SalesReturnDetails] PRIMARY KEY CLUSTERED 
(
	[brdcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Supplier](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[TypeId] [int] NULL,
	[Address] [nvarchar](500) NULL,
	[TinNo] [nvarchar](50) NULL,
	[DLNo] [nvarchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Pincode] [nvarchar](10) NULL,
	[MobileNo] [nvarchar](12) NULL,
	[IsActive] [bit] NULL,
	[DueDays] [int] NULL,
 CONSTRAINT [PK__Supplier__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 1/17/2016 12:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tax](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Tax__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (5, 500, N'SiteReport', N'Report', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, NULL, 5)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (7, 700, N'SiteTransaction', N'Transaction', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, NULL, 7)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8, 800, N'SiteSettings', N'Settings', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, NULL, 8)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (500, 500, N'DailySales', N'DailySales', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 5, 500)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (700, 700, N'Sales', N'Sales', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 700)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (710, 700, N'Purchase', N'Purchase', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 710)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (720, 700, N'Indent', N'Indent', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 720)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (730, 700, N'IndentBill', N'IndentBill', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 730)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (740, 700, N'SalesReturn', N'SalesReturn', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 740)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (750, 700, N'PurchaseReturn', N'PurchaseReturn', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 750)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (760, 700, N'IndentReturn', N'IndentReturn', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 760)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (770, 700, N'IndentBillReturn', N'IndentBillReturn', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 770)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (780, 700, N'IndentReceivable', N'IndentReceivable', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 7, 780)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (800, 800, N'DrugUnit', N'Drung Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 8, 800)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (810, 800, N'Manufacturer', N'Manufacturer', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 810)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (820, 800, N'Category', N'Category', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 820)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (830, 800, N'Department', N'Department', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 830)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (840, 800, N'Content', N'Content', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 840)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (850, 800, N'Drug Type', N'Drug Type', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 850)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (860, 800, N'Rack', N'Rack', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 860)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (870, 800, N'Tax', N'Tax', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 870)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (880, 800, N'Drug Generic', N'Drug Generic', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 880)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (890, 800, N'Bank', N'Bank', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 890)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (900, 800, N'Supplier', N'Supplier', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 900)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (910, 800, N'Product', N'Product', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 910)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (920, 800, N'CreditAuth', N'CreditAuth', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 920)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8001, 800, N'AddDrugUnit', N'Add Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8002, 800, N'EditDrugUnit', N'Edit Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8003, 800, N'DeleteDrugUnit', N'Delete Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8004, 800, N'ViewDrugUnits', N'View Drug Units', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (8, N'SiteSettings', N'Settings', N'fa fa-gear', N'/admin/#/admin', NULL, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (800, N'DrugUnit', N'Drug Unit', N'fa fa-leaf', N'/admin/#/unit', 8, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (810, N'Manufacturer', N'Manufacturer', N'fa fa-truck', N'/admin/#/manf', 8, 2, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (820, N'Category', N'Category', N'fa fa-file-o', N'/admin/#/category', 8, 3, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (830, N'Department', N'Department', N'fa fa-bank', N'/admin/#/department', 8, 4, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (840, N'Content', N'Content', N'fa fa-file-o', N'/admin/#/content', 8, 5, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (850, N'Drug Type', N'Drug Type', N'fa fa-file-o', N'/admin/#/drugtype', 8, 6, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (860, N'Rack', N'Rack', N'fa fa-file-o', N'/admin/#/rack', 8, 7, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (870, N'Tax', N'Tax', N'fa fa-file-o', N'/admin/#/tax', 8, 8, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (880, N'Drug Generic', N'Drug Generic', N'fa fa-file-o', N'/admin/#/druggeneric', 8, 9, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (890, N'Bank', N'Bank', N'fa fa-file-o', N'/admin/#/bank', 8, 10, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (900, N'Supplier', N'Supplier', N'fa fa-file-o', N'/admin/#/supplier', 8, 11, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (910, N'Product', N'Product', N'fa fa-file-o', N'/admin/#/product', 8, 12, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (920, N'Credit', N'Credit', N'fa fa-file-o', N'/admin/#/creditauth', 8, 13, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (4, N'Purchase', N'Purchase', NULL, N'/purchase', NULL, 3, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (5, N'SiteReports', N'Reports', N'fa fa-gear', N'/admin/#/admin', NULL, 3, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (7, N'SiteTransaction', N'Transaction', N'fa fa-gear', N'/purchase', NULL, 2, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (500, N'DailySales', N'DailySales', N'fa fa-file-o', N'/bill', 5, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (700, N'Sales', N'Sales', N'fa fa-file-o', N'/bill', 7, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (710, N'Purchase', N'Purchase', N'fa fa-file-o', N'/purchase', 7, 2, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (720, N'Indent', N'Indent', N'fa fa-file-o', N'/indent', 7, 3, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (730, N'IndentBill', N'IndentBill', N'fa fa-file-o', N'/indentbill', 7, 4, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (740, N'SalesReturn', N'SalesReturn', N'fa fa-file-o', N'/billreturn', 7, 5, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (750, N'PurchaseReturn', N'PurchaseReturn', N'fa fa-file-o', N'/purchasereturn', 7, 6, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (760, N'IndentReturn', N'IndentReturn', N'fa fa-file-o', N'/indentreturn', 7, 7, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (770, N'IndentBillReturn', N'IndentBillReturn', N'fa fa-file-o', N'/indentbillreturn', 7, 8, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (780, N'IndentReceivable', N'IndentReceivable', N'fa fa-file-o', N'/indentreceivable', 7, 9, 0)
GO
INSERT [dbo].[ApplicationModule] ([Id], [Key], [Name], [LandingPage], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted]) VALUES (500, N'SiteReports', N'Reports', N'/admin', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0)
GO
INSERT [dbo].[ApplicationModule] ([Id], [Key], [Name], [LandingPage], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted]) VALUES (700, N'SiteTransaction', N'Transaction', N'/admin', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0)
GO
INSERT [dbo].[ApplicationModule] ([Id], [Key], [Name], [LandingPage], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted]) VALUES (800, N'SiteSettings', N'Settings', N'/admin', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0)
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (100, 1, N'SuperAdmin', NULL, 0, NULL, NULL, NULL, NULL, N'admin')
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (110, 1, N'Admin', NULL, 0, NULL, NULL, NULL, NULL, N'Admin')
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (200, 1, N'Supplier', NULL, 0, NULL, NULL, NULL, NULL, N'Supplier')
GO
SET IDENTITY_INSERT [dbo].[ApplicationUser] ON 

GO
INSERT [dbo].[ApplicationUser] ([UserId], [PharmacyId], [PersonId], [Username], [Password], [EmailId], [RoleId], [LastLoginDate], [FailedLoginDate], [IsActive], [IsAccountLocked], [FailedLoginAttempt], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [UserType], [NeedPasswordReset]) VALUES (6, 1, 1, N'misadmin', N'1000:0l1u6/DbKlnDBiYRDLr0SfIUpmMhsGNw:osNxkhIZLxtRVYrsubfCRNWCot2Y/GW+', N'dariasys@gmail.com', 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[ApplicationUser] ([UserId], [PharmacyId], [PersonId], [Username], [Password], [EmailId], [RoleId], [LastLoginDate], [FailedLoginDate], [IsActive], [IsAccountLocked], [FailedLoginAttempt], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [UserType], [NeedPasswordReset]) VALUES (7, 1, 1, N'bala', N'1000:0l1u6/DbKlnDBiYRDLr0SfIUpmMhsGNw:osNxkhIZLxtRVYrsubfCRNWCot2Y/GW+', N'dariasys@gmail.com', 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[ApplicationUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Bank] ON 

GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'SBI', N'State Bank Of India', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'IB', N'Indian Bank', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'ICICI', N'ICICI Bank', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (5, N'Axis', N'Axis Bank', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (6, N'HDFC', N'HDFC Bank', 1)
GO
SET IDENTITY_INSERT [dbo].[Bank] OFF
GO
SET IDENTITY_INSERT [dbo].[Consultant] ON 

GO
INSERT [dbo].[Consultant] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Dr. Bala', N'', 1)
GO
INSERT [dbo].[Consultant] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'Dr. Varu', N'', 1)
GO
INSERT [dbo].[Consultant] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'Dr. Sathiya', N'', 1)
GO
SET IDENTITY_INSERT [dbo].[Consultant] OFF
GO
SET IDENTITY_INSERT [dbo].[CreditAuth] ON 

GO
INSERT [dbo].[CreditAuth] ([Id], [AuthName], [DepName], [DesigName], [FindBy], [IsActive]) VALUES (1, N'Bala', N'Admin', N'Executive', N'admin', 1)
GO
SET IDENTITY_INSERT [dbo].[CreditAuth] OFF
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

GO
INSERT [dbo].[Department] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Lab', N'Laboratory', 1)
GO
INSERT [dbo].[Department] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'OT', N'Operation Theater', 1)
GO
INSERT [dbo].[Department] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'Pharmacy', N'Pharmacy', 1)
GO
INSERT [dbo].[Department] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'Ist Floor', N'Ist Floor', 1)
GO
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugCategory] ON 

GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Tablet', N'Tablet', 1)
GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'Syrub', N'Syrub', 1)
GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'Bottle', N'Bottle', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugContent] ON 

GO
INSERT [dbo].[DrugContent] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'asd', N'asd', 1)
GO
INSERT [dbo].[DrugContent] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'ams', N'ams', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugContent] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugGeneric] ON 

GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (13, N'Testing', N'testad', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1013, N'ok', N'dsa', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1015, N'lt', N'litre', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1016, N'asd', N'as', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1017, N'MG', N'mg', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1018, N'test', N'test', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1019, N'mlmg', N'mgml', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1021, N'bcd', N'testing', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugGeneric] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugType] ON 

GO
INSERT [dbo].[DrugType] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Capsul', N'tablet', 1)
GO
INSERT [dbo].[DrugType] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'Needle', N'Injection', 1)
GO
INSERT [dbo].[DrugType] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'Tablet', N'Tablet', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugType] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugUnit] ON 

GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'ml', N'MiliLitre', 1)
GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'l', N'Litre', 1)
GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'mg', N'milligram', 1)
GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'nos', N'Numbers', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugUnit] OFF
GO
SET IDENTITY_INSERT [dbo].[Indent] ON 

GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (7, 1, N'SB13', CAST(0xA56C02C4 AS SmallDateTime), N'SAIRA', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C02C4 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (8, 1, N'SB14', CAST(0xA56C02C6 AS SmallDateTime), N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C02C6 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (9, 1, N'SB15', CAST(0xA56C02CA AS SmallDateTime), N'SAIRA', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C02C9 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (17, 1, N'SB18', CAST(0xA56C02EB AS SmallDateTime), N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C02EB AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (18, 1, N'SB19', CAST(0xA56C02F0 AS SmallDateTime), N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C02F0 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (20, 1, N'PI3', CAST(0xA56C0303 AS SmallDateTime), N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, NULL, N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C0303 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (21, 1, N'PI4', CAST(0xA56C0305 AS SmallDateTime), N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'Cash', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Sundhar', NULL, 1, CAST(0xA56C0305 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (22, 1, N'PI5', CAST(0xA56C031B AS SmallDateTime), N'Fairoz', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'Cash', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Sundhar', NULL, 1, CAST(0xA56C031B AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (23, 1, N'PI6', CAST(0xA57603B7 AS SmallDateTime), N'BALASAHEB ANNASAHEB KOTHIWALE', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57603B7 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (24, 1, N'PI7', CAST(0xA57603BC AS SmallDateTime), N'A M AKRAM', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57603BA AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (25, 1, N'PI8', CAST(0xA57603BE AS SmallDateTime), N'Fairoz', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57603BE AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (26, 1, N'PI9', CAST(0xA57603C5 AS SmallDateTime), N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57603C5 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (27, 1, N'PI10', CAST(0xA5770521 AS SmallDateTime), N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770521 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (28, 1, N'PI11', CAST(0xA5770524 AS SmallDateTime), N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770524 AS SmallDateTime), 6)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (29, 1, N'PI12', CAST(0xA577052D AS SmallDateTime), N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA577052D AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (30, 1, N'PI13', CAST(0xA57802D3 AS SmallDateTime), N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802D3 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (31, 1, N'PI14', CAST(0xA57802D7 AS SmallDateTime), N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802D7 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (32, 1, N'PI15', CAST(0xA57802D9 AS SmallDateTime), N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802D9 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (33, 1, N'PI16', CAST(0xA57802DC AS SmallDateTime), N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802DC AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (34, 1, N'PI17', CAST(0xA57802E0 AS SmallDateTime), N'A M AKRAM', NULL, N'IP1061', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802E0 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (35, 1, N'PI18', CAST(0xA5780325 AS SmallDateTime), N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5780325 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (36, 1, N'PI19', CAST(0xA57803A1 AS SmallDateTime), N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803A1 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (37, 1, N'PI20', CAST(0xA57803A8 AS SmallDateTime), N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803A8 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (38, 1, N'PI21', CAST(0xA57803BA AS SmallDateTime), N'BALASAHEB ANNASAHEB KOTHIWALE', NULL, N'IP1062', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803BA AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (39, 1, N'PI22', CAST(0xA57803BD AS SmallDateTime), N'BALASAHEB ANNASAHEB KOTHIWALE', NULL, N'IP1062', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803BD AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (40, 1, N'PI23', CAST(0xA57803C0 AS SmallDateTime), N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803C0 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (41, 1, N'PI24', CAST(0xA57803C2 AS SmallDateTime), N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803C2 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (42, 1, N'PI25', CAST(0xA57A0401 AS SmallDateTime), N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57A0401 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (43, 1, N'PI26', CAST(0xA58104B1 AS SmallDateTime), N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'CORPORATE', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA58104B1 AS SmallDateTime), 7)
GO
INSERT [dbo].[Indent] ([IndentId], [PharmacyId], [IndentNo], [IndentDate], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [DeptName], [Ward], [UserName], [PayMode], [Status], [Cancel], [CancelDate], [CancelUser], [Edit], [EditDate], [EditUser], [IndentFor], [IndentUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (44, 1, N'PI27', CAST(0xA583031C AS SmallDateTime), N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, N'SELF', N'R         ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA583031C AS SmallDateTime), 6)
GO
SET IDENTITY_INSERT [dbo].[Indent] OFF
GO
SET IDENTITY_INSERT [dbo].[IndentDetails] ON 

GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (3, 1, 17, 2, N'1234', 1, 1, N'12/20', NULL, 50062, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 1, CAST(0xA56C02EB AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (4, 1, 18, 4, N'1234', 1, 1, N'10/17', NULL, 50058, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, 1, CAST(0xA56C02F0 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (7, 1, 20, 1, N'123', 1, 1, N'12/20', NULL, 50071, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 1, CAST(0xA56C0303 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (8, 1, 20, 4, N'4512', 1, 1, N'10/25', NULL, 50068, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 1, CAST(0xA56C0303 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (9, 1, 21, 2, N'1334', 4, 1, N'12/20', NULL, 50065, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 1, CAST(0xA56C0305 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (11, 1, 22, 2, N'1234', 1, 1, N'12/20', NULL, 50062, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 1, CAST(0xA56C031B AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (12, 1, 23, 4, N'4512', 2, 1, N'10/25', NULL, 50068, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57603B7 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (13, 1, 23, 1, N'123', 1, 1, N'12/20', NULL, 50071, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57603B7 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (14, 1, 24, 2, N'121212', 1, 1, N'12/25', NULL, 50067, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57603BA AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (15, 1, 25, 7, N'ddf', 1, 1, N'12/19', NULL, 50059, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57603BE AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (16, 1, 26, 2, N'121212', 1, 1, N'12/25', NULL, 50067, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57603C5 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (17, 1, 27, 2, N'asda', 5, 1, N'12/16', NULL, 50073, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA5770521 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (18, 1, 27, 1, N'123', 1, 1, N'12/20', NULL, 50071, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA5770521 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (19, 1, 28, 2, N'asda', 6, 1, N'12/16', NULL, 50073, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA5770524 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (20, 1, 29, 2, N'cal123', 25, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA577052D AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (21, 1, 30, 2, N'cal123', 10, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57802D3 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (22, 1, 31, 2, N'asda', 5, 1, N'12/16', NULL, 50073, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57802D7 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (23, 1, 32, 2, N'234', 1, 1, N'12/20', NULL, 50072, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57802D9 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (24, 1, 33, 2, N'cal123', 3, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57802DC AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (25, 1, 34, 2, N'cal123', 12, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57802E0 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (26, 1, 35, 2, N'cal123', 10, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA5780325 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (27, 1, 36, 2, N'cal123', 5, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803A1 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (28, 1, 37, 2, N'cal123', 10, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803A8 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (29, 1, 37, 4, N'bb253', 100, 1, N'10/19', NULL, 50075, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803A8 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (30, 1, 40, 2, N'asda', 1, 1, N'12/16', NULL, 50073, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803C0 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (31, 1, 41, 2, N'1234', 1, 1, N'12/25', NULL, 50066, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803C2 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (32, 1, 41, 1, N'123', 1, 1, N'12/20', NULL, 50071, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803C2 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (33, 1, 41, 2, N'cal123', 1, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57803C2 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (34, 1, 42, 2, N'Test1', 25, 1, N'12/19', NULL, 50076, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57A0401 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (35, 1, 42, 2, N'Test2', 10, 1, N'10/17', NULL, 50077, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA57A0401 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (36, 1, 43, 2, N'Test1', 10, 1, N'12/19', NULL, 50076, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA58104B1 AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (37, 1, 44, 2, N'cal123', 10, 1, N'12/19', NULL, 50074, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA583031C AS SmallDateTime))
GO
INSERT [dbo].[IndentDetails] ([IndentDetId], [PharmacyId], [IndentId], [ProductId], [BatchNo], [Qty], [MfgId], [ExpDate], [GRNNo], [PurDetId], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (38, 1, 44, 4, N'bb253', 3, 1, N'10/19', NULL, 50075, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, CAST(0xA583031C AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[IndentDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[InternalTransfer] ON 

GO
INSERT [dbo].[InternalTransfer] ([IntTransCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (1, 1, N'SB9', CAST(0xA5580306 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5580306 AS SmallDateTime), 6)
GO
INSERT [dbo].[InternalTransfer] ([IntTransCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (6, 1, N'SB10', CAST(0xA558031B AS SmallDateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA558031B AS SmallDateTime), 6)
GO
INSERT [dbo].[InternalTransfer] ([IntTransCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID]) VALUES (7, 1, N'SB11', CAST(0xA55903D2 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(1125.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA55903D2 AS SmallDateTime), 6)
GO
SET IDENTITY_INSERT [dbo].[InternalTransfer] OFF
GO
SET IDENTITY_INSERT [dbo].[InternalTransferDetails] ON 

GO
INSERT [dbo].[InternalTransferDetails] ([ITcode], [PharmacyId], [IntTransCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (1, 1, 1, 2, N'Batch123', 1, NULL, N'12/20', NULL, CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 0, 1, CAST(0xA558031B AS SmallDateTime))
GO
INSERT [dbo].[InternalTransferDetails] ([ITcode], [PharmacyId], [IntTransCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (2, 1, 0, 1, N'Batch123', 10, NULL, N'12/20', NULL, CAST(75.000 AS Decimal(18, 3)), CAST(750.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(1000.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 0, 1, CAST(0xA55903D2 AS SmallDateTime))
GO
INSERT [dbo].[InternalTransferDetails] ([ITcode], [PharmacyId], [IntTransCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime]) VALUES (3, 1, 0, 4, N'Batch123', 5, NULL, N'12/20', NULL, CAST(75.000 AS Decimal(18, 3)), CAST(375.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(500.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 0, 1, CAST(0xA55903D2 AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[InternalTransferDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] ON 

GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Chaya', N'Chaya Pvt Ltd', 1)
GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'Merck', N'Merck Pvt Ltd', 1)
GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'Starlab', N'Starlab Pv', 1)
GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'Invitrogen', N'Invitrogen', 1)
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

GO
INSERT [dbo].[Person] ([PersonId], [PharmacyId], [FirstName], [LastName], [Gender], [DOB], [MobileNumber], [EmailId], [AddressLine], [City], [State], [ZipCode], [Country], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [PersonImageUrl]) VALUES (1, 1, N'Daria', N'Admin', N'Male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
INSERT [dbo].[Pharmacy] ([Id], [ParentId], [Name], [CompanyName], [ContactPerson], [TINRegNo], [DrugLicenceNo], [EmailId], [Mobile], [Telephone1], [Telephone2], [Fax], [Website], [AddressLine1], [AddressLine2], [Zipcode], [City], [Country], [LogoImage], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [GRNIDValue], [GRNPrefix], [BillIDValue], [BillPrefix], [IndentIDValue], [IndentPrefix]) VALUES (1, NULL, N'Daria', N'Daria', N'Uniza', NULL, NULL, N'dariasys@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL, 56, N'GRN', 47, N'SB', 27, N'PI')
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] ON 

GO
INSERT [dbo].[PharmacyXModule] ([Id], [PharmacyId], [ModuleId], [IsDeleted]) VALUES (3, 1, 500, 0)
GO
INSERT [dbo].[PharmacyXModule] ([Id], [PharmacyId], [ModuleId], [IsDeleted]) VALUES (2, 1, 700, 0)
GO
INSERT [dbo].[PharmacyXModule] ([Id], [PharmacyId], [ModuleId], [IsDeleted]) VALUES (1, 1, 800, 0)
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (1, NULL, N'DNS 500', 1, 4, 1, 13, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (2, NULL, N'Calpal 250mg', 1, 1, 1, 1013, 1, 3, 21, 500, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (3, NULL, N'2Ml Injection', 2, 4, 1, 1013, 1, 1, 5, 10, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (4, NULL, N'BandAid Big', 1, 1, 1, 1013, 3, 4, 5, 10, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (5, NULL, N'5ML Injection', 2, 4, 2, 1013, 1, 3, 5, 10, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (6, NULL, N'Horlicks', 4, 1, 1, 1013, 4, 3, 5, 10, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (7, NULL, N'Calpal 500Mg', 1, 1, 1, 1013, 1, 3, 5, 10, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (8, NULL, N'BandAid Small', 4, 1, 1, 1013, 2, 2, 5, 15, 1, 0, 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (9, NULL, N'Pan 40', 1, 1, 2, 13, 1, 1, 5, 100, 0, 0, 0, 0, 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseDetail] ON 

GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (40039, 1, 60020, 2, N'255', 50, 10, 1, 1, N'10/10', 10, 600, CAST(7.600 AS Decimal(18, 3)), CAST(19.500 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(1109.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(4.180 AS Decimal(18, 3)), CAST(5.000 AS Decimal(18, 3)), CAST(19.000 AS Decimal(18, 3)), CAST(0.760 AS Decimal(18, 3)), CAST(1.950 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA5110522 AS SmallDateTime), NULL, NULL, CAST(20.900 AS Decimal(18, 3)), CAST(380.000 AS Decimal(18, 3)), CAST(357.200 AS Decimal(18, 3)), CAST(1170.000 AS Decimal(18, 3)), CAST(1122.120 AS Decimal(18, 3)), CAST(1.250 AS Decimal(18, 3)), CAST(3.800 AS Decimal(18, 3)), CAST(22.800 AS Decimal(18, 3)), CAST(25.080 AS Decimal(18, 3)), CAST(23.830 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (50038, 1, 70019, 2, N'kijmi', 50, 10, 1, 1, N'10/15', 10, 600, CAST(7.600 AS Decimal(18, 3)), CAST(19.500 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(1109.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(4.180 AS Decimal(18, 3)), CAST(5.000 AS Decimal(18, 3)), CAST(19.000 AS Decimal(18, 3)), CAST(0.760 AS Decimal(18, 3)), CAST(1.950 AS Decimal(18, 3)), NULL, 1, NULL, 1, CAST(0xA512031A AS SmallDateTime), NULL, NULL, CAST(20.900 AS Decimal(18, 3)), CAST(380.000 AS Decimal(18, 3)), CAST(357.200 AS Decimal(18, 3)), CAST(1170.000 AS Decimal(18, 3)), CAST(1122.120 AS Decimal(18, 3)), CAST(1.250 AS Decimal(18, 3)), CAST(3.800 AS Decimal(18, 3)), CAST(22.800 AS Decimal(18, 3)), CAST(25.080 AS Decimal(18, 3)), CAST(23.830 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (50042, 1, 70022, 2, N'250', 50, 10, 1, 2, N'10/10', 10, 600, CAST(7.600 AS Decimal(18, 3)), CAST(19.500 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(1109.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(4.180 AS Decimal(18, 3)), CAST(5.000 AS Decimal(18, 3)), CAST(19.000 AS Decimal(18, 3)), CAST(0.760 AS Decimal(18, 3)), CAST(1.950 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA512049E AS SmallDateTime), NULL, NULL, CAST(20.900 AS Decimal(18, 3)), CAST(380.000 AS Decimal(18, 3)), CAST(361.000 AS Decimal(18, 3)), CAST(1170.000 AS Decimal(18, 3)), CAST(1125.920 AS Decimal(18, 3)), CAST(1.250 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(19.000 AS Decimal(18, 3)), CAST(25.080 AS Decimal(18, 3)), CAST(23.830 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (50043, 1, 70022, 1, N'266', 25, 2, 2, 1, N'12/18', 5, 135, CAST(5.500 AS Decimal(18, 3)), CAST(22.200 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(568.150 AS Decimal(18, 3)), N'COST', N'INCL', 0, 0, 0, 0, CAST(0.610 AS Decimal(18, 3)), CAST(2.000 AS Decimal(18, 3)), CAST(2.750 AS Decimal(18, 3)), CAST(1.100 AS Decimal(18, 3)), CAST(4.440 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA512049E AS SmallDateTime), NULL, NULL, CAST(7.170 AS Decimal(18, 3)), CAST(137.500 AS Decimal(18, 3)), CAST(134.530 AS Decimal(18, 3)), CAST(599.400 AS Decimal(18, 3)), CAST(588.650 AS Decimal(18, 3)), CAST(0.160 AS Decimal(18, 3)), CAST(0.220 AS Decimal(18, 3)), CAST(2.970 AS Decimal(18, 3)), CAST(7.780 AS Decimal(18, 3)), CAST(7.620 AS Decimal(18, 3)))
GO
SET IDENTITY_INSERT [dbo].[PurchaseDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseHeader] ON 

GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (60020, 1, N'GRN29', CAST(0xA5110521 AS SmallDateTime), 0, 2, N'255', CAST(0xA5110521 AS SmallDateTime), 5, CAST(0xA5160521 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5110522 AS SmallDateTime), N'6', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (70019, 1, N'GRN30', CAST(0xA5120319 AS SmallDateTime), 0, 2, N'de', CAST(0xA5120319 AS SmallDateTime), 5, CAST(0xA5170319 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(500.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(380.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA512031A AS SmallDateTime), N'6', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (70022, 1, N'GRN31', CAST(0xA51203D0 AS SmallDateTime), 0, 2, N'ded', CAST(0xA51203D0 AS SmallDateTime), 5, CAST(0xA51703D0 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(1520.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(517.500 AS Decimal(18, 3)), CAST(1002.500 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA51203D1 AS SmallDateTime), N'6', 1, CAST(0xA512049E AS SmallDateTime), 6)
GO
SET IDENTITY_INSERT [dbo].[PurchaseHeader] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseReturnDetail] ON 

GO
INSERT [dbo].[PurchaseReturnDetail] ([Id], [PharmacyId], [PRHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (1, 1, 1, 5, N'asdasd', 1, 0, 1, 3, N'12/20', 1, 1, CAST(55.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), NULL, NULL, CAST(96.150 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(55.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA5580443 AS SmallDateTime), NULL, NULL, CAST(2.200 AS Decimal(18, 3)), CAST(55.000 AS Decimal(18, 3)), CAST(55.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(97.800 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(2.200 AS Decimal(18, 3)), CAST(2.200 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseReturnDetail] ([Id], [PharmacyId], [PRHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (2, 1, 1, 5, N'aqwr', 1, 0, 1, 3, N'10/17', 1, 1, CAST(60.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), NULL, NULL, CAST(144.230 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA5580443 AS SmallDateTime), NULL, NULL, CAST(2.400 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(147.600 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseReturnDetail] ([Id], [PharmacyId], [PRHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (3, 1, 2, 4, N'1234', 1, 0, 1, 3, N'10/17', 1, 1, CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), NULL, NULL, CAST(105.770 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA55903CD AS SmallDateTime), NULL, NULL, CAST(2.400 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(107.600 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseReturnDetail] ([Id], [PharmacyId], [PRHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (4, 1, 3, 2, N'Test1', 100, 0, 1, 2, N'12/19', 1, 100, CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(14218.010 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA5830327 AS SmallDateTime), NULL, NULL, CAST(550.000 AS Decimal(18, 3)), CAST(10000.000 AS Decimal(18, 3)), CAST(10000.000 AS Decimal(18, 3)), CAST(15000.000 AS Decimal(18, 3)), CAST(14450.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(550.000 AS Decimal(18, 3)), CAST(550.000 AS Decimal(18, 3)))
GO
INSERT [dbo].[PurchaseReturnDetail] ([Id], [PharmacyId], [PRHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [VATAmount], [TotalCostPrice], [NetCostPrice], [TotalMRP], [NetMRP], [VatOnDiscountAmount], [DiscOnFreeQtyAmount], [TotalDiscountAmount], [TotalVatAmount], [NetVATAmount]) VALUES (5, 1, 3, 2, N'Test2', 50, 0, 2, 2, N'10/17', 1, 50, CAST(75.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), NULL, NULL, CAST(5924.170 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), NULL, NULL, NULL, 1, CAST(0xA5830327 AS SmallDateTime), NULL, NULL, CAST(206.250 AS Decimal(18, 3)), CAST(3750.000 AS Decimal(18, 3)), CAST(3750.000 AS Decimal(18, 3)), CAST(6250.000 AS Decimal(18, 3)), CAST(6043.750 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(206.250 AS Decimal(18, 3)), CAST(206.250 AS Decimal(18, 3)))
GO
SET IDENTITY_INSERT [dbo].[PurchaseReturnDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseReturnHeader] ON 

GO
INSERT [dbo].[PurchaseReturnHeader] ([Id], [PharmacyId], [ReturnNo], [ReturnDate], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (1, 1, N'GRN45', CAST(0xA5580443 AS SmallDateTime), N'GRN45', CAST(0xA5580443 AS SmallDateTime), 0, 2, N'12313', CAST(0xA52A0399 AS SmallDateTime), 4, CAST(0xA52E0399 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(1500.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(115.000 AS Decimal(18, 3)), CAST(1385.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5580443 AS SmallDateTime), N'6', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseReturnHeader] ([Id], [PharmacyId], [ReturnNo], [ReturnDate], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (2, 1, N'GRN46', CAST(0xA55903CD AS SmallDateTime), N'GRN46', CAST(0xA55903CD AS SmallDateTime), 0, 3, N'14542', CAST(0xA52A039B AS SmallDateTime), 12, CAST(0xA536039B AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(2000.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(1940.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA55903CD AS SmallDateTime), N'6', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseReturnHeader] ([Id], [PharmacyId], [ReturnNo], [ReturnDate], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (3, 1, N'GRN51', CAST(0xA5830327 AS SmallDateTime), N'GRN51', CAST(0xA5830327 AS SmallDateTime), 0, 2, N'D7500', CAST(0xA57803F9 AS SmallDateTime), 4, CAST(0xA57C03F9 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(13750.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(13750.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5830327 AS SmallDateTime), N'6', NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[PurchaseReturnHeader] OFF
GO
SET IDENTITY_INSERT [dbo].[Rack] ON 

GO
INSERT [dbo].[Rack] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'R1 Neuro', N'Neuro', 1)
GO
INSERT [dbo].[Rack] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'R2 Cardio', N'Cardio', 1)
GO
INSERT [dbo].[Rack] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'R3 General', N'General Medicine', 1)
GO
SET IDENTITY_INSERT [dbo].[Rack] OFF
GO
SET IDENTITY_INSERT [dbo].[RoleXFeature] ON 

GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1, 100, 8, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1024, 100, 500, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1015, 100, 700, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1016, 100, 710, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1017, 100, 720, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1018, 100, 730, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1019, 100, 740, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1020, 100, 750, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1021, 100, 760, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1022, 100, 770, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1025, 100, 780, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (3, 100, 800, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1002, 100, 810, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1003, 100, 820, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1004, 100, 830, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1005, 100, 840, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1006, 100, 850, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1007, 100, 860, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1008, 100, 870, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1009, 100, 880, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1010, 100, 890, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1011, 100, 900, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1012, 100, 910, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1013, 100, 920, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (4, 100, 8001, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (5, 100, 8002, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (6, 100, 8003, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (7, 100, 8004, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1023, 200, 5, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1014, 200, 7, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (2, 200, 8, 0)
GO
SET IDENTITY_INSERT [dbo].[RoleXFeature] OFF
GO
SET IDENTITY_INSERT [dbo].[RunningStock] ON 

GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (1, 1, 4, N'1234', 0, N'10/17', 50058, 1, CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), 1, 0, 1, 0, 0, 0, 0, NULL, NULL, CAST(0x0000A5770162808B AS DateTime), NULL, NULL, NULL, CAST(0x0000A56C00CEAE98 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN39')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (2, 1, 7, N'ddf', 0, N'12/19', 50059, 1, CAST(80.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), 1, 0, 1, 0, 0, 0, 1, NULL, NULL, CAST(0x0000A57701303086 AS DateTime), NULL, NULL, NULL, CAST(0x0000A57601072297 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN39')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (3, 1, 2, N'1234', 0, N'12/20', 50062, 1, CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), 1, 0, 1, 0, 0, 0, 1, NULL, NULL, CAST(0x0000A57800C6193A AS DateTime), NULL, NULL, NULL, CAST(0x0000A56C00DA3D25 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN40')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (4, 1, 2, N'1334', 1, N'12/20', 50065, 1, CAST(50.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), 5, 0, 4, 0, 0, 0, 4, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000A56C00D4409F AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN41')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (5, 1, 2, N'1234', 0, N'12/25', 50066, 1, CAST(55.000 AS Decimal(18, 3)), CAST(95.000 AS Decimal(18, 3)), 1, 0, 1, 0, 0, 0, 1, NULL, NULL, CAST(0x0000A57801087485 AS DateTime), NULL, NULL, NULL, CAST(0x0000A57801081D7B AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN43')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (6, 1, 2, N'121212', 0, N'12/25', 50067, 1, CAST(50.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), 2, 0, 1, 0, 0, 0, 2, NULL, NULL, CAST(0x0000A57701621514 AS DateTime), NULL, NULL, NULL, CAST(0x0000A57601092EE0 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN44')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (7, 1, 4, N'4512', 1, N'10/25', 50068, 1, CAST(75.000 AS Decimal(18, 3)), CAST(90.000 AS Decimal(18, 3)), 5, 0, 1, 0, 0, 0, 2, NULL, NULL, CAST(0x0000A5770163467C AS DateTime), NULL, NULL, NULL, CAST(0x0000A57601056817 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN44')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (16, 1, 2, N'cal123', 54, N'12/19', 50074, 2, CAST(12.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), 150, 0, 96, 0, 0, 0, 86, NULL, NULL, CAST(0x0000A58300DB956E AS DateTime), NULL, NULL, NULL, CAST(0x0000A58300DA8DB2 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN49')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (17, 1, 4, N'bb253', 897, N'10/19', 50075, 1, CAST(3.750 AS Decimal(18, 3)), CAST(5.600 AS Decimal(18, 3)), 1000, 0, 103, 0, 0, 0, 103, NULL, NULL, CAST(0x0000A58300DBA71C AS DateTime), NULL, NULL, NULL, CAST(0x0000A58300DA8DB4 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN49')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (10, 1, 1, N'123', 0, N'12/20', 50071, 1, CAST(50.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), 4, 0, 3, 0, 0, 0, 3, NULL, NULL, CAST(0x0000A57801087647 AS DateTime), NULL, NULL, NULL, CAST(0x0000A57801081D7B AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN32')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (18, 1, 2, N'Test1', 65, N'12/19', 50076, 1, CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), 100, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, CAST(0x0000A581014A424B AS DateTime), NULL, NULL, NULL, CAST(0x0000A5810149DD76 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN50')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (19, 1, 2, N'Test2', 40, N'10/17', 50077, 2, CAST(75.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), 50, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, CAST(0x0000A57A011A5A54 AS DateTime), NULL, NULL, NULL, CAST(0x0000A57A01197E83 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN50')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (20, 1, 2, N'Test1', 100, N'12/19', 4, 1, CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (14, 1, 2, N'234', 0, N'12/20', 50072, 1, CAST(10.000 AS Decimal(18, 3)), CAST(20.000 AS Decimal(18, 3)), 1, 0, 1, 0, 0, 0, 1, NULL, NULL, CAST(0x0000A57800C8923A AS DateTime), NULL, NULL, NULL, CAST(0x0000A57800C8586D AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN47')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (15, 1, 2, N'asda', 13, N'12/16', 50073, 1, CAST(356.400 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), 30, 0, 17, 0, 0, 0, 17, NULL, NULL, CAST(0x0000A5780107EB7C AS DateTime), NULL, NULL, NULL, CAST(0x0000A5780107C3B4 AS DateTime), CAST(5.50 AS Decimal(18, 2)), N'GRN48')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (21, 1, 2, N'Test2', 50, N'10/17', 5, 2, CAST(75.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (22, 1, 9, N'Pan256', 20, N'12/25', 50078, 1, CAST(75.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (23, 1, 2, N'Cal600', 50, N'10/20', 50079, 2, CAST(65.000 AS Decimal(18, 3)), CAST(82.000 AS Decimal(18, 3)), 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), N'GRN52')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (24, 1, 2, N'asd', 10, N'12/25', 50080, 1, CAST(50.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), 10, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000A58400B4AE50 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, CAST(14.50 AS Decimal(18, 2)), N'GRN53')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (25, 1, 9, N'asfadfas', 10, N'12/20', 50081, 1, CAST(100.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), 10, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000A58400DE2C99 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), N'GRN54')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (26, 1, 2, N'asfsf', 1, N'12/20', 50082, 2, CAST(10.000 AS Decimal(18, 3)), CAST(20.000 AS Decimal(18, 3)), 1, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000A58400DF2AFF AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, CAST(14.50 AS Decimal(18, 2)), N'GRN55')
GO
INSERT [dbo].[RunningStock] ([Id], [PharmacyId], [ProductId], [BatchNo], [Qty], [ExpiryDate], [PurDetId], [MfgId], [CostPrice], [MRP], [PurQty], [PurRetQty], [SaleQty], [SaleRetQty], [OpenStockQty], [StockAdjQty], [IndentQty], [PurDt], [PurRetDt], [SaleDt], [SaleRetDt], [OpenStockDt], [StockAdjDt], [IndentDt], [VAT], [GRNNo]) VALUES (27, 1, 9, N'pan58965', 10, NULL, 50083, 2, CAST(80.000 AS Decimal(18, 3)), CAST(145.000 AS Decimal(18, 3)), 10, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000A58400E05D22 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, CAST(5.50 AS Decimal(18, 2)), N'GRN56')
GO
SET IDENTITY_INSERT [dbo].[RunningStock] OFF
GO
SET IDENTITY_INSERT [dbo].[Sales] ON 

GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (1, 1, N'SB2', CAST(0xA54F02B6 AS SmallDateTime), NULL, NULL, N'Bala', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F02B6 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (3, 1, N'SB3', CAST(0xA54F02F0 AS SmallDateTime), NULL, NULL, N'Ganesh', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(75.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F02EF AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (15, 1, N'SB4', CAST(0xA54F0344 AS SmallDateTime), NULL, NULL, N'Mani', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(75.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F0344 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (16, 1, N'SB5', CAST(0xA54F0347 AS SmallDateTime), NULL, NULL, N'Vignesh', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F0347 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (17, 1, N'SB6', CAST(0xA54F0388 AS SmallDateTime), NULL, NULL, N'Sakthi', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(225.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(225.000 AS Decimal(18, 3)), CAST(225.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F0388 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (18, 1, N'SB7', CAST(0xA54F0388 AS SmallDateTime), NULL, NULL, N'Janaki', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(75.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA54F0388 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (19, 1, N'SB8', CAST(0xA5560552 AS SmallDateTime), NULL, NULL, N'Anu', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(225.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(225.000 AS Decimal(18, 3)), CAST(225.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Walkin', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5560552 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (21, 1, N'SB12', CAST(0xA5630383 AS SmallDateTime), NULL, NULL, N'Rosy', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'OP', N'Card', NULL, N'Balance   ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5630383 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (22, 1, N'SB20', CAST(0xA56C0302 AS SmallDateTime), NULL, NULL, N'Irin', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'OP', N'Card', NULL, N'Balance   ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA56C0302 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (23, 1, N'SB21', CAST(0xA5730360 AS SmallDateTime), NULL, NULL, N'Rini', NULL, NULL, N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'OP', N'Card', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5730360 AS SmallDateTime), 6, NULL)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (24, 1, N'SB22', CAST(0xA5750030 AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(430.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(430.000 AS Decimal(18, 3)), CAST(200.000 AS Decimal(18, 3)), CAST(230.000 AS Decimal(18, 3)), CAST(23.650 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'IP', N'Cash', NULL, N'Balance   ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA575002F AS SmallDateTime), 6, 21)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (26, 1, N'SB23', CAST(0xA5750050 AS SmallDateTime), NULL, NULL, N'Fairoz', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(8.250 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'IP', N'Cash', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5750050 AS SmallDateTime), 6, 22)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (27, 1, N'SB24', CAST(0xA5770303 AS SmallDateTime), NULL, NULL, N'A M AKRAM', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'IP', N'SELF', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770302 AS SmallDateTime), 7, 24)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (28, 1, N'SB25', CAST(0xA5770453 AS SmallDateTime), NULL, NULL, N'Fairoz', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'IP', N'CORPORATE', NULL, N'Paid      ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770453 AS SmallDateTime), 7, 25)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (29, 1, N'SB26', CAST(0xA5770504 AS SmallDateTime), NULL, NULL, N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(370.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(370.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(370.000 AS Decimal(18, 3)), CAST(15.400 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, N'IP', N'CORPORATE', NULL, N'Balance   ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770504 AS SmallDateTime), 7, 23)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (30, 1, N'SB27', CAST(0xA5770509 AS SmallDateTime), NULL, NULL, N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770509 AS SmallDateTime), 7, 26)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (31, 1, N'SB28', CAST(0xA577050B AS SmallDateTime), NULL, NULL, N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'Cash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA577050B AS SmallDateTime), 7, 18)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (32, 1, N'SB29', CAST(0xA577050D AS SmallDateTime), NULL, NULL, N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(190.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'Cash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA577050D AS SmallDateTime), 7, 20)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (33, 1, N'SB30', CAST(0xA5770522 AS SmallDateTime), NULL, NULL, N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(2450.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770522 AS SmallDateTime), 6, 27)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (34, 1, N'SB31', CAST(0xA5770525 AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(2820.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5770525 AS SmallDateTime), 6, 28)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (35, 1, N'SB32', CAST(0xA578029D AS SmallDateTime), NULL, NULL, N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(637.500 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA578029D AS SmallDateTime), 7, 29)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (36, 1, N'SB33', CAST(0xA57802D1 AS SmallDateTime), NULL, NULL, N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'Cash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802CE AS SmallDateTime), 7, 17)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (37, 1, N'SB34', CAST(0xA57802D5 AS SmallDateTime), NULL, NULL, N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802D3 AS SmallDateTime), 6, 30)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (38, 1, N'SB35', CAST(0xA57802D8 AS SmallDateTime), NULL, NULL, N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(2350.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802D8 AS SmallDateTime), 7, 31)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (39, 1, N'SB36', CAST(0xA57802DA AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(20.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(1.100 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802DA AS SmallDateTime), 7, 32)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (40, 1, N'SB37', CAST(0xA57802DD AS SmallDateTime), NULL, NULL, N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(76.500 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(4.208 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802DD AS SmallDateTime), 7, 33)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (42, 1, N'SB38', CAST(0xA57802ED AS SmallDateTime), NULL, NULL, N'A M AKRAM', NULL, N'IP1061', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(306.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(16.830 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57802ED AS SmallDateTime), 7, 34)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (43, 1, N'SB39', CAST(0xA5780384 AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(100.000 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(105.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5780384 AS SmallDateTime), 7, 35)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (44, 1, N'SB40', CAST(0xA5780398 AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(5.000 AS Decimal(18, 3)), CAST(250.000 AS Decimal(18, 3)), CAST(250.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5780398 AS SmallDateTime), 7, 35)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (45, 1, N'SB41', CAST(0xA57803A2 AS SmallDateTime), NULL, NULL, N'Fairoz', NULL, N'IP1057', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(127.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(127.500 AS Decimal(18, 3)), CAST(127.500 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(7.013 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803A2 AS SmallDateTime), 7, 36)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (46, 1, N'SB42', CAST(0xA57803A9 AS SmallDateTime), NULL, NULL, N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(815.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(815.000 AS Decimal(18, 3)), CAST(500.000 AS Decimal(18, 3)), CAST(315.000 AS Decimal(18, 3)), CAST(44.825 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803A9 AS SmallDateTime), 7, 37)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (47, 1, N'SB43', CAST(0xA57803C1 AS SmallDateTime), NULL, NULL, N'Mohammed ', NULL, N'IP1058', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(470.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(25.850 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803C1 AS SmallDateTime), 7, 40)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (48, 1, N'SB44', CAST(0xA57803C3 AS SmallDateTime), NULL, NULL, N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(220.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(220.500 AS Decimal(18, 3)), CAST(220.500 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(12.128 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57803C3 AS SmallDateTime), 7, 41)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (49, 1, N'SB45', CAST(0xA57A0404 AS SmallDateTime), NULL, NULL, N'Vvvvv', NULL, N'IP1063', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(5000.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(5000.000 AS Decimal(18, 3)), CAST(3000.000 AS Decimal(18, 3)), CAST(2000.000 AS Decimal(18, 3)), CAST(275.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA57A0404 AS SmallDateTime), 6, 42)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (50, 1, N'SB46', CAST(0xA58104B2 AS SmallDateTime), NULL, NULL, N'Sakthivel', NULL, N'IP1064', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(1500.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(1500.000 AS Decimal(18, 3)), CAST(1000.000 AS Decimal(18, 3)), CAST(500.000 AS Decimal(18, 3)), CAST(82.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'CORPORATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA58104B2 AS SmallDateTime), 7, 43)
GO
INSERT [dbo].[Sales] ([BillCode], [PharmacyId], [BillNo], [BillDate], [BillTime], [BillDateTime], [Customer], [CustomerID], [IPNo], [ConsultantName], [ConsultantCode], [Department], [DepartmentCode], [Ward], [TotalAmount], [DiscountPercent], [Discount], [NetAmount], [PaidAmount], [Balance], [TotalVat], [RoundOff], [UserName], [SalesMode], [PayMode], [CreditAuthorization], [BillStatus], [BillCancel], [BillCancelDate], [BillCancelUser], [BillEdit], [BillEditDate], [BillEditUser], [RefDrName], [BillFor], [BilledUser], [MobileNo], [AddedBy], [AddedDateTime], [SavedUserID], [IndentId]) VALUES (51, 1, N'SB47', CAST(0xA583031F AS SmallDateTime), NULL, NULL, N'SAIRA', NULL, N'IP1056', N'Dr. Varalakshmi', NULL, NULL, NULL, NULL, CAST(271.800 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(100.000 AS Decimal(18, 3)), CAST(171.800 AS Decimal(18, 3)), CAST(171.800 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(14.949 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'SELF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(0xA5830320 AS SmallDateTime), 6, 44)
GO
SET IDENTITY_INSERT [dbo].[Sales] OFF
GO
SET IDENTITY_INSERT [dbo].[SalesDetails] ON 

GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (1, 1, 15, 2, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0347 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (2, 1, 16, 2, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0347 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (3, 1, 16, 5, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0347 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (4, 1, 17, 2, N'Batch123', 2, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(200.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0388 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (5, 1, 17, 5, N'Batch123', 1, 11, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0388 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (6, 1, 18, 2, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA54F0388 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (7, 1, 19, 2, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5560552 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (8, 1, 19, 4, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5560552 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (9, 1, 19, 7, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5560552 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (10, 1, 21, 2, N'Batch123', 2, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(200.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5630383 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (11, 1, 9, 2, N'1234', 1, 1, N'10/28', N'GRN', CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA56C02C9 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (12, 1, 22, 2, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA56C0302 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (13, 1, 22, 1, N'Batch123', 1, 1, N'12/20', N'GRN', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA56C0302 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (14, 1, 23, 2, N'1334', 4, 1, N'05/19', N'GRN', CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5730360 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (15, 1, 23, 4, N'1234', 1, 1, N'07/16', N'GRN', CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5730360 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (16, 1, 24, 2, N'1334', 4, 1, N'12/20', N'GRN', CAST(50.000 AS Decimal(18, 3)), CAST(200.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(320.000 AS Decimal(18, 3)), CAST(5.50 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA575002F AS SmallDateTime), NULL, NULL, NULL, NULL, 50065)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (17, 1, 24, 4, N'1234', 1, 1, N'10/17', N'GRN', CAST(60.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(5.50 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA575002F AS SmallDateTime), NULL, NULL, NULL, NULL, 3)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (18, 1, 26, 2, N'1234', 1, 1, N'12/20', N'GRN', CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(5.50 AS Decimal(18, 2)), CAST(8.250 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5750050 AS SmallDateTime), NULL, NULL, NULL, NULL, 50062)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (19, 1, 27, 2, N'121212', 1, 1, N'12/25', N'GRN44', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 0, 1, CAST(0xA5770302 AS SmallDateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (20, 1, 28, 7, N'ddf', 1, 1, N'12/19', N'GRN39', CAST(80.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770453 AS SmallDateTime), NULL, NULL, NULL, NULL, 50059)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (21, 1, 29, 4, N'4512', 3, NULL, N'10/25', N'GRN44', CAST(75.000 AS Decimal(18, 3)), CAST(225.000 AS Decimal(18, 3)), CAST(90.000 AS Decimal(18, 3)), CAST(270.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770504 AS SmallDateTime), NULL, NULL, NULL, NULL, 50068)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (22, 1, 29, 1, N'123', 1, 1, N'12/20', N'GRN32', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770504 AS SmallDateTime), NULL, NULL, NULL, NULL, 50071)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (23, 1, 30, 2, N'121212', 1, NULL, N'12/25', N'GRN44', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(80.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770509 AS SmallDateTime), NULL, NULL, NULL, NULL, 50067)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (24, 1, 31, 4, N'1234', 1, NULL, N'10/17', N'GRN39', CAST(60.000 AS Decimal(18, 3)), CAST(60.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA577050B AS SmallDateTime), NULL, NULL, NULL, NULL, 50058)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (25, 1, 32, 1, N'123', 1, NULL, N'12/20', N'GRN32', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA577050D AS SmallDateTime), NULL, NULL, NULL, NULL, 50071)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (26, 1, 32, 4, N'4512', 1, 1, N'10/25', N'GRN44', CAST(75.000 AS Decimal(18, 3)), CAST(75.000 AS Decimal(18, 3)), CAST(90.000 AS Decimal(18, 3)), CAST(90.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA577050D AS SmallDateTime), NULL, NULL, NULL, NULL, 50068)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (27, 1, 33, 2, N'asda', 5, NULL, N'12/16', N'GRN48', CAST(356.400 AS Decimal(18, 3)), CAST(1782.000 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(2350.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770522 AS SmallDateTime), NULL, NULL, NULL, NULL, 50073)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (28, 1, 33, 1, N'123', 1, 1, N'12/20', N'GRN32', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770522 AS SmallDateTime), NULL, NULL, NULL, NULL, 50071)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (29, 1, 34, 2, N'asda', 6, NULL, N'12/16', N'GRN48', CAST(356.400 AS Decimal(18, 3)), CAST(2138.400 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(2820.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5770525 AS SmallDateTime), NULL, NULL, NULL, NULL, 50073)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (30, 1, 35, 2, N'cal123', 25, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(312.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(637.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA578029D AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (31, 1, 36, 2, N'1234', 1, NULL, N'12/20', N'GRN40', CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802CE AS SmallDateTime), NULL, NULL, NULL, NULL, 50062)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (32, 1, 37, 2, N'cal123', 10, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802D3 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (33, 1, 38, 2, N'asda', 5, NULL, N'12/16', N'GRN48', CAST(356.400 AS Decimal(18, 3)), CAST(1782.000 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(2350.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802D8 AS SmallDateTime), NULL, NULL, NULL, NULL, 50073)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (34, 1, 39, 2, N'234', 1, NULL, N'12/20', N'GRN47', CAST(10.000 AS Decimal(18, 3)), CAST(10.000 AS Decimal(18, 3)), CAST(20.000 AS Decimal(18, 3)), CAST(20.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802DA AS SmallDateTime), NULL, NULL, NULL, NULL, 50072)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (35, 1, 40, 2, N'cal123', 3, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(37.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(76.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802DD AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (36, 1, 42, 2, N'cal123', 12, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(306.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(16.830 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57802ED AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (37, 1, 43, 2, N'cal123', 10, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5780384 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (38, 1, 44, 2, N'cal123', 10, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5780398 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (39, 1, 45, 2, N'cal123', 5, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(62.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(127.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(7.013 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803A2 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (40, 1, 46, 2, N'cal123', 10, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803A9 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (41, 1, 46, 4, N'bb253', 100, 1, N'10/19', N'GRN49', CAST(3.750 AS Decimal(18, 3)), CAST(375.000 AS Decimal(18, 3)), CAST(5.600 AS Decimal(18, 3)), CAST(560.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(30.800 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803A9 AS SmallDateTime), NULL, NULL, NULL, NULL, 50075)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (42, 1, 47, 2, N'asda', 1, NULL, N'12/16', N'GRN48', CAST(356.400 AS Decimal(18, 3)), CAST(356.400 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(470.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(25.850 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803C1 AS SmallDateTime), NULL, NULL, NULL, NULL, 50073)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (43, 1, 48, 2, N'1234', 1, NULL, N'12/25', N'GRN43', CAST(55.000 AS Decimal(18, 3)), CAST(55.000 AS Decimal(18, 3)), CAST(95.000 AS Decimal(18, 3)), CAST(95.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(5.225 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803C3 AS SmallDateTime), NULL, NULL, NULL, NULL, 50066)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (44, 1, 48, 1, N'123', 1, 1, N'12/20', N'GRN32', CAST(50.000 AS Decimal(18, 3)), CAST(50.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(5.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803C3 AS SmallDateTime), NULL, NULL, NULL, NULL, 50071)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (45, 1, 48, 2, N'cal123', 1, 1, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(12.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(1.403 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57803C3 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (46, 1, 49, 2, N'Test1', 25, NULL, N'12/19', N'GRN50', CAST(100.000 AS Decimal(18, 3)), CAST(2500.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(3750.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(206.250 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57A0404 AS SmallDateTime), NULL, NULL, NULL, NULL, 50076)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (47, 1, 49, 2, N'Test2', 10, 1, N'10/17', N'GRN50', CAST(75.000 AS Decimal(18, 3)), CAST(750.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(1250.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(68.750 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA57A0404 AS SmallDateTime), NULL, NULL, NULL, NULL, 50077)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (48, 1, 50, 2, N'Test1', 10, NULL, N'12/19', N'GRN50', CAST(100.000 AS Decimal(18, 3)), CAST(1000.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(1500.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(82.500 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA58104B2 AS SmallDateTime), NULL, NULL, NULL, NULL, 50076)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (49, 1, 51, 2, N'cal123', 10, NULL, N'12/19', N'GRN49', CAST(12.500 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(25.500 AS Decimal(18, 3)), CAST(255.000 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(14.025 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5830320 AS SmallDateTime), NULL, NULL, NULL, NULL, 50074)
GO
INSERT [dbo].[SalesDetails] ([bdcode], [PharmacyId], [BillCode], [ProductId], [BatchNo], [Qty], [MfgId], [ExpiryDate], [GRNNo], [CostPrice], [TotalCostPrice], [MRP], [TotalMRP], [TaxPercent], [TaxAmount], [DiscPercent], [Discount], [CancelFlag], [EditProduct], [OldQty], [AddedBy], [AddedDateTime], [EditedBy], [EditedDate], [CanceledBy], [CanceledDate], [PurDetId]) VALUES (50, 1, 51, 4, N'bb253', 3, 1, N'10/19', N'GRN49', CAST(3.750 AS Decimal(18, 3)), CAST(11.250 AS Decimal(18, 3)), CAST(5.600 AS Decimal(18, 3)), CAST(16.800 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.924 AS Decimal(18, 3)), CAST(0.00 AS Decimal(18, 2)), CAST(0.000 AS Decimal(18, 3)), 0, 0, 0, 1, CAST(0xA5830320 AS SmallDateTime), NULL, NULL, NULL, NULL, 50075)
GO
SET IDENTITY_INSERT [dbo].[SalesDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Supplier] ON 

GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive], [DueDays]) VALUES (1, N'Vardhaman Pharma', 1, N'AMS Bangalore', N'AB1174', NULL, N'Karnataka', N'katnataka', N'India', N'Bala', N'ams@gmail.com', N'45789', N'ab12354', N'90350', N'9035010066', 1, 5)
GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive], [DueDays]) VALUES (2, N'Sri Balaji Pharma', 1, N'DARIA Bangalore', N'AB1174', NULL, N'Karnataka', N'katnataka', N'India', N'Bala', N'ams@gmail.com', N'45789', N'ab12354', N'90350', N'9035010066', 1, 4)
GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive], [DueDays]) VALUES (3, N'Anand Pharma', 1, N'tamilnadu', N'tamilnadu', NULL, N'dharmapuri', N'india', N'india', N'india', N'ams@gmail.com', N'944345485', N'5878', N'560034', N'9543014127', 1, 12)
GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive], [DueDays]) VALUES (4, N'Focus Medisales Pvt Ltd', 1, NULL, N'1325455887855', NULL, NULL, NULL, NULL, N'Bala', NULL, NULL, NULL, NULL, NULL, 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[Supplier] OFF
GO
SET IDENTITY_INSERT [dbo].[Tax] ON 

GO
INSERT [dbo].[Tax] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'5.5', N'VAT 5.5', 1)
GO
INSERT [dbo].[Tax] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'14.5', N'VAT 14.5', 1)
GO
SET IDENTITY_INSERT [dbo].[Tax] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ApplicationFeature_Key_UNIQUE]    Script Date: 1/17/2016 12:33:18 PM ******/
ALTER TABLE [dbo].[ApplicationFeature] ADD  CONSTRAINT [ApplicationFeature_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Applicat__3214EC068A5B222B]    Script Date: 1/17/2016 12:33:18 PM ******/
ALTER TABLE [dbo].[ApplicationMenu] ADD UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ApplicationModule_Key_UNIQUE]    Script Date: 1/17/2016 12:33:18 PM ******/
ALTER TABLE [dbo].[ApplicationModule] ADD  CONSTRAINT [ApplicationModule_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Bank_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Bank] ADD  CONSTRAINT [UQ_Bank_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Consultant_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Consultant] ADD  CONSTRAINT [UQ_Consultant_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_CreditAuth_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[CreditAuth] ADD  CONSTRAINT [UQ_CreditAuth_Name] UNIQUE NONCLUSTERED 
(
	[AuthName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Department_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [UQ_Department_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugCategory_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[DrugCategory] ADD  CONSTRAINT [UQ_DrugCategory_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugContent_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[DrugContent] ADD  CONSTRAINT [UQ_DrugContent_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugGeneric_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[DrugGeneric] ADD  CONSTRAINT [UQ_DrugGeneric_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugType_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[DrugType] ADD  CONSTRAINT [UQ_DrugType_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugUnit_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[DrugUnit] ADD  CONSTRAINT [UQ_DrugUnit_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Product_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [UQ_Product_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Rack_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Rack] ADD  CONSTRAINT [UQ_Rack_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Supplier_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Supplier] ADD  CONSTRAINT [UQ_Supplier_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Tax_Name]    Script Date: 1/17/2016 12:33:19 PM ******/
ALTER TABLE [dbo].[Tax] ADD  CONSTRAINT [UQ_Tax_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicationFeature] ADD  CONSTRAINT [DF_ApplicationFeature_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationMenu] ADD  CONSTRAINT [DF_ApplicationMenu_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationModule] ADD  CONSTRAINT [DF_ApplicationModule_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Person] ADD  DEFAULT ('India') FOR [Country]
GO
ALTER TABLE [dbo].[Pharmacy] ADD  DEFAULT ('India') FOR [Country]
GO
ALTER TABLE [dbo].[Pharmacy] ADD  CONSTRAINT [DF_Pharmacy_GRNPrefix]  DEFAULT ('GRN') FOR [GRNPrefix]
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ModuleId])
REFERENCES [dbo].[ApplicationModule] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ModuleId])
REFERENCES [dbo].[ApplicationModule] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ModuleId])
REFERENCES [dbo].[ApplicationModule] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ParentId])
REFERENCES [dbo].[ApplicationFeature] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ParentId])
REFERENCES [dbo].[ApplicationFeature] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ParentId])
REFERENCES [dbo].[ApplicationFeature] ([Id])
GO
ALTER TABLE [dbo].[PurchaseDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseDetail_Id] FOREIGN KEY([PHeaderId])
REFERENCES [dbo].[PurchaseHeader] ([Id])
GO
ALTER TABLE [dbo].[PurchaseDetail] CHECK CONSTRAINT [FK_PurchaseDetail_Id]
GO
ALTER TABLE [dbo].[PurchaseDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseDetail_MfgId] FOREIGN KEY([MfgId])
REFERENCES [dbo].[Manufacturer] ([Id])
GO
ALTER TABLE [dbo].[PurchaseDetail] CHECK CONSTRAINT [FK_PurchaseDetail_MfgId]
GO
ALTER TABLE [dbo].[PurchaseDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseDetail_PharmacyId] FOREIGN KEY([PharmacyId])
REFERENCES [dbo].[Pharmacy] ([Id])
GO
ALTER TABLE [dbo].[PurchaseDetail] CHECK CONSTRAINT [FK_PurchaseDetail_PharmacyId]
GO
ALTER TABLE [dbo].[PurchaseDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseDetail_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[PurchaseDetail] CHECK CONSTRAINT [FK_PurchaseDetail_ProductId]
GO
ALTER TABLE [dbo].[PurchaseHeader]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseHeader_PharmacyId] FOREIGN KEY([PharmacyId])
REFERENCES [dbo].[Pharmacy] ([Id])
GO
ALTER TABLE [dbo].[PurchaseHeader] CHECK CONSTRAINT [FK_PurchaseHeader_PharmacyId]
GO
ALTER TABLE [dbo].[PurchaseReturnDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturnDetail_Id] FOREIGN KEY([PRHeaderId])
REFERENCES [dbo].[PurchaseReturnHeader] ([Id])
GO
ALTER TABLE [dbo].[PurchaseReturnDetail] CHECK CONSTRAINT [FK_PurchaseReturnDetail_Id]
GO
ALTER TABLE [dbo].[PurchaseReturnDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturnDetail_MfgId] FOREIGN KEY([MfgId])
REFERENCES [dbo].[Manufacturer] ([Id])
GO
ALTER TABLE [dbo].[PurchaseReturnDetail] CHECK CONSTRAINT [FK_PurchaseReturnDetail_MfgId]
GO
ALTER TABLE [dbo].[PurchaseReturnDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturnDetail_PharmacyId] FOREIGN KEY([PharmacyId])
REFERENCES [dbo].[Pharmacy] ([Id])
GO
ALTER TABLE [dbo].[PurchaseReturnDetail] CHECK CONSTRAINT [FK_PurchaseReturnDetail_PharmacyId]
GO
ALTER TABLE [dbo].[PurchaseReturnDetail]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturnDetail_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[PurchaseReturnDetail] CHECK CONSTRAINT [FK_PurchaseReturnDetail_ProductId]
GO
ALTER TABLE [dbo].[PurchaseReturnHeader]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturnHeader_PharmacyId] FOREIGN KEY([PharmacyId])
REFERENCES [dbo].[Pharmacy] ([Id])
GO
ALTER TABLE [dbo].[PurchaseReturnHeader] CHECK CONSTRAINT [FK_PurchaseReturnHeader_PharmacyId]
GO

