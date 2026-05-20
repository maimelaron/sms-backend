package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.dto.RegisterRequest;
import com.interfaceinnovators.sms_backend.dto.UserDto;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.model.User;
import com.interfaceinnovators.sms_backend.repository.StudentRepository;
import com.interfaceinnovators.sms_backend.service.SuperAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/super-admin")
@RequiredArgsConstructor
public class SuperAdminController {

    private final SuperAdminService superAdminService;
    private final StudentRepository studentRepository;

    // ---- User Management ----

    @GetMapping("/users")
    public ResponseEntity<ApiResponse<List<User>>> getUsers(
            @RequestParam(required = false) User.Role role) {
        List<User> users = role != null
                ? superAdminService.getUsersByRole(role)
                : superAdminService.getAllUsers();
        return ResponseEntity.ok(ApiResponse.success(users));
    }

    @PostMapping("/users")
    public ResponseEntity<ApiResponse<UserDto>> createUser(@RequestBody RegisterRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(
                    superAdminService.createUser(request), "User created successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/users/{id}")
    public ResponseEntity<ApiResponse<User>> updateUser(
            @PathVariable Long id, @RequestBody User user) {
        try {
            return ResponseEntity.ok(ApiResponse.success(superAdminService.updateUser(id, user)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/users/{id}/deactivate")
    public ResponseEntity<ApiResponse<Void>> deactivateUser(@PathVariable Long id) {
        try {
            superAdminService.deactivateUser(id);
            return ResponseEntity.ok(ApiResponse.success(null, "User deactivated"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteUser(@PathVariable Long id) {
        try {
            superAdminService.deleteUser(id);
            return ResponseEntity.ok(ApiResponse.success(null, "User deleted"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    // ---- Students (read-only view) ----

    @GetMapping("/students")
    public ResponseEntity<ApiResponse<List<Student>>> getAllStudents(
            @RequestParam(required = false) String status) {
        List<Student> students;
        if (status != null) {
            try {
                students = studentRepository.findByStatus(Student.StudentStatus.valueOf(status.toUpperCase()));
            } catch (IllegalArgumentException e) {
                students = studentRepository.findAll();
            }
        } else {
            students = studentRepository.findAll();
        }
        return ResponseEntity.ok(ApiResponse.success(students));
    }
}
