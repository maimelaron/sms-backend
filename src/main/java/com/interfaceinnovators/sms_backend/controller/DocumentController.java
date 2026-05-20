package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Document;
import com.interfaceinnovators.sms_backend.service.DocumentService;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/documents")
@RequiredArgsConstructor
public class DocumentController {

    private final DocumentService documentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Document>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(documentService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Document>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(documentService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Document>> upload(@RequestBody Document document) {
        try {
            if (document.getFileName() == null || document.getFileName().isBlank())
                return ResponseEntity.badRequest().body(ApiResponse.error("Please select a file to upload."));
            if (document.getDocumentType() == null || document.getDocumentType().isBlank())
                return ResponseEntity.badRequest().body(ApiResponse.error("Please select a document type."));
            return ResponseEntity.ok(ApiResponse.success(documentService.upload(document), "Document uploaded successfully."));
        } catch (DataIntegrityViolationException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Upload failed: a required field is missing. Please check your input and try again."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Upload failed. Please try again."));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Document>> update(@PathVariable Long id, @RequestBody Document document) {
        try {
            return ResponseEntity.ok(ApiResponse.success(documentService.update(id, document)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        documentService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Document deleted"));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<ApiResponse<List<Document>>> getByStudent(@PathVariable Long studentId) {
        return ResponseEntity.ok(ApiResponse.success(documentService.findByStudentId(studentId)));
    }

    @GetMapping("/parent/{parentId}")
    public ResponseEntity<ApiResponse<List<Document>>> getByParent(@PathVariable Long parentId) {
        return ResponseEntity.ok(ApiResponse.success(documentService.findByParentId(parentId)));
    }

    @GetMapping("/type/{documentType}")
    public ResponseEntity<ApiResponse<List<Document>>> getByType(@PathVariable String documentType) {
        return ResponseEntity.ok(ApiResponse.success(documentService.findByType(documentType)));
    }

    @GetMapping("/unverified")
    public ResponseEntity<ApiResponse<List<Document>>> getUnverified() {
        return ResponseEntity.ok(ApiResponse.success(documentService.findUnverified()));
    }

    @PutMapping("/{id}/verify")
    public ResponseEntity<ApiResponse<Document>> verify(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        try {
            String verifiedBy = body.getOrDefault("verifiedBy", "Admin");
            return ResponseEntity.ok(ApiResponse.success(documentService.verify(id, verifiedBy)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
