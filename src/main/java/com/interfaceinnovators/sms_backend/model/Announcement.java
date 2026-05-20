package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "announcement")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Announcement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private AnnouncementType type = AnnouncementType.GENERAL;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonProperty("announcementId")
    public String getAnnouncementId() {
        return id != null ? String.valueOf(id) : null;
    }

    public enum AnnouncementType {
        GENERAL, URGENT, EXAM, HOLIDAY
    }
}
