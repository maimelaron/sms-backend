package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StudentService {

    private final StudentRepository studentRepository;

    @Transactional(readOnly = true)
    public List<Student> findAll() {
        return studentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Student findById(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public List<Student> findByStatus(Student.StudentStatus status) {
        return studentRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Student> findByParent(Long parentId) {
        return studentRepository.findByParentId(parentId);
    }

    @Transactional
    public Student save(Student student) {
        if (student.getStatus() == null) student.setStatus(Student.StudentStatus.PENDING);
        if (student.getCreatedAt() == null) student.setCreatedAt(java.time.LocalDateTime.now());
        return studentRepository.save(student);
    }

    @Transactional
    public Student update(Long id, Student updated) {
        Student existing = findById(id);
        existing.setName(updated.getName());
        existing.setSurname(updated.getSurname());
        existing.setGender(updated.getGender());
        existing.setDateOfBirth(updated.getDateOfBirth());
        existing.setNationality(updated.getNationality());
        existing.setGrade(updated.getGrade());
        existing.setYearOfAdmission(updated.getYearOfAdmission());
        existing.setPreviousSchool(updated.getPreviousSchool());
        existing.setLatestSchoolReport(updated.getLatestSchoolReport());
        existing.setClassName(updated.getClassName());
        existing.setTeacher(updated.getTeacher());
        return studentRepository.save(existing);
    }

    @Transactional
    public Student approve(Long id) {
        Student student = findById(id);
        student.setStatus(Student.StudentStatus.APPROVED);
        student.setRejectionReason(null);
        return studentRepository.save(student);
    }

    @Transactional
    public Student approveWithClass(Long id, Map<String, String> classData) {
        Student student = findById(id);
        student.setStatus(Student.StudentStatus.APPROVED);
        student.setRejectionReason(null);
        if (classData.containsKey("className")) student.setClassName(classData.get("className"));
        if (classData.containsKey("teacher")) student.setTeacher(classData.get("teacher"));
        return studentRepository.save(student);
    }

    @Transactional
    public Student reject(Long id, String reason) {
        Student student = findById(id);
        student.setStatus(Student.StudentStatus.REJECTED);
        student.setRejectionReason(reason);
        return studentRepository.save(student);
    }

    @Transactional
    public void delete(Long id) {
        studentRepository.deleteById(id);
    }
}
