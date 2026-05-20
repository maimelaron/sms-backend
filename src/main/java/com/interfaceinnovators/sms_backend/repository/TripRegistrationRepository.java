package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.TripRegistration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TripRegistrationRepository extends JpaRepository<TripRegistration, Long> {
    List<TripRegistration> findByTripId(Long tripId);
    List<TripRegistration> findByStudentId(Long studentId);
    Optional<TripRegistration> findByTripIdAndStudentId(Long tripId, Long studentId);
    List<TripRegistration> findByTripIdAndStatus(Long tripId, TripRegistration.RegistrationStatus status);
}
