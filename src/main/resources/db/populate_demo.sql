-- ============================================================
-- SMS — Demo Data Population Script
-- Run AFTER setup_db.sql (database + tables must exist)
-- Safe to re-run: clears and re-inserts all data
-- ============================================================

USE sms_db;

-- disable FK checks so we can truncate freely
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE document;
TRUNCATE TABLE progress_record;
TRUNCATE TABLE trip_registration;
TRUNCATE TABLE meeting;
TRUNCATE TABLE payment;
TRUNCATE TABLE trip;
TRUNCATE TABLE application;
TRUNCATE TABLE student;
TRUNCATE TABLE `user`;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- USERS  (2 admins, 3 teachers, 6 parents)
-- ============================================================
INSERT INTO `user` (`id`,`first_name`,`last_name`,`email`,`password_hash`,`role`) VALUES
(1,  'Admin',    'System',    'admin@sms.ac.za',              'hashed_pw', 'ADMIN'),
(2,  'Priya',    'Naidoo',    'priya.naidoo@sms.ac.za',       'hashed_pw', 'ADMIN'),
(3,  'Sarah',    'Nkosi',     'sarah.nkosi@sms.ac.za',        'hashed_pw', 'TEACHER'),
(4,  'David',    'Mokoena',   'david.mokoena@sms.ac.za',      'hashed_pw', 'TEACHER'),
(5,  'Lindiwe',  'Dube',      'lindiwe.dube@sms.ac.za',       'hashed_pw', 'TEACHER'),
(6,  'James',    'Khumalo',   'james.khumalo@gmail.com',      'hashed_pw', 'PARENT'),
(7,  'Lerato',   'Dlamini',   'lerato.dlamini@gmail.com',     'hashed_pw', 'PARENT'),
(8,  'Nomsa',    'Sithole',   'nomsa.sithole@gmail.com',      'hashed_pw', 'PARENT'),
(9,  'Thabo',    'Molefe',    'thabo.molefe@gmail.com',       'hashed_pw', 'PARENT'),
(10, 'Zanele',   'Mahlangu',  'zanele.mahlangu@gmail.com',    'hashed_pw', 'PARENT'),
(11, 'Sipho',    'Zulu',      'sipho.zulu@gmail.com',         'hashed_pw', 'PARENT');

-- ============================================================
-- STUDENTS  (8 students across different grades)
-- ============================================================
INSERT INTO `student` (`id`,`student_number`,`first_name`,`last_name`,`date_of_birth`,`grade`,`parent_id`,`status`) VALUES
(1, 'STU-2025-001', 'Ayanda',   'Khumalo',  '2012-03-15', 'Grade 8',  6,  'ACTIVE'),
(2, 'STU-2025-002', 'Zanele',   'Dlamini',  '2010-07-22', 'Grade 10', 7,  'ACTIVE'),
(3, 'STU-2025-003', 'Sipho',    'Sithole',  '2011-11-08', 'Grade 9',  8,  'ACTIVE'),
(4, 'STU-2025-004', 'Palesa',   'Molefe',   '2009-05-30', 'Grade 11', 9,  'ACTIVE'),
(5, 'STU-2025-005', 'Tebogo',   'Khumalo',  '2013-01-18', 'Grade 7',  6,  'PENDING'),
(6, 'STU-2025-006', 'Mpho',     'Mahlangu', '2011-06-25', 'Grade 9',  10, 'ACTIVE'),
(7, 'STU-2025-007', 'Lesedi',   'Zulu',     '2010-09-14', 'Grade 10', 11, 'INACTIVE'),
(8, NULL,           'Dineo',    'Sithole',  '2014-02-28', 'Grade 6',  8,  'PENDING');

-- ============================================================
-- APPLICATIONS  (mix: 3 APPROVED, 4 PENDING, 2 REJECTED)
-- ============================================================
INSERT INTO `application` (`id`,`parent_id`,`student_first_name`,`student_last_name`,`date_of_birth`,`grade_applying_for`,`status`,`reviewed_by`,`reviewed_at`,`rejection_reason`) VALUES
(1,  6,  'Ayanda',  'Khumalo',   '2012-03-15', 'Grade 8',  'APPROVED', 1, '2025-01-10 09:00:00', NULL),
(2,  7,  'Zanele',  'Dlamini',   '2010-07-22', 'Grade 10', 'APPROVED', 1, '2025-01-10 09:30:00', NULL),
(3,  8,  'Sipho',   'Sithole',   '2011-11-08', 'Grade 9',  'APPROVED', 2, '2025-01-11 10:00:00', NULL),
(4,  9,  'Palesa',  'Molefe',    '2009-05-30', 'Grade 11', 'PENDING',  NULL, NULL, NULL),
(5,  6,  'Tebogo',  'Khumalo',   '2013-01-18', 'Grade 7',  'PENDING',  NULL, NULL, NULL),
(6,  10, 'Mpho',    'Mahlangu',  '2011-06-25', 'Grade 9',  'PENDING',  NULL, NULL, NULL),
(7,  11, 'Lesedi',  'Zulu',      '2010-09-14', 'Grade 10', 'PENDING',  NULL, NULL, NULL),
(8,  7,  'Kagiso',  'Dlamini',   '2008-04-12', 'Grade 12', 'REJECTED', 1, '2025-01-12 11:00:00', 'Incomplete documentation submitted.'),
(9,  8,  'Dineo',   'Sithole',   '2014-02-28', 'Grade 6',  'REJECTED', 2, '2025-01-13 14:00:00', 'Grade capacity full for the requested year.');

-- ============================================================
-- TRIPS  (3 OPEN, 1 CLOSED, 1 CANCELLED)
-- ============================================================
INSERT INTO `trip` (`id`,`title`,`destination`,`description`,`trip_date`,`return_date`,`cost`,`max_participants`,`created_by`,`status`) VALUES
(1, 'Science Museum Visit',    'Johannesburg',  'Annual excursion to Sci-Bono Discovery Centre.',           '2025-04-15', '2025-04-15', 250.00,  40, 1, 'OPEN'),
(2, 'Drakensberg Hike',        'KwaZulu-Natal', 'Two-day adventure hike in the Drakensberg mountains.',     '2025-05-20', '2025-05-21', 850.00,  20, 1, 'OPEN'),
(3, 'Cape Town Cultural Tour', 'Cape Town',     'History and culture tour of Cape Town and surroundings.',  '2025-07-10', '2025-07-14', 3200.00, 30, 1, 'OPEN'),
(4, 'Kruger Park Safari',      'Mpumalanga',    'Wildlife safari at Kruger National Park.',                 '2025-03-01', '2025-03-03', 1500.00, 25, 2, 'CLOSED'),
(5, 'Robben Island Visit',     'Cape Town',     'Historical tour of Robben Island.',                        '2025-02-14', '2025-02-14', 400.00,  35, 2, 'CANCELLED');

-- ============================================================
-- PAYMENTS  (mix of statuses and types)
-- ============================================================
INSERT INTO `payment` (`id`,`student_id`,`parent_id`,`amount`,`payment_type`,`status`,`reference_number`,`paid_at`) VALUES
(1, 1, 6,  5500.00, 'TUITION', 'SUCCESSFUL', 'REF-2025-001', '2025-01-15 10:00:00'),
(2, 2, 7,  5500.00, 'TUITION', 'SUCCESSFUL', 'REF-2025-002', '2025-01-15 11:00:00'),
(3, 3, 8,  5500.00, 'TUITION', 'SUCCESSFUL', 'REF-2025-003', '2025-01-16 09:00:00'),
(4, 4, 9,  5500.00, 'TUITION', 'PENDING',    'REF-2025-004', NULL),
(5, 5, 6,  5500.00, 'TUITION', 'PENDING',    'REF-2025-005', NULL),
(6, 6, 10, 5500.00, 'TUITION', 'FAILED',     'REF-2025-006', NULL),
(7, 1, 6,   250.00, 'TRIP',    'SUCCESSFUL', 'REF-2025-007', '2025-03-10 08:00:00'),
(8, 2, 7,   850.00, 'TRIP',    'PENDING',    'REF-2025-008', NULL),
(9, 3, 8,   850.00, 'TRIP',    'PENDING',    'REF-2025-009', NULL),
(10,4, 9,   150.00, 'OTHER',   'SUCCESSFUL', 'REF-2025-010', '2025-02-20 12:00:00');

-- ============================================================
-- MEETINGS  (mix: 3 PENDING, 2 APPROVED, 1 REJECTED)
-- ============================================================
INSERT INTO `meeting` (`id`,`parent_id`,`teacher_id`,`student_id`,`requested_date`,`requested_time`,`status`,`confirmed_date`,`confirmed_time`,`notes`) VALUES
(1, 6,  3, 1, '2025-03-20', '14:00:00', 'PENDING',  NULL,         NULL,         NULL),
(2, 7,  4, 2, '2025-03-22', '10:00:00', 'APPROVED', '2025-03-22', '10:00:00',   'Please bring latest report card.'),
(3, 8,  3, 3, '2025-03-25', '09:00:00', 'PENDING',  NULL,         NULL,         NULL),
(4, 9,  5, 4, '2025-03-26', '11:00:00', 'APPROVED', '2025-03-26', '11:30:00',   'Discuss term 1 progress.'),
(5, 10, 4, 6, '2025-03-28', '15:00:00', 'PENDING',  NULL,         NULL,         NULL),
(6, 11, 5, 7, '2025-03-18', '13:00:00', 'REJECTED', NULL,         NULL,         NULL);

-- ============================================================
-- PROGRESS RECORDS  (multiple subjects per student)
-- ============================================================
INSERT INTO `progress_record` (`id`,`student_id`,`teacher_id`,`subject`,`term`,`year`,`mark`,`comment`) VALUES
(1,  1, 3, 'Mathematics',     'TERM_1', 2025, 78.50, 'Good progress, needs to work on algebra.'),
(2,  1, 4, 'Life Sciences',   'TERM_1', 2025, 82.00, 'Excellent participation in class.'),
(3,  1, 5, 'English',         'TERM_1', 2025, 75.00, 'Strong reading skills.'),
(4,  2, 3, 'Mathematics',     'TERM_1', 2025, 91.00, 'Outstanding performance.'),
(5,  2, 4, 'Physical Science','TERM_1', 2025, 88.00, 'Very strong analytical skills.'),
(6,  3, 5, 'Mathematics',     'TERM_1', 2025, 65.00, 'Struggling with equations, extra support recommended.'),
(7,  3, 3, 'English',         'TERM_1', 2025, 72.00, 'Improving steadily.'),
(8,  4, 4, 'Mathematics',     'TERM_1', 2025, 88.50, 'Consistent and hardworking.'),
(9,  4, 5, 'Life Sciences',   'TERM_1', 2025, 94.00, 'Top of the class.'),
(10, 6, 3, 'Mathematics',     'TERM_1', 2025, 70.00, 'Average performance, can improve.');

-- ============================================================
SELECT '✅ Demo data loaded successfully!' AS result;
SELECT '---' AS '';
SELECT 'users'            AS `table`, COUNT(*) AS records FROM `user`            UNION ALL
SELECT 'students',                    COUNT(*)             FROM `student`         UNION ALL
SELECT 'applications',                COUNT(*)             FROM `application`     UNION ALL
SELECT 'trips',                       COUNT(*)             FROM `trip`            UNION ALL
SELECT 'payments',                    COUNT(*)             FROM `payment`         UNION ALL
SELECT 'meetings',                    COUNT(*)             FROM `meeting`         UNION ALL
SELECT 'progress_records',            COUNT(*)             FROM `progress_record`;
