-- ============================================================
-- Drop existing tables in reverse dependency order
-- ============================================================
IF OBJECT_ID('Media', 'U') IS NOT NULL DROP TABLE [Media];
IF OBJECT_ID('Reviews', 'U') IS NOT NULL DROP TABLE [Reviews];
IF OBJECT_ID('ChatMessages', 'U') IS NOT NULL DROP TABLE [ChatMessages];
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE [Payments];
IF OBJECT_ID('YachtBookings', 'U') IS NOT NULL DROP TABLE [YachtBookings];
IF OBJECT_ID('TourBookings', 'U') IS NOT NULL DROP TABLE [TourBookings];
IF OBJECT_ID('Tours', 'U') IS NOT NULL DROP TABLE [Tours];
IF OBJECT_ID('YachtAds', 'U') IS NOT NULL DROP TABLE [YachtAds];
IF OBJECT_ID('Vacancies', 'U') IS NOT NULL DROP TABLE [Vacancies];
IF OBJECT_ID('Resumes', 'U') IS NOT NULL DROP TABLE [Resumes];
IF OBJECT_ID('UserProfiles', 'U') IS NOT NULL DROP TABLE [UserProfiles];
IF OBJECT_ID('UserRoles', 'U') IS NOT NULL DROP TABLE [UserRoles];
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE [Roles];
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE [Users];
IF OBJECT_ID('Races', 'U') IS NOT NULL DROP TABLE [Races];
IF OBJECT_ID('News', 'U') IS NOT NULL DROP TABLE [News];
IF OBJECT_ID('MapLocations', 'U') IS NOT NULL DROP TABLE [MapLocations];
GO

-- ============================================================
-- Create tables (English column names)
-- ============================================================

-- Users
CREATE TABLE [Users] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [email] NVARCHAR(150) NOT NULL UNIQUE,
    [password_hash] NVARCHAR(128) NOT NULL,
    [first_name] NVARCHAR(50) NULL,
    [last_name] NVARCHAR(50) NULL,
    [city] NVARCHAR(100) NULL,
    [skill_level] NVARCHAR(20) NULL,
    [phone] NVARCHAR(20) NULL,
    [photo_url] NVARCHAR(MAX) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO

-- Roles
CREATE TABLE [Roles] (
    [id] TINYINT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(20) NOT NULL UNIQUE
);
GO

-- UserRoles
CREATE TABLE [UserRoles] (
    [user_id] BIGINT NOT NULL,
    [role_id] TINYINT NOT NULL,
    CONSTRAINT PK_UserRoles PRIMARY KEY ([user_id], [role_id]),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY ([role_id]) REFERENCES [Roles]([id]) ON DELETE CASCADE
);
GO
CREATE INDEX IX_UserRoles_User ON [UserRoles]([user_id]);
CREATE INDEX IX_UserRoles_Role ON [UserRoles]([role_id]);
GO

-- UserProfiles
CREATE TABLE [UserProfiles] (
    [user_id] BIGINT NOT NULL PRIMARY KEY,
    [description] NVARCHAR(MAX) NULL,
    [experience] NVARCHAR(MAX) NULL,
    [certificates] NVARCHAR(MAX) NULL,
    [preferences] NVARCHAR(MAX) NULL,
    CONSTRAINT FK_UserProfiles_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE CASCADE
);
GO

-- Resumes
CREATE TABLE [Resumes] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [user_id] BIGINT NOT NULL,
    [title] NVARCHAR(255) NULL,
    [description] NVARCHAR(MAX) NULL,
    [skill_level] NVARCHAR(20) NULL,
    [years_experience] TINYINT NULL,
    [certificates] NVARCHAR(MAX) NULL,
    [desired_position] NVARCHAR(100) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Resumes_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE CASCADE
);
GO
CREATE INDEX IX_Resumes_User ON [Resumes]([user_id]);
GO

-- Vacancies
CREATE TABLE [Vacancies] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [captain_id] BIGINT NOT NULL,
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [required_skill_level] NVARCHAR(20) NULL,
    [is_temporary] BIT NOT NULL DEFAULT 0,
    [start_date] DATE NULL,
    [end_date] DATE NULL,
    [departure_city] NVARCHAR(100) NULL,
    [crew_count] INT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'active' CHECK ([status] IN ('active', 'closed', 'cancelled')),
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Vacancies_Users FOREIGN KEY ([captain_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION
);
GO
CREATE INDEX IX_Vacancies_Captain ON [Vacancies]([captain_id]);
CREATE INDEX IX_Vacancies_Status ON [Vacancies]([status]);
GO

-- YachtAds
CREATE TABLE [YachtAds] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [owner_id] BIGINT NOT NULL,
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [ad_type] NVARCHAR(10) NOT NULL CHECK ([ad_type] IN ('sale', 'rent')),
    [price] DECIMAL(12,2) NULL,
    [currency] NVARCHAR(3) NULL DEFAULT 'RUB',
    [yacht_type] NVARCHAR(30) NULL,
    [length] DECIMAL(5,2) NULL,
    [year_built] SMALLINT NULL,
    [engine_power] NVARCHAR(50) NULL,
    [cabins] TINYINT NULL,
    [is_available] BIT NOT NULL DEFAULT 1,
    [available_from] DATE NULL,
    [available_to] DATE NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'moderated' CHECK ([status] IN ('active', 'archived', 'moderated')),
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_YachtAds_Users FOREIGN KEY ([owner_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_available_dates CHECK (([available_from] IS NULL AND [available_to] IS NULL) OR ([available_from] <= [available_to]))
);
GO
CREATE INDEX IX_YachtAds_Owner ON [YachtAds]([owner_id]);
CREATE INDEX IX_YachtAds_Status ON [YachtAds]([status]);
CREATE INDEX IX_YachtAds_Available ON [YachtAds]([is_available]);
CREATE INDEX IX_YachtAds_Dates ON [YachtAds]([available_from], [available_to]);
GO

-- Tours
CREATE TABLE [Tours] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [organizer_id] BIGINT NOT NULL,
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [destination] NVARCHAR(255) NULL,
    [tour_type] NVARCHAR(20) NULL CHECK ([tour_type] IN ('cruise', 'excursion', 'river')),
    [price] DECIMAL(12,2) NOT NULL,
    [currency] NVARCHAR(3) NOT NULL DEFAULT 'RUB',
    [duration_days] TINYINT NOT NULL CHECK ([duration_days] > 0),
    [included_services] NVARCHAR(MAX) NULL,
    [max_participants] TINYINT NOT NULL CHECK ([max_participants] > 0),
    [available_from] DATE NOT NULL,
    [available_to] DATE NOT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'moderated' CHECK ([status] IN ('active', 'archived', 'moderated')),
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Tours_Users FOREIGN KEY ([organizer_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_Tours_dates CHECK ([available_from] <= [available_to])
);
GO
CREATE INDEX IX_Tours_Organizer ON [Tours]([organizer_id]);
CREATE INDEX IX_Tours_Status ON [Tours]([status]);
CREATE INDEX IX_Tours_Dates ON [Tours]([available_from], [available_to]);
GO

-- TourBookings
CREATE TABLE [TourBookings] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [user_id] BIGINT NOT NULL,
    [tour_id] BIGINT NOT NULL,
    [booking_date] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [start_date] DATE NOT NULL,
    [end_date] DATE NOT NULL,
    [participants_count] TINYINT NOT NULL CHECK ([participants_count] > 0),
    [total_amount] DECIMAL(12,2) NOT NULL,
    [service_fee] DECIMAL(12,2) NOT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([status] IN ('pending', 'confirmed', 'paid', 'cancelled', 'completed')),
    [payment_status] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([payment_status] IN ('pending', 'paid', 'failed')),
    [payment_id] NVARCHAR(255) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_TourBookings_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_TourBookings_Tours FOREIGN KEY ([tour_id]) REFERENCES [Tours]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_TourBookings_dates CHECK ([start_date] <= [end_date])
);
GO
CREATE INDEX IX_TourBookings_User ON [TourBookings]([user_id]);
CREATE INDEX IX_TourBookings_Tour ON [TourBookings]([tour_id]);
CREATE INDEX IX_TourBookings_Status ON [TourBookings]([status]);
GO

-- YachtBookings
CREATE TABLE [YachtBookings] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [yacht_ad_id] BIGINT NOT NULL,
    [renter_id] BIGINT NOT NULL,
    [start_date] DATE NOT NULL,
    [end_date] DATE NOT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([status] IN ('pending', 'confirmed', 'cancelled', 'completed')),
    [total_amount] DECIMAL(12,2) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_YachtBookings_YachtAds FOREIGN KEY ([yacht_ad_id]) REFERENCES [YachtAds]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_YachtBookings_Users FOREIGN KEY ([renter_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_YachtBookings_dates CHECK ([start_date] <= [end_date])
);
GO
CREATE INDEX IX_YachtBookings_Yacht ON [YachtBookings]([yacht_ad_id]);
CREATE INDEX IX_YachtBookings_Renter ON [YachtBookings]([renter_id]);
CREATE INDEX IX_YachtBookings_Dates ON [YachtBookings]([start_date], [end_date]);
CREATE INDEX IX_YachtBookings_Status ON [YachtBookings]([status]);
GO

-- Payments
CREATE TABLE [Payments] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [user_id] BIGINT NOT NULL,
    [booking_id] BIGINT NULL,
    [amount] DECIMAL(12,2) NOT NULL,
    [currency] NVARCHAR(3) NOT NULL DEFAULT 'RUB',
    [payment_type] NVARCHAR(20) NOT NULL CHECK ([payment_type] IN ('service_fee', 'donation')),
    [status] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([status] IN ('pending', 'completed', 'failed')),
    [gateway_transaction_id] NVARCHAR(255) NULL,
    [payment_date] DATETIME2 NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Payments_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Payments_TourBookings FOREIGN KEY ([booking_id]) REFERENCES [TourBookings]([id]) ON DELETE SET NULL
);
GO
CREATE INDEX IX_Payments_User ON [Payments]([user_id]);
CREATE INDEX IX_Payments_Booking ON [Payments]([booking_id]);
GO

-- ChatMessages
CREATE TABLE [ChatMessages] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [sender_id] BIGINT NOT NULL,
    [receiver_id] BIGINT NOT NULL,
    [message] NVARCHAR(MAX) NOT NULL,
    [is_read] BIT NOT NULL DEFAULT 0,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_ChatMessages_Sender FOREIGN KEY ([sender_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_ChatMessages_Receiver FOREIGN KEY ([receiver_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_ChatMessages_not_self CHECK ([sender_id] <> [receiver_id])
);
GO
CREATE INDEX IX_ChatMessages_Sender ON [ChatMessages]([sender_id]);
CREATE INDEX IX_ChatMessages_Receiver ON [ChatMessages]([receiver_id]);
CREATE INDEX IX_ChatMessages_Date ON [ChatMessages]([created_at]);
GO

-- Reviews (without CHECK constraint on tour_id or yacht_ad_id)
CREATE TABLE [Reviews] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [author_id] BIGINT NOT NULL,
    [target_user_id] BIGINT NOT NULL,
    [tour_id] BIGINT NULL,
    [yacht_ad_id] BIGINT NULL,
    [rating] TINYINT NOT NULL CHECK ([rating] BETWEEN 1 AND 5),
    [comment] NVARCHAR(MAX) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Reviews_Author FOREIGN KEY ([author_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Reviews_TargetUser FOREIGN KEY ([target_user_id]) REFERENCES [Users]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Reviews_Tour FOREIGN KEY ([tour_id]) REFERENCES [Tours]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Reviews_YachtAd FOREIGN KEY ([yacht_ad_id]) REFERENCES [YachtAds]([id]) ON DELETE NO ACTION
);
GO
CREATE INDEX IX_Reviews_Author ON [Reviews]([author_id]);
CREATE INDEX IX_Reviews_Target ON [Reviews]([target_user_id]);
CREATE INDEX IX_Reviews_Tour ON [Reviews]([tour_id]);
CREATE INDEX IX_Reviews_YachtAd ON [Reviews]([yacht_ad_id]);
GO

-- Races
CREATE TABLE [Races] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [city] NVARCHAR(100) NULL,
    [start_date] DATE NOT NULL,
    [end_date] DATE NOT NULL,
    [race_type] NVARCHAR(50) NULL,
    [age_group] NVARCHAR(50) NULL,
    [organizer_contact] NVARCHAR(255) NULL,
    [registration_link] NVARCHAR(255) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT CHK_Races_dates CHECK ([start_date] <= [end_date])
);
GO
CREATE INDEX IX_Races_Date ON [Races]([start_date], [end_date]);
CREATE INDEX IX_Races_City ON [Races]([city]);
GO

-- News
CREATE TABLE [News] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [title] NVARCHAR(255) NOT NULL,
    [content] NVARCHAR(MAX) NOT NULL,
    [published_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'draft' CHECK ([status] IN ('draft', 'published', 'archived')),
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [updated_at] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO
CREATE INDEX IX_News_Status ON [News]([status]);
CREATE INDEX IX_News_Date ON [News]([published_at]);
GO

-- MapLocations
CREATE TABLE [MapLocations] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [latitude] DECIMAL(10,8) NOT NULL,
    [longitude] DECIMAL(11,8) NOT NULL,
    [location_type] NVARCHAR(20) NOT NULL CHECK ([location_type] IN ('marina', 'anchorage', 'port')),
    [description] NVARCHAR(MAX) NULL,
    [services] NVARCHAR(MAX) NULL,
    [depth] DECIMAL(5,2) NULL,
    [contact_phone] NVARCHAR(20) NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO
CREATE INDEX IX_MapLocations_Type ON [MapLocations]([location_type]);
CREATE INDEX IX_MapLocations_Coordinates ON [MapLocations]([latitude], [longitude]);
GO

-- Media
CREATE TABLE [Media] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [yacht_ad_id] BIGINT NULL,
    [tour_id] BIGINT NULL,
    [race_id] BIGINT NULL,
    [news_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [file_url] NVARCHAR(MAX) NOT NULL,
    [file_type] NVARCHAR(20) NOT NULL CHECK ([file_type] IN ('image', 'video')),
    [is_main] BIT NOT NULL DEFAULT 0,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Media_YachtAds FOREIGN KEY ([yacht_ad_id]) REFERENCES [YachtAds]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Media_Tours FOREIGN KEY ([tour_id]) REFERENCES [Tours]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Media_Races FOREIGN KEY ([race_id]) REFERENCES [Races]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Media_News FOREIGN KEY ([news_id]) REFERENCES [News]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Media_Users FOREIGN KEY ([user_id]) REFERENCES [Users]([id]) ON DELETE CASCADE,
    CONSTRAINT CHK_Media_one_entity CHECK (
        (CASE WHEN [yacht_ad_id] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [tour_id] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [race_id] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [news_id] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [user_id] IS NOT NULL THEN 1 ELSE 0 END) = 1
    )
);
GO
CREATE INDEX IX_Media_YachtAd ON [Media]([yacht_ad_id]);
CREATE INDEX IX_Media_Tour ON [Media]([tour_id]);
CREATE INDEX IX_Media_Race ON [Media]([race_id]);
CREATE INDEX IX_Media_News ON [Media]([news_id]);
CREATE INDEX IX_Media_User ON [Media]([user_id]);
GO

PRINT 'Database YachtingPlatform (English column names) successfully created.';
GO