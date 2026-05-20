package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Document;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DocumentRepository extends JpaRepository<Document, Long> {
    List<Document> findByStudentId(Long studentId);
    List<Document> findByParentId(Long parentId);
    List<Document> findByDocumentType(String documentType);
    List<Document> findByVerifiedFalse();
}
