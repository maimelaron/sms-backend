package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.model.User;
import com.interfaceinnovators.sms_backend.repository.StudentRepository;
import com.interfaceinnovators.sms_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/stats")
@RequiredArgsConstructor
public class StatsController {

    private final StudentRepository studentRepository;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, Long>>> getPublicStats() {
        long totalStudents = studentRepository.findByStatus(Student.StudentStatus.APPROVED).size();
        long totalTeachers = userRepository.findByRole(User.Role.TEACHER).size();
        Map<String, Long> stats = Map.of(
                "totalStudents", totalStudents,
                "totalTeachers", totalTeachers
        );
        return ResponseEntity.ok(ApiResponse.success(stats));
    }
}
