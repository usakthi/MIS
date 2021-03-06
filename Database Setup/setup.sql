ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Paren__21B6055D]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Modul__20C1E124]
GO
ALTER TABLE [dbo].[Pharmacy] DROP CONSTRAINT [DF__Pharmacy__Countr__164452B1]
GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [DF__Person__Country__1367E606]
GO
ALTER TABLE [dbo].[ApplicationModule] DROP CONSTRAINT [DF_ApplicationModule_IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationMenu] DROP CONSTRAINT [DF_ApplicationMenu_IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [DF_ApplicationFeature_IsDeleted]
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Tax]
GO
/****** Object:  Table [dbo].[RoleXFeature]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[RoleXFeature]
GO
/****** Object:  Table [dbo].[Rack]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Rack]
GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ProductType]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Product]
GO
/****** Object:  Table [dbo].[PharmacyXModule]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[PharmacyXModule]
GO
/****** Object:  Table [dbo].[Pharmacy]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Pharmacy]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Person]
GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Manufacturer]
GO
/****** Object:  Table [dbo].[DrugType]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[DrugType]
GO
/****** Object:  Table [dbo].[DrugGeneric]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[DrugGeneric]
GO
/****** Object:  Table [dbo].[DrugContent]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[DrugContent]
GO
/****** Object:  Table [dbo].[DrugCategory]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[DrugCategory]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[Department]
GO
/****** Object:  Table [dbo].[ApplicationUser]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ApplicationUser]
GO
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ApplicationRole]
GO
/****** Object:  Table [dbo].[ApplicationModule]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ApplicationModule]
GO
/****** Object:  Table [dbo].[ApplicationMenu]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ApplicationMenu]
GO
/****** Object:  Table [dbo].[ApplicationFeature]    Script Date: 07-06-2015 20:21:01 ******/
DROP TABLE [dbo].[ApplicationFeature]
GO
/****** Object:  Table [dbo].[ApplicationFeature]    Script Date: 07-06-2015 20:21:01 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ApplicationFeature_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationMenu]    Script Date: 07-06-2015 20:21:02 ******/
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
	[IsDeleted] [bit] NULL,
UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationModule]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ApplicationModule_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[ApplicationUser]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[Department]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Department_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugCategory]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_DrugCategory_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugContent]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_DrugContent_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugGeneric]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_DrugGeneric_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DrugType]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_DrugType_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 07-06-2015 20:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturer](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Manufacturer__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[Pharmacy]    Script Date: 07-06-2015 20:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK__Pharmacy__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PharmacyXModule]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[Product]    Script Date: 07-06-2015 20:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Classification] [tinyint] NULL,
	[MainCategoryId] [int] NULL,
	[ProductTypeId] [int] NULL,
	[ManufacturerId] [int] NULL,
	[DrugGenericId] [int] NULL,
	[Strength] [nvarchar](20) NULL,
	[Unit] [nvarchar](20) NULL,
	[MinStock] [numeric](18, 2) NULL,
	[MaxStock] [numeric](18, 2) NULL,
	[ExpiryDate] [smalldatetime] NOT NULL,
	[AllowModifyExpiry] [bit] NULL,
	[NotifyExpiry] [bit] NULL,
	[NotifyExpiryDays] [int] NULL,
	[SupplierTake] [bit] NULL,
	[SupplierTakeBeforeExpiry] [bit] NULL,
	[SupplierTakeBeforeExpiryDays] [int] NULL,
	[SupplierTakeAfterExpiry] [bit] NULL,
	[SupplierTakeAfterExpiryDays] [int] NULL,
	[AddedBy] [int] NULL,
	[AddedDateTime] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[Rack]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Rack_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoleXFeature]    Script Date: 07-06-2015 20:21:02 ******/
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
/****** Object:  Table [dbo].[Tax]    Script Date: 07-06-2015 20:21:02 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Tax_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

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
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ModuleId])
REFERENCES [dbo].[ApplicationModule] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFeature]  WITH CHECK ADD FOREIGN KEY([ParentId])
REFERENCES [dbo].[ApplicationFeature] ([Id])
GO


/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateTax]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateTax]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateRack]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateRack]
GO
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateManufacturer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateDrugType]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugContent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUDSRGenerateRPSRistaData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUDSRGenerateRPSRistaData]
GO
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserLogonDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserLogonDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTaxs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetTaxs]
GO
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTax]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetTax]
GO
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRacks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRacks]
GO
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRack]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRack]
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetManufacturers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetManufacturers]
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetManufacturer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugUnits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugUnits]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugTypes]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugType]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugContents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugContents]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugContent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDrugCategories]
GO
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDepartments]
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDepartment]
GO
/****** Object:  StoredProcedure [dbo].[GetAllActiveMenuItems]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllActiveMenuItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllActiveMenuItems]
GO
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteTax]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteTax]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteRack]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteRack]
GO
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteManufacturer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteDrugType]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugContent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteDepartment]
GO
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddTax]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddTax]
GO
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddRack]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddRack]
GO
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddManufacturer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddDrugType]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugContent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 07-06-2015 20:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddDepartment]
GO
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddDepartment]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddDrugCategory]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugContent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddDrugContent]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddDrugType]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddDrugUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddDrugUnit]    

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddManufacturer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddManufacturer]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddRack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddRack]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddTax]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddTax]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteDepartment]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteDrugCategory]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugContent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteDrugContent]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteDrugType]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteDrugUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteDrugUnit]    
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteManufacturer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteManufacturer]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteRack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteRack]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteTax]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteTax]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllActiveMenuItems]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllActiveMenuItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[GetAllActiveMenuItems]



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






' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDepartment]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDepartments] 

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugCategories]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugCategories]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugCategory]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugContent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugContent]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugContents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugContents]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugType]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugTypes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugTypes]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugUnit]    
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDrugUnits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDrugUnits]    

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetManufacturer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetManufacturer]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetManufacturers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetManufacturers]    

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetRack]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRacks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetRacks]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTax]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetTax]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTaxs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetTaxs]

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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserLogonDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserLogonDetails]          

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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUDSRGenerateRPSRistaData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROC [dbo].[spUDSRGenerateRPSRistaData]
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
SET @RPSDate=CAST(CAST(DATEPART(yyyy, @Date) as varChar(4)) + ''/'' + CAST(DATEPART(mm, @Date) as varChar(2)) + ''/01'' AS DATETIME)
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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateDepartment]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateDrugCategory]    
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugContent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateDrugContent]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateDrugType]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateDrugUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateDrugUnit]    
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateManufacturer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateManufacturer]    
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateRack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateRack]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 07-06-2015 20:23:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateTax]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateTax]
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

	RAISERROR ( ''Error %s occurred in %s. Line  %d'', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
' 
END
GO


