package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.dto.LoginRequest;
import com.interfaceinnovators.sms_backend.dto.RegisterRequest;
import com.interfaceinnovators.sms_backend.dto.UserDto;
import com.interfaceinnovators.sms_backend.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserDto>> register(@RequestBody RegisterRequest request) {
        try {
            UserDto user = authService.register(request);
            return ResponseEntity.ok(ApiResponse.success(user, "Registration successful"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserDto>> login(@RequestBody LoginRequest request) {
        try {
            UserDto user = authService.login(request);
            return ResponseEntity.ok(ApiResponse.success(user, "Login successful"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<ApiResponse<Void>> forgotPassword(@RequestBody Map<String, String> body) {
        // Stub — no email service in academic project
        return ResponseEntity.ok(ApiResponse.success(null, "Password reset email sent (mock)"));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<Void>> resetPassword(@RequestBody Map<String, String> body) {
        try {
            authService.resetPassword(body.get("uid"), body.get("newPassword"));
            return ResponseEntity.ok(ApiResponse.success(null, "Password reset successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/user-by-email")
    public ResponseEntity<ApiResponse<UserDto>> getUserByEmail(@RequestParam String email) {
        try {
            UserDto user = authService.getUserByEmail(email);
            return ResponseEntity.ok(ApiResponse.success(user));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }
}
