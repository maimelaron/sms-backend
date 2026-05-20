package com.interfaceinnovators.sms_backend.dto;

import com.interfaceinnovators.sms_backend.model.User;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {
    private String uid;
    private String email;
    private String fullName;
    private String phoneNumber;
    private User.Role role;
    private String parentId;
}
