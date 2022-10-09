package com.devstories.authservice.service;

import com.devstories.authservice.dto.JwtResponse;
import com.devstories.authservice.dto.LoginRequest;
import com.devstories.authservice.dto.RegisterRequest;
import com.devstories.authservice.dto.UserDto;

public interface AuthService {

    JwtResponse login(LoginRequest loginRequest);

    UserDto register(RegisterRequest registerRequest);
}
