package com.interfaceinnovators.sms_backend.repository;

import com.interfaceinnovators.sms_backend.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TripRepository extends JpaRepository<Trip, Long> {
    List<Trip> findByActiveTrue();
    List<Trip> findByActiveFalse();
}
