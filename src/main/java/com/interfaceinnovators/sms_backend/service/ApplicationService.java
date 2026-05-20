package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Application;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

/**
 * Stub — Application enrollment is handled via ParentService.addChild / StudentService.
 */
@Service
public class ApplicationService {

    public List<Application> findAll() {
        return Collections.emptyList();
    }

    public Application findById(Long id) {
        throw new RuntimeException("Applications are managed through student enrollment.");
    }

    public Application save(Application application) {
        throw new RuntimeException("Applications are managed through student enrollment.");
    }

    public void delete(Long id) {
        throw new RuntimeException("Applications are managed through student enrollment.");
    }
}
