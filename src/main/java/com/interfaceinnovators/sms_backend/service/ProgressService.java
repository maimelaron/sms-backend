package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.ProgressRecord;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

/**
 * Stub — Progress records are not part of the current API contract.
 */
@Service
public class ProgressService {

    public List<ProgressRecord> findAll() {
        return Collections.emptyList();
    }

    public ProgressRecord findById(Long id) {
        throw new RuntimeException("Progress records are not yet implemented.");
    }

    public List<ProgressRecord> findByStudent(Long studentId) {
        return Collections.emptyList();
    }

    public ProgressRecord save(ProgressRecord record) {
        throw new RuntimeException("Progress records are not yet implemented.");
    }

    public void delete(Long id) {
        throw new RuntimeException("Progress records are not yet implemented.");
    }
}
