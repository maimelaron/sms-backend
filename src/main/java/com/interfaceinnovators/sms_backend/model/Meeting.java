package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "meeting")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Meeting {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "scheduled_time")
    private LocalDateTime scheduledTime;

    @Column(name = "teacher_id", length = 100)
    private String teacherId;

    @Column(name = "teacher_name", length = 200)
    private String teacherName;

    /** FK to parent.id — plain Long for direct JSON serialisation */
    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "parent_name", length = 200)
    private String parentName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private MeetingType type = MeetingType.GROUP_MEETING;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private MeetingStatus status = MeetingStatus.PENDING;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonProperty("meetingId")
    public String getMeetingId() {
        return id != null ? String.valueOf(id) : null;
    }

    public enum MeetingType {
        GROUP_MEETING, ONE_ON_ONE
    }

    public enum MeetingStatus {
        PENDING, APPROVED, REJECTED, SCHEDULED, COMPLETED, CANCELLED
    }
}
