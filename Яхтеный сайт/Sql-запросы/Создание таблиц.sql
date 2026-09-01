USE яхты;

-- Таблица пользователей
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    middle_name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL DEFAULT 'member',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица сотрудников
CREATE TABLE Employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    position NVARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Таблица посетителей
CREATE TABLE Visitors (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Таблица яхт
CREATE TABLE Boats (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    image NVARCHAR(255),
    capacity INT,
    price DECIMAL(10, 2),
    availability NVARCHAR(50) NOT NULL DEFAULT 'available',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица бронирований
CREATE TABLE Bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    visitors_id INT,
    boat_id INT,
    start_date DATETIME,
    end_date DATETIME,
    status NVARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (visitors_id) REFERENCES Visitors(id),
    FOREIGN KEY (boat_id) REFERENCES Boats(id)
);

-- Таблица новостей
CREATE TABLE News (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX),
    image NVARCHAR(255),
    published_at DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица команд
CREATE TABLE Teams (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    image NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица членов команд
CREATE TABLE TeamMembers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    team_id INT,
    visitors_id INT,
    role NVARCHAR(50) NOT NULL DEFAULT 'member',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (team_id) REFERENCES Teams(id),
    FOREIGN KEY (visitors_id) REFERENCES Visitors(id)
);

-- Таблица гонок
CREATE TABLE Races (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    date DATETIME,
    location NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица участников гонок
CREATE TABLE RaceParticipants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    race_id INT,
    team_id INT,
    boat_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (race_id) REFERENCES Races(id),
    FOREIGN KEY (team_id) REFERENCES Teams(id),
    FOREIGN KEY (boat_id) REFERENCES Boats(id)
);

-- Таблица контактов
CREATE TABLE Contacts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    message NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица туров
CREATE TABLE Tours (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    image NVARCHAR(255),
    price DECIMAL(10, 2),
    duration INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Таблица бронирований туров
CREATE TABLE TourBookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    visitors_id INT,
    tour_id INT,
    start_date DATETIME,
    end_date DATETIME,
    status NVARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (visitors_id) REFERENCES Visitors(id),
    FOREIGN KEY (tour_id) REFERENCES Tours(id)
);

-- Таблица отзывов
CREATE TABLE Reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    visitors_id INT,
    boat_id INT,
    rating INT,
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (visitors_id) REFERENCES Visitors(id),
    FOREIGN KEY (boat_id) REFERENCES Boats(id)
);

-- Таблица избранных яхт
CREATE TABLE Favorites (
    id INT IDENTITY(1,1) PRIMARY KEY,
    visitors_id INT,
    boat_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (visitors_id) REFERENCES Visitors(id),
    FOREIGN KEY (boat_id) REFERENCES Boats(id)
);

-- Таблица настроек пользователей
CREATE TABLE UserSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    language NVARCHAR(5),
    notification_settings NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Таблица тегов
CREATE TABLE Tags (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица тегов яхт
CREATE TABLE BoatTags (
    id INT IDENTITY(1,1) PRIMARY KEY,
    boat_id INT,
    tag_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (boat_id) REFERENCES Boats(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

-- Таблица тегов туров
CREATE TABLE TourTags (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tour_id INT,
    tag_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (tour_id) REFERENCES Tours(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

-- Таблица файлов
CREATE TABLE Files (
    id INT IDENTITY(1,1) PRIMARY KEY,
    filename NVARCHAR(255) NOT NULL,
    filetype NVARCHAR(50),
    filepath NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица файлов яхт
CREATE TABLE BoatFiles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    boat_id INT,
    file_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (boat_id) REFERENCES Boats(id),
    FOREIGN KEY (file_id) REFERENCES Files(id)
);

-- Таблица файлов туров
CREATE TABLE TourFiles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tour_id INT,
    file_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (tour_id) REFERENCES Tours(id),
    FOREIGN KEY (file_id) REFERENCES Files(id)
);

-- Таблица целей Яндекс.Метрики
CREATE TABLE Goals (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица настроек целей Яндекс.Метрики
CREATE TABLE GoalSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    goal_id INT,
    settings NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (goal_id) REFERENCES Goals(id)
);

-- Таблица редиректов
CREATE TABLE Redirects (
    id INT IDENTITY(1,1) PRIMARY KEY,
    old_url NVARCHAR(255) NOT NULL,
    new_url NVARCHAR(255) NOT NULL,
    status_code INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица настроек редиректов
CREATE TABLE RedirectSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    redirect_id INT,
    settings NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (redirect_id) REFERENCES Redirects(id)
);

-- Таблица счетчика Яндекс.Метрика
CREATE TABLE YandexMetric (
    id INT IDENTITY(1,1) PRIMARY KEY,
    counter_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица настроек счетчика Яндекс.Метрика
CREATE TABLE YandexMetricSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    yandex_metric_id INT,
    settings NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (yandex_metric_id) REFERENCES YandexMetric(id)
);

-- Таблица инструментов аналитики
CREATE TABLE AnalyticsTools (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

-- Таблица настроек инструментов аналитики
CREATE TABLE AnalyticsToolSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    analytics_tool_id INT,
    settings NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (analytics_tool_id) REFERENCES AnalyticsTools(id)
);

-- Таблица тегов инструментов аналитики
CREATE TABLE AnalyticsToolTags (
    id INT IDENTITY(1,1) PRIMARY KEY,
    analytics_tool_id INT,
    tag_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (analytics_tool_id) REFERENCES AnalyticsTools(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

-- Таблица файлов инструментов аналитики
CREATE TABLE AnalyticsToolFiles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    analytics_tool_id INT,
    file_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (analytics_tool_id) REFERENCES AnalyticsTools(id),
    FOREIGN KEY (file_id) REFERENCES Files(id)
);