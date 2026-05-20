package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.Payment;
import com.interfaceinnovators.sms_backend.model.Student;
import com.interfaceinnovators.sms_backend.model.Trip;
import com.interfaceinnovators.sms_backend.model.TripRegistration;
import com.interfaceinnovators.sms_backend.repository.PaymentRepository;
import com.interfaceinnovators.sms_backend.repository.StudentRepository;
import com.interfaceinnovators.sms_backend.repository.TripRegistrationRepository;
import com.interfaceinnovators.sms_backend.repository.TripRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TripService {

    private final TripRepository tripRepository;
    private final TripRegistrationRepository registrationRepository;
    private final PaymentRepository paymentRepository;
    private final StudentRepository studentRepository;

    @Transactional(readOnly = true)
    public List<Trip> findAll() {
        List<Trip> trips = tripRepository.findAll();
        trips.forEach(this::populateRegisteredStudents);
        return trips;
    }

    @Transactional(readOnly = true)
    public Trip findById(Long id) {
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + id));
        populateRegisteredStudents(trip);
        return trip;
    }

    @Transactional
    public Trip save(Trip trip) {
        if (trip.getCreatedAt() == null) trip.setCreatedAt(java.time.LocalDateTime.now());
        if (trip.getActive() == null) trip.setActive(true);
        return tripRepository.save(trip);
    }

    @Transactional
    public Trip update(Long id, Trip updated) {
        Trip existing = tripRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + id));
        existing.setTitle(updated.getTitle());
        existing.setDescription(updated.getDescription());
        existing.setDestination(updated.getDestination());
        existing.setPrice(updated.getPrice());
        existing.setTripDate(updated.getTripDate());
        existing.setEligibleGrades(updated.getEligibleGrades());
        existing.setActive(updated.getActive());
        if (updated.getImageUrl() != null) existing.setImageUrl(updated.getImageUrl());
        return tripRepository.save(existing);
    }

    @Transactional
    public Trip hold(Long id) {
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + id));
        trip.setActive(false);
        return tripRepository.save(trip);
    }

    @Transactional
    public Trip activate(Long id) {
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + id));
        trip.setActive(true);
        return tripRepository.save(trip);
    }

    @Transactional
    public Trip updateImage(Long id, String imageData) {
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + id));
        trip.setImageUrl(imageData);
        return tripRepository.save(trip);
    }

    @Transactional
    public void delete(Long id) {
        tripRepository.deleteById(id);
    }

    @Transactional
    public TripRegistration register(Long tripId, Long studentId, Long parentId, String paymentMethod) {
        Trip trip = tripRepository.findById(tripId)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + tripId));

        // Create payment record
        Payment payment = Payment.builder()
                .studentId(studentId)
                .parentId(parentId)
                .tripId(tripId)
                .amount(trip.getPrice())
                .method(paymentMethod != null ? paymentMethod : "Mock Payment")
                .status(Payment.PaymentStatus.COMPLETED)
                .transactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .build();
        payment = paymentRepository.save(payment);

        // Create registration
        TripRegistration registration = TripRegistration.builder()
                .tripId(tripId)
                .studentId(studentId)
                .paymentId(payment.getId())
                .status(TripRegistration.RegistrationStatus.REGISTERED)
                .build();
        return registrationRepository.save(registration);
    }

    @Transactional
    public void unregister(Long tripId, Long studentId) {
        registrationRepository.findByTripIdAndStudentId(tripId, studentId)
                .ifPresent(reg -> {
                    reg.setStatus(TripRegistration.RegistrationStatus.CANCELLED);
                    registrationRepository.save(reg);
                });
    }

    @Transactional(readOnly = true)
    public Map<String, List<Student>> getPaidStudentsByGrade(Long tripId) {
        List<TripRegistration> registrations = registrationRepository
                .findByTripIdAndStatus(tripId, TripRegistration.RegistrationStatus.REGISTERED);

        Map<String, List<Student>> result = new LinkedHashMap<>();
        for (TripRegistration reg : registrations) {
            studentRepository.findById(reg.getStudentId()).ifPresent(student -> {
                String grade = student.getGrade() != null ? student.getGrade() : "Unknown";
                result.computeIfAbsent(grade, k -> new ArrayList<>()).add(student);
            });
        }
        // Sort by grade key
        return result.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));
    }

    private void populateRegisteredStudents(Trip trip) {
        if (trip.getId() == null) {
            trip.setRegisteredStudents(new ArrayList<>());
            return;
        }
        List<TripRegistration> regs = registrationRepository
                .findByTripIdAndStatus(trip.getId(), TripRegistration.RegistrationStatus.REGISTERED);
        List<String> studentIds = regs.stream()
                .map(r -> String.valueOf(r.getStudentId()))
                .collect(Collectors.toList());
        trip.setRegisteredStudents(studentIds);
    }
}
