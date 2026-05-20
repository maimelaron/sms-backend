package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Parent;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.repository.ParentRepository;
import com.interfaceinnovators.sms_backend.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ParentService {

    private final ParentRepository parentRepository;
    private final StudentRepository studentRepository;

    @Transactional(readOnly = true)
    public List<Parent> findAll() {
        return parentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Parent findById(Long id) {
        return parentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Parent not found with id: " + id));
    }

    @Transactional
    public Parent update(Long id, Parent updated) {
        Parent existing = findById(id);
        existing.setFullName(updated.getFullName());
        existing.setEmail(updated.getEmail());
        existing.setPhoneNumber(updated.getPhoneNumber());
        existing.setAddress(updated.getAddress());
        return parentRepository.save(existing);
    }

    @Transactional
    public void delete(Long id) {
        parentRepository.deleteById(id);
    }

    @Transactional
    public Student addChild(Long parentId, Student child) {
        findById(parentId); // verify parent exists
        child.setParentId(parentId);
        child.setStatus(Student.StudentStatus.PENDING);
        if (child.getCreatedAt() == null) child.setCreatedAt(java.time.LocalDateTime.now());
        return studentRepository.save(child);
    }

    @Transactional(readOnly = true)
    public List<Student> getChildren(Long parentId) {
        findById(parentId); // verify parent exists
        return studentRepository.findByParentId(parentId);
    }

    @Transactional
    public Student updateChild(Long parentId, Long studentId, Student updated) {
        Student existing = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with id: " + studentId));
        existing.setName(updated.getName());
        existing.setSurname(updated.getSurname());
        existing.setGender(updated.getGender());
        existing.setDateOfBirth(updated.getDateOfBirth());
        existing.setNationality(updated.getNationality());
        existing.setGrade(updated.getGrade());
        existing.setYearOfAdmission(updated.getYearOfAdmission());
        existing.setPreviousSchool(updated.getPreviousSchool());
        existing.setLatestSchoolReport(updated.getLatestSchoolReport());
        return studentRepository.save(existing);
    }
}
