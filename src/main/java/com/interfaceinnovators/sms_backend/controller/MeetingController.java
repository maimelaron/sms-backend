package com.interfaceinnovators.sms_backend.controller;

import com.interfaceinnovators.sms_backend.dto.ApiResponse;
import com.interfaceinnovators.sms_backend.model.Meeting;
import com.interfaceinnovators.sms_backend.service.MeetingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/meetings")
@RequiredArgsConstructor
public class MeetingController {

    private final MeetingService meetingService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Meeting>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(meetingService.findAll()));
    }

    @GetMapping("/pending")
    public ResponseEntity<ApiResponse<List<Meeting>>> getPending() {
        return ResponseEntity.ok(ApiResponse.success(
                meetingService.findByStatus(Meeting.MeetingStatus.PENDING)));
    }

    @GetMapping("/approved")
    public ResponseEntity<ApiResponse<List<Meeting>>> getApproved() {
        return ResponseEntity.ok(ApiResponse.success(
                meetingService.findByStatus(Meeting.MeetingStatus.APPROVED)));
    }

    @GetMapping("/rejected")
    public ResponseEntity<ApiResponse<List<Meeting>>> getRejected() {
        return ResponseEntity.ok(ApiResponse.success(
                meetingService.findByStatus(Meeting.MeetingStatus.REJECTED)));
    }

    @GetMapping("/parent/{parentId}")
    public ResponseEntity<ApiResponse<List<Meeting>>> getByParent(@PathVariable Long parentId) {
        return ResponseEntity.ok(ApiResponse.success(meetingService.findByParent(parentId)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Meeting>> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(meetingService.findById(id)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Meeting>> create(@RequestBody Meeting meeting) {
        try {
            return ResponseEntity.ok(ApiResponse.success(meetingService.save(meeting), "Meeting created"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/request-one-on-one")
    public ResponseEntity<ApiResponse<Meeting>> requestOneOnOne(@RequestBody Meeting meeting) {
        try {
            meeting.setType(Meeting.MeetingType.ONE_ON_ONE);
            meeting.setStatus(Meeting.MeetingStatus.PENDING);
            return ResponseEntity.ok(ApiResponse.success(meetingService.save(meeting), "Meeting request submitted"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Meeting>> update(@PathVariable Long id, @RequestBody Meeting meeting) {
        try {
            return ResponseEntity.ok(ApiResponse.success(meetingService.update(id, meeting)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<Meeting>> approve(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(meetingService.approve(id), "Meeting approved"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Meeting>> reject(
            @PathVariable Long id, @RequestBody Map<String, String> body) {
        try {
            String reason = body.getOrDefault("reason", "Meeting request declined.");
            return ResponseEntity.ok(ApiResponse.success(meetingService.reject(id, reason), "Meeting rejected"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        meetingService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Meeting deleted"));
    }
}
