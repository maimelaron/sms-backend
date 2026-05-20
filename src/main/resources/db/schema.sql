-- ============================================================
-- School Management System — Database Schema (Reference Only)
-- Database: sms_db (MySQL 8.x)
-- NOTE: Schema is managed by Hibernate (ddl-auto=update).
--       This file is for reference and manual setup only.
-- ============================================================
-- Run first: CREATE DATABASE sms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- ============================================================

CREATE TABLE IF NOT EXISTS `user` (
    `id`            BIGINT          NOT NULL AUTO_INCREMENT,
    `full_name`     VARCHAR(200)    NOT NULL,
    `email`         VARCHAR(150)    NOT NULL UNIQUE,
    `password_hash` VARCHAR(255)    NOT NULL,
    `phone_number`  VARCHAR(20),
    `active`        TINYINT(1)      NOT NULL DEFAULT 1,
    `role`          ENUM('PARENT','TEACHER','ADMIN') NOT NULL DEFAULT 'PARENT',
    `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `parent` (
    `id`            BIGINT          NOT NULL AUTO_INCREMENT,
    `user_id`       BIGINT          NOT NULL UNIQUE,
    `full_name`     VARCHAR(200)    NOT NULL,
    `email`         VARCHAR(150)    NOT NULL,
    `phone_number`  VARCHAR(20),
    `address`       TEXT,
    `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_parent_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `student` (
    `id`                    BIGINT          NOT NULL AUTO_INCREMENT,
    `name`                  VARCHAR(100)    NOT NULL,
    `surname`               VARCHAR(100)    NOT NULL,
    `gender`                ENUM('MALE','FEMALE','OTHER'),
    `date_of_birth`         DATE,
    `birth_certificate_id`  VARCHAR(50)     NOT NULL UNIQUE,
    `nationality`           VARCHAR(50),
    `grade`                 VARCHAR(10)     NOT NULL,
    `year_of_admission`     INT,
    `previous_school`       VARCHAR(200),
    `latest_school_report`  VARCHAR(500),
    `parent_id`             BIGINT          NOT NULL,
    `class_name`            VARCHAR(50),
    `teacher`               VARCHAR(100),
    `status`                ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `rejection_reason`      TEXT,
    `created_at`            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `meeting` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT,
    `title`             VARCHAR(200)    NOT NULL,
    `description`       TEXT,
    `scheduled_time`    DATETIME,
    `teacher_id`        VARCHAR(100),
    `teacher_name`      VARCHAR(200),
    `parent_id`         BIGINT,
    `parent_name`       VARCHAR(200),
    `type`              ENUM('GROUP_MEETING','ONE_ON_ONE') NOT NULL DEFAULT 'GROUP_MEETING',
    `status`            ENUM('PENDING','APPROVED','REJECTED','SCHEDULED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    `rejection_reason`  TEXT,
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `trip` (
    `id`                    BIGINT          NOT NULL AUTO_INCREMENT,
    `title`                 VARCHAR(200)    NOT NULL,
    `description`           TEXT,
    `destination`           VARCHAR(200)    NOT NULL,
    `image_url`             LONGTEXT,
    `price`                 DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    `trip_date`             DATE            NOT NULL,
    `eligible_grades_str`   TEXT,
    `active`                TINYINT(1)      NOT NULL DEFAULT 1,
    `created_at`            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `payment` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT,
    `student_id`        BIGINT,
    `parent_id`         BIGINT,
    `trip_id`           BIGINT,
    `amount`            DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    `method`            VARCHAR(50),
    `status`            ENUM('PENDING','COMPLETED','FAILED') NOT NULL DEFAULT 'PENDING',
    `transaction_id`    VARCHAR(100)    UNIQUE,
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `trip_registration` (
    `id`                BIGINT      NOT NULL AUTO_INCREMENT,
    `trip_id`           BIGINT,
    `student_id`        BIGINT,
    `payment_id`        BIGINT,
    `consent_submitted` TINYINT(1)  NOT NULL DEFAULT 0,
    `status`            ENUM('REGISTERED','CANCELLED') NOT NULL DEFAULT 'REGISTERED',
    `registered_at`     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `announcement` (
    `id`            BIGINT      NOT NULL AUTO_INCREMENT,
    `title`         VARCHAR(200) NOT NULL,
    `content`       TEXT,
    `type`          ENUM('GENERAL','URGENT','EXAM','HOLIDAY') NOT NULL DEFAULT 'GENERAL',
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `document_request` (
    `id`            BIGINT      NOT NULL AUTO_INCREMENT,
    `parent_id`     BIGINT,
    `request_type`  VARCHAR(100),
    `description`   TEXT,
    `status`        ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `document` (
    `id`            BIGINT      NOT NULL AUTO_INCREMENT,
    `student_id`    BIGINT,
    `parent_id`     BIGINT,
    `document_type` VARCHAR(100),
    `file_name`     VARCHAR(255),
    `file_url`      LONGTEXT,
    `description`   TEXT,
    `mime_type`     VARCHAR(100),
    `file_size`     BIGINT,
    `verified`      TINYINT(1)  NOT NULL DEFAULT 0,
    `verified_by`   VARCHAR(200),
    `verified_at`   DATETIME,
    `uploaded_at`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
