
GO
DELETE FROM [dbo].[Tax]
GO
DELETE FROM [dbo].[RoleXFeature]
GO
DELETE FROM [dbo].[Rack]
GO
DELETE FROM [dbo].[ProductType]
GO
DELETE FROM [dbo].[Product]
GO
DELETE FROM [dbo].[PharmacyXModule]
GO
DELETE FROM [dbo].[Pharmacy]
GO
DELETE FROM [dbo].[Person]
GO
DELETE FROM [dbo].[Manufacturer]
GO
DELETE FROM [dbo].[DrugType]
GO
DELETE FROM [dbo].[DrugGeneric]
GO
DELETE FROM [dbo].[DrugContent]
GO
DELETE FROM [dbo].[DrugCategory]
GO
DELETE FROM [dbo].[Department]
GO
DELETE FROM [dbo].[ApplicationUser]
GO
DELETE FROM [dbo].[ApplicationRole]
GO
DELETE FROM [dbo].[ApplicationMenu]
GO
DELETE FROM [dbo].[ApplicationFeature]
GO
DELETE FROM [dbo].[ApplicationModule]
GO
INSERT [dbo].[ApplicationModule] ([Id], [Key], [Name], [LandingPage], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted]) VALUES (800, N'SiteSettings', N'Settings', N'/admin', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8, 800, N'SiteSettings', N'Settings', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, NULL, 8)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (800, 800, N'DrugUnit', N'Drung Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 8, 800)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (810, 800, N'Manufacturer', N'Manufacturer', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 810)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (820, 800, N'Category', N'Category', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, 820)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8001, 800, N'AddDrugUnit', N'Add Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8002, 800, N'EditDrugUnit', N'Edit Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8003, 800, N'DeleteDrugUnit', N'Delete Drug Unit', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8004, 800, N'ViewDrugUnits', N'View Drug Units', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, 800, NULL)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (8, N'SiteSettings', N'Settings', N'fa fa-gear', N'#/admin', NULL, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (800, N'DrugUnit', N'Drug Unit', N'fa fa-leaf', N'#/unit', 8, 1, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (810, N'Manufacturer', N'Manufacturer', N'fa fa-truck', N'#/manf', 8, 2, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (820, N'Category', N'Category', N'fa fa-file-o', N'#/category', 8, 3, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (830, N'Department', N'Department', N'fa fa-bank', N'#/department', 8, 4, 0)
GO
INSERT [dbo].[ApplicationMenu] ([Id], [Key], [Name], [DisplayImageClass], [URL], [ParentId], [Order], [IsDeleted]) VALUES (840, N'DrugType', N'DrugType', N'fa fa-file-o', N'#/drugtype', 8, 5, 0)
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (100, 1, N'SuperAdmin', NULL, 0, NULL, NULL, NULL, NULL, N'#/admin')
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (110, 1, N'Admin', NULL, 0, NULL, NULL, NULL, NULL, N'/index')
GO
INSERT [dbo].[ApplicationRole] ([RoleId], [PharmacyId], [RoleName], [RoleDescription], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [LandingPage]) VALUES (200, 1, N'Supplier', NULL, 0, NULL, NULL, NULL, NULL, N'/supplier')
GO
SET IDENTITY_INSERT [dbo].[ApplicationUser] ON 

GO
INSERT [dbo].[ApplicationUser] ([UserId], [PharmacyId], [PersonId], [Username], [Password], [EmailId], [RoleId], [LastLoginDate], [FailedLoginDate], [IsActive], [IsAccountLocked], [FailedLoginAttempt], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [UserType], [NeedPasswordReset]) VALUES (6, 1, 1, N'misadmin', N'1000:0l1u6/DbKlnDBiYRDLr0SfIUpmMhsGNw:osNxkhIZLxtRVYrsubfCRNWCot2Y/GW+', N'dariasys@gmail.com', 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[ApplicationUser] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugCategory] ON 

GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Test', N'cardewdwdewd', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugGeneric] ON 

GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'mg', N'milligramdewed', 0)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (12, N'ml', N'ml', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (13, N'Tes', N'testad', 1)
GO
INSERT [dbo].[DrugGeneric] ([Id], [Name], [Description], [IsActive]) VALUES (1013, N'ok', N'dsa', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugGeneric] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

GO
INSERT [dbo].[Person] ([PersonId], [PharmacyId], [FirstName], [LastName], [Gender], [DOB], [MobileNumber], [EmailId], [AddressLine], [City], [State], [ZipCode], [Country], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [PersonImageUrl]) VALUES (1, 1, N'Daria', N'Admin', N'Male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
INSERT [dbo].[Pharmacy] ([Id], [ParentId], [Name], [CompanyName], [ContactPerson], [TINRegNo], [DrugLicenceNo], [EmailId], [Mobile], [Telephone1], [Telephone2], [Fax], [Website], [AddressLine1], [AddressLine2], [Zipcode], [City], [Country], [LogoImage], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, NULL, N'Daria', N'Daria', N'Uniza', NULL, NULL, N'dariasys@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] ON 

GO
INSERT [dbo].[PharmacyXModule] ([Id], [PharmacyId], [ModuleId], [IsDeleted]) VALUES (1, 1, 800, 0)
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] OFF
GO
SET IDENTITY_INSERT [dbo].[RoleXFeature] ON 

GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1, 100, 8, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (3, 100, 800, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1002, 100, 810, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (1003, 100, 820, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (4, 100, 8001, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (5, 100, 8002, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (6, 100, 8003, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (7, 100, 8004, 0)
GO
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (2, 200, 8, 0)
GO
SET IDENTITY_INSERT [dbo].[RoleXFeature] OFF
GO
SET IDENTITY_INSERT [dbo].[Tax] ON 

GO
INSERT [dbo].[Tax] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'okd', N'dsad', 1)
GO
SET IDENTITY_INSERT [dbo].[Tax] OFF
GO
