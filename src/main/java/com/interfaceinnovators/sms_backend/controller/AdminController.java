package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Announcement;
import com.interfaceinnovators.sms_backend.model.DocumentRequest;
import com.interfaceinnovators.sms_backend.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    // ---- Announcements ----

    @GetMapping("/announcements")
    public ResponseEntity<ApiResponse<List<Announcement>>> getAllAnnouncements() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getAllAnnouncements()));
    }

    @GetMapping("/announcements/{id}")
    public ResponseEntity<ApiResponse<Announcement>> getAnnouncementById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(adminService.getAnnouncementById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/announcements")
    public ResponseEntity<ApiResponse<Announcement>> createAnnouncement(@RequestBody Announcement announcement) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.createAnnouncement(announcement), "Announcement created"));
    }

    @PutMapping("/announcements/{id}")
    public ResponseEntity<ApiResponse<Announcement>> updateAnnouncement(
            @PathVariable Long id, @RequestBody Announcement announcement) {
        try {
            return ResponseEntity.ok(ApiResponse.success(adminService.updateAnnouncement(id, announcement)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/announcements/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteAnnouncement(@PathVariable Long id) {
        adminService.deleteAnnouncement(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Announcement deleted"));
    }

    // ---- Document Requests ----

    @GetMapping("/document-requests")
    public ResponseEntity<ApiResponse<List<DocumentRequest>>> getAllDocumentRequests() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getAllDocumentRequests()));
    }

    @GetMapping("/document-requests/pending")
    public ResponseEntity<ApiResponse<List<DocumentRequest>>> getPendingDocumentRequests() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getPendingDocumentRequests()));
    }

    @PutMapping("/document-requests/{id}/approve")
    public ResponseEntity<ApiResponse<DocumentRequest>> approveDocumentRequest(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(adminService.approveDocumentRequest(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
