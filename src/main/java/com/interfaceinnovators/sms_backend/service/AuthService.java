package com.interfaceinnovators.sms_backend.service;

import com.interfaceinnovators.sms_backend.dto.LoginRequest;
import com.interfaceinnovators.sms_backend.dto.RegisterRequest;
import com.interfaceinnovators.sms_backend.dto.UserDto;
import com.interfaceinnovators.sms_backend.model.Parent;
import com.interfaceinnovators.sms_backend.model.User;
import com.interfaceinnovators.sms_backend.repository.ParentRepository;
import com.interfaceinnovators.sms_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ParentRepository parentRepository;

    @Transactional
    public UserDto register(RegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email already in use: " + request.getEmail());
        }

        // Public registration is restricted to PARENT only
        User.Role role = request.getRole();
        if (role != null && role != User.Role.PARENT) {
            throw new RuntimeException("Public registration is only available for parents. Contact the school administrator to create other account types.");
        }

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .passwordHash(request.getPassword())
                .phoneNumber(request.getPhoneNumber())
                .role(User.Role.PARENT)
                .active(true)
                .build();
        user = userRepository.save(user);

        // Create Parent profile for PARENT role
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

    @Transactional(readOnly = true)
    public UserDto login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));

        if (!request.getPassword().equals(user.getPasswordHash())) {
            throw new RuntimeException("Invalid email or password");
        }

        Parent parent = null;
        if (user.getRole() == User.Role.PARENT) {
            parent = parentRepository.findByUserId(user.getId()).orElse(null);
        }

        return toDto(user, parent);
    }

    @Transactional(readOnly = true)
    public UserDto getUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        Parent parent = null;
        if (user.getRole() == User.Role.PARENT) {
            parent = parentRepository.findByUserId(user.getId()).orElse(null);
        }
        return toDto(user, parent);
    }

    @Transactional
    public void resetPassword(String uid, String newPassword) {
        Long userId = Long.parseLong(uid);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setPasswordHash(newPassword);
        userRepository.save(user);
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
