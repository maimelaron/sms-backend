-- ============================================================
-- Interface Innovators High School — FULL DEMO DATA
-- Populates every table with realistic data for UI testing.
--
-- HOW TO RUN:
--   1. Start the Spring Boot backend first (Hibernate creates tables)
--   2. Open MySQL Workbench → select sms_db schema
--   3. Run this entire script
--   4. Refresh and log in:
--        Super Admin : superadmin@school.ac.za / Super@123
--        Admin       : admin@school.ac.za      / Admin@123
--        Parent      : sarah.mokoena@parent.com / Parent@123
-- ============================================================

USE sms_db;

-- Wipe existing data cleanly
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE trip_registration;
TRUNCATE TABLE payment;
TRUNCATE TABLE document_request;
TRUNCATE TABLE document;
TRUNCATE TABLE meeting;
TRUNCATE TABLE student;
TRUNCATE TABLE parent;
TRUNCATE TABLE announcement;
TRUNCATE TABLE trip;
TRUNCATE TABLE user;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- USERS  (1 super admin · 1 admin · 3 teachers · 10 parents — total 15)
-- ============================================================
INSERT INTO `user` (id, full_name, email, password_hash, phone_number, role, active, created_at) VALUES
-- Super Admin
(1,  'Super Administrator', 'superadmin@school.ac.za',    'Super@123',   '0110001000', 'SUPER_ADMIN', TRUE, NOW()),
-- Admin
(2,  'Thembi Nkosi',        'admin@school.ac.za',         'Admin@123',   '0110001001', 'ADMIN',       TRUE, NOW()),
-- Teachers
(3,  'Mr David Sithole',    'david.sithole@school.ac.za', 'Teacher@123', '0820001002', 'TEACHER', TRUE, NOW()),
(4,  'Ms Grace Mohlala',    'grace.mohlala@school.ac.za', 'Teacher@123', '0830001003', 'TEACHER', TRUE, NOW()),
(5,  'Mr Sipho Dlamini',    'sipho.dlamini@school.ac.za', 'Teacher@123', '0840001004', 'TEACHER', TRUE, NOW()),
-- Parents
(6,  'Sarah Mokoena',       'sarah.mokoena@parent.com',   'Parent@123',  '0820001005', 'PARENT',  TRUE, NOW()),
(7,  'James Khumalo',       'james.khumalo@parent.com',   'Parent@123',  '0830001006', 'PARENT',  TRUE, NOW()),
(8,  'Lerato Dlamini',      'lerato.dlamini@parent.com',  'Parent@123',  '0840001007', 'PARENT',  TRUE, NOW()),
(9,  'Thandeka Zulu',       'thandeka.zulu@parent.com',   'Parent@123',  '0850001008', 'PARENT',  TRUE, NOW()),
(10, 'Mpho Molefe',         'mpho.molefe@parent.com',     'Parent@123',  '0860001009', 'PARENT',  TRUE, NOW()),
(11, 'Nomsa Shabalala',     'nomsa.shabalala@parent.com', 'Parent@123',  '0870001010', 'PARENT',  TRUE, NOW()),
(12, 'Thabo Nkosi',         'thabo.nkosi@parent.com',     'Parent@123',  '0810001011', 'PARENT',  TRUE, NOW()),
(13, 'Zanele Mthembu',      'zanele.mthembu@parent.com',  'Parent@123',  '0820001012', 'PARENT',  TRUE, NOW()),
(14, 'Pieter van Wyk',      'pieter.vanwyk@parent.com',   'Parent@123',  '0830001013', 'PARENT',  TRUE, NOW()),
(15, 'Fatima Patel',        'fatima.patel@parent.com',    'Parent@123',  '0840001014', 'PARENT',  TRUE, NOW());

-- ============================================================
-- PARENTS  (linked to user accounts)
-- ============================================================
INSERT INTO `parent` (id, user_id, full_name, email, phone_number, address, created_at) VALUES
(1, 6,  'Sarah Mokoena',   'sarah.mokoena@parent.com',   '0820001005', '14 Acacia Street, Soweto, Johannesburg 1804',       NOW()),
(2, 7,  'James Khumalo',   'james.khumalo@parent.com',   '0830001006', '27 Bougainvillea Ave, Sandton, Johannesburg 2196',  NOW()),
(3, 8,  'Lerato Dlamini',  'lerato.dlamini@parent.com',  '0840001007', '5 Jacaranda Close, Pretoria East 0081',             NOW()),
(4, 9,  'Thandeka Zulu',   'thandeka.zulu@parent.com',   '0850001008', '88 Msunduzi Road, Pietermaritzburg 3201',           NOW()),
(5, 10, 'Mpho Molefe',     'mpho.molefe@parent.com',     '0860001009', '3 Sunflower Drive, Midrand, Johannesburg 1682',     NOW()),
(6, 11, 'Nomsa Shabalala', 'nomsa.shabalala@parent.com', '0870001010', '12 Protea Road, Boksburg, Ekurhuleni 1459',                NOW()),
(7, 12, 'Thabo Nkosi',    'thabo.nkosi@parent.com',    '0810001011', '45 Oak Street, Alexandra, Johannesburg 2090',               NOW()),
(8, 13, 'Zanele Mthembu', 'zanele.mthembu@parent.com', '0820001012', '19 Palm Avenue, Centurion, Pretoria 0157',                  NOW()),
(9, 14, 'Pieter van Wyk', 'pieter.vanwyk@parent.com',  '0830001013', '7 Fynbos Road, Paarl, Western Cape 7646',                   NOW()),
(10, 15, 'Fatima Patel',  'fatima.patel@parent.com',   '0840001014', '33 Lotus Lane, Lenasia, Johannesburg 1827',                 NOW());

-- ============================================================
-- STUDENTS  (20 learners across all grades and statuses)
-- ============================================================
INSERT INTO `student`
  (id, name, surname, gender, date_of_birth, birth_certificate_id, nationality, grade,
   year_of_admission, previous_school, parent_id, class_name, teacher, status, rejection_reason, created_at)
VALUES
-- Parent 1 – Sarah Mokoena
(1,  'Amahle',   'Mokoena',   'FEMALE', '2013-04-12', 'BC-2013-0001', 'South African', '7',  2024, 'Soweto Primary School',         1, '7A', 'Mr David Sithole',  'APPROVED', NULL,                                   NOW()),
(2,  'Lethiwe',  'Mokoena',   'MALE',   '2010-08-23', 'BC-2010-0002', 'South African', '10', 2021, 'Soweto Primary School',         1, '10B','Ms Grace Mohlala',  'APPROVED', NULL,                                   NOW()),
(3,  'Siphelele','Mokoena',   'MALE',   '2015-01-07', 'BC-2015-0003', 'South African', '5',  2025, NULL,                            1, NULL,  NULL,               'PENDING',  NULL,                                   NOW()),

-- Parent 2 – James Khumalo
(4,  'Ayanda',   'Khumalo',   'FEMALE', '2012-06-30', 'BC-2012-0004', 'South African', '8',  2023, 'Sandton Prep School',           2, '8A', 'Mr David Sithole',  'APPROVED', NULL,                                   NOW()),
(5,  'Zakhele',  'Khumalo',   'MALE',   '2009-11-15', 'BC-2009-0005', 'South African', '11', 2020, 'Sandton Prep School',           2, '11A','Mr Sipho Dlamini',  'APPROVED', NULL,                                   NOW()),

-- Parent 3 – Lerato Dlamini
(6,  'Zanele',   'Dlamini',   'FEMALE', '2011-03-18', 'BC-2011-0006', 'South African', '9',  2022, 'Pretoria North Primary',        3, '9B', 'Ms Grace Mohlala',  'APPROVED', NULL,                                   NOW()),
(7,  'Thabo',    'Dlamini',   'MALE',   '2014-09-02', 'BC-2014-0007', 'South African', '6',  2025, 'Pretoria North Primary',        3, NULL,  NULL,               'PENDING',  NULL,                                   NOW()),
(8,  'Nandi',    'Dlamini',   'FEMALE', '2016-12-20', 'BC-2016-0008', 'South African', '4',  2025, NULL,                            3, NULL,  NULL,               'REJECTED', 'Incomplete birth certificate submitted. Please resubmit with a certified copy.', NOW()),

-- Parent 4 – Thandeka Zulu
(9,  'Sbusiso',  'Zulu',      'MALE',   '2008-07-04', 'BC-2008-0009', 'South African', '12', 2019, 'Pietermaritzburg High',         4, '12A','Mr Sipho Dlamini',  'APPROVED', NULL,                                   NOW()),
(10, 'Nokwanda', 'Zulu',      'FEMALE', '2012-02-28', 'BC-2012-0010', 'South African', '8',  2023, 'Pietermaritzburg High',         4, '8B', 'Mr David Sithole',  'APPROVED', NULL,                                   NOW()),
(11, 'Mthokozisi','Zulu',     'MALE',   '2015-05-16', 'BC-2015-0011', 'South African', '5',  2025, 'Umgungundlovu Primary',         4, NULL,  NULL,               'PENDING',  NULL,                                   NOW()),

-- Parent 5 – Mpho Molefe
(12, 'Tebogo',   'Molefe',    'MALE',   '2013-10-10', 'BC-2013-0012', 'South African', '7',  2024, 'Midrand Junior School',         5, '7B', 'Mr David Sithole',  'APPROVED', NULL,                                   NOW()),
(13, 'Kelebogile','Molefe',   'FEMALE', '2011-06-14', 'BC-2011-0013', 'South African', '9',  2022, 'Midrand Junior School',         5, '9A', 'Ms Grace Mohlala',  'APPROVED', NULL,                                   NOW()),
(14, 'Otsile',   'Molefe',    'MALE',   '2016-03-03', 'BC-2016-0014', 'South African', '4',  2025, NULL,                            5, NULL,  NULL,               'REJECTED', 'Grade placement requires previous school records. Please provide certified report card.', NOW()),

-- Parent 6 – Nomsa Shabalala
(15, 'Lungelo',  'Shabalala', 'MALE',   '2010-12-25', 'BC-2010-0015', 'South African', '10', 2021, 'Boksburg Primary',              6, '10A','Ms Grace Mohlala',  'APPROVED', NULL,                                   NOW()),
(16, 'Sifiso',   'Shabalala', 'MALE',   '2013-08-17', 'BC-2013-0016', 'South African', '7',  2024, 'Boksburg Primary',              6, '7C', 'Mr David Sithole',  'APPROVED', NULL,                                   NOW()),
(17, 'Phumzile', 'Shabalala', 'FEMALE', '2015-04-29', 'BC-2015-0017', 'South African', '5',  2025, 'Boksburg Primary',              6, NULL,  NULL,               'PENDING',  NULL,                                   NOW()),
(18, 'Ntuthuko', 'Shabalala', 'MALE',   '2017-09-11', 'BC-2017-0018', 'South African', '3',  2025, NULL,                            6, NULL,  NULL,               'PENDING',  NULL,                                   NOW());

-- ============================================================
-- TRIPS  (5 trips – mix of active and inactive)
-- ============================================================
INSERT INTO `trip` (id, title, description, destination, price, trip_date, eligible_grades_str, active, created_at) VALUES
(1, 'Sci-Bono Science Museum',
    'An exciting day at the Sci-Bono Discovery Centre. Learners will engage with interactive science, technology and engineering exhibits. Lunch is included.',
    'Newtown, Johannesburg', 280.00, '2025-08-15', '7,8,9', TRUE, NOW()),

(2, 'Drakensberg Hiking Adventure',
    'A two-day overnight hike in the breathtaking Drakensberg mountains. Includes transportation, accommodation in mountain huts, all meals, and a qualified guide.',
    'uKhahlamba-Drakensberg, KwaZulu-Natal', 950.00, '2025-09-19', '10,11,12', TRUE, NOW()),

(3, 'Apartheid Museum & Constitutional Hill',
    'A meaningful cultural and historical tour covering two of Johannesburg''s most significant heritage sites. Deepen your understanding of South Africa''s history.',
    'Johannesburg', 320.00, '2025-10-10', '8,9,10,11,12', TRUE, NOW()),

(4, 'Cape Town Explorer',
    'Three-day trip to Cape Town. Includes Table Mountain cable car, Robben Island, the V&A Waterfront, Cape Point, and the Boulders Penguin Colony.',
    'Cape Town, Western Cape', 3500.00, '2025-11-21', '10,11,12', TRUE, NOW()),

(5, 'Walter Sisulu National Botanical Garden',
    'A relaxing educational visit to the Walter Sisulu Botanical Garden. Learners will learn about indigenous plants and the famous Witpoortjie waterfall.',
    'Roodepoort, Johannesburg', 150.00, '2025-07-25', '4,5,6,7', FALSE, NOW()),

(6, 'Gold Reef City – Science and History',
    'An educational visit to Gold Reef City with a focus on South African gold mining history and the laws of physics through interactive exhibits.',
    'Johannesburg', 450.00, '2025-08-30', '7,8,9,10', TRUE, NOW()),

(7, 'National Zoological Gardens',
    'A guided educational tour of the National Zoological Gardens in Pretoria. Learners will learn about biodiversity, conservation, and animal behaviour.',
    'Pretoria', 180.00, '2025-09-05', '4,5,6', TRUE, NOW()),

(8, 'Constitutional Court Tour',
    'An educational tour of the Constitutional Court of South Africa — one of the most significant human rights courts in the world. Includes a guided lecture.',
    'Johannesburg', 50.00, '2025-09-12', '11,12', TRUE, NOW()),

(9, 'Sterkfontein Caves – Cradle of Humankind',
    'Guided tour of the UNESCO World Heritage Site. Learners will engage with palaeontology and discover the story of early human ancestors.',
    'Maropeng, Gauteng', 220.00, '2025-10-03', '8,9,10', TRUE, NOW()),

(10, 'Kruger National Park Safari',
    'Three-day educational safari at Kruger National Park. Includes game drives, a guided bush walk, and a presentation on South African ecology and conservation.',
    'Mpumalanga', 2800.00, '2025-11-07', '10,11,12', TRUE, NOW());

-- ============================================================
-- ANNOUNCEMENTS  (6 – all four types)
-- ============================================================
INSERT INTO `announcement` (id, title, content, type, created_at) VALUES
(1, 'Welcome to the 2025 Academic Year',
   'We warmly welcome all learners, parents and staff back to Meridian High School. This year promises to be filled with exciting opportunities for growth, learning and achievement. Our doors are always open — please do not hesitate to contact the administration office.',
   'GENERAL', NOW()),

(2, 'Term 3 Examination Schedule',
   'Term 3 examinations will be held from 18 to 29 August 2025. All learners must ensure they are in possession of their timetables. No late entries will be accepted. Study guides are available from the library from 1 August.',
   'EXAM', NOW()),

(3, 'URGENT: School Closure – Burst Water Pipe',
   'Due to a burst water main on the school premises, the school will be closed on Wednesday 9 July 2025. All assessments scheduled for that day will be rescheduled. Parents will be notified of new dates via this portal.',
   'URGENT', NOW()),

(4, 'Public Holiday – National Women''s Day',
   'Please note that the school will be closed on Friday 8 August 2025 in observance of National Women''s Day. Normal classes resume on Monday 11 August 2025. Have a wonderful long weekend!',
   'HOLIDAY', NOW()),

(5, 'Annual Science Fair – Call for Entries',
   'The Annual Science Fair will take place on Friday 5 September 2025 in the school hall. All grades are encouraged to participate. Entry forms are available from your class teacher. Prizes will be awarded for the top three projects per category.',
   'GENERAL', NOW()),

(6, 'Grade 12 Mock Examinations',
   'Grade 12 mock examinations (Trial Exams) are scheduled for 15 to 26 September 2025. This is a critical preparation milestone. Attendance is compulsory. Any learner who misses a paper without a valid medical certificate will receive zero.',
   'EXAM', NOW()),

(7, 'Sports Day – Term 3',
   'The annual Sports Day will take place on Saturday 23 August 2025. All learners are encouraged to participate in their preferred track and field events. Parents are welcome to attend. Gates open at 07:30.',
   'GENERAL', NOW()),

(8, 'URGENT: Modified Timetable – Load Shedding',
   'Due to scheduled load shedding, the school will operate on a modified timetable on affected days. Battery-powered inverters have been installed in key areas. Please check the notice board daily.',
   'URGENT', NOW()),

(9, 'Grade 11 Preliminary Examinations',
   'Grade 11 preliminary examinations are scheduled for 6 to 17 October 2025. A detailed timetable will be distributed by class teachers. Learners must collect their timetables from the admin office by 26 September.',
   'EXAM', NOW()),

(10, 'Spring Day – School Holiday',
   'In celebration of Spring Day, the school will be closed on Friday 26 September 2025. School resumes on Monday 29 September 2025. Enjoy the long weekend!',
   'HOLIDAY', NOW());

-- ============================================================
-- MEETINGS  (10 – spread across all statuses)
-- ============================================================
INSERT INTO `meeting` (id, title, description, scheduled_time, teacher_id, teacher_name, parent_id, parent_name, type, status, rejection_reason, created_at) VALUES
-- PENDING requests (awaiting admin approval)
(1,  'Progress Feedback – Amahle Mokoena',
     'I would like to discuss Amahle''s academic progress and upcoming exam preparation.',
     '2025-08-20 14:00:00', '2', 'Mr David Sithole', 1, 'Sarah Mokoena',   'ONE_ON_ONE',   'PENDING',  NULL, NOW()),

(2,  'Grade 10 Parent Information Evening',
     'End-of-term parent briefing for all Grade 10 parents. Topics include subject choices for Grade 11.',
     '2025-08-27 18:00:00', '3', 'Ms Grace Mohlala', 3, 'Lerato Dlamini',  'GROUP_MEETING','PENDING',  NULL, NOW()),

(3,  'Concern About Sbusiso''s Attendance',
     'Sbusiso has missed several morning periods. I would like to discuss the reasons and find a solution.',
     '2025-08-22 10:30:00', '4', 'Mr Sipho Dlamini', 4, 'Thandeka Zulu',   'ONE_ON_ONE',   'PENDING',  NULL, NOW()),

(4,  'Grade 7 Orientation for New Parents',
     'Introductory session for parents of Grade 7 learners joining in 2025.',
     '2025-09-03 09:00:00', '2', 'Mr David Sithole', 5, 'Mpho Molefe',     'GROUP_MEETING','PENDING',  NULL, NOW()),

-- APPROVED meetings (scheduled and confirmed)
(5,  'Zakhele Khumalo – Subject Selection Meeting',
     'Discussion about Zakhele''s matric subject choices and career direction.',
     '2025-08-14 11:00:00', '4', 'Mr Sipho Dlamini', 2, 'James Khumalo',   'ONE_ON_ONE',   'APPROVED', NULL, NOW()),

(6,  'Grade 9 Academic Support Programme',
     'Briefing for Grade 9 parents on the academic support and tutoring programme available this term.',
     '2025-08-12 17:30:00', '3', 'Ms Grace Mohlala', 3, 'Lerato Dlamini',  'GROUP_MEETING','APPROVED', NULL, NOW()),

(7,  'Lunch-Hour Study Hall – Parent Permission',
     'Parents requested information about the supervised lunch-hour study facility.',
     '2025-08-08 13:00:00', '2', 'Mr David Sithole', 6, 'Nomsa Shabalala', 'ONE_ON_ONE',   'APPROVED', NULL, NOW()),

-- REJECTED requests
(8,  'Last-Minute Individual Progress Report',
     'Requesting an urgent meeting to review Tebogo''s progress report before report day.',
     '2025-07-25 08:00:00', '2', 'Mr David Sithole', 5, 'Mpho Molefe',     'ONE_ON_ONE',   'REJECTED',
     'Meeting requests must be submitted at least 5 school days in advance. Please resubmit for a date after 1 August.', NOW()),

(9,  'Grade 8 Discipline Discussion',
     'Parent requested a meeting regarding a disciplinary matter involving Nokwanda.',
     '2025-07-28 15:00:00', '2', 'Mr David Sithole', 4, 'Thandeka Zulu',   'ONE_ON_ONE',   'REJECTED',
     'This matter has been resolved through the school''s disciplinary process. No further meeting is required at this stage.', NOW()),

(10, 'Homework Assistance Request',
     'Parent requesting that the school provide additional homework assistance for Grade 7 learners.',
     '2025-07-30 14:00:00', '2', 'Mr David Sithole', 1, 'Sarah Mokoena',   'GROUP_MEETING','REJECTED',
     'The school already offers a homework club every Tuesday and Thursday from 14:30 to 16:00. Learners are encouraged to attend.', NOW());

-- ============================================================
-- PAYMENTS  (8 completed payments for trip registrations)
-- ============================================================
INSERT INTO `payment` (id, student_id, parent_id, trip_id, amount, method, status, transaction_id, created_at) VALUES
(1,  1,  1, 1, 280.00,  'Credit Card',   'COMPLETED', 'TXN-A1B2C3D4', NOW()),
(2,  4,  2, 1, 280.00,  'Debit Card',    'COMPLETED', 'TXN-E5F6G7H8', NOW()),
(3,  5,  2, 2, 950.00,  'Bank Transfer', 'COMPLETED', 'TXN-I9J0K1L2', NOW()),
(4,  6,  3, 3, 320.00,  'Credit Card',   'COMPLETED', 'TXN-M3N4O5P6', NOW()),
(5,  9,  4, 2, 950.00,  'Credit Card',   'COMPLETED', 'TXN-Q7R8S9T0', NOW()),
(6,  9,  4, 4, 3500.00, 'Bank Transfer', 'COMPLETED', 'TXN-U1V2W3X4', NOW()),
(7,  12, 5, 1, 280.00,  'Cash',          'COMPLETED', 'TXN-Y5Z6A7B8', NOW()),
(8,  15, 6, 3, 320.00,  'Debit Card',    'COMPLETED', 'TXN-C9D0E1F2', NOW()),
(9,  2,  1, 2, 950.00,  'Credit Card',   'COMPLETED', 'TXN-G3H4I5J6', NOW()),
(10, 10, 4, 3, 320.00,  'EFT Transfer',  'COMPLETED', 'TXN-K7L8M9N0', NOW());

-- ============================================================
-- TRIP REGISTRATIONS  (matching the payments above)
-- ============================================================
INSERT INTO `trip_registration` (id, trip_id, student_id, payment_id, consent_submitted, status, registered_at) VALUES
(1, 1, 1,  1, TRUE,  'REGISTERED', NOW()),
(2, 1, 4,  2, TRUE,  'REGISTERED', NOW()),
(3, 2, 5,  3, TRUE,  'REGISTERED', NOW()),
(4, 3, 6,  4, FALSE, 'REGISTERED', NOW()),
(5, 2, 9,  5, TRUE,  'REGISTERED', NOW()),
(6, 4, 9,  6, TRUE,  'REGISTERED', NOW()),
(7, 1, 12, 7, TRUE,  'REGISTERED', NOW()),
(8,  3, 15, 8,  FALSE, 'REGISTERED', NOW()),
(9,  2, 2,  9,  TRUE,  'REGISTERED', NOW()),
(10, 3, 10, 10, TRUE,  'REGISTERED', NOW());

-- ============================================================
-- DOCUMENT REQUESTS  (6 – all statuses)
-- ============================================================
INSERT INTO `document_request` (id, parent_id, request_type, description, status, created_at) VALUES
(1, 1, 'Progress Report',
   'Please provide an up-to-date academic progress report for Amahle Mokoena (Grade 7A) for scholarship application purposes.',
   'APPROVED', NOW()),

(2, 2, 'Character Reference Letter',
   'We require an official character reference letter for Zakhele Khumalo for his university application.',
   'APPROVED', NOW()),

(3, 3, 'Proof of Enrollment',
   'Official proof of enrollment letter for Zanele Dlamini needed for medical aid registration.',
   'PENDING', NOW()),

(4, 4, 'Transfer Letter',
   'Requesting a transfer letter for Nokwanda Zulu as we may be relocating to Cape Town early next year.',
   'PENDING', NOW()),

(5, 5, 'Academic Transcript',
   'Full academic transcript for Tebogo Molefe required for bursary application deadline 30 September.',
   'PENDING', NOW()),

(6, 6, 'Sports Participation Certificate',
   'Certificate confirming Lungelo Shabalala''s participation in the school athletics team for the 2024/2025 season.',
   'REJECTED', NOW()),

(7, 1, 'Fee Statement',
   'Request for a detailed fee statement for the 2025 academic year for tax certificate (IT3b) submission purposes.',
   'APPROVED', NOW()),

(8, 3, 'Medical Exemption Letter',
   'Requesting an official letter confirming that Thabo Dlamini is temporarily exempted from physical education following a recent sports injury.',
   'PENDING', NOW()),

(9, 5, 'Subject Change Confirmation',
   'Formal confirmation required for Tebogo Molefe''s approved subject change from Mathematics to Mathematical Literacy, effective Term 3.',
   'REJECTED', NOW()),

(10, 6, 'Scholarship Reference Letter',
   'An official reference letter is needed for Lungelo Shabalala''s application to the Meridian Bursary Fund. Deadline is 15 October 2025.',
   'PENDING', NOW());

-- ============================================================
-- Verify counts
-- ============================================================
SELECT 'users'              AS `table`, COUNT(*) AS records FROM user
UNION ALL
SELECT 'parents',                        COUNT(*) FROM parent
UNION ALL
SELECT 'students',                       COUNT(*) FROM student
UNION ALL
SELECT 'trips',                          COUNT(*) FROM trip
UNION ALL
SELECT 'announcements',                  COUNT(*) FROM announcement
UNION ALL
SELECT 'meetings',                       COUNT(*) FROM meeting
UNION ALL
SELECT 'payments',                       COUNT(*) FROM payment
UNION ALL
SELECT 'trip_registrations',             COUNT(*) FROM trip_registration
UNION ALL
SELECT 'document_requests',              COUNT(*) FROM document_request;
