package com.interfaceinnovators.sms_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payment")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "trip_id")
    private Long tripId;

    @Column(nullable = false, precision = 10, scale = 2)
    @Builder.Default
    private BigDecimal amount = BigDecimal.ZERO;

    @Column(length = 50)
    private String method;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private PaymentStatus status = PaymentStatus.PENDING;

    @Column(name = "transaction_id", unique = true, length = 100)
    private String transactionId;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonProperty("paymentId")
    public String getPaymentId() {
        return id != null ? String.valueOf(id) : null;
    }

    public enum PaymentStatus {
        PENDING, COMPLETED, FAILED
    }
}
