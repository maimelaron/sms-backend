package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "parent")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Parent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    @JsonIgnore
    private User user;

    @Column(name = "full_name", nullable = false, length = 200)
    private String fullName;

    @Column(nullable = false, length = 150)
    private String email;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    /** Numeric id serialised as string "parentId" */
    @JsonProperty("parentId")
    public String getParentId() {
        return id != null ? String.valueOf(id) : null;
    }

    /** Firebase-style uid — maps to the linked User's numeric id */
    @JsonProperty("uid")
    public String getUid() {
        return (user != null && user.getId() != null) ? String.valueOf(user.getId()) : null;
    }
}
