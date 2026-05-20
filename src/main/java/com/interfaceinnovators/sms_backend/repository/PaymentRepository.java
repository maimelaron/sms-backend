package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByStatus(Payment.PaymentStatus status);
    List<Payment> findByStudentId(Long studentId);
    List<Payment> findByParentId(Long parentId);
    List<Payment> findByTripId(Long tripId);
    Optional<Payment> findByStudentIdAndTripId(Long studentId, Long tripId);
}
