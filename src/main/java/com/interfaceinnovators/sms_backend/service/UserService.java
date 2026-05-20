package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.model.User;
import com.interfaceinnovators.sms_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    @Transactional
    public User save(User user) {
        return userRepository.save(user);
    }

    @Transactional
    public User update(Long id, User updated) {
        User existing = findById(id);
        existing.setFullName(updated.getFullName());
        existing.setEmail(updated.getEmail());
        existing.setPhoneNumber(updated.getPhoneNumber());
        existing.setRole(updated.getRole());
        return userRepository.save(existing);
    }

    @Transactional
    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<User> findByRole(User.Role role) {
        return userRepository.findByRole(role);
    }
}
