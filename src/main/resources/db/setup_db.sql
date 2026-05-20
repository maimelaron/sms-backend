-- ============================================================
-- SMS — Full Database Setup Script
-- Run this in MySQL Workbench or via:
--   mysql -u root -p < setup_db.sql
-- ============================================================

DROP
DATABASE IF EXISTS sms_db;
CREATE
DATABASE sms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE
sms_db;

-- ============================================================
-- TABLES (FK-safe order)
-- ============================================================

CREATE TABLE `user`
(
    `id`            BIGINT       NOT NULL AUTO_INCREMENT,
    `first_name`    VARCHAR(100) NOT NULL,
    `last_name`     VARCHAR(100) NOT NULL,
    `email`         VARCHAR(150) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role`          ENUM('PARENT','TEACHER','ADMIN') NOT NULL,
    `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `student`
(
    `id`             BIGINT       NOT NULL AUTO_INCREMENT,
    `student_number` VARCHAR(20) UNIQUE,
    `first_name`     VARCHAR(100) NOT NULL,
    `last_name`      VARCHAR(100) NOT NULL,
    `date_of_birth`  DATE         NOT NULL,
    `grade`          VARCHAR(10)  NOT NULL,
    `parent_id`      BIGINT       NOT NULL,
    `status`         ENUM('PENDING','ACTIVE','INACTIVE') NOT NULL DEFAULT 'PENDING',
    `created_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_student_parent` FOREIGN KEY (`parent_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `application`
(
    `id`                 BIGINT       NOT NULL AUTO_INCREMENT,
    `parent_id`          BIGINT       NOT NULL,
    `student_first_name` VARCHAR(100) NOT NULL,
    `student_last_name`  VARCHAR(100) NOT NULL,
    `date_of_birth`      DATE         NOT NULL,
    `grade_applying_for` VARCHAR(10)  NOT NULL,
    `status`             ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `reviewed_by`        BIGINT NULL,
    `rejection_reason`   TEXT NULL,
    `submitted_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `reviewed_at`        TIMESTAMP NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_application_parent` FOREIGN KEY (`parent_id`) REFERENCES `user` (`id`),
    CONSTRAINT `fk_application_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `trip`
(
    `id`               BIGINT         NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(200)   NOT NULL,
    `description`      TEXT,
    `destination`      VARCHAR(200)   NOT NULL,
    `trip_date`        DATE           NOT NULL,
    `return_date`      DATE           NOT NULL,
    `cost`             DECIMAL(10, 2) NOT NULL,
    `max_participants` INT            NOT NULL,
    `created_by`       BIGINT         NOT NULL,
    `status`           ENUM('OPEN','CLOSED','CANCELLED') NOT NULL DEFAULT 'OPEN',
    `created_at`       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_trip_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `payment`
(
    `id`               BIGINT         NOT NULL AUTO_INCREMENT,
    `student_id`       BIGINT         NOT NULL,
    `parent_id`        BIGINT         NOT NULL,
    `amount`           DECIMAL(10, 2) NOT NULL,
    `payment_type`     ENUM('TUITION','TRIP','OTHER') NOT NULL,
    `status`           ENUM('PENDING','SUCCESSFUL','FAILED') NOT NULL DEFAULT 'PENDING',
    `reference_number` VARCHAR(50) UNIQUE,
    `paid_at`          TIMESTAMP NULL,
    `created_at`       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_payment_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
    CONSTRAINT `fk_payment_parent` FOREIGN KEY (`parent_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meeting`
(
    `id`             BIGINT    NOT NULL AUTO_INCREMENT,
    `parent_id`      BIGINT    NOT NULL,
    `teacher_id`     BIGINT    NOT NULL,
    `student_id`     BIGINT    NOT NULL,
    `requested_date` DATE      NOT NULL,
    `requested_time` TIME      NOT NULL,
    `status`         ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `confirmed_date` DATE NULL,
    `confirmed_time` TIME NULL,
    `notes`          TEXT NULL,
    `created_at`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_meeting_parent` FOREIGN KEY (`parent_id`) REFERENCES `user` (`id`),
    CONSTRAINT `fk_meeting_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`),
    CONSTRAINT `fk_meeting_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `trip_registration`
(
    `id`                BIGINT    NOT NULL AUTO_INCREMENT,
    `trip_id`           BIGINT    NOT NULL,
    `student_id`        BIGINT    NOT NULL,
    `payment_id`        BIGINT NULL,
    `consent_submitted` BOOLEAN   NOT NULL DEFAULT FALSE,
    `status`            ENUM('REGISTERED','CANCELLED') NOT NULL DEFAULT 'REGISTERED',
    `registered_at`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_tripreg_trip` FOREIGN KEY (`trip_id`) REFERENCES `trip` (`id`),
    CONSTRAINT `fk_tripreg_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
    CONSTRAINT `fk_tripreg_payment` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `progress_record`
(
    `id`          BIGINT        NOT NULL AUTO_INCREMENT,
    `student_id`  BIGINT        NOT NULL,
    `teacher_id`  BIGINT        NOT NULL,
    `subject`     VARCHAR(100)  NOT NULL,
    `term`        ENUM('TERM_1','TERM_2','TERM_3','TERM_4') NOT NULL,
    `year`        INT           NOT NULL,
    `mark`        DECIMAL(5, 2) NOT NULL,
    `comment`     TEXT NULL,
    `recorded_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_progress_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
    CONSTRAINT `fk_progress_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `document`
(
    `id`             BIGINT       NOT NULL AUTO_INCREMENT,
    `application_id` BIGINT       NOT NULL,
    `document_type`  VARCHAR(100) NOT NULL,
    `file_name`      VARCHAR(255) NOT NULL,
    `file_path`      VARCHAR(500) NOT NULL,
    `uploaded_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_document_application` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO `user` (`id`, `first_name`, `last_name`, `email`, `password_hash`, `role`)
VALUES (1, 'Admin', 'System', 'admin@sms.ac.za', 'hashed_password', 'ADMIN'),
       (2, 'James', 'Khumalo', 'james.khumalo@gmail.com', 'hashed_password', 'PARENT'),
       (3, 'Lerato', 'Dlamini', 'lerato.dlamini@gmail.com', 'hashed_password', 'PARENT'),
       (4, 'Nomsa', 'Sithole', 'nomsa.sithole@gmail.com', 'hashed_password', 'PARENT'),
       (5, 'Thabo', 'Molefe', 'thabo.molefe@gmail.com', 'hashed_password', 'PARENT'),
       (6, 'Sarah', 'Nkosi', 'sarah.nkosi@sms.ac.za', 'hashed_password', 'TEACHER'),
       (7, 'David', 'Mokoena', 'david.mokoena@sms.ac.za', 'hashed_password', 'TEACHER');

INSERT INTO `student` (`id`, `student_number`, `first_name`, `last_name`, `date_of_birth`, `grade`, `parent_id`,
                       `status`)
VALUES (1, 'STU-2025-001', 'Ayanda', 'Khumalo', '2012-03-15', 'Grade 8', 2, 'ACTIVE'),
       (2, 'STU-2025-002', 'Zanele', 'Dlamini', '2010-07-22', 'Grade 10', 3, 'ACTIVE'),
       (3, 'STU-2025-003', 'Sipho', 'Sithole', '2011-11-08', 'Grade 9', 4, 'ACTIVE'),
       (4, 'STU-2025-004', 'Palesa', 'Molefe', '2009-05-30', 'Grade 11', 5, 'ACTIVE'),
       (5, NULL, 'Tebogo', 'Khumalo', '2013-01-18', 'Grade 7', 2, 'PENDING');

INSERT INTO `application` (`id`, `parent_id`, `student_first_name`, `student_last_name`, `date_of_birth`,
                           `grade_applying_for`, `status`, `reviewed_by`, `reviewed_at`)
VALUES (1, 2, 'Ayanda', 'Khumalo', '2012-03-15', 'Grade 8', 'APPROVED', 1, '2025-01-10 09:00:00'),
       (2, 3, 'Zanele', 'Dlamini', '2010-07-22', 'Grade 10', 'APPROVED', 1, '2025-01-10 09:30:00'),
       (3, 4, 'Sipho', 'Sithole', '2011-11-08', 'Grade 9', 'PENDING', NULL, NULL),
       (4, 5, 'Palesa', 'Molefe', '2009-05-30', 'Grade 11', 'PENDING', NULL, NULL),
       (5, 2, 'Tebogo', 'Khumalo', '2013-01-18', 'Grade 7', 'PENDING', NULL, NULL),
       (6, 3, 'Mpho', 'Dlamini', '2008-09-12', 'Grade 12', 'REJECTED', 1, '2025-01-11 11:00:00');

INSERT INTO `trip` (`id`, `title`, `destination`, `description`, `trip_date`, `return_date`, `cost`, `max_participants`,
                    `created_by`, `status`)
VALUES (1, 'Science Museum Visit', 'Johannesburg', 'Annual science excursion to the Sci-Bono Discovery Centre.',
        '2025-04-15', '2025-04-15', 250.00, 40, 1, 'OPEN'),
       (2, 'Drakensberg Hike', 'KwaZulu-Natal', 'Two-day adventure hike in the Drakensberg mountains.', '2025-05-20',
        '2025-05-21', 850.00, 20, 1, 'OPEN'),
       (3, 'Cape Town Cultural Tour', 'Cape Town', 'History and culture tour of Cape Town and surroundings.',
        '2025-07-10', '2025-07-14', 3200.00, 30, 1, 'OPEN');

INSERT INTO `payment` (`id`, `student_id`, `parent_id`, `amount`, `payment_type`, `status`, `reference_number`,
                       `paid_at`)
VALUES (1, 1, 2, 5500.00, 'TUITION', 'SUCCESSFUL', 'REF-2025-001', '2025-01-15 10:00:00'),
       (2, 2, 3, 5500.00, 'TUITION', 'SUCCESSFUL', 'REF-2025-002', '2025-01-15 11:00:00'),
       (3, 3, 4, 5500.00, 'TUITION', 'PENDING', 'REF-2025-003', NULL),
       (4, 1, 2, 250.00, 'TRIP', 'PENDING', 'REF-2025-004', NULL);

INSERT INTO `meeting` (`id`, `parent_id`, `teacher_id`, `student_id`, `requested_date`, `requested_time`, `status`,
                       `confirmed_date`, `confirmed_time`)
VALUES (1, 2, 6, 1, '2025-03-20', '14:00:00', 'PENDING', NULL, NULL),
       (2, 3, 7, 2, '2025-03-22', '10:00:00', 'APPROVED', '2025-03-22', '10:00:00'),
       (3, 4, 6, 3, '2025-03-25', '09:00:00', 'PENDING', NULL, NULL);

INSERT INTO `progress_record` (`id`, `student_id`, `teacher_id`, `subject`, `term`, `year`, `mark`, `comment`)
VALUES (1, 1, 6, 'Mathematics', 'TERM_1', 2025, 78.50, 'Good progress, needs to work on algebra.'),
       (2, 1, 7, 'Life Sciences', 'TERM_1', 2025, 82.00, 'Excellent participation in class.'),
       (3, 2, 6, 'Mathematics', 'TERM_1', 2025, 91.00, 'Outstanding performance.'),
       (4, 3, 7, 'Physical Science', 'TERM_1', 2025, 65.00, 'Struggling with chemical equations.'),
       (5, 4, 6, 'Mathematics', 'TERM_1', 2025, 88.50, 'Consistent and hardworking.');

-- ============================================================
SELECT 'Database setup complete!' AS status;
SELECT TABLE_NAME, TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sms_db';
