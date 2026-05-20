package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Meeting;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MeetingRepository extends JpaRepository<Meeting, Long> {
    List<Meeting> findByStatus(Meeting.MeetingStatus status);
    List<Meeting> findByParentId(Long parentId);
    List<Meeting> findByTeacherId(String teacherId);
}
