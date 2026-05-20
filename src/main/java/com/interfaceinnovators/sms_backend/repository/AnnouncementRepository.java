package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Announcement;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {
}
