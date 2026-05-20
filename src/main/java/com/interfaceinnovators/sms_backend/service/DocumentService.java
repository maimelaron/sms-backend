package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Document;
import com.interfaceinnovators.sms_backend.model.DocumentRequest;
import com.interfaceinnovators.sms_backend.repository.DocumentRepository;
import com.interfaceinnovators.sms_backend.repository.DocumentRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DocumentService {

    private final DocumentRepository documentRepository;
    private final DocumentRequestRepository documentRequestRepository;

    @Transactional(readOnly = true)
    public List<Document> findAll() {
        return documentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Document findById(Long id) {
        return documentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Document not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public List<Document> findByStudentId(Long studentId) {
        return documentRepository.findByStudentId(studentId);
    }

    @Transactional(readOnly = true)
    public List<Document> findByParentId(Long parentId) {
        return documentRepository.findByParentId(parentId);
    }

    @Transactional(readOnly = true)
    public List<Document> findByType(String documentType) {
        return documentRepository.findByDocumentType(documentType);
    }

    @Transactional(readOnly = true)
    public List<Document> findUnverified() {
        return documentRepository.findByVerifiedFalse();
    }

    @Transactional
    public Document upload(Document document) {
        if (document.getUploadedAt() == null) {
            document.setUploadedAt(java.time.LocalDateTime.now());
        }
        if (document.getVerified() == null) {
            document.setVerified(false);
        }
        return documentRepository.save(document);
    }

    @Transactional
    public Document update(Long id, Document updated) {
        Document existing = findById(id);
        existing.setFileName(updated.getFileName());
        existing.setDocumentType(updated.getDocumentType());
        existing.setDescription(updated.getDescription());
        if (updated.getFileUrl() != null) existing.setFileUrl(updated.getFileUrl());
        return documentRepository.save(existing);
    }

    @Transactional
    public Document verify(Long id, String verifiedBy) {
        Document existing = findById(id);
        existing.setVerified(true);
        existing.setVerifiedBy(verifiedBy);
        existing.setVerifiedAt(LocalDateTime.now());
        return documentRepository.save(existing);
    }

    @Transactional
    public void delete(Long id) {
        documentRepository.deleteById(id);
    }

    // Document Requests
    @Transactional
    public DocumentRequest requestDocument(Long parentId, DocumentRequest request) {
        request.setParentId(parentId);
        request.setStatus(DocumentRequest.DocumentRequestStatus.PENDING);
        return documentRequestRepository.save(request);
    }
}
