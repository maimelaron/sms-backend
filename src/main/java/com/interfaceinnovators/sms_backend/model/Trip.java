package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Entity
@Table(name = "trip")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Trip {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 200)
    private String destination;

    @Column(name = "image_url", columnDefinition = "LONGTEXT")
    private String imageUrl;

    @Column(nullable = false, precision = 10, scale = 2)
    @Builder.Default
    private BigDecimal price = BigDecimal.ZERO;

    @Column(name = "trip_date", nullable = false)
    private LocalDate tripDate;

    /** Stored as comma-separated grades e.g. "1,2,3,R" */
    @JsonIgnore
    @Column(name = "eligible_grades_str", columnDefinition = "TEXT")
    private String eligibleGradesStr;

    @Builder.Default
    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    /** Populated at runtime by service — not persisted */
    @Transient
    private List<String> registeredStudents;

    @JsonProperty("tripId")
    public String getTripId() {
        return id != null ? String.valueOf(id) : null;
    }

    @JsonProperty("eligibleGrades")
    public List<String> getEligibleGrades() {
        if (eligibleGradesStr == null || eligibleGradesStr.isBlank()) return new ArrayList<>();
        return Arrays.asList(eligibleGradesStr.split(","));
    }

    @JsonProperty("eligibleGrades")
    public void setEligibleGrades(List<String> grades) {
        this.eligibleGradesStr = (grades != null && !grades.isEmpty())
                ? String.join(",", grades) : null;
    }
}
