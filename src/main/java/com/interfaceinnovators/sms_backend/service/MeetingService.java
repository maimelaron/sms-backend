package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Meeting;
import com.interfaceinnovators.sms_backend.repository.MeetingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MeetingService {

    private final MeetingRepository meetingRepository;

    @Transactional(readOnly = true)
    public List<Meeting> findAll() {
        return meetingRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Meeting findById(Long id) {
        return meetingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Meeting not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public List<Meeting> findByStatus(Meeting.MeetingStatus status) {
        return meetingRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Meeting> findByParent(Long parentId) {
        return meetingRepository.findByParentId(parentId);
    }

    @Transactional
    public Meeting save(Meeting meeting) {
        if (meeting.getStatus() == null) meeting.setStatus(Meeting.MeetingStatus.PENDING);
        if (meeting.getType() == null) meeting.setType(Meeting.MeetingType.GROUP_MEETING);
        if (meeting.getCreatedAt() == null) meeting.setCreatedAt(java.time.LocalDateTime.now());
        return meetingRepository.save(meeting);
    }

    @Transactional
    public Meeting update(Long id, Meeting updated) {
        Meeting existing = findById(id);
        existing.setTitle(updated.getTitle());
        existing.setDescription(updated.getDescription());
        existing.setScheduledTime(updated.getScheduledTime());
        existing.setTeacherId(updated.getTeacherId());
        existing.setTeacherName(updated.getTeacherName());
        if (updated.getType() != null) existing.setType(updated.getType());
        if (updated.getStatus() != null) existing.setStatus(updated.getStatus());
        if (updated.getParentId() != null) existing.setParentId(updated.getParentId());
        if (updated.getParentName() != null) existing.setParentName(updated.getParentName());
        return meetingRepository.save(existing);
    }

    @Transactional
    public Meeting approve(Long id) {
        Meeting meeting = findById(id);
        meeting.setStatus(Meeting.MeetingStatus.APPROVED);
        meeting.setRejectionReason(null);
        return meetingRepository.save(meeting);
    }

    @Transactional
    public Meeting reject(Long id, String reason) {
        Meeting meeting = findById(id);
        meeting.setStatus(Meeting.MeetingStatus.REJECTED);
        meeting.setRejectionReason(reason);
        return meetingRepository.save(meeting);
    }

    @Transactional
    public void delete(Long id) {
        meetingRepository.deleteById(id);
    }
}
