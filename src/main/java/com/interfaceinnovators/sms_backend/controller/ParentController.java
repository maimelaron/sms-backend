package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.DocumentRequest;
import com.interfaceinnovators.sms_backend.model.Parent;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.service.DocumentService;
import com.interfaceinnovators.sms_backend.service.ParentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/parents")
@RequiredArgsConstructor
public class ParentController {

    private final ParentService parentService;
    private final DocumentService documentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Parent>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(parentService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Parent>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(parentService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Parent>> update(@PathVariable Long id, @RequestBody Parent parent) {
        try {
            return ResponseEntity.ok(ApiResponse.success(parentService.update(id, parent)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        parentService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Parent deleted"));
    }

    @PostMapping("/{id}/children")
    public ResponseEntity<ApiResponse<Student>> addChild(@PathVariable Long id, @RequestBody Student child) {
        try {
            Student saved = parentService.addChild(id, child);
            return ResponseEntity.ok(ApiResponse.success(saved, "Child added successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/{id}/children")
    public ResponseEntity<ApiResponse<List<Student>>> getChildren(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(parentService.getChildren(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/children/{studentId}")
    public ResponseEntity<ApiResponse<Student>> updateChild(
            @PathVariable Long id,
            @PathVariable Long studentId,
            @RequestBody Student student) {
        try {
            Student updated = parentService.updateChild(id, studentId, student);
            return ResponseEntity.ok(ApiResponse.success(updated));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/{id}/document-requests")
    public ResponseEntity<ApiResponse<DocumentRequest>> requestDocument(
            @PathVariable Long id,
            @RequestBody DocumentRequest request) {
        try {
            DocumentRequest saved = documentService.requestDocument(id, request);
            return ResponseEntity.ok(ApiResponse.success(saved, "Document request submitted"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
