package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "document")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Document {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "document_type", length = 100)
    private String documentType;

    @Column(name = "file_name", length = 255)
    private String fileName;

    @Column(name = "file_url", columnDefinition = "LONGTEXT")
    private String fileUrl;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "mime_type", length = 100)
    private String mimeType;

    @Column(name = "file_size")
    private Long fileSize;

    @Builder.Default
    @Column(nullable = false)
    private Boolean verified = false;

    @Column(name = "verified_by", length = 200)
    private String verifiedBy;

    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;

    @Column(name = "uploaded_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime uploadedAt = LocalDateTime.now();

    @JsonProperty("documentId")
    public String getDocumentId() {
        return id != null ? String.valueOf(id) : null;
    }
}
