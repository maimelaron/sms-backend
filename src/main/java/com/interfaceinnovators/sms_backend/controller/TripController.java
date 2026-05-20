package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.model.Trip;
import com.interfaceinnovators.sms_backend.model.TripRegistration;
import com.interfaceinnovators.sms_backend.service.TripService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/trips")
@RequiredArgsConstructor
public class TripController {

    private final TripService tripService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Trip>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(tripService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Trip>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Trip>> create(@RequestBody Trip trip) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.save(trip), "Trip created"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Trip>> update(@PathVariable Long id, @RequestBody Trip trip) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.update(id, trip)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        tripService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Trip deleted"));
    }

    @PutMapping("/{id}/hold")
    public ResponseEntity<ApiResponse<Trip>> hold(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.hold(id), "Trip put on hold"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/activate")
    public ResponseEntity<ApiResponse<Trip>> activate(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.activate(id), "Trip activated"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/image")
    public ResponseEntity<ApiResponse<Trip>> updateImage(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        try {
            String imageData = body.getOrDefault("imageData", body.get("imageUrl"));
            return ResponseEntity.ok(ApiResponse.success(tripService.updateImage(id, imageData)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/{id}/register")
    public ResponseEntity<ApiResponse<TripRegistration>> register(
            @PathVariable Long id, @RequestBody Map<String, Object> body) {
        try {
            Long studentId = body.containsKey("studentId")
                    ? Long.parseLong(body.get("studentId").toString()) : null;
            Long parentId = body.containsKey("parentId")
                    ? Long.parseLong(body.get("parentId").toString()) : null;
            String paymentMethod = (String) body.getOrDefault("paymentMethod", "Mock Payment");

            TripRegistration reg = tripService.register(id, studentId, parentId, paymentMethod);
            return ResponseEntity.ok(ApiResponse.success(reg, "Registered and payment processed"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}/register/{studentId}")
    public ResponseEntity<ApiResponse<Void>> unregister(
            @PathVariable Long id, @PathVariable Long studentId) {
        tripService.unregister(id, studentId);
        return ResponseEntity.ok(ApiResponse.success(null, "Unregistered from trip"));
    }

    @GetMapping("/{id}/paid-students")
    public ResponseEntity<ApiResponse<Map<String, List<Student>>>> getPaidStudentsByGrade(
            @PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(tripService.getPaidStudentsByGrade(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
