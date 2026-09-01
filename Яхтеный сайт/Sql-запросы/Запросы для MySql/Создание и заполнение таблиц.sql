
-- 1. Создание базы данных FreeWind

CREATE DATABASE IF NOT EXISTS FreeWind
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE FreeWind;


-- 2. Удаление существующих таблиц

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Media;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS ChatMessages;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS YachtBookings;
DROP TABLE IF EXISTS TourBookings;
DROP TABLE IF EXISTS Tours;
DROP TABLE IF EXISTS YachtAds;
DROP TABLE IF EXISTS Vacancies;
DROP TABLE IF EXISTS Resumes;
DROP TABLE IF EXISTS UserProfiles;
DROP TABLE IF EXISTS UserRoles;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Races;
DROP TABLE IF EXISTS News;
DROP TABLE IF EXISTS MapLocations;

SET FOREIGN_KEY_CHECKS = 1;

-- 3. Создание таблиц

-- Пользователи
CREATE TABLE Users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    first_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NULL,
    city VARCHAR(100) NULL,
    skill_level VARCHAR(20) NULL,
    phone VARCHAR(20) NULL,
    photo_url TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Роли
CREATE TABLE Roles (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Связь пользователей и ролей (многие ко многим)
CREATE TABLE UserRoles (
    user_id BIGINT NOT NULL,
    role_id TINYINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_UserRoles_User ON UserRoles(user_id);
CREATE INDEX IX_UserRoles_Role ON UserRoles(role_id);

-- Профили пользователей (один к одному)
CREATE TABLE UserProfiles (
    user_id BIGINT NOT NULL PRIMARY KEY,
    description TEXT NULL,
    experience TEXT NULL,
    certificates TEXT NULL,
    preferences TEXT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Анкеты (резюме яхтсменов)
CREATE TABLE Resumes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NULL,
    description TEXT NULL,
    skill_level VARCHAR(20) NULL,
    years_experience TINYINT NULL,
    certificates TEXT NULL,
    desired_position VARCHAR(100) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Resumes_User ON Resumes(user_id);

-- Вакансии (поиск команды)
CREATE TABLE Vacancies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    captain_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    required_skill_level VARCHAR(20) NULL,
    is_temporary BOOLEAN DEFAULT FALSE NOT NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    departure_city VARCHAR(100) NULL,
    crew_count INT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (captain_id) REFERENCES Users(id) ON DELETE NO ACTION,
    CHECK (status IN ('active', 'closed', 'cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Vacancies_Captain ON Vacancies(captain_id);
CREATE INDEX IX_Vacancies_Status ON Vacancies(status);

-- Объявления о яхтах (аренда/продажа)
CREATE TABLE YachtAds (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    owner_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    ad_type VARCHAR(10) NOT NULL,
    price DECIMAL(12,2) NULL,
    currency VARCHAR(3) DEFAULT 'RUB',
    yacht_type VARCHAR(30) NULL,
    length DECIMAL(5,2) NULL,
    year_built SMALLINT NULL,
    engine_power VARCHAR(50) NULL,
    cabins TINYINT NULL,
    is_available BOOLEAN DEFAULT TRUE NOT NULL,
    available_from DATE NULL,
    available_to DATE NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'moderated',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES Users(id) ON DELETE NO ACTION,
    CHECK (ad_type IN ('sale', 'rent')),
    CHECK (status IN ('active', 'archived', 'moderated')),
    CHECK ((available_from IS NULL AND available_to IS NULL) OR (available_from <= available_to))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_YachtAds_Owner ON YachtAds(owner_id);
CREATE INDEX IX_YachtAds_Status ON YachtAds(status);
CREATE INDEX IX_YachtAds_Available ON YachtAds(is_available);
CREATE INDEX IX_YachtAds_Dates ON YachtAds(available_from, available_to);

-- Туры (предложения организаторов)
CREATE TABLE Tours (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    organizer_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    destination VARCHAR(255) NULL,
    tour_type VARCHAR(20) NULL,
    price DECIMAL(12,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'RUB',
    duration_days TINYINT NOT NULL,
    included_services TEXT NULL,
    max_participants TINYINT NOT NULL,
    available_from DATE NOT NULL,
    available_to DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'moderated',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES Users(id) ON DELETE NO ACTION,
    CHECK (tour_type IN ('cruise', 'excursion', 'river')),
    CHECK (duration_days > 0),
    CHECK (max_participants > 0),
    CHECK (status IN ('active', 'archived', 'moderated')),
    CHECK (available_from <= available_to)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Tours_Organizer ON Tours(organizer_id);
CREATE INDEX IX_Tours_Status ON Tours(status);
CREATE INDEX IX_Tours_Dates ON Tours(available_from, available_to);

-- Бронирования туров
CREATE TABLE TourBookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    tour_id BIGINT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    participants_count TINYINT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    service_fee DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    payment_id VARCHAR(255) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE NO ACTION,
    FOREIGN KEY (tour_id) REFERENCES Tours(id) ON DELETE NO ACTION,
    CHECK (participants_count > 0),
    CHECK (status IN ('pending', 'confirmed', 'paid', 'cancelled', 'completed')),
    CHECK (payment_status IN ('pending', 'paid', 'failed')),
    CHECK (start_date <= end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_TourBookings_User ON TourBookings(user_id);
CREATE INDEX IX_TourBookings_Tour ON TourBookings(tour_id);
CREATE INDEX IX_TourBookings_Status ON TourBookings(status);

-- Бронирования яхт
CREATE TABLE YachtBookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yacht_ad_id BIGINT NOT NULL,
    renter_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(12,2) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (yacht_ad_id) REFERENCES YachtAds(id) ON DELETE NO ACTION,
    FOREIGN KEY (renter_id) REFERENCES Users(id) ON DELETE NO ACTION,
    CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    CHECK (start_date <= end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_YachtBookings_Yacht ON YachtBookings(yacht_ad_id);
CREATE INDEX IX_YachtBookings_Renter ON YachtBookings(renter_id);
CREATE INDEX IX_YachtBookings_Dates ON YachtBookings(start_date, end_date);
CREATE INDEX IX_YachtBookings_Status ON YachtBookings(status);

-- Платежи (сервисный сбор и пожертвования)
CREATE TABLE Payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    booking_id BIGINT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'RUB',
    payment_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    gateway_transaction_id VARCHAR(255) NULL,
    payment_date DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE NO ACTION,
    FOREIGN KEY (booking_id) REFERENCES TourBookings(id) ON DELETE SET NULL,
    CHECK (payment_type IN ('service_fee', 'donation')),
    CHECK (status IN ('pending', 'completed', 'failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Payments_User ON Payments(user_id);
CREATE INDEX IX_Payments_Booking ON Payments(booking_id);

-- Сообщения чата
CREATE TABLE ChatMessages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sender_id BIGINT NOT NULL,
    receiver_id BIGINT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES Users(id) ON DELETE NO ACTION,
    FOREIGN KEY (receiver_id) REFERENCES Users(id) ON DELETE NO ACTION,
    CHECK (sender_id <> receiver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_ChatMessages_Sender ON ChatMessages(sender_id);
CREATE INDEX IX_ChatMessages_Receiver ON ChatMessages(receiver_id);
CREATE INDEX IX_ChatMessages_Date ON ChatMessages(created_at);

-- Отзывы (без ограничения на заполнение tour_id или yacht_ad_id)
CREATE TABLE Reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    author_id BIGINT NOT NULL,
    target_user_id BIGINT NOT NULL,
    tour_id BIGINT NULL,
    yacht_ad_id BIGINT NULL,
    rating TINYINT NOT NULL,
    comment TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Users(id) ON DELETE NO ACTION,
    FOREIGN KEY (target_user_id) REFERENCES Users(id) ON DELETE NO ACTION,
    FOREIGN KEY (tour_id) REFERENCES Tours(id) ON DELETE NO ACTION,
    FOREIGN KEY (yacht_ad_id) REFERENCES YachtAds(id) ON DELETE NO ACTION,
    CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Reviews_Author ON Reviews(author_id);
CREATE INDEX IX_Reviews_Target ON Reviews(target_user_id);
CREATE INDEX IX_Reviews_Tour ON Reviews(tour_id);
CREATE INDEX IX_Reviews_YachtAd ON Reviews(yacht_ad_id);

-- Гонки (расписание)
CREATE TABLE Races (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    city VARCHAR(100) NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    race_type VARCHAR(50) NULL,
    age_group VARCHAR(50) NULL,
    organizer_contact VARCHAR(255) NULL,
    registration_link VARCHAR(255) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CHECK (start_date <= end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Races_Date ON Races(start_date, end_date);
CREATE INDEX IX_Races_City ON Races(city);

-- Новости
CREATE TABLE News (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CHECK (status IN ('draft', 'published', 'archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_News_Status ON News(status);
CREATE INDEX IX_News_Date ON News(published_at);

-- Места на карте (причалы, марины, рейды)
CREATE TABLE MapLocations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    location_type VARCHAR(20) NOT NULL,
    description TEXT NULL,
    services TEXT NULL,
    depth DECIMAL(5,2) NULL,
    contact_phone VARCHAR(20) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CHECK (location_type IN ('marina', 'anchorage', 'port'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_MapLocations_Type ON MapLocations(location_type);
CREATE INDEX IX_MapLocations_Coordinates ON MapLocations(latitude, longitude);

-- Медиа (фото/видео для разных сущностей)
CREATE TABLE Media (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yacht_ad_id BIGINT NULL,
    tour_id BIGINT NULL,
    race_id BIGINT NULL,
    news_id BIGINT NULL,
    user_id BIGINT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR(20) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (yacht_ad_id) REFERENCES YachtAds(id) ON DELETE CASCADE,
    FOREIGN KEY (tour_id) REFERENCES Tours(id) ON DELETE CASCADE,
    FOREIGN KEY (race_id) REFERENCES Races(id) ON DELETE CASCADE,
    FOREIGN KEY (news_id) REFERENCES News(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    CHECK (file_type IN ('image', 'video')),
    CHECK ( (yacht_ad_id IS NOT NULL) + (tour_id IS NOT NULL) + (race_id IS NOT NULL) + (news_id IS NOT NULL) + (user_id IS NOT NULL) = 1 )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE INDEX IX_Media_YachtAd ON Media(yacht_ad_id);
CREATE INDEX IX_Media_Tour ON Media(tour_id);
CREATE INDEX IX_Media_Race ON Media(race_id);
CREATE INDEX IX_Media_News ON Media(news_id);
CREATE INDEX IX_Media_User ON Media(user_id);


-- 4. Вставка тестовых данных


-- 4.1 Роли
INSERT INTO Roles (name) VALUES
    ('admin'),
    ('moderator'),
    ('tour_organizer'),
    ('captain'),
    ('owner'),
    ('user');

-- 4.2 Пользователи
INSERT INTO Users (email, password_hash, first_name, last_name, city, skill_level, phone, photo_url)
VALUES
    ('admin@yacht.ru', 'hash1', 'Alexey', 'Adminov', 'Moscow', 'professional', '+7-900-111-22-33', 'admin_avatar.jpg'),
    ('moder@yacht.ru', 'hash2', 'Maria', 'Moderatorova', 'Saint Petersburg', 'amateur', '+7-900-222-33-44', 'moder_avatar.jpg'),
    ('organizer@yacht.ru', 'hash3', 'Ivan', 'Organizatorov', 'Sochi', 'professional', '+7-900-333-44-55', 'org_avatar.jpg'),
    ('captain@yacht.ru', 'hash4', 'Petr', 'Captainov', 'Vladivostok', 'professional', '+7-900-444-55-66', 'cap_avatar.jpg'),
    ('owner@yacht.ru', 'hash5', 'Sergey', 'Ownerov', 'Kaliningrad', 'amateur', '+7-900-555-66-77', 'owner_avatar.jpg'),
    ('user1@yacht.ru', 'hash6', 'Elena', 'Ivanova', 'Moscow', 'beginner', '+7-900-666-77-88', 'user1_avatar.jpg'),
    ('user2@yacht.ru', 'hash7', 'Dmitry', 'Petrov', 'Saint Petersburg', 'amateur', '+7-900-777-88-99', 'user2_avatar.jpg');

-- 4.3 Сохраняем ID пользователей в переменные
SELECT @admin_id := id FROM Users WHERE email = 'admin@yacht.ru';
SELECT @moder_id := id FROM Users WHERE email = 'moder@yacht.ru';
SELECT @organizer_id := id FROM Users WHERE email = 'organizer@yacht.ru';
SELECT @captain_id := id FROM Users WHERE email = 'captain@yacht.ru';
SELECT @owner_id := id FROM Users WHERE email = 'owner@yacht.ru';
SELECT @user1_id := id FROM Users WHERE email = 'user1@yacht.ru';
SELECT @user2_id := id FROM Users WHERE email = 'user2@yacht.ru';

-- 4.4 Назначение ролей
INSERT INTO UserRoles (user_id, role_id)
VALUES
    (@admin_id, (SELECT id FROM Roles WHERE name = 'admin')),
    (@moder_id, (SELECT id FROM Roles WHERE name = 'moderator')),
    (@organizer_id, (SELECT id FROM Roles WHERE name = 'tour_organizer')),
    (@captain_id, (SELECT id FROM Roles WHERE name = 'captain')),
    (@owner_id, (SELECT id FROM Roles WHERE name = 'owner')),
    (@user1_id, (SELECT id FROM Roles WHERE name = 'user')),
    (@user2_id, (SELECT id FROM Roles WHERE name = 'user'));

-- 4.5 Профили пользователей
INSERT INTO UserProfiles (user_id, description, experience, certificates, preferences)
VALUES
    (@admin_id, 'Chief Administrator', '10 years in IT', 'Administration', 'Security'),
    (@moder_id, 'Content Moderator', '3 years in yachting', 'Moderation', 'Data cleanliness'),
    (@organizer_id, 'Tour organizer on the Black Sea', '5 years', 'Captain 3rd rank', 'Client comfort'),
    (@captain_id, 'Experienced long-distance captain', '12 years', 'Skipper 1st class', 'Speed regattas'),
    (@owner_id, 'Owner of several yachts', '8 years', 'Shipowner', 'Rent and sale'),
    (@user1_id, 'Lover of sea walks', '2 years', 'Basic course', 'Excursions'),
    (@user2_id, 'Beginner, wants to learn', '0 years', 'None', 'Training');

-- 4.6 Анкеты (резюме)
INSERT INTO Resumes (user_id, title, description, skill_level, years_experience, certificates, desired_position)
VALUES
    (@captain_id, 'Captain for regattas', 'Looking for team to participate in races', 'professional', 12, 'Skipper', 'captain'),
    (@user1_id, 'Beginner sailor', 'Want to gain experience', 'beginner', 0, '', 'sailor'),
    (@user2_id, 'Amateur', 'Looking for crew for travels', 'amateur', 2, 'Rescuer', 'helmsman'),
    (@moder_id, 'Moderator and yachtsman', 'Can help with organization', 'amateur', 3, 'Shipmaster', 'assistant'),
    (@organizer_id, 'Tour organizer', 'Know routes and safety', 'professional', 5, 'Captain', 'organizer');

-- 4.7 Вакансии
INSERT INTO Vacancies (captain_id, title, description, required_skill_level, is_temporary, start_date, end_date, departure_city, crew_count, status)
VALUES
    (@captain_id, 'Team for regatta', 'Need 3 sailors for race', 'amateur', TRUE, '2026-08-01', '2026-08-10', 'Vladivostok', 3, 'active'),
    (@captain_id, 'Passage to Kamchatka', 'Looking for experienced navigator', 'professional', FALSE, '2026-09-01', '2026-09-20', 'Petropavlovsk-Kamchatsky', 1, 'active'),
    (@captain_id, 'Walk along the bay', 'Need 2 helmsmen for weekend', 'beginner', TRUE, '2026-07-15', '2026-07-17', 'Vladivostok', 2, 'closed'),
    (@organizer_id, 'River tour', 'Looking for guide-instructor', 'amateur', TRUE, '2026-08-05', '2026-08-12', 'Saint Petersburg', 1, 'active'),
    (@moder_id, 'Assistant in organization', 'Volunteer needed for regatta', 'beginner', TRUE, '2026-07-20', '2026-07-25', 'Sochi', 2, 'active');

-- 4.8 Объявления о яхтах
INSERT INTO YachtAds (owner_id, title, description, ad_type, price, currency, yacht_type, length, year_built, engine_power, cabins, is_available, available_from, available_to, status)
VALUES
    (@owner_id, 'Sailing yacht Bavaria 50', 'Excellent condition, ready for rent', 'rent', 150000.00, 'RUB', 'sail', 15.5, 2020, '80 hp', 4, TRUE, '2026-06-01', '2026-09-30', 'active'),
    (@owner_id, 'Motor yacht Sunseeker', 'For sea cruises', 'rent', 200000.00, 'RUB', 'motor', 18.0, 2022, '300 hp', 3, TRUE, '2026-07-01', '2026-08-31', 'active'),
    (@owner_id, 'Catamaran Lagoon 46', 'Ideal for charter', 'rent', 180000.00, 'RUB', 'catamaran', 13.5, 2021, '2x40 hp', 5, TRUE, '2026-05-01', '2026-10-15', 'active'),
    (@owner_id, 'Yacht Jeanneau for sale', 'Best price, own', 'sale', 8500000.00, 'RUB', 'sail', 12.0, 2018, '60 hp', 3, FALSE, NULL, NULL, 'archived'),
    (@owner_id, 'Small boat rental', 'For fishing and river walks', 'rent', 5000.00, 'RUB', 'motor', 5.0, 2015, '20 hp', 1, TRUE, '2026-07-01', '2026-08-31', 'moderated');

SELECT @yacht1_id := id FROM YachtAds WHERE title = 'Sailing yacht Bavaria 50';
SELECT @yacht2_id := id FROM YachtAds WHERE title = 'Motor yacht Sunseeker';
SELECT @yacht3_id := id FROM YachtAds WHERE title = 'Catamaran Lagoon 46';
SELECT @yacht4_id := id FROM YachtAds WHERE title = 'Small boat rental';

-- 4.9 Туры
INSERT INTO Tours (organizer_id, title, description, destination, tour_type, price, currency, duration_days, included_services, max_participants, available_from, available_to, status)
VALUES
    (@organizer_id, 'Black Sea cruise', '7 days of rest with visits to bays', 'Sochi – Novorossiysk', 'cruise', 120000.00, 'RUB', 7, 'Meals, insurance, instructor', 8, '2026-07-15', '2026-09-15', 'active'),
    (@organizer_id, 'Walk along the Gulf of Finland', 'One-day yacht tour', 'Saint Petersburg – Kronstadt', 'excursion', 35000.00, 'RUB', 1, 'Excursion, lunch', 12, '2026-08-01', '2026-09-01', 'active'),
    (@organizer_id, 'Rafting on the Volga River', 'Three-day rafting with stops', 'Tver – Rybinsk', 'river', 45000.00, 'RUB', 3, 'Transfer, tents, food', 10, '2026-07-20', '2026-08-20', 'active'),
    (@organizer_id, 'New Year''s cruise in the Caribbean', 'Exotic 14-day tour', 'Caribbean Sea', 'cruise', 450000.00, 'RUB', 14, 'All inclusive, flight', 16, '2026-12-20', '2027-01-10', 'moderated'),
    (@organizer_id, 'Family walk on Lake Baikal', '2 days on a sailing yacht', 'Baikal', 'excursion', 80000.00, 'RUB', 2, 'Fishing, sauna', 6, '2026-07-10', '2026-08-31', 'archived');

SELECT @tour1_id := id FROM Tours WHERE title = 'Black Sea cruise';
SELECT @tour2_id := id FROM Tours WHERE title = 'Walk along the Gulf of Finland';
SELECT @tour3_id := id FROM Tours WHERE title = 'Rafting on the Volga River';
SELECT @tour4_id := id FROM Tours WHERE title = 'New Year''s cruise in the Caribbean';
SELECT @tour5_id := id FROM Tours WHERE title = 'Family walk on Lake Baikal';

-- 4.10 Бронирования туров
INSERT INTO TourBookings (user_id, tour_id, start_date, end_date, participants_count, total_amount, service_fee, status, payment_status, payment_id)
VALUES
    (@user1_id, @tour1_id, '2026-07-20', '2026-07-27', 2, 240000.00, 24000.00, 'confirmed', 'paid', 'pay_001'),
    (@user2_id, @tour2_id, '2026-08-05', '2026-08-05', 1, 35000.00, 3500.00, 'paid', 'paid', 'pay_002'),
    (@moder_id, @tour3_id, '2026-08-01', '2026-08-03', 3, 135000.00, 13500.00, 'pending', 'pending', NULL),
    (@captain_id, @tour1_id, '2026-08-10', '2026-08-17', 4, 480000.00, 48000.00, 'cancelled', 'failed', 'pay_003'),
    (@admin_id, @tour5_id, '2026-07-15', '2026-07-16', 2, 160000.00, 16000.00, 'completed', 'paid', 'pay_004');

SELECT @booking1_id := id FROM TourBookings WHERE payment_id = 'pay_001';
SELECT @booking2_id := id FROM TourBookings WHERE payment_id = 'pay_002';
SELECT @booking3_id := id FROM TourBookings WHERE payment_id IS NULL;
SELECT @booking4_id := id FROM TourBookings WHERE payment_id = 'pay_003';
SELECT @booking5_id := id FROM TourBookings WHERE payment_id = 'pay_004';

-- 4.11 Бронирования яхт
INSERT INTO YachtBookings (yacht_ad_id, renter_id, start_date, end_date, status, total_amount)
VALUES
    (@yacht1_id, @user1_id, '2026-07-10', '2026-07-12', 'confirmed', 300000.00),
    (@yacht2_id, @user2_id, '2026-07-20', '2026-07-22', 'pending', 400000.00),
    (@yacht3_id, @moder_id, '2026-08-01', '2026-08-05', 'confirmed', 720000.00),
    (@yacht4_id, @captain_id, '2026-07-15', '2026-07-15', 'completed', 5000.00),
    (@yacht1_id, @admin_id, '2026-08-15', '2026-08-17', 'cancelled', 300000.00);

-- 4.12 Платежи
INSERT INTO Payments (user_id, booking_id, amount, currency, payment_type, status, gateway_transaction_id, payment_date)
VALUES
    (@user1_id, @booking1_id, 24000.00, 'RUB', 'service_fee', 'completed', 'tx_001', NOW()),
    (@user2_id, @booking2_id, 3500.00, 'RUB', 'service_fee', 'completed', 'tx_002', NOW()),
    (@admin_id, @booking5_id, 16000.00, 'RUB', 'service_fee', 'completed', 'tx_003', NOW()),
    (@moder_id, NULL, 5000.00, 'RUB', 'donation', 'completed', 'tx_004', NOW()),
    (@captain_id, NULL, 1200.00, 'RUB', 'donation', 'pending', 'tx_005', NULL);

-- 4.13 Сообщения чата
INSERT INTO ChatMessages (sender_id, receiver_id, message, is_read)
VALUES
    (@user1_id, @captain_id, 'Hello, I want to join the team', TRUE),
    (@captain_id, @user1_id, 'Great! Tell me about your experience', FALSE),
    (@organizer_id, @moder_id, 'Please check the new tour', TRUE),
    (@user2_id, @owner_id, 'What are the rental conditions?', FALSE),
    (@owner_id, @user2_id, 'Deposit 10000, hourly payment', TRUE);

-- 4.14 Отзывы
INSERT INTO Reviews (author_id, target_user_id, tour_id, yacht_ad_id, rating, comment)
VALUES
    (@user1_id, @captain_id, NULL, NULL, 5, 'Great captain, everything went super!'),
    (@user2_id, @organizer_id, @tour2_id, NULL, 4, 'Tour was nice, but the weather let us down'),
    (@moder_id, @owner_id, NULL, @yacht1_id, 5, 'The yacht is in perfect condition!'),
    (@captain_id, @organizer_id, @tour1_id, NULL, 3, 'It was a bit noisy, but overall not bad'),
    (@admin_id, @moder_id, NULL, @yacht2_id, 4, 'Good yacht, but price is a bit high');

-- 4.15 Гонки
INSERT INTO Races (title, description, city, start_date, end_date, race_type, age_group, organizer_contact, registration_link)
VALUES
    ('Vladivostok Cup', 'Annual regatta in the Peter the Great Bay', 'Vladivostok', '2026-08-10', '2026-08-12', 'regatta', 'amateurs', '+7-423-111-22-33', 'https://regatta.vl.ru'),
    ('Baltic Regatta', 'Cruiser yacht race along the route SPB – Helsinki', 'Saint Petersburg', '2026-09-01', '2026-09-05', 'cruiser', 'professionals', '+7-812-222-33-44', 'https://baltic-regatta.ru'),
    ('Black Sea Cup', 'Traditional race in Sochi', 'Sochi', '2026-07-20', '2026-07-22', 'match', 'all', '+7-862-333-44-55', 'https://sochi-cup.ru'),
    ('Volga Regatta', 'Race on the Volga River on sailing yachts', 'Kazan', '2026-07-25', '2026-07-27', 'river', 'amateurs', '+7-843-444-55-66', 'https://volgaregatta.ru'),
    ('Youth Regatta', 'For yachtsmen under 25 years old', 'Kaliningrad', '2026-08-15', '2026-08-17', 'dinghy', 'youth', '+7-401-555-66-77', 'https://youthregatta.ru');

SELECT @race1_id := id FROM Races WHERE title = 'Vladivostok Cup';
SELECT @race2_id := id FROM Races WHERE title = 'Baltic Regatta';
SELECT @race3_id := id FROM Races WHERE title = 'Black Sea Cup';
SELECT @race4_id := id FROM Races WHERE title = 'Volga Regatta';
SELECT @race5_id := id FROM Races WHERE title = 'Youth Regatta';

-- 4.16 Новости
INSERT INTO News (title, content, status)
VALUES
    ('GIMS rule changes 2026', 'Updated navigation rules for small vessels...', 'published'),
    ('Winners of the Vladivostok Cup', 'Team "Sea Wolf" won in the bay...', 'published'),
    ('New season of tours on Baikal', 'Pre-order for August tours is open...', 'published'),
    ('Attention! Storm warning on the Black Sea', 'Strong winds expected in the coming days...', 'published'),
    ('Opening of a new marina in Sochi', 'New yacht port ready to receive vessels...', 'draft');

SELECT @news1_id := id FROM News WHERE title = 'GIMS rule changes 2026';
SELECT @news2_id := id FROM News WHERE title = 'Winners of the Vladivostok Cup';
SELECT @news3_id := id FROM News WHERE title = 'New season of tours on Baikal';
SELECT @news4_id := id FROM News WHERE title = 'Attention! Storm warning on the Black Sea';
SELECT @news5_id := id FROM News WHERE title = 'Opening of a new marina in Sochi';

-- 4.17 Места на карте
INSERT INTO MapLocations (name, latitude, longitude, location_type, description, services, depth, contact_phone)
VALUES
    ('Ultra Marina', 43.123456, 131.987654, 'marina', 'Modern yacht berth', 'Refueling, repair, shop', 8.0, '+7-423-111-22-33'),
    ('Baltic Pier', 59.932333, 30.302333, 'marina', 'Convenient parking in the center', 'Water, electricity', 6.5, '+7-812-222-33-44'),
    ('Quiet Roadstead', 44.567890, 38.123456, 'anchorage', 'Calm place for anchoring', 'Natural harbor', 12.0, NULL),
    ('Sochi Port', 43.587654, 39.724545, 'port', 'Major passenger port', 'Customs, shops', 10.0, '+7-862-333-44-55'),
    ('Amber Marina', 54.712345, 20.554321, 'marina', 'Berth for small vessels', 'Refueling, cafe', 5.0, '+7-401-555-66-77');

-- 4.18 Медиа
INSERT INTO Media (yacht_ad_id, tour_id, race_id, news_id, user_id, file_url, file_type, is_main)
VALUES
    (@yacht1_id, NULL, NULL, NULL, NULL, 'bavaria_1.jpg', 'image', TRUE),
    (@yacht1_id, NULL, NULL, NULL, NULL, 'bavaria_2.jpg', 'image', FALSE),
    (NULL, @tour1_id, NULL, NULL, NULL, 'black_sea_cruise.jpg', 'image', TRUE),
    (NULL, NULL, @race1_id, NULL, NULL, 'vl_regatta.jpg', 'image', TRUE),
    (NULL, NULL, NULL, @news1_id, NULL, 'gims_news.jpg', 'image', TRUE),
    (NULL, NULL, NULL, NULL, @admin_id, 'admin_avatar.jpg', 'image', TRUE),
    (NULL, NULL, NULL, NULL, @captain_id, 'captain_avatar.jpg', 'image', TRUE);

-- Готово
SELECT 'Database FreeWind successfully created and populated with test data.' AS Result;