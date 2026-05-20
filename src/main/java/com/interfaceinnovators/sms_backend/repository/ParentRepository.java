package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ParentRepository extends JpaRepository<Parent, Long> {

    @Query("SELECT p FROM Parent p WHERE p.user.id = :userId")
    Optional<Parent> findByUserId(@Param("userId") Long userId);

    Optional<Parent> findByEmail(String email);
}
