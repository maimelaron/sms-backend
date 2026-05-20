package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "trip_registration")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TripRegistration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(name = "trip_id")
    private Long tripId;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "payment_id")
    private Long paymentId;

    @Builder.Default
    @Column(name = "consent_submitted", nullable = false)
    private Boolean consentSubmitted = false;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private RegistrationStatus status = RegistrationStatus.REGISTERED;

    @Column(name = "registered_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime registeredAt = LocalDateTime.now();

    @JsonProperty("registrationId")
    public String getRegistrationId() {
        return id != null ? String.valueOf(id) : null;
    }

    public enum RegistrationStatus {
        REGISTERED, CANCELLED
    }
}
