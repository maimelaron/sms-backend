# SMS — Coding Plan (How We Build It)

## Implementation Order (strict — each step depends on the one above)

### Step 1 — Database
1. `src/main/resources/schema.sql` — 9 CREATE TABLE statements in FK-safe order
2. `src/main/resources/data.sql` — seed data (INSERT IGNORE, 5+ records in user/student/application)
3. `src/main/resources/application.properties` — MySQL connection + JPA config

### Step 2 — Backend Config
4. `config/CorsConfig.java` — allow localhost:3000 → localhost:8080

### Step 3 — Backend Models (FK-safe order)
5. `model/User.java`
6. `model/Student.java`
7. `model/Application.java`
8. `model/Trip.java`
9. `model/Payment.java`
10. `model/Meeting.java`
11. `model/TripRegistration.java`
12. `model/ProgressRecord.java`
13. `model/Document.java`

### Step 4 — Repositories (one line each, any order)
14–22. One `JpaRepository` interface per entity

### Step 5 — Services (business logic)
23. `UserService`
24. `StudentService`
25. `ApplicationService` (owns approve/reject logic)
26. `TripService`
27. `PaymentService` (auto-generates reference number)
28. `MeetingService`
29. `ProgressService`

### Step 6 — Controllers (REST endpoints)
30. `UserController` → `/api/users`
31. `StudentController` → `/api/students`
32. `ApplicationController` → `/api/applications`
33. `TripController` → `/api/trips`
34. `PaymentController` → `/api/payments`
35. `MeetingController` → `/api/meetings`
36. `ProgressController` → `/api/progress`

### Step 7 — Frontend Shared Infrastructure
37. `src/api/axios.js` — Axios base instance pointing to localhost:8080
38. `src/components/Table.jsx` — reusable table (columns + data props)
39. `src/components/Modal.jsx` — reusable modal (isOpen, onClose, title, children)
40. `src/components/Navbar.jsx` — links to all 6 pages
41. `src/App.js` — React Router v7 routes for all 6 pages

### Step 8 — Frontend Pages (each member's page)
42. `pages/ApplicationsPage.jsx` — Member 1: list + approve/reject
43. `pages/StudentsPage.jsx` — Member 2: list + update
44. `pages/TripsPage.jsx` — Member 3: list + create + delete
45. `pages/PaymentsPage.jsx` — Member 4: list + insert
46. `pages/MeetingsPage.jsx` — Member 5: list + update
47. `pages/UsersPage.jsx` — Member 6: list + delete

---

## Key Rules Followed
- NO `@Data` on JPA entities — use `@Getter @Setter @NoArgsConstructor @AllArgsConstructor`
- All `@ManyToOne` fields get explicit `@JoinColumn(name="col_name")` — critical for Meeting/ProgressRecord which have 2 FKs to same table
- All ENUM fields get `@Enumerated(EnumType.STRING)`
- `spring.jpa.open-in-view=false` — prevent lazy load issues
- `INSERT IGNORE` in data.sql — safe to re-run on restart
- All pages import from `src/api/axios.js` — never hardcode the URL
- After every mutation, re-fetch the list to keep UI in sync

---

## Table Creation Order (FK constraint safety)
```
user → student → application → trip → payment → meeting
     → trip_registration → progress_record → document
```

## Seed Data Summary
- 7 users: 1 ADMIN, 4 PARENT, 2 TEACHER
- 5 students: 4 ACTIVE, 1 PENDING (parent_ids 2–5)
- 6 applications: 2 APPROVED, 3 PENDING, 1 REJECTED (mix for UI demo)
- 3+ trips, 3+ payments, 3+ meetings, 3+ progress records
