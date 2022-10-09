package com.devstories.authservice.dto;

import com.devstories.authservice.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {

    private String username;

    public static UserDto of(User user) {
        return UserDto.builder().username(user.getUsername()).build();
    }
}
