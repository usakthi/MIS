USE [SpiderPharmacy]
GO
ALTER TABLE [dbo].[PurchaseHeader] DROP CONSTRAINT [FK_PurchaseHeader_PharmacyId]
GO
ALTER TABLE [dbo].[PurchaseDetail] DROP CONSTRAINT [FK_PurchaseDetail_ProductId]
GO
ALTER TABLE [dbo].[PurchaseDetail] DROP CONSTRAINT [FK_PurchaseDetail_PharmacyId]
GO
ALTER TABLE [dbo].[PurchaseDetail] DROP CONSTRAINT [FK_PurchaseDetail_MfgId]
GO
ALTER TABLE [dbo].[PurchaseDetail] DROP CONSTRAINT [FK_PurchaseDetail_Id]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Paren__5C6CB6D7]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Paren__4460231C]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Paren__1975C517]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Modul__5B78929E]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Modul__436BFEE3]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [FK__Applicati__Modul__1881A0DE]
GO
ALTER TABLE [dbo].[Pharmacy] DROP CONSTRAINT [DF_Pharmacy_GRNPrefix]
GO
ALTER TABLE [dbo].[Pharmacy] DROP CONSTRAINT [DF__Pharmacy__Countr__5A846E65]
GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [DF__Person__Country__59904A2C]
GO
ALTER TABLE [dbo].[ApplicationModule] DROP CONSTRAINT [DF_ApplicationModule_IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationMenu] DROP CONSTRAINT [DF_ApplicationMenu_IsDeleted]
GO
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [DF_ApplicationFeature_IsDeleted]
GO
/****** Object:  Index [UQ_Tax_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Tax] DROP CONSTRAINT [UQ_Tax_Name]
GO
/****** Object:  Index [UQ_Supplier_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Supplier] DROP CONSTRAINT [UQ_Supplier_Name]
GO
/****** Object:  Index [UQ_Rack_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Rack] DROP CONSTRAINT [UQ_Rack_Name]
GO
/****** Object:  Index [UQ_Product_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [UQ_Product_Name]
GO
/****** Object:  Index [UQ_DrugUnit_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugUnit] DROP CONSTRAINT [UQ_DrugUnit_Name]
GO
/****** Object:  Index [UQ_DrugType_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugType] DROP CONSTRAINT [UQ_DrugType_Name]
GO
/****** Object:  Index [UQ_DrugGeneric_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugGeneric] DROP CONSTRAINT [UQ_DrugGeneric_Name]
GO
/****** Object:  Index [UQ_DrugContent_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugContent] DROP CONSTRAINT [UQ_DrugContent_Name]
GO
/****** Object:  Index [UQ_DrugCategory_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugCategory] DROP CONSTRAINT [UQ_DrugCategory_Name]
GO
/****** Object:  Index [UQ_Department_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Department] DROP CONSTRAINT [UQ_Department_Name]
GO
/****** Object:  Index [UQ_CreditAuth_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[CreditAuth] DROP CONSTRAINT [UQ_CreditAuth_Name]
GO
/****** Object:  Index [UQ_Bank_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Bank] DROP CONSTRAINT [UQ_Bank_Name]
GO
/****** Object:  Index [ApplicationModule_Key_UNIQUE]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationModule] DROP CONSTRAINT [ApplicationModule_Key_UNIQUE]
GO
/****** Object:  Index [UQ__Applicat__3214EC062AD55B43]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationMenu] DROP CONSTRAINT [UQ__Applicat__3214EC062AD55B43]
GO
/****** Object:  Index [ApplicationFeature_Key_UNIQUE]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationFeature] DROP CONSTRAINT [ApplicationFeature_Key_UNIQUE]
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Tax]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Supplier]
GO
/****** Object:  Table [dbo].[RoleXFeature]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[RoleXFeature]
GO
/****** Object:  Table [dbo].[Rack]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Rack]
GO
/****** Object:  Table [dbo].[PurchaseRequestDetails]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[PurchaseRequestDetails]
GO
/****** Object:  Table [dbo].[PurchaseRequest]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[PurchaseRequest]
GO
/****** Object:  Table [dbo].[PurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[PurchaseHeader]
GO
/****** Object:  Table [dbo].[PurchaseDetail]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[PurchaseDetail]
GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ProductType]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Product]
GO
/****** Object:  Table [dbo].[PharmacyXModule]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[PharmacyXModule]
GO
/****** Object:  Table [dbo].[Pharmacy]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Pharmacy]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Person]
GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Manufacturer]
GO
/****** Object:  Table [dbo].[DrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[DrugUnit]
GO
/****** Object:  Table [dbo].[DrugType]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[DrugType]
GO
/****** Object:  Table [dbo].[DrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[DrugGeneric]
GO
/****** Object:  Table [dbo].[DrugContent]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[DrugContent]
GO
/****** Object:  Table [dbo].[DrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[DrugCategory]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Department]
GO
/****** Object:  Table [dbo].[CreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[CreditAuth]
GO
/****** Object:  Table [dbo].[Bank]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[Bank]
GO
/****** Object:  Table [dbo].[ApplicationUser]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ApplicationUser]
GO
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ApplicationRole]
GO
/****** Object:  Table [dbo].[ApplicationModule]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ApplicationModule]
GO
/****** Object:  Table [dbo].[ApplicationMenu]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ApplicationMenu]
GO
/****** Object:  Table [dbo].[ApplicationFeature]    Script Date: 31-08-2015 19:27:05 ******/
DROP TABLE [dbo].[ApplicationFeature]
GO
/****** Object:  StoredProcedure [dbo].[VerifyUserCredentials]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[VerifyUserCredentials]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateTax]
GO
/****** Object:  StoredProcedure [dbo].[UpdateSupplier]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateSupplier]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateRack]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdatePurchaseHeader]
GO
/****** Object:  StoredProcedure [dbo].[UpdateProduct]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateProduct]
GO
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDrugType]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDrugGeneric]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateCreditAuth]
GO
/****** Object:  StoredProcedure [dbo].[UpdateBank]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[UpdateBank]
GO
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[spUDSRGenerateRPSRistaData]
GO
/****** Object:  StoredProcedure [dbo].[SavePurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[SavePurchaseHeader]
GO
/****** Object:  StoredProcedure [dbo].[RetriveManufact]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[RetriveManufact]
GO
/****** Object:  StoredProcedure [dbo].[RetriveDrugtype]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[RetriveDrugtype]
GO
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetUserLogonDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetTaxs]
GO
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetTax]
GO
/****** Object:  StoredProcedure [dbo].[GetSuppliers]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetSuppliers]
GO
/****** Object:  StoredProcedure [dbo].[GetSupplier]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetSupplier]
GO
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetRacks]
GO
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetRack]
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseList]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetPurchaseList]
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseDetails]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetPurchaseDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetProducts]
GO
/****** Object:  StoredProcedure [dbo].[GetProductMaster]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetProductMaster]
GO
/****** Object:  StoredProcedure [dbo].[GetProduct]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetProduct]
GO
/****** Object:  StoredProcedure [dbo].[GetNextGRNForPharmacy]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetNextGRNForPharmacy]
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetManufacturers]
GO
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugUnits]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugTypes]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugType]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugGenerics]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugGenerics]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugGeneric]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugContents]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDrugCategories]
GO
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDepartments]
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetDepartment]
GO
/****** Object:  StoredProcedure [dbo].[GetCreditAuths]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetCreditAuths]
GO
/****** Object:  StoredProcedure [dbo].[GetCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetCreditAuth]
GO
/****** Object:  StoredProcedure [dbo].[GetBanks]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetBanks]
GO
/****** Object:  StoredProcedure [dbo].[GetBank]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetBank]
GO
/****** Object:  StoredProcedure [dbo].[GetAllActiveMenuItems]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[GetAllActiveMenuItems]
GO
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteTax]
GO
/****** Object:  StoredProcedure [dbo].[DeleteSupplier]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteSupplier]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteRack]
GO
/****** Object:  StoredProcedure [dbo].[DeletePurchaseItems]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeletePurchaseItems]
GO
/****** Object:  StoredProcedure [dbo].[DeletePurchase]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeletePurchase]
GO
/****** Object:  StoredProcedure [dbo].[DeleteProduct]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteProduct]
GO
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDrugType]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDrugGeneric]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteDepartment]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteCreditAuth]
GO
/****** Object:  StoredProcedure [dbo].[DeleteBank]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[DeleteBank]
GO
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddTax]
GO
/****** Object:  StoredProcedure [dbo].[AddSupplier]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddSupplier]
GO
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddRack]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddPurchaseItem]
GO
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddPurchaseHeader]
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddProduct]
GO
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddManufacturer]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDrugUnit]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDrugType]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDrugGeneric]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDrugContent]
GO
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDrugCategory]
GO
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddDepartment]
GO
/****** Object:  StoredProcedure [dbo].[AddCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddCreditAuth]
GO
/****** Object:  StoredProcedure [dbo].[AddBank]    Script Date: 31-08-2015 19:27:05 ******/
DROP PROCEDURE [dbo].[AddBank]
GO
USE [master]
GO
/****** Object:  Database [SpiderPharmacy]    Script Date: 31-08-2015 19:27:05 ******/
DROP DATABASE [SpiderPharmacy]
GO
/****** Object:  Database [SpiderPharmacy]    Script Date: 31-08-2015 19:27:05 ******/
CREATE DATABASE [SpiderPharmacy] ON  PRIMARY 
( NAME = N'MIS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQL2012\MSSQL\DATA\SpiderPharmacy.mdf' , SIZE = 4352KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MIS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQL2012\MSSQL\DATA\SpiderPharmacy_log.ldf' , SIZE = 7040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SpiderPharmacy] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SpiderPharmacy].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SpiderPharmacy] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET ARITHABORT OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SpiderPharmacy] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SpiderPharmacy] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SpiderPharmacy] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SpiderPharmacy] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SpiderPharmacy] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SpiderPharmacy] SET RECOVERY FULL 
GO
ALTER DATABASE [SpiderPharmacy] SET  MULTI_USER 
GO
ALTER DATABASE [SpiderPharmacy] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SpiderPharmacy] SET DB_CHAINING OFF 
GO
USE [SpiderPharmacy]
GO
/****** Object:  StoredProcedure [dbo].[AddBank]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDepartment]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddPurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddPurchaseItem]    Script Date: 31-08-2015 19:27:05 ******/
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
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[AddRack]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddSupplier]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[AddTax]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteBank]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDepartment]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteProduct]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeletePurchase]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeletePurchaseItems]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteRack]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteSupplier]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteTax]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetAllActiveMenuItems]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetBank]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetBanks]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCreditAuths]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDepartments]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugCategories]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugContents]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugGenerics]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugTypes]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDrugUnits]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetManufacturers]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetNextGRNForPharmacy]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetProduct]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetProductMaster]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 31-08-2015 19:27:05 ******/
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

SELECT
    row_number() OVER (ORDER BY prd.Name) AS Slno,
    prd.Id,
    prd.Classification,
	prd.Name AS DrugName,
    type.Name AS Type,
    cat.Name AS	Category,
    cont.Name AS MainCategory,
    gen.Name AS Generic,
    mfg.Name AS Manufacture,
    unit.Name AS Unit,
	prd.MinStock,
	prd.MaxStock,
	prd.ExpiryNotifyinDays,
	prd.ExpiryDays,
	prd.SuppTakenBeforExpiryDays,
	prd.TakenBeforeDays,
	prd.SuppTakenAfterExpiryDays,
	prd.TakenAfterDays,
    prd.IsActive      
FROM Product prd
INNER JOIN Drugtype type ON prd.typeId=type.Id
INNER JOIN DrugCategory cat ON cat.Id =prd.CategoryId	
INNER JOIN Drugcontent cont ON cont.Id =prd.MainCategoryId
INNER JOIN DrugGeneric gen ON gen.Id =prd.GenericId
INNER JOIN manufacturer mfg ON mfg.Id=prd.ManfId
INNER JOIN DrugUnit unit ON unit.Id=prd.UnitId

END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetPurchaseDetails]    Script Date: 31-08-2015 19:27:05 ******/
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
     
   FROM  
   PurchaseDetail PD  
   INNER JOIN Product P ON P.Id=PD.ProductId    
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
/****** Object:  StoredProcedure [dbo].[GetPurchaseList]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRack]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRacks]    Script Date: 31-08-2015 19:27:05 ******/
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

SELECT row_number() OVER (ORDER BY Id) AS Slno,Id,Name,[Description] As [Desc], IsActive FROM Rack  
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorProc NVARCHAR(126), @ErrorLineNo INT;

	SELECT @ErrorLineNo = ERROR_LINE(), @ErrorMessage = ERROR_MESSAGE(), @ErrorProc = ERROR_PROCEDURE();

	RAISERROR ( 'Error %s occurred in %s. Line  %d', 16, 1, @ErrorMessage, @ErrorProc, @ErrorLineNo )
	
	WITH SETERROR;
	
END CATCH
	                   
END
GO
/****** Object:  StoredProcedure [dbo].[GetSupplier]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetSuppliers]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTax]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTaxs]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserLogonDetails]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[RetriveDrugtype]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[RetriveManufact]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[SavePurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[spUDSRGenerateRPSRistaData]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateBank]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateCreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugContent]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateManufacturer]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateProduct]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdatePurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateRack]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateSupplier]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  StoredProcedure [dbo].[VerifyUserCredentials]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ApplicationFeature]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ApplicationMenu]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ApplicationModule]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ApplicationUser]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Bank]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[CreditAuth]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Department]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[DrugCategory]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[DrugContent]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[DrugGeneric]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[DrugType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[DrugUnit]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Person]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Pharmacy]    Script Date: 31-08-2015 19:27:05 ******/
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
 CONSTRAINT [PK__Pharmacy__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PharmacyXModule]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Product]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[ProductType]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[PurchaseDetail]    Script Date: 31-08-2015 19:27:05 ******/
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
 CONSTRAINT [PK_PurchaseDetail_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseHeader]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[PurchaseRequest]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[PurchaseRequestDetails]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Rack]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[RoleXFeature]    Script Date: 31-08-2015 19:27:05 ******/
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
/****** Object:  Table [dbo].[Supplier]    Script Date: 31-08-2015 19:27:05 ******/
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
 CONSTRAINT [PK__Supplier__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 31-08-2015 19:27:05 ******/
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
INSERT [dbo].[ApplicationFeature] ([Id], [ModuleId], [Key], [Name], [Description], [IsActive], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [IsDeleted], [ParentId], [MenuId]) VALUES (8, 800, N'SiteSettings', N'Settings', NULL, 1, 1, CAST(0xA47A0523 AS SmallDateTime), NULL, NULL, 0, NULL, 8)
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
SET IDENTITY_INSERT [dbo].[ApplicationUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Bank] ON 

GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'SBI tamilnadu', N'State Bank Of India', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'indian bank', N'indian', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'aas', N'asdfa', 1)
GO
INSERT [dbo].[Bank] ([Id], [Name], [Description], [IsActive]) VALUES (5, N'ggjh', N'jhgjh', 1)
GO
SET IDENTITY_INSERT [dbo].[Bank] OFF
GO
SET IDENTITY_INSERT [dbo].[CreditAuth] ON 

GO
INSERT [dbo].[CreditAuth] ([Id], [AuthName], [DepName], [DesigName], [FindBy], [IsActive]) VALUES (1, N'admin', N'admin', N'creator', N'abc', 1)
GO
SET IDENTITY_INSERT [dbo].[CreditAuth] OFF
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

GO
INSERT [dbo].[Department] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Lab', N'Laboratory', 1)
GO
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugCategory] ON 

GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Test', N'test', 1)
GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'ffff', N'ffff', 1)
GO
INSERT [dbo].[DrugCategory] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'Maggi', N'Indai', 1)
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
INSERT [dbo].[DrugType] ([Id], [Name], [Description], [IsActive]) VALUES (4, N'dariams', N'operation', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugType] OFF
GO
SET IDENTITY_INSERT [dbo].[DrugUnit] ON 

GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'MLMG', N'ML', 1)
GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'sdfgdfg', N'sd', 0)
GO
INSERT [dbo].[DrugUnit] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'sad', N'sdasa', 1)
GO
SET IDENTITY_INSERT [dbo].[DrugUnit] OFF
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] ON 

GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Abc', N'abc pt ltd', 1)
GO
INSERT [dbo].[Manufacturer] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'sxs', N'ffff', 1)
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

GO
INSERT [dbo].[Person] ([PersonId], [PharmacyId], [FirstName], [LastName], [Gender], [DOB], [MobileNumber], [EmailId], [AddressLine], [City], [State], [ZipCode], [Country], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [PersonImageUrl]) VALUES (1, 1, N'Daria', N'Admin', N'Male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
INSERT [dbo].[Pharmacy] ([Id], [ParentId], [Name], [CompanyName], [ContactPerson], [TINRegNo], [DrugLicenceNo], [EmailId], [Mobile], [Telephone1], [Telephone2], [Fax], [Website], [AddressLine1], [AddressLine2], [Zipcode], [City], [Country], [LogoImage], [IsDeleted], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime], [GRNIDValue], [GRNPrefix]) VALUES (1, NULL, N'Daria', N'Daria', N'Uniza', NULL, NULL, N'dariasys@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'India', NULL, NULL, NULL, NULL, NULL, NULL, 24, N'GRN')
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] ON 

GO
INSERT [dbo].[PharmacyXModule] ([Id], [PharmacyId], [ModuleId], [IsDeleted]) VALUES (1, 1, 800, 0)
GO
SET IDENTITY_INSERT [dbo].[PharmacyXModule] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (1, NULL, N'asda', 1, 1, 1, 13, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1)
GO
INSERT [dbo].[Product] ([Id], [Classification], [Name], [TypeId], [CategoryId], [MainCategoryId], [GenericId], [ManfId], [UnitId], [MinStock], [MaxStock], [ExpiryNotifyinDays], [ExpiryDays], [SuppTakenBeforExpiryDays], [TakenBeforeDays], [SuppTakenAfterExpiryDays], [TakenAfterDays], [IsActive]) VALUES (2, NULL, N'Calpal', 1, 1, 1, 1013, 1, 2, 21, 500, 0, 0, 0, 0, 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseDetail] ON 

GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, 1, 20013, 1, N'muju', 25, 2, 1, 1, N'11/2012', 50, 1350, CAST(0.000 AS Decimal(18, 3)), CAST(10.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), CAST(13.750 AS Decimal(18, 3)), CAST(20.625 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(1.650 AS Decimal(18, 3)), CAST(1.000 AS Decimal(18, 3)), CAST(0.150 AS Decimal(18, 3)), CAST(0.011 AS Decimal(18, 3)), CAST(0.007 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA500051F AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, 1, 20015, 2, N'billa2', 100, 10, 1, 1, N'10/2015', 50, 5500, CAST(0.000 AS Decimal(18, 3)), CAST(21.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), CAST(115.500 AS Decimal(18, 3)), CAST(132.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(13.200 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.004 AS Decimal(18, 3)), CAST(0.004 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA5000544 AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, 1, 20015, 1, N'dangmari', 50, 25, 1, 3, N'10/2018', 22, 1650, CAST(0.000 AS Decimal(18, 3)), CAST(2.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), CAST(30.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(15.000 AS Decimal(18, 3)), CAST(5.000 AS Decimal(18, 3)), CAST(0.750 AS Decimal(18, 3)), CAST(0.009 AS Decimal(18, 3)), CAST(0.001 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA5000544 AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10024, 1, 30016, 2, N'25huhu', 25, 10, 1, 2, NULL, 25, 875, CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), CAST(206.250 AS Decimal(18, 3)), CAST(151.250 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(60.500 AS Decimal(18, 3)), CAST(127.000 AS Decimal(18, 3)), CAST(139.700 AS Decimal(18, 3)), CAST(0.126 AS Decimal(18, 3)), CAST(0.171 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA5040490 AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10025, 1, 30014, 2, N'2550', 100, 25, 1, 1, NULL, 10, 1250, CAST(0.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), CAST(687.500 AS Decimal(18, 3)), CAST(660.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(165.000 AS Decimal(18, 3)), CAST(2.000 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)), CAST(0.096 AS Decimal(18, 3)), CAST(0.100 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA5040509 AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10026, 1, 30015, 2, N'2550', 100, 25, 1, 1, NULL, 10, 1250, CAST(0.000 AS Decimal(18, 3)), CAST(125.000 AS Decimal(18, 3)), CAST(5.500 AS Decimal(18, 3)), CAST(687.500 AS Decimal(18, 3)), CAST(660.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(165.000 AS Decimal(18, 3)), CAST(2.000 AS Decimal(18, 3)), CAST(2.400 AS Decimal(18, 3)), CAST(0.096 AS Decimal(18, 3)), CAST(0.100 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA504050A AS SmallDateTime), NULL, NULL)
GO
INSERT [dbo].[PurchaseDetail] ([Id], [PharmacyId], [PHeaderId], [ProductId], [BatchNo], [Qty], [FreeQty], [MfgId], [UnitId], [ExpiryDate], [Packing], [AssortedQty], [CostPrice], [MRP], [VAT], [MRPVATAmount], [COSTVATAmount], [AbatedMRP], [TaxMode], [TaxType], [DiscApplicable], [VATOnDiscount], [VATOnFreeQty], [DiscOnFreeQty], [FreeQtyVATAmount], [DiscountPercentage], [DiscountAmount], [AssortedCostPrice], [AssortedMRPPrice], [AbatedCost], [RackId], [Barcode], [AddedBy], [AddedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10027, 1, 30015, 1, N'222', 110, 10, 1, 3, NULL, 10, 1200, CAST(0.000 AS Decimal(18, 3)), CAST(15.000 AS Decimal(18, 3)), CAST(4.000 AS Decimal(18, 3)), CAST(66.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), N'COST', N'EXCL', 0, 0, 0, 0, CAST(0.000 AS Decimal(18, 3)), CAST(10.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(0.013 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), 1, NULL, 1, CAST(0xA504050A AS SmallDateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[PurchaseDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[PurchaseHeader] ON 

GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (10006, 1, N'GRN11', CAST(0xA4FA0000 AS SmallDateTime), 0, 3, N'4848484', CAST(0xA4F20000 AS SmallDateTime), 34, CAST(0xA4EA0000 AS SmallDateTime), CAST(2.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(151515.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(484848.000 AS Decimal(18, 3)), CAST(25152.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA4FD04C2 AS SmallDateTime), N'misadmin', 1, CAST(0xA5040508 AS SmallDateTime), 6)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (10008, 1, N'GRN12', CAST(0xA4FA0000 AS SmallDateTime), 0, 1, N'4848484', CAST(0xA4F20000 AS SmallDateTime), 34, CAST(0xA4EA0000 AS SmallDateTime), CAST(2.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(151515.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(484848.000 AS Decimal(18, 3)), CAST(25152.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA4FD04CE AS SmallDateTime), N'misadmin', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (20013, 1, N'GRN14', CAST(0xA4F20000 AS SmallDateTime), 0, 3, NULL, CAST(0xA4EB0000 AS SmallDateTime), 12, CAST(0xA4F10000 AS SmallDateTime), CAST(0.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(11.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(152.000 AS Decimal(18, 3)), CAST(10.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA500051F AS SmallDateTime), N'1', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (20015, 1, N'GRN15', CAST(0xA4F30000 AS SmallDateTime), 0, 2, NULL, CAST(0xA4F20000 AS SmallDateTime), 25, CAST(0xA4EA0000 AS SmallDateTime), CAST(2.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(11.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(150.000 AS Decimal(18, 3)), CAST(11.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5000544 AS SmallDateTime), N'1', NULL, NULL, NULL)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (30014, 1, N'GRN20', CAST(0xA4FC0000 AS SmallDateTime), 0, 3, N'kill0552', CAST(0xA4EC0000 AS SmallDateTime), 25, CAST(0xA4EA0000 AS SmallDateTime), CAST(10.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(11100.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(100.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5040442 AS SmallDateTime), N'1', 1, CAST(0xA5040509 AS SmallDateTime), 6)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (30015, 1, N'GRN21', CAST(0xA4FC0000 AS SmallDateTime), 0, 1, N'kill05523', CAST(0xA4EC0000 AS SmallDateTime), 25, CAST(0xA4EA0000 AS SmallDateTime), CAST(10.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(11100.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(1000.000 AS Decimal(18, 3)), CAST(120.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5040443 AS SmallDateTime), N'1', 1, CAST(0xA504050A AS SmallDateTime), 6)
GO
INSERT [dbo].[PurchaseHeader] ([Id], [PharmacyId], [GrnNo], [GrnDate], [POrderNo], [SupplierId], [SupplierInvNo], [SupplierInvDate], [CreditPeriod], [CreditDate], [DiscountPercent], [DiscountAmount], [TotalAmount], [TotalVAT], [NetAmount], [RoundOff], [PaidStatus], [PaidAmount], [Status], [Comment], [AddedBy], [AddedDateTime], [AddedUserName], [UpdatedBy], [UpdatedDateTime], [SavedUserId]) VALUES (30016, 1, N'GRN22', CAST(0xA4F50000 AS SmallDateTime), 0, 3, N'sdsasa', CAST(0xA4ED0000 AS SmallDateTime), 2, CAST(0xA4F20000 AS SmallDateTime), CAST(3.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(12120.000 AS Decimal(18, 3)), CAST(0.000 AS Decimal(18, 3)), CAST(20050.000 AS Decimal(18, 3)), CAST(110.000 AS Decimal(18, 3)), 0, CAST(0.000 AS Decimal(18, 3)), NULL, NULL, 1, CAST(0xA5040458 AS SmallDateTime), N'1', 1, CAST(0xA5040490 AS SmallDateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[PurchaseHeader] OFF
GO
SET IDENTITY_INSERT [dbo].[Rack] ON 

GO
INSERT [dbo].[Rack] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'mlmhg', N'mlmk', 1)
GO
SET IDENTITY_INSERT [dbo].[Rack] OFF
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
INSERT [dbo].[RoleXFeature] ([Id], [RoleIid], [FeatureId], [IsDeleted]) VALUES (2, 200, 8, 0)
GO
SET IDENTITY_INSERT [dbo].[RoleXFeature] OFF
GO
SET IDENTITY_INSERT [dbo].[Supplier] ON 

GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive]) VALUES (1, N'ams', 1, N'AMS Bangalore', N'AB1174', NULL, N'Karnataka', N'katnataka', N'India', N'Bala', N'ams@gmail.com', N'45789', N'ab12354', N'90350', N'9035010066', 1)
GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive]) VALUES (2, N'daria', 1, N'DARIA Bangalore', N'AB1174', NULL, N'Karnataka', N'katnataka', N'India', N'Bala', N'ams@gmail.com', N'45789', N'ab12354', N'90350', N'9035010066', 1)
GO
INSERT [dbo].[Supplier] ([Id], [Name], [TypeId], [Address], [TinNo], [DLNo], [City], [State], [Country], [ContactPerson], [Email], [Phone], [Fax], [Pincode], [MobileNo], [IsActive]) VALUES (3, N'ganesh', 1, N'tamilnadu', N'tamilnadu', NULL, N'dharmapuri', N'india', N'india', N'india', N'ams@gmail.com', N'944345485', N'5878', N'560034', N'9543014127', 0)
GO
SET IDENTITY_INSERT [dbo].[Supplier] OFF
GO
SET IDENTITY_INSERT [dbo].[Tax] ON 

GO
INSERT [dbo].[Tax] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'okd', N'dsad', 1)
GO
INSERT [dbo].[Tax] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'normal', N'nleee', 1)
GO
SET IDENTITY_INSERT [dbo].[Tax] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ApplicationFeature_Key_UNIQUE]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationFeature] ADD  CONSTRAINT [ApplicationFeature_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Applicat__3214EC062AD55B43]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationMenu] ADD UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ApplicationModule_Key_UNIQUE]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[ApplicationModule] ADD  CONSTRAINT [ApplicationModule_Key_UNIQUE] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Bank_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Bank] ADD  CONSTRAINT [UQ_Bank_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_CreditAuth_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[CreditAuth] ADD  CONSTRAINT [UQ_CreditAuth_Name] UNIQUE NONCLUSTERED 
(
	[AuthName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Department_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [UQ_Department_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugCategory_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugCategory] ADD  CONSTRAINT [UQ_DrugCategory_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugContent_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugContent] ADD  CONSTRAINT [UQ_DrugContent_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugGeneric_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugGeneric] ADD  CONSTRAINT [UQ_DrugGeneric_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugType_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugType] ADD  CONSTRAINT [UQ_DrugType_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_DrugUnit_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[DrugUnit] ADD  CONSTRAINT [UQ_DrugUnit_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Product_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [UQ_Product_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Rack_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Rack] ADD  CONSTRAINT [UQ_Rack_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Supplier_Name]    Script Date: 31-08-2015 19:27:05 ******/
ALTER TABLE [dbo].[Supplier] ADD  CONSTRAINT [UQ_Supplier_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_Tax_Name]    Script Date: 31-08-2015 19:27:05 ******/
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
USE [master]
GO
ALTER DATABASE [SpiderPharmacy] SET  READ_WRITE 
GO

    
    
ALTER PROCEDURE [dbo].[GetPurchaseDetails]          
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
   ,PD.UnitId    
   ,ExpiryDate    
   ,Packing    
   ,AssortedQty    
   ,CostPrice  as Cost  
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
       
   FROM    
   PurchaseDetail PD    
   INNER JOIN Product P ON P.Id=PD.ProductId      
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

	
/****** Object:  StoredProcedure [dbo].[SearchPurchase]    Script Date: 20-09-2015 23:25:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

          
CREATE PROCEDURE [dbo].[SearchPurchase]        
(        
  @PharmacyId INT        
 ,@pageSize INT = 10        
 ,@page INT        
 ,@OrderBy VARCHAR(50)='IdDesc'      
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
              
 IF (@OrderBy = 'IdDesc')      
  SET @sortOrderString = 'ORDER BY PH.Id DESC'      
 ELSE IF (@OrderBy = 'IdAsc')      
  SET @sortOrderString = 'ORDER BY PH.Id ASC'      
 ELSE IF (@OrderBy = 'GRNAsc')        
  SET @sortOrderString = 'ORDER BY PH.GrnNo ASC'        
 ELSE IF (@OrderBy = 'GRNDesc')        
  SET @sortOrderString = 'ORDER BY PH.GrnNo DESC'        
      
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
    ' AND ((PH.GrnDate = '''+ convert(varchar(10), @AddedToDate, 120) +''' ))'    
          
  IF (@AddedFromDate <> '')        
   SET @sqlClause = @sqlClause +        
    ' AND ((PH.AddedDateTime > '''+ convert(varchar(10), @AddedFromDate, 120) +''' ))'        
          
  IF (@AddedToDate <> '')        
   SET @sqlClause = @sqlClause +        
    ' AND ((PH.AddedDateTime < '''+ convert(varchar(10), @AddedToDate, 120) +''' ))'        
              
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


            
  
alter PROCEDURE [dbo].[SearchPurchase]          
  
(          
  
  @PharmacyId INT          
  
 ,@pageSize INT = 10          
  
 ,@page INT          
  
 ,@OrderBy VARCHAR(50)='IdDesc'        
  
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
  
                
  
 IF (@OrderBy = 'IdDesc')        
  
  SET @sortOrderString = 'ORDER BY PH.Id DESC'        
  
 ELSE IF (@OrderBy = 'IdAsc')        
  
  SET @sortOrderString = 'ORDER BY PH.Id ASC'        
  
 ELSE IF (@OrderBy = 'GRNAsc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnNo ASC'          
  
 ELSE IF (@OrderBy = 'GRNDesc')          
  
  SET @sortOrderString = 'ORDER BY PH.GrnNo DESC'          
  
        
  
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
  
    ' AND ((PH.AddedDateTime > '''+ convert(varchar(10), @AddedFromDate, 120) +''' ))'          
  
            
  
  IF (@AddedToDate <> '')          
  
   SET @sqlClause = @sqlClause +          
  
    ' AND ((PH.AddedDateTime < '''+ convert(varchar(10), @AddedToDate, 120) +''' ))'          
  
                
  
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

               
  
alter PROCEDURE [dbo].[SearchPurchase]          
  
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