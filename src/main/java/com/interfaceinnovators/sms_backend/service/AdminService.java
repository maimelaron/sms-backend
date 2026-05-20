package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Announcement;
import com.interfaceinnovators.sms_backend.model.DocumentRequest;
import com.interfaceinnovators.sms_backend.repository.AnnouncementRepository;
import com.interfaceinnovators.sms_backend.repository.DocumentRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AnnouncementRepository announcementRepository;
    private final DocumentRequestRepository documentRequestRepository;

    // ---- Announcements ----

    @Transactional(readOnly = true)
    public List<Announcement> getAllAnnouncements() {
        return announcementRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Announcement getAnnouncementById(Long id) {
        return announcementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Announcement not found with id: " + id));
    }

    @Transactional
    public Announcement createAnnouncement(Announcement announcement) {
        return announcementRepository.save(announcement);
    }

    @Transactional
    public Announcement updateAnnouncement(Long id, Announcement updated) {
        Announcement existing = getAnnouncementById(id);
        existing.setTitle(updated.getTitle());
        existing.setContent(updated.getContent());
        existing.setType(updated.getType());
        return announcementRepository.save(existing);
    }

    @Transactional
    public void deleteAnnouncement(Long id) {
        announcementRepository.deleteById(id);
    }

    // ---- Document Requests ----

    @Transactional(readOnly = true)
    public List<DocumentRequest> getAllDocumentRequests() {
        return documentRequestRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<DocumentRequest> getPendingDocumentRequests() {
        return documentRequestRepository.findByStatus(DocumentRequest.DocumentRequestStatus.PENDING);
    }

    @Transactional
    public DocumentRequest approveDocumentRequest(Long id) {
        DocumentRequest req = documentRequestRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Document request not found with id: " + id));
        req.setStatus(DocumentRequest.DocumentRequestStatus.APPROVED);
        return documentRequestRepository.save(req);
    }
}
