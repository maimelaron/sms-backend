package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Student>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(studentService.findAll()));
    }

    @GetMapping("/pending")
    public ResponseEntity<ApiResponse<List<Student>>> getPending() {
        return ResponseEntity.ok(ApiResponse.success(
                studentService.findByStatus(Student.StudentStatus.PENDING)));
    }

    @GetMapping("/approved")
    public ResponseEntity<ApiResponse<List<Student>>> getApproved() {
        return ResponseEntity.ok(ApiResponse.success(
                studentService.findByStatus(Student.StudentStatus.APPROVED)));
    }

    @GetMapping("/rejected")
    public ResponseEntity<ApiResponse<List<Student>>> getRejected() {
        return ResponseEntity.ok(ApiResponse.success(
                studentService.findByStatus(Student.StudentStatus.REJECTED)));
    }

    @GetMapping("/parent/{parentId}")
    public ResponseEntity<ApiResponse<List<Student>>> getByParent(@PathVariable Long parentId) {
        return ResponseEntity.ok(ApiResponse.success(studentService.findByParent(parentId)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Student>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(studentService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Student>> create(@RequestBody Student student) {
        try {
            return ResponseEntity.ok(ApiResponse.success(studentService.save(student), "Student created"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Student>> update(@PathVariable Long id, @RequestBody Student student) {
        try {
            return ResponseEntity.ok(ApiResponse.success(studentService.update(id, student)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<Student>> approve(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(studentService.approve(id), "Student approved"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/approve-with-class")
    public ResponseEntity<ApiResponse<Student>> approveWithClass(
            @PathVariable Long id, @RequestBody Map<String, String> classData) {
        try {
            return ResponseEntity.ok(ApiResponse.success(
                    studentService.approveWithClass(id, classData), "Student approved with class"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Student>> reject(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        try {
            String reason = body.getOrDefault("reason", "Does not meet requirements.");
            return ResponseEntity.ok(ApiResponse.success(studentService.reject(id, reason), "Student rejected"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        studentService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Student deleted"));
    }
}
