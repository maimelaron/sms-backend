package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Application;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

/**
 * Stub — Application enrollment is handled through student registration (/parents/{id}/children).
 */
@RestController
@RequestMapping("/api/applications")
public class ApplicationController {

    @GetMapping
    public ResponseEntity<ApiResponse<List<Application>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(Collections.emptyList(),
                "Application management is handled through student enrollment."));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> getById(@PathVariable Long id) {
        return ResponseEntity.status(404).body(ApiResponse.error(
                "Applications are managed through student enrollment."));
    }
}
