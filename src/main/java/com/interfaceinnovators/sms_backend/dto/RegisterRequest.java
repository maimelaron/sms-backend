package com.interfaceinnovators.sms_backend.dto;

import com.interfaceinnovators.sms_backend.model.User;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegisterRequest {
    private String email;
    private String password;
    private String fullName;
    private String phoneNumber;
    private String address;
    @Builder.Default
    private User.Role role = User.Role.PARENT;
}
