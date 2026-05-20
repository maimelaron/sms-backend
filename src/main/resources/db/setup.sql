-- ============================================================
-- Interface Innovators High School — School Management System
-- FULL SETUP SCRIPT  (run this in MySQL Workbench)
--
-- What this does:
--   1. Drops and recreates the sms_db database
--   2. Creates all tables
--   3. Loads full demo data
--
-- Login credentials after running:
--   Super Admin : superadmin@school.ac.za / Super@123
--   Admin       : admin@school.ac.za      / Admin@123
--   Parent      : sarah.mokoena@parent.com / Parent@123
-- ============================================================


-- ============================================================
-- STEP 1: DROP & RECREATE DATABASE
-- ============================================================
DROP DATABASE IF EXISTS sms_db;
CREATE DATABASE sms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sms_db;


-- ============================================================
-- STEP 2: CREATE TABLES
-- ============================================================

CREATE TABLE `user` (
    `id`            BIGINT        NOT NULL AUTO_INCREMENT,
    `full_name`     VARCHAR(200)  NOT NULL,
    `email`         VARCHAR(150)  NOT NULL UNIQUE,
    `password_hash` VARCHAR(255)  NOT NULL,
    `phone_number`  VARCHAR(20),
    `role`          ENUM('PARENT','TEACHER','ADMIN','SUPER_ADMIN') NOT NULL DEFAULT 'PARENT',
    `active`        BOOLEAN       NOT NULL DEFAULT TRUE,
    `created_at`    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `parent` (
    `id`           BIGINT       NOT NULL AUTO_INCREMENT,
    `user_id`      BIGINT       NOT NULL UNIQUE,
    `full_name`    VARCHAR(200) NOT NULL,
    `email`        VARCHAR(150) NOT NULL,
    `phone_number` VARCHAR(20),
    `address`      TEXT,
    `created_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_parent_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `student` (
    `id`                    BIGINT       NOT NULL AUTO_INCREMENT,
    `name`                  VARCHAR(100) NOT NULL,
    `surname`               VARCHAR(100) NOT NULL,
    `gender`                ENUM('MALE','FEMALE','OTHER'),
    `date_of_birth`         DATE,
    `birth_certificate_id`  VARCHAR(50)  NOT NULL UNIQUE,
    `nationality`           VARCHAR(50),
    `grade`                 VARCHAR(10)  NOT NULL,
    `year_of_admission`     INT,
    `previous_school`       VARCHAR(200),
    `latest_school_report`  VARCHAR(500),
    `parent_id`             BIGINT       NOT NULL,
    `class_name`            VARCHAR(50),
    `teacher`               VARCHAR(100),
    `status`                ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `rejection_reason`      TEXT,
    `created_at`            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_student_parent` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `trip` (
    `id`                  BIGINT         NOT NULL AUTO_INCREMENT,
    `title`               VARCHAR(200)   NOT NULL,
    `description`         TEXT,
    `destination`         VARCHAR(200)   NOT NULL,
    `image_url`           LONGTEXT,
    `price`               DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    `trip_date`           DATE           NOT NULL,
    `eligible_grades_str` TEXT,
    `active`              BOOLEAN        NOT NULL DEFAULT TRUE,
    `created_at`          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `announcement` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `title`      VARCHAR(200) NOT NULL,
    `content`    TEXT         NOT NULL,
    `type`       ENUM('GENERAL','EXAM','URGENT','HOLIDAY') NOT NULL DEFAULT 'GENERAL',
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meeting` (
    `id`               BIGINT       NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(200) NOT NULL,
    `description`      TEXT,
    `scheduled_time`   DATETIME,
    `teacher_id`       VARCHAR(100),
    `teacher_name`     VARCHAR(200),
    `parent_id`        BIGINT,
    `parent_name`      VARCHAR(200),
    `type`             ENUM('ONE_ON_ONE','GROUP_MEETING') NOT NULL DEFAULT 'GROUP_MEETING',
    `status`           ENUM('PENDING','APPROVED','REJECTED','SCHEDULED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    `rejection_reason` TEXT,
    `created_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_meeting_parent` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `payment` (
    `id`             BIGINT        NOT NULL AUTO_INCREMENT,
    `student_id`     BIGINT        NOT NULL,
    `parent_id`      BIGINT        NOT NULL,
    `trip_id`        BIGINT        NOT NULL,
    `amount`         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `method`         VARCHAR(50),
    `status`         ENUM('PENDING','COMPLETED','FAILED') NOT NULL DEFAULT 'PENDING',
    `transaction_id` VARCHAR(100)  UNIQUE,
    `created_at`     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_payment_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
    CONSTRAINT `fk_payment_parent`  FOREIGN KEY (`parent_id`)  REFERENCES `parent`  (`id`),
    CONSTRAINT `fk_payment_trip`    FOREIGN KEY (`trip_id`)    REFERENCES `trip`    (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `trip_registration` (
    `id`                BIGINT    NOT NULL AUTO_INCREMENT,
    `trip_id`           BIGINT    NOT NULL,
    `student_id`        BIGINT    NOT NULL,
    `payment_id`        BIGINT,
    `consent_submitted` BOOLEAN   NOT NULL DEFAULT FALSE,
    `status`            ENUM('REGISTERED','CANCELLED') NOT NULL DEFAULT 'REGISTERED',
    `registered_at`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_tripreg_trip`    FOREIGN KEY (`trip_id`)    REFERENCES `trip`    (`id`),
    CONSTRAINT `fk_tripreg_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
    CONSTRAINT `fk_tripreg_payment` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `document_request` (
    `id`           BIGINT       NOT NULL AUTO_INCREMENT,
    `parent_id`    BIGINT       NOT NULL,
    `request_type` VARCHAR(100) NOT NULL,
    `description`  TEXT,
    `status`       ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `created_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_docreq_parent` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `document` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT,
    `student_id`    BIGINT,
    `parent_id`     BIGINT,
    `document_type` VARCHAR(100),
    `file_name`     VARCHAR(255),
    `file_url`      LONGTEXT,
    `description`   TEXT,
    `mime_type`     VARCHAR(100),
    `file_size`     BIGINT,
    `verified`      BOOLEAN      NOT NULL DEFAULT FALSE,
    `verified_by`   VARCHAR(200),
    `verified_at`   DATETIME,
    `uploaded_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================================
-- STEP 3: DEMO DATA
-- ============================================================

-- USERS
INSERT INTO `user` (`id`, `full_name`, `email`, `password_hash`, `phone_number`, `role`, `active`, `created_at`) VALUES
(1,  'Super Administrator', 'superadmin@school.ac.za',    'Super@123',   '0110001000', 'SUPER_ADMIN', TRUE, NOW()),
(2,  'Thembi Nkosi',        'admin@school.ac.za',         'Admin@123',   '0110001001', 'ADMIN',       TRUE, NOW()),
(3,  'Mr David Sithole',    'david.sithole@school.ac.za', 'Teacher@123', '0820001002', 'TEACHER',     TRUE, NOW()),
(4,  'Ms Grace Mohlala',    'grace.mohlala@school.ac.za', 'Teacher@123', '0830001003', 'TEACHER',     TRUE, NOW()),
(5,  'Mr Sipho Dlamini',    'sipho.dlamini@school.ac.za', 'Teacher@123', '0840001004', 'TEACHER',     TRUE, NOW()),
(6,  'Sarah Mokoena',       'sarah.mokoena@parent.com',   'Parent@123',  '0820001005', 'PARENT',      TRUE, NOW()),
(7,  'James Khumalo',       'james.khumalo@parent.com',   'Parent@123',  '0830001006', 'PARENT',      TRUE, NOW()),
(8,  'Lerato Dlamini',      'lerato.dlamini@parent.com',  'Parent@123',  '0840001007', 'PARENT',      TRUE, NOW()),
(9,  'Thandeka Zulu',       'thandeka.zulu@parent.com',   'Parent@123',  '0850001008', 'PARENT',      TRUE, NOW()),
(10, 'Mpho Molefe',         'mpho.molefe@parent.com',     'Parent@123',  '0860001009', 'PARENT',      TRUE, NOW()),
(11, 'Nomsa Shabalala',     'nomsa.shabalala@parent.com', 'Parent@123',  '0870001010', 'PARENT',      TRUE, NOW());

-- PARENTS
INSERT INTO `parent` (`id`, `user_id`, `full_name`, `email`, `phone_number`, `address`, `created_at`) VALUES
(1, 6,  'Sarah Mokoena',   'sarah.mokoena@parent.com',   '0820001005', '14 Acacia Street, Soweto, Johannesburg 1804',       NOW()),
(2, 7,  'James Khumalo',   'james.khumalo@parent.com',   '0830001006', '27 Bougainvillea Ave, Sandton, Johannesburg 2196',  NOW()),
(3, 8,  'Lerato Dlamini',  'lerato.dlamini@parent.com',  '0840001007', '5 Jacaranda Close, Pretoria East 0081',             NOW()),
(4, 9,  'Thandeka Zulu',   'thandeka.zulu@parent.com',   '0850001008', '88 Msunduzi Road, Pietermaritzburg 3201',           NOW()),
(5, 10, 'Mpho Molefe',     'mpho.molefe@parent.com',     '0860001009', '3 Sunflower Drive, Midrand, Johannesburg 1682',     NOW()),
(6, 11, 'Nomsa Shabalala', 'nomsa.shabalala@parent.com', '0870001010', '12 Protea Road, Boksburg, Ekurhuleni 1459',         NOW());

-- STUDENTS
INSERT INTO `student`
  (`id`, `name`, `surname`, `gender`, `date_of_birth`, `birth_certificate_id`, `nationality`, `grade`,
   `year_of_admission`, `previous_school`, `parent_id`, `class_name`, `teacher`, `status`, `rejection_reason`, `created_at`)
VALUES
(1,  'Amahle',     'Mokoena',   'FEMALE', '2013-04-12', 'BC-2013-0001', 'South African', '7',  2024, 'Soweto Primary School',    1, '7A',  'Mr David Sithole', 'APPROVED', NULL, NOW()),
(2,  'Lethiwe',    'Mokoena',   'MALE',   '2010-08-23', 'BC-2010-0002', 'South African', '10', 2021, 'Soweto Primary School',    1, '10B', 'Ms Grace Mohlala', 'APPROVED', NULL, NOW()),
(3,  'Siphelele',  'Mokoena',   'MALE',   '2015-01-07', 'BC-2015-0003', 'South African', '5',  2025, NULL,                       1, NULL,  NULL,               'PENDING',  NULL, NOW()),
(4,  'Ayanda',     'Khumalo',   'FEMALE', '2012-06-30', 'BC-2012-0004', 'South African', '8',  2023, 'Sandton Prep School',      2, '8A',  'Mr David Sithole', 'APPROVED', NULL, NOW()),
(5,  'Zakhele',    'Khumalo',   'MALE',   '2009-11-15', 'BC-2009-0005', 'South African', '11', 2020, 'Sandton Prep School',      2, '11A', 'Mr Sipho Dlamini', 'APPROVED', NULL, NOW()),
(6,  'Zanele',     'Dlamini',   'FEMALE', '2011-03-18', 'BC-2011-0006', 'South African', '9',  2022, 'Pretoria North Primary',   3, '9B',  'Ms Grace Mohlala', 'APPROVED', NULL, NOW()),
(7,  'Thabo',      'Dlamini',   'MALE',   '2014-09-02', 'BC-2014-0007', 'South African', '6',  2025, 'Pretoria North Primary',   3, NULL,  NULL,               'PENDING',  NULL, NOW()),
(8,  'Nandi',      'Dlamini',   'FEMALE', '2016-12-20', 'BC-2016-0008', 'South African', '4',  2025, NULL,                       3, NULL,  NULL,               'REJECTED', 'Incomplete birth certificate. Please resubmit with a certified copy.', NOW()),
(9,  'Sbusiso',    'Zulu',      'MALE',   '2008-07-04', 'BC-2008-0009', 'South African', '12', 2019, 'Pietermaritzburg High',    4, '12A', 'Mr Sipho Dlamini', 'APPROVED', NULL, NOW()),
(10, 'Nokwanda',   'Zulu',      'FEMALE', '2012-02-28', 'BC-2012-0010', 'South African', '8',  2023, 'Pietermaritzburg High',    4, '8B',  'Mr David Sithole', 'APPROVED', NULL, NOW()),
(11, 'Mthokozisi', 'Zulu',      'MALE',   '2015-05-16', 'BC-2015-0011', 'South African', '5',  2025, 'Umgungundlovu Primary',    4, NULL,  NULL,               'PENDING',  NULL, NOW()),
(12, 'Tebogo',     'Molefe',    'MALE',   '2013-10-10', 'BC-2013-0012', 'South African', '7',  2024, 'Midrand Junior School',    5, '7B',  'Mr David Sithole', 'APPROVED', NULL, NOW()),
(13, 'Kelebogile', 'Molefe',    'FEMALE', '2011-06-14', 'BC-2011-0013', 'South African', '9',  2022, 'Midrand Junior School',    5, '9A',  'Ms Grace Mohlala', 'APPROVED', NULL, NOW()),
(14, 'Otsile',     'Molefe',    'MALE',   '2016-03-03', 'BC-2016-0014', 'South African', '4',  2025, NULL,                       5, NULL,  NULL,               'REJECTED', 'Grade placement requires previous school records. Please provide certified report card.', NOW()),
(15, 'Lungelo',    'Shabalala', 'MALE',   '2010-12-25', 'BC-2010-0015', 'South African', '10', 2021, 'Boksburg Primary',         6, '10A', 'Ms Grace Mohlala', 'APPROVED', NULL, NOW()),
(16, 'Sifiso',     'Shabalala', 'MALE',   '2013-08-17', 'BC-2013-0016', 'South African', '7',  2024, 'Boksburg Primary',         6, '7C',  'Mr David Sithole', 'APPROVED', NULL, NOW()),
(17, 'Phumzile',   'Shabalala', 'FEMALE', '2015-04-29', 'BC-2015-0017', 'South African', '5',  2025, 'Boksburg Primary',         6, NULL,  NULL,               'PENDING',  NULL, NOW()),
(18, 'Ntuthuko',   'Shabalala', 'MALE',   '2017-09-11', 'BC-2017-0018', 'South African', '3',  2025, NULL,                       6, NULL,  NULL,               'PENDING',  NULL, NOW());

-- TRIPS
INSERT INTO `trip` (`id`, `title`, `description`, `destination`, `price`, `trip_date`, `eligible_grades_str`, `active`, `created_at`) VALUES
(1, 'Sci-Bono Science Museum',
   'An exciting day at the Sci-Bono Discovery Centre. Learners will engage with interactive science, technology and engineering exhibits. Lunch included.',
   'Newtown, Johannesburg', 280.00, '2025-08-15', '7,8,9', TRUE, NOW()),
(2, 'Drakensberg Hiking Adventure',
   'A two-day overnight hike in the breathtaking Drakensberg mountains. Includes transport, accommodation, all meals and a qualified guide.',
   'uKhahlamba-Drakensberg, KwaZulu-Natal', 950.00, '2025-09-19', '10,11,12', TRUE, NOW()),
(3, 'Apartheid Museum & Constitutional Hill',
   'A meaningful cultural and historical tour covering two of Johannesburg''s most significant heritage sites.',
   'Johannesburg', 320.00, '2025-10-10', '8,9,10,11,12', TRUE, NOW()),
(4, 'Cape Town Explorer',
   'Three-day trip to Cape Town. Includes Table Mountain, Robben Island, V&A Waterfront, Cape Point and Boulders Penguin Colony.',
   'Cape Town, Western Cape', 3500.00, '2025-11-21', '10,11,12', TRUE, NOW()),
(5, 'Walter Sisulu Botanical Garden',
   'A relaxing educational visit to the Walter Sisulu National Botanical Garden.',
   'Roodepoort, Johannesburg', 150.00, '2025-07-25', '4,5,6,7', FALSE, NOW());

-- ANNOUNCEMENTS
INSERT INTO `announcement` (`id`, `title`, `content`, `type`, `created_at`) VALUES
(1, 'Welcome to the 2025 Academic Year',
   'We warmly welcome all learners, parents and staff back to Interface Innovators High School. This year promises to be filled with exciting opportunities for growth, learning and achievement.',
   'GENERAL', NOW()),
(2, 'Term 3 Examination Schedule',
   'Term 3 examinations will be held from 18 to 29 August 2025. All learners must ensure they are in possession of their timetables. No late entries will be accepted.',
   'EXAM', NOW()),
(3, 'URGENT: School Closure – Burst Water Pipe',
   'Due to a burst water main on the school premises, the school will be closed on Wednesday 9 July 2025. All assessments scheduled for that day will be rescheduled.',
   'URGENT', NOW()),
(4, 'Public Holiday – National Women''s Day',
   'The school will be closed on Friday 8 August 2025 in observance of National Women''s Day. Normal classes resume on Monday 11 August 2025.',
   'HOLIDAY', NOW()),
(5, 'Annual Science Fair – Call for Entries',
   'The Annual Science Fair will take place on Friday 5 September 2025 in the school hall. All grades are encouraged to participate.',
   'GENERAL', NOW()),
(6, 'Grade 12 Mock Examinations',
   'Grade 12 mock examinations are scheduled for 15 to 26 September 2025. Attendance is compulsory for all Grade 12 learners.',
   'EXAM', NOW());

-- MEETINGS
INSERT INTO `meeting` (`id`, `title`, `description`, `scheduled_time`, `teacher_id`, `teacher_name`, `parent_id`, `parent_name`, `type`, `status`, `rejection_reason`, `created_at`) VALUES
(1,  'Progress Feedback – Amahle Mokoena',    'I would like to discuss Amahle''s academic progress and upcoming exam preparation.',                        '2025-08-20 14:00:00', '3', 'Mr David Sithole',  1, 'Sarah Mokoena',   'ONE_ON_ONE',   'PENDING',  NULL, NOW()),
(2,  'Grade 10 Parent Information Evening',   'End-of-term parent briefing for all Grade 10 parents. Topics include subject choices for Grade 11.',          '2025-08-27 18:00:00', '4', 'Ms Grace Mohlala', 3, 'Lerato Dlamini',  'GROUP_MEETING','PENDING',  NULL, NOW()),
(3,  'Concern About Sbusiso''s Attendance',   'Sbusiso has missed several morning periods. I would like to discuss the reasons and find a solution.',        '2025-08-22 10:30:00', '5', 'Mr Sipho Dlamini', 4, 'Thandeka Zulu',   'ONE_ON_ONE',   'PENDING',  NULL, NOW()),
(4,  'Grade 7 Orientation for New Parents',   'Introductory session for parents of Grade 7 learners joining in 2025.',                                       '2025-09-03 09:00:00', '3', 'Mr David Sithole', 5, 'Mpho Molefe',     'GROUP_MEETING','PENDING',  NULL, NOW()),
(5,  'Zakhele Khumalo – Subject Selection',   'Discussion about Zakhele''s matric subject choices and career direction.',                                    '2025-08-14 11:00:00', '5', 'Mr Sipho Dlamini', 2, 'James Khumalo',   'ONE_ON_ONE',   'APPROVED', NULL, NOW()),
(6,  'Grade 9 Academic Support Programme',   'Briefing for Grade 9 parents on the academic support and tutoring programme available this term.',             '2025-08-12 17:30:00', '4', 'Ms Grace Mohlala', 3, 'Lerato Dlamini',  'GROUP_MEETING','APPROVED', NULL, NOW()),
(7,  'Supervised Study Hall – Parent Info',   'Parents requested information about the supervised lunch-hour study facility.',                               '2025-08-08 13:00:00', '3', 'Mr David Sithole', 6, 'Nomsa Shabalala', 'ONE_ON_ONE',   'APPROVED', NULL, NOW()),
(8,  'Urgent Progress Review – Tebogo',       'Requesting an urgent meeting to review Tebogo''s progress report before report day.',                         '2025-07-25 08:00:00', '3', 'Mr David Sithole', 5, 'Mpho Molefe',     'ONE_ON_ONE',   'REJECTED', 'Meeting requests must be submitted at least 5 school days in advance. Please resubmit for a date after 1 August.', NOW()),
(9,  'Grade 8 Discipline Discussion',         'Parent requested a meeting regarding a disciplinary matter involving Nokwanda.',                              '2025-07-28 15:00:00', '3', 'Mr David Sithole', 4, 'Thandeka Zulu',   'ONE_ON_ONE',   'REJECTED', 'This matter has been resolved through the school''s disciplinary process. No further meeting is required.', NOW()),
(10, 'Homework Assistance Request',           'Parent requesting additional homework assistance for Grade 7 learners.',                                      '2025-07-30 14:00:00', '3', 'Mr David Sithole', 1, 'Sarah Mokoena',   'GROUP_MEETING','REJECTED', 'The school already offers a homework club every Tuesday and Thursday from 14:30 to 16:00.', NOW());

-- PAYMENTS
INSERT INTO `payment` (`id`, `student_id`, `parent_id`, `trip_id`, `amount`, `method`, `status`, `transaction_id`, `created_at`) VALUES
(1, 1,  1, 1, 280.00,  'Credit Card',   'COMPLETED', 'TXN-A1B2C3D4', NOW()),
(2, 4,  2, 1, 280.00,  'Debit Card',    'COMPLETED', 'TXN-E5F6G7H8', NOW()),
(3, 5,  2, 2, 950.00,  'Bank Transfer', 'COMPLETED', 'TXN-I9J0K1L2', NOW()),
(4, 6,  3, 3, 320.00,  'Credit Card',   'COMPLETED', 'TXN-M3N4O5P6', NOW()),
(5, 9,  4, 2, 950.00,  'Credit Card',   'COMPLETED', 'TXN-Q7R8S9T0', NOW()),
(6, 9,  4, 4, 3500.00, 'Bank Transfer', 'COMPLETED', 'TXN-U1V2W3X4', NOW()),
(7, 12, 5, 1, 280.00,  'Cash',          'COMPLETED', 'TXN-Y5Z6A7B8', NOW()),
(8, 15, 6, 3, 320.00,  'Debit Card',    'COMPLETED', 'TXN-C9D0E1F2', NOW());

-- TRIP REGISTRATIONS
INSERT INTO `trip_registration` (`id`, `trip_id`, `student_id`, `payment_id`, `consent_submitted`, `status`, `registered_at`) VALUES
(1, 1, 1,  1, TRUE,  'REGISTERED', NOW()),
(2, 1, 4,  2, TRUE,  'REGISTERED', NOW()),
(3, 2, 5,  3, TRUE,  'REGISTERED', NOW()),
(4, 3, 6,  4, FALSE, 'REGISTERED', NOW()),
(5, 2, 9,  5, TRUE,  'REGISTERED', NOW()),
(6, 4, 9,  6, TRUE,  'REGISTERED', NOW()),
(7, 1, 12, 7, TRUE,  'REGISTERED', NOW()),
(8, 3, 15, 8, FALSE, 'REGISTERED', NOW());

-- DOCUMENT REQUESTS
INSERT INTO `document_request` (`id`, `parent_id`, `request_type`, `description`, `status`, `created_at`) VALUES
(1, 1, 'Progress Report',              'Please provide an up-to-date academic progress report for Amahle Mokoena (Grade 7A) for scholarship application purposes.', 'APPROVED', NOW()),
(2, 2, 'Character Reference Letter',   'We require an official character reference letter for Zakhele Khumalo for his university application.',                       'APPROVED', NOW()),
(3, 3, 'Proof of Enrollment',          'Official proof of enrollment letter for Zanele Dlamini needed for medical aid registration.',                                  'PENDING',  NOW()),
(4, 4, 'Transfer Letter',              'Requesting a transfer letter for Nokwanda Zulu as we may be relocating to Cape Town early next year.',                         'PENDING',  NOW()),
(5, 5, 'Academic Transcript',          'Full academic transcript for Tebogo Molefe required for bursary application deadline 30 September.',                           'PENDING',  NOW()),
(6, 6, 'Sports Participation Certificate', 'Certificate confirming Lungelo Shabalala''s participation in the school athletics team for the 2024/2025 season.',        'REJECTED', NOW());


-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'users'              AS `table`, COUNT(*) AS records FROM `user`
UNION ALL SELECT 'parents',             COUNT(*) FROM parent
UNION ALL SELECT 'students',            COUNT(*) FROM student
UNION ALL SELECT 'trips',               COUNT(*) FROM trip
UNION ALL SELECT 'announcements',       COUNT(*) FROM announcement
UNION ALL SELECT 'meetings',            COUNT(*) FROM meeting
UNION ALL SELECT 'payments',            COUNT(*) FROM payment
UNION ALL SELECT 'trip_registrations',  COUNT(*) FROM trip_registration
UNION ALL SELECT 'document_requests',   COUNT(*) FROM document_request;
