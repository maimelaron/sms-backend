package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "student")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 100)
    private String surname;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Gender gender;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "birth_certificate_id", nullable = false, unique = true, length = 50)
    private String birthCertificateId;

    @Column(length = 50)
    private String nationality;

    @Column(nullable = false, length = 10)
    private String grade;

    @Column(name = "year_of_admission")
    private Integer yearOfAdmission;

    @Column(name = "previous_school", length = 200)
    private String previousSchool;

    @Column(name = "latest_school_report", length = 500)
    private String latestSchoolReport;

    /** FK to parent.id — stored as plain Long for direct JSON serialisation */
    @Column(name = "parent_id", nullable = false)
    private Long parentId;

    @Column(name = "class_name", length = 50)
    private String className;

    @Column(length = 100)
    private String teacher;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private StudentStatus status = StudentStatus.PENDING;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonProperty("studentId")
    public String getStudentId() {
        return id != null ? String.valueOf(id) : null;
    }

    @JsonProperty("fullName")
    public String getFullName() {
        return (name != null ? name : "") + " " + (surname != null ? surname : "");
    }

    public enum StudentStatus {
        PENDING, APPROVED, REJECTED
    }

    public enum Gender {
        MALE, FEMALE, OTHER
    }
}
