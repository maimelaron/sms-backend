package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "document_request")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DocumentRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "request_type", length = 100)
    private String requestType;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private DocumentRequestStatus status = DocumentRequestStatus.PENDING;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonProperty("requestId")
    public String getRequestId() {
        return id != null ? String.valueOf(id) : null;
    }

    public enum DocumentRequestStatus {
        PENDING, APPROVED, REJECTED
    }
}
