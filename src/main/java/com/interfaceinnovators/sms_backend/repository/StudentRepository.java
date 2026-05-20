package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StudentRepository extends JpaRepository<Student, Long> {
    List<Student> findByParentId(Long parentId);
    List<Student> findByStatus(Student.StudentStatus status);
}
