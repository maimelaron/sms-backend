# School Management System — Implementation Plan
**Group:** Interface Innovators
**Assessment:** Assessment 2 (due current semester)
**Stack:** Spring Boot (Java 17) · React 19 · MySQL · Axios · React Router

---

## Group Members & Page Assignments (Assessment 2)

| # | Member | Student No. | Assigned Page / Feature |
|---|--------|-------------|------------------------|
| 1 | PJ Manamela (Leader) | 221992059 | Application Management (list + approve/reject) |
| 2 | A Dipheko | 224057830 | Student Records (list + update) |
| 3 | MM Mamabolo | 224044682 | Trip Management (list + create + delete) |
| 4 | KE Motlhokodi | 223825303 | Payment Monitoring (list + insert) |
| 5 | LN Mashego | 222400074 | Meeting Scheduling (list + update) |
| 6 | R Moeletsi | 222862515 | User Management (list + delete) |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend (UI) | React 19, React Router v7, Axios |
| Backend (API) | Spring Boot 4.x, Java 17, Spring Data JPA, Lombok |
| Database | MySQL 8.x (OpenSource — satisfies Assessment 2 requirement) |
| Build | Maven (backend), npm (frontend) |

---

## Project Structure

### Backend — `sms-backend`
```
src/main/java/com/interfaceinnovators/sms_backend/
├── config/
│   └── CorsConfig.java
├── model/
│   ├── User.java
│   ├── Parent.java
│   ├── Teacher.java
│   ├── Student.java
│   ├── Application.java
│   ├── Document.java
│   ├── Payment.java
│   ├── Meeting.java
│   ├── Trip.java
│   ├── TripRegistration.java
│   ├── TripAttendance.java
│   └── ProgressRecord.java
├── repository/
│   ├── UserRepository.java
│   ├── ParentRepository.java
│   ├── TeacherRepository.java
│   ├── StudentRepository.java
│   ├── ApplicationRepository.java
│   ├── DocumentRepository.java
│   ├── PaymentRepository.java
│   ├── MeetingRepository.java
│   ├── TripRepository.java
│   ├── TripRegistrationRepository.java
│   ├── TripAttendanceRepository.java
│   └── ProgressRecordRepository.java
├── service/
│   ├── UserService.java
│   ├── StudentService.java
│   ├── ApplicationService.java
│   ├── PaymentService.java
│   ├── MeetingService.java
│   ├── TripService.java
│   └── ProgressService.java
└── controller/
    ├── UserController.java
    ├── StudentController.java
    ├── ApplicationController.java
    ├── PaymentController.java
    ├── MeetingController.java
    ├── TripController.java
    └── ProgressController.java

src/main/resources/
├── application.properties
└── db/
    ├── schema.sql          ← database creation script (print for assessment)
    └── data.sql            ← seed data (5+ records per table)
```

### Frontend — `sms-frontend`
```
src/
├── api/
│   └── axios.js            ← base Axios instance (baseURL = http://localhost:8080)
├── pages/
│   ├── ApplicationsPage.jsx        ← Member 1 (PJ)
│   ├── StudentsPage.jsx            ← Member 2 (A Dipheko)
│   ├── TripsPage.jsx               ← Member 3 (MM Mamabolo)
│   ├── PaymentsPage.jsx            ← Member 4 (KE Motlhokodi)
│   ├── MeetingsPage.jsx            ← Member 5 (LN Mashego)
│   └── UsersPage.jsx               ← Member 6 (R Moeletsi)
├── components/
│   ├── Navbar.jsx
│   ├── Table.jsx           ← reusable table
│   └── Modal.jsx           ← reusable form modal
├── App.jsx
└── index.js
```

---

## Database Design (ERD Tables)

> **Naming standard:** snake_case, singular table names, `id` as PK, FK named `<table>_id`

### Table 1: `user`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| first_name | VARCHAR(100) | NOT NULL |
| last_name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | NOT NULL |
| role | ENUM('PARENT','TEACHER','ADMIN') | NOT NULL |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 2: `student`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| student_number | VARCHAR(20) | UNIQUE |
| first_name | VARCHAR(100) | NOT NULL |
| last_name | VARCHAR(100) | NOT NULL |
| date_of_birth | DATE | NOT NULL |
| grade | VARCHAR(10) | NOT NULL |
| parent_id | BIGINT | FK → user(id) |
| status | ENUM('PENDING','ACTIVE','INACTIVE') | DEFAULT 'PENDING' |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 3: `application`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| parent_id | BIGINT | FK → user(id) |
| student_first_name | VARCHAR(100) | NOT NULL |
| student_last_name | VARCHAR(100) | NOT NULL |
| date_of_birth | DATE | NOT NULL |
| grade_applying_for | VARCHAR(10) | NOT NULL |
| status | ENUM('PENDING','APPROVED','REJECTED') | DEFAULT 'PENDING' |
| reviewed_by | BIGINT | FK → user(id), nullable |
| submitted_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| reviewed_at | TIMESTAMP | nullable |
| rejection_reason | TEXT | nullable |

### Table 4: `payment`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| student_id | BIGINT | FK → student(id) |
| parent_id | BIGINT | FK → user(id) |
| amount | DECIMAL(10,2) | NOT NULL |
| payment_type | ENUM('TUITION','TRIP','OTHER') | NOT NULL |
| status | ENUM('PENDING','SUCCESSFUL','FAILED') | DEFAULT 'PENDING' |
| reference_number | VARCHAR(50) | UNIQUE |
| paid_at | TIMESTAMP | nullable |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 5: `meeting`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| parent_id | BIGINT | FK → user(id) |
| teacher_id | BIGINT | FK → user(id) |
| student_id | BIGINT | FK → student(id) |
| requested_date | DATE | NOT NULL |
| requested_time | TIME | NOT NULL |
| status | ENUM('PENDING','APPROVED','REJECTED') | DEFAULT 'PENDING' |
| confirmed_date | DATE | nullable |
| confirmed_time | TIME | nullable |
| notes | TEXT | nullable |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 6: `trip`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | |
| destination | VARCHAR(200) | NOT NULL |
| trip_date | DATE | NOT NULL |
| return_date | DATE | NOT NULL |
| cost | DECIMAL(10,2) | NOT NULL |
| max_participants | INT | NOT NULL |
| created_by | BIGINT | FK → user(id) |
| status | ENUM('OPEN','CLOSED','CANCELLED') | DEFAULT 'OPEN' |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 7: `trip_registration`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| trip_id | BIGINT | FK → trip(id) |
| student_id | BIGINT | FK → student(id) |
| payment_id | BIGINT | FK → payment(id), nullable |
| consent_submitted | BOOLEAN | DEFAULT FALSE |
| status | ENUM('REGISTERED','CANCELLED') | DEFAULT 'REGISTERED' |
| registered_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 8: `progress_record`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| student_id | BIGINT | FK → student(id) |
| teacher_id | BIGINT | FK → user(id) |
| subject | VARCHAR(100) | NOT NULL |
| term | ENUM('TERM_1','TERM_2','TERM_3','TERM_4') | NOT NULL |
| year | YEAR | NOT NULL |
| mark | DECIMAL(5,2) | NOT NULL |
| comment | TEXT | nullable |
| recorded_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### Table 9: `document`
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT |
| application_id | BIGINT | FK → application(id) |
| document_type | VARCHAR(100) | NOT NULL |
| file_name | VARCHAR(255) | NOT NULL |
| file_path | VARCHAR(500) | NOT NULL |
| uploaded_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

---

## API Endpoints

### User / Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | List all users |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Create user |
| PUT | `/api/users/{id}` | Update user |
| DELETE | `/api/users/{id}` | Delete user |

### Applications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/applications` | List all applications |
| GET | `/api/applications/{id}` | Get application |
| POST | `/api/applications` | Submit application |
| PUT | `/api/applications/{id}/approve` | Approve application |
| PUT | `/api/applications/{id}/reject` | Reject application |

### Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/students` | List all students |
| GET | `/api/students/{id}` | Get student |
| POST | `/api/students` | Create student |
| PUT | `/api/students/{id}` | Update student |
| DELETE | `/api/students/{id}` | Delete student |

### Payments
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/payments` | List all payments |
| GET | `/api/payments/{id}` | Get payment |
| POST | `/api/payments` | Record payment |
| PUT | `/api/payments/{id}` | Update payment status |

### Meetings
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/meetings` | List all meetings |
| GET | `/api/meetings/{id}` | Get meeting |
| POST | `/api/meetings` | Request meeting |
| PUT | `/api/meetings/{id}` | Approve/reject/update meeting |
| DELETE | `/api/meetings/{id}` | Cancel meeting |

### Trips
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/trips` | List all trips |
| GET | `/api/trips/{id}` | Get trip |
| POST | `/api/trips` | Create trip |
| PUT | `/api/trips/{id}` | Update trip |
| DELETE | `/api/trips/{id}` | Delete trip |
| GET | `/api/trips/{id}/registrations` | Get trip registrations |
| POST | `/api/trips/{id}/register` | Register student for trip |

### Progress Records
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/progress` | List all records |
| GET | `/api/progress/student/{studentId}` | Get student progress |
| POST | `/api/progress` | Add progress record |
| PUT | `/api/progress/{id}` | Update progress record |

---

## Implementation Steps

### Phase 1 — Database Setup (Assessment 2 Priority)

- [ ] **1.1** Create MySQL database: `CREATE DATABASE sms_db;`
- [ ] **1.2** Write `schema.sql` — full CREATE TABLE script for all 9 tables with FK constraints
- [ ] **1.3** Write `data.sql` — seed data (minimum 5 records per table for the 3 assessment tables: `user`, `student`, `application`)
- [ ] **1.4** Configure `application.properties`:
  ```properties
  spring.datasource.url=jdbc:mysql://localhost:3306/sms_db
  spring.datasource.username=root
  spring.datasource.password=<your_password>
  spring.jpa.hibernate.ddl-auto=validate
  spring.jpa.show-sql=true
  spring.sql.init.mode=always
  ```
- [ ] **1.5** Print ERD diagram + database script for assessment submission

### Phase 2 — Backend (Spring Boot API)

- [ ] **2.1** Add `CorsConfig.java` to allow React frontend (`localhost:3000`)
- [ ] **2.2** Create JPA `@Entity` models for all 9 tables
- [ ] **2.3** Create `JpaRepository` interfaces for all entities
- [ ] **2.4** Create service classes with business logic
- [ ] **2.5** Create `@RestController` classes for all API endpoints
- [ ] **2.6** Test all endpoints with Postman / curl

### Phase 3 — Frontend (React) — Assessment 2 Pages

Each member implements their assigned page. Each page must:
1. **List** all records from the API (fetched on load with Axios)
2. **Perform at least one of** insert / update / delete via API calls

#### Member 1 — `ApplicationsPage.jsx` (PJ Manamela)
- Table listing: id, applicant name, grade, status, submitted date
- Buttons: "Approve" → PUT `/api/applications/{id}/approve`, "Reject" → PUT `/api/applications/{id}/reject`
- Status badge coloring (PENDING=yellow, APPROVED=green, REJECTED=red)

#### Member 2 — `StudentsPage.jsx` (A Dipheko)
- Table listing: student number, name, grade, status, parent
- Inline edit or modal: update grade, status
- PUT `/api/students/{id}`

#### Member 3 — `TripsPage.jsx` (MM Mamabolo)
- Table listing: title, destination, date, cost, status, participants
- "Add Trip" button → form modal → POST `/api/trips`
- "Delete" button per row → DELETE `/api/trips/{id}`

#### Member 4 — `PaymentsPage.jsx` (KE Motlhokodi)
- Table listing: reference, student name, amount, type, status, date
- "Record Payment" form → POST `/api/payments`
- Filter by status (PENDING / SUCCESSFUL / FAILED)

#### Member 5 — `MeetingsPage.jsx` (LN Mashego)
- Table listing: parent, teacher, student, requested date/time, status
- "Approve" → updates confirmed date/time → PUT `/api/meetings/{id}`
- "Reject" → PUT `/api/meetings/{id}` with status=REJECTED

#### Member 6 — `UsersPage.jsx` (R Moeletsi)
- Table listing: name, email, role, created date
- "Delete" button per row → DELETE `/api/users/{id}` (with confirmation dialog)
- Role filter dropdown

### Phase 4 — Integration & Polish

- [ ] **4.1** Add `Navbar.jsx` with links to all 6 pages
- [ ] **4.2** Add loading spinners and error messages on API failures
- [ ] **4.3** Add basic form validation on all forms
- [ ] **4.4** Test all CRUD flows end-to-end

### Phase 5 — Full System Features (Post-Assessment 2)

- [ ] **5.1** Authentication — JWT-based login (Spring Security + JWT)
- [ ] **5.2** Role-based access control (PARENT / TEACHER / ADMIN routes)
- [ ] **5.3** File upload for documents (multipart/form-data → stored on server)
- [ ] **5.4** Payment receipt generation (PDF)
- [ ] **5.5** Notifications system
- [ ] **5.6** Student progress reports (PDF export)
- [ ] **5.7** Trip attendance management
- [ ] **5.8** Parent portal (view student progress, trips, payments)

---

## Assessment 2 Checklist

### OpenSource Database (6 marks)
- [ ] ERD printed — field and table names in snake_case naming standard (2 marks)
- [ ] Database creation script printed (1 mark)
- [ ] 3 example tables created and populated with 5+ records each — use `user`, `student`, `application` (1 mark)
- [ ] Foreign key relationships created as per ERD (2 marks)

### Logical Tiers (14 marks)
- [ ] User Interface — React frontend running on `localhost:3000` (3 marks)
- [ ] API Services — Spring Boot REST API on `localhost:8080` (2 marks)
- [ ] Database — MySQL `sms_db` (2 marks)
- [ ] **Member 1 (PJ):** ApplicationsPage — list (2) + approve/reject (5) = 7 marks
- [ ] **Member 2 (A Dipheko):** StudentsPage — list (2) + update (5) = 7 marks
- [ ] **Member 3 (MM Mamabolo):** TripsPage — list (2) + create+delete (5) = 7 marks
- [ ] **Member 4 (KE Motlhokodi):** PaymentsPage — list (2) + insert (5) = 7 marks
- [ ] **Member 5 (LN Mashego):** MeetingsPage — list (2) + update (5) = 7 marks
- [ ] **Member 6 (R Moeletsi):** UsersPage — list (2) + delete (5) = 7 marks

> **Note:** Each member gets individual marks. All pages must be different. No two members use the same page.

---

## What to Build First (Recommended Order)

1. Create MySQL database and run `schema.sql`
2. Seed data with `data.sql` (5+ records in `user`, `student`, `application`)
3. Configure `application.properties` and verify Spring Boot connects to MySQL
4. Build entity models + repositories + controllers (all at once — they are straightforward)
5. Each member builds and tests their individual page against the running API
6. Add `Navbar` + routing so the app is presentable as a whole

---

## Running the System

### Backend
```bash
cd C:/Users/am120754/IdeaProjects/sms-backend
./mvnw spring-boot:run
# API available at http://localhost:8080
```

### Frontend
```bash
cd C:/Users/am120754/WebstormProjects/sms-frontend
npm start
# UI available at http://localhost:3000
```

### MySQL
```sql
CREATE DATABASE sms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sms_db;
-- then run schema.sql
```

---

## Key Notes

- The proposal used **Firebase** as the backend — this implementation **replaces Firebase with MySQL + Spring Boot JPA**, which satisfies the "OpenSource database" requirement of Assessment 2.
- Spring Boot's `spring.sql.init.mode=always` will auto-run `schema.sql` and `data.sql` from `src/main/resources/` on startup.
- Use `spring.jpa.hibernate.ddl-auto=validate` (not `create`) once the schema is stable so data is not wiped on restart.
- CORS must be configured in Spring Boot to allow the React dev server (`localhost:3000`) to call the API.
