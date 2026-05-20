package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Payment;
import com.interfaceinnovators.sms_backend.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;

    @Transactional(readOnly = true)
    public List<Payment> findAll() {
        return paymentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Payment findById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public List<Payment> findByStudentId(Long studentId) {
        return paymentRepository.findByStudentId(studentId);
    }

    @Transactional(readOnly = true)
    public List<Payment> findByParentId(Long parentId) {
        return paymentRepository.findByParentId(parentId);
    }

    @Transactional(readOnly = true)
    public List<Payment> findByTripId(Long tripId) {
        return paymentRepository.findByTripId(tripId);
    }

    @Transactional(readOnly = true)
    public List<Payment> findByStatus(Payment.PaymentStatus status) {
        return paymentRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> checkPaymentStatus(Long studentId, Long tripId) {
        Optional<Payment> payment = paymentRepository.findByStudentIdAndTripId(studentId, tripId);
        boolean hasPaid = payment.map(p -> p.getStatus() == Payment.PaymentStatus.COMPLETED).orElse(false);
        return Map.of("hasPaid", hasPaid, "payment", payment.orElse(null));
    }

    @Transactional
    public Payment createMockPayment(Payment payment) {
        if (payment.getTransactionId() == null || payment.getTransactionId().isBlank()) {
            payment.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        if (payment.getStatus() == null) payment.setStatus(Payment.PaymentStatus.COMPLETED);
        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment update(Long id, Payment updated) {
        Payment existing = findById(id);
        existing.setAmount(updated.getAmount());
        existing.setMethod(updated.getMethod());
        existing.setStatus(updated.getStatus());
        return paymentRepository.save(existing);
    }

    @Transactional
    public Payment updateStatus(Long id, Payment.PaymentStatus status) {
        Payment existing = findById(id);
        existing.setStatus(status);
        return paymentRepository.save(existing);
    }

    @Transactional
    public void delete(Long id) {
        paymentRepository.deleteById(id);
    }
}
