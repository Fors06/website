-- ============================================================
-- Insert test data (single batch, all variables declared upfront)
-- ============================================================

DECLARE 
    @admin_id BIGINT, @moder_id BIGINT, @organizer_id BIGINT, @captain_id BIGINT, @owner_id BIGINT, @user1_id BIGINT, @user2_id BIGINT,
    @tour1_id BIGINT, @tour2_id BIGINT, @tour3_id BIGINT, @tour4_id BIGINT, @tour5_id BIGINT,
    @booking1_id BIGINT, @booking2_id BIGINT, @booking3_id BIGINT, @booking4_id BIGINT, @booking5_id BIGINT,
    @yacht1_id BIGINT, @yacht2_id BIGINT, @yacht3_id BIGINT, @yacht4_id BIGINT,
    @race1_id BIGINT, @race2_id BIGINT, @race3_id BIGINT, @race4_id BIGINT, @race5_id BIGINT,
    @news1_id BIGINT, @news2_id BIGINT, @news3_id BIGINT, @news4_id BIGINT, @news5_id BIGINT;

-- 1. Roles
INSERT INTO [Roles] ([name]) VALUES
    ('admin'),
    ('moderator'),
    ('tour_organizer'),
    ('captain'),
    ('owner'),
    ('user');

-- 2. Users
INSERT INTO [Users] ([email], [password_hash], [first_name], [last_name], [city], [skill_level], [phone], [photo_url])
VALUES
    ('admin@yacht.ru', 'hash1', 'Alexey', 'Adminov', 'Moscow', 'professional', '+7-900-111-22-33', 'admin_avatar.jpg'),
    ('moder@yacht.ru', 'hash2', 'Maria', 'Moderatorova', 'Saint Petersburg', 'amateur', '+7-900-222-33-44', 'moder_avatar.jpg'),
    ('organizer@yacht.ru', 'hash3', 'Ivan', 'Organizatorov', 'Sochi', 'professional', '+7-900-333-44-55', 'org_avatar.jpg'),
    ('captain@yacht.ru', 'hash4', 'Petr', 'Captainov', 'Vladivostok', 'professional', '+7-900-444-55-66', 'cap_avatar.jpg'),
    ('owner@yacht.ru', 'hash5', 'Sergey', 'Ownerov', 'Kaliningrad', 'amateur', '+7-900-555-66-77', 'owner_avatar.jpg'),
    ('user1@yacht.ru', 'hash6', 'Elena', 'Ivanova', 'Moscow', 'beginner', '+7-900-666-77-88', 'user1_avatar.jpg'),
    ('user2@yacht.ru', 'hash7', 'Dmitry', 'Petrov', 'Saint Petersburg', 'amateur', '+7-900-777-88-99', 'user2_avatar.jpg');

-- 3. Store user IDs
SELECT @admin_id = [id] FROM [Users] WHERE [email] = 'admin@yacht.ru';
SELECT @moder_id = [id] FROM [Users] WHERE [email] = 'moder@yacht.ru';
SELECT @organizer_id = [id] FROM [Users] WHERE [email] = 'organizer@yacht.ru';
SELECT @captain_id = [id] FROM [Users] WHERE [email] = 'captain@yacht.ru';
SELECT @owner_id = [id] FROM [Users] WHERE [email] = 'owner@yacht.ru';
SELECT @user1_id = [id] FROM [Users] WHERE [email] = 'user1@yacht.ru';
SELECT @user2_id = [id] FROM [Users] WHERE [email] = 'user2@yacht.ru';

-- 4. UserRoles
INSERT INTO [UserRoles] ([user_id], [role_id])
VALUES
    (@admin_id, (SELECT [id] FROM [Roles] WHERE [name] = 'admin')),
    (@moder_id, (SELECT [id] FROM [Roles] WHERE [name] = 'moderator')),
    (@organizer_id, (SELECT [id] FROM [Roles] WHERE [name] = 'tour_organizer')),
    (@captain_id, (SELECT [id] FROM [Roles] WHERE [name] = 'captain')),
    (@owner_id, (SELECT [id] FROM [Roles] WHERE [name] = 'owner')),
    (@user1_id, (SELECT [id] FROM [Roles] WHERE [name] = 'user')),
    (@user2_id, (SELECT [id] FROM [Roles] WHERE [name] = 'user'));

-- 5. UserProfiles
INSERT INTO [UserProfiles] ([user_id], [description], [experience], [certificates], [preferences])
VALUES
    (@admin_id, 'Chief Administrator', '10 years in IT', 'Administration', 'Security'),
    (@moder_id, 'Content Moderator', '3 years in yachting', 'Moderation', 'Data cleanliness'),
    (@organizer_id, 'Tour organizer on the Black Sea', '5 years', 'Captain 3rd rank', 'Client comfort'),
    (@captain_id, 'Experienced long-distance captain', '12 years', 'Skipper 1st class', 'Speed regattas'),
    (@owner_id, 'Owner of several yachts', '8 years', 'Shipowner', 'Rent and sale'),
    (@user1_id, 'Lover of sea walks', '2 years', 'Basic course', 'Excursions'),
    (@user2_id, 'Beginner, wants to learn', '0 years', 'None', 'Training');

-- 6. Resumes
INSERT INTO [Resumes] ([user_id], [title], [description], [skill_level], [years_experience], [certificates], [desired_position])
VALUES
    (@captain_id, 'Captain for regattas', 'Looking for team to participate in races', 'professional', 12, 'Skipper', 'captain'),
    (@user1_id, 'Beginner sailor', 'Want to gain experience', 'beginner', 0, '', 'sailor'),
    (@user2_id, 'Amateur', 'Looking for crew for travels', 'amateur', 2, 'Rescuer', 'helmsman'),
    (@moder_id, 'Moderator and yachtsman', 'Can help with organization', 'amateur', 3, 'Shipmaster', 'assistant'),
    (@organizer_id, 'Tour organizer', 'Know routes and safety', 'professional', 5, 'Captain', 'organizer');

-- 7. Vacancies
INSERT INTO [Vacancies] ([captain_id], [title], [description], [required_skill_level], [is_temporary], [start_date], [end_date], [departure_city], [crew_count], [status])
VALUES
    (@captain_id, 'Team for regatta', 'Need 3 sailors for race', 'amateur', 1, '2026-08-01', '2026-08-10', 'Vladivostok', 3, 'active'),
    (@captain_id, 'Passage to Kamchatka', 'Looking for experienced navigator', 'professional', 0, '2026-09-01', '2026-09-20', 'Petropavlovsk-Kamchatsky', 1, 'active'),
    (@captain_id, 'Walk along the bay', 'Need 2 helmsmen for weekend', 'beginner', 1, '2026-07-15', '2026-07-17', 'Vladivostok', 2, 'closed'),
    (@organizer_id, 'River tour', 'Looking for guide-instructor', 'amateur', 1, '2026-08-05', '2026-08-12', 'Saint Petersburg', 1, 'active'),
    (@moder_id, 'Assistant in organization', 'Volunteer needed for regatta', 'beginner', 1, '2026-07-20', '2026-07-25', 'Sochi', 2, 'active');

-- 8. YachtAds
INSERT INTO [YachtAds] ([owner_id], [title], [description], [ad_type], [price], [currency], [yacht_type], [length], [year_built], [engine_power], [cabins], [is_available], [available_from], [available_to], [status])
VALUES
    (@owner_id, 'Sailing yacht Bavaria 50', 'Excellent condition, ready for rent', 'rent', 150000.00, 'RUB', 'sail', 15.5, 2020, '80 hp', 4, 1, '2026-06-01', '2026-09-30', 'active'),
    (@owner_id, 'Motor yacht Sunseeker', 'For sea cruises', 'rent', 200000.00, 'RUB', 'motor', 18.0, 2022, '300 hp', 3, 1, '2026-07-01', '2026-08-31', 'active'),
    (@owner_id, 'Catamaran Lagoon 46', 'Ideal for charter', 'rent', 180000.00, 'RUB', 'catamaran', 13.5, 2021, '2x40 hp', 5, 1, '2026-05-01', '2026-10-15', 'active'),
    (@owner_id, 'Yacht Jeanneau for sale', 'Best price, own', 'sale', 8500000.00, 'RUB', 'sail', 12.0, 2018, '60 hp', 3, 0, NULL, NULL, 'archived'),
    (@owner_id, 'Small boat rental', 'For fishing and river walks', 'rent', 5000.00, 'RUB', 'motor', 5.0, 2015, '20 hp', 1, 1, '2026-07-01', '2026-08-31', 'moderated');

SELECT @yacht1_id = [id] FROM [YachtAds] WHERE [title] = 'Sailing yacht Bavaria 50';
SELECT @yacht2_id = [id] FROM [YachtAds] WHERE [title] = 'Motor yacht Sunseeker';
SELECT @yacht3_id = [id] FROM [YachtAds] WHERE [title] = 'Catamaran Lagoon 46';
SELECT @yacht4_id = [id] FROM [YachtAds] WHERE [title] = 'Small boat rental';

-- 9. Tours
INSERT INTO [Tours] ([organizer_id], [title], [description], [destination], [tour_type], [price], [currency], [duration_days], [included_services], [max_participants], [available_from], [available_to], [status])
VALUES
    (@organizer_id, 'Black Sea cruise', '7 days of rest with visits to bays', 'Sochi – Novorossiysk', 'cruise', 120000.00, 'RUB', 7, 'Meals, insurance, instructor', 8, '2026-07-15', '2026-09-15', 'active'),
    (@organizer_id, 'Walk along the Gulf of Finland', 'One-day yacht tour', 'Saint Petersburg – Kronstadt', 'excursion', 35000.00, 'RUB', 1, 'Excursion, lunch', 12, '2026-08-01', '2026-09-01', 'active'),
    (@organizer_id, 'Rafting on the Volga River', 'Three-day rafting with stops', 'Tver – Rybinsk', 'river', 45000.00, 'RUB', 3, 'Transfer, tents, food', 10, '2026-07-20', '2026-08-20', 'active'),
    (@organizer_id, 'New Year''s cruise in the Caribbean', 'Exotic 14-day tour', 'Caribbean Sea', 'cruise', 450000.00, 'RUB', 14, 'All inclusive, flight', 16, '2026-12-20', '2027-01-10', 'moderated'),
    (@organizer_id, 'Family walk on Lake Baikal', '2 days on a sailing yacht', 'Baikal', 'excursion', 80000.00, 'RUB', 2, 'Fishing, sauna', 6, '2026-07-10', '2026-08-31', 'archived');

SELECT @tour1_id = [id] FROM [Tours] WHERE [title] = 'Black Sea cruise';
SELECT @tour2_id = [id] FROM [Tours] WHERE [title] = 'Walk along the Gulf of Finland';
SELECT @tour3_id = [id] FROM [Tours] WHERE [title] = 'Rafting on the Volga River';
SELECT @tour4_id = [id] FROM [Tours] WHERE [title] = 'New Year''s cruise in the Caribbean';
SELECT @tour5_id = [id] FROM [Tours] WHERE [title] = 'Family walk on Lake Baikal';

-- 10. TourBookings
INSERT INTO [TourBookings] ([user_id], [tour_id], [start_date], [end_date], [participants_count], [total_amount], [service_fee], [status], [payment_status], [payment_id])
VALUES
    (@user1_id, @tour1_id, '2026-07-20', '2026-07-27', 2, 240000.00, 24000.00, 'confirmed', 'paid', 'pay_001'),
    (@user2_id, @tour2_id, '2026-08-05', '2026-08-05', 1, 35000.00, 3500.00, 'paid', 'paid', 'pay_002'),
    (@moder_id, @tour3_id, '2026-08-01', '2026-08-03', 3, 135000.00, 13500.00, 'pending', 'pending', NULL),
    (@captain_id, @tour1_id, '2026-08-10', '2026-08-17', 4, 480000.00, 48000.00, 'cancelled', 'failed', 'pay_003'),
    (@admin_id, @tour5_id, '2026-07-15', '2026-07-16', 2, 160000.00, 16000.00, 'completed', 'paid', 'pay_004');

SELECT @booking1_id = [id] FROM [TourBookings] WHERE [payment_id] = 'pay_001';
SELECT @booking2_id = [id] FROM [TourBookings] WHERE [payment_id] = 'pay_002';
SELECT @booking3_id = [id] FROM [TourBookings] WHERE [payment_id] IS NULL;
SELECT @booking4_id = [id] FROM [TourBookings] WHERE [payment_id] = 'pay_003';
SELECT @booking5_id = [id] FROM [TourBookings] WHERE [payment_id] = 'pay_004';

-- 11. YachtBookings
INSERT INTO [YachtBookings] ([yacht_ad_id], [renter_id], [start_date], [end_date], [status], [total_amount])
VALUES
    (@yacht1_id, @user1_id, '2026-07-10', '2026-07-12', 'confirmed', 300000.00),
    (@yacht2_id, @user2_id, '2026-07-20', '2026-07-22', 'pending', 400000.00),
    (@yacht3_id, @moder_id, '2026-08-01', '2026-08-05', 'confirmed', 720000.00),
    (@yacht4_id, @captain_id, '2026-07-15', '2026-07-15', 'completed', 5000.00),
    (@yacht1_id, @admin_id, '2026-08-15', '2026-08-17', 'cancelled', 300000.00);

-- 12. Payments
INSERT INTO [Payments] ([user_id], [booking_id], [amount], [currency], [payment_type], [status], [gateway_transaction_id], [payment_date])
VALUES
    (@user1_id, @booking1_id, 24000.00, 'RUB', 'service_fee', 'completed', 'tx_001', GETDATE()),
    (@user2_id, @booking2_id, 3500.00, 'RUB', 'service_fee', 'completed', 'tx_002', GETDATE()),
    (@admin_id, @booking5_id, 16000.00, 'RUB', 'service_fee', 'completed', 'tx_003', GETDATE()),
    (@moder_id, NULL, 5000.00, 'RUB', 'donation', 'completed', 'tx_004', GETDATE()),
    (@captain_id, NULL, 1200.00, 'RUB', 'donation', 'pending', 'tx_005', NULL);

-- 13. ChatMessages
INSERT INTO [ChatMessages] ([sender_id], [receiver_id], [message], [is_read])
VALUES
    (@user1_id, @captain_id, 'Hello, I want to join the team', 1),
    (@captain_id, @user1_id, 'Great! Tell me about your experience', 0),
    (@organizer_id, @moder_id, 'Please check the new tour', 1),
    (@user2_id, @owner_id, 'What are the rental conditions?', 0),
    (@owner_id, @user2_id, 'Deposit 10000, hourly payment', 1);

-- 14. Reviews
INSERT INTO [Reviews] ([author_id], [target_user_id], [tour_id], [yacht_ad_id], [rating], [comment])
VALUES
    (@user1_id, @captain_id, NULL, NULL, 5, 'Great captain, everything went super!'),
    (@user2_id, @organizer_id, @tour2_id, NULL, 4, 'Tour was nice, but the weather let us down'),
    (@moder_id, @owner_id, NULL, @yacht1_id, 5, 'The yacht is in perfect condition!'),
    (@captain_id, @organizer_id, @tour1_id, NULL, 3, 'It was a bit noisy, but overall not bad'),
    (@admin_id, @moder_id, NULL, @yacht2_id, 4, 'Good yacht, but price is a bit high');

-- 15. Races
INSERT INTO [Races] ([title], [description], [city], [start_date], [end_date], [race_type], [age_group], [organizer_contact], [registration_link])
VALUES
    ('Vladivostok Cup', 'Annual regatta in the Peter the Great Bay', 'Vladivostok', '2026-08-10', '2026-08-12', 'regatta', 'amateurs', '+7-423-111-22-33', 'https://regatta.vl.ru'),
    ('Baltic Regatta', 'Cruiser yacht race along the route SPB – Helsinki', 'Saint Petersburg', '2026-09-01', '2026-09-05', 'cruiser', 'professionals', '+7-812-222-33-44', 'https://baltic-regatta.ru'),
    ('Black Sea Cup', 'Traditional race in Sochi', 'Sochi', '2026-07-20', '2026-07-22', 'match', 'all', '+7-862-333-44-55', 'https://sochi-cup.ru'),
    ('Volga Regatta', 'Race on the Volga River on sailing yachts', 'Kazan', '2026-07-25', '2026-07-27', 'river', 'amateurs', '+7-843-444-55-66', 'https://volgaregatta.ru'),
    ('Youth Regatta', 'For yachtsmen under 25 years old', 'Kaliningrad', '2026-08-15', '2026-08-17', 'dinghy', 'youth', '+7-401-555-66-77', 'https://youthregatta.ru');

SELECT @race1_id = [id] FROM [Races] WHERE [title] = 'Vladivostok Cup';
SELECT @race2_id = [id] FROM [Races] WHERE [title] = 'Baltic Regatta';
SELECT @race3_id = [id] FROM [Races] WHERE [title] = 'Black Sea Cup';
SELECT @race4_id = [id] FROM [Races] WHERE [title] = 'Volga Regatta';
SELECT @race5_id = [id] FROM [Races] WHERE [title] = 'Youth Regatta';

-- 16. News
INSERT INTO [News] ([title], [content], [status])
VALUES
    ('GIMS rule changes 2026', 'Updated navigation rules for small vessels...', 'published'),
    ('Winners of the Vladivostok Cup', 'Team "Sea Wolf" won in the bay...', 'published'),
    ('New season of tours on Baikal', 'Pre-order for August tours is open...', 'published'),
    ('Attention! Storm warning on the Black Sea', 'Strong winds expected in the coming days...', 'published'),
    ('Opening of a new marina in Sochi', 'New yacht port ready to receive vessels...', 'draft');

SELECT @news1_id = [id] FROM [News] WHERE [title] = 'GIMS rule changes 2026';
SELECT @news2_id = [id] FROM [News] WHERE [title] = 'Winners of the Vladivostok Cup';
SELECT @news3_id = [id] FROM [News] WHERE [title] = 'New season of tours on Baikal';
SELECT @news4_id = [id] FROM [News] WHERE [title] = 'Attention! Storm warning on the Black Sea';
SELECT @news5_id = [id] FROM [News] WHERE [title] = 'Opening of a new marina in Sochi';

-- 17. MapLocations
INSERT INTO [MapLocations] ([name], [latitude], [longitude], [location_type], [description], [services], [depth], [contact_phone])
VALUES
    ('Ultra Marina', 43.123456, 131.987654, 'marina', 'Modern yacht berth', 'Refueling, repair, shop', 8.0, '+7-423-111-22-33'),
    ('Baltic Pier', 59.932333, 30.302333, 'marina', 'Convenient parking in the center', 'Water, electricity', 6.5, '+7-812-222-33-44'),
    ('Quiet Roadstead', 44.567890, 38.123456, 'anchorage', 'Calm place for anchoring', 'Natural harbor', 12.0, NULL),
    ('Sochi Port', 43.587654, 39.724545, 'port', 'Major passenger port', 'Customs, shops', 10.0, '+7-862-333-44-55'),
    ('Amber Marina', 54.712345, 20.554321, 'marina', 'Berth for small vessels', 'Refueling, cafe', 5.0, '+7-401-555-66-77');

-- 18. Media
INSERT INTO [Media] ([yacht_ad_id], [tour_id], [race_id], [news_id], [user_id], [file_url], [file_type], [is_main])
VALUES
    (@yacht1_id, NULL, NULL, NULL, NULL, 'bavaria_1.jpg', 'image', 1),
    (@yacht1_id, NULL, NULL, NULL, NULL, 'bavaria_2.jpg', 'image', 0),
    (NULL, @tour1_id, NULL, NULL, NULL, 'black_sea_cruise.jpg', 'image', 1),
    (NULL, NULL, @race1_id, NULL, NULL, 'vl_regatta.jpg', 'image', 1),
    (NULL, NULL, NULL, @news1_id, NULL, 'gims_news.jpg', 'image', 1),
    (NULL, NULL, NULL, NULL, @admin_id, 'admin_avatar.jpg', 'image', 1),
    (NULL, NULL, NULL, NULL, @captain_id, 'captain_avatar.jpg', 'image', 1);

PRINT 'Test data successfully inserted.';
GO