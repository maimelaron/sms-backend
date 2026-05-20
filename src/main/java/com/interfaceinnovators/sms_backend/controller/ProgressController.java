package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.ProgressRecord;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

/**
 * Stub — Progress records are not part of the current API contract.
 */
@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    @GetMapping
    public ResponseEntity<ApiResponse<List<ProgressRecord>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(Collections.emptyList()));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<ApiResponse<List<ProgressRecord>>> getByStudent(@PathVariable Long studentId) {
        return ResponseEntity.ok(ApiResponse.success(Collections.emptyList()));
    }
}
