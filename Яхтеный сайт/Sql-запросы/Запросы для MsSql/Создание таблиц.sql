-- ============================================================
-- Удаление существующих таблиц (в обратном порядке зависимостей)
-- ============================================================
IF OBJECT_ID('Медиа', 'U') IS NOT NULL DROP TABLE [Медиа];
IF OBJECT_ID('Отзывы', 'U') IS NOT NULL DROP TABLE [Отзывы];
IF OBJECT_ID('СообщенияЧата', 'U') IS NOT NULL DROP TABLE [СообщенияЧата];
IF OBJECT_ID('Платежи', 'U') IS NOT NULL DROP TABLE [Платежи];
IF OBJECT_ID('БронированияЯхт', 'U') IS NOT NULL DROP TABLE [БронированияЯхт];
IF OBJECT_ID('БронированияТуров', 'U') IS NOT NULL DROP TABLE [БронированияТуров];
IF OBJECT_ID('Туры', 'U') IS NOT NULL DROP TABLE [Туры];
IF OBJECT_ID('ОбъявленияЯхт', 'U') IS NOT NULL DROP TABLE [ОбъявленияЯхт];
IF OBJECT_ID('Вакансии', 'U') IS NOT NULL DROP TABLE [Вакансии];
IF OBJECT_ID('Анкеты', 'U') IS NOT NULL DROP TABLE [Анкеты];
IF OBJECT_ID('ПрофилиПользователей', 'U') IS NOT NULL DROP TABLE [ПрофилиПользователей];
IF OBJECT_ID('РолиПользователей', 'U') IS NOT NULL DROP TABLE [РолиПользователей];
IF OBJECT_ID('Роли', 'U') IS NOT NULL DROP TABLE [Роли];
IF OBJECT_ID('Пользователи', 'U') IS NOT NULL DROP TABLE [Пользователи];
IF OBJECT_ID('Гонки', 'U') IS NOT NULL DROP TABLE [Гонки];
IF OBJECT_ID('Новости', 'U') IS NOT NULL DROP TABLE [Новости];
IF OBJECT_ID('МестаНаКарте', 'U') IS NOT NULL DROP TABLE [МестаНаКарте];
GO

-- ============================================================
-- Создание таблиц (структура)
-- ============================================================

-- Пользователи
CREATE TABLE [Пользователи] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [эл_почта] NVARCHAR(150) NOT NULL UNIQUE,
    [хэш_пароля] NVARCHAR(128) NOT NULL,
    [имя] NVARCHAR(50) NULL,
    [фамилия] NVARCHAR(50) NULL,
    [город] NVARCHAR(100) NULL,
    [уровень_подготовки] NVARCHAR(20) NULL,
    [телефон] NVARCHAR(20) NULL,
    [ссылка_на_фото] NVARCHAR(MAX) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO

-- Роли
CREATE TABLE [Роли] (
    [id] TINYINT IDENTITY(1,1) PRIMARY KEY,
    [название] NVARCHAR(20) NOT NULL UNIQUE
);
GO

-- РолиПользователей
CREATE TABLE [РолиПользователей] (
    [id_пользователя] BIGINT NOT NULL,
    [id_роли] TINYINT NOT NULL,
    CONSTRAINT PK_РолиПользователей PRIMARY KEY ([id_пользователя], [id_роли]),
    CONSTRAINT FK_РолиПользователей_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_РолиПользователей_Роли FOREIGN KEY ([id_роли]) REFERENCES [Роли]([id]) ON DELETE CASCADE
);
GO
CREATE INDEX IX_РолиПользователей_Пользователь ON [РолиПользователей]([id_пользователя]);
CREATE INDEX IX_РолиПользователей_Роль ON [РолиПользователей]([id_роли]);
GO

-- ПрофилиПользователей
CREATE TABLE [ПрофилиПользователей] (
    [id_пользователя] BIGINT NOT NULL PRIMARY KEY,
    [описание] NVARCHAR(MAX) NULL,
    [опыт] NVARCHAR(MAX) NULL,
    [сертификаты] NVARCHAR(MAX) NULL,
    [предпочтения] NVARCHAR(MAX) NULL,
    CONSTRAINT FK_ПрофилиПользователей_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE CASCADE
);
GO

-- Анкеты
CREATE TABLE [Анкеты] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_пользователя] BIGINT NOT NULL,
    [заголовок] NVARCHAR(255) NULL,
    [описание] NVARCHAR(MAX) NULL,
    [уровень_подготовки] NVARCHAR(20) NULL,
    [лет_опыта] TINYINT NULL,
    [сертификаты] NVARCHAR(MAX) NULL,
    [желаемая_должность] NVARCHAR(100) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Анкеты_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE CASCADE
);
GO
CREATE INDEX IX_Анкеты_Пользователь ON [Анкеты]([id_пользователя]);
GO

-- Вакансии
CREATE TABLE [Вакансии] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_капитана] BIGINT NOT NULL,
    [заголовок] NVARCHAR(255) NOT NULL,
    [описание] NVARCHAR(MAX) NULL,
    [требуемый_уровень] NVARCHAR(20) NULL,
    [временная] BIT NOT NULL DEFAULT 0,
    [дата_начала] DATE NULL,
    [дата_окончания] DATE NULL,
    [город_отправления] NVARCHAR(100) NULL,
    [количество_экипажа] INT NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'active' CHECK ([статус] IN ('active', 'closed', 'cancelled')),
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Вакансии_Пользователи FOREIGN KEY ([id_капитана]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION
);
GO
CREATE INDEX IX_Вакансии_Капитан ON [Вакансии]([id_капитана]);
CREATE INDEX IX_Вакансии_Статус ON [Вакансии]([статус]);
GO

-- ОбъявленияЯхт
CREATE TABLE [ОбъявленияЯхт] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_владельца] BIGINT NOT NULL,
    [заголовок] NVARCHAR(255) NOT NULL,
    [описание] NVARCHAR(MAX) NULL,
    [тип_объявления] NVARCHAR(10) NOT NULL CHECK ([тип_объявления] IN ('sale', 'rent')),
    [цена] DECIMAL(12,2) NULL,
    [валюта] NVARCHAR(3) NULL DEFAULT 'RUB',
    [тип_яхты] NVARCHAR(30) NULL,
    [длина] DECIMAL(5,2) NULL,
    [год_постройки] SMALLINT NULL,
    [мощность_двигателя] NVARCHAR(50) NULL,
    [количество_кают] TINYINT NULL,
    [доступна] BIT NOT NULL DEFAULT 1,
    [доступна_с] DATE NULL,
    [доступна_по] DATE NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'moderated' CHECK ([статус] IN ('active', 'archived', 'moderated')),
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_ОбъявленияЯхт_Пользователи FOREIGN KEY ([id_владельца]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_доступна_даты CHECK (([доступна_с] IS NULL AND [доступна_по] IS NULL) OR ([доступна_с] <= [доступна_по]))
);
GO
CREATE INDEX IX_ОбъявленияЯхт_Владелец ON [ОбъявленияЯхт]([id_владельца]);
CREATE INDEX IX_ОбъявленияЯхт_Статус ON [ОбъявленияЯхт]([статус]);
CREATE INDEX IX_ОбъявленияЯхт_Доступна ON [ОбъявленияЯхт]([доступна]);
CREATE INDEX IX_ОбъявленияЯхт_Даты ON [ОбъявленияЯхт]([доступна_с], [доступна_по]);
GO

-- Туры
CREATE TABLE [Туры] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_организатора] BIGINT NOT NULL,
    [заголовок] NVARCHAR(255) NOT NULL,
    [описание] NVARCHAR(MAX) NULL,
    [направление] NVARCHAR(255) NULL,
    [тип_тура] NVARCHAR(20) NULL CHECK ([тип_тура] IN ('круиз', 'прогулка', 'речная')),
    [цена] DECIMAL(12,2) NOT NULL,
    [валюта] NVARCHAR(3) NOT NULL DEFAULT 'RUB',
    [продолжительность_дней] TINYINT NOT NULL CHECK ([продолжительность_дней] > 0),
    [включенные_услуги] NVARCHAR(MAX) NULL,
    [макс_участников] TINYINT NOT NULL CHECK ([макс_участников] > 0),
    [доступен_с] DATE NOT NULL,
    [доступен_по] DATE NOT NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'moderated' CHECK ([статус] IN ('active', 'archived', 'moderated')),
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Туры_Пользователи FOREIGN KEY ([id_организатора]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_Туры_даты CHECK ([доступен_с] <= [доступен_по])
);
GO
CREATE INDEX IX_Туры_Организатор ON [Туры]([id_организатора]);
CREATE INDEX IX_Туры_Статус ON [Туры]([статус]);
CREATE INDEX IX_Туры_Даты ON [Туры]([доступен_с], [доступен_по]);
GO

-- БронированияТуров
CREATE TABLE [БронированияТуров] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_пользователя] BIGINT NOT NULL,
    [id_тура] BIGINT NOT NULL,
    [дата_бронирования] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_начала] DATE NOT NULL,
    [дата_окончания] DATE NOT NULL,
    [количество_участников] TINYINT NOT NULL CHECK ([количество_участников] > 0),
    [общая_сумма] DECIMAL(12,2) NOT NULL,
    [сервисный_сбор] DECIMAL(12,2) NOT NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([статус] IN ('pending', 'confirmed', 'paid', 'cancelled', 'completed')),
    [статус_оплаты] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([статус_оплаты] IN ('pending', 'paid', 'failed')),
    [идентификатор_платежа] NVARCHAR(255) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_БронированияТуров_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_БронированияТуров_Туры FOREIGN KEY ([id_тура]) REFERENCES [Туры]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_БронированияТуров_даты CHECK ([дата_начала] <= [дата_окончания])
);
GO
CREATE INDEX IX_БронированияТуров_Пользователь ON [БронированияТуров]([id_пользователя]);
CREATE INDEX IX_БронированияТуров_Тур ON [БронированияТуров]([id_тура]);
CREATE INDEX IX_БронированияТуров_Статус ON [БронированияТуров]([статус]);
GO

-- БронированияЯхт
CREATE TABLE [БронированияЯхт] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_яхты] BIGINT NOT NULL,
    [id_арендатора] BIGINT NOT NULL,
    [дата_начала] DATE NOT NULL,
    [дата_окончания] DATE NOT NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([статус] IN ('pending', 'confirmed', 'cancelled', 'completed')),
    [общая_сумма] DECIMAL(12,2) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_БронированияЯхт_ОбъявленияЯхт FOREIGN KEY ([id_яхты]) REFERENCES [ОбъявленияЯхт]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_БронированияЯхт_Пользователи FOREIGN KEY ([id_арендатора]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_БронированияЯхт_даты CHECK ([дата_начала] <= [дата_окончания])
);
GO
CREATE INDEX IX_БронированияЯхт_Яхта ON [БронированияЯхт]([id_яхты]);
CREATE INDEX IX_БронированияЯхт_Арендатор ON [БронированияЯхт]([id_арендатора]);
CREATE INDEX IX_БронированияЯхт_Даты ON [БронированияЯхт]([дата_начала], [дата_окончания]);
CREATE INDEX IX_БронированияЯхт_Статус ON [БронированияЯхт]([статус]);
GO

-- Платежи
CREATE TABLE [Платежи] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_пользователя] BIGINT NOT NULL,
    [id_бронирования] BIGINT NULL,
    [сумма] DECIMAL(12,2) NOT NULL,
    [валюта] NVARCHAR(3) NOT NULL DEFAULT 'RUB',
    [тип_платежа] NVARCHAR(20) NOT NULL CHECK ([тип_платежа] IN ('service_fee', 'donation')),
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'pending' CHECK ([статус] IN ('pending', 'completed', 'failed')),
    [идентификатор_транзакции_шлюза] NVARCHAR(255) NULL,
    [дата_платежа] DATETIME2 NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Платежи_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Платежи_БронированияТуров FOREIGN KEY ([id_бронирования]) REFERENCES [БронированияТуров]([id]) ON DELETE SET NULL
);
GO
CREATE INDEX IX_Платежи_Пользователь ON [Платежи]([id_пользователя]);
CREATE INDEX IX_Платежи_Бронирование ON [Платежи]([id_бронирования]);
GO

-- СообщенияЧата
CREATE TABLE [СообщенияЧата] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_отправителя] BIGINT NOT NULL,
    [id_получателя] BIGINT NOT NULL,
    [сообщение] NVARCHAR(MAX) NOT NULL,
    [прочитано] BIT NOT NULL DEFAULT 0,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_СообщенияЧата_Отправитель FOREIGN KEY ([id_отправителя]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_СообщенияЧата_Получатель FOREIGN KEY ([id_получателя]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT CHK_Сообщения_не_себе CHECK ([id_отправителя] <> [id_получателя])
);
GO
CREATE INDEX IX_СообщенияЧата_Отправитель ON [СообщенияЧата]([id_отправителя]);
CREATE INDEX IX_СообщенияЧата_Получатель ON [СообщенияЧата]([id_получателя]);
CREATE INDEX IX_СообщенияЧата_Дата ON [СообщенияЧата]([дата_создания]);
GO

-- Отзывы (без ограничения CHECK на заполнение id_тура или id_объявления)
CREATE TABLE [Отзывы] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_автора] BIGINT NOT NULL,
    [id_целевого_пользователя] BIGINT NOT NULL,
    [id_тура] BIGINT NULL,
    [id_объявления] BIGINT NULL,
    [оценка] TINYINT NOT NULL CHECK ([оценка] BETWEEN 1 AND 5),
    [комментарий] NVARCHAR(MAX) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Отзывы_Автор FOREIGN KEY ([id_автора]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Отзывы_ЦелевойПользователь FOREIGN KEY ([id_целевого_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Отзывы_Тур FOREIGN KEY ([id_тура]) REFERENCES [Туры]([id]) ON DELETE NO ACTION,
    CONSTRAINT FK_Отзывы_Объявление FOREIGN KEY ([id_объявления]) REFERENCES [ОбъявленияЯхт]([id]) ON DELETE NO ACTION
    -- Ограничение CHK_Отзывы_цель удалено
);
GO
CREATE INDEX IX_Отзывы_Автор ON [Отзывы]([id_автора]);
CREATE INDEX IX_Отзывы_Целевой ON [Отзывы]([id_целевого_пользователя]);
CREATE INDEX IX_Отзывы_Тур ON [Отзывы]([id_тура]);
CREATE INDEX IX_Отзывы_Объявление ON [Отзывы]([id_объявления]);
GO

-- Гонки
CREATE TABLE [Гонки] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [заголовок] NVARCHAR(255) NOT NULL,
    [описание] NVARCHAR(MAX) NULL,
    [город] NVARCHAR(100) NULL,
    [дата_начала] DATE NOT NULL,
    [дата_окончания] DATE NOT NULL,
    [тип_гонки] NVARCHAR(50) NULL,
    [возрастная_группа] NVARCHAR(50) NULL,
    [контакты_организатора] NVARCHAR(255) NULL,
    [ссылка_регистрации] NVARCHAR(255) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT CHK_Гонки_даты CHECK ([дата_начала] <= [дата_окончания])
);
GO
CREATE INDEX IX_Гонки_Дата ON [Гонки]([дата_начала], [дата_окончания]);
CREATE INDEX IX_Гонки_Город ON [Гонки]([город]);
GO

-- Новости
CREATE TABLE [Новости] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [заголовок] NVARCHAR(255) NOT NULL,
    [содержание] NVARCHAR(MAX) NOT NULL,
    [дата_публикации] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [статус] NVARCHAR(20) NOT NULL DEFAULT 'draft' CHECK ([статус] IN ('draft', 'published', 'archived')),
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    [дата_обновления] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO
CREATE INDEX IX_Новости_Статус ON [Новости]([статус]);
CREATE INDEX IX_Новости_Дата ON [Новости]([дата_публикации]);
GO

-- МестаНаКарте
CREATE TABLE [МестаНаКарте] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [название] NVARCHAR(255) NOT NULL,
    [широта] DECIMAL(10,8) NOT NULL,
    [долгота] DECIMAL(11,8) NOT NULL,
    [тип_места] NVARCHAR(20) NOT NULL CHECK ([тип_места] IN ('marina', 'anchorage', 'port')),
    [описание] NVARCHAR(MAX) NULL,
    [услуги] NVARCHAR(MAX) NULL,
    [глубина] DECIMAL(5,2) NULL,
    [контактный_телефон] NVARCHAR(20) NULL,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL
);
GO
CREATE INDEX IX_МестаНаКарте_Тип ON [МестаНаКарте]([тип_места]);
CREATE INDEX IX_МестаНаКарте_Координаты ON [МестаНаКарте]([широта], [долгота]);
GO

-- Медиа
CREATE TABLE [Медиа] (
    [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [id_объявления] BIGINT NULL,
    [id_тура] BIGINT NULL,
    [id_гонки] BIGINT NULL,
    [id_новости] BIGINT NULL,
    [id_пользователя] BIGINT NULL,
    [ссылка_на_файл] NVARCHAR(MAX) NOT NULL,
    [тип_файла] NVARCHAR(20) NOT NULL CHECK ([тип_файла] IN ('image', 'video')),
    [главное_изображение] BIT NOT NULL DEFAULT 0,
    [дата_создания] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_Медиа_ОбъявленияЯхт FOREIGN KEY ([id_объявления]) REFERENCES [ОбъявленияЯхт]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Медиа_Туры FOREIGN KEY ([id_тура]) REFERENCES [Туры]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Медиа_Гонки FOREIGN KEY ([id_гонки]) REFERENCES [Гонки]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Медиа_Новости FOREIGN KEY ([id_новости]) REFERENCES [Новости]([id]) ON DELETE CASCADE,
    CONSTRAINT FK_Медиа_Пользователи FOREIGN KEY ([id_пользователя]) REFERENCES [Пользователи]([id]) ON DELETE CASCADE,
    CONSTRAINT CHK_Медиа_одна_сущность CHECK (
        (CASE WHEN [id_объявления] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [id_тура] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [id_гонки] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [id_новости] IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN [id_пользователя] IS NOT NULL THEN 1 ELSE 0 END) = 1
    )
);
GO
CREATE INDEX IX_Медиа_Объявление ON [Медиа]([id_объявления]);
CREATE INDEX IX_Медиа_Тур ON [Медиа]([id_тура]);
CREATE INDEX IX_Медиа_Гонка ON [Медиа]([id_гонки]);
CREATE INDEX IX_Медиа_Новость ON [Медиа]([id_новости]);
CREATE INDEX IX_Медиа_Пользователь ON [Медиа]([id_пользователя]);
GO

PRINT 'База данных YachtingPlatform успешно создана.';
GO