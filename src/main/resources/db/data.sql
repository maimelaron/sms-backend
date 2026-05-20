-- ============================================================
-- Interface Innovators High School — Seed Data
-- HOW TO RUN:
--   1. Start the Spring Boot backend first (so Hibernate creates tables)
--   2. Open MySQL Workbench and connect to localhost
--   3. Select the 'sms_db' schema
--   4. Paste and run this entire script
-- ============================================================

USE sms_db;

-- Clear existing data (safe to re-run)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE student;
TRUNCATE TABLE parent;
TRUNCATE TABLE user;
TRUNCATE TABLE trip;
TRUNCATE TABLE announcement;
TRUNCATE TABLE document_request;
SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------
-- USERS
-- Roles: SUPER_ADMIN, ADMIN, PARENT, TEACHER
-- Passwords stored as plain text (academic project)
-- --------------------------------------------------------
INSERT INTO `user` (`id`, `full_name`, `email`, `password_hash`, `phone_number`, `role`, `active`, `created_at`) VALUES
(1, 'Super Administrator', 'superadmin@school.ac.za', 'Super@123',   '0110000000', 'SUPER_ADMIN', TRUE, NOW()),
(2, 'System Admin',        'admin@school.ac.za',      'Admin@123',   '0110000001', 'ADMIN',       TRUE, NOW()),
(3, 'James Khumalo',       'james@parent.com',        'Parent@123',  '0820000002', 'PARENT',      TRUE, NOW()),
(4, 'Lerato Dlamini',      'lerato@parent.com',       'Parent@123',  '0830000003', 'PARENT',      TRUE, NOW()),
(5, 'Sarah Nkosi',         'sarah@school.ac.za',      'Teacher@123', '0840000004', 'TEACHER',     TRUE, NOW());

-- --------------------------------------------------------
-- PARENTS (linked to user accounts)
-- --------------------------------------------------------
INSERT INTO `parent` (`id`, `user_id`, `full_name`, `email`, `phone_number`, `address`, `created_at`) VALUES
(1, 3, 'James Khumalo',  'james@parent.com',  '0820000002', '12 Maple Street, Soweto',  NOW()),
(2, 4, 'Lerato Dlamini', 'lerato@parent.com', '0830000003', '45 Oak Avenue, Sandton',   NOW());

-- --------------------------------------------------------
-- STUDENTS
-- --------------------------------------------------------
INSERT INTO `student` (`id`, `name`, `surname`, `gender`, `date_of_birth`, `birth_certificate_id`, `grade`, `year_of_admission`, `parent_id`, `status`, `created_at`) VALUES
(1, 'Ayanda',  'Khumalo', 'MALE',   '2012-03-15', 'BC-2012-001', '8',  2024, 1, 'APPROVED', NOW()),
(2, 'Zanele',  'Dlamini', 'FEMALE', '2010-07-22', 'BC-2010-002', '10', 2022, 2, 'APPROVED', NOW()),
(3, 'Tebogo',  'Khumalo', 'MALE',   '2013-01-18', 'BC-2013-003', '7',  2025, 1, 'PENDING',  NOW());

-- --------------------------------------------------------
-- TRIPS
-- --------------------------------------------------------
INSERT INTO `trip` (`id`, `title`, `description`, `destination`, `price`, `trip_date`, `eligible_grades_str`, `active`, `created_at`) VALUES
(1, 'Science Museum Visit',    'Annual science excursion to Sci-Bono Discovery Centre.', 'Johannesburg',   250.00, '2025-08-15', '7,8,9',        TRUE, NOW()),
(2, 'Drakensberg Hike',        'Two-day adventure hike in the Drakensberg mountains.',   'KwaZulu-Natal',  850.00, '2025-09-20', '10,11,12',     TRUE, NOW()),
(3, 'Cape Town Cultural Tour', 'History and culture tour of Cape Town and surroundings.','Cape Town',     3200.00, '2025-11-10', '8,9,10,11,12', TRUE, NOW());

-- --------------------------------------------------------
-- ANNOUNCEMENTS
-- --------------------------------------------------------
INSERT INTO `announcement` (`id`, `title`, `content`, `type`, `created_at`) VALUES
(1, 'Welcome Back!',         'Welcome back to the new academic year! We look forward to a productive year together.', 'GENERAL', NOW()),
(2, 'Term 2 Exams',          'Term 2 exams will be held from 18 to 29 August 2025. Prepare well!',                    'EXAM',    NOW()),
(3, 'Public Holiday Notice', 'School will be closed on 9 August 2025 for National Women''s Day.',                     'HOLIDAY', NOW()),
(4, 'Science Fair',          'Annual Science Fair on 5 September 2025. All grades are encouraged to participate.',   'GENERAL', NOW());

-- --------------------------------------------------------
-- Done
-- --------------------------------------------------------
SELECT 'Seed data loaded successfully!' AS Status;
