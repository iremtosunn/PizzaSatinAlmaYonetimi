USE [master]
GO
/****** Nesnesi: Database [PizzaSatinAlmaDB] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE DATABASE [PizzaSatinAlmaDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PizzaSatinAlmaDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\PizzaSatinAlmaDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PizzaSatinAlmaDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\PizzaSatinAlmaDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PizzaSatinAlmaDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET RECOVERY FULL 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET  MULTI_USER 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PizzaSatinAlmaDB]
GO
/****** Nesnesi: Table [dbo].[Bildirimler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bildirimler](
	[BildirimID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[Baslik] [nvarchar](100) NOT NULL,
	[Mesaj] [nvarchar](500) NOT NULL,
	[OkunduMu] [bit] NOT NULL,
	[OlusturmaTarihi] [datetime] NOT NULL,
	[OkunmaTarihi] [datetime] NULL,
 CONSTRAINT [PK_Bildirimler] PRIMARY KEY CLUSTERED 
(
	[BildirimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[FirmaKullanicilari] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirmaKullanicilari](
	[FirmaKullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaID] [int] NOT NULL,
	[AdSoyad] [nvarchar](100) NOT NULL,
	[Telefon] [nvarchar](20) NULL,
	[Eposta] [nvarchar](100) NOT NULL,
	[Gorev] [nvarchar](100) NULL,
 CONSTRAINT [PK_FirmaKullanicilari] PRIMARY KEY CLUSTERED 
(
	[FirmaKullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Firmalar] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Firmalar](
	[FirmaID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaAdi] [nvarchar](150) NOT NULL,
	[VergiNo] [nvarchar](20) NOT NULL,
	[Telefon] [nvarchar](20) NULL,
	[Adres] [nvarchar](255) NULL,
	[Eposta] [nvarchar](254) NULL,
 CONSTRAINT [PK_Firmalar] PRIMARY KEY CLUSTERED 
(
	[FirmaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Kullanicilar] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanicilar](
	[KullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[RolID] [int] NOT NULL,
	[AdSoyad] [nvarchar](100) NOT NULL,
	[KullaniciAdi] [nvarchar](50) NOT NULL,
	[SifreHash] [varbinary](64) NOT NULL,
	[SifreSalt] [varbinary](32) NOT NULL,
	[Eposta] [nvarchar](254) NOT NULL,
	[Durum] [int] NOT NULL,
	[SonGirisTarihi] [datetime] NULL,
	[KayitTarihi] [datetime] NOT NULL,
 CONSTRAINT [PK_Kullanicilar] PRIMARY KEY CLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Roller] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roller](
	[RolID] [int] IDENTITY(1,1) NOT NULL,
	[RolAdi] [nvarchar](100) NOT NULL,
	[Aciklama] [nvarchar](500) NULL,
 CONSTRAINT [PK_Roller] PRIMARY KEY CLUSTERED 
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[RolYetkileri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolYetkileri](
	[RolID] [int] NOT NULL,
	[YetkiID] [int] NOT NULL,
 CONSTRAINT [PK_RolYetkileri] PRIMARY KEY CLUSTERED 
(
	[RolID] ASC,
	[YetkiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[SatinAlmaSiparisleri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SatinAlmaSiparisleri](
	[SiparisID] [int] IDENTITY(1,1) NOT NULL,
	[SiparisNo] [nvarchar](20) NOT NULL,
	[TalepID] [int] NOT NULL,
	[TeklifID] [int] NOT NULL,
	[OnaylayanKullaniciID] [int] NOT NULL,
	[SiparisTarihi] [datetime] NOT NULL,
	[SiparisDurumID] [int] NOT NULL,
 CONSTRAINT [PK_SatinAlmaSiparisleri] PRIMARY KEY CLUSTERED 
(
	[SiparisID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[SatinAlmaTalepleri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SatinAlmaTalepleri](
	[TalepID] [int] IDENTITY(1,1) NOT NULL,
	[TalepNo] [nvarchar](20) NOT NULL,
	[TalepEdenKullaniciID] [int] NOT NULL,
	[UrunAdi] [nvarchar](150) NOT NULL,
	[Miktar] [decimal](10, 2) NOT NULL,
	[Birim] [nvarchar](20) NOT NULL,
	[TalepTarihi] [datetime] NOT NULL,
	[TalepDurumID] [int] NOT NULL,
	[Aciklama] [nvarchar](255) NULL,
 CONSTRAINT [PK_SatinAlmaTalepleri] PRIMARY KEY CLUSTERED 
(
	[TalepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Tedarikciler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tedarikciler](
	[TedarikciID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaID] [int] NOT NULL,
	[TedarikciDurumID] [int] NOT NULL,
	[KayitTarihi] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_Tedarikciler] PRIMARY KEY CLUSTERED 
(
	[TedarikciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[TeklifKalemleri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeklifKalemleri](
	[TeklifKalemID] [int] IDENTITY(1,1) NOT NULL,
	[TeklifID] [int] NOT NULL,
	[KalemAdi] [nvarchar](150) NOT NULL,
	[KalemAciklamasi] [nvarchar](255) NULL,
	[Miktar] [decimal](18, 3) NOT NULL,
	[Birim] [nvarchar](20) NOT NULL,
	[BirimFiyat] [decimal](18, 2) NOT NULL,
	[ToplamTutar] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_TeklifKalemleri] PRIMARY KEY CLUSTERED 
(
	[TeklifKalemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Teklifler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teklifler](
	[TeklifID] [int] IDENTITY(1,1) NOT NULL,
	[TeklifNo] [nvarchar](20) NOT NULL,
	[TalepID] [int] NOT NULL,
	[TedarikciID] [int] NOT NULL,
	[TeklifGirenKullaniciID] [int] NOT NULL,
	[TeklifTutari] [decimal](10, 2) NOT NULL,
	[TeslimSuresiGun] [int] NOT NULL,
	[SKT] [date] NULL,
	[TeklifTarihi] [datetime] NOT NULL,
	[GecerlilikTarihi] [date] NULL,
	[ParaBirimi] [char](3) NOT NULL,
	[TeklifDurumID] [int] NOT NULL,
 CONSTRAINT [PK_Teklifler] PRIMARY KEY CLUSTERED 
(
	[TeklifID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[Yetkiler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Yetkiler](
	[YetkiID] [int] IDENTITY(1,1) NOT NULL,
	[YetkiKodu] [nvarchar](100) NOT NULL,
	[YetkiAdi] [nvarchar](150) NOT NULL,
	[Aciklama] [nvarchar](500) NULL,
 CONSTRAINT [PK_Yetkiler] PRIMARY KEY CLUSTERED 
(
	[YetkiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bildirimler] ON 
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (9, 1, N'Yeni Talep', N'ST0001 numaralı talep sisteme eklendi.', 1, CAST(N'2026-06-14T18:36:30.030' AS DateTime), CAST(N'2026-06-15T18:36:30.030' AS DateTime))
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (10, 2, N'Yeni Teklif', N'ST0002 talebi için yeni teklif sisteme eklendi.', 0, CAST(N'2026-06-17T18:36:30.030' AS DateTime), NULL)
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (11, 3, N'Teklif Seçildi', N'TK0004 numaralı teklif seçildi.', 1, CAST(N'2026-06-20T18:36:30.030' AS DateTime), CAST(N'2026-06-21T18:36:30.030' AS DateTime))
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (12, 9, N'Sipariş Oluşturuldu', N'SP0004 numaralı sipariş oluşturuldu.', 0, CAST(N'2026-06-21T18:36:30.030' AS DateTime), NULL)
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (13, 4, N'Talep Onaylandı', N'ST0003 numaralı talep onaylandı.', 1, CAST(N'2026-06-22T18:36:30.030' AS DateTime), CAST(N'2026-06-23T18:36:30.030' AS DateTime))
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (14, 5, N'Talep Reddedildi', N'ST0006 numaralı talep reddedildi.', 1, CAST(N'2026-06-24T18:36:30.030' AS DateTime), CAST(N'2026-06-24T18:36:30.030' AS DateTime))
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (15, 14, N'Yeni Talep', N'ST0007 numaralı talep oluşturuldu.', 0, CAST(N'2026-06-25T18:36:30.030' AS DateTime), NULL)
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (16, 15, N'Yeni Teklif', N'ST0009 talebi için teklif geldi.', 1, CAST(N'2026-06-27T18:36:30.030' AS DateTime), CAST(N'2026-06-28T18:36:30.030' AS DateTime))
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (17, 16, N'Teklif Seçildi', N'TK0022 numaralı teklif seçildi.', 0, CAST(N'2026-07-04T18:36:30.030' AS DateTime), NULL)
GO
INSERT [dbo].[Bildirimler] ([BildirimID], [KullaniciID], [Baslik], [Mesaj], [OkunduMu], [OlusturmaTarihi], [OkunmaTarihi]) VALUES (18, 17, N'Sipariş Tamamlandı', N'SP0002 numaralı sipariş tamamlandı.', 1, CAST(N'2026-07-09T18:36:30.030' AS DateTime), CAST(N'2026-07-10T18:36:30.030' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Bildirimler] OFF
GO
SET IDENTITY_INSERT [dbo].[FirmaKullanicilari] ON 
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (1, 1, N'Ahmet Yılmaz', N'0532 111 11 11', N'ahmet.yilmaz@egetarim.com', N'Satış Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (2, 2, N'Ayşe Demir', N'0532 222 22 22', N'ayse.demir@marmarabirlik.com.tr', N'Kurumsal Satış Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (3, 3, N'Mehmet Kaya', N'0532 333 33 33', N'mehmet.kaya@sutas.com.tr', N'Bölge Satış Sorumlusu')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (4, 4, N'Fatma Çelik', N'0532 444 44 44', N'fatma.celik@pinar.com.tr', N'Satış Müdürü')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (5, 5, N'Emre Aydın', N'0532 555 55 55', N'emre.aydin@metro-tr.com', N'Kurumsal Müşteri Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (6, 6, N'Burak Şahin', N'0532 666 66 66', N'burak.sahin@banvit.com', N'Satış Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (7, 7, N'Elif Arslan', N'0532 777 77 77', N'elif.arslan@tatgida.com', N'Müşteri Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (8, 8, N'Can Öztürk', N'0532 888 88 88', N'can.ozturk@kaleun.com', N'Satış Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (9, 9, N'Gökhan Özdemir', N'0533 101 10 10', N'gokhan.ozdemir@anadolusebze.com', N'Satış Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (10, 10, N'Derya Koç', N'0533 102 20 20', N'derya.koc@marmaramantar.com', N'Kurumsal Satış Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (11, 11, N'Onur Kılıç', N'0533 103 30 30', N'onur.kilic@akdenizbaharat.com', N'Bölge Satış Sorumlusu')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (12, 12, N'Pelin Yalçın', N'0533 104 40 40', N'pelin.yalcin@bereketsut.com', N'Satış Müdürü')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (13, 13, N'Hakan Aksoy', N'0533 105 50 50', N'hakan.aksoy@lezzetet.com', N'Müşteri Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (14, 14, N'Buse Karaca', N'0533 106 60 60', N'buse.karaca@guvenambalaj.com', N'Kurumsal Satış Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (15, 15, N'İsmail Şen', N'0533 107 70 70', N'ismail.sen@ankatemizlik.com', N'Satış Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (16, 16, N'Nazlı Acar', N'0533 108 80 80', N'nazli.acar@karadenizmisir.com', N'Satış Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (17, 17, N'Kerem Polat', N'0533 109 90 90', N'kerem.polat@ozegezeytinyagi.com', N'Bölge Satış Sorumlusu')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (18, 18, N'Esra Kaplan', N'0533 110 10 20', N'esra.kaplan@dogaicecek.com', N'Kurumsal Müşteri Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (19, 19, N'Volkan Aslan', N'0533 111 20 30', N'volkan.aslan@paketdunyasi.com', N'Satış Müdürü')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (20, 20, N'Ceren Çolak', N'0533 112 30 40', N'ceren.colak@yesilovatarim.com', N'Satış Temsilcisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (21, 1, N'Seda Öztürk', N'0534 201 11 11', N'seda.ozturk@egetarim.com', N'Satış Müdürü')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (22, 3, N'Barış Çetin', N'0534 203 33 33', N'baris.cetin@sutas.com.tr', N'Kurumsal Müşteri Yöneticisi')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (23, 5, N'İrem Yıldırım', N'0534 205 55 55', N'irem.yildirim@metro-tr.com', N'Satış Operasyon Uzmanı')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (24, 7, N'Tolga Eren', N'0534 207 77 77', N'tolga.eren@tatgida.com', N'Bölge Satış Müdürü')
GO
INSERT [dbo].[FirmaKullanicilari] ([FirmaKullaniciID], [FirmaID], [AdSoyad], [Telefon], [Eposta], [Gorev]) VALUES (25, 8, N'Melis Dinç', N'0534 208 88 88', N'melis.dinc@kaleun.com', N'Müşteri Temsilcisi')
GO
SET IDENTITY_INSERT [dbo].[FirmaKullanicilari] OFF
GO
SET IDENTITY_INSERT [dbo].[Firmalar] ON 
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (1, N'Ege Tarım A.Ş.', N'1234567890', N'0232 450 10 10', N'Kemalpaşa OSB / İzmir', N'info@egetarim.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (2, N'Marmarabirlik', N'2345678901', N'0224 270 75 00', N'Nilüfer / Bursa', N'info@marmarabirlik.com.tr')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (3, N'Sütaş Süt Ürünleri A.Ş.', N'3456789012', N'0224 280 50 00', N'Karacabey / Bursa', N'info@sutas.com.tr')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (4, N'Pınar Et', N'4567890123', N'0232 495 00 00', N'Pınarbaşı / İzmir', N'info@pinar.com.tr')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (5, N'Metro Türkiye', N'5678901234', N'0212 478 70 00', N'Bayrampaşa / İstanbul', N'info@metro-tr.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (6, N'Banvit', N'6789012345', N'0266 733 84 00', N'Bandırma / Balıkesir', N'info@banvit.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (7, N'Tat Gıda', N'7890123456', N'0212 456 78 90', N'Tuzla / İstanbul', N'info@tatgida.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (8, N'Kale Un', N'8901234567', N'0312 345 67 89', N'Sincan OSB / Ankara', N'info@kaleun.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (9, N'Anadolu Sebze Gıda A.Ş.', N'9012345678', N'0332 310 10 10', N'Selçuklu / Konya', N'info@anadolusebze.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (10, N'Marmara Mantar Ürünleri Ltd. Şti.', N'9123456780', N'0262 320 20 20', N'Gebze / Kocaeli', N'info@marmaramantar.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (11, N'Akdeniz Baharat Sanayi A.Ş.', N'9234567801', N'0324 330 30 30', N'Akdeniz / Mersin', N'info@akdenizbaharat.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (12, N'Bereket Süt ve Peynir Ltd. Şti.', N'9345678012', N'0266 340 40 40', N'Altıeylül / Balıkesir', N'info@bereketsut.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (13, N'Lezzet Et Ürünleri A.Ş.', N'9456780123', N'0342 350 50 50', N'Şehitkamil / Gaziantep', N'info@lezzetet.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (14, N'Güven Ambalaj Sanayi Ltd. Şti.', N'9567801234', N'0212 360 60 60', N'Esenyurt / İstanbul', N'info@guvenambalaj.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (15, N'Anka Temizlik Ürünleri A.Ş.', N'9678012345', N'0312 370 70 70', N'Yenimahalle / Ankara', N'info@ankatemizlik.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (16, N'Karadeniz Mısır Ürünleri Ltd. Şti.', N'9780123456', N'0462 380 80 80', N'Ortahisar / Trabzon', N'info@karadenizmisir.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (17, N'Öz Ege Zeytinyağı A.Ş.', N'9801234567', N'0236 390 90 90', N'Akhisar / Manisa', N'info@ozegezeytinyagi.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (18, N'Doğa İçecek Dağıtım Ltd. Şti.', N'8912345670', N'0224 400 10 20', N'Osmangazi / Bursa', N'info@dogaicecek.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (19, N'Paket Dünyası Ambalaj A.Ş.', N'8123456709', N'0216 410 20 30', N'Tuzla / İstanbul', N'info@paketdunyasi.com')
GO
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiNo], [Telefon], [Adres], [Eposta]) VALUES (20, N'Yeşilova Tarım Ürünleri Ltd. Şti.', N'8234567091', N'0242 420 30 40', N'Kepez / Antalya', N'info@yesilovatarim.com')
GO
SET IDENTITY_INSERT [dbo].[Firmalar] OFF
GO
SET IDENTITY_INSERT [dbo].[Kullanicilar] ON 
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (1, 1, N'Murat Yıldız', N'myildiz', 0x1234567890ABCDEF, 0xABCDEF1234567890, N'murat.yildiz@pizza.com', 1, CAST(N'2026-07-14T17:25:57.950' AS DateTime), CAST(N'2026-07-14T17:25:57.950' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (2, 2, N'Selin Demir', N'sdemir', 0x2234567890ABCDEF, 0xBBCDEF1234567890, N'selin.demir@pizza.com', 1, CAST(N'2026-07-14T17:25:57.950' AS DateTime), CAST(N'2026-07-14T17:25:57.950' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (3, 2, N'Emre Kaya', N'ekaya', 0x3234567890ABCDEF, 0xCBCDEF1234567890, N'emre.kaya@pizza.com', 1, CAST(N'2026-07-14T17:25:57.950' AS DateTime), CAST(N'2026-07-14T17:25:57.950' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (4, 3, N'Ali Çetin', N'acetin', 0x4234567890ABCDEF, 0xDBCDEF1234567890, N'ali.cetin@pizza.com', 1, CAST(N'2026-07-14T17:25:57.950' AS DateTime), CAST(N'2026-07-14T17:25:57.950' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (5, 3, N'Zeynep Arslan', N'zarslan', 0x5234567890ABCDEF, 0xEBCDEF1234567890, N'zeynep.arslan@pizza.com', 1, CAST(N'2026-07-14T17:25:57.950' AS DateTime), CAST(N'2026-07-14T17:25:57.950' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (6, 5, N'Ahmet Yılmaz', N'ayilmaz.tedarikci', 0x7343A3B3C3D3E3F3, 0x2343A3B3C3D3E3F3, N'ahmet.yilmaz@egetarim.com', 1, NULL, CAST(N'2026-07-14T17:33:30.667' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (7, 5, N'Mehmet Kaya', N'mkaya.tedarikci', 0x7444A4B4C4D4E4F4, 0x2444A4B4C4D4E4F4, N'mehmet.kaya@sutas.com.tr', 1, NULL, CAST(N'2026-07-14T17:33:30.667' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (8, 5, N'Emre Aydın', N'eaydin.tedarikci', 0x7545A5B5C5D5E5F5, 0x2545A5B5C5D5E5F5, N'emre.aydin@metro-tr.com', 0, NULL, CAST(N'2026-07-14T17:33:30.667' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (9, 1, N'Gizem Akın', N'gakin', 0x6131A1B1C1D1E1F1, 0x1131A1B1C1D1E1F1, N'gizem.akin@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (10, 2, N'Burcu Şimşek', N'bsimsek', 0x6232A2B2C2D2E2F2, 0x1232A2B2C2D2E2F2, N'burcu.simsek@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (11, 2, N'Caner Özkan', N'cozkan', 0x6333A3B3C3D3E3F3, 0x1333A3B3C3D3E3F3, N'caner.ozkan@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (12, 2, N'Deniz Korkmaz', N'dkorkmaz', 0x6434A4B4C4D4E4F4, 0x1434A4B4C4D4E4F4, N'deniz.korkmaz@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (13, 2, N'Ece Aydın', N'eceaydin', 0x6535A5B5C5D5E5F5, 0x1535A5B5C5D5E5F5, N'ece.aydin@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (14, 3, N'Ömer Kaya', N'okaya', 0x6636A6B6C6D6E6F6, 0x1636A6B6C6D6E6F6, N'omer.kaya@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (15, 3, N'Yasemin Güneş', N'ygunes', 0x6737A7B7C7D7E7F7, 0x1737A7B7C7D7E7F7, N'yasemin.gunes@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (16, 3, N'Kadir Toprak', N'ktoprak', 0x6838A8B8C8D8E8F8, 0x1838A8B8C8D8E8F8, N'kadir.toprak@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (17, 3, N'Elif Çınar', N'ecinar', 0x6939A9B9C9D9E9F9, 0x1939A9B9C9D9E9F9, N'elif.cinar@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (18, 3, N'Mert Yalçın', N'myalcin', 0x7040A0B0C0D0E0F0, 0x2040A0B0C0D0E0F0, N'mert.yalcin@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (19, 3, N'İpek Arı', N'iari', 0x7141A1B1C1D1E1F1, 0x2141A1B1C1D1E1F1, N'ipek.ari@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (20, 3, N'Serkan Tunç', N'stunc', 0x7242A2B2C2D2E2F2, 0x2242A2B2C2D2E2F2, N'serkan.tunc@pizza.com', 1, CAST(N'2026-07-14T17:39:45.057' AS DateTime), CAST(N'2026-07-14T17:39:45.057' AS DateTime))
GO
INSERT [dbo].[Kullanicilar] ([KullaniciID], [RolID], [AdSoyad], [KullaniciAdi], [SifreHash], [SifreSalt], [Eposta], [Durum], [SonGirisTarihi], [KayitTarihi]) VALUES (21, 3, N'Deneme Kullanıcısı', N'deneme', 0x01, 0x02, N'deneme@pizza.com', 1, NULL, CAST(N'2026-07-14T18:37:51.083' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Kullanicilar] OFF
GO
SET IDENTITY_INSERT [dbo].[Roller] ON 
GO
INSERT [dbo].[Roller] ([RolID], [RolAdi], [Aciklama]) VALUES (1, N'Satın Alma Yöneticisi', N'Satın alma süreçlerini yönetir ve teklifleri onaylar.')
GO
INSERT [dbo].[Roller] ([RolID], [RolAdi], [Aciklama]) VALUES (2, N'Satın Alma Uzmanı', N'Satın alma taleplerini inceler, teklifleri toplar ve sisteme girer.')
GO
INSERT [dbo].[Roller] ([RolID], [RolAdi], [Aciklama]) VALUES (3, N'Talep Oluşturan Kullanıcı', N'Satın alma talebi oluşturur.')
GO
INSERT [dbo].[Roller] ([RolID], [RolAdi], [Aciklama]) VALUES (5, N'Tedarikçi', N'Teklif veren tedarikçi firma temsilcisidir.')
GO
SET IDENTITY_INSERT [dbo].[Roller] OFF
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 1)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 2)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 3)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 4)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 5)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 6)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (1, 7)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (2, 2)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (2, 3)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (2, 4)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (3, 1)
GO
INSERT [dbo].[RolYetkileri] ([RolID], [YetkiID]) VALUES (3, 2)
GO
SET IDENTITY_INSERT [dbo].[SatinAlmaSiparisleri] ON 
GO
INSERT [dbo].[SatinAlmaSiparisleri] ([SiparisID], [SiparisNo], [TalepID], [TeklifID], [OnaylayanKullaniciID], [SiparisTarihi], [SiparisDurumID]) VALUES (1, N'SP0010', 3, 10, 1, CAST(N'2026-06-20T18:01:13.303' AS DateTime), 1)
GO
INSERT [dbo].[SatinAlmaSiparisleri] ([SiparisID], [SiparisNo], [TalepID], [TeklifID], [OnaylayanKullaniciID], [SiparisTarihi], [SiparisDurumID]) VALUES (2, N'SP0013', 12, 13, 1, CAST(N'2026-07-05T18:01:13.303' AS DateTime), 0)
GO
INSERT [dbo].[SatinAlmaSiparisleri] ([SiparisID], [SiparisNo], [TalepID], [TeklifID], [OnaylayanKullaniciID], [SiparisTarihi], [SiparisDurumID]) VALUES (3, N'SP0028', 8, 28, 1, CAST(N'2026-06-29T18:01:13.303' AS DateTime), 0)
GO
INSERT [dbo].[SatinAlmaSiparisleri] ([SiparisID], [SiparisNo], [TalepID], [TeklifID], [OnaylayanKullaniciID], [SiparisTarihi], [SiparisDurumID]) VALUES (4, N'SP0037', 18, 37, 1, CAST(N'2026-07-12T18:01:13.303' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[SatinAlmaSiparisleri] OFF
GO
SET IDENTITY_INSERT [dbo].[SatinAlmaTalepleri] ON 
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (1, N'ST0001', 4, N'Domates', CAST(500.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-14T17:45:47.113' AS DateTime), 0, N'Pizza sosu üretiminde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (2, N'ST0002', 5, N'Mozzarella Peyniri', CAST(250.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-15T17:45:47.113' AS DateTime), 1, N'Pizza üretiminde kullanılacak mozzarella peyniridir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (3, N'ST0003', 14, N'Pizza Unu', CAST(1000.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-17T17:45:47.113' AS DateTime), 2, N'Hamur üretiminde kullanılacak yüksek proteinli undur.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (4, N'ST0004', 15, N'Sucuk', CAST(180.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-19T17:45:47.113' AS DateTime), 1, N'Karışık pizza üretiminde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (5, N'ST0005', 16, N'Siyah Zeytin', CAST(160.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-21T17:45:47.113' AS DateTime), 0, N'Dilimlenmiş çekirdeksiz siyah zeytin talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (6, N'ST0006', 17, N'Kültür Mantarı', CAST(220.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-23T17:45:47.113' AS DateTime), 3, N'Taze kültür mantarı alım talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (7, N'ST0007', 18, N'Yeşil Biber', CAST(300.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-24T17:45:47.113' AS DateTime), 0, N'Sebzeli pizza üretiminde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (8, N'ST0008', 19, N'Pizza Kutusu', CAST(5000.00 AS Decimal(10, 2)), N'Adet', CAST(N'2026-06-26T17:45:47.113' AS DateTime), 2, N'Orta boy baskılı pizza kutusu talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (9, N'ST0009', 20, N'Domates Salçası', CAST(400.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-27T17:45:47.113' AS DateTime), 1, N'Pizza sosu üretimine uygun salça talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (10, N'ST0010', 4, N'Kaşar Peyniri', CAST(200.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-29T17:45:47.113' AS DateTime), 0, N'Pizza çeşitlerinde kullanılacak kaşar peyniridir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (11, N'ST0011', 5, N'Tavuk Göğsü', CAST(250.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-06-30T17:45:47.113' AS DateTime), 1, N'Tavuklu pizza üretiminde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (12, N'ST0012', 14, N'Mısır', CAST(300.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-02T17:45:47.113' AS DateTime), 2, N'Konserve tatlı mısır talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (13, N'ST0013', 15, N'Kekik', CAST(75.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-03T17:45:47.113' AS DateTime), 3, N'Pizza baharat karışımında kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (14, N'ST0014', 16, N'Ayçiçek Yağı', CAST(500.00 AS Decimal(10, 2)), N'Litre', CAST(N'2026-07-04T17:45:47.113' AS DateTime), 0, N'Üretim hattında kullanılacak ayçiçek yağıdır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (15, N'ST0015', 17, N'Peçete', CAST(10000.00 AS Decimal(10, 2)), N'Adet', CAST(N'2026-07-06T17:45:47.113' AS DateTime), 1, N'Paket servis siparişlerinde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (16, N'ST0016', 18, N'Kırmızı Biber', CAST(120.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-07T17:45:47.113' AS DateTime), 0, N'Pizza sosu ve baharat karışımı için kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (17, N'ST0017', 19, N'Jalapeno Biberi', CAST(100.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-08T17:45:47.113' AS DateTime), 1, N'Acılı pizza çeşitlerinde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (18, N'ST0018', 20, N'Karton Bardak', CAST(4000.00 AS Decimal(10, 2)), N'Adet', CAST(N'2026-07-09T17:45:47.113' AS DateTime), 2, N'İçecek servisi için karton bardak talebidir.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (19, N'ST0019', 4, N'Salam', CAST(170.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-11T17:45:47.113' AS DateTime), 3, N'Karışık pizza üretiminde kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (20, N'ST0020', 5, N'Sarımsak Tozu', CAST(60.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-13T17:45:47.113' AS DateTime), 0, N'Pizza sosu ve baharat karışımında kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (21, N'ST0021', 4, N'Rendelenmiş Mozzarella', CAST(300.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-15T17:31:10.977' AS DateTime), 0, N'Pizza üretim hattında kullanılacaktır.')
GO
INSERT [dbo].[SatinAlmaTalepleri] ([TalepID], [TalepNo], [TalepEdenKullaniciID], [UrunAdi], [Miktar], [Birim], [TalepTarihi], [TalepDurumID], [Aciklama]) VALUES (22, N'ST0022', 4, N'Domates Sosu', CAST(100.00 AS Decimal(10, 2)), N'Kg', CAST(N'2026-07-15T17:59:10.653' AS DateTime), 2, N'Pizza üretimi için')
GO
SET IDENTITY_INSERT [dbo].[SatinAlmaTalepleri] OFF
GO
SET IDENTITY_INSERT [dbo].[Tedarikciler] ON 
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (1, 1, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (2, 2, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (3, 3, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (4, 4, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (5, 5, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (6, 6, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (7, 7, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (8, 8, 1, CAST(N'2026-07-14T17:24:06.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (9, 9, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (10, 10, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (11, 11, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (12, 12, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (13, 13, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (14, 14, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (15, 15, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (16, 16, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (17, 17, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (18, 18, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (19, 19, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
INSERT [dbo].[Tedarikciler] ([TedarikciID], [FirmaID], [TedarikciDurumID], [KayitTarihi]) VALUES (20, 20, 1, CAST(N'2026-07-14T17:31:24.0000000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Tedarikciler] OFF
GO
SET IDENTITY_INSERT [dbo].[TeklifKalemleri] ON 
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (1, 1, N'Mozzarella Peyniri', N'Pizza üretiminde kullanılacak mozzarella peyniridir.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(475.00 AS Decimal(18, 2)), CAST(118750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (2, 2, N'Mozzarella Peyniri', N'Pizza üretiminde kullanılacak mozzarella peyniridir.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(458.00 AS Decimal(18, 2)), CAST(114500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (3, 3, N'Mozzarella Peyniri', N'Pizza üretiminde kullanılacak mozzarella peyniridir.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(484.00 AS Decimal(18, 2)), CAST(121000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (4, 10, N'Pizza Unu', N'Hamur üretiminde kullanılacak yüksek proteinli undur.', CAST(1000.000 AS Decimal(18, 3)), N'Kg', CAST(342.00 AS Decimal(18, 2)), CAST(342000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (5, 11, N'Pizza Unu', N'Hamur üretiminde kullanılacak yüksek proteinli undur.', CAST(1000.000 AS Decimal(18, 3)), N'Kg', CAST(355.00 AS Decimal(18, 2)), CAST(355000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (6, 12, N'Pizza Unu', N'Hamur üretiminde kullanılacak yüksek proteinli undur.', CAST(1000.000 AS Decimal(18, 3)), N'Kg', CAST(360.00 AS Decimal(18, 2)), CAST(360000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (7, 16, N'Sucuk', N'Karışık pizza üretiminde kullanılacaktır.', CAST(180.000 AS Decimal(18, 3)), N'Kg', CAST(980.00 AS Decimal(18, 2)), CAST(176400.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (8, 17, N'Sucuk', N'Karışık pizza üretiminde kullanılacaktır.', CAST(180.000 AS Decimal(18, 3)), N'Kg', CAST(940.00 AS Decimal(18, 2)), CAST(169200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (9, 18, N'Sucuk', N'Karışık pizza üretiminde kullanılacaktır.', CAST(180.000 AS Decimal(18, 3)), N'Kg', CAST(1010.00 AS Decimal(18, 2)), CAST(181800.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (10, 22, N'Kültür Mantarı', N'Taze kültür mantarı alım talebidir.', CAST(220.000 AS Decimal(18, 3)), N'Kg', CAST(285.00 AS Decimal(18, 2)), CAST(62700.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (11, 23, N'Kültür Mantarı', N'Taze kültür mantarı alım talebidir.', CAST(220.000 AS Decimal(18, 3)), N'Kg', CAST(310.00 AS Decimal(18, 2)), CAST(68200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (12, 24, N'Kültür Mantarı', N'Taze kültür mantarı alım talebidir.', CAST(220.000 AS Decimal(18, 3)), N'Kg', CAST(295.00 AS Decimal(18, 2)), CAST(64900.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (13, 28, N'Pizza Kutusu', N'Orta boy baskılı pizza kutusu talebidir.', CAST(5000.000 AS Decimal(18, 3)), N'Adet', CAST(8.50 AS Decimal(18, 2)), CAST(42500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (14, 29, N'Pizza Kutusu', N'Orta boy baskılı pizza kutusu talebidir.', CAST(5000.000 AS Decimal(18, 3)), N'Adet', CAST(8.95 AS Decimal(18, 2)), CAST(44750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (15, 30, N'Pizza Kutusu', N'Orta boy baskılı pizza kutusu talebidir.', CAST(5000.000 AS Decimal(18, 3)), N'Adet', CAST(9.30 AS Decimal(18, 2)), CAST(46500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (16, 34, N'Domates Salçası', N'Pizza sosu üretimine uygun salça talebidir.', CAST(400.000 AS Decimal(18, 3)), N'Kg', CAST(146.00 AS Decimal(18, 2)), CAST(58400.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (17, 35, N'Domates Salçası', N'Pizza sosu üretimine uygun salça talebidir.', CAST(400.000 AS Decimal(18, 3)), N'Kg', CAST(153.00 AS Decimal(18, 2)), CAST(61200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (18, 36, N'Domates Salçası', N'Pizza sosu üretimine uygun salça talebidir.', CAST(400.000 AS Decimal(18, 3)), N'Kg', CAST(149.00 AS Decimal(18, 2)), CAST(59600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (19, 4, N'Tavuk Göğsü', N'Tavuklu pizza üretiminde kullanılacaktır.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(197.00 AS Decimal(18, 2)), CAST(49250.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (20, 5, N'Tavuk Göğsü', N'Tavuklu pizza üretiminde kullanılacaktır.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(207.00 AS Decimal(18, 2)), CAST(51750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (21, 6, N'Tavuk Göğsü', N'Tavuklu pizza üretiminde kullanılacaktır.', CAST(250.000 AS Decimal(18, 3)), N'Kg', CAST(195.00 AS Decimal(18, 2)), CAST(48750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (22, 13, N'Mısır', N'Konserve tatlı mısır talebidir.', CAST(300.000 AS Decimal(18, 3)), N'Kg', CAST(150.00 AS Decimal(18, 2)), CAST(45000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (23, 14, N'Mısır', N'Konserve tatlı mısır talebidir.', CAST(300.000 AS Decimal(18, 3)), N'Kg', CAST(158.00 AS Decimal(18, 2)), CAST(47400.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (24, 15, N'Mısır', N'Konserve tatlı mısır talebidir.', CAST(300.000 AS Decimal(18, 3)), N'Kg', CAST(154.00 AS Decimal(18, 2)), CAST(46200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (25, 19, N'Kekik', N'Pizza baharat karışımında kullanılacaktır.', CAST(75.000 AS Decimal(18, 3)), N'Kg', CAST(450.00 AS Decimal(18, 2)), CAST(33750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (26, 20, N'Kekik', N'Pizza baharat karışımında kullanılacaktır.', CAST(75.000 AS Decimal(18, 3)), N'Kg', CAST(500.00 AS Decimal(18, 2)), CAST(37500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (27, 21, N'Kekik', N'Pizza baharat karışımında kullanılacaktır.', CAST(75.000 AS Decimal(18, 3)), N'Kg', CAST(480.00 AS Decimal(18, 2)), CAST(36000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (28, 25, N'Peçete', N'Paket servis siparişlerinde kullanılacaktır.', CAST(10000.000 AS Decimal(18, 3)), N'Adet', CAST(1.85 AS Decimal(18, 2)), CAST(18500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (29, 26, N'Peçete', N'Paket servis siparişlerinde kullanılacaktır.', CAST(10000.000 AS Decimal(18, 3)), N'Adet', CAST(1.79 AS Decimal(18, 2)), CAST(17900.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (30, 27, N'Peçete', N'Paket servis siparişlerinde kullanılacaktır.', CAST(10000.000 AS Decimal(18, 3)), N'Adet', CAST(1.98 AS Decimal(18, 2)), CAST(19800.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (31, 31, N'Jalapeno Biberi', N'Acılı pizza çeşitlerinde kullanılacaktır.', CAST(100.000 AS Decimal(18, 3)), N'Kg', CAST(485.00 AS Decimal(18, 2)), CAST(48500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (32, 32, N'Jalapeno Biberi', N'Acılı pizza çeşitlerinde kullanılacaktır.', CAST(100.000 AS Decimal(18, 3)), N'Kg', CAST(510.00 AS Decimal(18, 2)), CAST(51000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (33, 33, N'Jalapeno Biberi', N'Acılı pizza çeşitlerinde kullanılacaktır.', CAST(100.000 AS Decimal(18, 3)), N'Kg', CAST(525.00 AS Decimal(18, 2)), CAST(52500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (34, 37, N'Karton Bardak', N'İçecek servisi için karton bardak talebidir.', CAST(4000.000 AS Decimal(18, 3)), N'Adet', CAST(3.10 AS Decimal(18, 2)), CAST(12400.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (35, 38, N'Karton Bardak', N'İçecek servisi için karton bardak talebidir.', CAST(4000.000 AS Decimal(18, 3)), N'Adet', CAST(3.30 AS Decimal(18, 2)), CAST(13200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (36, 39, N'Karton Bardak', N'İçecek servisi için karton bardak talebidir.', CAST(4000.000 AS Decimal(18, 3)), N'Adet', CAST(3.50 AS Decimal(18, 2)), CAST(14000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (37, 7, N'Salam', N'Karışık pizza üretiminde kullanılacaktır.', CAST(170.000 AS Decimal(18, 3)), N'Kg', CAST(920.00 AS Decimal(18, 2)), CAST(156400.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (38, 8, N'Salam', N'Karışık pizza üretiminde kullanılacaktır.', CAST(170.000 AS Decimal(18, 3)), N'Kg', CAST(890.00 AS Decimal(18, 2)), CAST(151300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (39, 9, N'Salam', N'Karışık pizza üretiminde kullanılacaktır.', CAST(170.000 AS Decimal(18, 3)), N'Kg', CAST(960.00 AS Decimal(18, 2)), CAST(163200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (1002, 40, N'Domates', N'Pizza sosu üretiminde kullanılacaktır.', CAST(500.000 AS Decimal(18, 3)), N'Kg', CAST(175.00 AS Decimal(18, 2)), CAST(87500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (1003, 41, N'Domates', N'Pizza sosu üretiminde kullanılacaktır.', CAST(500.000 AS Decimal(18, 3)), N'Kg', CAST(175.00 AS Decimal(18, 2)), CAST(87500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (1004, 42, N'Domates Sosu', N'Pizza üretimi için', CAST(100.000 AS Decimal(18, 3)), N'Kg', CAST(150.00 AS Decimal(18, 2)), CAST(15000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[TeklifKalemleri] ([TeklifKalemID], [TeklifID], [KalemAdi], [KalemAciklamasi], [Miktar], [Birim], [BirimFiyat], [ToplamTutar]) VALUES (1005, 43, N'Domates Sosu', N'Pizza üretimi için', CAST(100.000 AS Decimal(18, 3)), N'Kg', CAST(150.00 AS Decimal(18, 2)), CAST(15000.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[TeklifKalemleri] OFF
GO
SET IDENTITY_INSERT [dbo].[Teklifler] ON 
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (1, N'TK0001', 2, 3, 2, CAST(118750.00 AS Decimal(10, 2)), 4, CAST(N'2026-10-30' AS Date), CAST(N'2026-06-17T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (2, N'TK0002', 2, 12, 2, CAST(114500.00 AS Decimal(10, 2)), 5, CAST(N'2026-11-15' AS Date), CAST(N'2026-06-17T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 1)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (3, N'TK0003', 2, 5, 2, CAST(121000.00 AS Decimal(10, 2)), 3, CAST(N'2026-10-20' AS Date), CAST(N'2026-06-18T18:01:13.303' AS DateTime), CAST(N'2026-07-23' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (4, N'TK0019', 11, 6, 2, CAST(49250.00 AS Decimal(10, 2)), 3, CAST(N'2026-08-05' AS Date), CAST(N'2026-07-02T18:01:13.303' AS DateTime), CAST(N'2026-07-20' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (5, N'TK0020', 11, 5, 2, CAST(51750.00 AS Decimal(10, 2)), 2, CAST(N'2026-08-01' AS Date), CAST(N'2026-07-02T18:01:13.303' AS DateTime), CAST(N'2026-07-20' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (6, N'TK0021', 11, 13, 2, CAST(48750.00 AS Decimal(10, 2)), 4, CAST(N'2026-08-08' AS Date), CAST(N'2026-07-03T18:01:13.303' AS DateTime), CAST(N'2026-07-19' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (7, N'TK0037', 19, 4, 2, CAST(156400.00 AS Decimal(10, 2)), 4, CAST(N'2026-11-20' AS Date), CAST(N'2026-07-12T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (8, N'TK0038', 19, 13, 2, CAST(151300.00 AS Decimal(10, 2)), 5, CAST(N'2026-11-25' AS Date), CAST(N'2026-07-12T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (9, N'TK0039', 19, 5, 2, CAST(163200.00 AS Decimal(10, 2)), 3, CAST(N'2026-11-15' AS Date), CAST(N'2026-07-13T18:01:13.303' AS DateTime), CAST(N'2026-07-20' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (10, N'TK0004', 3, 8, 3, CAST(342000.00 AS Decimal(10, 2)), 4, NULL, CAST(N'2026-06-19T18:01:13.303' AS DateTime), CAST(N'2026-07-26' AS Date), N'TRY', 1)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (11, N'TK0005', 3, 5, 3, CAST(355000.00 AS Decimal(10, 2)), 3, NULL, CAST(N'2026-06-19T18:01:13.303' AS DateTime), CAST(N'2026-07-26' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (12, N'TK0006', 3, 9, 3, CAST(360000.00 AS Decimal(10, 2)), 6, NULL, CAST(N'2026-06-20T18:01:13.303' AS DateTime), CAST(N'2026-07-25' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (13, N'TK0022', 12, 16, 3, CAST(45000.00 AS Decimal(10, 2)), 5, CAST(N'2027-04-01' AS Date), CAST(N'2026-07-04T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 1)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (14, N'TK0023', 12, 5, 3, CAST(47400.00 AS Decimal(10, 2)), 3, CAST(N'2027-03-20' AS Date), CAST(N'2026-07-04T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (15, N'TK0024', 12, 7, 3, CAST(46200.00 AS Decimal(10, 2)), 6, CAST(N'2027-04-15' AS Date), CAST(N'2026-07-05T18:01:13.303' AS DateTime), CAST(N'2026-07-23' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (16, N'TK0007', 4, 4, 10, CAST(176400.00 AS Decimal(10, 2)), 4, CAST(N'2026-12-10' AS Date), CAST(N'2026-06-21T18:01:13.303' AS DateTime), CAST(N'2026-07-22' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (17, N'TK0008', 4, 13, 10, CAST(169200.00 AS Decimal(10, 2)), 5, CAST(N'2026-12-15' AS Date), CAST(N'2026-06-21T18:01:13.303' AS DateTime), CAST(N'2026-07-22' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (18, N'TK0009', 4, 5, 10, CAST(181800.00 AS Decimal(10, 2)), 3, CAST(N'2026-11-30' AS Date), CAST(N'2026-06-22T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (19, N'TK0025', 13, 11, 10, CAST(33750.00 AS Decimal(10, 2)), 4, CAST(N'2027-01-15' AS Date), CAST(N'2026-07-05T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (20, N'TK0026', 13, 5, 10, CAST(37500.00 AS Decimal(10, 2)), 3, CAST(N'2026-12-20' AS Date), CAST(N'2026-07-05T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (21, N'TK0027', 13, 1, 10, CAST(36000.00 AS Decimal(10, 2)), 6, CAST(N'2027-01-05' AS Date), CAST(N'2026-07-06T18:01:13.303' AS DateTime), CAST(N'2026-07-20' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (22, N'TK0010', 6, 10, 11, CAST(62700.00 AS Decimal(10, 2)), 3, CAST(N'2026-07-25' AS Date), CAST(N'2026-06-25T18:01:13.303' AS DateTime), CAST(N'2026-07-19' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (23, N'TK0011', 6, 5, 11, CAST(68200.00 AS Decimal(10, 2)), 2, CAST(N'2026-07-22' AS Date), CAST(N'2026-06-25T18:01:13.303' AS DateTime), CAST(N'2026-07-19' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (24, N'TK0012', 6, 20, 11, CAST(64900.00 AS Decimal(10, 2)), 5, CAST(N'2026-07-28' AS Date), CAST(N'2026-06-26T18:01:13.303' AS DateTime), CAST(N'2026-07-18' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (25, N'TK0028', 15, 14, 11, CAST(18500.00 AS Decimal(10, 2)), 5, NULL, CAST(N'2026-07-08T18:01:13.303' AS DateTime), CAST(N'2026-07-22' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (26, N'TK0029', 15, 19, 11, CAST(17900.00 AS Decimal(10, 2)), 6, NULL, CAST(N'2026-07-08T18:01:13.303' AS DateTime), CAST(N'2026-07-22' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (27, N'TK0030', 15, 5, 11, CAST(19800.00 AS Decimal(10, 2)), 3, NULL, CAST(N'2026-07-09T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (28, N'TK0013', 8, 14, 12, CAST(42500.00 AS Decimal(10, 2)), 6, NULL, CAST(N'2026-06-28T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 1)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (29, N'TK0014', 8, 19, 12, CAST(44750.00 AS Decimal(10, 2)), 4, NULL, CAST(N'2026-06-28T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (30, N'TK0015', 8, 5, 12, CAST(46500.00 AS Decimal(10, 2)), 3, NULL, CAST(N'2026-06-29T18:01:13.303' AS DateTime), CAST(N'2026-07-23' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (31, N'TK0031', 17, 20, 12, CAST(48500.00 AS Decimal(10, 2)), 4, CAST(N'2026-09-10' AS Date), CAST(N'2026-07-10T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (32, N'TK0032', 17, 1, 12, CAST(51000.00 AS Decimal(10, 2)), 3, CAST(N'2026-09-05' AS Date), CAST(N'2026-07-10T18:01:13.303' AS DateTime), CAST(N'2026-07-21' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (33, N'TK0033', 17, 5, 12, CAST(52500.00 AS Decimal(10, 2)), 2, CAST(N'2026-08-30' AS Date), CAST(N'2026-07-11T18:01:13.303' AS DateTime), CAST(N'2026-07-20' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (34, N'TK0016', 9, 7, 13, CAST(58400.00 AS Decimal(10, 2)), 4, CAST(N'2027-03-15' AS Date), CAST(N'2026-06-29T18:01:13.303' AS DateTime), CAST(N'2026-07-26' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (35, N'TK0017', 9, 5, 13, CAST(61200.00 AS Decimal(10, 2)), 3, CAST(N'2027-02-28' AS Date), CAST(N'2026-06-29T18:01:13.303' AS DateTime), CAST(N'2026-07-26' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (36, N'TK0018', 9, 9, 13, CAST(59600.00 AS Decimal(10, 2)), 6, CAST(N'2027-03-30' AS Date), CAST(N'2026-06-30T18:01:13.303' AS DateTime), CAST(N'2026-07-25' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (37, N'TK0034', 18, 19, 13, CAST(12400.00 AS Decimal(10, 2)), 5, NULL, CAST(N'2026-07-11T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 1)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (38, N'TK0035', 18, 14, 13, CAST(13200.00 AS Decimal(10, 2)), 4, NULL, CAST(N'2026-07-11T18:01:13.303' AS DateTime), CAST(N'2026-07-24' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (39, N'TK0036', 18, 5, 13, CAST(14000.00 AS Decimal(10, 2)), 3, NULL, CAST(N'2026-07-12T18:01:13.303' AS DateTime), CAST(N'2026-07-23' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (40, N'TK0040', 1, 5, 2, CAST(87500.00 AS Decimal(10, 2)), 4, CAST(N'2026-12-31' AS Date), CAST(N'2026-07-15T16:40:57.203' AS DateTime), CAST(N'2026-08-15' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (41, N'TK0041', 1, 5, 2, CAST(87500.00 AS Decimal(10, 2)), 4, CAST(N'2026-12-31' AS Date), CAST(N'2026-07-15T16:59:33.943' AS DateTime), CAST(N'2026-08-15' AS Date), N'TRY', 0)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (42, N'TK0042', 22, 5, 2, CAST(15000.00 AS Decimal(10, 2)), 3, CAST(N'2026-12-31' AS Date), CAST(N'2026-07-15T18:02:30.763' AS DateTime), CAST(N'2026-08-30' AS Date), N'TRY', 2)
GO
INSERT [dbo].[Teklifler] ([TeklifID], [TeklifNo], [TalepID], [TedarikciID], [TeklifGirenKullaniciID], [TeklifTutari], [TeslimSuresiGun], [SKT], [TeklifTarihi], [GecerlilikTarihi], [ParaBirimi], [TeklifDurumID]) VALUES (43, N'TK0043', 22, 5, 2, CAST(15000.00 AS Decimal(10, 2)), 3, CAST(N'2026-12-31' AS Date), CAST(N'2026-07-15T18:10:27.550' AS DateTime), CAST(N'2026-08-30' AS Date), N'TRY', 1)
GO
SET IDENTITY_INSERT [dbo].[Teklifler] OFF
GO
SET IDENTITY_INSERT [dbo].[Yetkiler] ON 
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (1, N'TALEP_OLUSTUR', N'Talep Oluştur', N'Yeni satın alma talebi oluşturma yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (2, N'TALEP_GORUNTULE', N'Talep Görüntüle', N'Satın alma taleplerini görüntüleme yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (3, N'TEKLIF_GIR', N'Teklif Gir', N'Tedarikçilerden alınan teklifleri sisteme girme yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (4, N'TEKLIF_KARSILASTIR', N'Teklif Karşılaştır', N'Girilen teklifleri karşılaştırma yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (5, N'TEKLIF_SEC', N'Teklif Seç', N'Uygun teklifi seçme yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (6, N'SIPARIS_GORUNTULE', N'Sipariş Görüntüle', N'Satın alma siparişlerini görüntüleme yetkisidir.')
GO
INSERT [dbo].[Yetkiler] ([YetkiID], [YetkiKodu], [YetkiAdi], [Aciklama]) VALUES (7, N'RAPOR_GORUNTULE', N'Rapor Görüntüle', N'Satın alma raporlarını görüntüleme yetkisidir.')
GO
SET IDENTITY_INSERT [dbo].[Yetkiler] OFF
GO
/****** Nesnesi: Index [IX_Bildirimler_KullaniciID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Bildirimler_KullaniciID] ON [dbo].[Bildirimler]
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_FirmaKullanicilari_Eposta] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[FirmaKullanicilari] ADD  CONSTRAINT [UQ_FirmaKullanicilari_Eposta] UNIQUE NONCLUSTERED 
(
	[Eposta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Firmalar_FirmaAdi] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Firmalar] ADD  CONSTRAINT [UQ_Firmalar_FirmaAdi] UNIQUE NONCLUSTERED 
(
	[FirmaAdi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Firmalar_VergiNo] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Firmalar] ADD  CONSTRAINT [UQ_Firmalar_VergiNo] UNIQUE NONCLUSTERED 
(
	[VergiNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Kullanicilar_Eposta] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Kullanicilar] ADD  CONSTRAINT [UQ_Kullanicilar_Eposta] UNIQUE NONCLUSTERED 
(
	[Eposta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Kullanicilar_KullaniciAdi] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Kullanicilar] ADD  CONSTRAINT [UQ_Kullanicilar_KullaniciAdi] UNIQUE NONCLUSTERED 
(
	[KullaniciAdi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [IX_Kullanicilar_AdSoyad] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Kullanicilar_AdSoyad] ON [dbo].[Kullanicilar]
(
	[AdSoyad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_Kullanicilar_Durum] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Kullanicilar_Durum] ON [dbo].[Kullanicilar]
(
	[Durum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_Kullanicilar_RolID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Kullanicilar_RolID] ON [dbo].[Kullanicilar]
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Roller_RolAdi] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Roller] ADD  CONSTRAINT [UQ_Roller_RolAdi] UNIQUE NONCLUSTERED 
(
	[RolAdi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_SatinAlmaSiparisleri_SiparisNo] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[SatinAlmaSiparisleri] ADD  CONSTRAINT [UQ_SatinAlmaSiparisleri_SiparisNo] UNIQUE NONCLUSTERED 
(
	[SiparisNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [UQ_SatinAlmaSiparisleri_TeklifID] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[SatinAlmaSiparisleri] ADD  CONSTRAINT [UQ_SatinAlmaSiparisleri_TeklifID] UNIQUE NONCLUSTERED 
(
	[TeklifID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_SatinAlmaSiparisleri_Durum] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_SatinAlmaSiparisleri_Durum] ON [dbo].[SatinAlmaSiparisleri]
(
	[SiparisDurumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_SatinAlmaSiparisleri_OnaylayanKullaniciID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_SatinAlmaSiparisleri_OnaylayanKullaniciID] ON [dbo].[SatinAlmaSiparisleri]
(
	[OnaylayanKullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_SatinAlmaSiparisleri_TalepID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_SatinAlmaSiparisleri_TalepID] ON [dbo].[SatinAlmaSiparisleri]
(
	[TalepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_SatinAlmaTalepleri_TalepNo] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[SatinAlmaTalepleri] ADD  CONSTRAINT [UQ_SatinAlmaTalepleri_TalepNo] UNIQUE NONCLUSTERED 
(
	[TalepNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [UQ_Tedarikciler_FirmaID] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Tedarikciler] ADD  CONSTRAINT [UQ_Tedarikciler_FirmaID] UNIQUE NONCLUSTERED 
(
	[FirmaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_Tedarikciler_DurumID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Tedarikciler_DurumID] ON [dbo].[Tedarikciler]
(
	[TedarikciDurumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_Tedarikciler_FirmaID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_Tedarikciler_FirmaID] ON [dbo].[Tedarikciler]
(
	[FirmaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Nesnesi: Index [IX_TeklifKalemleri_TeklifID] Betik Tarihi: 17.07.2026 14:53:33 ******/
CREATE NONCLUSTERED INDEX [IX_TeklifKalemleri_TeklifID] ON [dbo].[TeklifKalemleri]
(
	[TeklifID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Teklifler_TeklifNo] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Teklifler] ADD  CONSTRAINT [UQ_Teklifler_TeklifNo] UNIQUE NONCLUSTERED 
(
	[TeklifNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ_Yetkiler_YetkiKodu] Betik Tarihi: 17.07.2026 14:53:33 ******/
ALTER TABLE [dbo].[Yetkiler] ADD  CONSTRAINT [UQ_Yetkiler_YetkiKodu] UNIQUE NONCLUSTERED 
(
	[YetkiKodu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bildirimler] ADD  CONSTRAINT [DF_Bildirimler_Okundu]  DEFAULT ((0)) FOR [OkunduMu]
GO
ALTER TABLE [dbo].[Bildirimler] ADD  CONSTRAINT [DF_Bildirimler_OlusturmaTarihi]  DEFAULT (getdate()) FOR [OlusturmaTarihi]
GO
ALTER TABLE [dbo].[Kullanicilar] ADD  CONSTRAINT [DF_Kullanicilar_Durum]  DEFAULT ((1)) FOR [Durum]
GO
ALTER TABLE [dbo].[Kullanicilar] ADD  CONSTRAINT [DF_Kullanicilar_KayitTarihi]  DEFAULT (getdate()) FOR [KayitTarihi]
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri] ADD  CONSTRAINT [DF_SatinAlmaSiparisleri_SiparisTarihi]  DEFAULT (getdate()) FOR [SiparisTarihi]
GO
ALTER TABLE [dbo].[SatinAlmaTalepleri] ADD  CONSTRAINT [DF_SatinAlmaTalepleri_TalepTarihi]  DEFAULT (getdate()) FOR [TalepTarihi]
GO
ALTER TABLE [dbo].[Tedarikciler] ADD  CONSTRAINT [DF_Tedarikciler_KayitTarihi]  DEFAULT (sysdatetime()) FOR [KayitTarihi]
GO
ALTER TABLE [dbo].[Teklifler] ADD  CONSTRAINT [DF_Teklifler_TeklifTarihi]  DEFAULT (getdate()) FOR [TeklifTarihi]
GO
ALTER TABLE [dbo].[Bildirimler]  WITH CHECK ADD  CONSTRAINT [FK_Bildirimler_Kullanicilar] FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[Bildirimler] CHECK CONSTRAINT [FK_Bildirimler_Kullanicilar]
GO
ALTER TABLE [dbo].[FirmaKullanicilari]  WITH CHECK ADD  CONSTRAINT [FK_FirmaKullanicilari_Firmalar] FOREIGN KEY([FirmaID])
REFERENCES [dbo].[Firmalar] ([FirmaID])
GO
ALTER TABLE [dbo].[FirmaKullanicilari] CHECK CONSTRAINT [FK_FirmaKullanicilari_Firmalar]
GO
ALTER TABLE [dbo].[Kullanicilar]  WITH CHECK ADD  CONSTRAINT [FK_Kullanicilar_Roller] FOREIGN KEY([RolID])
REFERENCES [dbo].[Roller] ([RolID])
GO
ALTER TABLE [dbo].[Kullanicilar] CHECK CONSTRAINT [FK_Kullanicilar_Roller]
GO
ALTER TABLE [dbo].[RolYetkileri]  WITH CHECK ADD  CONSTRAINT [FK_RolYetkileri_Roller] FOREIGN KEY([RolID])
REFERENCES [dbo].[Roller] ([RolID])
GO
ALTER TABLE [dbo].[RolYetkileri] CHECK CONSTRAINT [FK_RolYetkileri_Roller]
GO
ALTER TABLE [dbo].[RolYetkileri]  WITH CHECK ADD  CONSTRAINT [FK_RolYetkileri_Yetkiler] FOREIGN KEY([YetkiID])
REFERENCES [dbo].[Yetkiler] ([YetkiID])
GO
ALTER TABLE [dbo].[RolYetkileri] CHECK CONSTRAINT [FK_RolYetkileri_Yetkiler]
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri]  WITH CHECK ADD  CONSTRAINT [FK_SatinAlmaSiparisleri_Kullanicilar] FOREIGN KEY([OnaylayanKullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri] CHECK CONSTRAINT [FK_SatinAlmaSiparisleri_Kullanicilar]
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri]  WITH CHECK ADD  CONSTRAINT [FK_SatinAlmaSiparisleri_Talepler] FOREIGN KEY([TalepID])
REFERENCES [dbo].[SatinAlmaTalepleri] ([TalepID])
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri] CHECK CONSTRAINT [FK_SatinAlmaSiparisleri_Talepler]
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri]  WITH CHECK ADD  CONSTRAINT [FK_SatinAlmaSiparisleri_Teklifler] FOREIGN KEY([TeklifID])
REFERENCES [dbo].[Teklifler] ([TeklifID])
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri] CHECK CONSTRAINT [FK_SatinAlmaSiparisleri_Teklifler]
GO
ALTER TABLE [dbo].[SatinAlmaTalepleri]  WITH CHECK ADD  CONSTRAINT [FK_SatinAlmaTalepleri_Kullanicilar] FOREIGN KEY([TalepEdenKullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[SatinAlmaTalepleri] CHECK CONSTRAINT [FK_SatinAlmaTalepleri_Kullanicilar]
GO
ALTER TABLE [dbo].[Tedarikciler]  WITH CHECK ADD  CONSTRAINT [FK_Tedarikciler_Firmalar] FOREIGN KEY([FirmaID])
REFERENCES [dbo].[Firmalar] ([FirmaID])
GO
ALTER TABLE [dbo].[Tedarikciler] CHECK CONSTRAINT [FK_Tedarikciler_Firmalar]
GO
ALTER TABLE [dbo].[TeklifKalemleri]  WITH CHECK ADD  CONSTRAINT [FK_TeklifKalemleri_Teklifler] FOREIGN KEY([TeklifID])
REFERENCES [dbo].[Teklifler] ([TeklifID])
GO
ALTER TABLE [dbo].[TeklifKalemleri] CHECK CONSTRAINT [FK_TeklifKalemleri_Teklifler]
GO
ALTER TABLE [dbo].[Teklifler]  WITH CHECK ADD  CONSTRAINT [FK_Teklifler_Kullanicilar] FOREIGN KEY([TeklifGirenKullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[Teklifler] CHECK CONSTRAINT [FK_Teklifler_Kullanicilar]
GO
ALTER TABLE [dbo].[Teklifler]  WITH CHECK ADD  CONSTRAINT [FK_Teklifler_Talepler] FOREIGN KEY([TalepID])
REFERENCES [dbo].[SatinAlmaTalepleri] ([TalepID])
GO
ALTER TABLE [dbo].[Teklifler] CHECK CONSTRAINT [FK_Teklifler_Talepler]
GO
ALTER TABLE [dbo].[Teklifler]  WITH CHECK ADD  CONSTRAINT [FK_Teklifler_Tedarikciler] FOREIGN KEY([TedarikciID])
REFERENCES [dbo].[Tedarikciler] ([TedarikciID])
GO
ALTER TABLE [dbo].[Teklifler] CHECK CONSTRAINT [FK_Teklifler_Tedarikciler]
GO
ALTER TABLE [dbo].[Kullanicilar]  WITH CHECK ADD  CONSTRAINT [CK_Kullanicilar_Durum] CHECK  (([Durum]=(2) OR [Durum]=(1) OR [Durum]=(0)))
GO
ALTER TABLE [dbo].[Kullanicilar] CHECK CONSTRAINT [CK_Kullanicilar_Durum]
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri]  WITH CHECK ADD  CONSTRAINT [CK_SatinAlmaSiparisleri_Durum] CHECK  (([SiparisDurumID]=(2) OR [SiparisDurumID]=(1) OR [SiparisDurumID]=(0)))
GO
ALTER TABLE [dbo].[SatinAlmaSiparisleri] CHECK CONSTRAINT [CK_SatinAlmaSiparisleri_Durum]
GO
ALTER TABLE [dbo].[SatinAlmaTalepleri]  WITH CHECK ADD  CONSTRAINT [CK_SatinAlmaTalepleri_Durum] CHECK  (([TalepDurumID]=(3) OR [TalepDurumID]=(2) OR [TalepDurumID]=(1) OR [TalepDurumID]=(0)))
GO
ALTER TABLE [dbo].[SatinAlmaTalepleri] CHECK CONSTRAINT [CK_SatinAlmaTalepleri_Durum]
GO
ALTER TABLE [dbo].[Tedarikciler]  WITH CHECK ADD  CONSTRAINT [CK_Tedarikciler_Durum] CHECK  (([TedarikciDurumID]=(1) OR [TedarikciDurumID]=(0)))
GO
ALTER TABLE [dbo].[Tedarikciler] CHECK CONSTRAINT [CK_Tedarikciler_Durum]
GO
ALTER TABLE [dbo].[TeklifKalemleri]  WITH CHECK ADD  CONSTRAINT [CK_TeklifKalemleri_BirimFiyat] CHECK  (([BirimFiyat]>=(0)))
GO
ALTER TABLE [dbo].[TeklifKalemleri] CHECK CONSTRAINT [CK_TeklifKalemleri_BirimFiyat]
GO
ALTER TABLE [dbo].[TeklifKalemleri]  WITH CHECK ADD  CONSTRAINT [CK_TeklifKalemleri_Miktar] CHECK  (([Miktar]>(0)))
GO
ALTER TABLE [dbo].[TeklifKalemleri] CHECK CONSTRAINT [CK_TeklifKalemleri_Miktar]
GO
ALTER TABLE [dbo].[TeklifKalemleri]  WITH CHECK ADD  CONSTRAINT [CK_TeklifKalemleri_ToplamTutar] CHECK  (([ToplamTutar]>=(0)))
GO
ALTER TABLE [dbo].[TeklifKalemleri] CHECK CONSTRAINT [CK_TeklifKalemleri_ToplamTutar]
GO
ALTER TABLE [dbo].[Teklifler]  WITH CHECK ADD  CONSTRAINT [CK_Teklifler_Durum] CHECK  (([TeklifDurumID]=(2) OR [TeklifDurumID]=(1) OR [TeklifDurumID]=(0)))
GO
ALTER TABLE [dbo].[Teklifler] CHECK CONSTRAINT [CK_Teklifler_Durum]
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_BildirimiOkunduYap] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_BildirimiOkunduYap]
    @BildirimID INT,
    @KullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Bildirimler
    SET
        OkunduMu = 1,
        OkunmaTarihi = GETDATE()
    WHERE BildirimID = @BildirimID
      AND KullaniciID = @KullaniciID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardAylikTalepTeklifOzeti] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardAylikTalepTeklifOzeti]
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Aylar AS
    (
        SELECT 0 AS Sira,
               DATEFROMPARTS
               (
                   YEAR(GETDATE()),
                   MONTH(GETDATE()),
                   1
               ) AS AyBaslangici

        UNION ALL

        SELECT
            Sira + 1,
            DATEADD
            (
                MONTH,
                -1,
                AyBaslangici
            )
        FROM Aylar
        WHERE Sira < 5
    )
    SELECT
        A.AyBaslangici,
        DATENAME(MONTH, A.AyBaslangici) AS AyAdi,

        (
            SELECT COUNT(*)
            FROM dbo.SatinAlmaTalepleri SAT
            WHERE SAT.TalepTarihi >= A.AyBaslangici
              AND SAT.TalepTarihi <
                  DATEADD(MONTH, 1, A.AyBaslangici)
        ) AS TalepSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.Teklifler T
            WHERE T.TeklifTarihi >= A.AyBaslangici
              AND T.TeklifTarihi <
                  DATEADD(MONTH, 1, A.AyBaslangici)
        ) AS TeklifSayisi

    FROM Aylar A
    ORDER BY A.AyBaslangici
    OPTION (MAXRECURSION 6);
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardEnCokCalisilanTedarikciler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardEnCokCalisilanTedarikciler]
    @KayitSayisi INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@KayitSayisi)
        F.FirmaAdi,
        COUNT(S.SiparisID) AS SiparisSayisi,
        SUM(T.TeklifTutari) AS ToplamSatinAlmaTutari,
        T.ParaBirimi
    FROM dbo.SatinAlmaSiparisleri S
    INNER JOIN dbo.Teklifler T
        ON S.TeklifID = T.TeklifID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    GROUP BY
        F.FirmaAdi,
        T.ParaBirimi
    ORDER BY
        SiparisSayisi DESC,
        ToplamSatinAlmaTutari DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardOzet] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_DashboardOzet]
    @KullaniciID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (
            SELECT COUNT(*)
            FROM dbo.SatinAlmaTalepleri SAT
            WHERE SAT.TalepDurumID = 0
        ) AS BekleyenTalepSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.Teklifler T
            WHERE T.TeklifTarihi >= CAST(GETDATE() AS DATE)
              AND T.TeklifTarihi < DATEADD
              (
                  DAY,
                  1,
                  CAST(GETDATE() AS DATE)
              )
        ) AS BugunGelenTeklifSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.Teklifler T
            LEFT JOIN dbo.SatinAlmaSiparisleri S
                ON T.TeklifID = S.TeklifID
            WHERE T.TeklifDurumID = 1
              AND S.SiparisID IS NULL
        ) AS OnayBekleyenSatinAlmaSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.Tedarikciler TED
            WHERE TED.TedarikciDurumID = 1
        ) AS AktifTedarikciSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.SatinAlmaTalepleri SAT
            WHERE SAT.TalepTarihi >=
                  DATEFROMPARTS
                  (
                      YEAR(GETDATE()),
                      MONTH(GETDATE()),
                      1
                  )
              AND SAT.TalepTarihi <
                  DATEADD
                  (
                      MONTH,
                      1,
                      DATEFROMPARTS
                      (
                          YEAR(GETDATE()),
                          MONTH(GETDATE()),
                          1
                      )
                  )
        ) AS BuAyAcilanTalepSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.SatinAlmaSiparisleri S
        ) AS ToplamSiparisSayisi,

        (
            SELECT COUNT(*)
            FROM dbo.Bildirimler B
            WHERE B.OkunduMu = 0
              AND
              (
                  @KullaniciID IS NULL
                  OR B.KullaniciID = @KullaniciID
              )
        ) AS OkunmamisBildirimSayisi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardSonSiparisler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardSonSiparisler]
    @KayitSayisi INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@KayitSayisi)
        S.SiparisNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        S.SiparisTarihi,
        CASE S.SiparisDurumID
            WHEN 0 THEN N'Oluşturuldu'
            WHEN 1 THEN N'Tamamlandı'
            WHEN 2 THEN N'İptal'
        END AS Durum
    FROM dbo.SatinAlmaSiparisleri S
    INNER JOIN dbo.Teklifler T
        ON S.TeklifID = T.TeklifID
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON S.TalepID = SAT.TalepID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    ORDER BY S.SiparisTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardSonTalepler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardSonTalepler]
    @KayitSayisi INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@KayitSayisi)
        SAT.TalepNo,
        SAT.UrunAdi,
        SAT.Miktar,
        SAT.Birim,
        K.AdSoyad AS TalepEden,
        SAT.TalepTarihi,
        CASE SAT.TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.SatinAlmaTalepleri SAT
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    ORDER BY SAT.TalepTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardSonTeklifler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardSonTeklifler]
    @KayitSayisi INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@KayitSayisi)
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeklifTarihi,
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    ORDER BY T.TeklifTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardTalepDurumDagilimi] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardTalepDurumDagilimi]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE SAT.TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum,
        COUNT(*) AS TalepSayisi
    FROM dbo.SatinAlmaTalepleri SAT
    GROUP BY SAT.TalepDurumID
    ORDER BY SAT.TalepDurumID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardTeklifDurumDagilimi] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardTeklifDurumDagilimi]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum,
        COUNT(*) AS TeklifSayisi
    FROM dbo.Teklifler T
    GROUP BY T.TeklifDurumID
    ORDER BY T.TeklifDurumID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_DashboardYaklasanTeklifTarihleri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_DashboardYaklasanTeklifTarihleri]
    @GunSayisi INT = 7
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.GecerlilikTarihi,
        DATEDIFF
        (
            DAY,
            CAST(GETDATE() AS DATE),
            T.GecerlilikTarihi
        ) AS KalanGun
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    WHERE T.GecerlilikTarihi >= CAST(GETDATE() AS DATE)
      AND T.GecerlilikTarihi <
          DATEADD
          (
              DAY,
              @GunSayisi + 1,
              CAST(GETDATE() AS DATE)
          )
      AND T.TeklifDurumID = 0
    ORDER BY T.GecerlilikTarihi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_FirmaKullanicilariniListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_FirmaKullanicilariniListele]
    @FirmaID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FK.FirmaKullaniciID,
        FK.FirmaID,
        F.FirmaAdi,
        FK.AdSoyad,
        FK.Telefon,
        FK.Eposta,
        FK.Gorev
    FROM dbo.FirmaKullanicilari FK
    INNER JOIN dbo.Firmalar F
        ON FK.FirmaID = F.FirmaID
    WHERE FK.FirmaID = @FirmaID
    ORDER BY FK.AdSoyad;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_FirmaKullanicisiEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_FirmaKullanicisiEkle]
    @FirmaID INT,
    @AdSoyad NVARCHAR(150),
    @Telefon NVARCHAR(30) = NULL,
    @Eposta NVARCHAR(150) = NULL,
    @Gorev NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Firmalar F
        WHERE F.FirmaID = @FirmaID
    )
    BEGIN
        THROW 50001, N'Belirtilen firma bulunamadı.', 1;
    END;

    INSERT INTO dbo.FirmaKullanicilari
    (
        FirmaID,
        AdSoyad,
        Telefon,
        Eposta,
        Gorev
    )
    VALUES
    (
        @FirmaID,
        @AdSoyad,
        @Telefon,
        @Eposta,
        @Gorev
    );
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_FirmaKullanicisiGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_FirmaKullanicisiGuncelle]
    @FirmaKullaniciID INT,
    @AdSoyad NVARCHAR(150),
    @Telefon NVARCHAR(30) = NULL,
    @Eposta NVARCHAR(150) = NULL,
    @Gorev NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.FirmaKullanicilari
    SET
        AdSoyad = @AdSoyad,
        Telefon = @Telefon,
        Eposta = @Eposta,
        Gorev = @Gorev
    WHERE FirmaKullaniciID = @FirmaKullaniciID;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, N'Firma kullanıcısı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_GirisKullanicisiniGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_GirisKullanicisiniGetir]
    @KullaniciAdi NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        K.KullaniciID,
        K.RolID,
        R.RolAdi,
        K.AdSoyad,
        K.KullaniciAdi,
        K.SifreHash,
        K.SifreSalt,
        K.Eposta,
        K.Durum
    FROM dbo.Kullanicilar K
    INNER JOIN dbo.Roller R
        ON K.RolID = R.RolID
    WHERE K.KullaniciAdi = @KullaniciAdi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KendiProfiliniGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KendiProfiliniGuncelle]
    @KullaniciID INT,
    @AdSoyad NVARCHAR(150),
    @Eposta NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Kullanicilar
    SET
        AdSoyad = @AdSoyad,
        Eposta = @Eposta
    WHERE KullaniciID = @KullaniciID
      AND Durum = 1;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, N'Aktif kullanıcı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciBildirimleri] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullaniciBildirimleri]
    @KullaniciID INT
AS
BEGIN
   

    SELECT
        Baslik,
        Mesaj,
        CASE OkunduMu
            WHEN 0 THEN N'Okunmadı'
            WHEN 1 THEN N'Okundu'
        END AS OkunmaDurumu,
        OlusturmaTarihi,
        OkunmaTarihi
    FROM dbo.Bildirimler B
    WHERE B.KullaniciID = @KullaniciID
    ORDER BY OlusturmaTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciDetayiGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_KullaniciDetayiGetir]
    @KullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        K.KullaniciID,
        K.AdSoyad,
        K.KullaniciAdi,
        K.Eposta,
        R.RolID,
        R.RolAdi,
        K.Durum,
        K.SonGirisTarihi,
        K.KayitTarihi
    FROM dbo.Kullanicilar K
    INNER JOIN dbo.Roller R
        ON K.RolID = R.RolID
    WHERE K.KullaniciID = @KullaniciID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciDurumuGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullaniciDurumuGuncelle]
    @KullaniciID INT,
    @YeniDurum INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @YeniDurum NOT IN (0, 1)
    BEGIN
        THROW 50001, N'Kullanıcı durumu yalnızca 0 veya 1 olabilir.', 1;
    END;

    UPDATE dbo.Kullanicilar
    SET Durum = @YeniDurum
    WHERE KullaniciID = @KullaniciID;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50002, N'Belirtilen kullanıcı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullaniciEkle]
    @RolAdi NVARCHAR(100),
    @AdSoyad NVARCHAR(150),
    @KullaniciAdi NVARCHAR(100),
    @Eposta NVARCHAR(150),
    @SifreHash VARBINARY(MAX),
    @SifreSalt VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RolID INT;

    SELECT
        @RolID = R.RolID
    FROM dbo.Roller R
    WHERE R.RolAdi = @RolAdi;

    IF @RolID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen rol bulunamadı.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Kullanicilar K
        WHERE K.KullaniciAdi = @KullaniciAdi
    )
    BEGIN
        THROW 50002, N'Bu kullanıcı adı zaten kullanılıyor.', 1;
    END;

    INSERT INTO dbo.Kullanicilar
    (
        RolID,
        AdSoyad,
        KullaniciAdi,
        SifreHash,
        SifreSalt,
        Eposta,
        Durum,
        SonGirisTarihi,
        KayitTarihi
    )
    VALUES
    (
        @RolID,
        @AdSoyad,
        @KullaniciAdi,
        @SifreHash,
        @SifreSalt,
        @Eposta,
        1,
        NULL,
        GETDATE()
    );
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullaniciGuncelle]
    @KullaniciID INT,
    @RolAdi NVARCHAR(100),
    @AdSoyad NVARCHAR(150),
    @KullaniciAdi NVARCHAR(100),
    @Eposta NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RolID INT;

    SELECT
        @RolID = R.RolID
    FROM dbo.Roller R
    WHERE R.RolAdi = @RolAdi;

    IF @RolID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen rol bulunamadı.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Kullanicilar K
        WHERE K.KullaniciAdi = @KullaniciAdi
          AND K.KullaniciID <> @KullaniciID
    )
    BEGIN
        THROW 50002, N'Bu kullanıcı adı başka bir kullanıcıya aittir.', 1;
    END;

    UPDATE dbo.Kullanicilar
    SET
        RolID = @RolID,
        AdSoyad = @AdSoyad,
        KullaniciAdi = @KullaniciAdi,
        Eposta = @Eposta
    WHERE KullaniciID = @KullaniciID;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50003, N'Belirtilen kullanıcı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullanicilariFiltrele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullanicilariFiltrele]
    @AramaMetni NVARCHAR(150) = NULL,
    @RolAdi NVARCHAR(100) = NULL,
    @Durum INT = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        K.KullaniciID,
        K.AdSoyad,
        K.KullaniciAdi,
        K.Eposta,
        R.RolAdi,
        CASE K.Durum
            WHEN 1 THEN N'Aktif'
            ELSE N'Pasif'
        END AS Durum,
        K.SonGirisTarihi,
        K.KayitTarihi
    FROM dbo.Kullanicilar K
    INNER JOIN dbo.Roller R
        ON K.RolID = R.RolID
    WHERE
        (
            @AramaMetni IS NULL
            OR K.AdSoyad LIKE N'%' + @AramaMetni + N'%'
            OR K.KullaniciAdi LIKE N'%' + @AramaMetni + N'%'
            OR K.Eposta LIKE N'%' + @AramaMetni + N'%'
        )
        AND
        (
            @RolAdi IS NULL
            OR R.RolAdi = @RolAdi
        )
        AND
        (
            @Durum IS NULL
            OR K.Durum = @Durum
        )
        AND
        (
            @BaslangicTarihi IS NULL
            OR K.KayitTarihi >= @BaslangicTarihi
        )
        AND
        (
            @BitisTarihi IS NULL
            OR K.KayitTarihi < DATEADD(DAY, 1, @BitisTarihi)
        )
    ORDER BY K.AdSoyad;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullanicilariListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullanicilariListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        K.KullaniciID,
        K.AdSoyad,
        K.KullaniciAdi,
        K.Eposta,
        R.RolAdi,
        CASE K.Durum
            WHEN 1 THEN N'Aktif'
            ELSE N'Pasif'
        END AS Durum,
        K.SonGirisTarihi,
        K.KayitTarihi
    FROM dbo.Kullanicilar K
    INNER JOIN dbo.Roller R
        ON K.RolID = R.RolID
    ORDER BY K.AdSoyad;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_KullaniciYonetimiOzet] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_KullaniciYonetimiOzet]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS ToplamKullanici,
        SUM(CASE WHEN Durum = 1 THEN 1 ELSE 0 END) AS AktifKullanici,
        SUM(CASE WHEN Durum = 0 THEN 1 ELSE 0 END) AS PasifKullanici,
        (
            SELECT COUNT(*)
            FROM dbo.Roller
        ) AS ToplamRol
    FROM dbo.Kullanicilar;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_OkunmamisBildirimSayisi] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_OkunmamisBildirimSayisi]
    @KullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS OkunmamisBildirimSayisi
    FROM dbo.Bildirimler B
    WHERE B.KullaniciID = @KullaniciID
      AND B.OkunduMu = 0;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_OnayBekleyenTeklifleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_OnayBekleyenTeklifleriListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeklifID,
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        K.AdSoyad AS TalepEden,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeslimSuresiGun,
        T.TeklifTarihi,
        T.GecerlilikTarihi
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    LEFT JOIN dbo.SatinAlmaSiparisleri S
        ON T.TeklifID = S.TeklifID
    WHERE T.TeklifDurumID = 1
      AND S.SiparisID IS NULL
    ORDER BY T.TeklifTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporAylikSatinAlmaTutari] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporAylikSatinAlmaTutari]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(S.SiparisTarihi) AS Yil,
        MONTH(S.SiparisTarihi) AS Ay,
        SUM(T.TeklifTutari) AS ToplamTutar
    FROM dbo.SatinAlmaSiparisleri S
    INNER JOIN dbo.Teklifler T
        ON S.TeklifID = T.TeklifID
    GROUP BY
        YEAR(S.SiparisTarihi),
        MONTH(S.SiparisTarihi)
    ORDER BY
        Yil DESC,
        Ay DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporAylikTalep] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporAylikTalep]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(TalepTarihi) AS Yil,
        MONTH(TalepTarihi) AS Ay,
        COUNT(*) AS TalepSayisi
    FROM dbo.SatinAlmaTalepleri
    GROUP BY
        YEAR(TalepTarihi),
        MONTH(TalepTarihi)
    ORDER BY
        Yil DESC,
        Ay DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporAylikTeklif] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporAylikTeklif]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(TeklifTarihi) AS Yil,
        MONTH(TeklifTarihi) AS Ay,
        COUNT(*) AS TeklifSayisi
    FROM dbo.Teklifler
    GROUP BY
        YEAR(TeklifTarihi),
        MONTH(TeklifTarihi)
    ORDER BY
        Yil DESC,
        Ay DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporEnCokSatinAlmaYapilanFirmalar] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporEnCokSatinAlmaYapilanFirmalar]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.FirmaAdi,
        COUNT(*) AS SiparisSayisi,
        SUM(T.TeklifTutari) AS ToplamTutar
    FROM dbo.SatinAlmaSiparisleri S
    INNER JOIN dbo.Teklifler T
        ON S.TeklifID = T.TeklifID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    GROUP BY
        F.FirmaAdi
    ORDER BY
        ToplamTutar DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporEnCokTeklifVerenFirmalar] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporEnCokTeklifVerenFirmalar]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.FirmaAdi,
        COUNT(*) AS TeklifSayisi
    FROM dbo.Teklifler T
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    GROUP BY
        F.FirmaAdi
    ORDER BY
        TeklifSayisi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporKullaniciTalepSayisi] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporKullaniciTalepSayisi]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        K.AdSoyad,
        COUNT(*) AS TalepSayisi
    FROM dbo.SatinAlmaTalepleri SAT
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    GROUP BY
        K.AdSoyad
    ORDER BY
        TalepSayisi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporSiparisDurumlari] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporSiparisDurumlari]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE SiparisDurumID
            WHEN 0 THEN N'Oluşturuldu'
            WHEN 1 THEN N'Tamamlandı'
            WHEN 2 THEN N'İptal'
        END AS Durum,
        COUNT(*) AS SiparisSayisi
    FROM dbo.SatinAlmaSiparisleri
    GROUP BY SiparisDurumID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporTalepDurumlari] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporTalepDurumlari]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum,
        COUNT(*) AS TalepSayisi
    FROM dbo.SatinAlmaTalepleri
    GROUP BY TalepDurumID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporTeklifDurumlari] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporTeklifDurumlari]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum,
        COUNT(*) AS TeklifSayisi
    FROM dbo.Teklifler
    GROUP BY TeklifDurumID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RaporYaklasanTeklifler] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_RaporYaklasanTeklifler]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeklifNo,
        F.FirmaAdi,
        SAT.TalepNo,
        T.GecerlilikTarihi
    FROM dbo.Teklifler T
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    WHERE T.GecerlilikTarihi >= CAST(GETDATE() AS DATE)
    ORDER BY T.GecerlilikTarihi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RoldenYetkiKaldir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RoldenYetkiKaldir]
    @RolID INT,
    @YetkiID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.RolYetkileri
    WHERE RolID = @RolID
      AND YetkiID = @YetkiID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RolEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RolEkle]
    @RolAdi NVARCHAR(100),
    @Aciklama NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Roller R
        WHERE R.RolAdi = @RolAdi
    )
    BEGIN
        THROW 50001, N'Bu rol adı zaten kullanılıyor.', 1;
    END;

    INSERT INTO dbo.Roller
    (
        RolAdi,
        Aciklama
    )
    VALUES
    (
        @RolAdi,
        @Aciklama
    );
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RoleYetkiEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RoleYetkiEkle]
    @RolID INT,
    @YetkiID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.RolYetkileri RY
        WHERE RY.RolID = @RolID
          AND RY.YetkiID = @YetkiID
    )
    BEGIN
        INSERT INTO dbo.RolYetkileri
        (
            RolID,
            YetkiID
        )
        VALUES
        (
            @RolID,
            @YetkiID
        );
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RolGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RolGuncelle]
    @RolID INT,
    @RolAdi NVARCHAR(100),
    @Aciklama NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Roller R
        WHERE R.RolAdi = @RolAdi
          AND R.RolID <> @RolID
    )
    BEGIN
        THROW 50001, N'Bu rol adı başka bir role aittir.', 1;
    END;

    UPDATE dbo.Roller
    SET
        RolAdi = @RolAdi,
        Aciklama = @Aciklama
    WHERE RolID = @RolID;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50002, N'Belirtilen rol bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RolleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RolleriListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.RolID,
        R.RolAdi,
        R.Aciklama,
        COUNT(K.KullaniciID) AS KullaniciSayisi
    FROM dbo.Roller R
    LEFT JOIN dbo.Kullanicilar K
        ON R.RolID = K.RolID
    GROUP BY
        R.RolID,
        R.RolAdi,
        R.Aciklama
    ORDER BY R.RolAdi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_RolYetkileriniGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RolYetkileriniGetir]
    @RolID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Y.YetkiID,
        Y.YetkiKodu,
        Y.YetkiAdi,
        Y.Aciklama,
        CASE
            WHEN RY.RolID IS NULL THEN 0
            ELSE 1
        END AS SeciliMi
    FROM dbo.Yetkiler Y
    LEFT JOIN dbo.RolYetkileri RY
        ON Y.YetkiID = RY.YetkiID
       AND RY.RolID = @RolID
    ORDER BY Y.YetkiAdi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SifreGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SifreGuncelle]
    @KullaniciID INT,
    @YeniSifreHash VARBINARY(MAX),
    @YeniSifreSalt VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Kullanicilar
    SET
        SifreHash = @YeniSifreHash,
        SifreSalt = @YeniSifreSalt
    WHERE KullaniciID = @KullaniciID
      AND Durum = 1;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, N'Aktif kullanıcı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SiparisDurumuGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_SiparisDurumuGuncelle]
@SiparisNo NVARCHAr(20),
@YeniDurum int as
begin
update SatinAlmaSiparisleri set SiparisDurumID = @YeniDurum where SiparisNo = @SiparisNo
end 
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SiparisleriDurumaGoreListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SiparisleriDurumaGoreListele]
    @Durum INT
AS
BEGIN
    SELECT
        S.SiparisID,
        S.SiparisNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        T.TeklifNo,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        K.AdSoyad AS OnaylayanKullanici,
        S.SiparisTarihi,
        CASE S.SiparisDurumID
            WHEN 0 THEN N'Oluşturuldu'
            WHEN 1 THEN N'Tamamlandı'
            WHEN 2 THEN N'İptal'
        END AS Durum
    FROM dbo.SatinAlmaSiparisleri S
    INNER JOIN dbo.Teklifler T
        ON S.TeklifID = T.TeklifID
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON S.TalepID = SAT.TalepID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    INNER JOIN dbo.Kullanicilar K
        ON S.OnaylayanKullaniciID = K.KullaniciID
    WHERE S.SiparisDurumID = @Durum
    ORDER BY S.SiparisTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SiparisleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_SiparisleriListele] as begin
select S.SiparisID, S.SiparisNo, SAT.TalepNo,SAT.UrunAdi,
        T.TeklifNo,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        K.AdSoyad AS OnaylayanKullanici,
        S.SiparisTarihi,
        case S.SiparisDurumID 
        when 0 then N'Oluşturuldu'
        when 1 then N'Tamamlandı'
        when 2 then N'İptal' end as Durum
        from SatinAlmaSiparisleri S
        inner join Teklifler T on s.TeklifID = t.TeklifID
        inner join SatinAlmaTalepleri SAT on s.TalepID = SAT.TalepID
        inner join Tedarikciler TED on t.TedarikciID = TED.TedarikciID
        inner join Firmalar F on TED.FirmaID = f.FirmaID 
        inner join Kullanicilar k on S.onaylayanKullaniciId = k.KullaniciID
        order by S.SiparisTarihi desc;
        end;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SiparisOlustur] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_SiparisOlustur]
    @TeklifID INT,
    @OnaylayanKullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SatinAlmaSiparisleri
    (
        SiparisNo,
        TalepID,
        TeklifID,
        OnaylayanKullaniciID,
        SiparisTarihi,
        SiparisDurumID
    )
    SELECT
        CONCAT(
            N'SP',
            RIGHT(N'0000' + CAST(T.TeklifID AS NVARCHAR(10)), 4)
        ),
        T.TalepID,
        T.TeklifID,
        @OnaylayanKullaniciID,
        GETDATE(),
        0
    FROM dbo.Teklifler T
    WHERE T.TeklifID = @TeklifID
      AND T.TeklifDurumID = 1
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.SatinAlmaSiparisleri S
          WHERE S.TeklifID = T.TeklifID
      );
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_SonGirisTarihiniGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_SonGirisTarihiniGuncelle]
    @KullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Kullanicilar
    SET SonGirisTarihi = GETDATE()
    WHERE KullaniciID = @KullaniciID
      AND Durum = 1;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, N'Aktif kullanıcı bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalebeAitTeklifleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TalebeAitTeklifleriListele]
    @TalepNo NVARCHAR(20)
AS
BEGIN
    SELECT
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        K.AdSoyad AS TalepEden,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeslimSuresiGun,
        T.SKT,
        T.GecerlilikTarihi,
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    WHERE SAT.TalepNo = @TalepNo
    ORDER BY T.TeklifTutari ASC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalebiReddet] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TalebiReddet]
    @TalepNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TalepID INT;

    SELECT
        @TalepID = SAT.TalepID
    FROM dbo.SatinAlmaTalepleri SAT
    WHERE SAT.TalepNo = @TalepNo;

    IF @TalepID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen talep bulunamadı.', 1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 3
        WHERE TalepID = @TalepID;

        UPDATE dbo.Teklifler
        SET TeklifDurumID = 2
        WHERE TalepID = @TalepID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalepDetayiGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TalepDetayiGetir]
    @TalepNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SAT.TalepID,
        SAT.TalepNo,
        SAT.UrunAdi,
        SAT.Miktar,
        SAT.Birim,
        SAT.Aciklama,
        SAT.TalepTarihi,
        K.AdSoyad AS TalepEden,
        CASE SAT.TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum,
        COUNT(T.TeklifID) AS TeklifSayisi
    FROM dbo.SatinAlmaTalepleri SAT
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    LEFT JOIN dbo.Teklifler T
        ON SAT.TalepID = T.TalepID
    WHERE SAT.TalepNo = @TalepNo
    GROUP BY
        SAT.TalepID,
        SAT.TalepNo,
        SAT.UrunAdi,
        SAT.Miktar,
        SAT.Birim,
        SAT.Aciklama,
        SAT.TalepTarihi,
        SAT.TalepDurumID,
        K.AdSoyad;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalepDuzenle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TalepDuzenle]
    @TalepID INT,
    @UrunAdi NVARCHAR(150),
    @UrunAciklamasi NVARCHAR(255) = NULL,
    @Miktar DECIMAL(10,2),
    @Birim NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.SatinAlmaTalepleri
        WHERE TalepID = @TalepID
    )
    BEGIN
        THROW 50001, N'Satın alma talebi bulunamadı.', 1;
    END;

    IF NULLIF(LTRIM(RTRIM(@UrunAdi)), N'') IS NULL
    BEGIN
        THROW 50002, N'Ürün adı boş bırakılamaz.', 1;
    END;

    IF @Miktar IS NULL OR @Miktar <= 0
    BEGIN
        THROW 50003, N'Miktar sıfırdan büyük olmalıdır.', 1;
    END;

    IF NULLIF(LTRIM(RTRIM(@Birim)), N'') IS NULL
    BEGIN
        THROW 50004, N'Birim boş bırakılamaz.', 1;
    END;

    UPDATE dbo.SatinAlmaTalepleri
    SET
        UrunAdi = LTRIM(RTRIM(@UrunAdi)),
        Aciklama = NULLIF(LTRIM(RTRIM(@UrunAciklamasi)), N''),
        Miktar = @Miktar,
        Birim = LTRIM(RTRIM(@Birim))
    WHERE TalepID = @TalepID;

    SELECT
        TalepID,
        TalepNo,
        UrunAdi,
        Aciklama AS UrunAciklamasi,
        Miktar,
        Birim
    FROM dbo.SatinAlmaTalepleri
    WHERE TalepID = @TalepID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalepEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TalepEkle]
    @TalepEdenKullaniciID INT,
    @UrunAdi NVARCHAR(150),
    @Miktar DECIMAL(18,2),
    @Birim NVARCHAR(30),
    @Aciklama NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @YeniTalepID INT;
    DECLARE @YeniTalepNo NVARCHAR(20);

    BEGIN TRANSACTION;

    BEGIN TRY

        INSERT INTO dbo.SatinAlmaTalepleri
        (
            TalepNo,
            TalepEdenKullaniciID,
            UrunAdi,
            Miktar,
            Birim,
            TalepTarihi,
            TalepDurumID,
            Aciklama
        )
        VALUES
        (
            N'GEÇİCİ',
            @TalepEdenKullaniciID,
            @UrunAdi,
            @Miktar,
            @Birim,
            GETDATE(),
            0,
            @Aciklama
        );

        SET @YeniTalepID = SCOPE_IDENTITY();

        SET @YeniTalepNo =
            CONCAT
            (
                N'ST',
                RIGHT
                (
                    N'0000' + CAST(@YeniTalepID AS NVARCHAR(10)),
                    4
                )
            );

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepNo = @YeniTalepNo
        WHERE TalepID = @YeniTalepID;

        COMMIT TRANSACTION;

        SELECT
            @YeniTalepID AS TalepID,
            @YeniTalepNo AS TalepNo;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalepleriFiltrele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TalepleriFiltrele]
    @AramaMetni NVARCHAR(150) = NULL,
    @TalepEden NVARCHAR(150) = NULL,
    @Durumlar NVARCHAR(20) = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi DATE = NULL,
    @MinMiktar DECIMAL(18,2) = NULL,
    @MaxMiktar DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SAT.TalepID,
        SAT.TalepNo,
        SAT.UrunAdi,
        SAT.Miktar,
        SAT.Birim,
        K.AdSoyad AS TalepEden,
        SAT.TalepTarihi,
        SAT.Aciklama,
        CASE SAT.TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.SatinAlmaTalepleri SAT
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    WHERE
        (
            @AramaMetni IS NULL
            OR SAT.TalepNo LIKE N'%' + @AramaMetni + N'%'
            OR SAT.UrunAdi LIKE N'%' + @AramaMetni + N'%'
        )
        AND
        (
            @TalepEden IS NULL
            OR K.AdSoyad LIKE N'%' + @TalepEden + N'%'
        )
        AND
        (
            @Durumlar IS NULL
            OR SAT.TalepDurumID IN
            (
                SELECT TRY_CAST(value AS INT)
                FROM STRING_SPLIT(@Durumlar, N',')
                WHERE TRY_CAST(value AS INT) IS NOT NULL
            )
        )
        AND
        (
            @BaslangicTarihi IS NULL
            OR SAT.TalepTarihi >= @BaslangicTarihi
        )
        AND
        (
            @BitisTarihi IS NULL
            OR SAT.TalepTarihi < DATEADD(DAY, 1, @BitisTarihi)
        )
        AND
        (
            @MinMiktar IS NULL
            OR SAT.Miktar >= @MinMiktar
        )
        AND
        (
            @MaxMiktar IS NULL
            OR SAT.Miktar <= @MaxMiktar
        )

    ORDER BY SAT.TalepTarihi DESC;

END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TalepleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TalepleriListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SAT.TalepID,
        SAT.TalepNo,
        SAT.UrunAdi,
        SAT.Miktar,
        SAT.Birim,
        K.AdSoyad AS TalepEden,
        SAT.TalepTarihi,
        SAT.Aciklama,
        CASE SAT.TalepDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Teklifler Alındı'
            WHEN 2 THEN N'Onaylandı'
            WHEN 3 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.SatinAlmaTalepleri SAT
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    ORDER BY SAT.TalepTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikciDetayiGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TedarikciDetayiGetir]
    @TedarikciID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        TED.TedarikciID,
        F.FirmaID,
        F.FirmaAdi,
        F.VergiNo,
        F.Telefon,
        F.Adres,
        F.Eposta,
        TED.TedarikciDurumID,
        TED.KayitTarihi
    FROM dbo.Tedarikciler TED
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    WHERE TED.TedarikciID = @TedarikciID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikciDurumuGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TedarikciDurumuGuncelle]
    @TedarikciID INT,
    @YeniDurum INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @YeniDurum NOT IN (0, 1)
    BEGIN
        THROW 50001, N'Tedarikçi durumu yalnızca 0 veya 1 olabilir.', 1;
    END;

    UPDATE dbo.Tedarikciler
    SET TedarikciDurumID = @YeniDurum
    WHERE TedarikciID = @TedarikciID;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50002, N'Belirtilen tedarikçi bulunamadı.', 1;
    END;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikciEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TedarikciEkle]
    @FirmaAdi NVARCHAR(150),
    @VergiNo NVARCHAR(20),
    @Telefon NVARCHAR(30) = NULL,
    @Adres NVARCHAR(500) = NULL,
    @Eposta NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @YeniFirmaID INT;

    BEGIN TRANSACTION;

    BEGIN TRY

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Firmalar F
            WHERE F.VergiNo = @VergiNo
        )
        BEGIN
            THROW 50001, N'Bu vergi numarasıyla kayıtlı bir firma zaten var.', 1;
        END;

        INSERT INTO dbo.Firmalar
        (
            FirmaAdi,
            VergiNo,
            Telefon,
            Adres,
            Eposta
        )
        VALUES
        (
            @FirmaAdi,
            @VergiNo,
            @Telefon,
            @Adres,
            @Eposta
        );

        SET @YeniFirmaID = SCOPE_IDENTITY();

        INSERT INTO dbo.Tedarikciler
        (
            FirmaID,
            TedarikciDurumID,
            KayitTarihi
        )
        VALUES
        (
            @YeniFirmaID,
            1,
            GETDATE()
        );

        COMMIT TRANSACTION;

        SELECT
            @YeniFirmaID AS FirmaID,
            @FirmaAdi AS FirmaAdi,
            N'Aktif' AS Durum;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikciGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TedarikciGuncelle]
    @TedarikciID INT,
    @FirmaAdi NVARCHAR(150),
    @VergiNo NVARCHAR(20),
    @Telefon NVARCHAR(30) = NULL,
    @Adres NVARCHAR(500) = NULL,
    @Eposta NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FirmaID INT;

    SELECT
        @FirmaID = TED.FirmaID
    FROM dbo.Tedarikciler TED
    WHERE TED.TedarikciID = @TedarikciID;

    IF @FirmaID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen tedarikçi bulunamadı.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Firmalar F
        WHERE F.VergiNo = @VergiNo
          AND F.FirmaID <> @FirmaID
    )
    BEGIN
        THROW 50002, N'Bu vergi numarası başka bir firmaya aittir.', 1;
    END;

    UPDATE dbo.Firmalar
    SET
        FirmaAdi = @FirmaAdi,
        VergiNo = @VergiNo,
        Telefon = @Telefon,
        Adres = @Adres,
        Eposta = @Eposta
    WHERE FirmaID = @FirmaID;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikcileriFiltrele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TedarikcileriFiltrele]
    @AramaMetni NVARCHAR(150) = NULL,
    @Durum INT = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        TED.TedarikciID,
        F.FirmaAdi,
        F.VergiNo,
        F.Telefon,
        F.Eposta,
        F.Adres,
        CASE TED.TedarikciDurumID
            WHEN 1 THEN N'Aktif'
            ELSE N'Pasif'
        END AS Durum,
        TED.KayitTarihi
    FROM dbo.Tedarikciler TED
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    WHERE
        (
            @AramaMetni IS NULL
            OR F.FirmaAdi LIKE N'%' + @AramaMetni + N'%'
            OR F.VergiNo LIKE N'%' + @AramaMetni + N'%'
            OR F.Telefon LIKE N'%' + @AramaMetni + N'%'
            OR F.Eposta LIKE N'%' + @AramaMetni + N'%'
        )
        AND
        (
            @Durum IS NULL
            OR TED.TedarikciDurumID = @Durum
        )
        AND
        (
            @BaslangicTarihi IS NULL
            OR TED.KayitTarihi >= @BaslangicTarihi
        )
        AND
        (
            @BitisTarihi IS NULL
            OR TED.KayitTarihi < DATEADD(DAY, 1, @BitisTarihi)
        )
    ORDER BY F.FirmaAdi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TedarikcileriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TedarikcileriListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        TED.TedarikciID,
        F.FirmaAdi,
        F.VergiNo,
        F.Telefon,
        F.Eposta,
        F.Adres,
        CASE TED.TedarikciDurumID
            WHEN 1 THEN N'Aktif'
            ELSE N'Pasif'
        END AS Durum,
        TED.KayitTarihi
    FROM dbo.Tedarikciler TED
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    ORDER BY F.FirmaAdi;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifDetayiGetir] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TeklifDetayiGetir]
    @TeklifNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeklifID,
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        F.FirmaAdi,
        K.AdSoyad AS TeklifGiren,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeslimSuresiGun,
        T.SKT,
        T.TeklifTarihi,
        T.GecerlilikTarihi,
        TK.KalemAdi,
        TK.KalemAciklamasi,
        TK.Miktar,
        TK.Birim,
        TK.BirimFiyat,
        TK.ToplamTutar,
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    INNER JOIN dbo.Kullanicilar K
        ON T.TeklifGirenKullaniciID = K.KullaniciID
    LEFT JOIN dbo.TeklifKalemleri TK
        ON T.TeklifID = TK.TeklifID
    WHERE T.TeklifNo = @TeklifNo;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifEkle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifEkle]
    @TalepNo NVARCHAR(20),
    @FirmaAdi NVARCHAR(150),
    @TeklifGirenKullaniciID INT,
    @BirimFiyat DECIMAL(18,2),
    @TeslimSuresiGun INT,
    @SKT DATE = NULL,
    @GecerlilikTarihi DATE,
    @ParaBirimi CHAR(3)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @YeniTeklifID INT;
    DECLARE @YeniTeklifNo NVARCHAR(20);
    DECLARE @Miktar DECIMAL(18,2);
    DECLARE @ToplamTutar DECIMAL(18,2);

    BEGIN TRANSACTION;

    BEGIN TRY

        SELECT
            @Miktar = SAT.Miktar
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepNo = @TalepNo;

        IF @Miktar IS NULL
        BEGIN
            THROW 50001, N'Belirtilen talep bulunamadı.', 1;
        END;

        SET @ToplamTutar = @Miktar * @BirimFiyat;

        INSERT INTO dbo.Teklifler
        (
            TeklifNo,
            TalepID,
            TedarikciID,
            TeklifGirenKullaniciID,
            TeklifTutari,
            TeslimSuresiGun,
            SKT,
            TeklifTarihi,
            GecerlilikTarihi,
            ParaBirimi,
            TeklifDurumID
        )
        SELECT
            N'GEÇİCİ',
            SAT.TalepID,
            TED.TedarikciID,
            @TeklifGirenKullaniciID,
            @ToplamTutar,
            @TeslimSuresiGun,
            @SKT,
            GETDATE(),
            @GecerlilikTarihi,
            @ParaBirimi,
            0
        FROM dbo.SatinAlmaTalepleri SAT
        INNER JOIN dbo.Firmalar F
            ON F.FirmaAdi = @FirmaAdi
        INNER JOIN dbo.Tedarikciler TED
            ON TED.FirmaID = F.FirmaID
        WHERE SAT.TalepNo = @TalepNo;

        SET @YeniTeklifID = SCOPE_IDENTITY();

        IF @YeniTeklifID IS NULL
        BEGIN
            THROW 50002, N'Firma veya tedarikçi bulunamadı.', 1;
        END;

        SET @YeniTeklifNo =
            CONCAT
            (
                N'TK',
                RIGHT
                (
                    N'0000' + CAST(@YeniTeklifID AS NVARCHAR(10)),
                    4
                )
            );

        UPDATE dbo.Teklifler
        SET TeklifNo = @YeniTeklifNo
        WHERE TeklifID = @YeniTeklifID;

        INSERT INTO dbo.TeklifKalemleri
        (
            TeklifID,
            KalemAdi,
            KalemAciklamasi,
            Miktar,
            Birim,
            BirimFiyat,
            ToplamTutar
        )
        SELECT
            @YeniTeklifID,
            SAT.UrunAdi,
            SAT.Aciklama,
            SAT.Miktar,
            SAT.Birim,
            @BirimFiyat,
            @ToplamTutar
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepNo = @TalepNo;

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 1
        WHERE TalepNo = @TalepNo;

        COMMIT TRANSACTION;

        SELECT
            @YeniTeklifID AS TeklifID,
            @YeniTeklifNo AS TeklifNo,
            @Miktar AS Miktar,
            @BirimFiyat AS BirimFiyat,
            @ToplamTutar AS ToplamTutar,
            N'Teklifler Alındı' AS TalepDurumu;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifGuncelle] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifGuncelle]
    @TeklifID           INT,
    @TedarikciID        INT,
    @TeklifTutari       DECIMAL(18, 2),
    @TeslimSuresiGun    INT,
    @SKT                DATE = NULL,
    @GecerlilikTarihi   DATE,
    @ParaBirimi         NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Teklifler
            WHERE TeklifID = @TeklifID
        )
        BEGIN
            THROW 50001, N'Güncellenecek teklif bulunamadı.', 1;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Teklifler
            WHERE TeklifID = @TeklifID
              AND TeklifDurumID <> 0
        )
        BEGIN
            THROW 50002,
                  N'Yalnızca Girildi durumundaki teklifler güncellenebilir.',
                  1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Tedarikciler
            WHERE TedarikciID = @TedarikciID
        )
        BEGIN
            THROW 50003, N'Seçilen tedarikçi bulunamadı.', 1;
        END;

        IF @TeklifTutari <= 0
        BEGIN
            THROW 50004, N'Teklif tutarı sıfırdan büyük olmalıdır.', 1;
        END;

        IF @TeslimSuresiGun <= 0
        BEGIN
            THROW 50005, N'Teslim süresi sıfırdan büyük olmalıdır.', 1;
        END;

        IF NULLIF(LTRIM(RTRIM(@ParaBirimi)), N'') IS NULL
        BEGIN
            THROW 50006, N'Para birimi boş bırakılamaz.', 1;
        END;

        IF @GecerlilikTarihi < CAST(GETDATE() AS DATE)
        BEGIN
            THROW 50007,
                  N'Geçerlilik tarihi bugünden önce olamaz.',
                  1;
        END;

        IF @SKT IS NOT NULL
           AND @SKT < CAST(GETDATE() AS DATE)
        BEGIN
            THROW 50008,
                  N'Son kullanma tarihi bugünden önce olamaz.',
                  1;
        END;

        BEGIN TRANSACTION;

        UPDATE dbo.Teklifler
        SET
            TedarikciID       = @TedarikciID,
            TeklifTutari      = @TeklifTutari,
            TeslimSuresiGun   = @TeslimSuresiGun,
            SKT               = @SKT,
            GecerlilikTarihi  = @GecerlilikTarihi,
            ParaBirimi        = UPPER(LTRIM(RTRIM(@ParaBirimi)))
        WHERE TeklifID = @TeklifID
          AND TeklifDurumID = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50009, N'Teklif güncellenemedi.', 1;
        END;

        COMMIT TRANSACTION;

        SELECT
            TeklifID,
            TeklifNo,
            TalepID,
            TedarikciID,
            TeklifGirenKullaniciID,
            TeklifTutari,
            TeslimSuresiGun,
            SKT,
            TeklifTarihi,
            GecerlilikTarihi,
            ParaBirimi,
            TeklifDurumID
        FROM dbo.Teklifler
        WHERE TeklifID = @TeklifID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifiReddet] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifiReddet]
    @TeklifNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TalepID INT;

    SELECT
        @TalepID = T.TalepID
    FROM dbo.Teklifler T
    WHERE T.TeklifNo = @TeklifNo;

    IF @TalepID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen teklif bulunamadı.', 1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE dbo.Teklifler
        SET TeklifDurumID = 2
        WHERE TeklifNo = @TeklifNo;

        -- Talebe ait reddedilmemiş başka teklif kalmadıysa talebi de reddet
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Teklifler T
            WHERE T.TalepID = @TalepID
              AND T.TeklifDurumID IN (0, 1)
        )
        BEGIN
            UPDATE dbo.SatinAlmaTalepleri
            SET TalepDurumID = 3
            WHERE TalepID = @TalepID;
        END;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifleriFiltrele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifleriFiltrele]
    @AramaMetni NVARCHAR(150) = NULL,
    @FirmaAdi NVARCHAR(150) = NULL,
    @Durumlar NVARCHAR(20) = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi DATE = NULL,
    @MinTutar DECIMAL(18,2) = NULL,
    @MaxTutar DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
    T.SKT,
        T.TeklifID,
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        K.AdSoyad AS TalepEden,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeslimSuresiGun,
        T.TeklifTarihi,
        T.GecerlilikTarihi,
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    WHERE
        (
            @AramaMetni IS NULL
            OR T.TeklifNo LIKE N'%' + @AramaMetni + N'%'
            OR SAT.TalepNo LIKE N'%' + @AramaMetni + N'%'
            OR SAT.UrunAdi LIKE N'%' + @AramaMetni + N'%'
        )
        AND
        (
            @FirmaAdi IS NULL
            OR F.FirmaAdi LIKE N'%' + @FirmaAdi + N'%'
        )
        AND
        (
            @Durumlar IS NULL
            OR T.TeklifDurumID IN
            (
                SELECT TRY_CAST(value AS INT)
                FROM STRING_SPLIT(@Durumlar, N',')
                WHERE TRY_CAST(value AS INT) IS NOT NULL
            )
        )
        AND
        (
            @BaslangicTarihi IS NULL
            OR T.TeklifTarihi >= @BaslangicTarihi
        )
        AND
        (
            @BitisTarihi IS NULL
            OR T.TeklifTarihi < DATEADD(DAY, 1, @BitisTarihi)
        )
        AND
        (
            @MinTutar IS NULL
            OR T.TeklifTutari >= @MinTutar
        )
        AND
        (
            @MaxTutar IS NULL
            OR T.TeklifTutari <= @MaxTutar
        )
    ORDER BY T.TeklifTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifleriListele] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TeklifleriListele]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeklifID,
        T.TeklifNo,
        SAT.TalepNo,
        SAT.UrunAdi,
        K.AdSoyad AS TalepEden,
        F.FirmaAdi,
        T.TeklifTutari,
        T.ParaBirimi,
        T.TeslimSuresiGun,
        T.TeklifTarihi,
        T.GecerlilikTarihi,
        CASE T.TeklifDurumID
            WHEN 0 THEN N'İnceleniyor'
            WHEN 1 THEN N'Seçildi'
            WHEN 2 THEN N'Reddedildi'
        END AS Durum
    FROM dbo.Teklifler T
    INNER JOIN dbo.SatinAlmaTalepleri SAT
        ON T.TalepID = SAT.TalepID
    INNER JOIN dbo.Kullanicilar K
        ON SAT.TalepEdenKullaniciID = K.KullaniciID
    INNER JOIN dbo.Tedarikciler TED
        ON T.TedarikciID = TED.TedarikciID
    INNER JOIN dbo.Firmalar F
        ON TED.FirmaID = F.FirmaID
    ORDER BY T.TeklifTarihi DESC;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifSec] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifSec]
    @TeklifNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TalepID INT;
    DECLARE @SecilenTeklifID INT;

    SELECT
        @SecilenTeklifID = T.TeklifID,
        @TalepID = T.TalepID
    FROM dbo.Teklifler T
    WHERE T.TeklifNo = @TeklifNo;

    IF @SecilenTeklifID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen teklif bulunamadı.', 1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE dbo.Teklifler
        SET TeklifDurumID =
            CASE
                WHEN TeklifID = @SecilenTeklifID THEN 1
                ELSE 2
            END
        WHERE TalepID = @TalepID;

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 2
        WHERE TalepID = @TalepID;

        COMMIT TRANSACTION;

        SELECT
            T.TeklifNo,
            CASE T.TeklifDurumID
                WHEN 0 THEN N'İnceleniyor'
                WHEN 1 THEN N'Seçildi'
                WHEN 2 THEN N'Reddedildi'
            END AS TeklifDurumu
        FROM dbo.Teklifler T
        WHERE T.TalepID = @TalepID
        ORDER BY T.TeklifTutari;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TeklifSil] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TeklifSil]
    @TeklifID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Teklifler
            WHERE TeklifID = @TeklifID
        )
        BEGIN
            THROW 50011, N'Silinecek teklif bulunamadı.', 1;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Teklifler
            WHERE TeklifID = @TeklifID
              AND TeklifDurumID <> 0
        )
        BEGIN
            THROW 50012,
                  N'Yalnızca Girildi durumundaki teklifler silinebilir.',
                  1;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.SatinAlmaSiparisleri
            WHERE TeklifID = @TeklifID
        )
        BEGIN
            THROW 50013,
                  N'Siparişe bağlı olan teklif silinemez.',
                  1;
        END;

        BEGIN TRANSACTION;

        DELETE FROM dbo.TeklifKalemleri
        WHERE TeklifID = @TeklifID;

        DELETE FROM dbo.Teklifler
        WHERE TeklifID = @TeklifID
          AND TeklifDurumID = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50014, N'Teklif silinemedi.', 1;
        END;

        COMMIT TRANSACTION;

        SELECT
            CAST(1 AS BIT) AS Basarili,
            N'Teklif başarıyla silindi.' AS Mesaj;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_TumBildirimleriOkunduYap] Betik Tarihi: 17.07.2026 14:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TumBildirimleriOkunduYap]
    @KullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Bildirimler
    SET
        OkunduMu = 1,
        OkunmaTarihi = GETDATE()
    WHERE KullaniciID = @KullaniciID
      AND OkunduMu = 0;
END;
GO
USE [master]
GO
ALTER DATABASE [PizzaSatinAlmaDB] SET  READ_WRITE 
GO
