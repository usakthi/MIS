USE [SpiderPharmacy]
GO
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 05/28/2015 21:07:33 ******/
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

/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetUserLogonDetails]          
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
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM Tax  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM Rack  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM Manufacturer  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetDrugUnits]    

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

SELECT Id,Name,[Description] As [Desc], IsActive FROM DrugGeneric  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM DrugType
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM DrugContent
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM DrugCategory  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 05/28/2015 21:07:33 ******/
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

SELECT Id,Name,[Description] As [Desc], IsActive FROM Department  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 05/28/2015 21:07:33 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.Tax   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.Rack   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.Manufacturer   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 05/28/2015 21:07:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DeleteDrugUnit]    
 @Id INT,
 @RowsAffected INT OUTPUT  

AS   

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON



BEGIN TRY

DELETE FROM dbo.DrugGeneric   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.DrugType
	
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.DrugContent   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.DrugCategory   
	
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
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 05/28/2015 21:07:33 ******/
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

DELETE FROM dbo.Department   
	
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
