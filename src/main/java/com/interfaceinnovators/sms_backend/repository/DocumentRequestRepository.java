package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.DocumentRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DocumentRequestRepository extends JpaRepository<DocumentRequest, Long> {
    List<DocumentRequest> findByStatus(DocumentRequest.DocumentRequestStatus status);
    List<DocumentRequest> findByParentId(Long parentId);
}
