package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.dto.RegisterRequest;
import com.interfaceinnovators.sms_backend.dto.UserDto;
import com.interfaceinnovators.sms_backend.model.Parent;
import com.interfaceinnovators.sms_backend.model.User;
import com.interfaceinnovators.sms_backend.repository.ParentRepository;
import com.interfaceinnovators.sms_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SuperAdminService {

    private final UserRepository userRepository;
    private final ParentRepository parentRepository;

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<User> getUsersByRole(User.Role role) {
        return userRepository.findByRole(role);
    }

    @Transactional
    public UserDto createUser(RegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email already in use: " + request.getEmail());
        }
        if (request.getRole() == User.Role.SUPER_ADMIN) {
            throw new RuntimeException("Cannot create additional Super Admin accounts.");
        }

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .passwordHash(request.getPassword() != null ? request.getPassword() : "Password@123")
                .phoneNumber(request.getPhoneNumber())
                .role(request.getRole() != null ? request.getRole() : User.Role.PARENT)
                .active(true)
                .build();
        user = userRepository.save(user);

        Parent parent = null;
        if (user.getRole() == User.Role.PARENT) {
            parent = Parent.builder()
                    .user(user)
                    .fullName(request.getFullName())
                    .email(request.getEmail())
                    .phoneNumber(request.getPhoneNumber())
                    .address(request.getAddress())
                    .build();
            parent = parentRepository.save(parent);
        }

        return toDto(user, parent);
    }

    @Transactional
    public User updateUser(Long id, User updated) {
        User existing = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        if (existing.getRole() == User.Role.SUPER_ADMIN) {
            throw new RuntimeException("Super Admin account cannot be modified here.");
        }
        existing.setFullName(updated.getFullName());
        existing.setEmail(updated.getEmail());
        existing.setPhoneNumber(updated.getPhoneNumber());
        if (updated.getRole() != null && updated.getRole() != User.Role.SUPER_ADMIN) {
            existing.setRole(updated.getRole());
        }
        if (updated.getActive() != null) {
            existing.setActive(updated.getActive());
        }
        return userRepository.save(existing);
    }

    @Transactional
    public void deactivateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        if (user.getRole() == User.Role.SUPER_ADMIN) {
            throw new RuntimeException("Super Admin account cannot be deactivated.");
        }
        user.setActive(false);
        userRepository.save(user);
    }

    @Transactional
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        if (user.getRole() == User.Role.SUPER_ADMIN) {
            throw new RuntimeException("Super Admin account cannot be deleted.");
        }
        userRepository.deleteById(id);
    }

    private UserDto toDto(User user, Parent parent) {
        return UserDto.builder()
                .uid(String.valueOf(user.getId()))
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phoneNumber(user.getPhoneNumber())
                .role(user.getRole())
                .parentId(parent != null ? String.valueOf(parent.getId()) : null)
                .build();
    }
}
