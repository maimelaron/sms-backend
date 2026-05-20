package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Payment;
import com.interfaceinnovators.sms_backend.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Payment>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(paymentService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Payment>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(paymentService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/mock")
    public ResponseEntity<ApiResponse<Payment>> createMock(@RequestBody Payment payment) {
        try {
            return ResponseEntity.ok(ApiResponse.success(paymentService.createMockPayment(payment), "Payment processed"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Payment>> update(@PathVariable Long id, @RequestBody Payment payment) {
        try {
            return ResponseEntity.ok(ApiResponse.success(paymentService.update(id, payment)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        paymentService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Payment deleted"));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<ApiResponse<List<Payment>>> getByStudent(@PathVariable Long studentId) {
        return ResponseEntity.ok(ApiResponse.success(paymentService.findByStudentId(studentId)));
    }

    @GetMapping("/parent/{parentId}")
    public ResponseEntity<ApiResponse<List<Payment>>> getByParent(@PathVariable Long parentId) {
        return ResponseEntity.ok(ApiResponse.success(paymentService.findByParentId(parentId)));
    }

    @GetMapping("/trip/{tripId}")
    public ResponseEntity<ApiResponse<List<Payment>>> getByTrip(@PathVariable Long tripId) {
        return ResponseEntity.ok(ApiResponse.success(paymentService.findByTripId(tripId)));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<Payment>>> getByStatus(@PathVariable String status) {
        try {
            Payment.PaymentStatus ps = Payment.PaymentStatus.valueOf(status.toUpperCase());
            return ResponseEntity.ok(ApiResponse.success(paymentService.findByStatus(ps)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Invalid status: " + status));
        }
    }

    @GetMapping("/check/{studentId}/{tripId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> checkStatus(
            @PathVariable Long studentId, @PathVariable Long tripId) {
        return ResponseEntity.ok(ApiResponse.success(paymentService.checkPaymentStatus(studentId, tripId)));
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<Payment>> updateStatus(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        try {
            Payment.PaymentStatus status = Payment.PaymentStatus.valueOf(body.get("status").toUpperCase());
            return ResponseEntity.ok(ApiResponse.success(paymentService.updateStatus(id, status)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
